SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Voucher_Details user stored procedure.

  Created: 08/22/2005 by Miguel Zavala

  Purpose: Retrieve voucher details and display them on cr_Voucher_Details_report.

Arguments: @BarCode   Identifies the Voucher being reported upon.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Miguel Zavala 08-22-2005     4.2.0
  Initial coding.

Terry Watkins 06-02-2009     6.0.7
  Modified Created Location to show CASINO_MACH_NO and MACH_NO.

Terry Watkins 11-08-2010     7.2.4
  Changed JOIN MACH_SETUP to LEFT OUTER JOIN MACH_SETUP and changed
    @CreateLoc = ms.CASINO_MACH_NO + ' (' + v.CREATED_LOC + ')',
    to
    @CreateLoc = ISNULL(ms.CASINO_MACH_NO, v.CREATED_LOC) + ' (' + v.CREATED_LOC + ')',
  in case the machine record is no longer available.
  
  Added code to set the VoucherStatus text that is returned to 'Voucher is valid.'
  'Voucher is valid.' if the voucher has not been redeemed, has not expired and
  if the IS_VALID column value is 1.

Terry Watkins 01-11-2012     v3.0.3
  Changed double quotes to single quotes on last line before the final select.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Voucher_Details] @BarCode VarChar(18)
AS

-- Variable Declarations...
DECLARE @VoucherID	      Integer
DECLARE @ExpirationDays	  Integer
DECLARE @RedeemedState 	  Integer	

DECLARE @IsValid          Bit

DECLARE @VoucherAmt	      Money

DECLARE @RedeemedDate     DateTime
DECLARE @CreateDate       DateTime
DECLARE @CurrentDate      DateTime

DECLARE @CreateLoc        VarChar(16)
DECLARE @RedeemedLoc      VarChar(16)
DECLARE @CasinoMachNo     VarChar(16)
DECLARE @VoucherStatus    VarChar(100)
DECLARE @CreatedBy        VarChar(30)
DECLARE @CashierSTN       VarChar(32)


-- Suppress unwanted statistics
SET NOCOUNT ON

-- Variable Initialization.
SET @CurrentDate   = GetDate()
SET @VoucherStatus = ''
SET @IsValid       = 0

-- Get the number of days to expiration...
SELECT @ExpirationDays = CAST(ITEM_VALUE AS Integer) FROM TPI_SETTING WHERE TPI_ID = 0 AND ITEM_KEY = 'ExpirationDays'

-- Get Voucher/Cashiers Tran info
SELECT
   @VoucherID     = v.VOUCHER_ID,
   @CreateDate    = v.CREATE_DATE,
   @CreateLoc     = ISNULL(ms.CASINO_MACH_NO, v.CREATED_LOC) + ' (' + v.CREATED_LOC + ')',
   @RedeemedDate  = v.REDEEMED_DATE,
   @RedeemedLoc   = v.REDEEMED_LOC,
   @VoucherAmt    = v.VOUCHER_AMOUNT,
   @RedeemedState = v.REDEEMED_STATE,
   @CreatedBY     = ct.CREATED_BY,
   @CashierSTN    = ISNULL(ct.CASHIER_STN, 'Machine'),
   @IsValid       = IS_VALID
FROM VOUCHER v
   LEFT OUTER JOIN MACH_SETUP ms ON v.CREATED_LOC = ms.MACH_NO
   LEFT OUTER JOIN CASHIER_TRANS ct ON v.VOUCHER_ID = ct.VOUCHER_ID AND ct.TRANS_TYPE = 'P'
WHERE BARCODE = @BarCode

IF (@RedeemedState = 0) AND (@CurrentDate <= (@CreateDate + @ExpirationDays)) AND (@IsValid = 1)
   -- Okay to Pay
   SET @VoucherStatus = 'Voucher is valid.'
ELSE IF ((@RedeemedState = 0) AND (@CurrentDate > (@CreateDate + @ExpirationDays)))
   -- Voucher Expired.
   SET @VoucherStatus = 'Voucher expired on ' +  CAST((@CreateDate + @ExpirationDays) AS VARCHAR) +
                        '.  The number of expiration days is ' + CAST(@ExpirationDays AS VARCHAR) + '.'
ELSE IF (@RedeemedState = 1 AND @CashierSTN = 'Machine')
   -- Ticket already redeemed at a Machine.
   BEGIN
      SELECT @CasinoMachNo = CASINO_MACH_NO FROM MACH_SETUP WHERE MACH_NO = @RedeemedLoc
      SET @VoucherStatus = 'Voucher redeemed on ' +  CAST(@RedeemedDate AS VARCHAR) +
                           '.  At Machine number: ' + @CasinoMachNo + '.'
   END
ELSE IF ((@RedeemedState = 1) AND (@CashierSTN <> 'Machine'))
   -- Ticket already redeemed at the Cashier.
   SET @VoucherStatus = 'Voucher redeemed on ' +  CAST(@RedeemedDate AS VARCHAR) +
                        ' at POS ' + @CashierSTN  + '. Voucher Paid By ' + @CreatedBY + '.'

SELECT
   @VoucherID     AS VoucherID,
   @Barcode       AS Barcode,
   @CreateDate    AS DateCreated,
   @CreateLoc     AS CreateLocation,
   @VoucherAmt    AS VoucherAmount,
   @VoucherStatus AS VoucherStatus
GO
