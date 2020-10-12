SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: mmMachineStatus

Created By:     Terry Watkins

Create Date:    05-19-2011

Description:    Machine Monitoring procedure to evaluate the current status of
                machines based on MACH_SETUP table column values.

Returns:        Machine data for machines that are not playable.

Parameters:     @IncludeOnlineMachines   Flag that defaults to 0 indicating if
                                         Online machines should be included.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 05-19-2011     v2.0.1
  Initial Coding.

Terry Watkins 05-19-2011     v2.0.2
  Added LOCATION_NAME to resultset.
  
Terry Watkins 05-19-2011     v2.0.3
  Fixed bug that caused all like numbered machines to have the same Status
  without regard for the Location.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[mmMachineStatus] @IncludeOnlineMachines Bit = 0
AS

-- SET NOCOUNT ON to prevent return of unwanted information.
SET NOCOUNT ON

-- [Variable Declarations]
DECLARE @ActiveFlag          TinyInt
DECLARE @CurrentTime         DateTime
DECLARE @MachineNbr          Char(5)
DECLARE @LastConnect         DateTime
DECLARE @LastDisconnect      DateTime
DECLARE @LocationID          Int
DECLARE @PlayStatus          Bit
DECLARE @PlayStatusChanged   DateTime
DECLARE @StatusType          Int

-- [Variable Initialization]
SET @CurrentTime = GETDATE()

-- Insert machine data into a temporary table.
SELECT
   ms.MACH_NO,
   ms.CASINO_MACH_NO,
   ms.MODEL_DESC,
   ms.GAME_CODE,
   ms.ACTIVE_FLAG,
   ms.PLAY_STATUS,
   ms.PLAY_STATUS_CHANGED,
   ms.LAST_CONNECT,
   ms.LAST_DISCONNECT,
   ms.IP_ADDRESS,
   ms.BALANCE,
   ms.MACH_SERIAL_NO,
   ms.VOUCHER_PRINTING,
   ms.LOCATION_ID,
   ms.REMOVED_FLAG,
   CAST(0 AS SmallInt)  AS STATUS_TYPE,
   c.CAS_NAME           AS LOCATION_NAME
INTO #MachineInfo
FROM MACH_SETUP ms
   LEFT OUTER JOIN dbo.CASINO c ON c.LOCATION_ID = ms.LOCATION_ID
WHERE ms.MACH_NO <> '0' AND ms.REMOVED_FLAG = 0

-- Cursor Declaration to retrieve machines that have had activity.
DECLARE MachineStatusList CURSOR
FOR
   SELECT MACH_NO, LOCATION_ID, ACTIVE_FLAG, LAST_CONNECT, LAST_DISCONNECT, PLAY_STATUS, PLAY_STATUS_CHANGED
   FROM #MachineInfo
   WHERE MACH_NO <> '0' AND REMOVED_FLAG = 0
   ORDER BY MACH_NO
    
-- Open the cursor and perform the first FETCH...
OPEN MachineStatusList

FETCH FROM MachineStatusList
INTO @MachineNbr, @LocationID, @ActiveFlag, @LastConnect, @LastDisconnect, @PlayStatus, @PlayStatusChanged

WHILE (@@FETCH_STATUS = 0)
   -- Successfully FETCHed a record, so insert a new row into temporary table #MonthlyRevenuebyGame.
   BEGIN
      -- Initialize machine status
      SET @StatusType = 0
      
      -- Begin Machine Status evaluation.
      IF (@LastConnect IS NULL OR @PlayStatusChanged IS NULL)
         -- Status = Never connected.
         BEGIN
            SET @StatusType = 3
         END
      ELSE IF (@LastDisconnect IS NOT NULL AND @LastDisconnect > @LastConnect)
         -- Status = Disconnected from Server.
         BEGIN
            SET @StatusType = 1
         END
      ELSE IF (@PlayStatus = 0)
         -- Status = Connected but not playable.
         BEGIN
            SET @StatusType = 2
         END
      
      -- Update the machine status in the temporary table.
      IF (@StatusType <> 0)
         BEGIN
            UPDATE #MachineInfo SET STATUS_TYPE = @StatusType
            WHERE MACH_NO = @MachineNbr AND LOCATION_ID = @LocationID
         END
      
      -- Attempt to fetch next cursor row.
      FETCH NEXT FROM MachineStatusList
      INTO @MachineNbr, @LocationID, @ActiveFlag, @LastConnect, @LastDisconnect, @PlayStatus, @PlayStatusChanged
   END

-- Close and Deallocate Cursor
CLOSE MachineStatusList
DEALLOCATE MachineStatusList

SELECT
   mi.LOCATION_ID,
   ISNULL(mi.LOCATION_NAME, '<null>') AS LOCATION_NAME,
   mi.MACH_NO,
   mi.CASINO_MACH_NO,
   mi.MODEL_DESC,
   mi.GAME_CODE,
   mi.ACTIVE_FLAG,
   mi.PLAY_STATUS,
   mi.PLAY_STATUS_CHANGED,
   mi.LAST_CONNECT,
   mi.LAST_DISCONNECT,
   mi.IP_ADDRESS,
   mi.BALANCE,
   mi.MACH_SERIAL_NO,
   mi.VOUCHER_PRINTING,
   mi.REMOVED_FLAG,
   mi.STATUS_TYPE,
   ms.LongName AS STATUS_TEXT
FROM #MachineInfo mi
   LEFT OUTER JOIN MachineStatus ms ON mi.STATUS_TYPE = ms.MachineStatusID
WHERE STATUS_TYPE > 0 OR @IncludeOnlineMachines = 1

-- Drop the temp table.
DROP TABLE #MachineInfo
GO
