SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: InsertJobStatus

Created: 07-05-2013 by Aldo Zamora

Purpose: Inserts a new row into the JobStatus table

Change Log:

Changed By    Date           Database Version
   Change Description
--------------------------------------------------------------------------------
Aldo Zamora   07-05-2013     
   Initial coding.
--------------------------------------------------------------------------------
*/
CREATE  PROCEDURE [dbo].[InsertJobStatus]
   @LocationID INT
   ,@JobName VARCHAR(64)
   ,@Success BIT
   ,@DateDataCollectedFor DATETIME

AS

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @ErrorMessage VARCHAR(1024)
DECLARE @ErrorNumber INT
DECLARE @ServerName NVARCHAR(32)
DECLARE @StoredProc VARCHAR(64)

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SELECT @ServerName = @@SERVERNAME
SET @StoredProc = 'InsertJobStatus'

/*
--------------------------------------------------------------------------------
   Insert a new row into the JobStatus table
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT INTO dbo.JobStatus
      (LocationID, ServerName, JobName, Success, DateDataCollectedFor, ExecutedDate, DatabaseName)
   VALUES
      (@LocationID, @ServerName, @JobName, @Success, @DateDataCollectedFor, GETDATE(), DB_NAME())
END TRY

BEGIN CATCH
   SELECT
      @ErrorNumber =  ERROR_NUMBER()
      ,@ErrorMessage = ERROR_MESSAGE()

   INSERT INTO CASINO_EVENT_LOG
      (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
   VALUES
      ('SP', @StoredProc, @ErrorMessage, @ErrorNumber, '00000')
END CATCH
GO
