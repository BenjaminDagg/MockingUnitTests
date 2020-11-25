SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*
--------------------------------------------------------------------------------
Procedure Name: cmsGetMachineAndGamesAssignedToBank

Created By:     BitOmni Inc

Create Date:    09/13/2016

Description:    Gets all machines and games assigned in specified format for use in MachinesAssignedToBank Data grid

Returns:  Simple select statment that returns information about a bank.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 9-13-2016
  Creation of stored procedure.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[cmsGetMachineAndGamesAssignedToBank]
	@BankNumber INT
AS

SET NOCOUNT ON

            
SELECT ms.[MACH_NO] AS MachineNumber,
	   ms.[CASINO_MACH_NO] AS LocationMachineNumber,
       ms.[MODEL_DESC] AS [Description],
       ms.[IP_ADDRESS] AS IpAddress,
       ISNULL(CONVERT(VARCHAR,  ms.[LAST_ACTIVITY], 101), 'Never') + ' '
		+ ISNULL(LTRIM(RIGHT(CONVERT(CHAR(20),  ms.[LAST_ACTIVITY], 22), 11)), '') AS LastActivity,
       ms.[MACH_SERIAL_NO] AS SerialNumber, 
       ISNULL(ms.[OS_VERSION], '') AS OsVersion,
       msg.[GAME_CODE] AS GameCode,
       msg.[TYPE_ID] AS [Type],
       (SELECT [GAME_DESC] FROM [dbo].[GAME_SETUP] gs WHERE gs.[GAME_CODE] = msg.[GAME_CODE]) AS GameDescription,
       msg.[GAME_RELEASE] AS GameVersion
FROM [dbo].[MACH_SETUP] ms 
LEFT OUTER JOIN [dbo].[MACH_SETUP_GAMES] msg ON msg.MACH_NO = ms.MACH_NO
WHERE msg.[BANK_NO] = @BankNumber
AND [REMOVED_FLAG] = 0
ORDER BY 1
GO
