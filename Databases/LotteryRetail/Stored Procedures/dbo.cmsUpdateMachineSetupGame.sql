SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure Name: cmsUpdateMachineSetupGame

Created By:     BitOmni Inc

Create Date:    08/16/2016

Description:    Updates a row into the MACH_SETUP_GAMES.
Used in Edit Selected Machine Setup. Interface only allows [IsEnabled] to change.

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 8-16-2016
  Creation of stored procedure.


--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsUpdateMachineSetupGame]
	@MachineNumber	CHAR(5),
	@GameCode		CHAR(3),
	@IsEnabled		BIT,
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

	UPDATE [dbo].[MACH_SETUP_GAMES]
		SET [IsEnabled] = @IsEnabled
	WHERE 
		[MACH_NO] = @MachineNumber AND
		[GAME_CODE] = @GameCode AND
		[BANK_NO] = @BankNumber
			   
	--If MultiGame is not enabled then must modify game and bank on MACH_NO also.
	IF @IsMultiGameEnabled = 0
	BEGIN
		UPDATE [MACH_SETUP]
		SET [GAME_CODE] = @GameCode,
			[BANK_NO] = @BankNumber,
			[TYPE_ID] = (SELECT [TYPE_ID] FROM [GAME_SETUP] WHERE [GAME_CODE] = @GameCode)
		WHERE [MACH_NO] = @MachineNumber
	END
    

-- Set the Return value.
RETURN @ReturnValue
GO
