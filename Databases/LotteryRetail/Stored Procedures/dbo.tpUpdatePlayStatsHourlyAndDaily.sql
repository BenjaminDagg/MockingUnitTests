SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpUpdatePlayStatsHourlyAndDaily

Desc: Inserts or updates PLAY_STATS_HOURLY and MACHINE_STATS information.

Written: 05-27-2014 by Louis Epstein

Called by: tpTrans* (Play transactions)

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 05-27-2014     v3.2.2
Initial Coding.

--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpUpdatePlayStatsHourlyAndDaily]
   @LocationIdPass int,
@MachNoPass char(5),
@CasinoMachNoPass varchar(8),
@AcctDatePass datetime,
@TimeStampPass datetime,
@DealNoPass int,
@GameCodePass varchar(3),
@DenomPass smallmoney = 0,
@CoinsBetPass smallint = 0,
@LinesBetPass smallint = 0,
@PlayCountPass int = 0,
@LossCountPass int = 0,
@WinCountPass int = 0,
@JackpotCountPass smallint = 0,
@ForfeitCountPass smallint = 0,
@TicketInCountPass int = 0,
@TicketOutCountPass int = 0,
@AmountInPass money = 0,
@AmountPlayedPass money = 0,
@AmountLostPass money = 0,
@AmountWonPass money = 0,
@AmountJackpotPass money = 0,
@AmountForfeitedPass money = 0,
@AmountProgPass money = 0,
@TicketInAmountPass money = 0,
@TicketOutAmountPass money = 0,
@ProgContributionPass money = 0,
@BillCount1Pass int = 0,
@BillCount2Pass int = 0,
@BillCount5Pass int = 0,
@BillCount10Pass int = 0,
@BillCount20Pass int = 0,
@BillCount50Pass int = 0,
@BillCount100Pass int = 0,
@BillCountOtherPass int = 0,
@PromoInAmountPass money = 0,
@PromoInCountPass int = 0,
@EftInAmountPass money = 0,
@EftInCountPass int = 0,
@EftOutAmountPass money = 0,
@EftOutCountPass int = 0,
@EftPromoInAmountPass money = 0,
@EftPromoInCountPass int = 0,
@EftPromoOutAmountPass money = 0,
@EftPromoOutCountPass int = 0,
@MainDoorOpenCountPass smallint = 0,
@CashDoorOpenCountPass smallint = 0,
@LogicDoorOpenCountPass smallint = 0,
@BaseDoorOpenCountPass smallint = 0,
@AmountPlayedPromoPass money = 0,
@AmountWonPromoPass money = 0

AS

DECLARE @PlayStatsHourlyID int
DECLARE @MachineStatsID int
DECLARE @HourOfDayPass int

SET @HourOfDayPass = DateDiff(Hour, CAST(FLOOR(CAST(@TimeStampPass AS FLOAT)) AS DATETIME), @TimeStampPass)

SELECT @MachineStatsID = MACHINE_STATS_ID
            FROM MACHINE_STATS
            WHERE
               MACH_NO        = @MachNoPass  AND
               CASINO_MACH_NO = @CasinoMachNoPass   AND
               ACCT_DATE      = @AcctDatePass AND
               DEAL_NO        = @DealNoPass         AND
               GAME_CODE      = @GameCodePass

SELECT @PlayStatsHourlyID = PLAY_STATS_HOURLY_ID
         FROM PLAY_STATS_HOURLY
         WHERE
            MACH_NO        = @MachNoPass AND
            CASINO_MACH_NO = @CasinoMachNoPass  AND
            ACCT_DATE      = @AcctDatePass      AND
            DEAL_NO        = @DealNoPass    AND
            GAME_CODE      = @GameCodePass      AND
            DENOM          = @DenomPass         AND
            COINS_BET      = @CoinsBetPass      AND
            LINES_BET      = @LinesBetPass      AND
            HOUR_OF_DAY    = @HourOfDayPass
            
