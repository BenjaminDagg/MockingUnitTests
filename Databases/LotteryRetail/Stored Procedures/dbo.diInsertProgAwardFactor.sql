SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertProgAwardFactor

Created By:     Terry Watkins

Create Date:    10-07-2009

Description:    Inserts a row into the PROG_AWARD_FACTOR table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     
                @ProgAwardFactorID PK row identifier
                @ProgressiveTypeID Link to the PROGRESSIVE_TYPE table
                @TierLevel         Tier level to which factor applies
                @AwardFactor       Number of coins from payscale tier already
                                   added to the progressive pool via the seed amount
                @UpdateFlag        Flag used to determine how to update the table

Change Log:

Changed By    Date           DB Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 10-07-2009     v7.0.0
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[diInsertProgAwardFactor]
   @ProgAwardFactorID  Int,
   @ProgressiveTypeID  Int,
   @TierLevel          SmallInt,
   @AwardFactor        Int,
   @UpdateFlag         Bit = 0
AS

SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM PROG_AWARD_FACTOR WHERE PROG_AWARD_FACTOR_ID = @ProgAwardFactorID)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE PROG_AWARD_FACTOR SET
            PROGRESSIVE_TYPE_ID = @ProgressiveTypeID,
            TIER_LEVEL          = @TierLevel,
            AWARD_FACTOR        = @AwardFactor
         WHERE PROG_AWARD_FACTOR_ID = @ProgAwardFactorID
         
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
      INSERT INTO PROG_AWARD_FACTOR
         (PROG_AWARD_FACTOR_ID, PROGRESSIVE_TYPE_ID, TIER_LEVEL, AWARD_FACTOR)
      VALUES
         (@ProgAwardFactorID, @ProgressiveTypeID, @TierLevel, @AwardFactor)
      
      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
