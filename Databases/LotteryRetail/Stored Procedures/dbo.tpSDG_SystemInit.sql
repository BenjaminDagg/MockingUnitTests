SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpSDG_SystemInit

Created 12-10-2004 by 

Purpose: Loads values returned by SDG "SYSTEMINIT" call into the CASINO and
         TPI_SETTING tables.

Return Dataset: ReturnCode

Called by: SdgServer.vb\processSystemInit

Arguments:
   @TPI_Property_ID   A number used to uniquely identify this site. (CASINO tbl)
   @Eod               Number of seconds after midnight that the property ends its day (TPI_SETTING tbl)
   @MeterCutoff       Number of seconds after midnight when SDG system will stop accepting meters (TPI_SETTING tbl)
   @EncryptionKey     Number used as seed for SDG supplied encryption routines (TPI_SETTING tbl)
   @AccountingMethod  This value will be SNAPSHOT only (TPI_SETTING tbl)
   @ExpirationDays    The number of days before which vouchers will be expired. (TPI_SETTING tbl)
   @HeartBeatInterval Expressed in seconds between HeartBeats. (TPI_SETTING tbl)
   @Version           SDG Version Number expressed as A.xx.yy (TPI_SETTING tbl)
   @PlayerTracking    True or False, if PlayerTracking is enabled or disabled (TPI_SETTING tbl)
   @eCoupon           True or False, indicates if TPI will accept eCoupons (TPI_SETTING tbl)

Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     12-10-2004     v4.0.0
  Initial Version

A. Murthy     04-21-2004     v4.1.0
  Added argument @eCoupon for SDG eCoupon processing
  
C. Coddington 01-31-2006     v5.0.1
  Added debug check before return value insertion.  
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpSDG_SystemInit]
   @TPI_Property_ID    Int,
   @Eod                VarChar(512),
   @MeterCutoff        VarChar(512),
   @EncryptionKey      VarChar(512),
   @AccountingMethod   VarChar(512),
   @ExpirationDays     VarChar(512),
   @HeartBeatInterval  VarChar(512),
   @Version            VarChar(512),
   @PlayerTracking     VarChar(512),
   @eCoupon            VarChar(8) = ''
AS

-- Variable Declarations
DECLARE @Current_Error  Int
DECLARE @Debug          Bit
DECLARE @MsgText        VarChar(1024)

SET NOCOUNT ON

-- Truncate the TPI_SETTING table prior to loading it.
TRUNCATE TABLE TPI_SETTING

-- Variable Initialization
SET @Current_Error = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpSDG_SystemInit'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpSDG_SystemInit Argument Values:  ' + 
         '  TPI_Property_ID: ' + CAST(@TPI_Property_ID AS VarChar) +
         '  Eod: ' + @Eod +
         '  MeterCutoff: ' + @MeterCutoff +
         '  EncryptionKey: ' + @EncryptionKey +
         '  AccountingMethod: ' + @AccountingMethod +
         '  ExpirationDays: ' + @ExpirationDays +
         '  HeartbeatInterval: ' + @HeartbeatInterval +
         '  Version: ' + @Version +
         '  PlayerTracking: ' + @PlayerTracking +
         '  eCoupon: ' + @eCoupon
      
      EXEC InsertDebugInfo 0, @MsgText, 0
   END

-- initialize @MsgText to store any Errors from Insert/Updates into TPI_SETTING table
SET @MsgText = ''

-- Update "TPI_PROPERTY_ID" col. in CASINO table
UPDATE CASINO SET TPI_PROPERTY_ID = @TPI_Property_ID WHERE SETASDEFAULT = 1

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "Eod"
UPDATE TPI_SETTING SET ITEM_VALUE = @Eod WHERE TPI_ID = 1 AND ITEM_KEY = 'Eod'

-- If the ITEM_VALUE col. does not have 'Eod" then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO TPI_SETTING
	(TPI_ID, ITEM_KEY, ITEM_VALUE)
    VALUES
	(1, 'Eod', @Eod)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 601
      SET @MsgText = 'tpSDG_SystemInit Insert/Update of TPI_SETTING failed for Eod'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "MeterCutoff"
