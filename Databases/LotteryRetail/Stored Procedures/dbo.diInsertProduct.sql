SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertProduct

Created By:     Terry Watkins

Create Date:    01-30-2006

Description:    Inserts or updates the PRODUCT table.

Returns:        0 = Successful row insertion
                1 = Record successfully updated
                n = TSQL Error Code

Parameters:     @ProductID    Product Line identifier
                @LongName     Descriptive text

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-14-2005     v5.0.1
   Initial coding
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertProduct]
   @ProductID    TinyInt,
   @ProductName  VarChar(64)

AS

-- Variable Declaration
DECLARE @ReturnValue    Int
DECLARE @SQLError       Int

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM PRODUCT WHERE PRODUCT_ID = @ProductID)
   BEGIN
      -- Record already exists.
      SET @ReturnValue = 1
      
      -- Attempt to update the record.
      UPDATE PRODUCT SET PRODUCT_DESCRIPTION = @ProductName WHERE PRODUCT_ID = @ProductID
      
      -- Store SQL Error number
      SELECT @SQLError = @@ERROR
      
      -- If an error occurred, reset the value that we will return.
      IF (@SQLError <> 0) SET @ReturnValue = @SQLError
   END
ELSE
   BEGIN
      -- Record doesn't exist, so insert it.
      INSERT INTO PRODUCT
         (PRODUCT_ID, PRODUCT_DESCRIPTION)
      VALUES
         (@ProductID, @ProductName)

      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
