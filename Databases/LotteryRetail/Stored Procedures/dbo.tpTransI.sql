SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpTransI

Created 04-11-2003 by Chris Coddington

Purpose: Handles all card inserts.

Return Dataset: ErrorID, ErrorDescription, ShutDownFlag, Balance, AccessLevel

Called by: Transaction Portal

Arguments:
   @CardAccount         Card Account Number
   @MachineBalance      Balance sent by the Machine in cents
   @MachineDenomination Machine Denomination in cents
   @MachineNumber       Machine Number
   @MachineSequence     Sequence Number generated and sent by the Machine
   @Pin                 Tech entered Pin Number
   @TimeStamp           Date and Time sent by the Machine (but overwritten here)
   @PromoBalance        Promotional Balance from the Machine


Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
Chris C.      07-24-2003
  Added support for pin/access level.

Chris C.      07-25-2003
  Removed machine denomination validation.

Chris C.      08-12-2003
  Moved Machine IsActive check to player card section.

Chris C.      02-10-2004
  Changed float datatypes to money datatypes.

Terry Watkins 03-01-2004
  Added retrieval of Game Code from the Machine table for insertion into
  CASINO_TRANS.

Terry Watkins 10-25-2004     v4.0.0
  Added insertion of TransID into CASINO_TRANS.
  Added Debug support.
  Added support for Cardless Play mode.
  Removed PIN number from debug message.

A Murthy      02-15-2005     v4.0.1
  Added Turn off "Inactive Machine" Error# 103 for Techs. per Dave Nessen

Terry Watkins 05-06-2005     v4.1.1
  Added argument @PromoBalance to support the MGAM TPI.

Terry Watkins 05-20-2005     v4.1.2
  Modified so that if a card is inserted and the system already has the same
  card or a different card in the machine, it will not generate an error.

Terry Watkins 06-15-2005     v4.1.4
  Changed size of @CardAccount and @MachCardAcct from 16 to 20.

Terry Watkins 07-06-2005     v4.1.5
  Added support for a PIN number play.

Terry Watkins 07-18-2005     v4.1.6
  Changed datatype of @PinNumber from Int to VarChar(6) to allow leading zeros
  and PIN Number encryption.

A. Murthy     12-16-2005     v5.0.0
 Return PromoBalance in final select to support MGAM.

Terry Watkins 01-16-2006     v5.0.1
  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
  to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

Terry Watkins 07-31-2006     v5.0.5
  Cast @Balance to Int in returned resultset (fomatting issue in the log file)

Terry Watkins 10-04-2006     v5.0.8
  Removed @TicketStatusID. No longer needed because column
  CASINO_TRANS.TICKET_STATUS_ID has been removed.

Terry Watkins 07-29-2008     v6.0.2
  Added Tech Key support.  Requires an entry in the CARD_ACCT and the
  CASINO_USERS tables.

Terry Watkins 11-03-2009     v7.0.0
  Added code to disallow balance adjustments that exceed the value set in
  CASINO.MAX_BAL_ADJUSTMENT.
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AcctDate changed from VarChar(16) to DateTime.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added retrieval of @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransI]
   @CardAccount         VarChar(20),
   @MachineBalance      Int,
   @MachineDenomination Int,
   @MachineNumber       VarChar(5),
   @MachineSequence     Int,
   @Pin                 nVarChar(128),
   @TimeStamp           DateTime,
   @PromoBalance        Int = 0
AS

-- Variable Declarations
DECLARE @AccessLevel      Int
DECLARE @AcctDate         DateTime
DECLARE @AccountPrefix    VarChar(6)
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
DECLARE @IsTechCard       Bit
DECLARE @IsTechKey        Bit
DECLARE @LinesBet         Int
DECLARE @LocationID       Int
DECLARE @LockupMachine    Int
DECLARE @MachCardAcct     VarChar(20)
DECLARE @MachGameCode     VarChar(3)
DECLARE @MachineBal       Money
DECLARE @MachineDenom     Money
DECLARE @MachIsActive     Bit
DECLARE @MachNbrAsInt     Int
DECLARE @MachNo           VarChar(5)
DECLARE @MaxBalAdjust     Money
DECLARE @MsgText          VarChar(1024)
DECLARE @PinNumber        VarChar(6)
DECLARE @PinRequired      Bit
DECLARE @PinText          nVarChar(128)
DECLARE @RollNo           Int
DECLARE @TicketNo         Int
DECLARE @TierLevel        SmallInt
DECLARE @TransAmt         Money
DECLARE @TransID          SmallInt
DECLARE @UAccount         VarChar(10)
DECLARE @MachineTimeStamp DateTime

