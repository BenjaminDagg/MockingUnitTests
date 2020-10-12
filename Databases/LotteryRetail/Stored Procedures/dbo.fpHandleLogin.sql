SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: fpHandleLogin

Created By:     Aldo Zamora

Create Date:    11-14-2011

Description:    Handles login requests from the Free Play application.

Returns:
   Return Value 
    0 = Successful login.
   -1 = Invalid AccountID value.
   -2 = DeActivated User.
   -3 = Invalid password.
   -4 = AccountID not an Admin or Supervisor.

Parameters:     Username and Password.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   11-14-2011     v7.2.5
   Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[fpHandleLogin] @AccountID VARCHAR(10), @Password VARCHAR(128)
AS

SET NOCOUNT ON

-- Declare Variables
DECLARE @AcctExists     BIT
DECLARE @HashedPassword VARCHAR(42)
DECLARE @IsActive       BIT
DECLARE @LevelCode      VARCHAR(15)
DECLARE @ReturnValue    INT

-- [Variable Init]
SET @ReturnValue = 0
SET @HashedPassword = CONVERT(VARCHAR(42), HASHBYTES('MD5', @Password), 2)

-- Does the account exist?
IF EXISTS(SELECT * FROM CASINO_USERS WHERE ACCOUNTID = @AccountID) SET @AcctExists = 1
      
IF @AcctExists = 1
   BEGIN
      -- Does the account/password combination exist? 
   	IF EXISTS(SELECT * FROM CASINO_USERS WHERE ACCOUNTID = @AccountID AND PHASH = @HashedPassword)
   	   BEGIN
   	      -- Yes, Retrieve the LEVEL_CODE and ACTIVE flag. 
            SELECT
               @LevelCode = LEVEL_CODE,
               @IsActive  = ACTIVE
            FROM dbo.CASINO_USERS
            WHERE ACCOUNTID = @AccountID AND PHASH = @HashedPassword
            
            -- Is the AccountID active?
            IF @IsActive = 1
               BEGIN
                  -- Yes, is the AccountID a supervisor or admin?
                  IF @LevelCode NOT IN('SUPERVISOR', 'ADMIN')
                     -- No, set the return value to AccountID not an Admin or Supervisor.
                     SET @ReturnValue = -4
                  ELSE
                     -- Yes, set the return value Successful login.
                     SET @ReturnValue = 0
               END
            ELSE
               -- No, set the return value to DeActivated AccountID.
               SET @ReturnValue = -2	   
         END
      ELSE
         -- Invalid password
         SET @ReturnValue = -3
   END
ELSE
   BEGIN
      -- No, set the return value to Invalid AccountID.
      SET @ReturnValue = -1
   END

-- Set the Return value.
RETURN @ReturnValue
GO
