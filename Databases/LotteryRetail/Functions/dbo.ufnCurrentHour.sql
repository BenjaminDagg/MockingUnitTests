SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnCurrentHour

Created 11-16-2010 by Terry Watkins

Purpose: Returns the current hour.

Returns: DateTime value


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-16-2010     DCLRetail v1.0.0
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnCurrentHour]() RETURNS Int
AS

BEGIN
   -- Variable Declarations
   DECLARE @CurrentTime    DateTime
   DECLARE @CurrentDate    DateTime
   DECLARE @ReturnValue    Int

   -- Store the current Date and Time.
   SET @CurrentTime = GetDate()
   
   -- Store just the date portion of the current date and time in the return value.
   SET @CurrentDate = CAST(FLOOR(CAST(@CurrentTime AS FLOAT)) AS DATETIME)
   
   -- Calculate the number of hours from midnight to now.
   SET @ReturnValue = DateDiff(Hour, @CurrentDate, @CurrentTime)
   
   -- Set the function return value.
   RETURN @ReturnValue
END
GO
