SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Defined Function CardlessErrorText

Created 12-13-2004 by Terry Watkins

Purpose: Removes 'Please remove card.' from error text if present.
         Should be called when in Cardless Play mode.

Returns: Error Text


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-13-2004     v4.0.0
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[CardlessErrorText] (@ErrorText VarChar(512)) RETURNS VarChar(512)
AS

BEGIN
   -- Variable Declarations
   DECLARE @ReturnValue VarChar(1024)
   DECLARE @CharPos     Int
   
   -- Variable Initialization
   SET @ReturnValue = @ErrorText
   
   -- Check for text to remove...
   SET @CharPos = CHARINDEX('Please remove card', @ReturnValue)
   
   IF (@CharPos > 0)
      SET @ReturnValue = RTRIM(LEFT(@ReturnValue, @CharPos - 1))
   
   -- Set the function return value.
   RETURN @ReturnValue
END
GO