IF @MachineStatsID IS NULL
BEGIN
INSERT INTO [MACHINE_STATS]
           ([MACH_NO]
           ,[CASINO_MACH_NO]
           ,[ACCT_DATE]
           ,[DEAL_NO]
           ,[GAME_CODE]
           ,[LOCATION_ID]
           ,[PLAY_COUNT]
           ,[LOSS_COUNT]
           ,[WIN_COUNT]
           ,[JACKPOT_COUNT]
           ,[FORFEIT_COUNT]
           ,[TICKET_IN_COUNT]
           ,[TICKET_OUT_COUNT]
           ,[AMOUNT_IN]
           ,[AMOUNT_PLAYED]
           ,[AMOUNT_LOST]
           ,[AMOUNT_WON]
           ,[AMOUNT_JACKPOT]
           ,[AMOUNT_FORFEITED]
           ,[AMOUNT_PROG]
           ,[TICKET_IN_AMOUNT]
           ,[TICKET_OUT_AMOUNT]
           ,[PROG_CONTRIBUTION]
           ,[BILL_COUNT_1]
           ,[BILL_COUNT_2]
           ,[BILL_COUNT_5]
           ,[BILL_COUNT_10]
           ,[BILL_COUNT_20]
           ,[BILL_COUNT_50]
           ,[BILL_COUNT_100]
           ,[BILL_COUNT_OTHER]
           ,[PROMO_IN_AMOUNT]
           ,[PROMO_IN_COUNT]
           ,[EFT_IN_AMOUNT]
           ,[EFT_IN_COUNT]
           ,[EFT_OUT_AMOUNT]
           ,[EFT_OUT_COUNT]
           ,[EFT_PROMO_IN_AMOUNT]
           ,[EFT_PROMO_IN_COUNT]
           ,[EFT_PROMO_OUT_AMOUNT]
           ,[EFT_PROMO_OUT_COUNT]
           ,[MAIN_DOOR_OPEN_COUNT]
           ,[CASH_DOOR_OPEN_COUNT]
           ,[LOGIC_DOOR_OPEN_COUNT]
           ,[BASE_DOOR_OPEN_COUNT]
           ,[AMOUNT_PLAYED_PROMO]
           ,[AMOUNT_WON_PROMO])
     VALUES
           (@MachNoPass,
@CasinoMachNoPass,
@AcctDatePass,
@DealNoPass,
@GameCodePass,
@LocationIdPass,
@PlayCountPass,
@LossCountPass,
@WinCountPass,
@JackpotCountPass,
@ForfeitCountPass,
@TicketInCountPass,
@TicketOutCountPass,
@AmountInPass,
@AmountPlayedPass,
@AmountLostPass,
@AmountWonPass,
@AmountJackpotPass,
@AmountForfeitedPass,
@AmountProgPass,
@TicketInAmountPass,
@TicketOutAmountPass,
@ProgContributionPass,
@BillCount1Pass,
@BillCount2Pass,
@BillCount5Pass,
@BillCount10Pass,
@BillCount20Pass,
@BillCount50Pass,
@BillCount100Pass,
@BillCountOtherPass,
@PromoInAmountPass,
@PromoInCountPass,
@EftInAmountPass,
@EftInCountPass,
@EftOutAmountPass,
@EftOutCountPass,
@EftPromoInAmountPass,
@EftPromoInCountPass,
@EftPromoOutAmountPass,
@EftPromoOutCountPass,
@MainDoorOpenCountPass,
@CashDoorOpenCountPass,
@LogicDoorOpenCountPass,
@BaseDoorOpenCountPass,
@AmountPlayedPromoPass,
@AmountWonPromoPass)
END
ELSE
BEGIN
UPDATE [MACHINE_STATS]
   SET 
