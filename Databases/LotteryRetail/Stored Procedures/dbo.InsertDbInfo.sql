SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: InsertDbInfo user stored procedure.

  Created: 01/23/2003 by Terry Watkins  

  Purpose: Inserts Database version information into the DB_INFO table.
           It should be called whenever upgrading the database schema.

Arguments: @UpgradeVersion - The DGE database version.

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
2003-01-23 Terry Watkins
  Initial Coding.

2006-12-14 Terry Watkins
  Upgrading to SQL Server 2005.
  Altered DB_INFO columns and adjusted insertions accordingly.
  
2014-05-15 Louis Epstein
  Added LocationID and DatabaseName to update query.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[InsertDbInfo] (@UpgradeVersion VarChar(8))
AS


DECLARE @CpuCount            SmallInt

DECLARE @PhysicalMemoryMB    Int
DECLARE @VirtualMemoryMB     Int

DECLARE @PhysicalMemoryBytes BigInt
DECLARE @VirtualMemoryBytes  BigInt

DECLARE @ServerName          VarChar(32)
DECLARE @SQLVersion          VarChar(12)
DECLARE @SQLSrvPack          VarChar(16)
DECLARE @SQLEdition          VarChar(32)
DECLARE @LocationID          Int
DECLARE @DatabaseName          VarChar(32)


SELECT
   @SQLVersion = CAST(ServerProperty('ProductVersion') AS VARCHAR),
   @SQLSrvPack = CAST(ServerProperty('ProductLevel') AS VARCHAR),
   @SQLEdition = CAST(ServerProperty('Edition') AS VARCHAR),
   @ServerName = CAST(ServerProperty('ServerName') AS VARCHAR),
   @DatabaseName = DB_NAME()
   
SELECT @LocationID = LOCATION_ID FROM CASINO WHERE SETASDEFAULT = 1
SELECT @LocationID = ISNULL(@LocationID, 0)

-- Retrieve number of CPUs and Physical Memory...
SELECT
   @CpuCount    = cpu_count,
   @PhysicalMemoryBytes = physical_memory_in_bytes,
   @VirtualMemoryBytes  = virtual_memory_in_bytes
FROM sys.dm_os_sys_info

-- Convert bytes to MegaBytes...
SET @PhysicalMemoryMB = (@PhysicalMemoryBytes + 524288) / 1048576
SET @VirtualMemoryMB  = (@VirtualMemoryBytes  + 524288) / 1048576

-- Insert a new DB_INFO row...
INSERT INTO DB_INFO
   (UPGRADE_VERSION, SQL_VERSION, SQL_EDITION, SQL_SERVICE_PACK, SERVER_NAME, CPU_COUNT, PHYSICAL_MEMORY, VIRTUAL_MEMORY, LocationID, DatabaseName)
VALUES
   (@UpgradeVersion, @SQLVersion, @SQLEdition, @SQLSrvPack, @ServerName, @CpuCount, @PhysicalMemoryMB, @VirtualMemoryMB, @LocationID, @DatabaseName)



GO
