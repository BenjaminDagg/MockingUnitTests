SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertPayscale

Created By:     Chris Coddington

Create Date:    09/09/2003

Description:    Inserts a row into the PAYSCALE table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     Each field from the PAYSCALE table.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 01-31-2006     v5.0.1
  Added @UpdateFlag (Bit default 0) to control updating of existing records.
  Returns 2 if record exists and Update flag = 0.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertPayscale]
   @PayscaleName     VarChar(16),
   @LongName         VarChar(64),
   @GameTypeCode     VarChar(2),
   @IsActive         Bit,
   @UpdateFlag       Bit = 0

AS

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM PAYSCALE WHERE PAYSCALE_NAME = @PayscaleName)
   -- Record already exists.
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE PAYSCALE SET
            LONG_NAME        = @LongName,
            GAME_TYPE_CODE   = @GameTypeCode,
            IS_ACTIVE        = @IsActive
         WHERE PAYSCALE_NAME = @PayscaleName
         
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
      INSERT INTO PAYSCALE
         (PAYSCALE_NAME, LONG_NAME, GAME_TYPE_CODE, IS_ACTIVE)
      VALUES
         (@PayscaleName, @LongName, @GameTypeCode, @IsActive)

      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
