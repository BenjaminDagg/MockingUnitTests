SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertGameSetup

Created By:     Chris Coddington

Create Date:    09/09/2003

Description:    Inserts a row into the GAME_SETUP table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     Each field from the GAME_SETUP table.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 01-31-2006     v5.0.1
  Added @UpdateFlag (Bit default 0) to control updating of existing records.
  Returns 2 if record exists and Update flag = 0.

Terry Watkins 01-31-2006     v5.0.4
  Added @GameTitleID argument for new GAME_SETUP.GAME_TITLE_ID column.
  
Louis Epstein 05-28-2013     v3.1.0
  Added functionality to insert GameTitleID if it exists in the XML data.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertGameSetup]
   @GameCode        VarChar(3),
   @GameDesc        VarChar(64),
   @TypeID          Char(1),
   @GameTypeCode    VarChar(2),
   @GameTitleID     Int = -1,
   @CasinoGameID    Int = -1,
   @UpdateFlag      Bit = 0

AS

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

-- Test to see if the Casino record already exists.
IF EXISTS (SELECT * FROM GAME_SETUP WHERE GAME_CODE = @GameCode)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE GAME_SETUP SET
            GAME_DESC       = @GameDesc,
            TYPE_ID         = @TypeID,
            GAME_TYPE_CODE  = @GameTypeCode,
            GAME_TITLE_ID   = @GameTitleID,
            CASINO_GAME_ID = @CasinoGameID
         WHERE GAME_CODE = @GameCode
         
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
      INSERT INTO GAME_SETUP
         (GAME_CODE, GAME_DESC, TYPE_ID, GAME_TYPE_CODE, GAME_TITLE_ID, CASINO_GAME_ID)
      VALUES
         (@GameCode, @GameDesc, @TypeID, @GameTypeCode,  @GameTitleID, @CasinoGameID)
      
      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
