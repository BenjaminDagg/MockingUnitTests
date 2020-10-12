SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpTransVPV (tpTrans Voucher PreValidation)

Created 10-28-2004 by Terry Watkins


Purpose:
   Prevalidates the machine and balance before tpTransVC or tpTransVR are called.

Return value:
   None

Returned dataset:
   ErrorCode, ErrorDescription, ShutdownFlag


Called by: TransactionPortal


Parameters:
   @MachineNumber    The DGE machine number
   @MachineBalance   Balance in cents that the Machine is showing
                        For 'VC' send machine balance prior to adjusting for cashout
                        For 'VR' send machine balance prior to adjusting for voucher amount
   @TransType        'VC' or 'VR' to indicate the trans type being processed
   @TransAmt         Transaction amount in cents (used for VC only, 0 when VR)


Note: This procedure makes the assumption that it will only be called while in
      Cardless Play mode (CASINO.PLAYER_CARD = 0) and retrieves that Balance
      from the MACH_SETUP table.  If we ever need to support Card Required mode
      (CASINO.PLAYER_CARD = 1), then the balance will need to be retrieved from
      the CARD_ACCT table.  This will require that the Card Account number be
      passed to this routine in a new argument.


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-01-2004     v4.0.0
  Initial coding

Terry Watkins 01-12-2005     v4.0.1
  Modified to insert a row in CASINO_TRANS when @TransType is VC.

Terry Watkins 09-07-2005     v5.0.0
  Changed the value inserted into CASINO_TRANS.BALANCE to be the total of the
  account balance plus the promo balance.

A. Murthy     01-16-2006     v5.0.1
   Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
   to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

Terry Watkins 10-04-2006     v5.0.8
  Removed @TicketStatusID. No longer needed because column
  CASINO_TRANS.TICKET_STATUS_ID has been removed.

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
CREATE PROCEDURE [dbo].[tpTransVPV]
   @MachineNumber       Char(5),
   @MachineBalance      Int,
   @TransType           VarChar(8),
   @TransAmt            Int,
   @TimeStamp           DateTime
AS

-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @Balance           Money
DECLARE @CardRequired      Bit
DECLARE @CasinoID          VarChar(6)
DECLARE @CasinoTransID     Int
DECLARE @CTBalance         Money
DECLARE @Debug             Bit
DECLARE @ErrorID           Int
DECLARE @ErrorSource       VarChar(64)
DECLARE @ErrorText         VarChar(1024)
DECLARE @ErrorDescription  VarChar(256)
DECLARE @EventCode         VarChar(2)
DECLARE @EventLogDesc  VarChar(1024)
DECLARE @IsActive          TinyInt
DECLARE @IsRemoved         Bit
DECLARE @LocationID        Int
DECLARE @LockupMachine     Int
DECLARE @MachGameCode      Char(3)
DECLARE @MachineBal        Money
DECLARE @MachNbrAsInt      Int
DECLARE @MaxBalAdjust      Money
DECLARE @MsgText           VarChar(2048)
DECLARE @NewBalance        Money
DECLARE @PromoBalance      Money
DECLARE @MachineTimeStamp  DateTime
DECLARE @TransAmount       Money
DECLARE @TransID           SmallInt

SET NOCOUNT ON

-- Variable Initialization
SET @MachineTimeStamp = @TimeStamp
SET @Balance          = 0
SET @CTBalance        = 0
SET @ErrorDescription = ''
SET @ErrorID          = 0
SET @ErrorSource      = 'tpTransVPV Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'SP'
SET @IsActive         = 1
SET @IsRemoved        = 0
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachGameCode     = ''
SET @MachineBal       = CAST(@MachineBalance AS Money) / 100
SET @MachNbrAsInt     = CAST(@MachineNumber AS Int)
SET @NewBalance       = 0
SET @PromoBalance     = 0
SET @TransAmount      = CAST(@TransAmt AS Money) / 100
SET @TransID          = 26
SET @TimeStamp        = GetDate()

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransVPV'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVPV Arguments - MachineNumber: ' + @MachineNumber +
         '  MachineBalance: ' + CAST(@MachineBalance AS VarChar(12)) +
         '  TransType: ' + @TransType +
         '  TransAmt: ' + CAST(@TransAmt AS VarChar(12))
         
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve CASINO information.
SELECT
   @CasinoID     = CAS_ID,
   @CardRequired = PLAYER_CARD,
   @MaxBalAdjust = MAX_BAL_ADJUSTMENT,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Call GetMachineStatus function (checks for Machine not found, inactive, or removed).
SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

IF (@Debug = 1)
   BEGIN
      SET @MsgText = 'GetMachineStatus returned: ' + CAST(@ErrorID AS VarChar)
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Set last activity and retrieve the Machine Balance if the machine record exists in MACH_SETUP.
IF (@ErrorID <> 104)
   UPDATE MACH_SETUP SET
      LAST_ACTIVITY = @TimeStamp,
      @Balance      = BALANCE,
      @PromoBalance = PROMO_BALANCE,
      @MachGameCode = GAME_CODE
   WHERE
      MACH_NO = @MachineNumber

