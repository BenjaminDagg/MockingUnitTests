SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_WeeklyRetailerInvoiceRP user stored procedure.

Created: 03-23-2011 by Terry Watkins

Purpose: Returns summarized data for the Weekly Retailer Invoice report that is
         printed on a Lottery receipt printer

Arguments: @Acct_Date:  Accounting date to use as the beginning of the week
                        for the resultset


Change Log:

Changed By      Date         Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins   03-23-2011   v7.2.4
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_WeeklyRetailerInvoiceRP] @Acct_Date DateTime
AS

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Variable Declarations
DECLARE @DollarsPlayed       Money
DECLARE @EndAcctDate         DateTime
DECLARE @JackpotPrizes       Money
DECLARE @LocationID          Int
DECLARE @LotteryTransfer     Money
DECLARE @NetDeposit          Money
DECLARE @NetRevenue          Money
DECLARE @PayoutThreshold     Money
DECLARE @PrizesWon           Money
DECLARE @RetailerCommission  Money
DECLARE @RetailerNbr         VarChar(6)
DECLARE @RetailRevShare      Decimal(4,2)
DECLARE @SweepAcct           VarChar(16)
DECLARE @UnclaimedPrizes     Money

-- Variable Initialization
SET @DollarsPlayed      = 0
SET @JackpotPrizes      = 0
SET @NetDeposit         = 0
SET @NetRevenue         = 0
SET @PrizesWon          = 0
SET @RetailerCommission = 0
SET @RetailerNbr        = ''
SET @SweepAcct          = ''
SET @UnclaimedPrizes    = 0

-- Retrieve CASINO table values...
SELECT
   @LocationID       = LOCATION_ID,
   @PayoutThreshold  = PAYOUT_THRESHOLD,
   @RetailRevShare   = RETAIL_REV_SHARE,
   @SweepAcct        = SWEEP_ACCT,
   @RetailerNbr      = RETAILER_NUMBER
FROM dbo.CASINO
WHERE SETASDEFAULT = 1

-- [Variable Initialization]
SET @EndAcctDate = DATEADD(Day,6, @Acct_Date)

-- Retrieve MachineStats data into local vars.
SELECT
   @DollarsPlayed = ISNULL(SUM(ms.AMOUNT_PLAYED), 0),
   @PrizesWon     = ISNULL(SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT), 0)
FROM MACHINE_STATS ms
   JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE ACCT_DATE BETWEEN @Acct_Date AND @EndAcctDate

-- Retrieve Jackpot Prizes.
SELECT @JackpotPrizes = ISNULL(SUM(TRANS_AMT), 0)
FROM dbo.JACKPOT
WHERE
   TRANS_AMT > @PayoutThreshold AND
   TRANS_ID  = 12               AND
   dbo.ufnGetAcctDateFromDate(DTIMESTAMP) BETWEEN @Acct_Date AND @EndAcctDate

-- Retrieve Unclaimed Prizes.
SELECT @UnclaimedPrizes = ISNULL(SUM(VOUCHER_AMOUNT), 0)
FROM dbo.VOUCHER
WHERE
   UCV_TRANSFERRED = 1 AND
   dbo.ufnGetAcctDateFromDate(UCV_TRANSFER_DATE) BETWEEN @Acct_Date AND @EndAcctDate

-- Set calculated values...
SET @NetRevenue = @DollarsPlayed - @PrizesWon
SET @RetailerCommission = (@NetRevenue * @RetailRevShare) / 100
SET @LotteryTransfer = @NetRevenue - @RetailerCommission
SET @NetDeposit = @LotteryTransfer + @JackpotPrizes + @UnclaimedPrizes

-- Select the result set that is returned by this procedure.
SELECT
   @LocationID                    AS LocationID,
   @SweepAcct                     AS SweepAccount,
   @RetailerNbr                   AS RetailerNumber,
   ISNULL(@DollarsPlayed, 0)      AS DollarsPlayed,
   ISNULL(@PrizesWon, 0)          AS PrizesWon,
   ISNULL(@NetRevenue, 0)         AS NetRevenue,
   ISNULL(@RetailerCommission, 0) AS RetailerCommission,
   ISNULL(@LotteryTransfer, 0)    AS LotteryTransfer,
   ISNULL(@JackpotPrizes, 0)      AS JackpotPrizes,
   ISNULL(@UnclaimedPrizes, 0)    AS UnclaimedPrizes,
   ISNULL(@NetDeposit, 0)         AS NetDepositRequired
GO
