SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpTransVC

Created 10-21-2004 by Terry Watkins

Purpose:
   Handles Voucher Created request which happens in response to a user pressing
   the Cash Out button on a machine.

Return value: None

Returned dataset: ErrorCode, ErrorDescription, ShutdownFlag

Called by: TransactionPortal

Parameters:
   @MachineNumber    The DGE machine number
   @TransAmt         The transaction amount in cents
   @MachineBalance   Balance in cents that the Machine is showing
   @CardAccount      Player Account number if present in the machine
   @IsJackpot        Flag indicating if voucher is for a jackpot


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
  Initial Coding

Terry Watkins 01-13-2005     v4.0.1
  Added code to update new MACHINE_METER table.  Required addition of new
  argument @IsJackpot.

A. Murthy     01-26-2005     v4.0.0
  For TITO set @CardAccount = 'INTERNAL'.

Terry Watkins 05-03-2005     v4.1.0
  Added CASINO_TRANS.TRANS_NO AS CasinoTransNo to the returned dataset.

Terry Watkins 06-15-2005     v4.1.4
  Changed size of @CardAccount from 16 to 20.

Terry Watkins 09-07-2005     v5.0.0
  Changed the value inserted into CASINO_TRANS.BALANCE to be the total of the
  account balance plus the promo balance.

Terry Watkins 09-07-2005     v5.0.1
  Fixed bug: When updating MACHINE_METER there was no WHERE clause so all
  rows were being updated.

   Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
   to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

Terry Watkins 10-04-2006     v5.0.8
  Removed @TicketStatusID. No longer needed because column
  CASINO_TRANS.TICKET_STATUS_ID has been removed.

  Added logic to retrieve the TRANS_NO of the play that fired the Voucher create
  process if @IsJackpot is set.

Terry Watkins 10-04-2006     v6.0.4
  Fixed last debug message: @JackpotTransNo was incorrectly labelled.

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
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
  
Louis Epstein 06-18-2014     v3.2.3
  Modified stat recording functionality to use tpUpdatePlayStatsHourlyAndDaily
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransVC]
   @MachineNumber       Char(5),
   @TransAmt            Int,
   @MachineBalance      Int,
   @CardAccount         VarChar(20),
   @IsJackpot           Bit,
   @TimeStamp DateTime
AS

-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @Balance           Money
DECLARE @Barcode           VarChar(20)
DECLARE @CardRequired      Bit
DECLARE @CasinoID          VarChar(6)
DECLARE @CasinoMachNo      VarChar(8)
DECLARE @CasinoTransID     Int
DECLARE @CoinsBet          Int
DECLARE @CTBalance         Money
DECLARE @DealNo            Int
DECLARE @Debug             Bit
DECLARE @ErrorID           Int
DECLARE @ErrorSource       VarChar(64)
DECLARE @ErrorText         VarChar(1024)
DECLARE @ErrorDescription  VarChar(256)
DECLARE @EventCode         VarChar(2)
DECLARE @EventLogDesc      VarChar(1024)
DECLARE @HourOfDay         Int
DECLARE @JackpotOutTotal   Money
DECLARE @JackpotOutCount   Int
DECLARE @JackpotTransNo    Int
DECLARE @LinesBet          Int
DECLARE @LocationID        Int
DECLARE @LockupMachine     Int
DECLARE @MachineBal        Money
DECLARE @MachGameCode      VarChar(3)
DECLARE @MachineMeterID    Int
DECLARE @MachNbrAsInt      Int
DECLARE @MachNo            VarChar(5)
DECLARE @MaxBalAdjust      Money
DECLARE @MinDate           DateTime
DECLARE @MsgText           VarChar(2048)
DECLARE @NewBalance        Money
DECLARE @PlayStatsHourlyID Int
DECLARE @PromoBalance      Money
DECLARE @RollNo            Int
DECLARE @TicketNo          Int
DECLARE @TicketOutCount    Int
DECLARE @TicketOutTotal    Money
DECLARE @TierLevel         SmallInt
DECLARE @MachineTimeStamp         DateTime
DECLARE @TransAmount       Money
DECLARE @TransID           SmallInt


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
SET @ErrorDescription = ''
SET @ErrorID          = 0
SET @ErrorSource      = 'tpTransVC Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'SP'
SET @JackpotTransNo   = 0
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
SET @TransID          = 22
SET @TimeStamp        = GetDate()

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransVC'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVC Arguments - MachineNumber: ' + @MachineNumber +
         '  TransAmt: ' + CAST(@TransAmt AS VarChar(10)) +
         '  MachineBalance: ' + CAST(@MachineBalance AS VarChar(10)) +
         '  CardAccount: ' + @CardAccount +
         '  IsJackpot: ' + CAST(@IsJackpot AS VarChar(2))
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
-- if the machine record was found in MACH_SETUP.
IF (@ErrorID <> 104)
   UPDATE MACH_SETUP SET
      LAST_ACTIVITY = @TimeStamp,
      @CasinoMachNo = CASINO_MACH_NO,
      @MachGameCode = GAME_CODE,
      @PromoBalance = PROMO_BALANCE,
      @Balance      = BALANCE
   WHERE
      MACH_NO = @MachineNumber

