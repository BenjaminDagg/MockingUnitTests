SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: UpdateAppUserPassword

Desc: Update the AppUser password in the AppUser table.

Return value: 0  Success.
              -1 Password is current password.
              -2 Password was previously used.

Called by: Lottery Management System

Parameters:
   @AppUserID     INT           ID of the user being updated
   @Password      VARBINARY(64) Users password
   @PasswordReset BIT           Was the password reset by an admin level user?  
Created on 12-01-2010 by Aldo Zamora

Change Log:
Changed By    Date
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   12-01-2010
  Initial Coding

Aldo Zamora   03-07-2012
  Added Password UpdateDate, reset the AccountLockOut and PasswordReset flag
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[UpdateAppUserPassword]
   @AppUserID     Int,
   @Password      VARCHAR(64),
   @PasswordReset BIT
  
AS

-- Variable Declaration section
DECLARE @Current INT
DECLARE @History INT
DECLARE @LastPasswordCount INT
DECLARE @ReturnValue INT
DECLARE @UpdateDate DATETIME
DECLARE @PasswordTable TABLE ([Password] VARBINARY(64))
DECLARE @PasswordHistoryON BIT

-- Get and Set the AccountingDate
SET @UpdateDate = dbo.ufnGetAcctDateFromDate(GETDATE())

-- Is PasswordHistory On?
SELECT @PasswordHistoryON = ItemValueBit
FROM AppSetting
WHERE ItemKey = 'PasswordHistory'

-- If PasswordHistory is on verify the new password wasn't previously used.
IF (@PasswordHistoryON = 1) 
   BEGIN
      -- Get the number of last passwords used new password will be check against.
      SELECT @LastPasswordCount = ItemValueInt
      FROM AppSetting
      WHERE ItemKey = 'PasswordHistory'
      
      -- Get the last passwords used and store them in a variable table.
      INSERT @PasswordTable
      SELECT TOP (@LastPasswordCount) [Password]
      FROM PasswordHistory
      WHERE AppUserID = @AppUserID
      ORDER BY DateChanged DESC
      
      -- Set flag to true if the new password is the current password?
      SELECT @Current = (SELECT COUNT(AppUserID) AS UserCount
                         FROM AppUser
                         WHERE AppUserID = @AppUserID AND [Password] = CONVERT(VARBINARY(64), @Password))
      -- Set the flag to true if the new password was one of the last password used?
      SELECT @History = (SELECT COUNT ([Password]) AS PasswordCount
                         FROM @PasswordTable WHERE [password] = CONVERT(VARBINARY(64), @Password))
   	
   END
ELSE
   -- PasswordHistory is off.
   BEGIN
      SET @Current = 0
      SET @History = 0
   END
   
-- Is the current password flag on?
IF (@Current = 0)
   BEGIN
      -- Is the last password used flag of?
      IF (@History = 0) 
         BEGIN
         
            SET @ReturnValue = 0
         
            -- Update data into AppUser table with the new password...
            UPDATE [AppUser]
            SET
               [Password] = CONVERT(VARBINARY(64), @Password),
               PasswordDate = @UpdateDate,
               PasswordReset = @PasswordReset,
               AccountLockedOut = 0
            WHERE AppUserID = @AppUserID
            
            -- If password history is on and the user is updating the password
            -- update the password history table.
            IF (@PasswordHistoryON = 1 AND @PasswordReset = 0)
               BEGIN
                  INSERT INTO [dbo].[PasswordHistory]
                     ([AppUserID], [Password])
                  VALUES
                     (@AppUserID, CONVERT(VARBINARY(64), @Password))
               END
         END
      ELSE 
         BEGIN
            -- Password was previously used.
            SET @ReturnValue = -2
         END
   END
ELSE 
   BEGIN
      -- Password is the current password.
      SET @ReturnValue = -1
   END 

-- Return value.
RETURN @ReturnValue
GO
