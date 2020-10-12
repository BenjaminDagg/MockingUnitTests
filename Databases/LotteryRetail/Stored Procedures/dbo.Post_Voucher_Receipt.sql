SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
Procedure: Post_Voucher_Receipt user stored procedure.

  Created: 09/20/2012 by Edris Khestoo

  Purpose: Properly updates tables when a customer receives payment of voucher balance.

Arguments: @VoucherCount  Number of Vouchers       
           @TransTotalAmount  Amount paid out in pennies
          
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Edris Khestoo 09-24-2012     3.0.7
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Post_Voucher_Receipt]
   @VoucherCount        Int,   
   @TransTotalAmount    MONEY 
AS

-- Variable Declarations...
DECLARE @Debug            Bit
DECLARE @MsgText          VarChar(2048)

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'Post_Voucher_Receipt'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'Post_Voucher_Receipt Arguments - VoucherCount: ' +
         ISNULL(CAST(@VoucherCount AS VarChar), '<null>') +       
         '  TransTotalAmount: ' + ISNULL(CAST(@TransTotalAmount AS VarChar), '<null>')
              
      EXEC InsertDebugInfo 0, @MsgText, 0
   END

   INSERT INTO [dbo].[VOUCHER_RECEIPT] ([VOUCHER_COUNT],[RECEIPT_TOTAL_AMOUNT])
   OUTPUT INSERTED.VOUCHER_RECEIPT_NO
   VALUES (@VoucherCount, @TransTotalAmount)
   
     
GO
