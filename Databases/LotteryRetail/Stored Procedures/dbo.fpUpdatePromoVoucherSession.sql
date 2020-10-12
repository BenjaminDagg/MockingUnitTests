SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: fpUpdatePromoVoucherSession

 Created By:    Aldo Zamora

Create Date:    11-17-2011

Description:    Update the row with the number of vouchers that
                were successfully printed in the session.

  Called By:    Free Play Application

    Returns:
       Return Value 
          0 = Successful update.
         -1 = Row doesn't exist.
          n = TSQL Error code.

 Parameters:    @VouchersPrinted   Number of vouchers successfully printed.
                @PromoVoucherSessionID  PromoVoucher
                
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   11-17-2011     v7.2.5
  Initial coding
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[fpUpdatePromoVoucherSession]
   @VouchersPrinted Int,
   @PromoVoucherSessionID Int
  
AS

-- Variable Declaration
DECLARE @ErrorID Int

-- Variable Initialization
SET @ErrorID = 0

-- Check to see if the row exists.
IF EXISTS(SELECT * FROM PROMO_VOUCHER_SESSION
          WHERE PROMO_VOUCHER_SESSION_ID = @PromoVoucherSessionID)
   BEGIN
      -- Insert the row.
      UPDATE PROMO_VOUCHER_SESSION
      SET VOUCHERS_PRINTED = @VouchersPrinted
      WHERE PROMO_VOUCHER_SESSION_ID = @PromoVoucherSessionID
      
      -- Save the @@ERROR value
      SELECT @ErrorID = @@ERROR
   END
ELSE
   BEGIN
      SET @ErrorID = -1
   END

-- Set the Return value.
RETURN @ErrorID
GO
