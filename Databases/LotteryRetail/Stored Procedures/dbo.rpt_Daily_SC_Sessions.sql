SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Daily_SC_Sessions user stored procedure.

Created:   undocumented

Purpose:   Returns data for the Daily Detail Activity Report By Cashier
           (Accounting System 'Daily Cashiers Report' menu item).

Arguments: @AcctDate: Accounting Date for the resultset

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-09-2004     v4.0.0
  Modified WHERE clause to filter out Card Read ('CR') entries.

Terry Watkins 07-21-2005     v4.1.7
  Modified to select both Card Account and Voucher payouts.
  
Edris Khestoo 6-18-2012      3.0.6
  Changed voucher to display only the last 4 digits.
  
Louis Epstein 9-25-2013      3.1.5
  Added receipt number for multi voucher functionality in report.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Daily_SC_Sessions] @StartDate DateTime, @EndDate DateTime
AS

-- Retrieve Card Account Payouts
SELECT
   csht.CREATED_BY,
   csht.SESSION_ID,
   csht.TRANS_NO,
   csht.CREATE_DATE,
   ct.CARD_ACCT_NO,
   csht.CASHIER_STN,
   ct.TRANS_AMT,
   CAST(0 AS Bit) AS IS_VOUCHER_PAYOUT,
   csht.PAYMENT_TYPE,
   NULL AS ReceiptNo
FROM CASHIER_TRANS csht
   JOIN CASINO_TRANS ct ON csht.TRANS_NO = ct.TRANS_NO
WHERE
   (csht.CREATE_DATE BETWEEN @StartDate AND @EndDate) AND
   (csht.TRANS_TYPE <> 'CR') AND
   (csht.VOUCHER_ID = 0)
UNION
-- Add Voucher payouts
SELECT
   csht.CREATED_BY,
   csht.SESSION_ID,
   csht.TRANS_NO,
   csht.CREATE_DATE,
   '**************' + RIGHT(v.BARCODE, 4) AS CARD_ACCT_NO,
   csht.CASHIER_STN,
   csht.TRANS_AMT,
   CAST(1 AS Bit) AS IS_VOUCHER_PAYOUT,
   csht.PAYMENT_TYPE,
   VRD.VOUCHER_RECEIPT_NO AS ReceiptNo
FROM CASHIER_TRANS csht
   JOIN VOUCHER v ON csht.VOUCHER_ID = v.VOUCHER_ID
   JOIN VOUCHER_RECEIPT_DETAILS VRD ON VRD.VOUCHER_ID = v.VOUCHER_ID
WHERE
   (csht.CREATE_DATE BETWEEN @StartDate AND @EndDate) AND
   (csht.TRANS_TYPE <> 'CR') AND
   (csht.VOUCHER_ID > 0)
ORDER BY csht.CREATED_BY, csht.CREATE_DATE
GO
