SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpTransH

Created 04-11-2003 by Chris Coddington

Desc: Handles all roll changes.

Return values: ErrorID
               ErrorDescription
               ShutDownFlag
               RollNumber
               TabTypeID
               TabsPerRoll
 
Called by: Transaction Portal

Parameters:
   @CardAccount         Card Account Number in the machine
   @DealNumber          Deal Number of Roll being put in machine
   @MachineDenomination Denom of the machine or 0 if multi-denom
   @MachineNumber       Machine number
   @MachineSequence     Transaction Sequence number
   @TicketNumber        Ticket number
   @TimeStamp           Date and time sent


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Chris C.      02-10-2004
  Changed float datatypes to money datatypes.

Terry Watkins 03-01-2004
  Added retrieval of Game Code from the Machine table for insertion into CASINO_TRANS.
                         
Chris C.      03-03-2004
  If deal does not exist, the sp now puts a 0 into CASINO_TRANS.

Terry Watkins 04-16-2004
  Modified to expect @MachineDenomination argument value of 0 to indicate a
  multi denom machine.  Added checks for multi denom deal in a single denom
  machine or single denom Deal ina multi denom machine.  Added Debug code to store
  debug info if turned on in DEBUG_SETTING.

Terry Watkins 10-25-2004
  Added insertion of TransID into CASINO_TRANS.

Terry Watkins 06-15-2005     v4.1.4
  Changed size of @CardAccount from 16 to 20.

Terry Watkins 01-16-2006     v5.0.1
  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
  to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

  Changed balance assignment so that it comes from MACH_SETUP in cardless play
  mode or from CARD_ACCT when in card play mode.

Terry Watkins 10-04-2006     v5.0.8
  Removed @TicketStatusID. No longer needed because column
  CASINO_TRANS.TICKET_STATUS_ID has been removed.

Terry Watkins 10-02-2008     v6.0.2
  Added retrieval of IS_MICRO_TAB to the returned resultset.

Terry Watkins 08-17-2008     v7.0.0
  Dropped unused variables @IsProgressive and @ProgressivePct
  and associated references to DEAL_SETUP.PROG_IND and PROG_PCT columns.
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AcctDate changed from VarChar(16) to DateTime.
  Do not set ErrorID 108 if the CardAccount is the OpKey account number.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.

Terry Watkins 08-25-2010     v7.2.3
  Modified so no longer returns @IsMicroTab flag and added the return of
  Tab Type Identifier and the number of Tabs per Roll.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added retrieval of @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID

Terry Watkins 01-12-2012     RetailLottery v3.0.3
  Added check to make sure ticket is active, if not, return error 532.
  If EGM_DEAL_GC_MATCH column value is 1 from the PRODUCT_LINE table check that
  the Game Code of the machine and Deal are the same.

Terry Watkins 06-06-2012     RetailLottery v3.0.6
  Added Try/Catch block around execution of tpInsertCasinoTrans to prevent this
  procedure from failing. (Case 28192)
  Added named parameters for execution of tpInsertCasinoTrans.
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
  
Eloy Bencomo 03-04-2014      v3.1.7
  Added TicketNumber Logging to TAB_ERROR

Edris Khestoo 08-28-2014     v.3.2.6
  Removed Logging of tab error for H trans to avoid double reporting of load issues
  
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransH]
   @CardAccount         VarChar(20),
   @DealNumber          Int,
   @MachineDenomination Int,
   @MachineNumber       VarChar(5),
   @MachineSequence     Int,
   @TicketNumber        Int,
   @TimeStamp           DateTime
AS

-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @Balance           Money
DECLARE @BankNumber        Int
DECLARE @CardRequired      Bit
DECLARE @CasinoID          VarChar(6)
DECLARE @CasinoTransID     Int
DECLARE @DealGameCode      VarChar(3)
DECLARE @DealNo            Int
DECLARE @Debug             Bit
DECLARE @DenomCount        Int
DECLARE @Denomination      Money
DECLARE @EgmDealGCMatch    Bit
DECLARE @ErrorID           Int
DECLARE @ErrorSource       VarChar(64)
DECLARE @ErrorText         VarChar(1024)
DECLARE @ErrorDescription  VarChar(256)
DECLARE @ErrorTypeID       Int
DECLARE @EventCode         VarChar(2)
DECLARE @GameTypeCode      VarChar(2)
DECLARE @EventLogDesc      VarChar(1024)
DECLARE @IntValue          Int
DECLARE @IsActive          Bit
DECLARE @LocationID        Int
DECLARE @LockupMachine     Int
DECLARE @MachGameCode      VarChar(3)
DECLARE @MachineDenom      Money
DECLARE @MachNbrAsInt      Int
DECLARE @MachNo            VarChar(5)
DECLARE @MSBalance         Money
DECLARE @MsgText           VarChar(2048)
DECLARE @ProductLineID     SmallInt
DECLARE @RollNo            Int
DECLARE @TabsPerRoll       Int
DECLARE @TabTypeID         Int
DECLARE @TicketNo          Int
DECLARE @TicketStatus      Int
DECLARE @TransAmt          Money
DECLARE @TransID           SmallInt
DECLARE @MachineTimeStamp  DateTime

