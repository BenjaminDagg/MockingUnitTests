SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function GetVoucherStatus

Created 04-25-2014 by Louis Epstein

Purpose: Returns voucher information for given VoucherID

Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 04-25-2014     v3.2.1
  Initial Coding

--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetVoucherStatus]
@VoucherBarcode nvarchar(18)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

    SELECT DISTINCT 
      [VOUCHER_ID]
      ,[LOCATION_ID]
      ,[VOUCHER_TYPE]
      ,[BARCODE]
      ,[VOUCHER_AMOUNT]
      ,[CREATE_DATE]
      ,[CREATED_LOC]
      ,[REDEEMED_LOC]
      ,[REDEEMED_STATE]
      ,[REDEEMED_DATE]
      ,[CHECK_VALUE]
      ,[CT_TRANS_NO_VC]
      ,[CT_TRANS_NO_VR]
      ,[CT_TRANS_NO_JP]
      ,[IS_VALID]
      ,[SESSION_PLAY_AMOUNT]
      ,[UCV_TRANSFERRED]
      ,[UCV_TRANSFER_DATE]
      ,[GAME_TITLE_ID]
      ,[PROMO_VOUCHER_SESSION_ID]
  FROM [VOUCHER]
  WHERE BARCODE = @VoucherBarcode
  
END
GO
