SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: AuthenticateUser

Desc: Authenticates user for the Lottery Management System.

Return values: 
   AppUser ID on success or
   -1 = Invalid LoginID value.
   -2 = DeActivated User.
   -3 = Invalid password.
   -4 = Account is locked.
      
Called by: Lottery Management System 

Parameters:
   @UserID     VarChar(16)     User login string
   @Password   VarChar(64)     User password string

Created on 09-15-2010 by Aldo Zamora

Change Log:

Changed By    Date
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   09-15-2010
  Initial Coding

Aldo Zamora   03-06-2012
  Added password expiration check and Account lockout functionality

Louis Epstein   09-18-2013
  Added retail group functionality

Louis Epstein   08-29-2014
  Modified procedure to use new AppUser schema
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[AuthenticateUser] @UserID VARCHAR(16), @Password VARCHAR(64), @LocationID INT = NULL, @Workstation VARCHAR(64) = NULL
   
AS

-- Variable Declaration
DECLARE @AccountLocked            BIT
DECLARE @AccountLockoutDuration   INT
DECLARE @AccountLockoutDurationOn BIT
DECLARE @AppUserID                INT
DECLARE @AuthCount                INT
DECLARE @DaysLeft                 INT
DECLARE @FailedAttempts           INT
DECLARE @IsActive                 BIT
DECLARE @LastFailedLoginDT        DATETIME
DECLARE @MaxFailedAttempts        INT
DECLARE @MaxFailedAttemptsOn      BIT
DECLARE @PasswordDate             DATETIME
DECLARE @PasswordExpirationDays   INT
DECLARE @PasswordReset            BIT
DECLARE @DaysPasswordInUse        INT
DECLARE @ReturnValue              INT
DECLARE @ReturnTable              TABLE(AppUserID INT, DaysLeft INT, PasswordReset BIT, LevelCode VARCHAR(15), SecurityLevel SMALLINT)
DECLARE @TimeElapsed              INT
DECLARE @LevelCode				  VARCHAR(15)
DECLARE @EventDescription		  VARCHAR(4000)
DECLARE @EventCode				  INT
DECLARE @SecurityLevel			  SMALLINT
DECLARE @EpochDays				  INT


-- Variable Initialization
SET @AppUserID   = 0
SET @AuthCount   = 0
SET @DaysLeft    = 0
SET @ReturnValue = -1
SET @DaysLeft = 0
SET @PasswordReset = 0
SET @EventCode = 2
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())

-- Set PasswordExpirationDays value.
SELECT @PasswordExpirationDays = CAST(ConfigValue AS int)
FROM AppConfig
WHERE ConfigKey = 'PasswordExpirationDays'

-- Is MaxFailedAttempts On or off?
SELECT @MaxFailedAttemptsOn = CASE WHEN CAST(ConfigValue AS int) > 0 THEN 1 ELSE 0 END
FROM AppConfig
WHERE ConfigKey = 'AccountLockoutThreshold'
-- Yes, set the value.
IF (@MaxFailedAttemptsOn = 1)
   BEGIN
      SELECT @MaxFailedAttempts = CAST(ConfigValue AS int)
      FROM AppConfig
      WHERE ConfigKey = 'AccountLockoutThreshold'
   END


-- Yes, set AccountLockoutDuration value.
IF @MaxFailedAttemptsOn = 1
   BEGIN
      SELECT @AccountLockoutDuration = CAST(ConfigValue AS int)
      FROM AppConfig
      WHERE ConfigKey = 'AccountLockoutDuration'
   END

-- Get and set AppUser info...
SELECT
   @AppUserID         = AU.AppUserID,
   @IsActive          = IsActive,
   @PasswordDate      = LastPasswordChangeDate,
   @PasswordReset     = IsPasswordChangeRequired,
   @AccountLocked     = IsLocked,
   @FailedAttempts    = FailedPasswordAttemptCount,
   @LastFailedLoginDT = LastFailedPasswordAttemptDate,
   @LevelCode         = RG.LEVEL_CODE,
   @SecurityLevel	  = LC.SECURITY_LEVEL
FROM AppUser AU
JOIN 
(
		SELECT ISNULL(MAX(SECURITY_LEVEL), 0) AS SECURITY_LEVEL, AU.AppUserID FROM AppUser AU
		LEFT OUTER JOIN AppUserRole AUG ON AUG.AppUserID = AU.AppUserID
		LEFT OUTER JOIN AppRole AG ON AG.AppRoleId = AUG.AppRoleId
		LEFT OUTER JOIN AppRoleRetailGroup ARRG ON ARRG.AppRoleId = AUG.AppRoleId
		LEFT OUTER JOIN RetailGroup RG ON RG.RetailGroupID = ARRG.RetailGroupID
		GROUP BY AU.AppUserID
) LC ON AU.AppUserID = LC.AppUserID
JOIN RetailGroup RG ON RG.SECURITY_LEVEL = LC.SECURITY_LEVEL
WHERE AU.UserName = @UserID

