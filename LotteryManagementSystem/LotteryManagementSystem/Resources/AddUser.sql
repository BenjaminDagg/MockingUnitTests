--DECLARE @UserName     VARCHAR(16)
--DECLARE @FirstName   VARCHAR(64)
--DECLARE @LastName	VARCHAR(64)
--DECLARE @Password   VARCHAR(64)


--SET @UserName = 'edrisk'
--SET @FirstName = 'Edris'
--SET @LastName = 'Khestoo'
--SET @Password = '123456'

DECLARE @PasswordDate DATETIME
DECLARE @ReturnValue INT

SET @PasswordDate = dbo.ufnGetAcctDateFromDate(GETDATE())
SET @ReturnValue = 0

-- Check if the UserID exists...
IF EXISTS(SELECT * FROM dbo.AppUser WHERE UserName = @UserName)
   BEGIN
      SET @ReturnValue = -1
   END
ELSE
    BEGIN
    
    
           
      -- Insert data into User table...
		INSERT INTO [AppUser] (
			[UserName]
           ,[Email]
           ,[FirstName]
           ,[LastName]
           ,[MiddleInitial]
           ,[Password]
           ,[IsLocked]
           ,[IsActive]
           ,[IsPasswordChangeRequired]
           ,[FailedPasswordAttemptCount]
           ,[LastPasswordChangeDate]
           ,[LastActivityDate]
           ,[LastFailedPasswordAttemptDate]
           ,[LastLoginDate]
           ,[LastLoginIpAddress]
		
		) 
		VALUES (
			 @UserName
			,NULL
			,@FirstName
			,@LastName
			,''
			,@Password
			,0
			,1
			,1
			,0
			,GETDATE()
			,GETDATE()
			,NULL
			,NULL
			,NULL)		
        
      SET @ReturnValue = SCOPE_IDENTITY()
	END

-- Return the LoginID value.
SELECT @ReturnValue