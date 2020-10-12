SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
Procedure: rpt_Security_Activity user stored procedure.

  Created: 12/13/2011 by Edris Khestoo

  Purpose: Returns The Security Tracking Data from APP_EVENT_LOG Table to a report

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
CREATE PROCEDURE [dbo].[rpt_Security_Activity] @StartDate DateTime, @EndDate DateTime
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
     AND A.[APP_EVENT_TYPE] IN (2,3,4,5,6,7)
     ORDER BY [EVENT_TIME]
GO
