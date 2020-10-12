SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertProductLine

Created By:     Terry Watkins

Create Date:    12-14-2005

Description:    Inserts a row into the PRODUCT_LINE table.

Returns:        0 = Successful row insertion
                1 = Record Exists and successfully updated
                n = TSQL Error Code

Parameters:     @ProductLineID  Product Line identifier
                @LongName       Descriptive text
                @GameClass      Indicates if Class II or Class III
                @IsActive       Indicates if active or deactivated

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-14-2005     v5.0.0
  Initial coding

Terry Watkins 02-03-2006     v5.0.1
  Modified logic so that if the record exists, it is updated instead of ignored.

Terry Watkins 01-11-2012     v3.0.3
  Added argument @EgmDealGCMatch to support new column EGM_DEAL_GC_MATCH for
  case 22836.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[diInsertProductLine]
   @ProductLineID    SmallInt,
   @LongName         VarChar(64),
   @GameClass        SmallInt,
   @EgmDealGCMatch   Bit = 0,
   @IsActive         Bit
AS

-- Variable Declaration
DECLARE @ReturnValue    Int
DECLARE @SQLError       Int

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM PRODUCT_LINE WHERE PRODUCT_LINE_ID = @ProductLineID)
   BEGIN
      -- Record already exists.
      SET @ReturnValue = 1
      
      -- Attempt to update the record.
      UPDATE PRODUCT_LINE SET
         LONG_NAME         = @LongName,
         GAME_CLASS        = @GameClass,
         EGM_DEAL_GC_MATCH = @EgmDealGCMatch,
         IS_ACTIVE         = @IsActive
      WHERE PRODUCT_LINE_ID = @ProductLineID
      
      -- Store SQL Error number
      SELECT @SQLError = @@ERROR
      
      -- If an error occurred, reset the value that we will return.
      IF (@SQLError <> 0) SET @ReturnValue = @SQLError
   END
ELSE
   BEGIN
      -- Record doesn't exist, so insert it.
      INSERT INTO PRODUCT_LINE
         (PRODUCT_LINE_ID, LONG_NAME, GAME_CLASS, EGM_DEAL_GC_MATCH, IS_ACTIVE)
      VALUES
         (@ProductLineID, @LongName, @GameClass, @EgmDealGCMatch, @IsActive)
      
      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
