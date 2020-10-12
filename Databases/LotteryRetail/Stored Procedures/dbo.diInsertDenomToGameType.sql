SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertDenomToGameType

Created By:     Terry Watkins

Create Date:    09/30/2003

Description:    Inserts a row into the DENOM_TO_GAME_TYPE table.

Returns:        0 = Successful row insertion
                1 = Record Already Exists
                n = TSQL Error Code

Parameters:     Each field from the Denom_To_Game table.

Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------

--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertDenomToGameType]
   @GameTypeCode  VarChar(2),
   @Denom         SmallMoney

AS

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM DENOM_TO_GAME_TYPE WHERE GAME_TYPE_CODE = @GameTypeCode AND DENOM_VALUE = @Denom)
   -- Record already exists.
   SET @ReturnValue = 1
ELSE
   BEGIN
      -- Record doesn't exist, so insert it.
      INSERT INTO DENOM_TO_GAME_TYPE
         (GAME_TYPE_CODE, DENOM_VALUE)
      VALUES
         (@GameTypeCode, @Denom)

      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
