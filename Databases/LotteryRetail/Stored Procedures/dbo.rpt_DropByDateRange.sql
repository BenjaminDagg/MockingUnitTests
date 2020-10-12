SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_DropByDateRange user stored procedure.

Created: 07-10-2006 by Terry Watkins

Purpose: Returns data for the Drop by Date Range Report.

Arguments: @StartDate: Beginning date/time for the resultset
           @EndDate:   Ending date/time for the resultset

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-10-2006     v5.0.4
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[rpt_DropByDateRange] @StartDate DateTime, @EndDate DateTime
	
AS

-- Declare Variables

-- Retrieve the data...
SELECT
   dm.MACH_NO                                 AS DgeMachNo,
   ms.CASINO_MACH_NO                          AS MachNo,
   dm.CARD_ACCT_NO                            AS CardAcctNo,
   dm.DTIMESTAMP                              AS DTimestamp,
   CAST(dm.DROP_AMOUNT AS MONEY) / 100        AS DropAmt,
   CAST(dm.ONE_DOLLAR_AMT AS MONEY)           AS OneDollarAmt,
   CAST(dm.TWO_DOLLAR_AMT AS MONEY) * 2       AS TwoDollarAmt,
   CAST(dm.FIVE_DOLLAR_AMT AS MONEY) * 5      AS FiveDollarAmt,
   CAST(dm.TEN_DOLLAR_AMT AS MONEY) * 10      AS TenDollarAmt,
   CAST(dm.TWENTY_DOLLAR_AMT AS MONEY) * 20   AS TwentyDollarAmt,
   CAST(dm.FIFTY_DOLLAR_AMT AS MONEY) * 50    AS FiftyDollarAmt,
   CAST(dm.HUNDRED_DOLLAR_AMT AS MONEY) * 100 AS HundredDollarAmt,
   dm.ONE_DOLLAR_AMT + dm.TWO_DOLLAR_AMT +
   dm.FIVE_DOLLAR_AMT + dm.TEN_DOLLAR_AMT +
   dm.TWENTY_DOLLAR_AMT + dm.FIFTY_DOLLAR_AMT +
   dm.HUNDRED_DOLLAR_AMT                      AS BillCount,
   cu.FNAME + ' ' + cu.LNAME                  AS TechName,
   CAST(dm.TICKET_IN_AMOUNT AS MONEY) / 100   AS VoucherInAmt,
   dm.TICKET_IN_COUNT                         AS VoucherInCount
FROM DROP_MACHINE dm
   JOIN MACH_SETUP ms ON dm.MACH_NO = ms.MACH_NO
   LEFT OUTER JOIN CASINO_USERS cu ON SUBSTRING(dm.CARD_ACCT_NO, 7,10) = cu.ACCOUNTID
WHERE dm.DTIMESTAMP BETWEEN @StartDate AND @EndDate
ORDER BY ms.CASINO_MACH_NO ASC
GO
