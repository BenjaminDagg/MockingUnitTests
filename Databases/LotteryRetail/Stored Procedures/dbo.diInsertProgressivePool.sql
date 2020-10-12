SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertProgressivePool

Created By:     Terry Watkins

Create Date:    08-19-2009

Description:    Inserts a row into the PROGRESSIVE_POOL table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     
                @ProgressivePoolID PK row identifier
                @ProgressiveTypeID Link to the PROGRESSIVE_TYPE table
                @GameTypeCode      Game Type Code
                @Denomination      Denom in cents necessary to claim a pool
                @CoinsBet          Number of coins bet necessary to claim a pool
                @LinesBet          Number of lines bet necessary to claim a pool
                @Pool1             Initial pool 1 value as money
                @Pool2             Initial pool 2 value as money
                @Pool3             Initial pool 3 value as money
@WinLevel    Win level information for multi level progressives
                @UpdateFlag        Flag used to determine how to update the table

Change Log:

Changed By    Date           DB Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-19-2009     v7.0.0
  Initial coding.
  
Louis Epstein 05-15-2013     v7.3.2
  Added functionality to insert/update WIN_LEVEL information
  
Louis Epstein 06-25-2014     v3.2.4
  Added functionality to insert/update LocationID
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[diInsertProgressivePool]
   @ProgressivePoolID  Int,
   @ProgressiveTypeID  Int,
   @GameTypeCode       VarChar(2),
   @Denomination       Int,
   @CoinsBet           SmallInt,
   @LinesBet           TinyInt,
   @Pool1              Money,
   @Pool2              Money,
   @Pool3              Money,
   @WinLevel           Tinyint,
   @SeedCount           Int = 0,
   @Rate1           Decimal(5,4) = 0,
   @Rate2           Decimal(5,4) = 0,
   @Rate3           Decimal(5,4) = 0,
   @UpdateFlag         Bit = 0
AS

SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM PROGRESSIVE_POOL WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE PROGRESSIVE_POOL SET
            PROGRESSIVE_TYPE_ID = @ProgressiveTypeID,
            GAME_TYPE_CODE      = @GameTypeCode,
            DENOMINATION        = @Denomination,
            COINS_BET           = @CoinsBet,
            LINES_BET           = @LinesBet,
            POOL_1              = @Pool1,
            POOL_2              = @Pool2,
            POOL_3              = @Pool3,
WinLevel = @WinLevel,
SeedCount = @SeedCount,
Rate1 = @Rate1,
Rate2 = @Rate2,
Rate3 = @Rate3,
LocationID = (SELECT LOCATION_ID FROM CASINO WHERE SETASDEFAULT = 1)
         WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID
         
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
      INSERT INTO PROGRESSIVE_POOL
         (PROGRESSIVE_POOL_ID, PROGRESSIVE_TYPE_ID, GAME_TYPE_CODE,
          DENOMINATION, COINS_BET, LINES_BET, POOL_1, POOL_2, POOL_3, WinLevel, SeedCount, Rate1, Rate2, Rate3, LocationID)
      VALUES
         (@ProgressivePoolID, @ProgressiveTypeID, @GameTypeCode,
          @Denomination, @CoinsBet, @LinesBet, @Pool1, @Pool2, @Pool3, @WinLevel, @SeedCount, @Rate1, @Rate2, @Rate3, (SELECT LOCATION_ID FROM CASINO WHERE SETASDEFAULT = 1))
      
      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
