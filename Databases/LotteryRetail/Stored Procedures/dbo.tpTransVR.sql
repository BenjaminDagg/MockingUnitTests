SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpTransVR

Created 10-21-2004 by Terry Watkins

Purpose:
   Handles Voucher Redeemed request which happens in response to a user
   inserting a voucher into a machine.

Return value: None

Returned dataset: ErrorCode, ErrorDescription, ShutdownFlag, CasinoTransID

Called by: TransactionPortal

Parameters:
   @MachineNumber       The DGE machine number
   @TransAmt            The transaction amount in cents
   @MachineBalance      The new balance in cents sent from the Machine to the TP
   @CardAccount         Player Account number if present in the machine


Note: This procedure makes the assumption that it will only be called while in
      Cardless Play mode (CASINO.PLAYER_CARD = 0) and retrieves that Balance
      from the MACH_SETUP table.  If we ever need to support Card Required mode
      (CASINO.PLAYER_CARD = 1), then the balance will need to be retrieved from
      the CARD_ACCT table.


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-01-2004     v4.0.0
  Initial coding.

Terry Watkins 01-13-2005     v4.0.1
  Added code to update new MACHINE_METER table.

A. Murthy     01-26-2005     v4.0.0
  For TITO set @CardAccount = 'INTERNAL'.

Terry Watkins 05-03-2005     v4.1.0
  Added CASINO_TRANS.TRANS_NO AS CasinoTransNo to the returned dataset.

Terry Watkins 06-15-2005     v4.1.4
  Changed size of @CardAccount from 16 to 20.

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
  Added insertion into (or updating of) table PLAY_STATS_HOURLY.

Terry Watkins 11-11-2010     LotteryRetail v3.0.4
  Added use of named parameters when calling tpInsertCasinoTrans.  This fixes a
  bug that caused the LocationID to be inserted into the PressUpCount column.
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
  
Louis Epstein 06-18-2014     v3.2.3
  Modified stat recording functionality to use tpUpdatePlayStatsHourlyAndDaily
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransVR]
   @MachineNumber       Char(5),
   @TransAmt            Int,
   @MachineBalance      Int,
   @CardAccount         VarChar(20),
   @TimeStamp DateTime
AS

-- Variable Declarations
DECLARE @AcctDate           DateTime
DECLARE @Balance            Money
DECLARE @Barcode            VarChar(20)
DECLARE @CardRequired       Bit
DECLARE @CasinoID           VarChar(6)
DECLARE @CasinoMachNo       VarChar(8)
DECLARE @CasinoTransID      Int
DECLARE @CoinsBet           Int
DECLARE @CTBalance          Money
DECLARE @DealNo             Int
DECLARE @Debug              Bit
DECLARE @ErrorID            Int
DECLARE @ErrorSource        VarChar(64)
DECLARE @ErrorText          VarChar(1024)
DECLARE @ErrorDescription   VarChar(256)
DECLARE @EventCode          VarChar(2)
DECLARE @EventLogDesc       VarChar(1024)
DECLARE @HourOfDay          Int
DECLARE @LinesBet           Int
DECLARE @LocationID         Int
DECLARE @LockupMachine      Int
DECLARE @MachineBal         Money
DECLARE @MachGameCode       VarChar(3)
DECLARE @MachNbrAsInt       Int
DECLARE @MachNo             VarChar(5)
DECLARE @MaxBalAdjust       Money
DECLARE @MsgText            VarChar(2048)
DECLARE @NewBalance         Money
DECLARE @PlayStatsHourlyID  Int
DECLARE @PromoBalance       Money
DECLARE @RollNo             Int
DECLARE @TicketNo           Int
DECLARE @TierLevel          SmallInt
DECLARE @MachineTimeStamp   DateTime
DECLARE @TransAmount        Money
DECLARE @TransID            SmallInt

SET NOCOUNT ON

-- Variable Initialization
SET @MachineTimeStamp = @TimeStamp
SET @Balance          = 0
SET @Barcode          = ''
SET @CardRequired     = 1
SET @CasinoMachNo     = ''
SET @CoinsBet         = 0
SET @CTBalance        = 0
SET @DealNo           = 0
SET @ErrorID          = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpTransVR Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'SP'
SET @LinesBet         = 0
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachineBal       = CAST(@MachineBalance AS Money) / 100
SET @MachGameCode     = ''
SET @MachNbrAsInt     = CAST(@MachineNumber AS Int)
SET @PromoBalance     = 0
SET @RollNo           = 0
SET @TicketNo         = 0
SET @TierLevel        = 0
SET @TransAmount      = CAST(@TransAmt AS Money) / 100
SET @TransID          = 21
SET @TimeStamp        = GetDate()

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransVR'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVR Arguments - MachineNumber: ' + @MachineNumber +
         '  TransAmt: ' + CAST(@TransAmt AS VarChar(10)) +
         '  MachineBalance: ' + CAST(@MachineBalance AS VarChar(10)) +
         '  CardAccount: ' + @CardAccount
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve Casino Information.
SELECT
   @CasinoID     = CAS_ID,
   @CardRequired = PLAYER_CARD,
   @MaxBalAdjust = MAX_BAL_ADJUSTMENT,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- If @CardRequired is 0 (TITO), set @CardAccount to 'INTERNAL'
