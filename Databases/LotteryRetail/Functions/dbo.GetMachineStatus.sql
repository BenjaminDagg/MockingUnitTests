SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Defined Function GetMachineStatus
Created 11-02-2004 by Terry Watkins
Purpose: Checks status of a machine
Returns:   0 = Machine exists, is Active and is not removed.
         104 = Machine record not found.
         103 = Machine is not active
         129 = Machine has been removed
The return values correspond to ERROR_LOOKUP.ERROR_NO values.
Change Log
Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-02-2004     v4.0.0
  Initial Coding

A. Murthy 01-16-2006         v5.0.1
   Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
   to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[GetMachineStatus] (@MachineNbr VarChar(5)) RETURNS Integer
AS
BEGIN
   -- Variable Declarations
   DECLARE @ReturnValue Int
   DECLARE @IsActive    TinyInt
   DECLARE @IsRemoved   Bit
   
   -- Variable Initialization
   SET @ReturnValue = 0
   
   -- Retrieve Machine information.
   SELECT
      @IsActive = ACTIVE_FLAG,
      @IsRemoved = REMOVED_FLAG
   FROM MACH_SETUP
   WHERE MACH_NO = @MachineNbr
   
   IF (@@ROWCOUNT = 0)
      -- Machine not found in MACH_SETUP.
      SET @ReturnValue = 104
   ELSE IF (@IsActive = 0)
      -- Machine is not Active.
      SET @ReturnValue = 103
   ELSE IF (@IsRemoved = 1)
      -- Machine has been removed.
      SET @ReturnValue = 129
   
   -- Set the function return value.
   RETURN @ReturnValue
END

GO
