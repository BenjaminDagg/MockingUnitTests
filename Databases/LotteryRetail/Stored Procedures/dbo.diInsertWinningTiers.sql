SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertWinningTiers

Created By:     Chris Coddington

Create Date:    09/09/2003

Description:    Inserts a row into the WINNING_TIERS table

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     Each field from the WINNING_TIERS table.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 01-31-2006     v5.0.1
  Added @UpdateFlag (Bit default 1) to control updating of existing records.
  Returns 2 if record exists and Update flag = 0.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertWinningTiers]
   @NbrOfWinners   Int,
   @WinningAmount  Money,
   @FormNumber     VarChar(10),
   @TierLevel      Smallint,
   @CoinsWon       Int,
   @UpdateFlag     Bit = 0

AS

-- Variable Declaration
DECLARE @ReturnValue Int

-- Variable Initialization - Assume successful insertion.
SET @ReturnValue = 0

SET NOCOUNT ON

-- Test to see if the form already exists.
IF EXISTS (SELECT * FROM WINNING_TIERS WHERE FORM_NUMB = @FormNumber AND Tier_Level = @TierLevel)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE WINNING_TIERS SET
            NUMB_OF_WINNERS  = @NbrOfWinners,
            WINNING_AMOUNT   = @WinningAmount,
            COINS_WON        = @CoinsWon
         WHERE FORM_NUMB = @FormNumber AND Tier_Level = @TierLevel
         
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
      INSERT INTO WINNING_TIERS
         (NUMB_OF_WINNERS, WINNING_AMOUNT, FORM_NUMB, TIER_LEVEL, COINS_WON)
      VALUES
         (@NbrOfWinners, @WinningAmount, @FormNumber, @TierLevel, @CoinsWon)

      SET @ReturnValue = @@ERROR

   END   

RETURN @ReturnValue
GO
