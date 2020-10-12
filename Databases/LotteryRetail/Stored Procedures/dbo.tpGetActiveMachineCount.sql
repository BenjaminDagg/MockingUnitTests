SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpGetActiveMachineCount

Created 06-07-2007 by Terry Watkins

Description: Returns the number of machines that have a positive balance.

Parameters: <none>

Change Log:

Changed By    Date            Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 06-07-2007      6.0.1
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetActiveMachineCount] @MiniumCount Int = 2
AS

-- [Variable Declarations]
DECLARE @ActiveCount      Int
DECLARE @ErrorID          Int
DECLARE @LockupMachine    Int
DECLARE @ErrorDescription VarChar(256)

-- [Variable Initialization]
SET @ErrorID          = 0
SET @ErrorDescription = ''
SET @LockupMachine    = 0

-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
SET NOCOUNT ON

-- Retrieve the count.
SELECT @ActiveCount = COUNT(*)
FROM MACH_SETUP
WHERE REMOVED_FLAG = 0 AND BALANCE > 0

-- Test active vs. minimum, if too few, set error code to 911.
IF (@ActiveCount < @MiniumCount)
   SET @ErrorID = 911

-- If Error is non-zero, look up the error message and shutdown flag.
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @ActiveCount      AS ActiveMachineCount

GO
