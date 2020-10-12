SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertPayscaleTier

Created By:     Chris Coddington

Create Date:    09/09/2003

Description:    Inserts a row into the PAYSCALE_TIER table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     Each field from the PAYSCALE_TIER table.

Change Log:

Changed By    Date           Database version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 04-13-2004
  Changed datatype of @TierLevel from TinyInt to SmallInt to support more
  than 255 Tiers. 

Terry Watkins 01-31-2006     v5.0.1
  Added @UpdateFlag (Bit default 0) to control updating of existing records.
  Returns 2 if record exists and Update flag = 0.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertPayscaleTier]
   @PayscaleName     VarChar(16),
   @TierLevel        SmallInt,
   @CoinsWon         Int,
   @Icons            VarChar(32),
   @IconMask         VarChar(32),
   @TierWinType      TinyInt,
   @UseMultiplier    Bit,
   @ScatterCount     TinyInt,
   @UpdateFlag       Bit = 0

AS

-- Suppress return of unwanted messages.
SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM PAYSCALE_TIER WHERE PAYSCALE_NAME = @PayscaleName AND TIER_LEVEL = @TierLevel)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE PAYSCALE_TIER SET
            COINS_WON      = @CoinsWon,
            ICONS          = @Icons,
            ICON_MASK      = @IconMask,
            TIER_WIN_TYPE  = @TierWinType,
            USE_MULTIPLIER = @UseMultiplier,
            SCATTER_COUNT  = @ScatterCount
         WHERE PAYSCALE_NAME = @PayscaleName AND TIER_LEVEL = @TierLevel
         
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
      INSERT INTO PAYSCALE_TIER
         (PAYSCALE_NAME, TIER_LEVEL, COINS_WON, ICONS,
          ICON_MASK, TIER_WIN_TYPE, USE_MULTIPLIER, SCATTER_COUNT)
      VALUES
         (@PayscaleName, @TierLevel, @CoinsWon, @Icons,
          @IconMask, @TierWinType, @UseMultiplier, @ScatterCount)
      
      SET @ReturnValue = @@ERROR
   END

-- Return the return value.
RETURN @ReturnValue
GO
