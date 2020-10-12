SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertGameType

Created By:     Terry Watkins

Create Date:    10/01/2003

Description:    Inserts a row into the GAME_TYPE table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     

Change Log:

Changed By    Date           DB Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 02-03-2005     v4.0.1
  Added argument @MultiBetDeals to support new GAME_TYPE.MULTI_BET_DEALS column.
  Added argument @ShowPayCredits to support new GAME_TYPE.SHOW_PAY_CREDITS column.

Terry Watkins 01-31-2006     v5.0.1
  Added @UpdateFlag (Bit default 0) to control updating of existing records.
  Returns 2 if record exists and Update flag = 0.

Terry Watkins 07-06-2009     v7.0.0
  Added argument @ProgressiveTypeID (Int default 0), @GameCategoryID (Int default 0),
  and @BarcodeTypeID (SmallInt default 0) to support new GAME_TYPE table columns
  PROGRESSIVE_TYPE_ID, GAME_CATEGORY_ID, and BARCODE_TYPE_ID.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[diInsertGameType]
   @GameTypeCode       VarChar(2),
   @LongName           VarChar(64),
   @TypeID             Char(1),
   @ProductID          TinyInt,
   @ProgressiveTypeID  Int = 0,
   @MaxCoinsBet        SmallInt,
   @MaxLinesBet        TinyInt,
   @GameCategoryID     Int = 0,
   @BarcodeTypeID      SmallInt = 0,
   @ShowPayCredits     Bit = 1,
   @MultiBetDeals      Bit = 0,
   @IsActive           Bit = 0,
   @UpdateFlag         Bit = 0

AS

SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM GAME_TYPE WHERE GAME_TYPE_CODE = @GameTypeCode)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE GAME_TYPE SET
            LONG_NAME           = @LongName,
            TYPE_ID             = @TypeID,
            PRODUCT_ID          = @ProductID,
            PROGRESSIVE_TYPE_ID = @ProgressiveTypeID,
            MAX_COINS_BET       = @MaxCoinsBet,
            MAX_LINES_BET       = @MaxLinesBet,
            GAME_CATEGORY_ID    = @GameCategoryID,
            BARCODE_TYPE_ID     = @BarcodeTypeID,
            SHOW_PAY_CREDITS    = @ShowPayCredits,
            IS_ACTIVE           = @IsActive
         WHERE GAME_TYPE_CODE = @GameTypeCode
         
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
      INSERT INTO GAME_TYPE
         (GAME_TYPE_CODE, LONG_NAME, TYPE_ID, PRODUCT_ID, PROGRESSIVE_TYPE_ID,
          MAX_COINS_BET, GAME_CATEGORY_ID, BARCODE_TYPE_ID, MAX_LINES_BET,
          MULTI_BET_DEALS, SHOW_PAY_CREDITS, IS_ACTIVE)
      VALUES
         (@GameTypeCode, @LongName, @TypeID, @ProductID, @ProgressiveTypeID,
          @MaxCoinsBet, @GameCategoryID, @BarcodeTypeID, @MaxLinesBet,
          @MultiBetDeals, @ShowPayCredits, @IsActive)
      
      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
