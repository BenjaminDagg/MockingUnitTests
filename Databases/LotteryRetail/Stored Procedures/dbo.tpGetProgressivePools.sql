SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpGetProgressivePools

Created 07-09-2009 by Terry Watkins

Description: Returns a list of all progressive pool values.

Parameters: Machine number

Change Log:

Changed By    Date            Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-09-2009      v7.0.0
  Initial coding.

Terry Watkins 07-09-2009      v7.2.1
  Added error logging into CASINO_EVENT_LOG.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetProgressivePools] @MachineNumber Char(5)
AS

-- [Variable Declarations]
DECLARE @Debug              Bit
DECLARE @ErrorID            Int
DECLARE @ErrorDescription   VarChar(256)
DECLARE @ErrorSource        VarChar(64)
DECLARE @EventCode          VarChar(2)
DECLARE @EventLogDesc       VarChar(1024)
DECLARE @LockupMachine      Int
DECLARE @MachineGTC         VarChar(2)
DECLARE @MachNbrAsInt       Int
DECLARE @MsgText            VarChar(2048)
DECLARE @PoolCount          Int
DECLARE @PPoolData          VarChar(64)
DECLARE @ProgressiveTypeID  Int
DECLARE @ReturnText         VarChar(1024)
DECLARE @TransID            Int

-- [Variable Initialization]
SET @ErrorID               = 0
SET @ErrorDescription      = ''
SET @ErrorSource           = 'tpGetProgressivePools Stored Procedure'
SET @EventCode             = 'SP'
SET @LockupMachine         = 0
SET @MachNbrAsInt          = CAST(@MachineNumber AS Int)
SET @PoolCount             = 0
SET @ReturnText            = ''
SET @TransID               = 64

-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
SET NOCOUNT ON

-- Check debug mode.
IF EXISTS(SELECT * FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpGetProgressivePools')
   SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpGetProgressivePools'
ELSE
   SET @Debug = 0

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText = 'tpGetProgressivePools Arguments -  MachineNumber: ' + @MachineNumber      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Check for existance, active, removed status of machine.
SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

-- Ignore error 103 (MACH_SETUP.ACTIVE_FLAG = 0).
IF (@ErrorID = 103) SET @ErrorID = 0

-- If the machine status is okay, retrieve the ProgressiveTypeID and the Game Type Code.
IF (@ErrorID = 0)
   BEGIN   
      SELECT
         @ProgressiveTypeID = GT_PROGRESSIVE_TYPE_ID,
         @MachineGTC        = BANK_GTC
      FROM uvwMachineSetup
      WHERE MACH_NO = @MachineNumber
      
      -- Is this machine playing a progressive game?
      IF (@ProgressiveTypeID > 0)
         BEGIN
            -- Retrieve the number of progressive pools that will be returned.
            SELECT @PoolCount = COUNT(*) FROM PROGRESSIVE_POOL
            WHERE PROGRESSIVE_TYPE_ID = @ProgressiveTypeID AND GAME_TYPE_CODE = @MachineGTC
            
            -- Is there pool data to retrieve?
            IF (@PoolCount > 0)
            -- Yes, 
               BEGIN
                  SET @ReturnText = CAST(@PoolCount AS VarChar) + ','
                  
                  DECLARE PoolInfo CURSOR FAST_FORWARD FOR                     SELECT                        CAST(PROGRESSIVE_POOL_ID AS VarChar) + ',' + CAST(CAST((POOL_1 * 100) AS BigInt) AS VarChar) + ','                     FROM PROGRESSIVE_POOL                     WHERE PROGRESSIVE_TYPE_ID = @ProgressiveTypeID AND GAME_TYPE_CODE = @MachineGTC                     ORDER BY DENOMINATION, LINES_BET, COINS_BET                                    -- Open the cursor                  OPEN PoolInfo
                                    -- Fetch the first row.                  FETCH FROM PoolInfo INTO @PPoolData                                    -- Begin read/process loop...                  WHILE (@@FETCH_STATUS = 0)                     BEGIN                        SET @ReturnText = @ReturnText + @PPoolData
                        
                        -- Get the next machine number.
                        FETCH NEXT FROM PoolInfo INTO  @PPoolData
                     END                  -- Close and Deallocate the Cursor                  CLOSE PoolInfo                  DEALLOCATE PoolInfo                                    -- Trim the trailing comma.                  IF (LEN(@ReturnText) > 1) SET @ReturnText = SUBSTRING(@ReturnText, 1, LEN(@ReturnText) -1)               END
            ELSE
               -- PoolCount is zero, set @ErrorID to 330.
               SET @ErrorID = 330
         END
      ELSE
         -- ProgressiveTypeID is not greater than zero, set @ErrorID to 330.
         SET @ErrorID = 330
   END

-- If Error is non-zero, look up the error message and shutdown flag.
IF (@ErrorID <> 0)
   BEGIN
      IF EXISTS(SELECT * FROM ERROR_LOOKUP WHERE ERROR_NO = @ErrorID)
         BEGIN
            SELECT
               @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar)),
               @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
            FROM ERROR_LOOKUP
            WHERE ERROR_NO = @ErrorID
         END
      ELSE
         BEGIN
            SET @ErrorDescription = 'Undefined Error ' + CAST(@ErrorID AS VarChar)
            SET @LockupMachine = 1
         END

      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription + ' Machine Number: ' + @MachineNumber

      -- Insert Error into the Casino_Event_Log
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @ReturnText       AS PoolData
GO
