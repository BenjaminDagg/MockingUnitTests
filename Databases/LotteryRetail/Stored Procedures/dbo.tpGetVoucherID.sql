SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpGetVoucherID

Created 03-12-2009 by Terry Watkins

Desc: Returns the VoucherID for the specified Barcode.

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

CREATE PROCEDURE [dbo].[tpGetVoucherID] @Barcode VarChar(18)
AS

SET NOCOUNT ON

-- Variable Declarations
DECLARE @ReturnValue   Int

-- Variable Initialization
SET @ReturnValue = 0

SELECT @ReturnValue = VOUCHER_ID FROM VOUCHER WHERE BARCODE = @Barcode

-- Return the return code and descriptive text as a result set.
SELECT @ReturnValue AS VoucherID
GO
