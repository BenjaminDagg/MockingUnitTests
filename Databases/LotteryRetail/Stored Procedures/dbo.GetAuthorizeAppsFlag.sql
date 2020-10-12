SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: GetAuthorizeAppsFlag user stored procedure.

  Created: 06-08-2009 by Terry Watkins  

  Purpose: Retrieves a value indicating if control application authorization is
           required (to support GLI requirement)


Arguments: None

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
06-08-2009 Terry Watkins     v6.0.7
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetAuthorizeAppsFlag]
AS

-- Variable Declarations
DECLARE @AuthenticateApps  Integer

-- Variable Initialization
SET @AuthenticateApps = 0

-- Does column CASINO.AUTHENICATE_APPS exist?
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CASINO' AND COLUMN_NAME = 'AUTHENTICATE_APPS')
   BEGIN
   -- Yes, so retrieve the value.
      SELECT @AuthenticateApps = CAST(AUTHENTICATE_APPS AS INT) FROM CASINO WHERE SETASDEFAULT = 1
   END

-- Set the return value
RETURN @AuthenticateApps
GO
