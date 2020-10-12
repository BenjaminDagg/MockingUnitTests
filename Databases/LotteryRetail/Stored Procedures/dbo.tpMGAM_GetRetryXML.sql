SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpMGAM_GetRetryXML

Created 10-11-2005 by A. Murthy

Purpose: Retreives the RetryXML from TPI_SETTING tbl.
         for use in CreditCash/RecordPlay

Return Dataset: XML stream

Called by: MgamClient.vb\DbTpMGAM_GetRetryXML

Arguments:
   @TpiID             2 for MGAM
   @ItemKey           RetryXML:MachineNumber,

Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     10-11-2005     v4.0.1
  Initial Version

A. Murthy     12-23-2005     v5.0.1
  Added write to DEBUG_INFO if Debugging mode is on.
  Also obtained MachNbrAsInt from @ItemKey.

--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpMGAM_GetRetryXML]
   @TpiID              Int,
   @ItemKey            VarChar(128)
AS

-- Variable Declarations
DECLARE @Current_Error  Int
DECLARE @Debug          Bit
DECLARE @ItemValue      VarChar(1024)
DECLARE @MachNbrAsInt   Int
DECLARE @MsgText        VarChar(1024)

SET NOCOUNT ON

-- Variable Initialization
SET @Current_Error = 0
SET @ItemValue = ''

-- Set the @MachNbrAsInt only when MachineNumber is available.
IF ISNUMERIC(RIGHT(@ITemKey,5)) = 1
   SET @MachNbrAsInt  = CAST(RIGHT(@ItemKey,5) AS Int)
ELSE
   SET @MachNbrAsInt = 0


-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpMGAM_GetRetryXML'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpMGAM_GetRetryXML Argument Values:  ' + 
         '  TpiID: ' + CAST(@TpiID AS VarChar) +
         '  ItemKey: ' + @ItemKey
      
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END

-- Initialize @MsgText to store any Errors from SELECTs into TPI_SETTING table.
SET @MsgText = ''

-- SELECT "ITEM_VALUE" col. in TPI_SETTING" table with TPI_ID=2 & ITEM_KEY=@ItemKey
SELECT @ItemValue = ITEM_VALUE FROM TPI_SETTING WHERE TPI_ID = @TpiID AND ITEM_KEY = @ItemKey

-- check for no rows in Select
IF (@@ROWCOUNT = 0)
   BEGIN
      -- no error. Set ItemValue to ''
      SET @ItemValue = ''
      SET @Current_Error = 0
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 838
      SET @ItemValue = ''
      SET @MsgText = 'Select of TPI_SETTING failed for ITEM_KEY=' + @ItemKey
   END

SET @MsgText = @MsgText + '  Current_Error: ' + CAST(@Current_Error AS VarChar) + '  ItemValue: ' + @ItemValue

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpMGAM_GetRetryXML Return Values : ' + @MsgText
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END

-- Return the @Current_Error, @ItemValue as a resultset.
SELECT @Current_Error AS ErrorID, @ItemValue AS RetryXML
GO