-- Did GetMachineStatus return an error?
IF (@ErrorID = 0)
   BEGIN
      -- No, so calculate what the new machine balance should be according to the DGE Backoffice.
      SET @NewBalance = @Balance - @TransAmount
      
      -- Compare calculated balance with what the Machine sent as the balance.
      IF (@MachineBal <> @NewBalance)
         -- Balance is off, set to 105 (Cardless locks machine, card required does not)
         BEGIN
            IF (@CardRequired = 0)
               SET @ErrorID = 105
            ELSE
               SET @ErrorID = 120
            -- In either case, set the error text...
            SET @ErrorText = ', Server balance: ' + CONVERT(VarChar(16), @Balance) +
                            ', Machine submitted: ' + CONVERT(VarChar(16), @MachineBal)
         END
   END

-- Handle any error condition...
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = [DESCRIPTION],
         @LockupMachine    = LOCKUP_MACHINE
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
      SET @EventLogDesc = 'Description: '      + @ErrorDescription +
                          ', Card Account: '   + @CardAccount   +
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

-- Update MACHINE_STATS and MACH_SETUP tables...
IF (@ErrorID = 0)
   BEGIN
      
      EXEC tpUpdatePlayStatsHourlyAndDaily 
      @LocationIdPass = @LocationID, 
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AcctDate,
@DealNoPass = @DealNo,
@GameCodePass = @MachGameCode,
@TicketOutCountPass = 1,
@TicketOutAmountPass = @TransAmount

      
      -- Update the BALANCE in the MACH_SETUP table.
      UPDATE MACH_SETUP SET BALANCE = @NewBalance WHERE MACH_NO = @MachineNumber

      -- Update the MACHINE_METER table...
      -- First retrieve data for the specified machine.
      SELECT
         @MachineMeterID  = ISNULL(MACHINE_METER_ID, 0),
         @TicketOutCount  = ISNULL(TICKET_OUT_COUNT, 0),
         @TicketOutTotal  = ISNULL(TICKET_OUT_TOTAL, 0),
         @JackpotOutTotal = ISNULL(JACKPOT_TICKET_OUT, 0),
         @JackpotOutCount = ISNULL(JACKPOT_TICKET_COUNT, 0)
      FROM MACHINE_METER
      WHERE MACH_NO = @MachineNumber
      
      IF (@MachineMeterID = 0)
         -- Row was not found, create a new row...
         BEGIN
            -- Is this a jackpot voucher?
            IF (@IsJackpot = 1)
               -- Yes, so set jackpot related counters.
               BEGIN
                  SET @JackpotOutCount = 1
                  SET @JackpotOutTotal = @TransAmount
               END
            ELSE
               -- No, so insert values of zero into jackpot related counters.
               BEGIN
                  SET @JackpotOutCount = 0
                  SET @JackpotOutTotal = 0
               END
            
            -- Perform the row insertion.
            INSERT INTO MACHINE_METER
               (MACH_NO, TICKET_OUT_TOTAL, TICKET_OUT_COUNT, JACKPOT_TICKET_OUT, JACKPOT_TICKET_COUNT)
            VALUES
               (@MachineNumber, @TransAmount, 1, @JackpotOutTotal, @JackpotOutCount)
         END
      ELSE
         -- MACHINE_METER row was found, so update it...
         BEGIN
            -- Is this a jackpot voucher?
            IF (@IsJackpot = 1)
               -- Yes, so increment the jackpot related values...
               BEGIN
                  SET @JackpotOutCount = @JackpotOutCount + 1
                  SET @JackpotOutTotal = @JackpotOutTotal + @TransAmount
               END
            
            -- Perform the update.
            UPDATE MACHINE_METER SET
               TICKET_OUT_COUNT = TICKET_OUT_COUNT + 1,
               TICKET_OUT_TOTAL = TICKET_OUT_TOTAL + @TransAmount,
               JACKPOT_TICKET_OUT = @JackpotOutTotal,
               JACKPOT_TICKET_COUNT = @JackpotOutCount
            WHERE MACH_NO = @MachineNumber
         END
      
      
   END

