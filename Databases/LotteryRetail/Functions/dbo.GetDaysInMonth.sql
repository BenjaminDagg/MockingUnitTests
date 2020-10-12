SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Defined Function GetDaysInMonth

Created 05-05-2005 by Terry Watkins

Purpose: Returns the number of days for the specified month and year

Returns: Days in month


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 05-05-2005     v4.1.1
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[GetDaysInMonth] (@MonthNbr Int, @YearNbr Int) RETURNS Integer
AS

BEGIN
   -- Variable Declarations
   DECLARE @ReturnValue Int
   DECLARE @DateValue   DateTime
   
   -- Variable Initialization
   SET @ReturnValue = 0
   
   IF (@MonthNbr IN (1, 3, 5, 7,8, 10, 12))
      SET @ReturnValue = 31
   
   IF (@MonthNbr IN (4, 6, 9, 11))
      SET @ReturnValue = 30
   
   IF (@MonthNbr = 2)
      BEGIN
         SET @DateValue = '02-01-' + CAST(@YearNbr AS VarChar)
         SET @DateValue = DATEADD(Day, -1, DATEADD(Month, 1, @DateValue))
         SET @ReturnValue = DAY(@DateValue)
      END
   
   -- Set the function return value.
   RETURN @ReturnValue
END

GO
