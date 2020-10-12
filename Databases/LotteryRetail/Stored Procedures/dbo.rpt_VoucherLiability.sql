SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_VoucherLiability user stored procedure.

  Created: 12-16-2010 by Terry Watkins

  Purpose: Returns unpaid voucher data for the Voucher Liability report

Arguments: @StartDate:  Starting DateTime for the resultset
           @EndDate:    Ending DateTime for the resultset


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-16-2010     DCL v1.0.0
  Original coding
Edris Khestoo 6-18-2012      3.0.6
  Changed voucher to display only the last 4 digits.

Edris Khestoo 9-3-2013       3.1.4
  Added Parameter that cotnrols if the last 4 digits or the full validation number are displayed. 
  
Louis Epstein 1-15-2014       3.1.7
  Added Parameter that cotnrols if the last 4 digits or the full validation number are displayed.

Edris Khestoo 4-8-2014   3.2.1
  The number of digits shown when barcode is hidden is now configurable, (Value 3 of 'REPORT_SECURITY_OPTIONS')
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_VoucherLiability] @StartDate DateTime, @EndDate DateTime, @HideVoucherNumber BIT = 1
AS


DECLARE @VisibleVoucherBarcodeCharacters INT 
SET @VisibleVoucherBarcodeCharacters = (SELECT CAST(VALUE3 as INT) FROM CASINO_SYSTEM_PARAMETERS where PAR_NAME = 'REPORT_SECURITY_OPTIONS')



SELECT
   v.VOUCHER_ID                                 AS VoucherID,
   v.LOCATION_ID                                AS LocationID,
   vt.LONG_NAME                                 AS VoucherType,
   CASE WHEN @HideVoucherNumber = 0 THEN v.BARCODE
ELSE   '**************' + RIGHT(v.BARCODE, @VisibleVoucherBarcodeCharacters)
   END AS ValidationID,
   v.VOUCHER_AMOUNT                             AS VoucherAmount,
   v.CREATE_DATE                                AS CreatedDateTime,
   v.CREATED_LOC                                AS CreatedLoc,
   v.CT_TRANS_NO_VC                             AS CasinoTransNo
FROM VOUCHER v
   JOIN dbo.VOUCHER_TYPE vt ON v.VOUCHER_TYPE = vt.VOUCHER_TYPE_ID
WHERE
   (v.CREATE_DATE BETWEEN @StartDate AND @EndDate) AND
   (v.REDEEMED_STATE = 0) AND
   (v.VOUCHER_TYPE <> 1)  AND
   (v.VOUCHER_TYPE <> 4)  AND
   (v.IS_VALID = 1)
ORDER BY v.VOUCHER_ID
GO