-- Calculate the CASINO_TRANS balance as the account plus promo balances.
SET @CTBalance = @NewBalance + @PromoBalance

-- Log transaction.
EXEC @CasinoTransID = tpInsertCasinoTrans
   @CasinoID, @DealNo, @RollNo, @TicketNo, 0, @TransAmount, @Barcode,
   @TransID, @AcctDate, @TimeStamp, @MachineNumber, @CardAccount, @CTBalance,
   @MachGameCode, @CoinsBet, @LinesBet, @TierLevel, 0, @LocationID, @MachineTimeStamp

-- Did we get a balance error in Cardless Play mode?
IF (@ErrorID = 105)
   BEGIN
      -- Is the difference <= adjustment threshold?
      IF ((@MachineBal - @Balance) <= @MaxBalAdjust)
         BEGIN
            -- Yes, so we need to adjust the machine balance...
            EXEC tpAdjustMachineBalance
               @MachineNumber, @CardRequired, @MachineBal, @Balance, 'tpTransVC',
               @MachineTimeStamp, @CasinoID, @AcctDate, @MachGameCode, @LocationID
         END
      ELSE
         -- The difference exceeds the max adjustment value, force a lockup.
         BEGIN
            SET @LockupMachine = 1
         END
   END

-- If the Jackpot flag is set, retrieve the TRANS_NO of the actual play transaction.
IF (@IsJackpot = 1)
   BEGIN
      SET @MinDate = DATEADD(Day, -1, @TimeStamp)
      
      SELECT @JackpotTransNo = MAX(TRANS_NO)
      FROM JACKPOT
      WHERE
         MACH_NO     = @MachineNumber AND
         TRANS_AMT   = @TransAmount   AND
         DTIMESTAMP >= @MinDate
      
      -- Make sure we don't return null.
      IF @JackpotTransNo IS NULL SET @JackpotTransNo = 0
   END

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVC Return Values - ErrorID: ' + CAST(@ErrorID AS VarChar) +
         '  ErrorDescription: ' + @ErrorDescription +
         '  LockupMachine: '    + CAST(@LockupMachine AS VarChar) +
         '  CasinoTransID: '    + CAST(@CasinoTransID AS VarChar) +
         '  JackpotTransNo: '   + CAST(@JackpotTransNo AS VarChar)
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @CasinoTransID    AS CasinoTransNo,
   @JackpotTransNo   AS JackpotTransNo
GO