SET NOCOUNT ON

-- Variable Initialization
SET @MachineTimeStamp = @TimeStamp
SET @AccessLevel      = 0
SET @AccountPrefix    = LEFT(@CardAccount, 6)
SET @Balance          = 0
SET @Barcode          = ''
SET @CardRequired     = 1
SET @CoinsBet         = 0
SET @DealNo           = 0
SET @ErrorID          = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpTransI Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'FI'
SET @EventLogDesc     = ''
SET @IsActive         = 0
SET @IsTechCard       = 0
SET @IsTechKey        = 0
SET @LinesBet         = 0
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachCardAcct     = ''
SET @MachineBal       = CONVERT(Money, @MachineBalance) / 100
SET @MachineDenom     = CONVERT(Money, @MachineDenomination) / 100
SET @MachNbrAsInt     = CAST(@MachineNumber AS Int)
SET @MachIsActive     = 0
SET @PinText          = ''
SET @RollNo           = 0
SET @TicketNo         = 0
SET @TierLevel        = 0
SET @TransAmt         = 0
SET @TransID          = 40
SET @TimeStamp        = GetDate()
SET @UAccount         = RIGHT(@CardAccount, 10)

-- Is the Card a Tech Card?
IF (@AccountPrefix = 'DGE001') SET @IsTechCard = 1

