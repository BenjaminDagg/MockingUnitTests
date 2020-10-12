SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: fpInsertVoucher

Created By:     Aldo Zamora

Create Date:    11-16-2011

Desc: Inserts a new row into the VOUCHER table.

Returns:
   Return Value 
    0 = Succesful insert.
  701 = Row already exists.
    n = TSQL Error code.

Called by: FreePlay Application

Parameters:
   @ValidationID  Voucher Validation ID
   @VoucherAmount Transaction amount in cents
   @CreatedLoc    The Worstation used to create vouchers.
   @VoucherType   0=Ordinary Cashout, 1=Jackpot Cashout,
                  2=Hand Pay, 3=Jackpot Hand Pay,
                  4=Restricted Promo Voucher
   @Checksum      Encrypted value of selected voucher column values.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   11-16-2011     v4.0.1
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[fpInsertVoucher]
   @ValidationID          VarChar(18),
   @VoucherAmount         Int,
   @CreatedLoc            VarChar(16),
   @VoucherType           Int,
   @CheckSum              VarBinary(8),
   @SessionPlayAmt        Int = 0, 
   @PromoVoucherSessionID Int

AS

-- Variable Declarations
DECLARE @ErrorID               INT
DECLARE @LocationID            INT
DECLARE @SessionPlayAmtAsMoney MONEY
DECLARE @TimeStamp             DATETIME
DECLARE @VoucherAmountAsMoney  MONEY
DECLARE @VoucherID             INT

SET NOCOUNT ON

-- Variable Initialization
-- Convert Transaction and SessionPlay Amounts to Money...
SET @SessionPlayAmtAsMoney = CAST(@SessionPlayAmt AS MONEY) / 100
SET @VoucherAmountAsMoney  = CAST(@VoucherAmount AS MONEY) / 100

SET @ErrorID = 0
SET @TimeStamp = GETDATE()
SET @VoucherID = 0

SELECT @LocationID = LOCATION_ID FROM dbo.CASINO WHERE SETASDEFAULT = 1

-- Check to see if the ValidationID value to be inserted already exists in the VOUCHER table.
IF EXISTS(SELECT * FROM VOUCHER WHERE BARCODE = @ValidationID)
   SET @ErrorID = 701

IF (@ErrorID = 0)
   BEGIN
      -- Insert a row into the VOUCHER table, Note that the BARCODE column is indexed.
      INSERT INTO VOUCHER
         (LOCATION_ID, VOUCHER_TYPE, BARCODE,
          VOUCHER_AMOUNT, CREATE_DATE, CREATED_LOC,
          CHECK_VALUE, SESSION_PLAY_AMOUNT, PROMO_VOUCHER_SESSION_ID)
      VALUES
         (@LocationID, @VoucherType, @ValidationID,
          @VoucherAmountAsMoney, @TimeStamp, @CreatedLoc,
          @CheckSum, @SessionPlayAmtAsMoney, @PromoVoucherSessionID)
      
      -- Store the primary key value of the newly inserted row and the @@ERROR value.
      SELECT @ErrorID = @@ERROR, @VoucherID = SCOPE_IDENTITY()
      
   END

-- Set the return value.
SELECT @ErrorID AS ErrorID, @VoucherID AS VoucherID
GO
