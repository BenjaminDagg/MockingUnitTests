SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnGetAcctDateFromDate

Created 11-24-2010 by Terry Watkins

Purpose: Returns the accounting Date of the specified datetime.

Returns: DateTime value


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-24-2010     v7.2.4
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnGetAcctDateFromDate](@DateTime AS DateTime) RETURNS DateTime
AS

BEGIN
   -- Variable Declarations
   DECLARE @CurrentTime    DateTime
   DECLARE @ReturnValue    DateTime
   DECLARE @ToTime         DateTime

   DECLARE @CutoffSeconds  Int
   DECLARE @CurrentSeconds Int

   -- Store the current Date and Time.
   SET @CurrentTime = GetDate()
   
   -- Store just the date portion of the incoming date-time in the return value.
   SET @ReturnValue = CAST(FLOOR(CAST(@DateTime AS FLOAT)) AS DATETIME)
   
   -- Get the number of seconds past midnight for the beginning of the accounting day.
   SET @CutoffSeconds = dbo.ufnGetCutoffSeconds()
   
   -- Calculate the number of seconds past midnight for the incoming date-time value.
   SET @CurrentSeconds  = (3600 * DATEPART (Hour, @DateTime)) + (60 * DATEPART (Minute, @DateTime)) + DATEPART (Second, @DateTime)

   -- If @CurrentSeconds < @CutoffSeconds then substract 1 day from the accounting date.
   IF @CurrentSeconds < @CutoffSeconds
      SET @ReturnValue = DateAdd(day, -1, @ReturnValue)
      
   -- Set the function return value.
   RETURN @ReturnValue
END
GO
