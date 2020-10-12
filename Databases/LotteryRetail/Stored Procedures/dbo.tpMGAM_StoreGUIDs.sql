SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpMGAM_StoreGUIDs

Created 01-29-2005 by A. Murthy

Purpose: Stores or Retreives the Device/Installation/Application GUIDs from TPI_SETTING tbl.

Return Dataset: GUID string or empty string in case of error

Called by: MgamClient.vb\RegisterInstanceXML

Arguments:
   @TpiID             2 for MGAM
   @ItemKey           Is one of DeviceGUID:MachineNumber,
                                InstallationGUID:IP_Address,
                                ApplicationGUID:MachineNumber

Change Log:

Changed By    Change Date         Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     01-29-2005          v4.0.1
  Initial Version

A. Murthy     12-23-2005          v5.0.1
  Changed InsertDebugInfo in Error trap to work only in Debug mode. Also obtained MachNbrAsInt from @ItemKey.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpMGAM_StoreGUIDs]
   @TpiID              Int,
   @ItemKey            VarChar(128)
AS

-- Variable Declarations
DECLARE @Current_Error  Int
DECLARE @Debug          Bit
DECLARE @ItemValue      VarChar(512)
DECLARE @MachNbrAsInt   Int
DECLARE @MgamGuid       UniqueIdentifier
DECLARE @MsgText        VarChar(1024)
DECLARE @StoredProcName VarChar(20)

SET NOCOUNT ON

-- Variable Initialization
SET @Current_Error = 0
SET @ItemValue = ''
SET @MgamGuid = NEWID()
SET @StoredProcName  = 'tpMGAM_StoreGUIDs'

-- Set the @MachNbrAsInt only when MachineNumber is available.
IF ISNUMERIC(RIGHT(@ITemKey,5)) = 1
   SET @MachNbrAsInt  = CAST(RIGHT(@ItemKey,5) AS Int)
ELSE
   SET @MachNbrAsInt = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = @StoredProcName

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         @StoredProcName + ' Argument Values:  ' + 
         '  TpiID: ' + CAST(@TpiID AS VarChar) +
         '  ItemKey: ' + @ItemKey
      
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END

-- Initialize @MsgText to store any Errors from Insert/Updates into TPI_SETTING table.
SET @MsgText = ''

-- SELECT "ITEM_VALUE" col. in TPI_SETTING" table with TPI_ID=2 & ITEM_KEY=@ItemKey
SELECT @ItemValue = ITEM_VALUE FROM TPI_SETTING WHERE TPI_ID = @TpiID AND ITEM_KEY = @ItemKey

-- If the ITEM_KEY col. does not have a GUID then INSERT a new record...
IF (@@ROWCOUNT = 0)
  BEGIN
    SET @ItemValue = CONVERT(VarChar(255), @MgamGuid)
    INSERT INTO TPI_SETTING
	(TPI_ID, ITEM_KEY, ITEM_VALUE)
    VALUES
	(@TpiID, @ItemKey , @ItemValue )
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 801
      SET @ItemValue = ''
      IF (@Debug = 1)
         BEGIN
            SET @MsgText = @StoredProcName + ' Select/Insert of TPI_SETTING failed for ITEM_KEY=' + @ItemKey
            EXEC InsertDebugInfo 0, @MsgText, 0
         END
   END

IF (@Debug = 1)
   BEGIN
      SET @MsgText = @StoredProcName + '  Return Value: ' + CAST(@Current_Error AS VarChar)
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END

-- Return the @ItemValue as a resultset.
SELECT @ItemValue AS MgamGUID
GO
