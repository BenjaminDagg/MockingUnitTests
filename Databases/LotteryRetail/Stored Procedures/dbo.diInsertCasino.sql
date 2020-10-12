SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertCasino

Created By:     Chris Coddington

Create Date:    09-09-2003

Description:    Inserts a row into the Casino table.

Returns:        0 = Successful row insertion
                1 = Successful row update
                n = TSQL Error Code

Parameters:
   @CasinoID               Casino Identifier
   @CasinoName             Casino Name
   @LockupAmt              Lockup Amount
   @FromTime               Casino offset starting time
   @ToTime                 Casino offset ending time
   @ClaimTimeout           Time in seconds for user to claim prize
   @DaubTimeout            Time in seconds for user to daub in bingo games
   @BingoFreeSquare        Flags if Bingo cards have free center squares
   @CardType               Card Type (SmartCard, MagStripe)
   @PlayerCard             Flags if Play require player card
   @ReceiptPrinter         
   @DisplayProgressive     Flags if Progressive amounts are displayed at EGMs
   @TpiID                  Third Party Interface identifier
   @ReprintTicket          Flags if Ticket Reprint button is displayed at EGMs
   @SummarizePlay          Flags if play is summarized in MACHINE_PLAY_STATS
                           for Hold by Denom report

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 10-16-2006     v5.0.8
  Removed argument @RedeemablePulltab (matching column removed).
  Added arguments @TpiID, @ReprintTicket, and @SummarizePlay

Terry Watkins 06-06-2007     v6.0.1
  Added @DaubTimeout and @BingoFreeSquare to update new columns in the Casino
  table that were added to support Bingo.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[diInsertCasino]
   @CasinoID               Char(6),
   @CasinoName             VarChar(48),
   @LockupAmt              SmallMoney,
   @FromTime               DateTime,
   @ToTime                 DateTime,
   @ClaimTimeout           SmallInt,
   @DaubTimeout            SmallInt,
   @BingoFreeSquare        Bit,
   @CardType               TinyInt,
   @PlayerCard             TinyInt,
   @ReceiptPrinter         Bit,
   @DisplayProgressive     Bit,
   @TpiID                  Int = 0,
   @ReprintTicket          Bit = 1,
   @SummarizePlay          Bit = 0
AS

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

-- Start a transaction
BEGIN TRANSACTION

-- No casinos should be marked as default as we are going to set it below.
UPDATE CASINO SET SETASDEFAULT = 0 WHERE SETASDEFAULT = 1

SET @ReturnValue = @@ERROR

IF @ReturnValue = 0
   BEGIN
      -- Test to see if the Casino record already exists.
      IF EXISTS (SELECT * FROM CASINO WHERE Cas_ID = @CasinoID)
         BEGIN
            -- Record already exists, so update it.
            UPDATE CASINO SET
               CAS_ID              = @CasinoID,
               CAS_NAME            = @CasinoName,
               SETASDEFAULT        = 1,
               LOCKUP_AMT          = @LockupAmt,
               FROM_TIME           = @FromTime,
               TO_TIME             = @ToTime,
               CLAIM_TIMEOUT       = @ClaimTimeout,
               DAUB_TIMEOUT        = @DaubTimeout,
               BINGO_FREE_SQUARE   = @BingoFreeSquare,
               CARD_TYPE           = @CardType,
               PLAYER_CARD         = @PlayerCard,
               TPI_ID              = @TpiID,
               REPRINT_TICKET      = @ReprintTicket,
               SUMMARIZE_PLAY      = @SummarizePlay,
               RECEIPT_PRINTER     = @ReceiptPrinter,
               DISPLAY_PROGRESSIVE = @DisplayProgressive
            WHERE CAS_ID = @CasinoID
            
            SET @ReturnValue = @@ERROR
            IF @ReturnValue = 0 SET @ReturnValue = 1
         END
      ELSE
         BEGIN
            -- Record doesn't exist, so insert it.
            INSERT INTO CASINO
               (CAS_ID, CAS_NAME, SETASDEFAULT, LOCKUP_AMT, FROM_TIME,
                TO_TIME, CLAIM_TIMEOUT, DAUB_TIMEOUT, BINGO_FREE_SQUARE,
                TPI_ID, CARD_TYPE, PLAYER_CARD, REPRINT_TICKET, SUMMARIZE_PLAY,
                RECEIPT_PRINTER, DISPLAY_PROGRESSIVE)
            VALUES
               (@CasinoID, @CasinoName, 1, @LockupAmt, @FromTime,
                @ToTime, @ClaimTimeout, @DaubTimeout, @BingoFreeSquare,
                @TpiID, @CardType, @PlayerCard, @ReprintTicket, @SummarizePlay,
                @ReceiptPrinter, @DisplayProgressive)
            
            SET @ReturnValue = @@ERROR
         END
   END

IF (@ReturnValue = 0 OR @ReturnValue = 1)
   COMMIT TRANSACTION
ELSE
   ROLLBACK TRANSACTION

-- Set the procedure return value.
RETURN @ReturnValue

GO
