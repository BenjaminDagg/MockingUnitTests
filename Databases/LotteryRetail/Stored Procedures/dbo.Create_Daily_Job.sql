SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: Create_Daily_Job user stored procedure.

  Created: 11/11/2002 by Terry Watkins

  Purpose: Creates a scheduled job that is executed daily at the specified time.

Arguments: @DBName:          Database name, required by JobStep
           @JobName:         Name by which the scheduled job will be referenced.
           @JobDescription:  Description of the job.
           @JobStepCommand:  SQL statement to be executed.
           @JobScheduleName: Name by which the job schedule will be referenced.
           @StartTime:       Time of day when the job is to be run.
           @OwnerLoginName:  User name that owns the Job.
           @EnabledState:    Flags if job is to be enabled (0 = no, 1 = yes)

  Returns: 0 to indicate success or 1 to indicate failure.

Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
DGETAW        11/11/2002 Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Create_Daily_Job]
   @DBName           VarChar(32),
   @JobName          VarChar(64),
   @JobDescription   VarChar(256),
   @JobStepCommand   VarChar(1024),
   @JobScheduleName  VarChar(64),
   @StartTime        Int,
   @OwnerLoginName   VarChar(32),
   @EnabledState     TinyInt

AS

-- Declare local vars...
DECLARE @JobID       Binary(16)
DECLARE @StepCommand Varchar(128)
DECLARE @ReturnCode  INT

-- Assume procedure will succeed.
SELECT @ReturnCode = 0


BEGIN TRANSACTION

   -- Make sure that the job category that we want to use exists.
   IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = N'Database Maintenance') < 1 
     EXECUTE msdb.dbo.sp_add_category @name = N'Database Maintenance'


   -- Drop the job if it already exists.
   SELECT @JobID = job_id FROM msdb.dbo.sysjobs WHERE name = @JobName

   IF (@JobID IS NOT NULL)
      BEGIN
         EXECUTE msdb.dbo.sp_delete_job @job_name = @JobName
         SELECT @JobID = NULL
      END

   -- Create the new Job...

   -- Add the job
   EXECUTE @ReturnCode = msdb.dbo.sp_add_job 
           @job_id = @JobID OUTPUT,
           @job_name = @JobName,
           @owner_login_name = @OwnerLoginName,
           @description = @JobDescription, 
           @category_name = 'Database Maintenance',
           @enabled = 0,
           @notify_level_email = 0,
           @notify_level_page = 0,
           @notify_level_netsend = 0,
           @notify_level_eventlog = 2,
           @delete_level= 0

   -- Handle any errors.
   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

   -- Add the Job Step (defines the work to be done)
   EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep
      @job_id = @JobID, 
      @step_id = 1, 
      @step_name = 'Step1', 
      @command = @JobStepCommand,
      @database_name = @DBName, 
      @server = '', 
      @database_user_name = '', 
      @subsystem = 'TSQL', 
      @cmdexec_success_code = 0, 
      @flags = 0, 
      @retry_attempts = 0, 
      @retry_interval = 1, 
      @output_file_name = '', 
      @on_success_step_id = 0, 
      @on_success_action = 1, 
      @on_fail_step_id = 0, 
      @on_fail_action = 2

   -- Handle any errors.
   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

   -- Set the job start step...
   EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1

   -- Handle any errors.
   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

   -- Add the Job Schedule (defines the start time and frequency for the job run)
   EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule 
      @job_id = @JobID,
      @name = @JobScheduleName,
      @enabled = 1,
      @freq_type = 4, 
      @active_start_date = 20020930,
      @active_start_time = @StartTime,
      @freq_interval = 1,
      @freq_subday_type = 1, 
      @freq_subday_interval = 0, 
      @freq_relative_interval = 0, 
      @freq_recurrence_factor = 1, 
      @active_end_date = 99991231, 
      @active_end_time = 235959

   -- Handle any errors.
   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

   -- Add the Target Servers
   EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)'

   -- Handle any errors.
   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

   -- Enable the job if appropriate...
   IF @EnabledState > 0
      BEGIN
         EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @enabled = 1

         -- Handle any errors.
         IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
      END

   -- Commit transactions
   COMMIT TRANSACTION

   -- Bypass rollback.
   GOTO EndSave

QuitWithRollback:
   -- An error occurred, rollback any work done and reset the return code value...
   IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
   SET @ReturnCode = 1

EndSave:
   -- Return 0 for success, non-zero indicates an error.
   RETURN @ReturnCode
GO
