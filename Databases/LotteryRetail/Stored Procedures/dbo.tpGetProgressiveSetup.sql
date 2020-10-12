SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpGetProgressiveSetup

Purpose: Returns Progressive setup data for an EGM.
         This routine will be called by each EGM playing a progressive game at
         startup.

Return Dataset: ErrorID, ErrorDescription, ShutDownFlag.

Called by: TpiClient.vb\HandleTransaction

Arguments: MachineNumber

Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-06-2009     v7.0.0
  Initial Coding.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.
  
Louis Epstein 05-15-2013     v7.3.2
  Added functionality to concat WIN_LEVEL information to the end of the message.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetProgressiveSetup] @MachineNumber Char(5)
AS

-- Variable Declarations
DECLARE @ContributionRate      Decimal(5,4)
DECLARE @DataBuffer            VarChar(512)
DECLARE @Debug                 Bit
DECLARE @ErrorDescription      VarChar(256)
DECLARE @ErrorID               Int
DECLARE @ErrorSource           VarChar(64)
DECLARE @EventCode             VarChar(2)
DECLARE @GameTypeCode          VarChar(2)
DECLARE @EventLogDesc          VarChar(1024)
DECLARE @HeaderCount           SmallInt
DECLARE @LockupMachine         Int
DECLARE @MachNbrAsInt          Int
DECLARE @MsgText               VarChar(1024)
DECLARE @PoolCount             Int
DECLARE @ProgressiveTypeID     Int
DECLARE @TimeStamp             DateTime
DECLARE @TransID               SmallInt
DECLARE @WinLevelData          VarChar(MAX)
DECLARE @WinLevelDataBuffer    VarChar(512)

DECLARE @PSData                VarChar(MAX)

SET NOCOUNT ON

-- Variable Initialization
SET @Debug              = 0
SET @ErrorDescription   = ''
SET @ErrorID            = 0
SET @ErrorSource        = 'tpGetProgressiveSetup Stored Procedure'
SET @EventCode          = 'SP'
SET @HeaderCount        = 0
SET @LockupMachine      = 0
SET @MachNbrAsInt       = CAST(@MachineNumber AS Int)
SET @PoolCount          = 0
SET @PSData             = ''
SET @TimeStamp          = GetDate()
SET @TransID            = 0
SET @WinLevelData = ''

