SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpUpdateVoucherTable

Created 01-10-2004 by A. Murthy

Desc: Updates REDEEMED_STATE, REDEEMED_LOC, IS_VALID record in the VOUCHER table.
      For VoucherRedeemed     REDEEMED_STATE = 1,
                              REDEEMED_LOC = MachineNumber,
                              CHECK_VALUE = @NewChecksum

      For VoucherNotRedeemed  Re-set REDEEMED_LOC = null IF
                              @MachineNumber = REDEMEED_LOC AND REDEEMED_STATE = 0              

      Update VOUCHER_TYPE for a give BarCode in "Voucher" Table
      For VoucherPrinted      VOUCHER_TYPE = 0, IS_VALID = 1
      For Jackpot             VOUCHER_TYPE = 1, IS_VALID = 1
      For HandPay             VOUCHER_TYPE = 2
      For JackpotHandPay      VOUCHER_TYPE = 3

Based upon @Flag = 'VR'  do update for VoucherRedeemed
                 = 'VNR' do update for VoucherNotRedeemed
                 = 'VP'  do update for VoucherPrinted
                 = 'JP'  do update for VoucherPrinted for Jackpot.
                 = 'HP'  do update for HandPay
                 = 'JHP' do update for HandPay for Jackpot.

Return values: ErrorCode, ErrorDescription, ShutdownFlag

Called by: TPIClient.vb\HandleVoucherRedeemed, HandleVoucherNotRedeemed

Parameters:
   @Barcode             Barcode of the Ticket
   @TimeStamp           DateTime value sent from the Machine
   @MachineNumber       The Machine Number where play occurred
   @Flag                'VR', 'VNR', 'VP', 'JP', 'HP', 'JHP'
   @Checksum            New checksum for VR.
                        Set to a default value of <NULL> because it is not
                        needed for @Flag = 'VNR', 'VP' & 'HP'.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Ashok Murthy  01-10-2005     v4.0.1
  Initial coding.

Ashok Murthy  01-10-2006     v5.0.1
  1) Added 5th input parm @Checksum to update VOUCHER.CHECK_VALUE for @Flag=VR.
     Changed @Barcode to VarChar to support 12 char. Iowa Barcodes.

  2) Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
     to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

Ashok Murthy  03-08-2006     v5.0.2
  1) Changed input parameter @Checksum from VarChar(16) to VarBinary(8) and
     set default value to NULL.
  2) Added new values ('JP', 'JHP') for @Flag input parm. Added new IF stmts below
     to set VOUCHER_TYPE to 0 for VP, 1 for JP, 2 for HP & 3 for JHP.

Terry Watkins 06-22-2006     v5.0.4
  Added ISNULL checking to prevent null DEBUG_INFO.DEBUG_TEXT column values.

Terry Watkins 02-07-2007     v5.0.8
  Fixed check to see if the voucher record exists (line 121).

A. Murthy     02-09-2007     v5.0.8
  - Set VOUCHER.IS_VALID to 1 For @Flag=VP/JP to indicate Voucher has just printed.
  - Leave VOUCHER.REDEEMED_DATE at NULL (column default) for @Flag=VP/JP/HP/JHP

Terry Watkins 03-20-2009     v6.0.4
  Removed return of checksum when in debug mode.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpUpdateVoucherTable]
   @BarCode             VarChar(18),
   @TimeStamp           DateTime,
   @MachineNumber       Char(5),
   @Flag                VarChar(3),
   @Checksum            VarBinary(8) = NULL
AS

-- Variable Declarations
DECLARE @Debug             Bit
DECLARE @ErrorID           Int
DECLARE @ErrorSource       VarChar(64)
DECLARE @ErrorDescription  VarChar(256)
DECLARE @EventCode         VarChar(2)
DECLARE @EventLogDesc      VarChar(1024)
DECLARE @LockupMachine     Int
DECLARE @MachNbrAsInt      Int
DECLARE @MsgText           VarChar(2048)
DECLARE @RedeemedLoc       VarChar(16)
DECLARE @RedeemedState     Bit
DECLARE @TransID           SmallInt
DECLARE @VoucherID         Int

SET NOCOUNT ON

-- Variable Initialization

SET @ErrorID           = 0
SET @ErrorDescription  = ''
SET @ErrorSource       = 'tpUpdateVoucherTable Stored Procedure'
SET @EventCode         = 'SP'
SET @LockupMachine     = 0
SET @MachNbrAsInt      = CAST(@MachineNumber AS Int)
SET @RedeemedLoc       = ''SET @RedeemedState     = 0
SET @TimeStamp         = GetDate()
SET @TransID           = 29
SET @VoucherID         = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpUpdateVoucherTable'

