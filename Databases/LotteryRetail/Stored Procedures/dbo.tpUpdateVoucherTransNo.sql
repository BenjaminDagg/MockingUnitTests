SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpUpdateVoucherTransNo

Created 05-02-2005 by Terry Watkins

Desc: Updates either the CT_TRANS_NO_VC or CT_TRANS_NO_VR column with the
      TRANS_NO value from the insert into CASINO_TRANS performed by either
      the tpTransVC or tpTransVR stored procedure.

Return values: None

Parameters:
   @VoucherID           Identifies the VOUCHER table row to update
   @CTTransNo           The value to put into the VOUCHER.CT_TRANS_NO_VC or
                        CT_TRANS_NO_VR column
   @TransType           'C'reated or 'R'edeemed

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 01-10-2005     v4.1.0
  Initial coding.

Terry Watkins 01-31-2007     v5.0.8
  Added update of VOUCHER.CT_TRANS_NO_JP column for voucher create.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[tpUpdateVoucherTransNo]
   @VoucherID  Int,
   @CTTransNo  Int,
   @JPTransNo  Int = 0,
   @TransType  Char(1)
AS

-- Variable Declarations

SET NOCOUNT ON

-- Perform the update.
IF (@TransType = 'C')
   UPDATE VOUCHER SET CT_TRANS_NO_VC = @CTTransNo, CT_TRANS_NO_JP = @JPTransNo WHERE VOUCHER_ID = @VoucherID

IF (@TransType = 'R')
   UPDATE VOUCHER SET CT_TRANS_NO_VR = @CTTransNo WHERE VOUCHER_ID = @VoucherID
GO
