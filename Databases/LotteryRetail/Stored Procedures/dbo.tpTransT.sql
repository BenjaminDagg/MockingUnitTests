SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpTransT

Desc: Handles all ticket requests.

Called by: Transaction Portal

Parameters:
   @CoinsBet      Int     Number of Coins that were bet per Line
   @DealNumber    Int     Deal Number played (Paper game, or 0 if EZTab)
   @Denomination  Int     Denomination of the Play expressed in cents
   @LinesBet      Int     Number of Lines played
   @MachineNumber Char(5) Machine identifier
   @TicketNumber  Int     Ticket Number (Paper game, or 0)


Author: Chris Coddington

Date: 6/26/2003

Change Log:
Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Chris C.      03-04-2004
  Started handling of paper games.

Terry Watkins 03-30-2004
  Finished paper handling.  Added debug logging.

Terry Watkins 02-24-2005     v4.0.1
  Added logic to return error 119 (duplicate ticket) if the ticket was flagged
  as Inactive in the eDeal database.

Terry Watkins 03-17-2005     v4.0.2
  Added logic to check for Paper form when Machine is electronic mode.

Terry Watkins 03-17-2005     v4.1.4
  Modified the select that returns the Deal and Ticket Number for EZTab games
  to support Keno games.  For Keno, the number of Coins Bet is not used to
  determine what Deal is current.

Terry Watkins 09-07-2005     v4.2.2
  Added ISNULL checking to debug message text.

Terry Watkins 01-16-2006     v5.0.1
  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
  to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

Terry Watkins 11-01-2006     v5.0.8
  Added a check for Paper games that the DealNumber is appropriate for the
  game being played (GTC of Form = GTC of Bank).

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.

Terry Watkins 10-14-2010     v7.2.4
  Added the recording of tab errors in the TAB_ERROR table if playing a paper
  game.

Terry Watkins 04-25-2011     LRAS v2.0.1
  Added check for closed Deal, returns error 112 if Deal is closed.

Aldo Zamora 04-22-2013     Lottery Retail v3.1.0
  Added LocationID WHEN updating the TabError table.
  
Eloy Bencomo 03-04-2014      v3.1.1
  Added TicketNumber Logging to TAB_ERROR
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransT]
   @CoinsBet       Int,
   @DealNumber     Int,
   @Denomination   Int,
   @LinesBet       Int,
   @MachineNumber  Char(5),
   @TicketNumber   Int
AS

-- Variable Declarations
DECLARE @BankGameTypeCode   VarChar(2)
DECLARE @Barcode            VarChar(256)
DECLARE @CardRequired       Bit
DECLARE @DealSequenceID     Int
DECLARE @DealTypeCode       Char(1)
DECLARE @Debug              Bit
DECLARE @ErrorID            Int
DECLARE @ErrorDescription   VarChar(256)
DECLARE @ErrorSource        VarChar(64)
DECLARE @ErrorTypeID        Int
DECLARE @EventCode          VarChar(2)
DECLARE @FormIsPaper        Bit
DECLARE @FormGameTypeCode   VarChar(2)
DECLARE @FormNumber         VarChar(10)
DECLARE @EventLogDesc       VarChar(256)
DECLARE @IsActive           Int
DECLARE @IsOpenDeal         Bit
DECLARE @IsPaper            Bit
DECLARE @LastTicket         INT
DECLARE @LocationID         Int
DECLARE @LockupMachine      Int
DECLARE @MachNbrAsInt       Int
DECLARE @MaxCoinsBet        SmallInt
DECLARE @MsgText            VarChar(2048)
DECLARE @NextDeal           Int
DECLARE @PaperArguments     Bit
DECLARE @ParamString        nVarChar(128)
DECLARE @PayscaleMultiplier Int
DECLARE @PayscaleName       VarChar(16)
DECLARE @SQLString          nVarChar(1024)
DECLARE @TicketIsActive     Bit
DECLARE @TierForm           VarChar(10)
DECLARE @TimeStamp          DateTime
DECLARE @TransID            SmallInt

