SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnGetAcctDate

Created 07-13-2009 by Terry Watkins

Purpose: Returns the current accounting Date.

Returns: DateTime value


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-13-2009     v6.0.8
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnGetAcctDate]() RETURNS DateTime
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
   
   -- Store just the date portion of the current date and time in the return value.
   SET @ReturnValue = CAST(FLOOR(CAST(@CurrentTime AS FLOAT)) AS DATETIME)
   
   -- Retrieve the CASINO.TO_TIME value (accounting cutoff time).
   SELECT @ToTime = TO_TIME FROM CASINO WHERE SETASDEFAULT = 1
   
   -- Calculate the accounting cutoff time in seconds.
   SET @CutoffSeconds  = (3600 * DATEPART (Hour, @ToTime)) + (60 * DATEPART (Minute, @ToTime)) + DATEPART (Second, @ToTime)
   
   -- Calculate the number of seconds from midnight to now.
   SET @CurrentSeconds = DateDiff(second, @ReturnValue, @CurrentTime)
   
   -- If the current number of seconds is less than the cutoff seconds,
   -- decrement the accounting date by 1 day.
   IF (@CurrentSeconds < @CutoffSeconds)
      SET @ReturnValue = DateAdd(day, -1, @ReturnValue)
   
   -- Set the function return value.
   RETURN @ReturnValue
END
GO
