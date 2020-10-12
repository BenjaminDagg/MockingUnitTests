SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpMGAM_GetLocalTransactionID

Created 07-22-2005 by A. Murthy

Purpose: Stores or Retreives & imcrements the LocalTransactionID from TPI_SETTING tbl.
         for use in CreditCash/RecordPlay/EndSession

Return Dataset: Steadily increasing number or 0 in case of error

Called by: MgamClient.vb\CreditCashXML, RecordTransactionXML, EndSessionXML

Arguments:
   @TpiID             2 for MGAM
   @ItemKey           LocalTransactionID:MachineNumber,

Change Log:

Changed By    Change Date         Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     07-22-2005          v4.0.1
  Initial Version

A. Murthy     12-23-2005          v5.0.1
  Added write to DEBUG_INFO if Debugging mode is on. Also obtained MachNbrAsInt from @ItemKey
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpMGAM_GetLocalTransactionID]
   @TpiID              Int,
   @ItemKey            VarChar(128)
AS

-- Variable Declarations
DECLARE @Current_Error  Int
DECLARE @Debug          Bit
DECLARE @ItemValue      VarChar(512)
DECLARE @ItemValueAsInt Int
DECLARE @MachNbrAsInt   Int
DECLARE @MsgText        VarChar(1024)

SET NOCOUNT ON

-- Variable Initialization
SET @Current_Error = 0
SET @ItemValue = ''
SET @ItemValueAsInt = 0

-- Set the @MachNbrAsInt only when MachineNumber is available.
IF ISNUMERIC(RIGHT(@ITemKey,5)) = 1
   SET @MachNbrAsInt  = CAST(RIGHT(@ItemKey,5) AS Int)
ELSE
   SET @MachNbrAsInt = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpMGAM_GetLocalTransactionID'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpMGAM_GetLocalTransactionID Argument Values:  ' + 
         '  TpiID: ' + CAST(@TpiID AS VarChar) +
         '  ItemKey: ' + @ItemKey
      
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END

-- Initialize @MsgText to store any Errors from Insert/Updates into TPI_SETTING table.
SET @MsgText = ''

-- SELECT "ITEM_VALUE" col. in TPI_SETTING" table with TPI_ID=2 & ITEM_KEY=@ItemKey
SELECT @ItemValue = ITEM_VALUE FROM TPI_SETTING WHERE TPI_ID = @TpiID AND ITEM_KEY = @ItemKey

-- If the ITEM_KEY col. does not have a LocalTransactionID:MachineNumber then INSERT a new record...
IF (@@ROWCOUNT = 0)
  BEGIN
    -- start the LocalTransactionID at 1
    SET @ItemValue = CONVERT(VarChar(255), 1)
    INSERT INTO TPI_SETTING
	(TPI_ID, ITEM_KEY, ITEM_VALUE)
    VALUES
	(@TpiID, @ItemKey , @ItemValue )
  END
ELSE
  BEGIN
    -- increment the LocalTransactionID by 1
    SET @ItemValueAsInt = CAST( @ItemValue AS Int )
    SET @ItemValueAsInt = @ItemValueAsInt + 1
    -- and convert it back to VarChar
    SET @ItemValue = CONVERT(VarChar(255), @ItemValueAsInt)
    -- and store it
    UPDATE TPI_SETTING SET ITEM_VALUE = @ItemValue 
        WHERE TPI_ID = @TpiID AND ITEM_KEY = @ItemKey
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 831
      SET @ItemValue = '0'
      SET @MsgText = 'Select/Insert/Update of TPI_SETTING failed for ITEM_KEY=' + @ItemKey
   END

SET @MsgText = @MsgText + '  Current_Error: ' + CAST(@Current_Error AS VarChar) + '  ItemValue: ' + @ItemValue

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpMGAM_GetLocalTransactionID Return Values : ' + @MsgText
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END


-- Return the @ItemValue as a resultset.
SELECT @ItemValue AS LocalTransactionID
GO