-- Variable Initialization
SET @Barcode               = ''
SET @CardRequired          = 1
SET @DealSequenceID        = 0
SET @DealTypeCode          = ' '
SET @ErrorID               = 0
SET @ErrorDescription      = ''
SET @ErrorSource           = 'tpTransT Stored Procedure'
SET @ErrorTypeID           = 0
SET @EventCode             = 'SP'
SET @FormIsPaper           = 0
SET @IsActive              = 0
SET @IsOpenDeal            = 0
SET @IsPaper               = 1
SET @LastTicket            = 0
SET @LockupMachine         = 0
SET @MachNbrAsInt          = CAST(@MachineNumber AS Int)
SET @NextDeal              = 0
SET @PaperArguments        = 0
SET @ParamString           = ''
SET @PayscaleMultiplier    = @CoinsBet
SET @SQLString             = ''
SET @TimeStamp             = GetDate()
SET @TransID               = 60

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransT'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransT Arguments - CoinsBet: ' + CAST(@CoinsBet AS VarChar(3)) +
         '  DealNumber: ' + CAST(@DealNumber AS VarChar(10)) +
         '  Denomination: ' + CAST(@Denomination AS VarChar(10)) +
         '  LinesBet: ' + CAST(@LinesBet AS VarChar(3)) +
         '  MachineNumber: ' + @MachineNumber +
         '  TicketNumber: ' + CAST(@TicketNumber AS VarChar(10))
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve CASINO information.
SELECT @CardRequired = PLAYER_CARD, @LocationID = LOCATION_ID FROM CASINO WHERE SETASDEFAULT = 1

-- Update last activity and retrieve the IsActive flag...
UPDATE MACH_SETUP SET
   @IsActive     = ACTIVE_FLAG,
   LAST_ACTIVITY = @TimeStamp
WHERE MACH_NO = @MachineNumber

