SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: InsertAppInfo user stored procedure.

  Created: 08-26-2009 by Terry Watkins  

  Purpose: Inserts or updates applicaton version information into the APP_INFO
           table. It is called by the back-office applications at startup.

Arguments: @ApplicationName    - The name of the application
           @ApplicationVersion - The version of the application

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
08-26-2009 Terry Watkins     v7.0.0
  Initial Coding.

08-05-2010 Terry Watkins     v7.2.2
  Modified WHERE clause of update to include computer name.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[InsertAppInfo]
   @ApplicationName         VarChar(64),
   @ComputerName            VarChar(64),
   @CurrentVersion          VarChar(16),
   @OSFullName              VarChar(64),
   @OSPlatform              VarChar(64),
   @OSVersion               VarChar(64),
   @MemoryTotalPhysical     BigInt,
   @MemoryTotalVirtual      BigInt,
   @MemoryAvailablePhysical BigInt,
   @MemoryAvailableVirtual  BigInt
AS

-- Variable Declaration
DECLARE @CurrentDT DateTime

-- Variable Initialization
SET @CurrentDT = GetDate()

-- Does a row already exist for the application and computer names?
IF EXISTS(SELECT * FROM APP_INFO WHERE APPLICATION_NAME = @ApplicationName AND COMPUTER_NAME = @ComputerName)
   -- Yes, so update it.
   BEGIN
      UPDATE APP_INFO SET
         CURRENT_VERSION           = @CurrentVersion,
         LAST_APP_STARTUP          = @CurrentDT,
         OS_FULLNAME               = @OSFullName,
         OS_PLATFORM               = @OSPlatform,
         OS_VERSION                = @OSVersion,
         MEMORY_TOTAL_PHYSICAL     = @MemoryTotalPhysical,
         MEMORY_TOTAL_VIRTUAL      = @MemoryTotalVirtual,
         MEMORY_AVAILABLE_PHYSICAL = @MemoryAvailablePhysical,
         MEMORY_AVAILABLE_VIRTUAL  = @MemoryAvailableVirtual
      WHERE
         APPLICATION_NAME = @ApplicationName AND
         COMPUTER_NAME    = @ComputerName
   END
ELSE
   -- No, so insert it.
   BEGIN
      -- Insert a new APP_INFO row...
      INSERT INTO APP_INFO
         (APPLICATION_NAME, COMPUTER_NAME, CURRENT_VERSION,
          LAST_APP_STARTUP, OS_FULLNAME, OS_PLATFORM, OS_VERSION,
          MEMORY_TOTAL_PHYSICAL, MEMORY_TOTAL_VIRTUAL,
          MEMORY_AVAILABLE_PHYSICAL, MEMORY_AVAILABLE_VIRTUAL)
      VALUES
         (@ApplicationName, @ComputerName, @CurrentVersion,
          @CurrentDT, @OSFullName, @OSPlatform, @OSVersion,
          @MemoryTotalPhysical, @MemoryTotalVirtual,
          @MemoryAvailablePhysical, @MemoryAvailableVirtual)
   END

GO
