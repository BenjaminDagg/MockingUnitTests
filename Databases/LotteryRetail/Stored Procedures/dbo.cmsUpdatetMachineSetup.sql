SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
--------------------------------------------------------------------------------
Procedure Name: [cmsUpdatetMachineSetup]

Created By:     BitOmni Inc

Create Date:    10/22/2016

Description:    Updates a row on the MACH_SETUP. 
Used in Machine Setup Edit

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 10-21-2016
  Creation of stored procedure.


--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[cmsUpdatetMachineSetup]
	@MachineNumber			CHAR(5),
	@LocationMachineNumber	VARCHAR(8),
	@Description			VARCHAR(64),	
	@IpAddress				VARCHAR(24),
	@SerialNumber			VARCHAR(15),
	@GameCode				VARCHAR(3),
	@IsMultiGameEnabled		BIT,
	@Removed				BIT
	
AS

-- Variable Declaration
DECLARE @ReturnValue		INT = 0
DECLARE @LocationId INT 
DECLARE @RemovedStateBefore BIT 
DECLARE @ErrorMessage VARCHAR(4000) = NULL
DECLARE @BankNo INT
DECLARE @TypeId VARCHAR(1)

SET NOCOUNT ON

SET @LocationId = (SELECT TOP 1 [LOCATION_ID] FROM [CASINO] WHERE [SETASDEFAULT] = 1)
SET @RemovedStateBefore = (SELECT [REMOVED_FLAG] FROM [dbo].[MACH_SETUP] WHERE [MACH_NO] = @MachineNumber)
SET @BankNo = (SELECT BANK_NO FROM [dbo].[MACH_SETUP_GAMES] WHERE [MACH_NO] = @MachineNumber AND [GAME_CODE] = @GameCode)
SET @TypeId = (SELECT TYPE_ID FROM [dbo].[MACH_SETUP_GAMES] WHERE [MACH_NO] = @MachineNumber AND [GAME_CODE] = @GameCode)

IF @LocationId IS NULL
BEGIN
	SET @ErrorMessage = 'Could not locate Location Id for Machine ' + @MachineNumber + '.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END


UPDATE [dbo].[MACH_SETUP]
   SET [CASINO_MACH_NO] = @LocationMachineNumber
      ,[MODEL_DESC] = @Description
      ,[IP_ADDRESS] = @IpAddress
      ,[MACH_SERIAL_NO] = @SerialNumber
      ,[MultiGameEnabled] = @IsMultiGameEnabled
 WHERE [MACH_NO] = @MachineNumber
 
IF @IsMultiGameEnabled = 0
BEGIN

	UPDATE [dbo].[MACH_SETUP]
	  SET GAME_CODE = @GameCode
	  ,BANK_NO = @BankNo
	  ,TYPE_ID = @TypeId
	WHERE [MACH_NO] = @MachineNumber
END

-- IF removed flag changes
IF (@Removed <> @RemovedStateBefore)
BEGIN
	UPDATE [dbo].[MACH_SETUP]
	   SET [REMOVED_FLAG] = @Removed,
		   [RemoveDate] = (CASE WHEN @Removed = 1 THEN GETDATE() ELSE NULL END)
	 WHERE [MACH_NO] = @MachineNumber
END           

-- Set the Return value.
RETURN @ReturnValue



GO
