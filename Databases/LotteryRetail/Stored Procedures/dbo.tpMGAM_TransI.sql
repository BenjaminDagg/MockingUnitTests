SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpMGAM_TransI

Created 04-28-2005 by A Murthy

Purpose: Handles all MGAM card inserts.

Return Dataset: ErrorID, ErrorDescription, ShutDownFlag, Balance, AccessLevel,
                PromoBalance

Called by: Transaction Portal upon MGAM Player Card insert

Arguments:
   @CardAccount         Card Account Number
   @MachineBalance      Balance sent by the Machine in cents
   @MachineDenomination Machine Denomination in cents
   @MachineNumber       Machine Number
   @MachineSequence     Sequence Number generated and sent by the Machine
   @Pin                 Tech entered Pin Number
   @TimeStamp           Date and Time sent by the Machine (but overwritten here)
   @PromoBalance        Coupon Balance sent by the Machine in cents


Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
A Murthy      02-15-2005     v4.0.x
  Initial Coding

Terry Watkins 05-22-2005     v4.1.4
  Changed size of @CardAccount from 16 to 20.

A Murthy      11-09-2005     v4.2.4
  Added check for ErrorID=109 to tpInsertCasinoTrans to avoid SQLException when
  a brand new card was inserted and the machine already had an old card in it.

A. Murthy     01-16-2006     v5.0.1
  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
  to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

Terry Watkins 10-04-2006     v5.0.8
  Removed @TicketStatusID (CASINO_TRANS.TICKET_STATUS_ID has been removed).

Terry Watkins 11-03-2009     v7.0.0
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AcctDate changed from VarChar(16) to DateTime.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added retrieval of @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpMGAM_TransI]
   @CardAccount         VarChar(20),
   @MachineBalance      Int,
   @MachineDenomination Int,
   @MachineNumber       VarChar(5),
   @MachineSequence     Int,
   @Pin                 nVarChar(128),
   @TimeStamp           DateTime,
   @PromoBalance        Int
AS

-- Variable Declarations
DECLARE @AccessLevel      Int
DECLARE @AcctDate         DateTime
DECLARE @Balance          Money
DECLARE @Barcode          VarChar(128)
DECLARE @CardRequired     Bit
DECLARE @CasinoID         VarChar(6)
DECLARE @CasinoTransID    Int
DECLARE @CoinsBet         Int
DECLARE @DealNo           Int
DECLARE @Debug            Bit
DECLARE @ErrorID          Int
DECLARE @ErrorSource      VarChar(64)
DECLARE @ErrorText        VarChar(1024)
DECLARE @ErrorDescription VarChar(256)
DECLARE @EventCode        VarChar(2)
DECLARE @EventLogDesc     VarChar(1024)
DECLARE @IsActive         Int
DECLARE @LinesBet         Int
DECLARE @LocationID       Int
DECLARE @LockupMachine    Int
DECLARE @MachCardAcct     VarChar(20)
DECLARE @MachGameCode     VarChar(3)
DECLARE @MachineBal       Money
DECLARE @MachineDenom     Money
DECLARE @MachIsActive     TinyInt
DECLARE @MachNbrAsInt     Int
DECLARE @MachNo           VarChar(5)
DECLARE @MsgText          VarChar(1024)
DECLARE @PinText          nVarChar(128)
DECLARE @PromoBal         Money
DECLARE @RollNo           Int
DECLARE @TicketNo         Int
DECLARE @TierLevel        SmallInt
DECLARE @TotalBal         Money
DECLARE @TransAmt         Money
DECLARE @TransID          SmallInt

SET NOCOUNT ON

