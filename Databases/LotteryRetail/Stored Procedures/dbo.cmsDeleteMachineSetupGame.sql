SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure Name: cmsDeleteMachineSetupGame

Created By:     BitOmni Inc

Create Date:    08/16/2016

Description:    Deletes a row into the MACH_SETUP_GAMES.
Used in Edit/Duplicate Selected Machine Setup when a dropdown selection is changed.

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 8-16-2016
  Creation of stored procedure.
------------- ---------- -------------------------------------------------------
Jenna Blackwell 02-25-2020   Resolve issue #36483. 
Need to comment out restraint if removing last MACH_SETUP_GAMES. 
This is disallowing ability to edit bank/game code when you only have a single record.  The current system
considers these changes as add/remove (rather than an update).  

--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsDeleteMachineSetupGame]
	@MachineNumber	CHAR(5),
	@GameCode		CHAR(3),	
	@BankNumber		INT
	
AS

-- Variable Declaration
DECLARE @ReturnValue		Int = 0
DECLARE @IsMultiGameEnabled BIT
DECLARE @ErrorMessage VARCHAR(4000) = NULL

SET NOCOUNT ON


SET @IsMultiGameEnabled = (SELECT [MultiGameEnabled] FROM [MACH_SETUP] WHERE [MACH_NO] = @MachineNumber)

IF @IsMultiGameEnabled IS NULL
BEGIN
	SET @ErrorMessage = 'Machine ' + @MachineNumber + ' not found in database.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF NOT EXISTS(SELECT * FROM MACH_SETUP_GAMES WHERE [MACH_NO] = @MachineNumber AND [GAME_CODE] = @GameCode AND [BANK_NO] = @BankNumber)
BEGIN
	SET @ErrorMessage = 'Game Setup does not exists for machine ' +  @MachineNumber + ' with GameCode ' + @GameCode + ' and BankNumber ' + CAST(@BankNumber AS VARCHAR)
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

--Commenting out below as described in change log

--IF ((SELECT COUNT(MACH_NO) FROM MACH_SETUP_GAMES WHERE [MACH_NO] = @MachineNumber) <= 1)
--BEGIN
--	SET @ErrorMessage = 'Cannot delete the only game setup for machine ' +  @MachineNumber + ' with GameCode ' + @GameCode + ' and BankNumber ' + CAST(@BankNumber AS VARCHAR)
--	RAISERROR (@ErrorMessage, 16, -1)
--	RETURN
--END

	DELETE FROM [dbo].[MACH_SETUP_GAMES]		
	WHERE 
		[MACH_NO] = @MachineNumber AND
		[GAME_CODE] = @GameCode AND
		[BANK_NO] = @BankNumber

-- Set the Return value.
RETURN @ReturnValue
GO
