SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpInsertVoucher

Created 01-10-2005 by A. Murthy

Desc: Inserts a new row into the VOUCHER table.

Returns: DataSet of ErrorCode, ErrorDescription, ShutdownFlag, VoucherID

Called by: TPIClient.vb\doVoucherInsert

Parameters:
   @Barcode             Barcode of the Ticket
   @TimeStamp           DateTime value sent from the Machine
   @TransAmt            Transaction amount in cents
   @MachineNumber       The Machine Number where play occurred
   @VoucherType         0=Ordinary Cashout, 1=Jackpot Cashout,
                        2=Hand Pay, 3=Jackpot Hand Pay
   @Checksum            Encrypted value of selected voucher column values.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Ashok Murthy  01-10-2005     v4.0.1
  Initial coding.

Ashok Murthy  12-27-2005     v5.0.1
  Added input argument @Checksum which will be stored in VOUCHER.CHECK_VALUE.
  Changed @Barcode to VarChar to support 12 char. Iowa Barcodes.

  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
  to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

A. Murthy     03-08-2006     v5.0.2
  Changed input argument @Checksum from VarChar(16) to VarBinary(8).

A. Murthy     02-09-2007     v5.0.8
  Removed setting REDEEMED_DATE = NULL in Insert stmt. because that is the column default.

Terry Watkins 02-11-2009     v6.0.4
  Added @SessionPlayAmt argument to update the new VOUCHER.SESSION_PLAY_AMOUNT
  column.  It has a default value of zero so this stored procedure can be called
  by older versions of the TP without failing.

  Removed Checksum from first debug message text.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.

Terry Watkins 05-04-2011     v2.0.1 DCL
  Created tpInsertVoucher using tpInsertBarCode, then dropped tpInsertBarcode.
  Added code to populate new VOUCHER.GAME_TITLE_ID column.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpInsertVoucher]
   @Barcode             VarChar(18),
   @TimeStamp           DateTime,
   @TransAmt            Int,
   @MachineNumber       Char(5),
   @VoucherType         Int,
   @Checksum            VarBinary(8),
   @SessionPlayAmt      Int = 0
AS

-- Variable Declarations
DECLARE @Debug                 Bit
DECLARE @ErrorID               Int
DECLARE @ErrorNum              Int
DECLARE @ErrorSource           VarChar(64)
DECLARE @ErrorText             VarChar(1024)
DECLARE @ErrorDescription      VarChar(256)
DECLARE @EventCode             VarChar(2)
DECLARE @EventLogDesc          VarChar(1024)
DECLARE @GameTitleID           Int
DECLARE @LocationID            Int
DECLARE @LockupMachine         Int
DECLARE @MachNbrAsInt          Int
DECLARE @MsgText               VarChar(2048)
DECLARE @SessionPlayAmtAsMoney Money
DECLARE @TransAmtAsMoney       Money
DECLARE @TransID               SmallInt
DECLARE @VoucherID             Int

SET NOCOUNT ON

-- Variable Initialization
-- Convert Transaction and SessionPlay Amounts to Money...
SET @SessionPlayAmtAsMoney = CAST(@SessionPlayAmt AS MONEY) / 100
SET @TransAmtAsMoney       = CAST(@TransAmt AS MONEY) / 100

SET @ErrorID           = 0
SET @ErrorDescription  = ''
SET @ErrorSource       = 'tpInsertVoucher Stored Procedure'
SET @ErrorText         = ''
SET @EventCode         = 'SP'
SET @GameTitleID       = 0
SET @LocationID        = 0
SET @LockupMachine     = 0
SET @MachNbrAsInt      = CAST(@MachineNumber AS Int)
SET @TimeStamp         = GetDate()
SET @TransID           = 29
SET @VoucherID         = 0

-- Retrieve the Location ID from CASINO.
SELECT @LocationID = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Retrieve the Debug mode for this stored procedure...
IF EXISTS(SELECT * FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpInsertVoucher')
   SELECT @Debug = DEBUG_MODE FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpInsertVoucher'
ELSE
   SET @Debug = 0

-- Retrieve GameTitleID.
SELECT @GameTitleID = gs.GAME_TITLE_ID
FROM dbo.MACH_SETUP ms
   JOIN dbo.GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE ms.MACH_NO = @MachineNumber

-- Is Debug turned on for this procedure?
IF (@Debug = 1)
   -- Yes so record argument values.
   BEGIN
      SET @MsgText =
         'tpInsertVoucher Argument Values:    Barcode: '      + @Barcode +
         '  TimeStamp: '      + CAST(@TimeStamp AS VarChar)   +
         '  TransAmt: '       + CAST(@TransAmt AS VarChar)    +
         '  MachineNumber: '  + @MachineNumber                +
         '  VoucherType: '    + CAST(@VoucherType AS VarChar) +
         '  SessionPlayAmt: ' + CAST(@TransAmt AS VarChar)
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
      
      SET @MsgText = 'tpInsertVoucher Calculated values:  TransAmtAsMoney: ' +
                     CAST(@TransAmtAsMoney AS VarChar) +
                     '  SessionPlayAmtAsMoney: ' +
                     CAST(@SessionPlayAmtAsMoney AS VarChar)
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Check to see if the Barcode value to be inserted already exists in the VOUCHER table.
IF EXISTS(SELECT * FROM VOUCHER WHERE BARCODE = @BarCode)
   SET @ErrorID = 701

IF (@ErrorID = 0)
   BEGIN      -- Insert a row into the VOUCHER table, Note that the BARCODE column is indexed.
      INSERT INTO VOUCHER
         (LOCATION_ID, BARCODE, CREATE_DATE, CREATED_LOC, VOUCHER_TYPE,
          VOUCHER_AMOUNT, SESSION_PLAY_AMOUNT, CHECK_VALUE, GAME_TITLE_ID)
      VALUES
         (@LocationID, @BarCode, @TimeStamp, @MachineNumber, @VoucherType,
          @TransAmtAsMoney, @SessionPlayAmtAsMoney, @Checksum, @GameTitleID)
   END

-- Get the Error from the INSERT
IF (@@ERROR = 0)
   SET @VoucherID = SCOPE_IDENTITY()
ELSE
   BEGIN
      SET @ErrorID = 702 
      SET @VoucherID = 0
   END

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
      
      -- Test if the Machine should be locked up.
      IF (@LockupMachine <> 0)
         BEGIN
            UPDATE MACH_SETUP SET ACTIVE_FLAG = 0 WHERE MACH_NO = @MachineNumber AND ACTIVE_FLAG = 1
            SET @EventCode = 'SD'
         END
       
      -- Build Error Message
      SET @EventLogDesc = 'Description:' + @ErrorDescription +
                          ', ErrorID:' + CAST(@ErrorID As VarChar) +
                          ', LockupMachine:' + CAST(@LockupMachine As VarChar) +
                          ', Machine Number:' + @MachineNumber
      
      -- Insert Error into the Casino_Event_Log
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)
   END

-- Is Debug turned on for this procedure?
IF (@Debug = 1)
   -- Yes, so write return values to the DEBUG_INFO table...
   BEGIN
      SET @MsgText = 'tpInsertVoucher Return values ErrorID:  ' + CAST(@ErrorID As VarChar) +
         '  ErrorDescription: ' + @ErrorDescription +
         '  LockupMachine: ' + CAST(@LockupMachine As VarChar ) +
         '  VoucherID: ' + CAST(@VoucherID As VarChar )
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to caller.
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @VoucherID        AS VoucherID
GO