-- Variable Initialization
SET @AccessLevel      = 0
SET @Balance          = 0
SET @Barcode          = ''
SET @CardRequired     = 1
SET @CoinsBet         = 0
SET @DealNo           = 0
SET @ErrorID          = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpMGAM_TransI Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'FI'
SET @IsActive         = 0
SET @LinesBet         = 0
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachCardAcct     = ''
SET @MachineBal       = CONVERT(Money, @MachineBalance) / 100
SET @MachineDenom     = CONVERT(Money, @MachineDenomination) / 100
SET @MachNbrAsInt     = CAST(@MachineNumber AS Int)
SET @MachIsActive     = 0
SET @PinText          = ''
SET @PromoBal         = CONVERT(Money, @PromoBalance) / 100
SET @RollNo           = 0
SET @TicketNo         = 0
SET @TierLevel        = 0
SET @TotalBal         = 0
SET @TransAmt         = 0
SET @TransID          = 40
SET @TimeStamp        = GetDate()

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpMGAM_TransI'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpMGAM_TransI Argument Values:  ' + 
         '  CardAccount: ' + @CardAccount +
         '  MachineBalance: ' + CAST(@MachineBalance AS VarChar) +
         '  MachineDenomination: ' + CAST(@MachineDenomination AS VarChar) +         '  MachineNumber: ' + @MachineNumber +
         '  MachineSequence: ' + CAST(@MachineSequence AS VarChar) +
         '  Pin: -----' +
         '  TimeStamp: ' + CAST(@TimeStamp AS VarChar) +
         '  PromoBalance: ' + CAST(@PromoBalance AS VarChar)
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END


-- Retrieve CASINO information.
SELECT
   @CasinoID     = CAS_ID,
   @CardRequired = PLAYER_CARD,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Check for existance, active, removed status of machine.
SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

-- If the MACH_SETUP row was found, update MACH_SETUP.LAST_ACTIVITY and retrieve GAME_CODE for the Machine.
IF (@ErrorID <> 104)
   UPDATE MACH_SETUP SET
      LAST_ACTIVITY = @TimeStamp,
      @MachIsActive = ACTIVE_FLAG,
      @MachGameCode = GAME_CODE
   WHERE MACH_NO = @MachineNumber