PLAY_COUNT = PLAY_COUNT + @PlayCountPass,
LOSS_COUNT = LOSS_COUNT + @LossCountPass,
WIN_COUNT = WIN_COUNT + @WinCountPass,
JACKPOT_COUNT = JACKPOT_COUNT + @JackpotCountPass,
FORFEIT_COUNT = FORFEIT_COUNT + @ForfeitCountPass,
TICKET_IN_COUNT = TICKET_IN_COUNT + @TicketInCountPass,
TICKET_OUT_COUNT = TICKET_OUT_COUNT + @TicketOutCountPass,
AMOUNT_IN = AMOUNT_IN + @AmountInPass,
AMOUNT_PLAYED = AMOUNT_PLAYED + @AmountPlayedPass,
AMOUNT_LOST = AMOUNT_LOST + @AmountLostPass,
AMOUNT_WON = AMOUNT_WON + @AmountWonPass,
AMOUNT_JACKPOT = AMOUNT_JACKPOT + @AmountJackpotPass,
AMOUNT_FORFEITED = AMOUNT_FORFEITED + @AmountForfeitedPass,
AMOUNT_PROG = AMOUNT_PROG + @AmountProgPass,
TICKET_IN_AMOUNT = TICKET_IN_AMOUNT + @TicketInAmountPass,
TICKET_OUT_AMOUNT = TICKET_OUT_AMOUNT + @TicketOutAmountPass,
PROG_CONTRIBUTION = PROG_CONTRIBUTION + @ProgContributionPass,
BILL_COUNT_1 = BILL_COUNT_1 + @BillCount1Pass,
BILL_COUNT_2 = BILL_COUNT_2 + @BillCount2Pass,
BILL_COUNT_5 = BILL_COUNT_5 + @BillCount5Pass,
BILL_COUNT_10 = BILL_COUNT_10 + @BillCount10Pass,
BILL_COUNT_20 = BILL_COUNT_20 + @BillCount20Pass,
BILL_COUNT_50 = BILL_COUNT_50 + @BillCount50Pass,
BILL_COUNT_100 = BILL_COUNT_100 + @BillCount100Pass,
BILL_COUNT_OTHER = BILL_COUNT_OTHER + @BillCountOtherPass,
PROMO_IN_AMOUNT = PROMO_IN_AMOUNT + @PromoInAmountPass,
PROMO_IN_COUNT = PROMO_IN_COUNT + @PromoInCountPass,
EFT_IN_AMOUNT = EFT_IN_AMOUNT + @EftInAmountPass,
EFT_IN_COUNT = EFT_IN_COUNT + @EftInCountPass,
EFT_OUT_AMOUNT = EFT_OUT_AMOUNT + @EftOutAmountPass,
EFT_OUT_COUNT = EFT_OUT_COUNT + @EftOutCountPass,
EFT_PROMO_IN_AMOUNT = EFT_PROMO_IN_AMOUNT + @EftPromoInAmountPass,
EFT_PROMO_IN_COUNT = EFT_PROMO_IN_COUNT + @EftPromoInCountPass,
EFT_PROMO_OUT_AMOUNT = EFT_PROMO_OUT_AMOUNT + @EftPromoOutAmountPass,
EFT_PROMO_OUT_COUNT = EFT_PROMO_OUT_COUNT + @EftPromoOutCountPass,
MAIN_DOOR_OPEN_COUNT = MAIN_DOOR_OPEN_COUNT + @MainDoorOpenCountPass,
CASH_DOOR_OPEN_COUNT = CASH_DOOR_OPEN_COUNT + @CashDoorOpenCountPass,
LOGIC_DOOR_OPEN_COUNT = LOGIC_DOOR_OPEN_COUNT + @LogicDoorOpenCountPass,
BASE_DOOR_OPEN_COUNT = BASE_DOOR_OPEN_COUNT + @BaseDoorOpenCountPass,
AMOUNT_PLAYED_PROMO = AMOUNT_PLAYED_PROMO + @AmountPlayedPromoPass,
AMOUNT_WON_PROMO = AMOUNT_WON_PROMO + @AmountWonPromoPass
      WHERE MACHINE_STATS_ID = @MachineStatsID 
END


