SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertProgressiveType

Created By:     Terry Watkins

Create Date:    08-19-2009

Description:    Inserts a row into the PROGRESSIVE_TYPE table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     
                @ProgressiveTypeID PK row identifier
                @LongName          Descriptive text
                @PoolCount         Number of pools 
                @TotalContribution Total contribution percent including seed values
                @SeedCount         Number of coins used to seed pools
                @Rate1             Percentage rate to increment pool 1
                @Rate2             Percentage rate to increment pool 2
                @Rate3             Percentage rate to increment pool 3
                @RateCombined      Percentage for rates 1 2 and 3
                @UpdateFlag        Flag used to determine how to update

Change Log:

Changed By    Date           DB Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-19-2009     v7.0.0
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[diInsertProgressiveType]
   @ProgressiveTypeID  Int,
   @LongName           VarChar(64),
   @PoolCount          SmallInt,
   @TotalContribution  Decimal(5,4),
   @UpdateFlag         Bit = 0
AS

SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM PROGRESSIVE_TYPE WHERE PROGRESSIVE_TYPE_ID = @ProgressiveTypeID)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE PROGRESSIVE_TYPE SET
            LONG_NAME          = @LongName,
            POOL_COUNT         = @PoolCount,
            TOTAL_CONTRIBUTION = @TotalContribution
         WHERE PROGRESSIVE_TYPE_ID = @ProgressiveTypeID
         
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
      INSERT INTO PROGRESSIVE_TYPE
         (PROGRESSIVE_TYPE_ID, LONG_NAME, POOL_COUNT, TOTAL_CONTRIBUTION)
      VALUES
         (@ProgressiveTypeID, @LongName, @PoolCount, @TotalContribution)
      
      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
