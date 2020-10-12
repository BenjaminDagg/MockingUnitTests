SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpGetStoreCheckSum

Purpose: Stores or Retreives the machine Checksum from TPI_SETTING tbl.

Return Dataset: CHECKSUM string or empty string in case of error

Called by: TransactionPortalControl.vb\DbtpGetStoreCheckSum
           IowaMonitorConsole.vb\DbtpGetStoreCheckSum

Arguments:
   @TpiID             3 for MGAM
   @ItemKey           CheckSum:CasinoMachNo
   @CheckSum         The binary checksum

Change Log:

Changed By    Change Date         Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     02-07-2006          v5.0.1
  Initial Version

A. Murthy     06-16-2006          v5.0.4 Changed storage into DEBUG_INFO from
                                         CASINO_MACH_NO to MACH_NO.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetStoreCheckSum]
   @TpiID              Int,
   @ItemKey            VarChar(128),
   @CheckSum           BigInt = 0
AS

-- Variable Declarations
DECLARE @CasinoMachNo   VarChar(8)
DECLARE @Debug          Bit
DECLARE @MachNbrAsInt   Int
DECLARE @MachNo         Char(5)
DECLARE @MsgText        VarChar(1024)
DECLARE @RowCount       Int
DECLARE @StoredProcName VarChar(20)

SET NOCOUNT ON

-- Variable Initialization
SET @CasinoMachNo = ''
SET @MachNo       = '     '
SET @RowCount = 0
SET @StoredProcName  = 'tpGetStoreCheckSum'

-- Parse out the CasinoMachNo from @ItemKey ( everything to the Right of "CheckSum:")
SET @CasinoMachNo = RIGHT(@ItemKey, LEN(@ItemKey) - 9)

-- Get the MACH_NO corresponding to the above CASINO_MACH_NO
SELECT @MachNo=ISNULL(MACH_NO,'00000')
   FROM MACH_SETUP WHERE CASINO_MACH_NO=@CasinoMachNo

-- Set the @MachNbrAsInt from the MACH_NO.
SET @MachNbrAsInt  = CAST(@MachNo AS Int)

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = @StoredProcName

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         @StoredProcName + ' Argument Values:  ' + 
         '  TpiID: ' + CAST(@TpiID AS VarChar) +
         '  ItemKey: ' + @ItemKey +
         '  CheckSum: ' + CAST(@CheckSum AS VarChar)
      
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END

-- Initialize @MsgText to store any Errors from Insert/Updates into TPI_SETTING table.
SET @MsgText = ''

-- Check if we have a row in TPI_SETTING" table with TPI_ID=3 & ITEM_KEY=CheckSum:CasinoMachNo
SELECT @RowCount = COUNT(*) FROM TPI_SETTING WHERE TPI_ID = @TpiID AND ITEM_KEY = @ItemKey

-- If the row does not exist, then INSERT a new record...
IF (@RowCount = 0)
  BEGIN
    INSERT INTO TPI_SETTING
	(TPI_ID, ITEM_KEY, ITEM_VALUE)
    VALUES
	(@TpiID, @ItemKey , CAST(@CheckSum AS VarChar) )
  END
ELSE IF (@RowCount = 1)
  -- Record exists update the ITEM_VALUE col. with the new CheckSum
  BEGIN
    UPDATE TPI_SETTING SET ITEM_VALUE = CAST(@CheckSum AS VarChar) WHERE TPI_ID = @TpiID AND ITEM_KEY = @ItemKey
  END

-- Check for Error
IF (@@ERROR <> 0)
   -- Set the CheckSum to the 0.
   SET @CheckSum = 0

IF (@Debug = 1)
   BEGIN
      SET @MsgText = @StoredProcName + '  Return Value: @CheckSum = ' + CAST(@CheckSum AS VarChar)
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END

-- Return the @CheckSum as a resultset.
SELECT @CheckSum AS CheckSum
GO
