SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function MarkVoucherPaid

Created 04-25-2014 by Louis Epstein

Purpose: Marks the given voucher as paid

Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 04-25-2014     v3.2.1
  Initial Coding

--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[MarkVoucherPaid]
@VoucherID int, @RedeemLocation varchar(32), @TransferToCentral bit
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

    UPDATE [VOUCHER]
   SET 
      [REDEEMED_LOC] = @RedeemLocation
      ,[REDEEMED_STATE] = 1
      ,[REDEEMED_DATE] = GETDATE()
      ,[CHECK_VALUE] = dbo.mfnGetVoucherCheckValue(BARCODE, CAST((VOUCHER_AMOUNT * 100) AS bigint), 1)
      ,[UCV_TRANSFERRED] = @TransferToCentral
      ,[UCV_TRANSFER_DATE] = CASE WHEN @TransferToCentral = 1 THEN GETDATE() ELSE NULL END
 WHERE VOUCHER_ID = @VoucherID

  
END
GO
