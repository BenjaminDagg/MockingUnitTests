SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_DailyActivityBySite user stored procedure.

  Created: 03-29-2011 by Aldo Zamora

  Purpose: Returns daily summarized data from the MACHINE_STATS Table for the
           report rpt_DailyActivityBySite period.

Arguments:
   @StartDate:    Starting DateTime for the result set
   @EndDate:      Ending DateTime for the result set
   @LocationID    Location ID for the result set
   @GameCode      Game Code for the result set


Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
Aldo Zamora   02-16-2012 Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_DailyActivitybySite]
   @StartDate DATETIME
  ,@EndDate DATETIME
  ,@MultipleLocationID VARCHAR(4000) = ''
  ,@LocationID VARCHAR(4000) = ''
  ,@GameCode VARCHAR(4000)
AS -- Suppress return of unwanted stats.
   SET NOCOUNT ON


IF @LocationID = ''
   BEGIN
      SET @LocationID = @MultipleLocationID   
   END

-- Select data.
   SELECT
      CONVERT(VARCHAR, cas.LOCATION_ID) + ' - ' + cas.CAS_NAME AS Location
     ,ms.ACCT_DATE AS AccountingDate
     ,ms.GAME_CODE AS GameCode
     ,gs.GAME_DESC AS GameCodeDescription
     ,ISNULL(SUM(ms.AMOUNT_IN), 0) AS AmountIn
     ,ISNULL(SUM(ms.TICKET_IN_AMOUNT), 0) AS VouchersIn
     ,ISNULL(SUM(ms.PROMO_IN_AMOUNT), 0) AS PromoIn
     ,ISNULL(SUM(ms.TICKET_OUT_AMOUNT), 0) AS VouchersOut
     ,ISNULL(SUM(ms.AMOUNT_PLAYED), 0) AS AmountPlayed
     ,ISNULL(SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0) AS AmountWon
     ,ISNULL(SUM(ms.AMOUNT_PLAYED - ms.AMOUNT_WON - ms.AMOUNT_JACKPOT - ms.AMOUNT_FORFEITED), 0) AS NetRevenue
     ,ISNULL(COUNT(DISTINCT ms.MACH_NO), 0) AS MachineCount
     ,(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount In') AS HeaderAmountIn
     ,(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher In') AS HeaderVoucherIn
     ,(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher Out') AS HeaderVoucherOut
     ,(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Played') AS HeaderAmountPlayed
     ,(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Won') AS HeaderAmountWon
     ,(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Net Revenue') AS HeaderNetRevenue
   FROM
      MACHINE_STATS ms
      JOIN CASINO cas ON ms.LOCATION_ID = cas.LOCATION_ID
      JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
   WHERE
      ms.ACCT_DATE BETWEEN @StartDate AND @EndDate
      AND ms.LOCATION_ID IN (SELECT Val
                             FROM dbo.ufn_StringToTable(@LocationID, ',', 1))
      AND ms.GAME_CODE IN (SELECT Val
                           FROM dbo.ufn_StringToTable(@GameCode, ',', 1))
   GROUP BY
      cas.LOCATION_ID
     ,cas.CAS_NAME
     ,ms.ACCT_DATE
     ,ms.GAME_CODE
     ,gs.GAME_DESC
GO
