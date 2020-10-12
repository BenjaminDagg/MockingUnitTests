SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpUpdateMachineGameRelease

Desc: Updates MACH_SETUP.GAME_RELEASE.

Written: 11-20-2008 by Terry Watkins

Called by: TransactionPortal after receiving A trans with "STATUS" command

Parameters:
   @MachineNumber     DGE Machine Identifier
   @GameRelease       New Game Release value.


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-20-2008     v6.0.2
  Initial coding.

Terry Watkins 11-20-2008     v7.0.0
  Added @OSVersion (with empty string default) to update the new OS_VERSION
  column in the MACH_SETUP table.

Terry Watkins 11-20-2008     v7.2.2
  Added new version arguments to update new version columns in MACH_SETUP.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpUpdateMachineGameRelease]
   @MachineNumber        Char(5),
   @GameRelease          VarChar(16) = '',
   @OSVersion            VarChar(16) = '',
   @SystemVersion        VarChar(16) = '',
   @SystemLibAVersion    VarChar(16) = '',
   @SystemCoreLibVersion VarChar(16) = '',
   @MathDllVersion       VarChar(16) = '',
   @GameCoreLibVersion   VarChar(16) = '',
   @GameLibVersion       VarChar(16) = '',
   @MathLibVersion       VarChar(16) = ''
AS

-- Variable Declarations
   
-- Update the MACH_SETUP table...
UPDATE MACH_SETUP SET
   GAME_RELEASE            = @GameRelease,
   OS_VERSION              = @OSVersion,
   SYSTEM_VERSION          = @SystemVersion,
   SYSTEM_LIB_A_VERSION    = @SystemLibAVersion,
   SYSTEM_CORE_LIB_VERSION = @SystemCoreLibVersion,
   MATH_DLL_VERSION        = @MathDllVersion,
   GAME_CORE_LIB_VERSION   = @GameCoreLibVersion,
   GAME_LIB_VERSION        = @GameLibVersion,
   MATH_LIB_VERSION        = @MathLibVersion
WHERE MACH_NO = @MachineNumber
GO
