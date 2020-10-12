SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Daily_Cashier_Trans user stored procedure.

  Created: 05/21/2002 by Terry Watkins

  Purpose: Returns Cashier Transaction data for reporting

Arguments: @StartDate:  Starting DateTime for the resultset
           @EndDate:    Ending DateTime for the resultset


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 05-21-2002
  Original coding

Terry Watkins 05-03-2005
  Joined in the VOUCHER table so we can show Voucher Numbers
  
Edris Khestoo 6-18-2012      3.0.6
  Changed voucher to display only the last 4 digits.

Edris Khestoo 9-3-2013       3.1.4
  Added Parameter that cotnrols if the last 4 digits or the full validation number are displayed. 

Edris Khestoo 4-8-2014   3.2.1
  The number of digits shown when barcode is hidden is now configurable, (Value 3 of 'REPORT_SECURITY_OPTIONS')
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[rpt_Daily_Cashier_Trans] @StartDate DateTime, @EndDate DateTime,  @HideVoucherNumber BIT = 1
AS

DECLARE @VisibleVoucherBarcodeCharacters INT 
SET @VisibleVoucherBarcodeCharacters = (SELECT CAST(VALUE3 as INT) FROM CASINO_SYSTEM_PARAMETERS where PAR_NAME = 'REPORT_SECURITY_OPTIONS')



SELECT
   csht.SESSION_ID,
   csht.CREATED_BY,
   csht.TRANS_TYPE,
   csht.TRANS_AMT,
   csht.CASHIER_TRANS_ID,
   csht.CREATE_DATE,
   CASE WHEN  csht.VOUCHER_ID = 0 THEN ct.CARD_ACCT_NO
WHEN  csht.VOUCHER_ID <> 0 AND @HideVoucherNumber = 0 THEN v.BARCODE
ELSE  '**************' + RIGHT(v.BARCODE, @VisibleVoucherBarcodeCharacters)
END  CARD_ACCT_NO,
   csht.CASHIER_STN,
   csht.PAYMENT_TYPE,
   '(' + RTRIM(cu.FNAME + ' ' + cu.LNAME) + ')' AS UName,
   cu.LEVEL_CODE
FROM CASHIER_TRANS csht
   LEFT OUTER JOIN CASINO_TRANS ct ON csht.TRANS_NO = ct.TRANS_NO
   LEFT OUTER JOIN CASINO_USERS cu ON csht.CREATED_BY = cu.ACCOUNTID
   LEFT OUTER JOIN VOUCHER       v ON csht.VOUCHER_ID = v.VOUCHER_ID
WHERE csht.CREATE_DATE BETWEEN @StartDate AND @EndDate
ORDER BY csht.CREATED_BY, csht.CREATE_DATE
GO
