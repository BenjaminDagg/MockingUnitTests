SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
Procedure: rpt_Report_Activity user stored procedure.

  Created: 08/26/2005 by MZ

  Purpose: Returns The Report Access Tracking from APP_EVENT_LOG Table to a report

Arguments: @StartDate: Starting report date
	   @EndDate:   Ending report date

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Edris Khestoo 12-13-2011     v3.0.0
  Initial coding

--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Report_Activity] @StartDate DateTime, @EndDate DateTime
AS

-- Suppress unwanted statistics
SET NOCOUNT ON

-- Use dates passed, however, if either is NULL, default as follows:
SET @StartDate = ISNULL(@StartDate, ((GetDate()) - 1))
SET @EndDate   = ISNULL(@EndDate, GetDate())

   SELECT 
          [ACCOUNTID]
         ,[EVENT_TIME]
         ,[EVENT_SOURCE]
         ,[WORK_STATION]
         ,[EVENT_DESC]
         ,[DESCRIPTION]
     FROM [dbo].[APP_EVENT_LOG] A
     JOIN APP_EVENT_TYPE AS T ON  T.[APP_EVENT_TYPE] = A.[APP_EVENT_TYPE]
     WHERE EVENT_TIME BETWEEN @StartDate  AND @EndDate
     AND A.[APP_EVENT_TYPE] = 1
     ORDER BY [EVENT_TIME]
GO
