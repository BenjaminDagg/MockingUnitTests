SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: UnlockAppUser

Desc: Update the AccountLockeOut flag in the AppUser table.

Return value: 0 on success or error code.

Called by: Lottery Management System

Parameters:
   @AppUserID  Int             ID of the user being updated
   
Created on 03-13-2012 by Aldo Zamora

Change Log:
Changed By    Date
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   03-13-2012
  Initial Coding
  
Aldo Zamora   03-20-2012
  Also cleared FailedLoginAttempts and LastFailedLoginAttempt
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[UnlockAppUser]
   @AppUserID  Int
   
AS

-- Update data into AppUser table...
UPDATE [AppUser]
   SET
      AccountLockedOut       = 0,
      FailedLoginAttempts    = 0,
      LastFailedLoginAttempt = NULL 
WHERE AppUserID = @AppUserID

-- Return the error value.
RETURN @@ERROR
GO