-- Is the machine active?
IF (@IsActive = 1)
   -- Yes, so we can continue...
   BEGIN
      -- Retrieve the Deal Type Code.
      SELECT
         @DealTypeCode     = ISNULL(gt.TYPE_ID, ' '),
         @BankGameTypeCode = b.GAME_TYPE_CODE
      FROM MACH_SETUP ms
         JOIN BANK b ON ms.BANK_NO = b.BANK_NO
         JOIN GAME_TYPE gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
      WHERE ms.MACH_NO = @MachineNumber
      
      -- Do the argument values indicate Paper or Electronic?
      IF (@DealNumber = 0) AND (@TicketNumber = 0)
         -- Non-Paper games send 0 for Deal and Ticket numbers.
         SET @PaperArguments = 0
      ELSE
         -- Paper games send the Deal and Ticket number read from the tab.
         SET @PaperArguments = 1
      
      IF (@PaperArguments = 0)
         -- Calling argument values indicate a Non-Paper game.
         BEGIN
            IF (@Debug = 1)
               BEGIN
                  SET @MsgText = 'tpTransT Electronic Game signature (DealNumber and TicketNumber = 0)'
                  EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
               END
            
            -- Retrieve the IsPaper flag and make sure form agrees with machine...
            SELECT @FormIsPaper = cf.IS_PAPER
            FROM DEAL_SETUP ds JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
            WHERE ds.DEAL_NO = @DealNumber
            
            IF (@FormIsPaper = 1)
               BEGIN
                  -- Machine is playing in electronic mode, Form is paper.
                  SET @ErrorID = 121
                  IF (@Debug = 1)
                     BEGIN
                        SET @MsgText = 'tpTransT found Paper Form for Electronic Game Terminal.'
                        EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
                     END
               END
         END
      ELSE
         -- Paper Game. The machine has passed the Deal and Ticket numbers.
         -- Get Form and GameType info based upon the Deal Number.
         BEGIN
            SELECT
               @FormNumber         = ds.FORM_NUMB,
               @FormIsPaper        = cf.IS_PAPER,
               @TierForm           = ds.FORM_NUMB,
               @IsOpenDeal         = ds.IS_OPEN,
               @MaxCoinsBet        = gt.MAX_COINS_BET,
               @PayscaleName       = ps.PAYSCALE_NAME,
               @PayscaleMultiplier = cf.PAYSCALE_MULTIPLIER,
               @FormGameTypeCode   = cf.GAME_TYPE_CODE
            FROM DEAL_SETUP        ds
               JOIN CASINO_FORMS   cf ON ds.FORM_NUMB = cf.FORM_NUMB
               JOIN GAME_TYPE      gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
               JOIN PAYSCALE       ps ON gt.GAME_TYPE_CODE = ps.GAME_TYPE_CODE
            WHERE ds.DEAL_NO = @DealNumber
            
            -- If we did not get a row back, there is a setup problem.
            IF (@@ROWCOUNT <> 1)
               BEGIN
                  SET @ErrorID = 121
                  IF (@Debug = 1)
                     BEGIN
                        SET @MsgText = 'tpTransT failed to retrieve Deal or Form or GameType or Payscale or PayscaleMultiplier info.'
                        EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
                     END
               END
            ELSE
               IF (@Debug = 1)
                  BEGIN
                     SET @MsgText = 'tpTransT - FormNumber: ' + @FormNumber + 
                        '  Form Is Paper: '      + ISNULL(CAST(@FormIsPaper AS VarChar(1)), '<null>') +
                        '  MaxCoinsBet: '        + ISNULL(CAST(@MaxCoinsBet AS VarChar(4)), '<null>') +
                        '  PayscaleName: '       + ISNULL(@PayscaleName, '<null>') +
                        '  PayscaleMultiplier: ' + ISNULL(CAST(@PayscaleMultiplier AS VarChar(4)), '<null>') +
                        '  Form GameTypeCode: '  + ISNULL(@FormGameTypeCode, '<null>') +
                        '  Bank GameTypeCode: '  + ISNULL(@BankGameTypeCode, '<null>')
                     EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
                  END
               
               -- Check that the GTC of the Form is the same as the GTC of the Bank.
               IF (@FormGameTypeCode <> @BankGameTypeCode)
                  SET @ErrorID = 136
               ELSE IF (@IsOpenDeal = 0)
                  SET @ErrorID = 112
         END
      
      IF (@ErrorID = 0)
         BEGIN
            BEGIN TRANSACTION TransT
            
            -- Electronic or Paper?
            IF (@FormIsPaper = 0) AND (@PaperArguments = 0)
               -- Electronic Deal
               BEGIN
                  BEGIN TRANSACTION DealSequenceMod
                     
                     SET @IsPaper = 0
                     
                     SELECT
                        @DealSequenceID  = dsq.DEAL_SEQUENCE_ID,
                        @DealNumber      = dsq.DEAL_NO,
                        @LastTicket      = dsq.LAST_TICKET,
                        @NextDeal        = dsq.NEXT_DEAL,
                        @TicketNumber    = dsq.NEXT_TICKET
                     FROM MACH_SETUP ms
                        INNER JOIN BANK          b ON ms.BANK_NO = b.BANK_NO
                        INNER JOIN CASINO_FORMS cf ON b.GAME_TYPE_CODE = cf.GAME_TYPE_CODE
                        INNER JOIN DEAL_SEQUENCE dsq WITH (TABLOCKX HOLDLOCK) ON cf.FORM_NUMB = dsq.FORM_NUMB 
                     WHERE
                        ms.MACH_NO            = @MachineNumber AND
                        cf.IS_PAPER           = 0              AND
                        dsq.DENOMINATION      = @Denomination  AND
                        dsq.LINES_BET         = @LinesBet      AND
                        dsq.CURRENT_DEAL_FLAG = 1              AND
                        (dsq.COINS_BET = @CoinsBet OR @DealTypeCode = 'K')
                     
                     IF (@@ROWCOUNT > 0)
                        BEGIN
                          IF (@Debug = 1)
                             BEGIN
                                SET @MsgText = 'tpTransT NonPaper Game - DealNumber: ' +
                                               ISNULL(CAST(@DealNumber AS VarChar(8)), '<null>')
                                EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
                             END
                           
                           -- Get Form and GameType info based upon the Deal Number.
                           SELECT
                              @FormIsPaper  = cf.IS_PAPER,
                              @TierForm     = ds.FORM_NUMB,
                              @MaxCoinsBet  = gt.MAX_COINS_BET,
                              @PayscaleName = ps.PAYSCALE_NAME
                           FROM DEAL_SETUP ds
                              JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
                              JOIN GAME_TYPE    gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
                              JOIN PAYSCALE     ps ON gt.GAME_TYPE_CODE = ps.GAME_TYPE_CODE
                           WHERE ds.DEAL_NO = @DealNumber
                           
                           -- Are we on the last ticket?
                           IF (@TicketNumber <> @LastTicket)
                              -- No
                              BEGIN
                                 -- Increment the ticket counter.
                                 UPDATE DEAL_SEQUENCE
                                 SET NEXT_TICKET = NEXT_TICKET + 1
                                 WHERE DEAL_SEQUENCE_ID = @DealSequenceID
                              END
                           ELSE
                              -- Yes we are at the end of the Deal.
                              BEGIN
                                 -- End of the deal, mark the current deal inactive.
                                 -- End of the deal, mark the next active.
                                 UPDATE DEAL_SEQUENCE
                                 SET CURRENT_DEAL_FLAG = CURRENT_DEAL_FLAG ^ 1
                                 WHERE
                                    DEAL_SEQUENCE_ID = @DealSequenceID OR
                                    DEAL_SEQUENCE_ID = @NextDeal
                              END
                        END
                     ELSE
                        BEGIN
                           -- No deals exist for the given parameters.
                           SET @ErrorID = 111
                        END
                  
                  COMMIT TRANSACTION DealSequenceMod
               END
            
            IF (@ErrorID = 0)
               BEGIN
                  -- Get the ticket
                  SET @SQLString = N'UPDATE eDeal.dbo.Deal' +
                                   CONVERT(nVarChar(16), @DealNumber) + 
                                   N' SET @BarcodeInside = Barcode, @TicketActive = IsActive WHERE TicketNumber = ' +
                                   CONVERT(nVarChar(16), @TicketNumber)
                  
                  SET @ParamString = N'@BarcodeInside VarChar(256) OUTPUT, @TicketActive Bit OUTPUT'
                  
                  IF EXISTS(SELECT * FROM eDeal.dbo.sysobjects WHERE Name = 'Deal' + CONVERT(VarChar(16), @DealNumber))
                     BEGIN
                        EXEC sp_ExecuteSQL @SQLString, @ParamString, @BarcodeInside = @Barcode OUTPUT, @TicketActive = @TicketIsActive OUTPUT
                     END
                  ELSE
                     -- Deal table in eDeal database was not found.
                     SET @ErrorID = 115
                  
                  -- Check that the ticket has not already been played.
                  IF (@ErrorID = 0 AND @TicketIsActive = 0)
                     SET @ErrorID = 119
                  
                  -- Paper and no errors?
                  IF (@IsPaper = 1 AND @ErrorID = 0)
                     BEGIN
                        -- Increment the ticket counter (for the inventory report).
                        -- For paper games, the NEXT_TICKET is just a counter, not
                        -- really the next ticket to be played since we don't know
                        -- in what order rolls and tickets will be played.
                        UPDATE DEAL_SEQUENCE SET
                           NEXT_TICKET       = (NEXT_TICKET + 1),
                           CURRENT_DEAL_FLAG = 1,
                           NEXT_DEAL         = 0
                        WHERE DEAL_NO = @DealNumber
                     END
               END
               
               IF (@ErrorID <> 0)
                  ROLLBACK TRANSACTION TransT
               ELSE
                  COMMIT TRANSACTION TransT
         END
   END