-- Is the Card really a Tech key?
IF (@IsTechCard = 1 AND @UAccount = '77777OpKey') SET @IsTechKey = 1

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransI'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpTransI Argument Values:  ' + 
         '  CardAccount: '         + ISNULL(@CardAccount, '<null>') +
         '  MachineBalance: '      + ISNULL(CAST(@MachineBalance AS VarChar), '<null>') +
         '  MachineDenomination: ' + ISNULL(CAST(@MachineDenomination AS VarChar), '<null>') +         '  MachineNumber: '       + ISNULL(@MachineNumber, '<null>') +
         '  MachineSequence: '     + ISNULL(CAST(@MachineSequence AS VarChar), '<null>') +
         '  Pin: -----'            +
         '  TimeStamp: '           + ISNULL(CAST(@TimeStamp AS VarChar), '<null>') +
         '  PromoBalance: '        + ISNULL(CAST(@PromoBalance AS VarChar), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve CASINO information.
SELECT
   @CasinoID     = CAS_ID,
   @CardRequired = PLAYER_CARD,
   @PinRequired  = PIN_REQUIRED,
   @MaxBalAdjust = MAX_BAL_ADJUSTMENT,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- If a player card is not required, then a Pin number is not required either.
IF (@CardRequired = 0 AND @PinRequired = 1) SET @PinRequired = 0

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpTransI calculated Values:  ' + 
         '  IsTechCard: '    + CASE @IsTechCard   WHEN 0 THEN 'No' ELSE 'Yes' END +
         '  IsTechKey: '     + CASE @IsTechKey    WHEN 0 THEN 'No' ELSE 'Yes' END +
         '  CardRequired: '  + CASE @CardRequired WHEN 0 THEN 'No' ELSE 'Yes' END +
         '  PinRequired: '   + CASE @PinRequired  WHEN 0 THEN 'No' ELSE 'Yes' END
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Check for existance, active, removed status of machine.
SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

-- If the MACH_SETUP row was found, update MACH_SETUP.LAST_ACTIVITY and retrieve Machine info.
IF (@ErrorID <> 104)
   UPDATE MACH_SETUP SET
      LAST_ACTIVITY = @TimeStamp,
      @MachIsActive = ACTIVE_FLAG,
      @MachGameCode = GAME_CODE,
      @Balance      = BALANCE
   WHERE MACH_NO = @MachineNumber

-- Turn off "Inactive Machine" Error# 103 for Techs.
IF (@ErrorID = 103 AND @IsTechCard = 1) SET @ErrorID = 0

-- Have we encountered an error?
IF (@ErrorID = 0)
   -- No, so check for a Player Card in Cardless mode...
   BEGIN
      -- In Cardless Play mode, only Tech cards are allowed.
      IF (@CardRequired = 0 AND @IsTechCard = 0)
         -- Invalid Card.
         SET @ErrorID = 102
         SET @ErrorText = ', Not a Tech Card. '
   END

-- The Card account must exist if in PinPlay mode and user is not a tech...
IF (@ErrorID = 0 AND @IsTechCard = 0 AND @PinRequired = 1)
   BEGIN
      SELECT @PinNumber = PIN_NUMBER FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAccount
      -- Did we find a row?
      IF (@@ROWCOUNT = 0)
         BEGIN
            SET @ErrorID = 133
            SET @ErrorText = ', Card not found while in PIN Play mode. '
         END
      ELSE IF (@PinNumber IS NULL)
         BEGIN
            SET @ErrorID = 134
            SET @ErrorText = ', Card account does not have a Pin Number. '
         END
   END

-- Have we encountered an error?
IF (@ErrorID = 0)
   -- No, so check for validity if this is a Tech Card.
   BEGIN
      -- Is it a Tech card?
      IF (@IsTechCard = 1)
         -- Yes, so retrieve user information.
         BEGIN
            -- If not a Tech Key and the Card Account does not exist, insert a row into CARD_ACCT...
            IF @IsTechKey = 0 AND NOT EXISTS(SELECT * FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAccount)
               INSERT INTO CARD_ACCT
                  (CARD_ACCT_NO, BALANCE, CREATE_DATE, MODIFIED_DATE, SESSION_DATE, [STATUS], MACH_NO)
               VALUES
                  (@CardAccount, 0, @TimeStamp, @TimeStamp, @TimeStamp, 1, @MachineNumber)
            
            -- Retrieve user information.
            SELECT @AccessLevel = ACCESS_LEVEL, @PinText = PSSWD, @IsActive = ACTIVE
            FROM CASINO_USERS
            WHERE ACCOUNTID = @UAccount
            
            -- Does the user record exist?
            IF (@@ROWCOUNT > 0)
               BEGIN
                  IF (@IsActive = 1)
                     -- Does the pin submitted match what is in the database?
                     BEGIN
                        IF (@PinText = @Pin)
                           -- Update the Machine Number in the Card Account Table
                           -- if it is not a tech key.
                           BEGIN
                              IF (@IsTechKey = 0)
                                 UPDATE CARD_ACCT SET
                                    MACH_NO      = @MachineNumber,
                                    SESSION_DATE = @TimeStamp
                                 WHERE CARD_ACCT_NO = @CardAccount
                           END
                        ELSE
                           -- Invalid PIN.
                           BEGIN
                              SET @ErrorID = 116
                              SET @AccessLevel = 0
                           END
                     END
                  ELSE
                     -- Inactive user, return Inactive Card error.
                     BEGIN
                        SET @ErrorID = 101
                        SET @AccessLevel = 0
                     END
               END
            ELSE
               -- User record was not found.
               SET @ErrorID = 102
         END
   END

-- Have we encountered an error in cardless play mode?
IF (@ErrorID = 0 AND @CardRequired = 0)
   -- No error and we are in Cardless Play mode,
   -- so now we evaluate Machine vs Server balance for Cardless play
   -- Note that we already have the balance from MACH_SETUP.BALANCE (~ line 190).
   BEGIN
      IF (@MachineBal <> @Balance)
         BEGIN
            -- Balance mismatch in Cardless mode is 105.
            SET @ErrorID = 105
            SET @ErrorText = ', Server balance: ' + CONVERT(VarChar(16), @Balance) +
                             ', Machine balance: ' + CONVERT(VarChar(16), @MachineBal)
         END
   END

-- Have we encountered an error?
IF (@ErrorID = 0)
   -- We have already handled Machine status, Cardless Play, and Tech cards.
   -- Now evaluate for Card Play mode with a User (not a Tech) card.
   BEGIN
      IF (@CardRequired = 1 AND @IsTechCard = 0)
         BEGIN
            -- Test that the card is for this Casino.
            IF (@AccountPrefix = @CasinoID)
               BEGIN
                  SELECT @MachCardAcct = CARD_ACCT_NO
                  FROM CARD_ACCT
                  WHERE MACH_NO = @MachineNumber
                  
                  -- Get the system balance from CARD_ACCT.
                  SELECT
                     @MachNo   = MACH_NO,
                     @Balance  = BALANCE,
                     @IsActive = STATUS,
                     @PinNumber = PIN_NUMBER
                  FROM CARD_ACCT
                  WHERE CARD_ACCT_NO = @CardAccount
                  
                  -- Was the CARD_ACCT record found?
                  IF (@@ROWCOUNT = 0 AND @PinRequired = 0)                     -- No, so create it if not in Pin play mode...
                     BEGIN
                        INSERT INTO CARD_ACCT
                           (CARD_ACCT_NO, BALANCE, CREATE_DATE, MODIFIED_DATE, SESSION_DATE, STATUS, MACH_NO)
                        VALUES
                           (@CardAccount, 0, @TimeStamp, @TimeStamp, @TimeStamp, 1, @MachineNumber)
                        
                        SET @Balance  = 0
                        SET @IsActive = 1
                        SET @MachNo   = '0'
                     END
                  
                  IF (@MachCardAcct = @CardAccount) SET @TransID = 43
                  
                  -- Test that the Card is active.
                  IF (@IsActive = 1)
                     BEGIN
                        -- Test that the Machine balance is equal to zero (no previous balance leftover)
                        IF (@MachineBal = 0)
                           BEGIN
                              -- Test that the card is not in another machine.
                              IF (@MachNo IS NULL OR @MachNo = '0' OR @MachCardAcct = @CardAccount)
                                 BEGIN
                                    -- This is not a tech card.
                                    -- Test that the Machine is active.
                                    IF (@MachIsActive = 1)
                                       BEGIN
                                          -- Update the Machine Number in the Card Account Table
                                          UPDATE CARD_ACCT SET
                                             MACH_NO      = @MachineNumber,
                                             SESSION_DATE = @TimeStamp
                                          WHERE CARD_ACCT_NO = @CardAccount
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
                                    SET @ErrorText = ', Card is in Machine number:' + @MachNo
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
               -- Card is not from this casino.
               SET @ErrorID = 102
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
      
      -- If in Cardless Play mode, reset error text.
      IF (@CardRequired = 0)
         SET @ErrorDescription = dbo.CardlessErrorText(@ErrorDescription)
      
      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription +
                          '  Card Account: ' + @CardAccount +
                          ' Machine Number: ' + @MachineNumber + @ErrorText
      
      IF (@ErrorID IN (102, 133))
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
      
      -- Reset balance to zero if in Card Play mode (so balance in CASINO_TRANS will show 0).
      IF (@CardRequired = 1) SET @Balance = 0
   END

-- Log transaction.
EXEC @CasinoTransID = tpInsertCasinoTrans
   @CasinoID, @DealNo, @RollNo, @TicketNo, 0, @TransAmt, @Barcode, @TransID,
   @AcctDate, @TimeStamp, @MachineNumber, @CardAccount, @Balance, @MachGameCode,
   @CoinsBet, @LinesBet, @TierLevel, 0, @LocationID, @MachineTimeStamp

-- Did we get a balance error in Cardless Play mode?
IF (@ErrorID = 105)
   BEGIN
      -- Is the difference <= adjustment threshold?
      IF ((@MachineBal - @Balance) <= @MaxBalAdjust)
         BEGIN
            -- Yes, so we need to adjust the machine balance...
            EXEC tpAdjustMachineBalance
               @MachineNumber, @CardRequired, @MachineBal, @Balance, 'tpTransI',
               @MachineTimeStamp, @CasinoID, @AcctDate, @MachGameCode, @LocationID
         END
      ELSE
         -- The difference exceeds the max adjustment value, force a lockup.
         BEGIN
            SET @LockupMachine = 1
         END
   END

-- Is Debug mode is on?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpTransI Return Values:  ' + 
         '  ErrorID: '          + ISNULL(CAST(@ErrorID AS VarChar), '<null>') +
         '  ErrorDescription: ' + ISNULL(@ErrorDescription, '<null>') +
         '  ShutDownFlag: '     + ISNULL(CAST(@LockupMachine AS VarChar), '<null>') +
         '  Balance: '          + ISNULL(CAST(@Balance AS VarChar), '<null>') +         '  AccessLevel: '      + ISNULL(CAST(@AccessLevel AS VarChar), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID                        AS ErrorID,
   @ErrorDescription               AS ErrorDescription,
   @LockupMachine                  AS ShutDownFlag,
   CAST(@Balance * 100 AS Integer) AS Balance,
   @PromoBalance                   AS PromoBalance,
   @AccessLevel                    AS AccessLevel
GO
