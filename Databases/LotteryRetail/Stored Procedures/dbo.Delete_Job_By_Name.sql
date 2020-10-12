SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: Delete_Job_By_Name user stored procedure.

  Created: 11-11-2002 by Terry Watkins

  Purpose: Deletes a scheduled job

Arguments: @JobName: Name of the scheduled job to be deleted.

  Returns: 0 to indicate success or 1 to indicate failure.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-11-2002
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Delete_Job_By_Name] @JobName VarChar(64)

AS

-- Declare local vars...
DECLARE @JobID       Binary(16)
DECLARE @StepCommand Varchar(128)
DECLARE @ReturnCode  INT

SET @ReturnCode = 0

-- Drop the job if it already exists.
SELECT @JobID = job_id FROM msdb.dbo.sysjobs WHERE name = @JobName

IF (@JobID IS NOT NULL)
   BEGIN
      EXECUTE msdb.dbo.sp_delete_job @job_name = @JobName
      SELECT @JobID = NULL
   END

-- Handle any errors.
IF @@ERROR <> 0 SET @ReturnCode = 1

-- Return 0 for success or 1 to indicate that an error has occurred.
RETURN @ReturnCode
GO