-- Check Debug mode...
IF EXISTS(SELECT * FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpGetProgressiveSetup')
   SELECT @Debug = DEBUG_MODE FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpGetProgressiveSetup'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText = 'tpGetProgressiveSetup Argument Values:  MachineNumber: ' + ISNULL(@MachineNumber, '<null>')
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Check for existance, active, removed status of machine.
IF (@MachNbrAsInt = 0)
   SET @ErrorID = 104
ELSE
   SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

-- Ignore error 103 (MACH_SETUP.ACTIVE_FLAG = 0)
IF (@ErrorID = 103) SET @ErrorID = 0

-- If the MACH_SETUP row was found, retrieve Machine information.
IF (@ErrorID <> 104)
   BEGIN
      -- Update MACH_SETUP.LAST_ACTIVITY.
      UPDATE MACH_SETUP SET LAST_ACTIVITY = @TimeStamp WHERE MACH_NO = @MachineNumber
      
      -- Retrieve and store the Game Type Code and the Progressive Type.
      SELECT
         @GameTypeCode      = b.GAME_TYPE_CODE,
         @ProgressiveTypeID = gt.PROGRESSIVE_TYPE_ID
      FROM MACH_SETUP ms
         JOIN BANK              b ON ms.BANK_NO = b.BANK_NO
         JOIN GAME_TYPE        gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
         JOIN PROGRESSIVE_TYPE pt ON gt.PROGRESSIVE_TYPE_ID = pt.PROGRESSIVE_TYPE_ID
      WHERE MACH_NO = @MachineNumber
      
      SELECT
@ContributionRate = SUM(Rate1) + SUM(Rate2) + SUM(Rate3)
  FROM PROGRESSIVE_POOL
  WHERE PROGRESSIVE_TYPE_ID = @ProgressiveTypeID AND DENOMINATION = (SELECT MIN(DENOM_VALUE) * 100 FROM DENOM_TO_GAME_TYPE WHERE GAME_TYPE_CODE = @GameTypeCode)
  GROUP BY PROGRESSIVE_TYPE_ID, DENOMINATION
      
      -- Get a count of Progressive Pool rows for the Progressive Type and Game Type Code of the EGM...
      SELECT @PoolCount = COUNT(*)
      FROM PROGRESSIVE_POOL
      WHERE
         PROGRESSIVE_TYPE_ID = @ProgressiveTypeID AND
         GAME_TYPE_CODE = @GameTypeCode 
      
      -- If no data, set error code to 330.
      IF (@PoolCount = 0) SET @ErrorID = 330
      
      -- Are we in Debug mode?
      IF (@Debug = 1)
         -- Yes, so record retrieved values...
         BEGIN
            SET @MsgText = 'tpGetProgressiveSetup retrieved values:  GameTypeCode: ' +
                           ISNULL(@GameTypeCode, '<null>') +
                           '  ProgressiveTypeID: ' +
                           ISNULL(CAST(@ProgressiveTypeID AS VarChar), '<null>') +
                           '  ContributionRate: ' +
                           ISNULL(CAST(@ContributionRate AS VarChar), '<null>') +
                           '  Pool Count: ' +
                           ISNULL(CAST(@PoolCount AS VarChar), '<null>')
            EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
         END
   END

-- If no errors, begin constructing the output text...
IF (@ErrorID = 0)
   BEGIN
      -- Begin building the return data text.
      SET @PSData = 'PTID=' + CAST(@ProgressiveTypeID AS VarChar) +
                    ',FieldCount=6,PoolCount=' + CAST(@PoolCount AS VarChar) +
                    ',ContributionRate=' + CAST(@ContributionRate AS VarChar)
      
      -- Now add Progressive Pool data...
      DECLARE ProgressivePoolData CURSOR FOR
         SELECT ',' + CAST(PROGRESSIVE_POOL_ID AS VarChar) +
                ',' + CAST(DENOMINATION AS VarChar) +
                ',' + CAST(COINS_BET AS VarChar)  +
                ',' + CAST(LINES_BET AS VarChar) +
                ',' + CAST(CAST(POOL_1 * 100 AS BigInt) AS VarChar), 
                ',' + CAST(WinLevel AS VarChar)
         FROM PROGRESSIVE_POOL
         WHERE
            PROGRESSIVE_TYPE_ID = @ProgressiveTypeID AND
            GAME_TYPE_CODE = @GameTypeCode 
         ORDER BY DENOMINATION, LINES_BET, COINS_BET
      
      -- Open the cursor and fetch the first record...
      OPEN ProgressivePoolData
      FETCH NEXT FROM ProgressivePoolData INTO @DataBuffer, @WinLevelDataBuffer
      
      -- Begin the processing loop...
      WHILE @@FETCH_STATUS = 0
         BEGIN
            -- Concatenate the results of this select to the output text.
            SET @PSData = @PSData + @DataBuffer
            SET @WinLevelData = @WinLevelData + @WinLevelDataBuffer
            
            -- Fetch the next row.
            FETCH NEXT FROM ProgressivePoolData INTO @DataBuffer, @WinLevelDataBuffer
         END
      
      CLOSE ProgressivePoolData
      DEALLOCATE ProgressivePoolData
      
   END

SET @PSData = @PSData + @WinLevelData

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      -- Does the error id exist in ERROR_LOOKUP?
      IF EXISTS(SELECT * FROM ERROR_LOOKUP WHERE ERROR_NO = @ErrorID)
         -- Yes, so retrieve the description and lockup values...
         BEGIN
            SELECT
               @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
               @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
            FROM ERROR_LOOKUP
            WHERE ERROR_NO = @ErrorID
         END
      ELSE
         -- Error ID not found in table, set default values...
         BEGIN
            SET @ErrorDescription = 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))
            SET @LockupMachine = 1
         END
      
      -- Test if the Machine should be locked up.
      IF (@LockupMachine <> 0)
         BEGIN
            UPDATE MACH_SETUP SET ACTIVE_FLAG = 0 WHERE MACH_NO = @MachineNumber
            SET @EventCode = 'SD'
         END
      
      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription + ' Machine Number: ' + @MachineNumber
      
      -- Insert Error into the Casino_Event_Log
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)
   END

-- Is Debug mode is on?
IF (@Debug = 1)
   -- Yes, so record return argument values...
   BEGIN
      -- Record standard return values...
      SET @MsgText =
         'tpGetProgressiveSetup Return Values:  ' + 
         '  ErrorID: '          + ISNULL(CAST(@ErrorID AS VarChar), '<null>') +
         '  ErrorDescription: ' + ISNULL(@ErrorDescription, '<null>') +
         '  ShutDownFlag: '     + ISNULL(CAST(@LockupMachine AS VarChar), '<null>')
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
      
      -- Add progressive data...
      SET @MsgText = 'tpGetProgressiveSetup Data:  ' + @PSData
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @PSData           AS ProgressiveSetupData
GO
