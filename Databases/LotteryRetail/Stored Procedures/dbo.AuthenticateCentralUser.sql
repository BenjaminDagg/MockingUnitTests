SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure Name: AuthenticateCentralUser

Created By:     Louis Epstein

Create Date:    9-19-2013

Description:    Handles login requests from central users accessing the LRAS application by querying central system.

Returns:        AppUserID, DaysLeft, PasswordReset, LevelCode

Parameters:     Username, Password, Workstation.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 09-19-2013     v3.1.5
  Initial Coding.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[AuthenticateCentralUser] 
      @AccountID VarChar(10),
      @Password VarChar(64),
      @Workstation VarChar(64)
AS

SET NOCOUNT ON

DECLARE @sqlQuery nvarchar(max)

SELECT @sqlQuery = VALUE1 + '.AuthenticateUser ''' + @AccountID + ''', ''' + @Password + ''', ' + CAST((SELECT LOCATION_ID FROM dbo.CASINO WHERE SETASDEFAULT = 1) AS nvarchar(max)) + ', ''' + @Workstation + '''' FROM dbo.CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'CENTRAL_SERVER_LINK'
EXEC(@sqlQuery)


  
GO
