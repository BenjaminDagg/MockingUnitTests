
--DECLARE @AppUserID     Int
--DECLARE @Password      VARCHAR(64)
--DECLARE @PasswordReset BIT
  
--SET @AppUserID = 21
--SET @Password = 'a776b2bf370eadebae6ee8191fa8a55d'
--SET @PasswordReset = 1

-- Variable Declaration section
DECLARE @Current INT
DECLARE @History INT
DECLARE @LastPasswordCount INT
DECLARE @ReturnValue INT
DECLARE @UpdateDate DATETIME
DECLARE @PasswordTable TABLE ([Password] VARCHAR(128))
DECLARE @PasswordHistoryON BIT

-- Get and Set the AccountingDate
SET @UpdateDate = dbo.ufnGetAcctDateFromDate(GETDATE())

-- Is PasswordHistory On?

SELECT @LastPasswordCount = CAST(ConfigValue AS INT)
FROM AppConfig
WHERE ConfigKey = 'PreviousPasswordLimit'

-- Yes, set the value.

IF (@LastPasswordCount > 0)
   BEGIN
	 SET @PasswordHistoryON = 1	 
   END
ELSE
   BEGIN
	 SET @PasswordHistoryON = 0
	 SET @LastPasswordCount = 0
   END
   
   
-- If PasswordHistory is on verify the new password wasn't previously used.
IF (@PasswordHistoryON = 1) 
   BEGIN
            
      -- Get the last passwords used and store them in a variable table.
      INSERT @PasswordTable
      SELECT TOP (@LastPasswordCount) [Password]
      FROM AppPasswordHistory
      WHERE AppUserID = @AppUserID
      ORDER BY CreatedDate DESC
      
      -- Set flag to true if the new password is the current password?
      SELECT @Current = (SELECT COUNT(AppUserID) AS UserCount
                         FROM AppUser
                         WHERE AppUserID = @AppUserID AND [Password] = @Password)
      -- Set the flag to true if the new password was one of the last password used?
      SELECT @History = (SELECT COUNT ([Password]) AS PasswordCount
                         FROM @PasswordTable WHERE [password] = @Password)
   	
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
               [Password] = @Password,
               LastPasswordChangeDate = @UpdateDate,
               IsPasswordChangeRequired = @PasswordReset,
               IsLocked = 0
            WHERE AppUserID = @AppUserID
            
            -- If password history is on and the user is updating the password
            -- update the password history table.
            IF (@PasswordHistoryON = 1 AND @PasswordReset = 0)
               BEGIN
                  INSERT INTO [dbo].[AppPasswordHistory]
                     ([AppUserID], [Password])
                  VALUES
                     (@AppUserID, @Password)
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
SELECT @ReturnValue