UPDATE TPI_SETTING SET ITEM_VALUE = @MeterCutoff WHERE TPI_ID = 1 AND ITEM_KEY = 'MeterCutoff'

-- If the ITEM_VALUE col. does not have 'MeterCutoff" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'MeterCutoff', @MeterCutoff)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 601
      SET @MsgText = 'tpSDG_SystemInit Insert/Update of TPI_SETTING failed for MeterCutoff'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "EncryptionKey"
UPDATE TPI_SETTING SET ITEM_VALUE = @EncryptionKey WHERE TPI_ID = 1 AND ITEM_KEY = 'EncryptionKey'

-- If the ITEM_VALUE col. does not have 'EncryptionKey" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'EncryptionKey', @EncryptionKey)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 601
      SET @MsgText = 'tpSDG_SystemInit Insert/Update of TPI_SETTING failed for EncryptionKey'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AccountingMethod"
UPDATE TPI_SETTING SET ITEM_VALUE = @AccountingMethod WHERE TPI_ID = 1 AND ITEM_KEY = 'AccountingMethod'

-- If the ITEM_VALUE col. does not have 'AccountingMethod" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AccountingMethod', @AccountingMethod)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 601
      SET @MsgText = 'tpSDG_SystemInit Insert/Update of TPI_SETTING failed for AccountingMethod'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "ExpirationDays"
UPDATE TPI_SETTING SET ITEM_VALUE = @ExpirationDays WHERE TPI_ID = 1 AND ITEM_KEY = 'ExpirationDays'

-- If the ITEM_VALUE col. does not have 'ExpirationDays" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'ExpirationDays', @ExpirationDays)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 601
      SET @MsgText = 'tpSDG_SystemInit Insert/Update of TPI_SETTING failed for ExpirationDays'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "HeartbeatInterval"
UPDATE TPI_SETTING SET ITEM_VALUE = @HeartbeatInterval WHERE TPI_ID = 1 AND ITEM_KEY = 'HeartbeatInterval'

-- If the ITEM_VALUE col. does not have 'HeartbeatInterval' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'HeartbeatInterval', @HeartbeatInterval)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 601
      SET @MsgText = 'tpSDG_SystemInit Insert/Update of TPI_SETTING failed for HeartbeatInterval'
   END


-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "Version"
UPDATE TPI_SETTING SET ITEM_VALUE = @Version WHERE TPI_ID = 1 AND ITEM_KEY = 'Version'

-- If the ITEM_VALUE col. does not have 'Version" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'Version', @Version)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 601
      SET @MsgText = 'tpSDG_SystemInit Insert/Update of TPI_SETTING failed for Version'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "PlayerTracking"
UPDATE TPI_SETTING SET ITEM_VALUE = @PlayerTracking WHERE TPI_ID = 1 AND ITEM_KEY = 'PlayerTracking'

-- If the ITEM_VALUE col. does not have 'PlayerTracking' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'PlayerTracking', @PlayerTracking)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 601
      SET @MsgText = 'tpSDG_SystemInit Insert/Update of TPI_SETTING failed for PlayerTracking'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "eCoupon"
UPDATE TPI_SETTING SET ITEM_VALUE = @eCoupon WHERE TPI_ID = 1 AND ITEM_KEY = 'eCoupon'

-- If the ITEM_VALUE col. does not have 'eCoupon' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'eCoupon', @eCoupon)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 601
      SET @MsgText = 'tpSDG_SystemInit Insert/Update of TPI_SETTING failed for eCoupon'
   END

IF (@Debug = 1)
   BEGIN
      SET @MsgText = @MsgText + '  Return Value: ' + CAST(@Current_Error AS VarChar)
      EXEC InsertDebugInfo 0, @MsgText, 0
   END
   
-- Return the error code as a resultset.
SELECT @Current_Error AS ReturnCode
GO
