SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_SecurityAudit user stored procedure.

  Created: 05-15-2013 by Aldo Zamora

  Purpose: Retrieve data for the rpt_SecurityAudit report.

Arguments:
   @StartDate DATETIME     Start of the date range.
   @EndDate   DATETIME     End of the date range.
   @User      VARCHAR(16)  Users the report will show data for.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   05-15-2013     3.0.9
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_SecurityAudit]
   @StartDate DATETIME,
   @EndDate DATETIME, 
   @User VARCHAR(4000),
   @EventCode VARCHAR(4000)

AS

-- Suppress unwanted statistics
SET NOCOUNT ON

-- Get Security Audit data
SELECT   
   APP_EVENT_ID AS EventLogID,
   EVENT_SOURCE AS EventSource,
   [DESCRIPTION] AS EventDescription,
   EVENT_TIME AS EventDateTime,
   ACCOUNTID AS CreatedBy
FROM dbo.APP_EVENT_LOG
WHERE
   APP_EVENT_TYPE IN (SELECT Val FROM dbo.ufn_StringToTable(@EventCode,',',1)) AND
   EVENT_TIME BETWEEN @StartDate AND DATEADD(Day, 1, @EndDate) AND
   ACCOUNTID IN (SELECT Val from dbo.ufn_StringToTable(@User,',',1))
ORDER BY
   CreatedBy,
   EventDateTime
GO
