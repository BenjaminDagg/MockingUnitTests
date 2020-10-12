SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Security_Audit user stored procedure.

  Created: 12-15-2011 by Aldo Zamora

  Purpose: Retrieve data for the rpt_Security_Audit report.

Arguments:
   @StartDate DATETIME     Start of the date range.
   @EndDate   DATETIME     End of the date range.
   @User      VARCHAR(16)  Users the report will show data for.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Cj Price   5-19-2014     2.0.6
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Security_Audit]
   @StartDate DATETIME,
   @EndDate DATETIME, 
   @User VARCHAR(4000),
   @EventType VARCHAR(4000)

AS

-- Suppress unwanted statistics
SET NOCOUNT ON

-- Get Security Audit data
SELECT   
   el.EventLogID,
   el.EventSource,
   el.EventTypeId,
   et.EventName,
   et.Description AS EventTypeDesc,
   el.Details,
   el.Description AS EventLogDesc,
   el.EventDate,
   el.UserId,
   au.UserName
FROM EventLog el
INNER JOIN EventType et ON et.EventTypeId = el.EventTypeId
INNER JOIN AppUser au ON au.AppUserId = el.UserId
WHERE
   et.EventName IN (SELECT Val FROM dbo.ufn_StringToTable(@EventType, ',', 1))
   AND el.EventDate BETWEEN @StartDate AND DATEADD(Day, 1, @EndDate)
   AND au.UserName IN (SELECT Val FROM dbo.ufn_StringToTable(@User, ',', 1))
ORDER BY
   au.UserName,
   el.EventDate
GO
