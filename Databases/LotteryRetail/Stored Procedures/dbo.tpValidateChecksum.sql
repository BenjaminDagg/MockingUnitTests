SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpValidateChecksum

Created 12-27-2005 by A. Murthy

Desc: Checks the input @OldChecksum against the CHECK_VALUE col. for the @VoucherID in the VOUCHER table.

Return values: ErrorCode, ErrorDescription, ShutdownFlag

Called by: TPIClient.vb\HandleVoucherRedeem

Parameters:
   @VoucherID         VoucherID (PK) of the Ticket
   @OldChecksum       The original Checksum value when the Barcode was first created (tpInsertBarcode).
   @MachineNumber     The 5 char. Machine Number.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Ashok Murthy  12-27-2005     v5.0.1
  1) Initial coding.

  2) Modified update of MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
     to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

Ashok Murthy  03-08-2006     v5.0.2
  Changed @OldChecksum input parameter from VarChar(16) to VarBinary(8) per
  Chris C.

A. Murthy     02-09-2007     v5.0.8
  REMOVED setting VOUCHER.REDEEMED_STATE to 0 because it is column default.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.
  
Aldo Zamora   01-11-2011    v7.2.4
  Removed OldChecksum text from debug message. For better security.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpValidateChecksum]
   @VoucherID           Int,
   @OldChecksum         VarBinary(8),
   @MachineNumber       VarChar(5)
AS

-- Variable Declarations
DECLARE @CheckValue          VarBinary(8)
DECLARE @Debug               Bit
DECLARE @DuplicateBarCode    Int
DECLARE @ErrorID             Int
DECLARE @ErrorNum            Int
DECLARE @ErrorSource         VarChar(64)
DECLARE @ErrorText           VarChar(1024)
DECLARE @ErrorDescription    VarChar(256)
DECLARE @EventCode           VarChar(2)
DECLARE @ExpiredDate         DateTime
DECLARE @EventLogDesc        VarChar(1024)
DECLARE @InAnotherMachine    Varchar(5)
DECLARE @IntValue            Int
DECLARE @IsActive            TinyInt
DECLARE @LockupAmt           SmallMoney
DECLARE @LockupMachine       Int
DECLARE @MachNbrAsInt        Int
DECLARE @MsgText             VarChar(2048)
DECLARE @TransID             SmallInt
DECLARE @VoucherExpireDays   Int

SET NOCOUNT ON

-- Variable Initialization
SET @ErrorID           = 0
SET @ErrorDescription  = ''
SET @ErrorSource       = 'tpValidateChecksum Stored Procedure'
SET @ErrorText         = ''
SET @EventCode         = 'SP'
SET @ExpiredDate       = GetDate()
SET @InAnotherMachine  = ''
SET @IntValue          = 0
SET @IsActive          = 0
SET @LockupAmt         = 0
SET @LockupMachine     = 0
SET @MachNbrAsInt      = CAST(@MachineNumber AS Int)
SET @TransID           = 0
SET @VoucherExpireDays = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpValidateChecksum'

-- If Debug mode, save argument values...
IF (@Debug = 1)
   -- Record argument values.
   BEGIN
      SET @MsgText =
         'tpValidateChecksum Argument Values:  ' + 
         '  VoucherID: ' + CAST(@VoucherID AS VarChar) +
         '  MachineNumber: ' + @MachineNumber 
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Check if @VoucherID exists in VOUCHER table and obtain the CHECK_VALUE col.
SELECT @CheckValue = CHECK_VALUE FROM VOUCHER WHERE VOUCHER_ID = @VoucherID

-- Get the Error from the SELECT
IF (@@ROWCOUNT <> 1)
   SET @ErrorID = 735

-- Check to see if the CHECK_VALUE matches the input @OldChecksum
IF (@ErrorID = 0)
   BEGIN
      IF (@CheckValue <> @OldChecksum)
         SET @ErrorID = 736
   END

-- Now set REDEEMED_LOC = @MachineNumber
IF (@ErrorID = 0)
   BEGIN
      UPDATE VOUCHER SET REDEEMED_LOC = @MachineNumber WHERE VOUCHER_ID = @VoucherID
      
      -- Get the Error from the UPDATE
      IF (@@ERROR <> 0)
         SET @ErrorID = 716
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
      SET @EventLogDesc = 'Description:'      + @ErrorDescription +
                          ', ErrorID:'        + CAST(@ErrorID As VarChar) +
                          ', LockupMachine:'  + CAST(@LockupMachine As VarChar) +
                          ', Machine Number:' + @MachineNumber
      
      -- Insert Error into the Casino_Event_Log
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)  
    END

 -- Make an entry in the DEBUG_INFO table
 IF (@Debug = 1)
    BEGIN
       SET @MsgText = 'tpValidateChecksum Return values - ErrorID:  ' + CAST(@ErrorID As VarChar) +
          '  ErrorDescription: ' + @ErrorDescription +
          '  LockupMachine: ' + CAST(@LockupMachine As VarChar)
       EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
    END
      
-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag
GO
