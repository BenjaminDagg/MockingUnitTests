SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure Name: [cmsIsMachineSetupUnique]

Created By:     BitOmni Inc

Create Date:    10/22/2016

Description:    Checks if machine setup with parameters exists in system. If it does throws error. 
Used in Machine Setup Add/Edit/Duplicate

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 10-21-2016
  Creation of stored procedure.


--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[cmsIsMachineSetupUnique]
	@MachineNumber			CHAR(5),	
	@LocationMachineNumber	VARCHAR(8),
	@IpAddress				VARCHAR(24),
	@SerialNumber			VARCHAR(15),
	@IsEditMode				BIT
	
AS

-- Variable Declaration
DECLARE @ReturnValue		Int = 0
DECLARE @LocationId INT 
DECLARE @ErrorMessage VARCHAR(4000) = NULL

SET NOCOUNT ON

SET @LocationId = (SELECT TOP 1 [LOCATION_ID] FROM [CASINO] WHERE [SETASDEFAULT] = 1)

IF @LocationId IS NULL
BEGIN
	SET @ErrorMessage = 'Could not locate Location Id for Machine ' + @MachineNumber + '.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF EXISTS (SELECT TOP 1 [MACH_NO] FROM [dbo].[MACH_SETUP] WHERE [MACH_NO] = @MachineNumber) AND @IsEditMode = 0
BEGIN
	SET @ErrorMessage = 'A machine with number ' + @MachineNumber + ' already exists in the database.' 
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF EXISTS (	SELECT TOP 1 [CASINO_MACH_NO] 
			FROM [dbo].[MACH_SETUP] 
			WHERE [CASINO_MACH_NO] = @LocationMachineNumber 
			AND [CASINO_MACH_NO] NOT IN (SELECT [CASINO_MACH_NO] FROM [dbo].[MACH_SETUP] WHERE [MACH_NO] = @MachineNumber))
BEGIN
	SET @ErrorMessage = 'A machine with location machine number ' + @LocationMachineNumber + ' already exists in the database.' 
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF EXISTS (	SELECT TOP 1 [IP_ADDRESS] 
			FROM [dbo].[MACH_SETUP] 
			WHERE [IP_ADDRESS] = @IpAddress
			AND [IP_ADDRESS] NOT IN (SELECT [IP_ADDRESS] FROM [dbo].[MACH_SETUP] WHERE [MACH_NO] = @MachineNumber))
BEGIN
	SET @ErrorMessage = 'A machine with Ip Address ' + @IpAddress + ' already exists in the database.' 
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF EXISTS (	SELECT TOP 1 [MACH_SERIAL_NO] 
			FROM [dbo].[MACH_SETUP] 
			WHERE [MACH_SERIAL_NO] = @SerialNumber
			AND [MACH_SERIAL_NO] NOT IN (SELECT [MACH_SERIAL_NO] FROM [dbo].[MACH_SETUP] WHERE [MACH_NO] = @MachineNumber)			)
BEGIN
	SET @ErrorMessage = 'A machine with serial number ' + @SerialNumber + ' already exists in the database.' 
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END


-- Set the Return value.
RETURN @ReturnValue
GO