SET NOCOUNT ON

-- Variable Initialization
SET @MachineTimeStamp = @TimeStamp
SET @Balance          = 0
SET @BankNumber       = 0
SET @CardRequired     = 1
SET @DealGameCode     = ''
SET @Denomination     = 0
SET @DealNo           = @DealNumber
SET @EgmDealGCMatch   = 0
SET @ErrorID          = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpTransH Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'SP'
SET @EventLogDesc     = ''
SET @IsActive         = 0
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachineDenom     = CONVERT(Money, @MachineDenomination) / 100
SET @MachNbrAsInt     = CAST(@MachineNumber AS Int)
SET @MSBalance        = 0
SET @ProductLineID    = 0
SET @RollNo           = 0
SET @TabsPerRoll      = 0
SET @TabTypeID        = -1
SET @TicketNo         = 0
SET @TransAmt         = 0
SET @TransID          = 70
SET @TimeStamp        = GetDate()

-- Retrieve Casino Information.
SELECT
   @CasinoID     = CAS_ID,
   @CardRequired = PLAYER_CARD,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransH'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransH Arguments - CardAccount: ' + ISNULL(@CardAccount, '<null>') +
         '  DealNumber: '          + ISNULL(CAST(@DealNumber AS VarChar), '<null>') +
         '  MachineDenomination: ' + ISNULL(CAST(@MachineDenomination AS VarChar), '<null>') +
         '  MachineNumber: '       + ISNULL(@MachineNumber, '<null>') +
         '  MachineSequence: '     + ISNULL(CAST(@MachineSequence AS VarChar), '<null>') +
         '  TicketNumber: '        + ISNULL(CAST(@TicketNumber AS VarChar), '<null>') +
         '  TimeStamp: '           + ISNULL(CONVERT(VarChar(32), @TimeStamp, 120), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve Machine information.
SELECT
   @IsActive     = ACTIVE_FLAG,
   @BankNumber   = BANK_NO,
   @MachGameCode = GAME_CODE,
   @MSBalance    = BALANCE
FROM MACH_SETUP
WHERE MACH_NO = @MachineNumber

-- Retrieve the ProductLineID from the Bank
SELECT @ProductLineID = PRODUCT_LINE_ID FROM dbo.BANK WHERE BANK_NO = @BankNumber

-- Retrieve CARD_ACCT information.
SELECT @MachNo = MACH_NO, @Balance = BALANCE FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAccount

-- Is there a CARD_ACCT row for the @CardAccount value?
IF (@@ROWCOUNT > 0)
   BEGIN
      -- Yes, now set the balance from either the MACH_SETUP or CARD_ACCT table...
      -- If Cardless play mode, reset to MACH_SETUP.BALANCE value.
      IF (@CardRequired = 0) SET @Balance = @MSBalance
      
      -- Now check if either the card account is the OpKey or else if the
      -- machine number on the CARD_ACCT row = @MachineNumber argument value.
      IF (@CardAccount = 'DGE00177777OpKey' OR @MachNo = @MachineNumber)
         BEGIN
            UPDATE MACH_SETUP SET LAST_ACTIVITY = @TimeStamp WHERE MACH_NO = @MachineNumber
            
            -- Is the machine still active?
            IF (@IsActive = 1)
               BEGIN
                  -- Yes, so check to see if there is a DEAL_SETUP row for the @DealNo argument value.
                  SELECT
                     @Denomination   = ds.DENOMINATION,
                     @IsActive       = ds.IS_OPEN,
                     @GameTypeCode   = cf.GAME_TYPE_CODE,
                     @TabsPerRoll    = ds.TABS_PER_ROLL,
                     @TabTypeID      = cf.TAB_TYPE_ID,
                     @DealGameCode   = ds.GAME_CODE
                  FROM DEAL_SETUP ds
                     JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
                  WHERE DEAL_NO = @DealNumber
                  
                  -- Is there a DEAL_SETUP record?
                  IF (@@ROWCOUNT > 0)
                     BEGIN
                        -- Yes, so check of the Deal is Active.
                        IF (@IsActive = 1)
                           BEGIN
                              -- Determine the roll number.
                              SET @RollNo = @TicketNumber / @TabsPerRoll + SIGN(@TicketNumber % @TabsPerRoll)
                              
                              -- Now test for single denom paper in a multi denom machine or
                              -- multi denom paper in a single denom machine.
                              
                              -- Retrieve a count of the valid denominations for this deal.
                              SELECT @DenomCount = COUNT(*) FROM DENOM_TO_GAME_TYPE WHERE GAME_TYPE_CODE = @GameTypeCode
                              
                              -- Is the Machine running in Single or Multi-Denom mode?
                              IF (@MachineDenomination = 0)
                                 BEGIN
                                    -- Multi-Denom mode. Check for multiple denoms in DENOM_TO_GAME_TYPE.
                                    IF (@DenomCount < 2)
                                       BEGIN
                                          SET @ErrorID = 127
                                          SET @ErrorText = ', MultiDenom Machine, Valid Deal Denom count is ' + CONVERT(VarChar(10), @DenomCount)
                                       END
                                 END
                              ELSE
                                 BEGIN
                                    -- Single-Denom mode. Check for multiple denoms in DENOM_TO_GAME_TYPE.
                                    IF (@DenomCount <> 1)
                                       BEGIN
                                          SET @ErrorID = 126
                                          SET @ErrorText = ', Single Denom Machine, Valid Deal Denom count is ' + CONVERT(VarChar(10), @DenomCount)
                                       END
                                    -- Test that the denoms match.
                                    ELSE IF (@Denomination <> @MachineDenom)
                                       BEGIN
                                          SET @ErrorID = 107
                                          SET @ErrorText = ', Denomination submitted: ' + CONVERT(VarChar(16), @MachineDenom)   
                                          SET @ErrorText = @ErrorText + ' but should be: ' + CONVERT(VarChar(16), @Denomination)      
                                       END
                                 END
                              
                              -- If no errors, check that the GAME_TYPE_CODE of the Form from
                              -- which the Deal was created is same as the Bank of this Machine.
                              IF (@ErrorID = 0)
                                 BEGIN
                                    SELECT @IntValue = COUNT(*) FROM BANK
                                    WHERE BANK_NO = @BankNumber AND GAME_TYPE_CODE = @GameTypeCode
                                    -- A count of zero means we have a mismatch.
                                    IF (@IntValue = 0)
                                       BEGIN
                                          SET @ErrorID = 128
                                          SET @ErrorText = ', Invalid Deal, Game Type incorrect for Bank ' + CONVERT(VarChar(10), @BankNumber)
                                          IF (@Debug = 1)
                                             BEGIN
                                                SET @MsgText = 'tpTransH - BankNumber: ' + 
                                                    CAST(@BankNumber AS VarChar(10)) +
                                                    '  GameTypeCode: ' + @GameTypeCode
                                                EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
                                             END
                                       END
                                 END
                                 
                              -- If no errors and PRODUCT_LINE.EGM_DEAL_GC_MATCH flag is set, check that
                              -- the Game Code of the EGM is the same as the Game Code of the Deal.
                              IF (@ErrorID = 0)
                                 BEGIN
                                    IF EXISTS(SELECT * FROM dbo.PRODUCT_LINE WHERE PRODUCT_LINE_ID = @ProductLineID)
                                       -- Row exists, so retrieve the EGM_DEAL_GC_MATCH value to determine if the
                                       -- GameCode of the Machine and Deal must match.
                                       BEGIN
                                          SELECT @EgmDealGCMatch = EGM_DEAL_GC_MATCH FROM dbo.PRODUCT_LINE WHERE PRODUCT_LINE_ID = @ProductLineID


  -- Allows for the existence of both 2-ply (with symbols) and single ply (with no symbols) to work
  -- Single ply behavior is to allow the same deal to work across all game families for a given form.   
  IF (@ProductLineID = 15 AND @TabTypeID = 6)
BEGIN
SET @EgmDealGCMatch = 1
END
  ELSE IF (@ProductLineID = 15)
BEGIN
SET @EgmDealGCMatch = 0
END



                                       END
                                    ELSE
                                       -- Unable to get the EGM_DEAL_GC_MATCH value because the ProductLine row does not exist.
                                       BEGIN
                                          SET @ErrorID = 141
                                          SET @ErrorText = ', The Bank ProductLineID was not found in the PRODUCT_LINE table.'
                                          IF (@Debug = 1)
                                             BEGIN
                                                SET @MsgText = 'tpTransH - ProductLineID ' + CAST(@ProductLineID AS VarChar) +
                                                               ' from Bank ' + CAST(@BankNumber AS VarChar) +
                                                               ' was not found in the PRODUCT_LINE table.'
                                                EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
                                             END
                                       END
                                 END
                              
                              IF (@ErrorID = 0 AND @EgmDealGCMatch = 1)
                                 -- No errors yet and the flag is set to force a match of EGM and Deal Game Codes...
                                 BEGIN
                                    IF (@DealGameCode <> @MachGameCode)
                                       BEGIN
                                          SET @ErrorID = 140
                                          SET @ErrorText = ', Invalid Deal, Game Code incorrect for Machine.'
                                          IF (@Debug = 1)
                                             BEGIN
                                                SET @MsgText = 'tpTransH - Machine Game Code: ' + @MachGameCode + '  Deal Game Code: ' + @DealGameCode
                                                EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
                                             END
                                       END
                                 END
                              
                              -- If no errors, check that the Ticket being loaded is not inactive.
                              IF (@ErrorID = 0)
                                 BEGIN
                                    -- Get the ticket status...
                                    EXEC @TicketStatus = GetPaperTicketStatus @DealNumber, @TicketNumber
                                    
                                    IF (@TicketStatus = 1)
                                       -- Ticket is inactive.
                                       BEGIN
                                          SET @ErrorID = 532
                                          SET @ErrorText = ', Ticket is inactive.'
                                       END
                                    
                                    IF (@TicketStatus = 2)
                                       -- Deal table not found in eDeal database.
                                       BEGIN
                                          SET @ErrorID = 111
                                          SET @ErrorText = ', eDeal Deal Table does not exist.'
                                       END
                                 END
                           END
                        ELSE
                           -- Deal is not Active (has been closed, DEAL_SETUP.IS_OPEN = 0).
                           SET @ErrorID = 112
                     END
                  ELSE
                     -- Deal does not exist.
                     SET @ErrorID = 111
               END
            ELSE
               -- Machine is inactive.
               SET @ErrorID = 103
         END
      ELSE
         -- Card is not in the machine.
         SET @ErrorID = 108
   END
ELSE
   -- Invalid Card
   SET @ErrorID = 102

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1),
         @ErrorTypeID      = ISNULL(ERROR_TYPE_ID, 0)
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
      
      -- If in Cardless Play mode, reset error text.
      IF (@CardRequired = 0)
         SET @ErrorDescription = dbo.CardlessErrorText(@ErrorDescription)
      
      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription +
                          ', Card Account: ' + @CardAccount +
                          ', Machine Number: ' + @MachineNumber + @ErrorText
      
      -- If in Debug mode, store the error in the DEBUG_INFO table.
      IF (@Debug = 1)
         BEGIN
            SET @MsgText = 'tpTransH - ' + @EventLogDesc
            EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
         END
      
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
      
      -- If the Deal is invalid or does not exist, insert 0 into CASINO_TRANS as the Deal Number.
      IF (@ErrorID = 111)
         SET @DealNo = 0
   END

