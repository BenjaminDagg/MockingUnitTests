SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diHandleLogin

Created By:     Terry Watkins

Create Date:    10-01-2003

Description:    Handles login requests from Deal Import application.

Returns:        0 = Invalid Login
                1 = Valid Login

Parameters:     Username and Password.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-21-2007     v6.0.1
  Rewrote to include functionality that sets IsDgeTech flag to false if the
  account is not active and returns more information so calling app can tell
  user why login failed.  Also added ISNULL check for first and last names.

Terry Watkins 06-09-2010     v7.2.2
  Added retrieval of new CASINO.MIN_DI_VERSION so Deal Import won't run if the
  version is too old.
  
 Edris Khestoo 12-15-2011    v3.0.0
 Changed password column reference on CASINO_USERS from PSSWD to PHASH
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[diHandleLogin] @AccountID VarChar(10), @Password nVarChar(128)
AS

SET NOCOUNT ON

-- Declare Variables
DECLARE @FullName      VarChar(64)
DECLARE @AcctExists    Bit
DECLARE @IsActive      Bit
DECLARE @PwdMatch      Bit
DECLARE @IsDgeTech     Int
DECLARE @MinDiVersion  Int

-- [Variable Init]
SET @AcctExists   = 0
SET @PwdMatch     = 0
SET @MinDiVersion = 7000

-- Retrieve the Minimum Deal Import version from the CASINO table
SELECT @MinDiVersion = MIN_DI_VERSION FROM CASINO WHERE SETASDEFAULT = 1

-- Does the account exist?
IF EXISTS(SELECT * FROM CASINO_USERS WHERE ACCOUNTID = @AccountID)
   SET @AcctExists = 1

-- Does the account/password combination exist?
IF EXISTS(SELECT * FROM CASINO_USERS WHERE ACCOUNTID = @AccountID AND PHASH = @Password)
   -- Account exists.
   BEGIN
      -- Password is good.
      SET @PwdMatch = 1
      
      -- Retrieve Full Name and DGE Tech flag.
      SELECT
         @IsDgeTech = ISNULL(Is_DGE_Tech, 0),
         @FullName  = RTRIM(LTRIM(ISNULL(FNAME, '') + ' ' + ISNULL(LNAME, ''))),
         @IsActive  = ISNULL(ACTIVE, 0)
      FROM CASINO_USERS
      WHERE ACCOUNTID = @AccountID AND PHASH = @Password
   END
ELSE
   -- Account/Password combo does not exist.
   BEGIN
      SET @IsDgeTech = 0
      SET @FullName  = ''
      SET @IsActive  = 0
      IF (@AcctExists = 1) SET @PwdMatch = 0
   END

-- Set the procedure resultset.
SELECT
   @AcctExists   AS AMATCH,
   @PwdMatch     AS PMATCH,
   @FullName     AS FULL_NAME,
   @IsDgeTech    AS IS_DGE_TECH,
   @IsActive     AS ACTIVE,
   @MinDiVersion AS MIN_DI_VERSION

-- If the account is not active, set IsDgeTech to zero.
IF (@IsActive = 0) SET @IsDgeTech = 0

-- Return value
RETURN @IsDgeTech
GO
