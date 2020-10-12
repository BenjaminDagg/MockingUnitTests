SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpRedeemBarCode

Created 01-06-2004 by A. Murthy

Desc: Handles getting AMOUNT
      or Sets REDEEMED_STATE, REDEEMED_LOC for a given Voucher.

Return values: ErrorCode, ErrorDescription, ShutdownFlag,
               VoucherValue, VoucherID, SessionPlayAmount

Called by: TPIClient.vb\HandleVoucherRedeem, HandleVoucherPrinted

Parameters:
   @Barcode             Barcode of the Ticket
   @TimeStamp           DateTime value sent from the Machine
   @MachineNumber       The Machine Number where play occurred

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Ashok Murthy  01-10-2005     v4.0.1
  Initial coding.

Ashok Murthy  01-10-2005     v4.1.0
  No longer generate an error if the voucher amount > lockup amount.
  Added VoucherID to the returned dataset.

Ashok Murthy  12-27-2005     v5.0.1
  Removed check to see if Barcode contains Casino_ID since Barcode is now
  totally random.
  Removed update for REDEEMED_STATE, REDEEM_LOC as this will be done in
  tpValidateChecksum.
  Changed @Barcode to VarChar to support 12 char. Iowa Barcodes.

  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
  to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

A. Murthy     05-25-2006     v5.0.4
  For Thunderbird Casino only, the Voucher can be redeemed only if the
  Create_Date = Accounting_Date

A. Murthy     02-08-2007     v5.0.8
  Add Check for IS_VALID = 0 to test if user is trying to redeem illegaly
  printed voucher.

Terry Watkins 02-13-2009     v6.0.4
  Added support for returning VOUCHER.SESSION_PLAY_AMOUNT.

Terry Watkins 11-03-2009     v7.0.0
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AcctDate changed from VarChar(16) to DateTime.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.

Terry Watkins 07-08-2011     v2.0.3
  Added a check so that transferred vouchers are not redeemable.


Terry Watkins 07-12-2011     v2.0.4
  Added assignment of error 745 for transferred (10 day unpaid) vouchers.
  
Louis Epstein 12-24-2013     v3.1.7
  Added promo voucher functionality
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpRedeemBarCode]
   @BarCode             VarChar(18),
   @TimeStamp           DateTime,
   @MachineNumber       Char(5)
AS

-- Variable Declarations
DECLARE @AccountingDate       DateTime
DECLARE @AlreadyRedeemed      Bit
DECLARE @CasID                Char(6)
DECLARE @CreateDate           DateTime
DECLARE @CreateDateFormatted  DateTime
DECLARE @Debug                Bit
DECLARE @DuplicateBarCode     Int
DECLARE @ErrorID              Int
DECLARE @ErrorNum             Int
DECLARE @ErrorSource          VarChar(64)
DECLARE @ErrorText            VarChar(1024)
DECLARE @ErrorDescription     VarChar(256)
DECLARE @EventCode            VarChar(2)
DECLARE @ExpiredDate          DateTime
DECLARE @EventLogDesc         VarChar(1024)
DECLARE @InAnotherMachine     Varchar(5)
DECLARE @IntValue             Int
DECLARE @IsActive             TinyInt
DECLARE @IsTransferred        Bit
DECLARE @IsValid              Bit
DECLARE @LockupAmt            SmallMoney
DECLARE @LockupMachine        Int
DECLARE @MachNbrAsInt         Int
DECLARE @MsgText              VarChar(2048)
DECLARE @PVSessionID          Int
DECLARE @RowCount             Int
DECLARE @SessionAmountInt     Int
DECLARE @SessionAmountMoney   Money
DECLARE @SqlError             Int
DECLARE @TransID              SmallInt
DECLARE @VoucherAmountInt     Int
DECLARE @VoucherAmountMoney   Money
DECLARE @VoucherExpireDays    Int
DECLARE @VoucherID            Int
DECLARE @VoucherType          SmallInt

SET NOCOUNT ON

-- Variable Initialization

SET @AlreadyRedeemed      = 0
SET @CreateDate           = GetDate()
SET @DuplicateBarCode     = 0
SET @ErrorID              = 0
SET @ErrorDescription     = ''
SET @ErrorSource          = 'tpRedeemBarCode Stored Procedure'
SET @ErrorText            = ''
SET @EventCode            = 'SP'
SET @ExpiredDate          = GetDate()
SET @EventLogDesc         = ''
SET @InAnotherMachine     = ''
SET @IntValue             = 0
SET @IsActive             = 0
SET @IsTransferred        = 0
SET @LockupAmt            = 0
SET @LockupMachine        = 0
SET @MachNbrAsInt         = CAST(@MachineNumber AS Int)
SET @PVSessionID          = 0
SET @RowCount             = 0
SET @SessionAmountInt     = 0
SET @SessionAmountMoney   = 0
SET @SqlError             = 0
SET @TimeStamp            = GetDate()
SET @TransID              = 29
SET @VoucherAmountInt     = 0
SET @VoucherAmountMoney   = 0
SET @VoucherExpireDays    = 0
SET @VoucherID            = 0
SET @VoucherType          = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpRedeemBarCode'

