SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertPayscaleTierKeno

Created By:     Terry Watkins

Create Date:    06-15-2005

Description:    Inserts a row into the PAYSCALE_TIER_KENO table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     Each field from the PAYSCALE_TIER table.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 06-15-2005     v4.1.4
  Initial coding.

Terry Watkins 01-31-2006     v5.0.1
  Added @UpdateFlag (Bit default 0) to control updating of existing records.
  Returns 2 if record exists and Update flag = 0.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertPayscaleTierKeno]
   @PayscaleName     VarChar(16),
   @TierLevel        SmallInt,
   @PickCount        SmallInt,
   @HitCount         SmallInt,
   @AwardFactor      Decimal(6,1),
   @TierWinType      TinyInt,
   @UpdateFlag       Bit = 0

AS

-- Suppress return of unwanted messages.
SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM PAYSCALE_TIER_KENO WHERE PAYSCALE_NAME = @PayscaleName AND TIER_LEVEL = @TierLevel)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE PAYSCALE_TIER_KENO SET
            PICK_COUNT       = @PickCount,
            HIT_COUNT        = @HitCount,
            AWARD_FACTOR     = @AwardFactor,
            TIER_WIN_TYPE    = @TierWinType
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
      INSERT INTO PAYSCALE_TIER_KENO
         (PAYSCALE_NAME, TIER_LEVEL, PICK_COUNT, HIT_COUNT, AWARD_FACTOR, TIER_WIN_TYPE)
      VALUES
         (@PayscaleName, @TierLevel, @PickCount, @HitCount, @AwardFactor, @TierWinType)
      
      SET @ReturnValue = @@ERROR
   END

-- Return the return value.
RETURN @ReturnValue
GO