IF @PlayStatsHourlyID IS NULL
BEGIN
INSERT INTO [PLAY_STATS_HOURLY]
           ([LOCATION_ID]
           ,[MACH_NO]
           ,[CASINO_MACH_NO]
           ,[ACCT_DATE]
           ,[DEAL_NO]
           ,[GAME_CODE]
           ,[DENOM]
           ,[COINS_BET]
           ,[LINES_BET]
           ,[HOUR_OF_DAY]
           ,[PLAY_COUNT]
           ,[LOSS_COUNT]
           ,[WIN_COUNT]
           ,[JACKPOT_COUNT]
           ,[FORFEIT_COUNT]
           ,[TICKET_IN_COUNT]
           ,[TICKET_OUT_COUNT]
           ,[AMOUNT_IN]
           ,[AMOUNT_PLAYED]
           ,[AMOUNT_LOST]
           ,[AMOUNT_WON]
           ,[AMOUNT_JACKPOT]
           ,[AMOUNT_FORFEITED]
           ,[AMOUNT_PROG]
           ,[TICKET_IN_AMOUNT]
           ,[TICKET_OUT_AMOUNT]
           ,[PROG_CONTRIBUTION]
           ,[BILL_COUNT_1]
           ,[BILL_COUNT_2]
           ,[BILL_COUNT_5]
           ,[BILL_COUNT_10]
           ,[BILL_COUNT_20]
           ,[BILL_COUNT_50]
           ,[BILL_COUNT_100]
           ,[BILL_COUNT_OTHER]
           ,[PROMO_IN_AMOUNT]
           ,[PROMO_IN_COUNT]
           ,[EFT_IN_AMOUNT]
           ,[EFT_IN_COUNT]
           ,[EFT_OUT_AMOUNT]
           ,[EFT_OUT_COUNT]
           ,[EFT_PROMO_IN_AMOUNT]
           ,[EFT_PROMO_IN_COUNT]
           ,[EFT_PROMO_OUT_AMOUNT]
           ,[EFT_PROMO_OUT_COUNT]
           ,[MAIN_DOOR_OPEN_COUNT]
           ,[CASH_DOOR_OPEN_COUNT]
           ,[LOGIC_DOOR_OPEN_COUNT]
           ,[BASE_DOOR_OPEN_COUNT]
           ,[AMOUNT_PLAYED_PROMO]
           ,[AMOUNT_WON_PROMO])
     VALUES
           (@LocationIdPass,
@MachNoPass,
@CasinoMachNoPass,
@AcctDatePass,
@DealNoPass,
@GameCodePass,
@DenomPass,
@CoinsBetPass,
@LinesBetPass,
@HourOfDayPass,
@PlayCountPass,
@LossCountPass,
@WinCountPass,
@JackpotCountPass,
@ForfeitCountPass,
@TicketInCountPass,
@TicketOutCountPass,
@AmountInPass,
@AmountPlayedPass,
@AmountLostPass,
@AmountWonPass,
@AmountJackpotPass,
@AmountForfeitedPass,
@AmountProgPass,
@TicketInAmountPass,
@TicketOutAmountPass,
@ProgContributionPass,
@BillCount1Pass,
@BillCount2Pass,
@BillCount5Pass,
@BillCount10Pass,
@BillCount20Pass,
@BillCount50Pass,
@BillCount100Pass,
@BillCountOtherPass,
@PromoInAmountPass,
@PromoInCountPass,
@EftInAmountPass,
@EftInCountPass,
@EftOutAmountPass,
@EftOutCountPass,
@EftPromoInAmountPass,
@EftPromoInCountPass,
@EftPromoOutAmountPass,
@EftPromoOutCountPass,
@MainDoorOpenCountPass,
@CashDoorOpenCountPass,
@LogicDoorOpenCountPass,
@BaseDoorOpenCountPass,
@AmountPlayedPromoPass,
@AmountWonPromoPass)
END
ELSE
BEGIN
UPDATE [PLAY_STATS_HOURLY]
   SET 
   PLAY_COUNT = PLAY_COUNT + @PlayCountPass,
