SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function IsValidVoucherCheckValue

Created 07-23-2008 by Terry Watkins

Purpose: Returns a boolean value indicating if a Voucher has a valid CHECK_VALUE.
         True means voucher has not been tampered with, False means either the
         Barcode, the Voucher Amount, or the REDEEMED_STATE was altered.

Returns: Bit value of 1 to indicate voucher is valid or 0 to indicate that the
         voucher has been tampered with.


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-23-2008     v6.0.2
  Initial Coding

Terry Watkins 12-03-2010     v7.2.4
  Corrected comments above.
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[IsValidVoucherCheckValue] (@VoucherID Int) RETURNS Bit
AS
BEGIN
   -- [Variable Declarations]
   DECLARE @ReturnValue    Bit
   DECLARE @RowCount       Bit
   
   -- [Variable Initialization]
   SET @ReturnValue = 0
   
   -- Does the specified voucher exist?
   IF EXISTS(SELECT * FROM VOUCHER WHERE VOUCHER_ID = @VoucherID)
      -- Yes so retrieve some data...
      BEGIN
         SELECT @RowCount = COUNT(*)
         FROM VOUCHER
         WHERE
            VOUCHER_ID = @VoucherID AND
            CHECK_VALUE = dbo.mfnGetVoucherCheckValue(BARCODE, CAST(VOUCHER_AMOUNT * 100 AS Int), REDEEMED_STATE)
         
         IF (@RowCount = 1)
            SET @ReturnValue = 1
      END
   
   -- Set the function return value.
   RETURN @ReturnValue
END
GO
