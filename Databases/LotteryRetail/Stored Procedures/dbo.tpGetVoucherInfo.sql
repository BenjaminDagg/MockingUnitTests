SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure [tpGetVoucherInfo]

Created 11-15-2011 by Terry Watkins

Desc: Returns the VoucherID, VoucherType, and Voucher in cents for the
      specified ValidationID (aka Barcode).

Called by: TPIClient.vb\HandleVoucherVoucherRedeemed

Parameters:
   @Barcode    Validation ID of the voucher

Returns:
   Voucher ID (Int) if found or -1 if no row found
   Voucher Type (SmallInt) if found or -1 if no row found
   Amount of the Voucher in cents or -1 if no row found

Change Log:

Changed By    Date          Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-15-2011    7.2.5
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetVoucherInfo] @Barcode VarChar(18)
AS

SET NOCOUNT ON

-- Variable Declarations
DECLARE @VoucherID     Int
DECLARE @VoucherType   SmallInt
DECLARE @VoucherAmount Int

-- Attempt to retrieve the Voucher Type.
SELECT
   @VoucherID   = VOUCHER_ID,
   @VoucherType = VOUCHER_TYPE,
   @VoucherAmount = CAST(VOUCHER_AMOUNT * 100 AS INT)
FROM VOUCHER
WHERE BARCODE = @Barcode

-- If no rows returned, reset the return value to -1
IF (@@ROWCOUNT = 0)
   BEGIN
      SET @VoucherID     = -1
      SET @VoucherType   = -1
      SET @VoucherAmount = -1
   END

-- Return the return code and descriptive text as a result set.
SELECT
   @VoucherID     AS VoucherID,
   @VoucherType   AS VoucherType,
   @VoucherAmount AS VoucherCents
GO