ELSE
   -- Machine ACTIVE_FLAG is 0 (machine has been deactivated).
   SET @ErrorID = 103

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1),
         @ErrorTypeID      = ERROR_TYPE_ID
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
      
      -- If in Cardless Play mode, reset error text.
      IF (@CardRequired = 0)
         SET @ErrorDescription = dbo.CardlessErrorText(@ErrorDescription)
      
      -- Build Error Message
      SET @EventLogDesc = 'Machine Number:' + @MachineNumber + ', Description:' + @ErrorDescription
      
      -- Test if the Machine should be locked up.
      IF (@LockupMachine <> 0)
         BEGIN
            UPDATE MACH_SETUP SET ACTIVE_FLAG = 0 WHERE MACH_NO = @MachineNumber AND ACTIVE_FLAG = 1
            SET @EventCode = 'SD'
         END
      
      -- Insert Error into the Casino_Event_Log
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)
      
      -- If the error is a tab error and playing a paper game,
      -- record the the tab error in the TAB_ERROR table.
      IF (@ErrorTypeID = 1 AND @IsPaper = 1)
         BEGIN
            INSERT INTO TAB_ERROR
               (MACH_NO, ERROR_NO, EVENT_TIME, LOCATION_ID, TICKET_NO)
            VALUES
               (@MachineNumber, @ErrorID, @TimeStamp, @LocationID, @TicketNumber)
         END
   END

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransT Return Values - ErrorID: ' + ISNULL(CAST(@ErrorID AS VarChar(10)), '<null>') +
         '  ErrorDescription: '   + ISNULL(@ErrorDescription, '<null>') +
         '  LockupMachine: '      + ISNULL(CAST(@LockupMachine AS VarChar(10)), '<null>') +
         '  DealNumber: '         + ISNULL(CAST(@DealNumber AS VarChar(10)), '<null>') +
         '  Barcode: '            + ISNULL(@Barcode, '<null>') +
         '  TicketIsActive: '     + ISNULL(CAST(@TicketIsActive AS VarChar), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @DealNumber       AS DealNumber,
   @Barcode          AS Barcode
GO
