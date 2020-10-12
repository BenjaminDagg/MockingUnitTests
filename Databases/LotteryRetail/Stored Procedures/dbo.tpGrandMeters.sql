SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpGrandMeters

Purpose: Handles storage of BMM meters sent from machine.

Return Dataset: ErrorID, ErrorDescription, ShutDownFlag.

Called by: TpiClient.vb\HandleTransaction

Arguments:
   32 parms. of Meter Information.

Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy      02-24-2006    5.0.2
  Initial Version.

A. Murthy      11-14-2006    5.0.8
  Added 2 new input parms "CancelledCreditOut/Count" for SDG CancelledCredits processing.

Terry Watkins 11-04-2009     v7.0.0
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AcctDate changed from VarChar(16) to DateTime.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGrandMeters]
   @MachineNumber            VarChar(5),
   @GamesPlayed              BigInt,
   @MoneyIn                  BigInt,
   @MoneyPlayed              BigInt,
   @TotalPrizes              BigInt,
   @CreditBalance            BigInt,
   @BillsCount               BigInt,
   @Bills1                   BigInt,
   @Bills2                   BigInt,
   @Bills5                   BigInt,
   @Bills10                  BigInt,
   @Bills20                  BigInt,
   @Bills50                  BigInt,
   @Bills100                 BigInt,
   @BillsOther               BigInt,
   @TicketIn                 BigInt,
   @TicketInCount            BigInt,
   @TicketOut                BigInt,
   @TicketOutCount           BigInt,
   @HandPayOut               BigInt,
   @HandPayCount             BigInt,
   @ProgressiveContributions BigInt,
   @ProgressiveAwards        BigInt,
   @JackpotOut               BigInt,
   @JackpotCount             BigInt,
   @PromoIn                  BigInt,
   @PromoInCount             BigInt,
   @CabinetDoorOpen          BigInt,
   @BillDoorOpen             BigInt,
   @PowerCycle               BigInt,
   @CabinetBaseDoorOpen      Int,
   @LogicDoorOpen            Int,
   @ProgressiveCount         BigInt,
   @CancelledCreditOut       BigInt,
   @CancelledCreditCount     BigInt
AS

-- Variable Declarations
DECLARE @AcctDate                      DateTime
DECLARE @AmountInMoney                 Money
DECLARE @AmountPlayedMoney             Money
DECLARE @CancelledCreditOutMoney       Money
DECLARE @CasinoMachNo                  VarChar(8)
DECLARE @CreditBalanceMoney            Money
DECLARE @Debug                         Bit
DECLARE @ErrorDescription              VarChar(256)
DECLARE @ErrorID                       Int
DECLARE @ErrorSource                   VarChar(64)
DECLARE @ErrorText                     VarChar(1024)
DECLARE @EventCode                     VarChar(2)
DECLARE @EventLogDesc                  VarChar(1024)
DECLARE @HandpayOutAmountMoney         Money
DECLARE @JackpotOutAmountMoney         Money
DECLARE @LockupMachine                 Int
DECLARE @MachNbrAsInt                  Int
DECLARE @MsgText                       VarChar(1024)
DECLARE @ProgressiveAwardsMoney        Money
DECLARE @ProgressiveContributionsMoney Money
DECLARE @PromoInAmountMoney            Money
DECLARE @TicketInAmountMoney           Money
DECLARE @TicketOutAmountMoney          Money
DECLARE @TimeStamp                     DateTime
DECLARE @TotalPrizesMoney              Money
DECLARE @TransID                       SmallInt

SET NOCOUNT ON

