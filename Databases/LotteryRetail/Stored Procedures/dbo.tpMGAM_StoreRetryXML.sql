SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpMGAM_StoreRetryXML

Created 10-11-2005 by A. Murthy

Purpose: Stores the RetryXML to be used after a Server Timeout into TPI_SETTING tbl.
         For use in CreditCash/RecordPlay.

Return Dataset: ErrorID.

Called by: DbTpMGAM_StoreRetryXML

Arguments:
   @TpiID             2 for MGAM
   @ItemKey           RetryXML:MachineNumber,
   @ItemValue         The retry XML containg CreditCash or RecordPlay info.

Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     10-11-2005     v4.0.1
  Initial Version

A. Murthy     12-23-2005     v5.0.1
  Added write to DEBUG_INFO at the end if Debugging is on.
  Also obtained MachNbrAsInt from @ItemKey

--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpMGAM_StoreRetryXML]
   @TpiID              Int,
   @ItemKey            VarChar(128),
   @ItemValue          VarChar(1024)
AS

-- Variable Declarations
DECLARE @Current_Error  Int
DECLARE @Debug          Bit
DECLARE @MachNbrAsInt   Int
DECLARE @MsgText        VarChar(1024)

SET NOCOUNT ON

-- Variable Initialization
SET @Current_Error = 0

-- Set the @MachNbrAsInt only when MachineNumber is available.
IF ISNUMERIC(RIGHT(@ITemKey,5)) = 1
   SET @MachNbrAsInt  = CAST(RIGHT(@ItemKey,5) AS Int)
ELSE
   SET @MachNbrAsInt = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpMGAM_StoreRetryXML'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpMGAM_StoreRetryXML Argument Values:  ' + 
         '  TpiID: ' + CAST(@TpiID AS VarChar) +
         '  ItemKey: ' + @ItemKey +
         '  ItemValue: ' + @ItemValue 
      
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END

-- Initialize @MsgText to store any Errors from Insert/Updates into TPI_SETTING table.
SET @MsgText = ''

-- Check if the row already exists in TPI_SETTING" table with TPI_ID=2 & ITEM_KEY=RetryXML:MachineNumber
IF EXISTS (SELECT * FROM TPI_SETTING WHERE TPI_ID=2 AND ITEM_KEY = @ItemKey)
   UPDATE TPI_SETTING SET ITEM_VALUE = @ItemValue 
   WHERE TPI_ID = 2 AND ITEM_KEY = @ItemKey
ELSE
   INSERT INTO TPI_SETTING
	(TPI_ID, ITEM_KEY, ITEM_VALUE)
    VALUES
	(@TpiID, @ItemKey , @ItemValue )

-- check for Error in Update/Insert
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 837
      SET @ItemValue = '0'
      SET @MsgText = 'Update/Insert of TPI_SETTING failed '
   END

SET @MsgText = @MsgText + '  Current_Error: ' + CAST(@Current_Error AS VarChar) + '  ItemKey: ' + @ItemKey

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpMGAM_StoreRetryXML Return Values : ' + @MsgText
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END


-- Return the @Current_Error as a resultset.
SELECT @Current_Error AS ErrorID
GO