-- Have we encountered an error?
IF (@ErrorID = 0)
   -- We have already handled Machine status.
   -- Now evaluate for Card Play mode with a User (not a Tech) card.
   BEGIN
      SELECT @MachCardAcct = CARD_ACCT_NO
      FROM CARD_ACCT
      WHERE MACH_NO = @MachineNumber
                  
      -- Test that the machine doesn't have a card in it.
      IF (@@ROWCOUNT = 0)
         BEGIN
            -- Get the the MACH_NO & STATUS from CARD_ACCT
            SELECT
               @MachNo   = MACH_NO,
               @Balance  = @MachineBal,
               @IsActive = STATUS
            FROM CARD_ACCT
            WHERE CARD_ACCT_NO = @CardAccount
            
            -- Was the CARD_ACCT record found?
            IF (@@ROWCOUNT = 0)
               -- No, so create it...
               BEGIN
                  INSERT INTO CARD_ACCT
                     (CARD_ACCT_NO, BALANCE, CREATE_DATE, MODIFIED_DATE, SESSION_DATE, STATUS, MACH_NO)
                  VALUES
                     (@CardAccount, @MachineBal, @TimeStamp, @TimeStamp, @TimeStamp, 1, @MachineNumber)
                  
                  SET @Balance  = @MachineBal
                  SET @IsActive = 1
                  SET @MachNo   = '0'
                END
            
            -- Reset @MachineBal to 0 because it has been transferred to @Balance
            SET @MachineBal = 0
            
            -- Test that the Card is active.
            IF (@IsActive = 1)
               BEGIN
                  -- Test that the Machine balance is equal to zero (no previous balance leftover)
                  IF (@MachineBal = 0)
                     BEGIN
                        -- Test that the card is not in another machine.
                        IF (@MachNo = 0 OR @MachNo IS NULL)
                           BEGIN
                              -- This is not a tech card.
                              -- Test that the Machine is active.
                              IF (@MachIsActive = 1)
                                 BEGIN
                                    -- Update the Machine Number in the Card Account Table
                                    UPDATE CARD_ACCT SET
                                       BALANCE      = @Balance,
                                       MACH_NO      = @MachineNumber,
                                       SESSION_DATE = @TimeStamp
                                    WHERE CARD_ACCT_NO = @CardAccount
                                    
                                    -- Update MACH_SETUP with PromoBalance
                                    UPDATE MACH_SETUP SET
                                       PROMO_BALANCE = @PromoBal
                                    WHERE MACH_NO = @MachineNumber
                                 END
                              ELSE
                                 -- Machine is not active.
                                 BEGIN
                                    SET @ErrorID = 103
                                 END
                           END
                        ELSE
                           -- Card is in another machine.
                           BEGIN
                              SET @ErrorID = 106
                              SET @ErrorText = ', Card is in Machine number:' +
                              CONVERT(VarChar(16), @MachNo)
                              SET @TransID = 42
                           END
                     END
                  ELSE
                     -- Machine balance is not equal to zero.
                     BEGIN
                        -- In card required mode, bad balance is 120.
                        SET @ErrorID = 120
                        SET @ErrorText = ', Machine balance should be zero, balance submitted was: ' +
                                         CONVERT(VarChar(16), (@MachineBal))
                     END
               END
            ELSE
               -- Card is not active.
               BEGIN
                  SET @ErrorID = 101
               END
         END
      ELSE
         -- Machine has a card in it.
         BEGIN
            -- Is it the card entered?
            IF (@MachCardAcct = @CardAccount)
               BEGIN
                  SET @ErrorID = 110
                  SET @TransID = 43
               END
            ELSE
               -- It is not this card.
               BEGIN
                  SET @ErrorID = 109
                  SET @ErrorText = ',Machine has card account:' + @MachCardAcct
               END
         END
   END

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
      
      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription +
                          '  Card Account: ' + @CardAccount +
                          ' Machine Number: ' + @MachineNumber + @ErrorText
      
      IF (@ErrorID = 102)
         SET @CardAccount = 'INVALID'
      
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
      
      -- Reset balance to zero (so balance in CASINO_TRANS will show 0).
      SET @Balance = 0
      
      -- Log transaction into CASINO_TRANS, 
      -- only if Error is not 109 otherwise you get a Foreign Key constraint failure with CARD_ACCT table.
      IF (@ErrorID <> 104 AND @ErrorID <> 109)
         EXEC @CasinoTransID = tpInsertCasinoTrans
            @CasinoID, @DealNo, @RollNo, @TicketNo, 0, @TransAmt, @Barcode, @TransID,
            @AcctDate, @TimeStamp, @MachineNumber, @CardAccount, @Balance,
            @MachGameCode, @CoinsBet, @LinesBet, @TierLevel, @LocationID
   END
ELSE
   BEGIN
      -- No errors Increase @Balance with PromoBalance when logging it into CASINO_TRANS
      SET @TotalBal = @Balance + @PromoBal
      
      EXEC @CasinoTransID = tpInsertCasinoTrans
         @CasinoID, @DealNo, @RollNo, @TicketNo, 0, @TransAmt, @Barcode, @TransID,
         @AcctDate, @TimeStamp, @MachineNumber, @CardAccount, @TotalBal,
         @MachGameCode, @CoinsBet, @LinesBet, @TierLevel, @LocationID
   END

-- Is Debug mode is on?
IF (@Debug = 1)
   -- Yes, so record outgoing argument values...
   BEGIN
      SET @MsgText =
         'tpMGAM_TransI Return Values:  ' + 
         '  ErrorID: '          + CAST(@ErrorID AS VarChar) +
         '  ErrorDescription: ' + @ErrorDescription +
         '  ShutDownFlag: '     + CAST(@LockupMachine AS VarChar) +
         '  Balance: '          + CAST(@Balance AS VarChar) +
         '  AccessLevel: '      + CAST(@AccessLevel AS VarChar) +
         '  PromoBalance: '     + CAST(@PromoBal AS VarChar)
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @Balance * 100    AS Balance,
   @PromoBal * 100   AS PromoBalance,
   @AccessLevel      AS AccessLevel
GO
