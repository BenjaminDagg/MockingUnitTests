SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Player_Activity user stored procedure.

  Created: 01/10/2002 by Miguel Zavala

  Purpose: Returns data for the Player Activity Report

Arguments: @StartDate:   Starting DateTime for the resultset
           @EndDate:     Ending DateTime for the resultset
           @CardAcctNbr  Card Account Number to report on
           @UseDates     0 = Retrieve the last 24 hours of activity
                         1 = Use the specified Date Range

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Norm Symonds  04-09-2002
  Added ORDER by ct.DTIMESTAMP to the select.

Terry Watkins 03-09-2004
  Modified to pull new CASINO_MACH_NO instead of MACH_NO so that the Casino
  Machine number is displayed.

Terry Watkins 06-01-2004
  Modified to pull DENOM, COINS_BET, and LINES_BET FROM CASINO_TRANS instead of
  FROM DEAL_SETUP.

  TAB_AMT is now calculated instead of being pulled directly from DEAL_SETUP

  Changed ORDER BY clause to use CASINO_TRANS.TRANS_NO
  instead of DTIMESTAMP (should be a little faster).

Terry Watkins 07-09-2004
  Changed select of @LastTransTime to retrieve MODIFIED_DATE from CARD_ACCT
  instead of MAX(DTIMESTAMP) from CASINO_TRANS when called for the last 24 hours
  of activity.

Terry Watkins 10-27-2004
  Removed TRANS_TYPE from returned dataset and added TRANS_ID and TRANS_DESC.
  Changed argument names so they are meaningful.

Terry Watkins 03-10-2005
  Added new PRESSED_COUNT column to the resultset.
  Modified TAB_COST calculation to include new PRESSED_COUNT column.

Terry Watkins 06-15-2005     v4.1.4
  Changed size of @CardAcctNbr from 16 to 20.

Terry Watkins 09-06-2005     v4.2.0
  Modified Tab amount calculation to support Keno.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Player_Activity]
   @StartDate    DateTime,
   @EndDate      DateTime,
   @CardAcctNbr  VarChar(20),
   @UseDates     Int
AS
-- Variable Declarations
DECLARE @LastTransTime DateTime
DECLARE @FromTime      DateTime

-- Set the From and To datetimes...
IF @UseDates = 0
   -- We want the last 24 hours of activity...
   BEGIN
      SELECT @LastTransTime = ISNULL(MODIFIED_DATE, GetDate())
      FROM CARD_ACCT WHERE (CARD_ACCT_NO = @CardAcctNbr)
      
      SET @FromTime =  @LastTransTime - 1
   END
ELSE
   -- We want activity for the specified range...
   BEGIN
      SET @FromTime      = @StartDate
      SET @LastTransTime = @EndDate
   END
   
-- Retrieve the data...
SELECT
   ct.TRANS_NO,
   ms.CASINO_MACH_NO,
   ct.TRANS_AMT,
   ct.BALANCE,
   ct.TRANS_ID,
   ISNULL(trn.REPORT_TEXT, '<undefined>') AS TRANS_DESC,
   ct.DTIMESTAMP,
   ct.CARD_ACCT_NO,
   CASE ds.TYPE_ID
      WHEN 'K' THEN ct.COINS_BET * CAST(ct.DENOM AS MONEY)
      ELSE (ct.PRESSED_COUNT + 1) * ct.COINS_BET * ct.LINES_BET * CAST(ct.DENOM AS MONEY) END AS TAB_AMT,
   ct.TICKET_NO,
   ct.DENOM,
   ct.COINS_BET,
   ct.LINES_BET,
   ct.PRESSED_COUNT
FROM CASINO_TRANS ct
   JOIN MACH_SETUP            ms ON ct.MACH_NO  = ms.MACH_NO
   LEFT OUTER JOIN DEAL_SETUP ds ON ct.DEAL_NO = ds.DEAL_NO
   LEFT OUTER JOIN TRANS     trn ON ct.TRANS_ID = trn.TRANS_ID
WHERE
   (ct.CARD_ACCT_NO = @CardAcctNbr) AND
   (ct.DTIMESTAMP BETWEEN @FromTime AND @LastTransTime)
ORDER BY ct.TRANS_NO
GO