-- Variable Initialization
SET @AmountInMoney                    = CAST(@MoneyIn AS Money) / 100
SET @AmountPlayedMoney                = CAST(@MoneyPlayed AS Money) / 100
SET @CancelledCreditOutMoney          = CAST(@CancelledCreditOut AS Money) / 100
SET @CasinoMachNo                     = ''
SET @CreditBalanceMoney               = CAST(@CreditBalance AS Money) / 100
SET @ErrorID                          = 0
SET @ErrorDescription                 = ''
SET @ErrorSource                      = 'tpGrandMeters Stored Procedure'
SET @ErrorText                        = ''
SET @EventCode                        = 'SP'
SET @HandpayOutAmountMoney            = CAST(@HandpayOut AS Money) / 100
SET @JackpotOutAmountMoney            = CAST(@JackpotOut AS Money) / 100
SET @LockupMachine                    = 0
SET @MachNbrAsInt                     = CAST(@MachineNumber AS Int)
SET @ProgressiveAwardsMoney           = CAST(@ProgressiveAwards AS Money) / 100
SET @ProgressiveContributionsMoney    = CAST(@ProgressiveContributions AS Money) / 100
SET @PromoInAmountMoney               = CAST(@PromoIn AS Money) / 100
SET @TimeStamp                        = GetDate()
SET @TicketInAmountMoney              = CAST(@TicketIn AS Money) / 100
SET @TicketOutAmountMoney             = CAST(@TicketOut AS Money) / 100
SET @TotalPrizesMoney                 = CAST(@TotalPrizes AS Money) / 100
SET @TransID                          = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpGrandMeters'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpGrandMeters Argument Values:  ' + 
         '  MachineNumber: '        + ISNULL(@MachineNumber, '<null>') +
         '  GamesPlayed: '          + ISNULL(CAST(@GamesPlayed AS VarChar), '<null>') +
         '  MoneyIn: '              + ISNULL(CAST(@MoneyIn AS VarChar), '<null>') +
         '  MoneyPlayed: '          + ISNULL(CAST(@MoneyPlayed AS VarChar), '<null>') +
         '  TotalPrizes: '          + ISNULL(CAST(@TotalPrizes AS VarChar), '<null>') +
         '  CreditBalance: '        + ISNULL(CAST(@CreditBalance AS VarChar), '<null>') +
         '  BillsCount: '           + ISNULL(CAST(@BillsCount AS VarChar), '<null>') +
         '  Bills1: '               + ISNULL(CAST(@Bills1 AS VarChar), '<null>') +
         '  Bills2: '               + ISNULL(CAST(@Bills2 AS VarChar), '<null>') +
         '  Bills5: '               + ISNULL(CAST(@Bills5 AS VarChar), '<null>') +
         '  Bills10: '              + ISNULL(CAST(@Bills10 AS VarChar), '<null>') +
         '  Bills20: '              + ISNULL(CAST(@Bills20 AS VarChar), '<null>') +
         '  Bills50: '              + ISNULL(CAST(@Bills50 AS VarChar), '<null>') +
         '  Bills100: '             + ISNULL(CAST(@Bills100 AS VarChar), '<null>') +
         '  BillsOther: '           + ISNULL(CAST(@BillsOther AS VarChar), '<null>') +
         '  TicketIn: '             + ISNULL(CAST(@TicketIn AS VarChar), '<null>') +
         '  TicketInCount: '        + ISNULL(CAST(@TicketInCount AS VarChar), '<null>') +
         '  TicketOut: '            + ISNULL(CAST(@TicketOut AS VarChar), '<null>') +
         '  TicketOutCount: '       + ISNULL(CAST(@TicketOutCount AS VarChar), '<null>') +
         '  HandPayOut: '           + ISNULL(CAST(@HandPayOut AS VarChar), '<null>') +
         '  HandPayCount: '         + ISNULL(CAST(@HandPayCount AS VarChar), '<null>') +
         '  ProgressiveContributions: '  + ISNULL(CAST(@ProgressiveContributions AS VarChar), '<null>') +
         '  ProgressiveAwards: '           + ISNULL(CAST(@ProgressiveAwards AS VarChar), '<null>') +
         '  JackpotOut: '           + ISNULL(CAST(@JackpotOut AS VarChar), '<null>') +
         '  JackpotCount: '         + ISNULL(CAST(@JackpotCount AS VarChar), '<null>') +
         '  PromoIn: '              + ISNULL(CAST(@PromoIn AS VarChar), '<null>') +
         '  PromoInCount: '         + ISNULL(CAST(@PromoInCount AS VarChar), '<null>') +
         '  CabinetDoorOpen: '      + ISNULL(CAST(@CabinetDoorOpen AS VarChar), '<null>') +
         '  BillDoorOpen: '         + ISNULL(CAST(@BillDoorOpen AS VarChar), '<null>') +
         '  PowerCycle: '           + ISNULL(CAST(@PowerCycle AS VarChar), '<null>') +
         '  CabinetBaseDoorOpen: '  + ISNULL(CAST(@CabinetBaseDoorOpen AS VarChar), '<null>') +
         '  LogicDoorOpen: '        + ISNULL(CAST(@LogicDoorOpen AS VarChar), '<null>') +
         '  ProgressiveCount: '     + ISNULL(CAST(@ProgressiveCount AS VarChar), '<null>') +
         '  CancelledCreditOut: '   + ISNULL(CAST(@CancelledCreditOut AS VarChar), '<null>') +
         '  CancelledCreditCount: ' + ISNULL(CAST(@CancelledCreditCount AS VarChar), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Get the Casino Machine Number.
SELECT @CasinoMachNo = CASINO_MACH_NO FROM MACH_SETUP WHERE MACH_NO = @MachineNumber

-- Attempt to update the GRAND_METER table for this MachNo, CasinoMachNo & this AccountingDate
UPDATE GRAND_METER SET
         PLAY_COUNT                 = @GamesPlayed,
         AMOUNT_IN                  = @AmountInMoney,
         AMOUNT_PLAYED              = @AmountPlayedMoney,
         TOTAL_PRIZES               = @TotalPrizesMoney,
         CREDIT_BALANCE             = @CreditBalanceMoney,
         BILL_COUNT                 = @BillsCount,
         BILL_COUNT_1               = @Bills1,
         BILL_COUNT_2               = @Bills2,
         BILL_COUNT_5               = @Bills5,
         BILL_COUNT_10              = @Bills10,
         BILL_COUNT_20              = @Bills20,
         BILL_COUNT_50              = @Bills50,
         BILL_COUNT_100             = @Bills100,
         BILL_COUNT_OTHER           = @BillsOther,
         TICKET_IN_AMOUNT           = @TicketInAmountMoney,
         TICKET_IN_COUNT            = @TicketInCount,
         TICKET_OUT_AMOUNT          = @TicketOutAmountMoney,
         TICKET_OUT_COUNT           = @TicketOutCount,
         HANDPAY_OUT_AMOUNT         = @HandPayOutAmountMoney,
         HANDPAY_COUNT              = @HandpayCount,
         PROGRESSIVE_CONTRIBUTIONS  = @ProgressiveContributionsMoney,
         PROGRESSIVE_AWARDS         = @ProgressiveAwardsMoney,
         JACKPOT_OUT_AMOUNT         = @JackpotOutAmountMoney,
         JACKPOT_COUNT              = @JackpotCount,
         PROMO_IN_AMOUNT            = @PromoInAmountMoney,
         PROMO_IN_COUNT             = @PromoInCount,
         CABINET_DOOR_OPEN          = @CabinetDoorOpen,
         BILL_DOOR_OPEN             = @BillDoorOpen,
         POWER_CYCLE                = @PowerCycle,
         CABINET_BASE_DOOR_OPEN     = @CabinetBaseDoorOpen,
         LOGIC_DOOR_OPEN            = @LogicDoorOpen,
         PROGRESSIVE_COUNT          = @ProgressiveCount,
         CANCELLED_CREDIT_OUT       = @CancelledCreditOutMoney,
         CANCELLED_CREDIT_COUNT     = @CancelledCreditCount
      WHERE
         MACH_NO        = @MachineNumber  AND
         CASINO_MACH_NO = @CasinoMachNo   AND
         ACCT_DATE      = @AcctDate

-- If no rows were modified, the record doesn't exist - so create it.
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO GRAND_METER
         (MACH_NO, CASINO_MACH_NO, ACCT_DATE, PLAY_COUNT, AMOUNT_IN, AMOUNT_PLAYED, TOTAL_PRIZES, CREDIT_BALANCE, 
          BILL_COUNT, BILL_COUNT_1, BILL_COUNT_2, BILL_COUNT_5, BILL_COUNT_10, BILL_COUNT_20, BILL_COUNT_50, BILL_COUNT_100, BILL_COUNT_OTHER,
          TICKET_IN_AMOUNT, TICKET_IN_COUNT, TICKET_OUT_AMOUNT, TICKET_OUT_COUNT, HANDPAY_OUT_AMOUNT, HANDPAY_COUNT,
          PROGRESSIVE_CONTRIBUTIONS, PROGRESSIVE_AWARDS, JACKPOT_OUT_AMOUNT, JACKPOT_COUNT, PROMO_IN_AMOUNT, PROMO_IN_COUNT,
          CABINET_DOOR_OPEN, BILL_DOOR_OPEN, POWER_CYCLE, CABINET_BASE_DOOR_OPEN, LOGIC_DOOR_OPEN, PROGRESSIVE_COUNT,
          CANCELLED_CREDIT_OUT, CANCELLED_CREDIT_COUNT)
      VALUES
         (@MachineNumber, @CasinoMachNo, @AcctDate, @GamesPlayed, @AmountInMoney, @AmountPlayedMoney, @TotalPrizesMoney, @CreditBalanceMoney,
          @BillsCount, @Bills1, @Bills2, @Bills5, @Bills10, @Bills20, @Bills50, @Bills100, @BillsOther,
          @TicketInAmountMoney, @TicketInCount, @TicketOutAmountMoney, @TicketOutCount, @HandPayOutAmountMoney, @HandpayCount,
          @ProgressiveContributionsMoney, @ProgressiveAwardsMoney, @JackpotOutAmountMoney, @JackpotCount, @PromoInAmountMoney,
          @PromoInCount, @CabinetDoorOpen, @BillDoorOpen, @PowerCycle, @CabinetBaseDoorOpen, @LogicDoorOpen, @ProgressiveCount,
          @CancelledCreditOutMoney, @CancelledCreditCount)
   END

-- For non-zero @@ERROR value, set ErrorID=283 (tpGrandMeters : Update/Insert failed.).
IF (@@ERROR <> 0)
    SET @ErrorID = 283

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
      
      -- Test if the Machine should be locked up.
      IF (@LockupMachine <> 0)
         BEGIN
            UPDATE MACH_SETUP SET ACTIVE_FLAG = 0 WHERE MACH_NO = @MachineNumber
            SET @EventCode = 'SD'
         END
        
      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription + ' Machine Number: ' + @MachineNumber + @ErrorText

      -- Insert Error into the Casino_Event_Log
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)
   END

-- Is Debug mode is on?
IF (@Debug = 1)
   -- Yes, so record return argument values...
   BEGIN
      SET @MsgText =
         'tpGrandMeters Return Values:  ' + 
         '  ErrorID: '          + ISNULL(CAST(@ErrorID AS VarChar), '<null>') +
         '  ErrorDescription: ' + ISNULL(@ErrorDescription, '<null>') +
         '  ShutDownFlag: '     + ISNULL(CAST(@LockupMachine AS VarChar), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag
GO
