SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: SetWinningTierLevels user stored procedure.

  Created: 12/18/2002 by Norm Symonds   

  Purpose: Sets Winning Tiers for a Given Casino Form or for All Forms
           if NULL is passed as the Form Number

Arguments: @FormNumb:  Form for which to set the Tier Levels


Change Log:

Date       By     Change Description
---------- ------ --------------------------------------------------------------
2002-12-18 DGENLS Initial coding.

2003-02-11 DGENLS Added Logic to handle new Integer ID Column WINNING_TIER_ID in 
                  WINNING_TIERS Table to deal with a situation where the Winning 
                  Amount and Number of Winners are the same for 2 different tiers
--------------------------------------------------------------------------------
*/
-- Drop Procedure SetWinningTierLevels
CREATE PROCEDURE [dbo].[SetWinningTierLevels] (@FormNumb Varchar(10) = NULL)
AS

-- General Variables...
DECLARE @TierLevel         Smallint 
DECLARE @CurrentFormNumber Varchar(10)
DECLARE @ErrorReturn       Int

-- Variables for the cursor...
DECLARE @FormNumber     VarChar(10) 
DECLARE @WinningAmount  Money
DECLARE @NumbOfWinners  Int
DECLARE @WinningTierID  Int

-- Set NOCOUNT ON to prevent return of unwanted statistics.
SET NOCOUNT ON

-- Declare a cursor to retrieve the Winning Amounts for each Tier in ascending order.
DECLARE FormWinningTiers CURSOR FAST_FORWARD
FOR
SELECT
   wt.FORM_NUMB         AS FormNumber,
   wt.WINNING_AMOUNT    AS WinningAmount,
   wt.NUMB_OF_WINNERS   AS NumbOfWinners,
   wt.WINNING_TIER_ID   AS WinningTierID
FROM WINNING_TIERS wt
WHERE
   @FormNumb IS NULL OR wt.FORM_NUMB = @FormNumb
ORDER BY wt.FORM_NUMB, wt.WINNING_AMOUNT, wt.NUMB_OF_WINNERS desc, wt.WINNING_TIER_ID   

-- Initialize Local Variables
SET @TierLevel = 0
SET @ErrorReturn = 0
SET @CurrentFormNumber = ' '


-- Open the cursor.
OPEN FormWinningTiers

-- Get the first row of data.
IF @@ERROR = 0 FETCH FROM FormWinningTiers INTO @FormNumber, @WinningAmount, @NumbOfWinners, @WinningTierID

WHILE (@@FETCH_STATUS = 0 AND @@ERROR = 0)
   -- Successfully FETCHed a record, insert a row into the temp table if the TypeID is not null.
   BEGIN
      IF @CurrentFormNumber = @FormNumber
          SET @TierLevel = @TierLevel + 1
      ELSE
          SET @TierLevel = 1

      SET @CurrentFormNumber = @FormNumber

      UPDATE WINNING_TIERS SET TIER_LEVEL = @TierLevel
      WHERE WINNING_TIER_ID = @WinningTierID
      -- WHERE FORM_NUMB = @FormNumber AND WINNING_AMOUNT = @WinningAmount AND NUMB_OF_WINNERS = @NumbOfWinners

      IF @@ERROR <> 0 SET @ErrorReturn = @@ERROR

      -- Get the next row of the resultset.
      FETCH NEXT FROM FormWinningTiers INTO @FormNumber, @WinningAmount, @NumbOfWinners, @WinningTierID

   END

-- Close and Deallocate Cursor
CLOSE FormWinningTiers
DEALLOCATE FormWinningTiers

RETURN @ErrorReturn
GO
