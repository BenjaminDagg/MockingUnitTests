SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertImportHistory

Created By:     Terry Watkins

Create Date:    09/11/2003

Description:    Inserts a row into the IMPORT_HISTORY table.

Returns:        Primary Key value of the newly inserted row

Parameters:     

Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------

--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertImportHistory]
   @ExportHistoryID Int,
   @ImportedBy      VarChar(64),
   @ExportedBy      VarChar(64),
   @ExportDate      DateTime,
   @CasinoUpdate    Bit,
   @GameUpdate      Bit,
   @BankUpdate      Bit,
   @FormUpdate      Bit,
   @IsGeneric       Bit

AS

-- Variable Declaration
DECLARE @ErrorCode   Int
DECLARE @ReturnValue Int

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

INSERT INTO IMPORT_HISTORY
   (EXPORT_HISTORY_ID, IMPORTED_BY, EXPORTED_BY, IMPORT_DATE, EXPORT_DATE,
    CASINO_UPDATE, GAME_UPDATE, BANK_UPDATE, FORM_UPDATE, IS_GENERIC)
VALUES
   (@ExportHistoryID,  @ImportedBy, @ExportedBy, GetDate(),   @ExportDate,
    @CasinoUpdate, @GameUpdate, @BankUpdate, @FormUpdate, @IsGeneric)

SET @ErrorCode = @@ERROR

IF @ErrorCode = 0
   SET @ReturnValue = @@IDENTITY
ELSE
   SET @ReturnValue = @ErrorCode


RETURN @ReturnValue
GO
