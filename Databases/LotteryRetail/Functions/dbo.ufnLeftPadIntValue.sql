SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnLeftPadIntValue

Created 08-07-2008 by Terry Watkins

Purpose: Returns a string prepended with the specified number of characters.

Returns: VarChar(32)


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-07-2008     v6.0.2
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnLeftPadIntValue](@IntValue Int, @PadChar Char(1), @TotalLength Int) RETURNS VarChar(32)
AS

BEGIN
   -- Variable Declarations
   DECLARE @ReturnValue  VarChar(32)
   DECLARE @NumericText  VarChar(16)
   DECLARE @PadLength    Int

   -- Build the return string...
   SET @NumericText = CAST(@IntValue AS VarChar)
   SET @PadLength = @TotalLength - LEN(@NumericText)
   IF @PadLength < 1
      SET  @ReturnValue = @NumericText
   ELSE
      SET @ReturnValue = REPLICATE(@PadChar, @PadLength) + @NumericText
   
   -- Set the function return value.
   RETURN @ReturnValue
END
GO
