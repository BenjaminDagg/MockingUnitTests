SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure Name: cmsInsertMachineSetupGame

Created By:     BitOmni Inc

Create Date:    08/14/2016

Description:    Inserts a row into the MACH_SETUP_GAMES. 
Used in Machine Setup Add/Edit/Duplicate

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 8-14-2016
  Creation of stored procedure.

BitOmni Inc 10-19-2016
  Update Stored Procedure for LRAS.
 

--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsInsertMachineSetupGame]
	@MachineNumber	CHAR(5),
	@GameCode		CHAR(3),
	@IsEnabled		BIT,
	@BankNumber		INT

AS

-- Variable Declaration
DECLARE @ReturnValue		Int = 0
DECLARE @IsMultiGameEnabled BIT
DECLARE @LocationId INT 
DECLARE @ErrorMessage VARCHAR(4000) = NULL

SET NOCOUNT ON

SET @LocationId = (SELECT [LOCATION_ID] FROM [MACH_SETUP] WHERE [MACH_NO] = @MachineNumber)


SET @IsMultiGameEnabled = (SELECT [MultiGameEnabled] FROM [MACH_SETUP] WHERE [MACH_NO] = @MachineNumber)

IF @IsMultiGameEnabled IS NULL
BEGIN
	SET @ErrorMessage = 'Machine ' + @MachineNumber + ' not found in database.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF @LocationId IS NULL
BEGIN
	SET @ErrorMessage = 'Could not locate Location Id for Machine ' + @MachineNumber + '.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF EXISTS(SELECT * FROM MACH_SETUP_GAMES WHERE [MACH_NO] = @MachineNumber AND [GAME_CODE] = @GameCode AND [BANK_NO] = @BankNumber)
BEGIN
	SET @ErrorMessage = 'Game Setup already exists for machine ' +  @MachineNumber + ' with GameCode ' + @GameCode + ' and BankNumber ' + CAST(@BankNumber AS VARCHAR)
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END


	--Insert the game
	INSERT INTO [dbo].[MACH_SETUP_GAMES]
			   ([MACH_NO]
			   ,[GAME_CODE]
			   ,[BANK_NO]
			   ,[IsEnabled]
			   ,[LOCATION_ID]
			   ,[TYPE_ID])
	SELECT	@MachineNumber,
			@GameCode,
			@BankNumber,
			@IsEnabled,
			@LocationId,
			(SELECT [TYPE_ID] FROM [GAME_SETUP] WHERE [GAME_CODE] = @GameCode)


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
