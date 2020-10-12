SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: UpdateRevenueType user stored procedure.

  Created: 03-28-2011 by Aldo Zamora

  Purpose: Updates Revenue Types.
  
  Returns: 0 = success
           1 = Flex Number already exists
           2 = No row found to update
           n = TSQL Error
        
Arguments: 
    @RevenueTypeID
    @FlexNumber
    
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora 03-28-2011       7.2.4DC
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[UpdateRevenueType]
    @RevenueTypeID  Int,
    @FlexNumber     Int

AS

-- Suppress unwanted statistics
SET NOCOUNT ON

-- Declare Variables
DECLARE @ReturnValue int
DECLARE @RowCount INT

-- Variable Initialization
SET @ReturnValue = 0
SET @RowCount = 0

-- Does the Flex Number already exist?
SELECT @RowCount = COUNT(*)
FROM dbo.RevenueType
WHERE FlexNumber = @FlexNumber AND RevenueTypeID <> @RevenueTypeID

-- Ok to update.
IF @RowCount = 0
   BEGIN
      -- Perform the update.
	   UPDATE [RevenueType] SET
         FlexNumber = @FlexNumber
      WHERE RevenueTypeID = @RevenueTypeID
      -- Check for errors.
      SELECT @ReturnValue = @@ERROR, @RowCount = @@ROWCOUNT
      IF @ReturnValue = 0 AND @RowCount = 0
         BEGIN
            -- No row found to update.
            SET @ReturnValue = 2	
         END
   END
ELSE
   BEGIN
      -- Flex Number already exist.
   	SET @ReturnValue = 1
   END

-- Set the Return Value.
RETURN @ReturnValue
GO