-- Test that machine exists in the MACH_SETUP table.
IF (@ErrorID = 0)
   -- Machine exists and is Active and not flagged as Removed...
   BEGIN
      IF (@Balance <> @MachineBal)
         BEGIN
            -- Machine balance does not equal the balance from MACH_SETUP.
            IF (@CardRequired = 0)
               BEGIN
                  SET @ErrorID = 105
               END
            ELSE
               BEGIN
                  SET @ErrorID = 120
               END
            
            -- Set error test.
            SET @ErrorText = '. Sys Balance: ' + CAST(@Balance AS VarChar) +
                             ' Mach Balance: ' + CAST(@MachineBal AS VarChar)
         END
   END

-- Test that the transaction amount is not greater than the machine balance.
IF (@ErrorID = 0)
   -- No errors so far.
   BEGIN
      IF (@TransType = 'VC' AND @TransAmt > @MachineBalance)
         BEGIN
            -- Transaction amount is greater than machine balance
            SET @ErrorID = 130
            SET @ErrorText = '. Trans Amt: ' + CAST(@TransAmount AS VarChar) +
                           ' Mach Balance: ' + CAST(@MachineBal AS VarChar)
         END
   END

-- Handle any errorsIF (@ErrorID > 0)
   BEGIN
      IF (@ErrorID > 0)
         BEGIN
            SELECT
               @ErrorDescription = [DESCRIPTION],               @LockupMachine    = LOCKUP_MACHINE
            FROM ERROR_LOOKUP
            WHERE ERROR_NO = @ErrorID
            
            IF (@@ROWCOUNT = 0)
               -- ERROR_LOOKUP row not found.
               BEGIN
                  SET @LockupMachine = 1
                  SET @ErrorDescription = 'Undefined Error (Error: '
                  IF (@ErrorID IS NULL)
                     SET @ErrorDescription = @ErrorDescription + 'NULL)'
                  ELSE
                     SET @ErrorDescription = @ErrorDescription + CAST(@ErrorID AS VarChar) + ')'
               END
            
            -- If in Cardless Play mode, reset error text.
            IF (@CardRequired = 0)
               SET @ErrorDescription = dbo.CardlessErrorText(@ErrorDescription)
            
            -- Build Error Message
            SET @EventLogDesc = 'Description:' + @ErrorDescription + 
                                ', Machine Number:' + @MachineNumber + @ErrorText
            
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
         END
   END

-- Did we get a balance error in Cardless Play mode?
IF (@ErrorID = 105)
   BEGIN
      -- Is the difference <= adjustment threshold?
      IF ((@MachineBal - @Balance) <= @MaxBalAdjust)
         BEGIN
            -- Yes, so we need to adjust the machine balance...
            EXEC tpAdjustMachineBalance
               @MachineNumber, @CardRequired, @MachineBal, @Balance, 'tpTransVPV',
               @MachineTimeStamp, @CasinoID, @AcctDate, @MachGameCode, @LocationID
         END
      ELSE
         -- The difference exceeds the max adjustment value, force a lockup.
         BEGIN
            SET @LockupMachine = 1
         END
   END

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVPV Return Values - ErrorID: ' + CAST(ISNULL(@ErrorID, 0) AS VarChar(10)) +
         '  ErrorDescription: ' + @ErrorDescription +
         '  LockupMachine: ' + CAST(@LockupMachine AS VarChar(10))
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Are we in Voucher Create mode?
IF (@TransType = 'VC')
   -- Yes, so insert a CASINO_TRANS row to record the request.
   BEGIN
      -- Calculate the CASINO_TRANS balance as the account plus promo balances.
      SET @CTBalance = @Balance + @PromoBalance
      
      -- Perform the insert...
      EXEC @CasinoTransID = tpInsertCasinoTrans
         @CasinoID        = @CasinoID,
         @DealNo          = 0,
         @RollNo          = 0,
         @TicketNo        = 0,
         @Denom           = 0,
         @TransAmt        = @TransAmount,
         @Barcode         = '',
         @TransID         = 29,
         @CurrentAcctDate = @AcctDate,
         @TimeStamp       = @TimeStamp,
         @MachineNumber   = @MachineNumber,
         @CardAccount     = 'INTERNAL',
         @Balance         = @CTBalance,
         @GameCode        = @MachGameCode,
         @CoinsBet        = 0,
         @LinesBet        = 0,
         @TierLevel       = 0,
         @PressUpCount    = 0,
         @LocationID      = @LocationID,
         @MachineTimeStamp = @MachineTimeStamp
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,   @LockupMachine    AS ShutDownFlag
GO
