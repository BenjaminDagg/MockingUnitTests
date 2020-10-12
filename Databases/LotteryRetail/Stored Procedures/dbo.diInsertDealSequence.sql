SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertDealSequence

Created By:     Chris Coddington

Create Date:    09/09/2003

Description:    Inserts a row into the DEAL_SEQUENCE table.
                Called by the Deal Import application.

Returns:          0 = No errors.
                400 = Deal Number already exists in the DEAL_SEQUENCE table.
                401 = Form doesn't exist.
                402 = @COINS_BET parameter does not match COINS_BET field in CASINO_FORMS.
                403 = @LINES_BET parameter does not match LINES_BET field in CASINO_FORMS.
                404 = @DENOMINATION parameter does not match DENOMINATION field in CASINO_FORMS.
                405 = Invalid Deal Sequence entries in DEAL_SEQUENCE table.
                
                The above listed descriptions can be found in the Error_Lookup table.

Parameters:
   @Form_Numb     VarChar(10) Form Number of the Deal
   @Deal_No       Int         Deal Number being added
   @Denomination  Int         Denomination of the Deal
   @Coins_Bet     SmallInt    Coins Bet (for paper games it is max coins)
   @Lines_Bet     TinyInt     Number of Lines Bet
   @Tabs_Per_Deal Int         Number of Tabs per Deal

Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
Terry W.      11-03-2003 Dropped unused @GameCode argument.

Terry W.      11-04-2003 Line 70: Pull DENOMINATION instead of TAB_AMT from
                         CASINO_FORMS to validate the denomination

Terry W.      11-04-2003 Check to see if Deal already exists in DEAL_SEQUENCE.

Chris C.      12-22-2003 Modified to use GAME_TYPE_CODE instead of FORM_NUMB to
                         accommodate the use of multiple Form numbers by a
                         single machine.

Terry W.      03-25-2004 Modified to insert a Paper Deal.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[diInsertDealSequence]
   @Form_Numb        VarChar(10),
   @Deal_No          Int,
   @Denomination     Int,
   @Coins_Bet        SmallInt,
   @Lines_Bet        TinyInt,
   @Tabs_Per_Deal    Int

AS

-- Declare Variables
DECLARE @CoinsBet             Int
DECLARE @Count                Int
DECLARE @CurrentDealFlag      Int
DECLARE @DealNumber           Int
DECLARE @DealSequenceID       Int
DECLARE @Denom                SmallMoney
DECLARE @ErrorID              Int
DECLARE @FormIsPaper          Bit
DECLARE @GameTypeCode         VarChar(2)
DECLARE @LastDealSequenceID   Int
DECLARE @LinesBet             Int

-- Initialize Variables
SET @CoinsBet           = 0
SET @Count              = 0
SET @CurrentDealFlag    = 0
SET @DealNumber         = 0
SET @DealSequenceID     = 0
SET @Denom              = 0
SET @ErrorID            = 0
SET @FormIsPaper        = 0
SET @GameTypeCode       = ''
SET @LastDealSequenceID = 0
SET @LinesBet           = 0

-- Turn off row counting.
SET NOCOUNT ON

-- Does the Deal Number already exist?
SELECT @Count = COUNT(*) FROM DEAL_SEQUENCE WHERE DEAL_NO = @Deal_No
IF @Count > 0 SET @ErrorID = 400

IF @ErrorID = 0
   BEGIN
      -- Validate the data passed in against the form.
      SELECT
         @CoinsBet      = COINS_BET, 
         @LinesBet      = LINES_BET,
         @Denom         = DENOMINATION,
         @GameTypeCode  = GAME_TYPE_CODE,
         @FormIsPaper   = IS_PAPER
      FROM CASINO_FORMS WHERE FORM_NUMB = @Form_Numb
      
      IF @@ROWCOUNT = 0
         SET @ErrorID = 401
      ELSE IF @CoinsBet <> @Coins_Bet
         SET @ErrorID = 402
      ELSE IF @LinesBet <> @Lines_Bet
         SET @ErrorID = 403
      ELSE IF (@Denom * 100) <> @Denomination
         SET @ErrorID = 404
      -- End validation.
   END