IF (@CardRequired = 0)
   SET @CardAccount = 'INTERNAL'

-- Get Current Accounting Date and hour of the day...
SET @AcctDate  = dbo.ufnGetAcctDate()
SET @HourOfDay = dbo.ufnCurrentHour()

-- Call GetMachineStatus function (checks for Machine not found, inactive, or removed).
SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

IF (@Debug = 1)
   BEGIN
      SET @MsgText = 'GetMachineStatus returned @ErrorID = ' + CAST(@ErrorID AS VarChar)
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Set last activity and retrieve Casino Machine Number and the Game Code of the machine
-- if the Machine record was found in MACH_SETUP.
IF (@ErrorID <> 104)
   BEGIN
      UPDATE MACH_SETUP SET
         LAST_ACTIVITY = @TimeStamp,
         @CasinoMachNo = CASINO_MACH_NO,
         @MachGameCode = GAME_CODE,
         @PromoBalance = PROMO_BALANCE,
         @Balance      = BALANCE
      WHERE
         MACH_NO = @MachineNumber
      
      -- Calculate what the new balance should be:
      -- (Add the transaction amount to the balance from MACH_SETUP).
      SET @NewBalance = @Balance + @TransAmount

      -- If no errors so far, set bad balance error if machine and system do not agree...
      IF (@ErrorID = 0 AND @MachineBal <> @NewBalance)
         BEGIN
            -- The new calculated balance does not agree with the balance sent from the machine.
            -- If in Cardless Play mode set 105 (no lockup) otherwise 120 (locks up machine).
            IF (@CardRequired = 0)
               SET @ErrorID = 105
            ELSE
               SET @ErrorID = 120
            -- Set the error text...
            SET @ErrorText = ', Server balance: ' + CONVERT(VarChar(16), @Balance) +
                             ', Machine submitted: ' + CONVERT(VarChar(16), @MachineBal)
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
                          ', Card Account: ' + @CardAccount +
                          ', Machine Number: ' + @MachineNumber + @ErrorText
      
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

-- Any errors encountered?
IF (@ErrorID = 0)
   -- No, so update MACHINE_STATS.TICKET_IN_COUNT & TICKET_IN_AMOUNT and MACH_SETUP.BALANCE columns...
   BEGIN
      
      EXEC tpUpdatePlayStatsHourlyAndDaily 
@LocationIdPass = @LocationID,
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AcctDate,
@DealNoPass = @DealNo,
@GameCodePass = @MachGameCode,
@TicketInCountPass = 1,
@TicketInAmountPass = @TransAmount

      
      -- Reset the BALANCE in the MACH_SETUP table.
      UPDATE MACH_SETUP SET BALANCE = @NewBalance WHERE MACH_NO = @MachineNumber
      
      -- Attempt to update the MACHINE_METER table.
      UPDATE MACHINE_METER SET
         TICKET_IN_COUNT = TICKET_IN_COUNT + 1,
         TICKET_IN_TOTAL = TICKET_IN_TOTAL + @TransAmount
      WHERE MACH_NO = @MachineNumber
      
      -- If no rows were modified, the record doesn't exist - so create it.
      IF (@@ROWCOUNT = 0)
         BEGIN
            INSERT INTO MACHINE_METER
               (MACH_NO, TICKET_IN_COUNT, TICKET_IN_TOTAL)
            VALUES
               (@MachineNumber, 1, @TransAmount)
         END
END

-- Calculate the CASINO_TRANS balance as the account plus promo balances.
SET @CTBalance = @NewBalance + @PromoBalance

-- Log transaction.
EXEC @CasinoTransID = tpInsertCasinoTrans
   @CasinoID        = @CasinoID,
   @DealNo          = @DealNo,
   @RollNo          = @RollNo,
   @TicketNo        = @TicketNo,
   @Denom           = 0,
   @TransAmt        = @TransAmount,
   @Barcode         = @Barcode,
   @TransID         = @TransID,
   @CurrentAcctDate = @AcctDate,
   @TimeStamp       = @TimeStamp,
   @MachineNumber   = @MachineNumber,
   @CardAccount     = @CardAccount,
   @Balance         = @CTBalance,
   @GameCode        = @MachGameCode,
   @CoinsBet        = @CoinsBet,
   @LinesBet        = @LinesBet,
   @TierLevel       = @TierLevel,
   @PressUpCount    = 0,
   @LocationID      = @LocationID,
   @MachineTimeStamp = @MachineTimeStamp

-- Did we get a balance error in Cardless Play mode?
IF (@ErrorID = 105)
   BEGIN
      -- Is the difference <= adjustment threshold?
      IF ((@MachineBal - @Balance) <= @MaxBalAdjust)
         BEGIN
            -- Yes, so we need to adjust the machine balance...
            EXEC tpAdjustMachineBalance
               @MachineNumber, @CardRequired, @MachineBal, @Balance, 'tpTransVR',
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
         'tpTransVR Return Values - ErrorID: ' + CAST(@ErrorID AS VarChar(10)) +
         '  ErrorDescription: ' + @ErrorDescription +
         '  LockupMachine: ' + CAST(@LockupMachine AS VarChar(10))
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @CasinoTransID    AS CasinoTransNo
GO