-- If Debug mode, save argument values...
IF (@Debug = 1)
   -- Record argument values.
   BEGIN
      SET @MsgText =
         'tpRedeemBarCode Argument Values:  ' + 
         '  Barcode: ' + @Barcode +
         '  TimeStamp: ' + CAST(@TimeStamp AS VarChar) +
         '  MachineNumber: ' + @MachineNumber
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve @CasId from the CASINO table.
SELECT @CasID = CAS_ID FROM CASINO WHERE SETASDEFAULT = 1

-- Get the AccountingDate
SET @AccountingDate = dbo.ufnGetAcctDate()

-- Check to see if the BarCode exists in VOUCHER table...
-- Also get REDEEMED_STATE, REDEEMED_LOC, CREATE_DATE, VOUCHER_AMOUNT, IS_VALID
SELECT
   @VoucherID          = ISNULL(VOUCHER_ID, 0),
   @AlreadyRedeemed    = REDEEMED_STATE,
   @InAnotherMachine   = REDEEMED_LOC,
   @CreateDate         = CREATE_DATE,
   @VoucherAmountMoney = VOUCHER_AMOUNT,
   @SessionAmountMoney = SESSION_PLAY_AMOUNT,
   @IsValid            = IS_VALID,   @IsTransferred      = UCV_TRANSFERRED,
   @VoucherType         = VOUCHER_TYPE,
   @PVSessionID         = PROMO_VOUCHER_SESSION_ID
FROM VOUCHER WHERE BARCODE = @BarCode

-- Get the Error from the SELECT
IF (@@ERROR <> 0)
   SET @ErrorID = 704

IF (@VoucherID = 0)
   SET @ErrorID = 703

-- Check for Voucher already redeemed
IF (@ErrorID = 0)
   BEGIN
      IF (@AlreadyRedeemed = 1) SET @ErrorID = 706
   END

-- Check for Voucher transferred because it remained unpaid too long.
IF (@ErrorID = 0)
   BEGIN
      IF (@IsTransferred = 1) SET @ErrorID = 745
   END

-- Check for Voucher not legally printed (user is fooling with machine)
IF (@ErrorID = 0)
   BEGIN
      IF (@IsValid = 0) SET @ErrorID = 742
   END

-- Check for Voucher in Another Machine
IF (@ErrorID = 0)
   BEGIN
      IF (LEN(@InAnotherMachine) > 0) SET @ErrorID = 720
   END

-- Check for expired Voucher
IF (@ErrorID = 0)
   BEGIN
      IF (@VoucherType <> 4)
         -- For Non-Promo vouchers, get Expiration days from the TPI_SETTING table.
         BEGIN
            -- Get the "ExpirationDays" TPI_SETTING table for TPI_ID=0 (DGE)
            SELECT @VoucherExpireDays = CAST(ITEM_VALUE AS Int) FROM TPI_SETTING
            WHERE TPI_ID = 0 AND ITEM_KEY = 'ExpirationDays'

            SELECT @SqlError = @@ERROR, @RowCount = @@ROWCOUNT
         END
      ELSE
         -- For Promo vouchers, get Expiration days from the PROMO_VOUCHER_SESSION table.
         BEGIN
            SELECT @VoucherExpireDays = EXPIRATION_DAYS
            FROM PROMO_VOUCHER_SESSION
            WHERE PROMO_VOUCHER_SESSION_ID = @PVSessionID

            SELECT @SqlError = @@ERROR, @RowCount = @@ROWCOUNT
         END

      -- Get the Error from the SELECT
      IF (@SqlError <> 0)
         SET @ErrorID = 704
      ELSE IF (@RowCount = 0)
         SET @ErrorID = 744
      ELSE IF (@ErrorID = 0)
         BEGIN
            -- Set the ExpiredDate to "@VoucherExpireDays" day after "CREATE_DATE"
            SET @ExpiredDate = DATEADD(day, @VoucherExpireDays, @CreateDate)

            -- Now check if the BarCode has expired
            IF (@ExpiredDate < @TimeStamp)
               BEGIN
                  SET @ErrorID = 705
               END
         END
   END

-- Convert the VoucherValue (VOUCHER_AMOUNT) into pennies
IF (@ErrorID = 0)
   BEGIN
      SET @VoucherAmountInt = CAST(@VoucherAmountMoney * 100 AS Int)
      SET @SessionAmountInt = CAST(@SessionAmountMoney * 100 AS Int)
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
      
      SET @VoucherAmountInt = 0
      SET @VoucherID   = 0
      
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

 -- Make an entry in the DEBUG_INFO table
 IF (@Debug = 1)
    BEGIN
       SET @MsgText = 'tpRedeemBarCode Return values ErrorID:  ' + CAST(@ErrorID As VarChar) +
           '  ErrorDescription: ' + @ErrorDescription +
           '  LockupMachine: '    + CAST(@LockupMachine As VarChar) +
           '  VoucherID: '        + CAST(@VoucherID As VarChar) +
           '  VoucherAmountInt: ' + CAST(@VoucherAmountInt As VarChar) +
           '  SessionAmountInt: ' + CAST(@SessionAmountInt As VarChar) +
           '  VoucherType: '      + CAST(@VoucherType As VarChar)
      
       EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
    END
      
-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @VoucherAmountInt AS VoucherValue,
   @VoucherID        AS VoucherID,
   @SessionAmountInt AS SessionPlayAmount,
   @VoucherType      AS VoucherType
GO
