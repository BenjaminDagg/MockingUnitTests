SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
Procedure: rpt_Voucher_Details user stored procedure.

  Created: 08/22/2005 by Miguel Zavala

  Purpose: Retrieve voucher details and display them on cr_Voucher_Details_report.

Arguments: @BarCode   Identifies the Voucher being reported upon.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Edris Khestoo 09-19-2012     3.0.7
  Initial coding. Based on [rpt_Voucher_Details] v3.0.3
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Voucher_Details_Multiple] @BarCodes VarChar(MAX)
AS


-- Suppress unwanted statistics
SET NOCOUNT ON


-- Get Voucher/Cashiers Tran info
DECLARE @SQL VARCHAR(MAX) 

SET @SQL = 
'-- Variable Initialization.
DECLARE @CurrentDate      DateTime
DECLARE @ExpirationDays	  Integer
SET @CurrentDate   = GetDate()

-- Get the number of days to expiration...
SELECT @ExpirationDays = CAST(ITEM_VALUE AS Integer) FROM TPI_SETTING WHERE TPI_ID = 0 AND ITEM_KEY = ''ExpirationDays''

SELECT  v.VOUCHER_ID AS VoucherID
       ,V.BARCODE AS Barcode
       ,v.CREATE_DATE DateCreated
       ,ISNULL(ms.CASINO_MACH_NO, v.CREATED_LOC) + '' ('' + v.CREATED_LOC + '')'' AS CreateLocation      
       ,v.VOUCHER_AMOUNT VoucherAmount
       , CASE WHEN (v.REDEEMED_STATE = 0) AND (@CurrentDate <= (v.CREATE_DATE + @ExpirationDays)) AND (v.IS_VALID = 1) THEN ''Voucher is valid.''
              WHEN (v.REDEEMED_STATE = 0) AND (@CurrentDate > (v.CREATE_DATE + @ExpirationDays)) THEN ''Voucher expired on '' +  CAST((v.CREATE_DATE + @ExpirationDays) AS VARCHAR) + ''.  The number of expiration days is '' + CAST(@ExpirationDays AS VARCHAR) + ''.''
              WHEN (v.REDEEMED_STATE = 1 AND  ISNULL(ct.CASHIER_STN, ''Machine'') = ''Machine'') THEN ''Voucher redeemed on '' +  CAST(v.REDEEMED_DATE AS VARCHAR) + ''.  At Machine number: '' + (SELECT CASINO_MACH_NO FROM MACH_SETUP WHERE MACH_NO = v.REDEEMED_LOC) + ''.''
              WHEN (v.REDEEMED_STATE = 1 AND  ISNULL(ct.CASHIER_STN, ''Machine'') <> ''Machine'') THEN ''Voucher redeemed on '' +  CAST(v.REDEEMED_DATE AS VARCHAR) + '' at POS '' + ct.CASHIER_STN  + ''. Voucher Paid By '' + ct.CREATED_BY + ''.''
         END AS VoucherState
FROM VOUCHER v
   LEFT OUTER JOIN MACH_SETUP ms ON v.CREATED_LOC = ms.MACH_NO
   LEFT OUTER JOIN CASHIER_TRANS ct ON v.VOUCHER_ID = ct.VOUCHER_ID AND ct.TRANS_TYPE = ''P''
WHERE BARCODE IN (' + @BarCodes + ')'

EXEC (@SQL)
GO