BEGIN TRY
   -- Log transaction.
   EXEC @CasinoTransID = tpInsertCasinoTrans
      @CasinoID        = @CasinoID,
      @DealNo          = @DealNo,
      @RollNo          = @RollNo,
      @TransAmt        = @TransAmt,
      @TransID         = @TransID,
      @CurrentAcctDate = @AcctDate,
      @TimeStamp       = @TimeStamp,
      @MachineNumber   = @MachineNumber,
      @CardAccount     = @CardAccount,
      @Balance         = @Balance,
      @GameCode        = @MachGameCode,
      @LocationID      = @LocationID,
      @MachineTimeStamp = @MachineTimeStamp
END TRY
BEGIN CATCH
   -- Store the TSQL error number.
   SELECT @IntValue = ERROR_NUMBER(), @ErrorSource = ERROR_PROCEDURE()
   
   -- Insert a row into the CASINO_EVENT_LOG table.
   INSERT INTO CASINO_EVENT_LOG
      (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
   VALUES
      ('FI', @ErrorSource, 'Insert of load roll into CASINO_TRANS failed.', @IntValue, @MachineNumber)
END CATCH

-- Return results to client
SELECT
   @ErrorID            AS ErrorID,
   @ErrorDescription   AS ErrorDescription,
   @LockupMachine      AS ShutDownFlag,
   @RollNo             AS RollNumber,
   @TabTypeID          AS TabTypeID,
   @TabsPerRoll        AS TabsPerRoll

GO
