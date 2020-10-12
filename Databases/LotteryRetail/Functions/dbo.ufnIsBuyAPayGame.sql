SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnIsBuyAPayGame

Created 04-21-2009 by Terry Watkins

Purpose: Returns a boolean (Bit) value indicating if the GameType is a BuyAPay
         game or not.

Returns: True (1) or False (0)


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-25-2006     v6.0.5
  Initial Coding

Terry Watkins 11-04-2009     v6.0.8
  Added check for GameCategoryID = 1.
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnIsBuyAPayGame] (@GameTypeCode VarChar(2)) RETURNS Bit
AS

BEGIN
   -- Variable Declarations
   DECLARE @ReturnValue Bit
   DECLARE @RowCount    Integer
   
   -- Initialize Return value.
   SET @ReturnValue = 0
   
   -- 
   SELECT @RowCount = COUNT(*) FROM GAME_TYPE
   WHERE
      [GAME_CATEGORY_ID] = 1 AND
      [TYPE_ID] = 'S'        AND
      [PRODUCT_ID] <> 3      AND
      [MAX_LINES_BET] = 1    AND
      [MAX_COINS_BET] = 3    AND
      [MULTI_BET_DEALS] = 0  AND
      [GAME_TYPE_CODE] = @GameTypeCode

   IF (@RowCount = 1) SET @ReturnValue = 1
   
   -- Set the function return value.
   RETURN @ReturnValue
END
GO
