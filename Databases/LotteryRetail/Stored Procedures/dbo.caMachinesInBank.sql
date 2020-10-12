SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: caMachinesInBank

Created 09-03-2009 by Aldo Zamora

Purpose: Retrieves machines in a bank.

Called by: Millenium Accounting System

Parameters: @BankNumber

Dataset Returned:
   MachineNumber, CasinoMachineNumber, Description, Type, GameCode, GameDescription, IPAddress,
   LastActivity, SerialNumber, GameVersion, OSVersion

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   09-03-2009     v7.0.0
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[caMachinesInBank] @BankNumber int
AS

-- Turn off return of unwanted stats.
SET NOCOUNT ON

-- Retrieves data.
SELECT
   ms.MACH_NO        AS MachineNumber,
   ms.CASINO_MACH_NO AS CasinoMachineNumber,
   ms.MODEL_DESC     AS ModelDescription,
   ms.[TYPE_ID]      AS TypeID,
   ms.GAME_CODE      AS GameCode,
   gs.GAME_DESC      AS GameDescription,
   ms.IP_ADDRESS     AS IPAdress,
   CONVERT(VarChar, ms.LAST_ACTIVITY, 120) AS LastActivity,
   ms.MACH_SERIAL_NO AS MachineSerialNumber,
   ms.GAME_RELEASE   AS GameRelease,
   ms.OS_VERSION     AS OSVersion
FROM MACH_SETUP ms
   JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE @BankNumber = ms.BANK_NO AND REMOVED_FLAG = 0
ORDER BY ms.MACH_NO
GO
