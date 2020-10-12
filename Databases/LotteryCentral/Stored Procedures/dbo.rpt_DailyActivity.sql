SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_DailyActivity user stored procedure.

  Created: 03-29-2011 by Aldo Zamora

  Purpose: Returns daily summarized data from the MACHINE_STATS Table for the
           report rpt_DailyActivity period.

Arguments: @StartDate


Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
Aldo Zamora   03-29-2011 Initial coding

--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[rpt_DailyActivity] @StartDate DATETIME

AS

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Select data.
SELECT
   ISNULL(SUM(ms.AMOUNT_IN), 0) AS AmountIn,
   ISNULL(SUM(ms.TICKET_IN_AMOUNT), 0) AS VouchersIn,
   ISNULL(SUM(ms.TICKET_OUT_AMOUNT), 0) AS VouchersOut,
   ISNULL(SUM(ms.AMOUNT_PLAYED), 0) AS AmountPlayed,
   ISNULL(SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0) AS AmountWon,
   ISNULL(SUM(ms.AMOUNT_PLAYED - ms.AMOUNT_WON - ms.AMOUNT_JACKPOT - ms.AMOUNT_FORFEITED), 0) AS NetRevenue,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount In' ) AS HeaderAmountIn,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher In' ) AS HeaderVoucherIn,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher Out') AS HeaderVoucherOut,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Played') AS HeaderAmountPlayed,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Won') AS HeaderAmountWon,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Net Revenue') AS HeaderNetRevenue
FROM
   MACHINE_STATS ms
WHERE
   ms.ACCT_DATE = @StartDate
GO
GRANT EXECUTE ON  [dbo].[rpt_DailyActivity] TO [SSRS]
GO
