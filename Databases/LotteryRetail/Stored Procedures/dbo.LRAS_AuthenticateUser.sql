SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure Name: LRAS_AuthenticateUser

Created By:     Edris Khestoo

Create Date:    3-10-2012

Description:    Handles login requests from LRAS application.

Returns:        0 = Invalid Login
                1 = Valid Login

Parameters:     Username and Password.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Edris Khestoo 03-10-2012     v3.0.4
  Initial Coding.
  
 Edris Khestoo 06-14-2012    v3.0.6
   Added paramater IsAuthorizeMode that determines if this is a authorize payment
   login attempt. If so use LOGIN_TRACKING_AUTHORIZE from CASINO_SYSTEM_PARAMETERS
   table to use different values when determining if a user has excceeded login 
   attempt limit.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[LRAS_AuthenticateUser] 
      @AccountID VarChar(10),
      @Password VarChar(64),
      @IsAuthorizeMode BIT = 0 
AS

SET NOCOUNT ON

-- Declare Variables
DECLARE @IsValidUser                   BIT
DECLARE @Authenticated                 BIT
DECLARE @LastFailedLoginDate           DATETIME
DECLARE @FailedAttempts                INT 
DECLARE @MinutesSinceLastFailedLogin   INTEGER
DECLARE @AccountLocked                 BIT
DECLARE @LevelCode                     VARCHAR(15)

-- Declare and Set Threshold Settings
DECLARE @LockoutThresholdSetting       INT 
DECLARE @LockoutEnabledSetting         BIT 
DECLARE @LockoutDurationSetting        INT

-- Get Password History settings values
DECLARE @MaxPasswordAge AS INT
DECLARE @DaysBeforeExpireWarning AS INT
DECLARE @IsPasswordAgeEnabled AS BIT 

SET @Authenticated = 0
SET @MaxPasswordAge =  ISNULL((SELECT CAST(ISNULL(VALUE1, 0) AS INT) FROM dbo.CASINO_SYSTEM_PARAMETERS CP WHERE CP.PAR_NAME = 'PASS_EXPIRE_DAYS'), 0);
SET @DaysBeforeExpireWarning = ISNULL((SELECT CAST(ISNULL(VALUE2, 0) AS INT) FROM dbo.CASINO_SYSTEM_PARAMETERS CP WHERE CP.PAR_NAME = 'PASS_EXPIRE_DAYS'), 0);

IF (@MaxPasswordAge > 0)
   SET @IsPasswordAgeEnabled = 1
ELSE
   SET @IsPasswordAgeEnabled = 0
   
   
-- Get Threshold Settings From [CASINO_SYSTEM_PARAMETERS]
IF @IsAuthorizeMode = 0
   BEGIN 
  
      SELECT @LockoutEnabledSetting = CONVERT(BIT, ISNULL(VALUE1, 0))
            ,@LockoutThresholdSetting = CONVERT(INT, ISNULL(VALUE2, 0))
            ,@LockoutDurationSetting = CONVERT(INT, ISNULL(VALUE3, 0))
      FROM [dbo].[CASINO_SYSTEM_PARAMETERS]
      WHERE PAR_NAME = 'LOGIN_TRACKING'
     
   END
ELSE
   BEGIN
      SELECT @LockoutEnabledSetting = CONVERT(BIT, ISNULL(VALUE1, 0))
            ,@LockoutThresholdSetting = CONVERT(INT, ISNULL(VALUE2, 0))
            ,@LockoutDurationSetting = CONVERT(INT, ISNULL(VALUE3, 0))
      FROM [dbo].[CASINO_SYSTEM_PARAMETERS]
      WHERE PAR_NAME = 'LOGIN_TRACKING_AUTHORIZE'
   END


-- Get User Previous Login Information
SELECT   @AccountLocked = ISNULL(IS_ACCOUNT_LOCKED, 0),
         @FailedAttempts = ISNULL(INVALID_ATTEMPTS, 0),
         @LastFailedLoginDate = ISNULL(LAST_INVALID_ATTEMPT, GETDATE())
FROM [dbo].[CASINO_USERS]
WHERE ACCOUNTID = @AccountID

-- Get the Minutes elapsed since last login (used for reset)
SET @MinutesSinceLastFailedLogin = DATEDIFF(mi,@LastFailedLoginDate, GETDATE())

