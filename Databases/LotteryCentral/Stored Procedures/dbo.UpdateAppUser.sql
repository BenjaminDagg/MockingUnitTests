SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: UpdateAppUser

Desc: Update the AppUser in the AppUser table.

Return value: 0 on success or error code.

Called by: Lottery Management System

Parameters:
   @AppUserID  Int             ID of the user being updated
   @UserID     VarChar(16)     Users login string
   @FullName   VarChar(64)     Users full name
   @IsActive   Bit				 Active Flag

Created on 09-14-2010 by Aldo Zamora

Change Log:
Changed By    Date
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   09-14-2010
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[UpdateAppUser]
   @AppUserID  Int,
   @UserID     VarChar(16),
   @FullName   VarChar(64),
   @IsActive   Bit
   
AS

-- Update data into AppUser table...
UPDATE [AppUser] SET
   UserID     = @UserID,
   FullName   = @FullName,
   IsActive   = @IsActive
WHERE AppUserID = @AppUserID

-- Return the error value.
RETURN @@ERROR
GO
