SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Login_Info user stored procedure.

  Created: 08/26/2005 by MZ

  Purpose: Returns The Logins Tracking to a report

Arguments: @StartDate: Starting report date
	   @EndDate:   Ending report date

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Miguel Zavala 08-22-2005     v4.2.0
  Initial coding

Terry Watkins 06-22-2006     v5.0.4
  Removed Cast of LoginTime to VarChar so date can be formatted in the report.
  Modified column names returned in the resultset.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Login_Info] @StartDate DateTime, @EndDate DateTime
AS

--Variable Declarations...
DECLARE @FromDate  DateTime
DECLARE @ToDate    DateTime

DECLARE @AccountID VarChar(10)
DECLARE @EventDesc VarChar(128)
DECLARE @WKStation VarChar(16)

-- Suppress unwanted statistics
SET NOCOUNT ON

-- Use dates passed, however, if either is NULL, default as follows:
SET @FromDate = ISNULL(@StartDate, ((GetDate()) - 1))
SET @ToDate   = ISNULL(@EndDate, GetDate())

SET @ToDate = DATEADD(DAY,1,@ToDate)

SELECT 
   li.LOGIN_TIME                                 AS LoginTime,
   li.ACCOUNTID                                  AS AccountID,  
   ISNULL(le.EVENT_DESC, 'Unknown Login Event')  AS EventDesc,  
   li.WORK_STATION                               AS WorkStation
FROM LOGIN_INFO li
   LEFT OUTER JOIN LOGIN_EVENT le ON li.LOGIN_EVENT_ID = le.LOGIN_EVENT_ID
WHERE li.LOGIN_TIME BETWEEN @FromDate AND @ToDate
ORDER BY li.LOGIN_TIME DESC
GO