IF @ErrorID = 0
   BEGIN
      -- Is the Form for Paper games?
      IF (@FormIsPaper = 1)
         -- Yes so we can perform a simple insertion. Note that the Current Deal Flag
         -- is turned off.  It will be turned on by tpTransT when a paper tab is read.
         BEGIN
            INSERT INTO DEAL_SEQUENCE
               (FORM_NUMB, DEAL_NO, DENOMINATION, COINS_BET, LINES_BET, 
                DATE_ADDED, CURRENT_DEAL_FLAG, NEXT_TICKET, LAST_TICKET, NEXT_DEAL)
            VALUES
               (@Form_Numb, @Deal_No, @Denomination, @Coins_Bet, @Lines_Bet, 
                GetDate(), 0, 0, @Tabs_Per_Deal, 0)
         END
      ELSE
         -- Not a Paper Deal so we need to handle the CURRENT_DEAL and NEXT_DEAL values.
         BEGIN
            -- Start a transaction
            BEGIN TRANSACTION
            
            -- Is there an active deal?
            SELECT @DealSequenceID = ds.DEAL_SEQUENCE_ID, @DealNumber = ds.DEAL_NO
            FROM DEAL_SEQUENCE ds
               INNER JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
            WHERE
               cf.GAME_TYPE_CODE    = @GameTypeCode AND
               ds.DENOMINATION      = @Denomination AND
               ds.COINS_BET         = @Coins_Bet    AND
               ds.LINES_BET         = @Lines_Bet    AND
               ds.CURRENT_DEAL_FLAG = 1
            
            IF @@ROWCOUNT = 0
               -- No active deal being played.
               SET @CurrentDealFlag = 1
            ELSE
               -- There is an active deal being played.
               SET @CurrentDealFlag = 0
            
            -- Insert the deal into the deal sequence table.
            INSERT INTO DEAL_SEQUENCE
               (FORM_NUMB, DEAL_NO, DENOMINATION, COINS_BET, LINES_BET, 
                DATE_ADDED, CURRENT_DEAL_FLAG, NEXT_TICKET, LAST_TICKET, NEXT_DEAL)
            VALUES
               (@Form_Numb, @Deal_No, @Denomination, @Coins_Bet, @Lines_Bet, 
                GETDATE(), @CurrentDealFlag, 1, @Tabs_Per_Deal, 0)
            
            -- Get the last identity insert
            SET @DealSequenceID = @@IDENTITY
            
            -- Retrieve row to be updated (if any) that will point to the newly inserted row.
            SELECT @LastDealSequenceID = ds.DEAL_SEQUENCE_ID
            FROM DEAL_SEQUENCE ds
               INNER JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
            WHERE
               cf.GAME_TYPE_CODE    = @GameTypeCode   AND
               ds.DENOMINATION      = @Denomination   AND
               ds.COINS_BET         = @Coins_Bet      AND
               ds.LINES_BET         = @Lines_Bet      AND
               ds.NEXT_DEAL         = 0               AND      
               ds.DEAL_SEQUENCE_ID  <> @DealSequenceID
            
            SET @Count = @@ROWCOUNT
            IF @Count = 1
               BEGIN
                  -- Update the last deal in play to point to the newly inserted deal.
                  UPDATE DEAL_SEQUENCE
                  SET   NEXT_DEAL         = @DealSequenceID
                  WHERE DEAL_SEQUENCE_ID  = @LastDealSequenceID
               END
            
            ELSE IF @Count > 1
               SET @ErrorID = 405
         
            -- If no errors, commit transaction, otherwise, roll it back...
            IF @ErrorID = 0
               COMMIT TRANSACTION
            ELSE
               ROLLBACK TRANSACTION
         END
   END
RETURN @ErrorID
GO
