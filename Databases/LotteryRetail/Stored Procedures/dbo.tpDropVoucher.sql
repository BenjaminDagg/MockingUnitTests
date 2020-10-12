SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpDropVoucher

Created 03-10-2009 by Terry Watkins

Desc: Deletes the specified row from the Voucher table.

Called by: TPIClient.vb\HandleVoucherPrintFailed

Parameters:
   @VoucherID     Row identifer

Returns:
    0 = Successfully deleted.
   -1 = Delete failed, see ResultText

Change Log:

Changed By    Date          Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-10-2009    6.0.4
  Initial coding.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[tpDropVoucher] @VoucherID Int
AS

SET NOCOUNT ON

-- Variable Declarations
DECLARE @RedeemedState Bit
DECLARE @ReturnCode    Int
DECLARE @ResultText    VarChar(64)

-- Variable Initialization
SET @ResultText = ''

IF EXISTS(SELECT * FROM VOUCHER WHERE VOUCHER_ID = @VoucherID)
   BEGIN
      SELECT @RedeemedState = REDEEMED_STATE FROM VOUCHER WHERE VOUCHER_ID = @VoucherID
      IF (@RedeemedState = 0)
         -- Voucher has not been redeemed so delete it.
         BEGIN
            -- Drop the row
            DELETE FROM VOUCHER WHERE VOUCHER_ID = @VoucherID
            IF (@@ERROR = 0)
               -- Success.
               BEGIN
                  SET @ReturnCode = 0
                  SET @ResultText = 'Voucher successfully deleted.'
               END
            ELSE
               -- Delete Error
               BEGIN
                  SET @ReturnCode = -1
                  SET @ResultText = 'Voucher deletion failed.'
               END
         END
      ELSE
         -- Voucher has already been redeemed so it should not be deleted.
         BEGIN
            SET @ReturnCode = -1
            SET @ResultText = 'Voucher has already been redeemed.'
         END
   END
ELSE
   -- Voucher row not found.
   BEGIN
      SET @ReturnCode = -1
      SET @ResultText = 'Voucher does not exist.'
   END

-- Return the return code and descriptive text as a result set.
SELECT @ReturnCode AS ReturnCode, @ResultText AS ResultText
GO
