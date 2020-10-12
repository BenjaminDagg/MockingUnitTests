SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_WeeklySweep user stored procedure.

Created: 06-28-2011 by Aldo Zamora

Purpose: Returns summarized data for the Weekly Retailer Invoice report that is
         printed on a Lottery receipt printer

Arguments: @Acct_Date:  Accounting date to use as the beginning of the week
                        for the resultset


Change Log:

Changed By      Date         Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora     06-28-2011   v2.0.3
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_WeeklySweep] @Acct_Date DateTime
AS

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Variable Declarations
DECLARE @EndDate DateTime

-- [Variable Initialization]
SET @EndDate = DATEADD(Day,6, @Acct_Date)

SELECT DISTINCT
   cas.LOCATION_ID AS LocationID,
   cas.SWEEP_ACCT AS SweepAccount,
   cas.RETAILER_NUMBER AS RetailerNumber,
   ISNULL(SUM(ms.AMOUNT_PLAYED), 0) AS DollarsPlayed,
   ISNULL(SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT), 0) AS PrizesWon,
   
   -- Calculate NetRevenue...
   (SELECT ISNULL(SUM(NetRevenue), 0)
    FROM dbo.GLInfo
    WHERE LocationID = cas.LOCATION_ID AND
       AccountingDate BETWEEN @Acct_Date AND @EndDate) AS NetRevenue,
   
   -- Calculate RetailerCommission...
   (SELECT ISNULL(SUM(AgentCommissionsExpense), 0)
    FROM dbo.GLInfo
    WHERE LocationID = cas.LOCATION_ID AND
       AccountingDate BETWEEN @Acct_Date AND @EndDate) AS RetailerCommission,
   
   -- Calculate LotteryTransfer...
   (SELECT ISNULL(SUM(NetRevenue - AgentCommissionsExpense), 0)
    FROM dbo.GLInfo 
    WHERE LocationID = cas.LOCATION_ID AND
       AccountingDate BETWEEN @Acct_Date AND @EndDate) AS LotteryTransfer,
   
   -- Calculate JackpotPrizes...
   (SELECT ISNULL(SUM(TRANS_AMT), 0)
    FROM dbo.JACKPOT
    WHERE
       LOCATION_ID = cas.LOCATION_ID AND
       TRANS_AMT > cas.PAYOUT_THRESHOLD AND
       TRANS_ID  = 12 AND
       dbo.ufnGetAcctDateFromDate(DTIMESTAMP) BETWEEN @Acct_Date AND @EndDate) AS JackpotPrizes,
   
   -- Calculate UnclaimedPrizes...
   (SELECT ISNULL(SUM(UnClaimedVoucherAmount), 0)
    FROM dbo.GLInfo 
    WHERE LocationID = cas.LOCATION_ID AND
       AccountingDate BETWEEN @Acct_Date AND @EndDate) AS UnclaimedPrizes,
   
   -- Calculate NetDepositRequired...
   (SELECT ISNULL(SUM(NetRevenue - AgentCommissionsExpense), 0)
    FROM dbo.GLInfo
    WHERE LocationID = cas.LOCATION_ID AND
       AccountingDate BETWEEN @Acct_Date AND @EndDate) +
   
   (SELECT ISNULL(SUM(TRANS_AMT), 0)
    FROM dbo.JACKPOT
    WHERE
       LOCATION_ID = cas.LOCATION_ID AND
       TRANS_AMT > cas.PAYOUT_THRESHOLD AND
       TRANS_ID  = 12 AND
       dbo.ufnGetAcctDateFromDate(DTIMESTAMP) BETWEEN @Acct_Date AND @EndDate) + 
   
   (SELECT ISNULL(SUM(UnClaimedVoucherAmount), 0)
    FROM dbo.GLInfo 
    WHERE LocationID = cas.LOCATION_ID AND
       AccountingDate BETWEEN @Acct_Date AND @EndDate) AS NetDepositRequired
   
FROM
   dbo.MACHINE_STATS ms
   JOIN dbo.CASINO cas ON ms.LOCATION_ID = cas.LOCATION_ID
   
WHERE
   ms.ACCT_DATE BETWEEN @Acct_Date AND @EndDate
   
GROUP BY
   cas.LOCATION_ID,
   cas.SWEEP_ACCT,
   cas.RETAILER_NUMBER,
   cas.RETAIL_REV_SHARE,
   cas.PAYOUT_THRESHOLD
GO
GRANT EXECUTE ON  [dbo].[rpt_WeeklySweep] TO [SSRS]
GO
