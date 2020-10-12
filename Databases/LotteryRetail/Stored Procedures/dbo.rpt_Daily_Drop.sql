SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Daily_Drop user stored procedure.

Created: 09/08/2003 by Chris Coddington

Purpose: Returns data for the Daily Drop Report.

Arguments: @AcctDate: Accounting Date for the resultset

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Chris C.      09-18-2003 Original coding

Terry Watkins 10-08-2003
  Changed argument from @AcctDate to @DropDate.
  Added retrieval of Tech Name.
  Modified logic to retrieve for the specified date instead of by Accounting Date.
  Removed DTIMESTAMP from the ORDER BY (only need machine number).

Terry Watkins 03-09-2004
  Retrieve MACH_SETUP.CASINO_MACH_NO instead of DROP_MACHINE.MACH_NO for the
  Machine Number displayed on the report.

Terry Watkins 12-17-2004     v4.0.0
  Added Ticket In Amount and Count to resultset.

Terry Watkins 12-17-2004     v4.1.0
  DROP_AMOUNT and TICKET_IN_AMOUNT are now cast to Money. The datatype of those
  columns in the DROP_MACHINE table was changed from Money to Int.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[rpt_Daily_Drop] @DropDate DateTime
	
AS

-- Declare Variables
DECLARE @D1    DateTime
DECLARE @D2    DateTime

SELECT @D2 = TO_TIME FROM CASINO WHERE SETASDEFAULT = 1

SET @D1 = CONVERT(VARCHAR, @DropDate, 110 ) + ' ' + LEFT(CONVERT(VARCHAR, @D2, 114), 8)
SET @D2 = DATEADD(dd, 1, @D1)

SELECT
   ms.CASINO_MACH_NO                        AS MachNo,
   dm.CARD_ACCT_NO                          AS CardAcctNo,
   dm.DTIMESTAMP                            AS DTimestamp,
   CAST(dm.DROP_AMOUNT AS MONEY) / 100      AS DropAmt,
   dm.ONE_DOLLAR_AMT                        AS OneDollarAmt,
   dm.TWO_DOLLAR_AMT                        AS TwoDollarAmt,
   dm.FIVE_DOLLAR_AMT                       AS FiveDollarAmt,
   dm.TEN_DOLLAR_AMT                        AS TenDollarAmt,
   dm.TWENTY_DOLLAR_AMT                     AS TwentyDollarAmt,
   dm.FIFTY_DOLLAR_AMT                      AS FiftyDollarAmt,
   dm.HUNDRED_DOLLAR_AMT                    AS HundredDollarAmt,
   cu.FNAME + ' ' + cu.LNAME                AS TechName,
   CAST(dm.TICKET_IN_AMOUNT AS MONEY) / 100 AS VoucherInAmt,
   dm.TICKET_IN_COUNT                       AS VoucherInCount
FROM DROP_MACHINE dm
   JOIN MACH_SETUP ms ON dm.MACH_NO = ms.MACH_NO
   LEFT OUTER JOIN CASINO_USERS cu ON SUBSTRING(dm.CARD_ACCT_NO, 7,10) = cu.ACCOUNTID
WHERE dm.DTIMESTAMP >= @D1 AND dm.DTIMESTAMP < @D2
ORDER BY ms.CASINO_MACH_NO ASC
GO