-- If Lockout setting is disabled, or account is locked but past 30 minutes
IF (@LockoutEnabledSetting = 0) OR (@AccountLocked = 1 AND @MinutesSinceLastFailedLogin >= @LockoutDurationSetting)
   BEGIN
      SET @AccountLocked = 0
      
   -- Reset Login info
      UPDATE [dbo].CASINO_USERS
   SET INVALID_ATTEMPTS = 0,
       LAST_INVALID_ATTEMPT = NULL,
       IS_ACCOUNT_LOCKED = 0
   WHERE ACCOUNTID = @AccountID
   END

 -- Check user credienticals
 IF (SELECT COUNT(*) FROM Casino_Users CU RIGHT OUTER JOIN Level_Permissions LP ON CU.Level_Code = LP.Level_Code WHERE AccountId = @AccountID AND PHASH = @Password) = 1
   BEGIN
      SET @Authenticated = 1 
   END
 ELSE
   BEGIN
      SET @Authenticated = 0
   END
       
 -- If Account is not locked, then check credientals, check invalid attempts 
 IF (@AccountLocked = 0)
   BEGIN
        -- Check the username and password 
      SET @IsValidUser = @Authenticated
                            
         -- IF valid login, reset lockout counters           
         IF (@IsValidUser = 1)
            BEGIN
               SET @AccountLocked = 0
               
            -- Reset Login info
               UPDATE [dbo].CASINO_USERS
            SET INVALID_ATTEMPTS = 0,
                LAST_INVALID_ATTEMPT = NULL,
                IS_ACCOUNT_LOCKED = 0
            WHERE ACCOUNTID = @AccountID
            
            END
         ELSE
            BEGIN
               IF (@LockoutEnabledSetting = 1)         
               BEGIN
                  IF (@FailedAttempts = @LockoutThresholdSetting - 1)
                     BEGIN
                        SET @AccountLocked = 1 
                        -- Set Lockout
                        UPDATE [dbo].CASINO_USERS
                     SET INVALID_ATTEMPTS = INVALID_ATTEMPTS + 1,
                         LAST_INVALID_ATTEMPT = GETDATE(),
                         IS_ACCOUNT_LOCKED = 1
                     WHERE ACCOUNTID = @AccountID
                     END
                  ELSE
                     BEGIN
                        -- Add counter and update last invalid attempt
                        UPDATE [dbo].CASINO_USERS
                     SET INVALID_ATTEMPTS = INVALID_ATTEMPTS + 1,
                         LAST_INVALID_ATTEMPT = GETDATE()
                     WHERE ACCOUNTID = @AccountID
                     END
               END
            END
   END
  
   -- Was The Username and password correct?
   IF (@IsValidUser = 1)
      BEGIN
         -- Do a second detailed lookup and return user info
         SELECT 
                @Authenticated [IsAuthenticated],
                @IsValidUser [IsValid], 
                @AccountLocked [IsLocked],
                @FailedAttempts [FailedAttempts],
                @LockoutThresholdSetting [FailedAttemptThreshold],
                
                CU.Active,
                CU.UserLogged,
                CU.ACCOUNTID,
                CU.Level_Code,
                CU.FNAME,
                CU.LNAME,
                LP.Security_Level,
                CU.INVALID_ATTEMPTS,
                CU.LAST_INVALID_ATTEMPT,
                CU.IS_PASSRESET,
                @IsPasswordAgeEnabled IsPasswordAgeEnabled,
                CASE WHEN @MaxPasswordAge > 0  THEN (SELECT ( @MaxPasswordAge - DATEDIFF(DAY, CU.PHASHDT, GETDATE())))       
                     ELSE 0
                END AS  DaysLeftToExpire,
                @DaysBeforeExpireWarning DaysBeforeExpireWarning
         FROM Casino_Users CU RIGHT OUTER JOIN Level_Permissions LP ON CU.Level_Code = LP.Level_Code 
         WHERE AccountId = @AccountID AND PHASH = @Password       
      END
    ELSE
      BEGIN 
         -- Invalid User/Name password return 1 or 0 for each column to indicate failure
         SELECT ISNULL(@Authenticated, 0) [IsAuthenticated], 
                ISNULL(@IsValidUser, 0) [IsValid], 
                ISNULL(@AccountLocked, 0) [IsLocked],
                ISNULL(@FailedAttempts, 0) [FailedAttempts],
                ISNULL(@LockoutThresholdSetting, 0) [FailedAttemptThreshold]
      END
  
GO
