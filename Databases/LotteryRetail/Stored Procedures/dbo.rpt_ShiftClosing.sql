SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_ShiftClosing user stored procedure.

Created: 03-17-2011 by Terry Watkins

Purpose: Returns summarized data for the Shift/Closing report that is printed on
         a Lottery receipt printer

Arguments: @DateRangeStart:  Starting Date and Time for the report
           @DateRangeEnd:    Ending Date and Time for the report

Change Log:

Changed By      Date         Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins   03-17-2011   v7.2.4
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_ShiftClosing]
   @DateRangeStart DateTime,
   @DateRangeEnd   DateTime
AS

-- Variable Declarations
DECLARE @RetailRevShare        Decimal(4,2)
DECLARE @TotalVoucherPayments  Money

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Retrieve the Retail commission percentage (RETAIL_REV_SHARE).
SELECT @RetailRevShare = RETAIL_REV_SHARE FROM dbo.CASINO WHERE SETASDEFAULT = 1

-- Retrieve total voucher cashier payouts before modifying the end of the date range.
SELECT @TotalVoucherPayments = ISNULL(SUM(TRANS_AMT), 0)
FROM dbo.CASHIER_TRANS
WHERE
   PAYMENT_TYPE IN ('A','M') AND
   CREATE_DATE BETWEEN @DateRangeStart AND @DateRangeEnd

-- Subtract 1 hour so we get all data up to but not including the ending time.
SET @DateRangeEnd = DATEADD(HOUR, -1, @DateRangeEnd)

-- Select the data.
SELECT
   ISNULL(SUM(AMOUNT_PLAYED), 0)     AS DollarsPlayed,
   ISNULL(SUM(AMOUNT_WON), 0)        AS PrizesWon,
   ISNULL(SUM(AMOUNT_JACKPOT), 0)    AS JackpotPrizesWon,
   ISNULL(SUM(AMOUNT_PLAYED - 
              AMOUNT_WON - 
              AMOUNT_JACKPOT -
              AMOUNT_FORFEITED), 0) AS NetRevenue,
   ISNULL(@TotalVoucherPayments, 0)  AS TotalVoucherPayments,
   ISNULL(@RetailRevShare, 0.0)      AS RetailRevShare
FROM dbo.PLAY_STATS_HOURLY
WHERE DATEADD(hour, HOUR_OF_DAY, ACCT_DATE) BETWEEN @DateRangeStart AND @DateRangeEnd

-- Now return a second set of data containing all of the voucher amounts that were paid.
-- Add the hour back...
SET @DateRangeEnd = DATEADD(HOUR, 1, @DateRangeEnd)
SELECT TRANS_AMT
FROM dbo.CASHIER_TRANS
WHERE
   PAYMENT_TYPE IN ('A','M') AND
   CREATE_DATE BETWEEN @DateRangeStart AND @DateRangeEnd
GO