-- Get and set the elapsed time value.
SET @TimeElapsed = DATEDIFF(mi, @LastFailedLoginDT, GETDATE())

-- Is AccountLockout on?
IF (@AccountLockoutDurationOn = 1)
   BEGIN
      -- Yes. Time has expired, unlock account.
      IF (@AccountLocked = 1 AND @TimeElapsed >= @AccountLockoutDuration)
         BEGIN
            -- Reset lockout.
            SET @AccountLocked = 0
	         
      	   UPDATE AppUser
         	SET FailedPasswordAttemptCount = 0,
         	   LastFailedPasswordAttemptDate = NULL,
         	   IsLocked = 0
         	WHERE AppUserID = @AppUserID
         END
   END
   
-- Verify username and password
IF (@AppUserID > 0)
   BEGIN
      -- Account is not locked.
      IF (@AccountLocked = 0)
         BEGIN
            -- Account is active.
            IF(@IsActive = 1)
               BEGIN
                  -- Is the password correct?
                  SELECT @AuthCount = COUNT(*)
                  FROM AppUser
                  WHERE AppUserID = @AppUserID AND [Password] = CONVERT(VARBINARY(64), @Password)
                  
                  -- Yes, get and set return values...
                  IF (@AuthCount = 1)
   	                 BEGIN
   	                    SET @DaysPasswordInUse = DATEDIFF(dd, @PasswordDate, GETDATE())
   	                    SET @ReturnValue = @AppUserID
   	                    SET @EventDescription = 'Successful Retail Login: User ID ' + @UserID + '.'
   	                    SET @EventCode = 1
   	                    SET @DaysLeft = @PasswordExpirationDays - @DaysPasswordInUse
                        
                        -- Reset failed login count.
   	                    IF (@MaxFailedAttemptsOn = 1)
   	                       BEGIN
   	                  	      UPDATE AppUser
   	                          SET FailedPasswordAttemptCount = 0,
   	                             LastFailedPasswordAttemptDate = NULL
   	                          WHERE AppUserID = @AppUserID
   	                       END
   	                 END
                  ELSE
                     BEGIN
                        -- Invalid password.
                        SET @ReturnValue = -3
                        SET @EventDescription = 'Retail Login Failed: Invalid password for User ID ' + @UserID + '.'
   		                
						-- If user has reached the max invalid login attempts lock the account...
   		                IF (@MaxFailedAttemptsOn = 1)
   		                   BEGIN
   		                      IF (@FailedAttempts = @MaxFailedAttempts - 1)
   		                         BEGIN
   		                            UPDATE AppUser
   		                            SET FailedPasswordAttemptCount = FailedPasswordAttemptCount + 1,
                                       IsLocked = 1, LastFailedPasswordAttemptDate = GETDATE()
   		                            WHERE AppUserID = @AppUserID
                                    
                                    SET @ReturnValue = -4
                                    SET @EventDescription = 'Retail Login Failed: Account is now locked for User ID ' + @UserID + '.'
                                    
                                 END
   		                      ELSE
   		                         BEGIN
   		                            UPDATE AppUser
   		                            SET FailedPasswordAttemptCount = FailedPasswordAttemptCount + 1, LastFailedPasswordAttemptDate = GETDATE()
   		                            WHERE AppUserID = @AppUserID	   	
   		                         END
   		                   END         
   		             END
   	           END
            ELSE
            BEGIN
               -- DeActivated User.
               SET @ReturnValue = -2
               SET @EventDescription = 'Retail Login Failed: User ID ' + @UserID + ' is deactivated.'
            END
         END
      ELSE
      BEGIN
         -- Account is locked.
         SET @ReturnValue = -4
         SET @EventDescription = 'Retail Login Failed: Account is now locked for User ID ' + @UserID + '.'
      END
   END
ELSE
BEGIN
   -- Invalid LoginID value.
   SET @ReturnValue = -1
   SET @EventDescription = 'Retail Login Failed: User ID ' + @UserID + ' is invalid.'
END

-- Insert return values into variable table.   
INSERT @ReturnTable (AppUserID, DaysLeft, PasswordReset, LevelCode, SecurityLevel) VALUES (@ReturnValue, @DaysLeft, @PasswordReset, @LevelCode, @SecurityLevel)

IF @LocationID IS NOT NULL
BEGIN
	INSERT EventLog ([PartionKey]
           ,[EventDate]
           ,[EventTypeId]
           ,[Description]
           ,[Details]
           ,[EventSource]
           ,[UserId]) VALUES (@EpochDays, GETDATE(), @EventCode, @EventDescription, NULL, 'LocationID:' + CAST(@LocationID AS nvarchar(max)) + ',Workstation:' + @Workstation, @AppUserID)
END

-- Return table.
SELECT * FROM @ReturnTable
GO
