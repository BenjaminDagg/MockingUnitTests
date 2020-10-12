SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_InvoiceDGtoInterlot user stored procedure.

Created: 04-14-2011 by Terry Watkins

Purpose: Returns data for the Liability report

Arguments: 


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 04-14-2011     Version 2.0.0
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_InvoiceDGtoInterlot] @StartDate DateTime
AS

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Variable Declaration section
DECLARE @AmtDueToDC09FromDC Money
DECLARE @DC09ILRevenue      Money
DECLARE @DC09IntralotPct    Decimal(6,4)
DECLARE @DGRevPercent       Decimal(6,4)
DECLARE @DGRevenue          Money
DECLARE @DollarsPlayed      Money
DECLARE @EndDate            DateTime
DECLARE @LotteryRevenue     Money
DECLARE @LotteryRevPercent  Decimal(6,4)
DECLARE @NetRevenue         Money
DECLARE @PrizesWon          Money
DECLARE @RetailCommission   Money
DECLARE @RetailRevPercent   Decimal(6,4)


-- Variable Initialization
SET @AmtDueToDC09FromDC = 0
SET @DC09ILRevenue      = 0
SET @DC09IntralotPct    = 0
SET @DGRevPercent       = 0
SET @DGRevenue          = 0
SET @DollarsPlayed      = 0
SET @EndDate            = DATEADD(day, 6, @StartDate)
SET @LotteryRevenue     = 0
SET @LotteryRevPercent  = 0
SET @NetRevenue         = 0
SET @PrizesWon          = 0
SET @RetailCommission   = 0
SET @RetailRevPercent   = 0

-- Retrieve RevShare values
SELECT @RetailRevPercent  = ItemValueDecimal FROM dbo.AppSetting WHERE ItemKey = 'RetailRevenuePercent'
SELECT @LotteryRevPercent = ItemValueDecimal FROM dbo.AppSetting WHERE ItemKey = 'LotteryRevenuePercent'
SELECT @DC09IntralotPct   = ItemValueDecimal FROM dbo.AppSetting WHERE ItemKey = 'DC09ILRevenuePercent'
SELECT @DGRevPercent      = ItemValueDecimal FROM dbo.AppSetting WHERE ItemKey = 'DGRevenuePercent'

-- Retrieve data into a temporary table.
SELECT
   @DollarsPlayed = ISNULL(SUM(AMOUNT_PLAYED), 0),
   @PrizesWon     = ISNULL(SUM(AMOUNT_WON + AMOUNT_FORFEITED + AMOUNT_JACKPOT), 0)
FROM dbo.MACHINE_STATS
WHERE ACCT_DATE BETWEEN @StartDate AND @EndDate

-- Set calculated values.
SET @NetRevenue         = @DollarsPlayed - @PrizesWon
SET @RetailCommission   = (@NetRevenue * @RetailRevPercent) / 100
SET @LotteryRevenue     = (@NetRevenue * @LotteryRevPercent) / 100
SET @DC09ILRevenue      = (@NetRevenue * @DC09IntralotPct) / 100
SET @DGRevenue          = (@NetRevenue * @DGRevPercent) / 100
SET @AmtDueToDC09FromDC = @DGRevenue + @DC09ILRevenue

SELECT
   @DollarsPlayed      AS DollarsPlayed,
   @PrizesWon          AS PrizesWon,
   @NetRevenue         AS NetRevenue,
   @RetailCommission   AS RetailerCommissions,
   @LotteryRevenue     AS LotteryRevenue,
   @DC09ILRevenue      AS DC09ILRevenue,
   @DGRevenue          AS DGRevenue,
   @AmtDueToDC09FromDC AS AmtDueToDC09FromDC
GO
GRANT EXECUTE ON  [dbo].[rpt_InvoiceDGtoInterlot] TO [SSRS]
GO