LOSS_COUNT = LOSS_COUNT + @LossCountPass,
WIN_COUNT = WIN_COUNT + @WinCountPass,
JACKPOT_COUNT = JACKPOT_COUNT + @JackpotCountPass,
FORFEIT_COUNT = FORFEIT_COUNT + @ForfeitCountPass,
TICKET_IN_COUNT = TICKET_IN_COUNT + @TicketInCountPass,
TICKET_OUT_COUNT = TICKET_OUT_COUNT + @TicketOutCountPass,
AMOUNT_IN = AMOUNT_IN + @AmountInPass,
AMOUNT_PLAYED = AMOUNT_PLAYED + @AmountPlayedPass,
AMOUNT_LOST = AMOUNT_LOST + @AmountLostPass,
AMOUNT_WON = AMOUNT_WON + @AmountWonPass,
AMOUNT_JACKPOT = AMOUNT_JACKPOT + @AmountJackpotPass,
AMOUNT_FORFEITED = AMOUNT_FORFEITED + @AmountForfeitedPass,
AMOUNT_PROG = AMOUNT_PROG + @AmountProgPass,
TICKET_IN_AMOUNT = TICKET_IN_AMOUNT + @TicketInAmountPass,
TICKET_OUT_AMOUNT = TICKET_OUT_AMOUNT + @TicketOutAmountPass,
PROG_CONTRIBUTION = PROG_CONTRIBUTION + @ProgContributionPass,
BILL_COUNT_1 = BILL_COUNT_1 + @BillCount1Pass,
BILL_COUNT_2 = BILL_COUNT_2 + @BillCount2Pass,
BILL_COUNT_5 = BILL_COUNT_5 + @BillCount5Pass,
BILL_COUNT_10 = BILL_COUNT_10 + @BillCount10Pass,
BILL_COUNT_20 = BILL_COUNT_20 + @BillCount20Pass,
BILL_COUNT_50 = BILL_COUNT_50 + @BillCount50Pass,
BILL_COUNT_100 = BILL_COUNT_100 + @BillCount100Pass,
BILL_COUNT_OTHER = BILL_COUNT_OTHER + @BillCountOtherPass,
PROMO_IN_AMOUNT = PROMO_IN_AMOUNT + @PromoInAmountPass,
PROMO_IN_COUNT = PROMO_IN_COUNT + @PromoInCountPass,
EFT_IN_AMOUNT = EFT_IN_AMOUNT + @EftInAmountPass,
EFT_IN_COUNT = EFT_IN_COUNT + @EftInCountPass,
EFT_OUT_AMOUNT = EFT_OUT_AMOUNT + @EftOutAmountPass,
EFT_OUT_COUNT = EFT_OUT_COUNT + @EftOutCountPass,
EFT_PROMO_IN_AMOUNT = EFT_PROMO_IN_AMOUNT + @EftPromoInAmountPass,
EFT_PROMO_IN_COUNT = EFT_PROMO_IN_COUNT + @EftPromoInCountPass,
EFT_PROMO_OUT_AMOUNT = EFT_PROMO_OUT_AMOUNT + @EftPromoOutAmountPass,
EFT_PROMO_OUT_COUNT = EFT_PROMO_OUT_COUNT + @EftPromoOutCountPass,
MAIN_DOOR_OPEN_COUNT = MAIN_DOOR_OPEN_COUNT + @MainDoorOpenCountPass,
CASH_DOOR_OPEN_COUNT = CASH_DOOR_OPEN_COUNT + @CashDoorOpenCountPass,
LOGIC_DOOR_OPEN_COUNT = LOGIC_DOOR_OPEN_COUNT + @LogicDoorOpenCountPass,
BASE_DOOR_OPEN_COUNT = BASE_DOOR_OPEN_COUNT + @BaseDoorOpenCountPass,
AMOUNT_PLAYED_PROMO = AMOUNT_PLAYED_PROMO + @AmountPlayedPromoPass,
AMOUNT_WON_PROMO = AMOUNT_WON_PROMO + @AmountWonPromoPass

 WHERE PLAY_STATS_HOURLY_ID = @PlayStatsHourlyID
END
GO
