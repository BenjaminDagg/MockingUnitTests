SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function UserInRole

Created 07-22-2008 by Aldo Zamora

Purpose: Checks to see if a user is in a database role.

Returns: Bit value True or False


Change Log

Changed By    Date            Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora 07-22-2008        v6.0.1
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[UserInRole] (@RoleName VarChar(64), @UserName VarChar(64)) RETURNS Bit
AS

BEGIN
   -- Variable Declarations
   DECLARE @InRole BIT
   
   -- Check to see if user exists and is in database role
   IF EXISTS(SELECT *
      FROM sys.database_principals p
         LEFT JOIN sys.database_role_members rm ON p.principal_id = rm.member_principal_id
      WHERE
         p.name = @UserName AND
         rm.role_principal_id IN (SELECT principal_id FROM sys.database_principals WHERE name = @RoleName))
      -- Set variable to true or false if user is in role
      BEGIN
         SET @InRole = 1
      END
   ELSE
      BEGIN
         SET @InRole = 0
      END
   
   -- Set the function return value.
   RETURN @InRole

END
GO