-- If Debug mode, save argument values...
IF (@Debug = 1)
   -- Record argument values.
   BEGIN
      SET @MsgText =
         'tpUpdateVoucherTable Argument Values:  Barcode: ' + ISNULL(@Barcode, '<null>') +
         '  TimeStamp: '     + CAST(@TimeStamp AS VarChar) +
         '  MachineNumber: ' + ISNULL(@MachineNumber, '<null>') +
         '  Flag: '          + ISNULL(@Flag, '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Check to see if the Voucher record to be updated exists in VOUCHER table...
IF EXISTS (SELECT * FROM VOUCHER WHERE BARCODE = @BarCode)
   BEGIN
      SELECT
         @VoucherID     = VOUCHER_ID,
         @RedeemedLoc   = REDEEMED_LOC,
         @RedeemedState = REDEEMED_STATE
      FROM VOUCHER
      WHERE BARCODE = @BarCode
   END
ELSE
   SET @ErrorID = 703

-- Now set REDEEMED_STATE = True, REDEEMED_LOC = @MachineNumber, and CHECK_VALUE = NewCheksum
-- for VoucherRedeemed i.e. @Flag = 'VR'
IF (@Flag = 'VR' AND @ErrorID = 0)
   BEGIN
      UPDATE VOUCHER SET
         REDEEMED_STATE = 1,
         REDEEMED_LOC   = @MachineNumber,
         REDEEMED_DATE  = GetDate(),
         CHECK_VALUE    = @Checksum
      WHERE VOUCHER_ID  = @VoucherID
      
      -- Get the Error from the UPDATE
      IF (@@ERROR <> 0)
         SET @ErrorID = 721
   END

-- Now set REDEEMED_LOC = '' for VoucherNotRedeemed i.e. @Flag = 'VNR'
IF (@Flag = 'VNR' AND @ErrorID = 0)
   BEGIN
      IF (@MachineNumber = @RedeemedLoc AND @RedeemedState = 0)
         BEGIN
            UPDATE VOUCHER SET REDEEMED_LOC = NULL
            WHERE VOUCHER_ID = @VoucherID
            -- Get the Error from the UPDATE
            IF (@@ERROR <> 0)
               SET @ErrorID = 722
         END
    END

-- Now set VOUCHER_TYPE = 1 for VoucherPrinted i.e. @Flag = 'VP'
IF (@Flag = 'VP' AND @ErrorID = 0)
   BEGIN
      UPDATE VOUCHER SET VOUCHER_TYPE = 0, IS_VALID = 1
      WHERE VOUCHER_ID = @VoucherID
      -- Get the Error from the UPDATE
      IF (@@ERROR <> 0)
         SET @ErrorID = 723
   END

-- Now set VOUCHER_TYPE = 1 for Jackpot i.e. @Flag = 'JP'
IF (@Flag = 'JP' AND @ErrorID = 0)
   BEGIN
      UPDATE VOUCHER SET VOUCHER_TYPE = 1, IS_VALID = 1
      WHERE VOUCHER_ID = @VoucherID
      -- Get the Error from the UPDATE
      IF (@@ERROR <> 0)
         SET @ErrorID = 725
   END

-- Now set VOUCHER_TYPE = 2 for HandPay i.e. @Flag = 'HP'
IF (@Flag = 'HP' AND @ErrorID = 0)
   BEGIN
      UPDATE VOUCHER SET VOUCHER_TYPE = 2
      WHERE VOUCHER_ID = @VoucherID
      -- Get the Error from the UPDATE
      IF (@@ERROR <> 0)
         SET @ErrorID = 740
   END

-- Now set VOUCHER_TYPE = 3 for JackpotHandPay i.e. @Flag = 'JHP'
IF (@Flag = 'JHP' AND @ErrorID = 0)
   BEGIN
      UPDATE VOUCHER SET VOUCHER_TYPE = 3
      WHERE VOUCHER_ID = @VoucherID
      -- Get the Error from the UPDATE
      IF (@@ERROR <> 0)
         SET @ErrorID = 741
   END

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar)),
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
      SET @EventLogDesc = 'Description: '      + @ErrorDescription +
                          ', ErrorID: '        + CAST(@ErrorID As VarChar) +                          ', LockupMachine: '  + CAST(@LockupMachine As VarChar) +
                          ', Machine Number: ' + @MachineNumber
      
      -- Insert Error into the CASINO_EVENT_LOG
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)
   END

-- Make an entry in the DEBUG_INFO table if in debug mode...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
          'tpUpdateVoucherTable Return Values - ErrorID:  ' + CAST(@ErrorID As VarChar) +
          '  ErrorDescription: ' + @ErrorDescription +
          '  LockupMachine: '    + CAST(@LockupMachine As VarChar )
          EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag
GO
