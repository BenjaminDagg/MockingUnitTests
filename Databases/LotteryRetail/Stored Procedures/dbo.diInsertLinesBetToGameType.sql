SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertLinesBetToGameType

Created By:     Terry Watkins

Create Date:    11-21-2005

Description:    Inserts a row into the GAME_TYPE table.

Returns:        0 = Successful row insertion
                1 = Record Already Exists
                n = TSQL Error Code

Parameters:     

Change Log:

Changed By    Date           DB Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-21-2005     v4.2.4
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[diInsertLinesBetToGameType]
   @GameTypeCode           VarChar(2),
   @LinesBet               TinyInt

AS

SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0


-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM LINES_BET_TO_GAME_TYPE
           WHERE GAME_TYPE_CODE = @GameTypeCode AND LINES_BET = @LinesBet)
   -- Record already exists.
   SET @ReturnValue = 1
ELSE
   BEGIN
      -- Record doesn't exist, so insert it.
      INSERT INTO LINES_BET_TO_GAME_TYPE
         (GAME_TYPE_CODE, LINES_BET)
      VALUES
         (@GameTypeCode, @LinesBet)
      
      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
