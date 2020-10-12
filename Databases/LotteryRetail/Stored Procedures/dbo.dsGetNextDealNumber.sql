SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: dsGetNextDealNumber

 Created By:    Terry Watkins

Create Date:    12-20-2005

Description:    Retrieves the next unused Deal number.
                It will be used to create a new Deal.

  Called By:    Deal Server Service

    Returns:    The Next Deal Number as an Integer value

 Parameters:    @MinDealNumber - Minimum value that will be returned

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-20-2005     v5.0.2
  Initial coding
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[dsGetNextDealNumber] @MinDealNumber Int = 1

AS

-- Variable Declaration
DECLARE @NextDealNumber Int

-- Variable Initialization
SET @NextDealNumber = 0

IF (@MinDealNumber < 1)
   SET @MinDealNumber = 1

-- Get the highest DealNumber for the specified Form
SELECT @NextDealNumber = ISNULL(MAX(DEAL_NO), @MinDealNumber - 1)
FROM DEAL_SETUP
WHERE DEAL_NO >= @MinDealNumber

-- Increment by 1
SET @NextDealNumber = @NextDealNumber + 1

-- Set the return value.
RETURN @NextDealNumber
GO
