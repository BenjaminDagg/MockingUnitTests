SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertGameCategory

Created By:     Terry Watkins

Create Date:    07-07-2009

Description:    Inserts or updates GAME_CATEGORY table rows.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     
                @GameCategoryID     Row identifier
                @LongName           Description
                @SortOrder          Presentation sort order
                @UpdateFlag         Update Flag

Change Log:

Changed By    Date           DB Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-06-2009     v7.0.0
  Initial coding.

Terry Watkins 07-06-2009     v7.0.0
  Added @LimitRTransTiers argument to support newly added column.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[diInsertGameCategory]
   @GameCategoryID     Int,
   @LongName           VarChar(64),
   @LimitRTransTiers   Bit,
   @SortOrder          Int,
   @UpdateFlag         Bit = 0
AS

SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0


-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM GAME_CATEGORY WHERE GAME_CATEGORY_ID = @GameCategoryID)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE GAME_CATEGORY SET
            LONG_NAME           = @LongName,
            LIMIT_RTRANS_TIERS  = @LimitRTransTiers,
            SORT_ORDER          = @SortOrder
         WHERE GAME_CATEGORY_ID = @GameCategoryID
         
         -- Store SQL error code.
         SET @ReturnValue = @@ERROR
         
         -- If no error, reset return value to 1 to indicate successful update.
         IF @ReturnValue = 0 SET @ReturnValue = 1
      END
   ELSE
      -- Record exists and update flag no set, so return 2 to indicate existing row ignored.
      SET @ReturnValue = 2
ELSE
   BEGIN
      -- Record doesn't exist, so insert it.
      INSERT INTO GAME_CATEGORY
         (GAME_CATEGORY_ID, LONG_NAME, LIMIT_RTRANS_TIERS, SORT_ORDER)
      VALUES
         (@GameCategoryID, @LongName, @LimitRTransTiers, @SortOrder)
      
      SET @ReturnValue = @@ERROR
   END

-- Set the procedure return value.
RETURN @ReturnValue
GO
