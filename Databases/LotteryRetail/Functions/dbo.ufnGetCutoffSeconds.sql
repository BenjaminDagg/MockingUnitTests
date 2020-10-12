SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnGetCutoffSeconds

Created 07-25-2008 by Terry Watkins

Purpose: Calculates the number of seconds from midnight to the accounting
         cutoff time.

Returns: Integer seconds value


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-20-2005     v6.0.1
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnGetCutoffSeconds]() RETURNS Integer
AS

BEGIN
   -- Variable Declarations
   DECLARE @ReturnValue     Int
   
   -- Retrieve the number of seconds per shift and the number of seconds into the accounting day...
   SELECT @ReturnValue = (3600 * DATEPART (Hour, TO_TIME)) + (60 * DATEPART (Minute, TO_TIME)) + DATEPART (Second, TO_TIME)
   FROM CASINO
   WHERE SETASDEFAULT = 1
   
   -- Set the function return value.
   RETURN @ReturnValue
END

GO
