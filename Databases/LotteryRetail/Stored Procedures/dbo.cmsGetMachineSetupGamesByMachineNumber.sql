SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
--------------------------------------------------------------------------------
Procedure Name: cmsGetMachineSetupGamesByMachineNumber

Created By:     BitOmni Inc

Create Date:    08/18/2016

Description:    Gets all entries and mach_setup_games with additonal game information for the specified machine number.
Used in Machine Setup Edit/Duplicate screens to select game setups from dropdowns already assigned.

Returns:

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 8-18-2016
  Creation of stored procedure.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsGetMachineSetupGamesByMachineNumber]
	@MachineNumber	CHAR(5)
AS

SET NOCOUNT ON

SELECT CAST(ms.BANK_NO AS VARCHAR) AS BankNumber ,
 CAST(b.BANK_NO AS VARCHAR) + ' - ' + [BANK_DESCR] AS BankDescription,
 ms.GAME_CODE AS GameCode,
 gs.GAME_CODE + ' - ' + GAME_DESC AS GameDescription,
 gs.[GAME_TITLE_ID] As GameTitleId,
ms.IsEnabled
FROM
MACH_SETUP_GAMES ms
JOIN GAME_SETUP gs on gs.GAME_CODE = ms.GAME_CODE
JOIN BANK b ON b.BANK_NO = ms.BANK_NO
WHERE MACH_NO = @MachineNumber
ORDER BY MACH_NO
GO
