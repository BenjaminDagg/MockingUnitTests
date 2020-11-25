SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure Name: [cmsInsertMachineSetup]

Created By:     BitOmni Inc

Create Date:    10/21/2016

Description:    Inserts a row into the MACH_SETUP. 
Used in Machine Setup Add/Duplicate

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 10-21-2016
  Creation of stored procedure.


--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[cmsInsertMachineSetup]
	@MachineNumber			CHAR(5),
	@Description			VARCHAR(64),
	@LocationMachineNumber	VARCHAR(8),
	@IpAddress				VARCHAR(24),
	@SerialNumber			VARCHAR(15),
	@IsMultiGameEnabled		BIT
	
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


INSERT INTO [dbo].[MACH_SETUP]
           ([MACH_NO]
           ,[MODEL_DESC]
           ,[CASINO_MACH_NO]
           ,[IP_ADDRESS]
           ,[MACH_SERIAL_NO]
           ,[MultiGameEnabled]
           ,[LOCATION_ID])
     VALUES
           (@MachineNumber,
            @Description,
            @LocationMachineNumber,
            @IpAddress,
            @SerialNumber,
            @IsMultiGameEnabled,
            @LocationId)
           

-- Set the Return value.
RETURN @ReturnValue
GO
