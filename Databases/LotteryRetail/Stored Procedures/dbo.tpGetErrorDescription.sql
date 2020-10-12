SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: tpGetErrorDescription

Desc: Gets an error description for a give error id.

Return values: varchar(256)

Called by: Transaction Portal

Parameters: @Error_No

Auth: Chris Coddington

Date: 4/11/2003

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-31-2004
  Added default values if row not found.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetErrorDescription] @Error_No Int
AS

SELECT
   ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@Error_No AS Varchar(10)) + '.')  AS ErrorDescription,
   ISNULL(LOCKUP_MACHINE, 1)   AS ShutDownFlag,
   ISNULL(ERROR_NO, @Error_No) AS ErrorID 
FROM ERROR_LOOKUP
WHERE ERROR_NO = @Error_No
GO
