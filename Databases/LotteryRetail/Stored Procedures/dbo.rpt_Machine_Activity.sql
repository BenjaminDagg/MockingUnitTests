SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Machine_Activity user stored procedure.

  Created: 01/10/2002 by Miguel Zavala

  Purpose: Return data for the Machine Activity Report.

Arguments:
   @BeginDT    Reporting Start DateTime
   @EndDT      Reporting Ending DateTime
   @Mach_No    Casino Machine number to report on (CASINO_MACH_NO)
   @UseRange   = 0 for the last 24 hours of activity
               = 1 use Date Range arguments

Change Log:

Changed By    Change Date    Database Version
 Change Description
---------------------------------------------------------------------------------------
Norm Symonds  04-09-2002
  Added ORDER by ct.DTIMESTAMP included CARD_ACCT_NO values of 'INTERNAL' and
  'INVALID' to show drops, rolls, and other transactions that happen just to the
  machine.

Terry Watkins 06-04-2002
  Added join to MACH_SETUP table to retrieve the machine description
  (MACH_SETUP.MODEL_DESC) so it can be displayed on the machine activity report.

Terry Watkins 01-28-2003
  Pulls last machine time from new column LAST_ACTIVITY in the MACH_SETUP table.

Terry Watkins 09-12-2003
  Modified to retrieve Denom, CoinsBet, and LinesBet.
  Reworked the argument names and flag datatype.

Terry Watkins 02-09-2004
  Made CASINO_FORMS JOIN a LEFT OUTER join so we get Inserts and Extracts where the
  Deal is 0.

Terry Watkins 03-09-2004
  The Accounting app now calls this proc passing the CASINO_MACH_NO instead of
  the MACH_NO.  The Machine number returned is a concatenation of
  MACH_SETUP.CASINO_MACH_NO and MACH_SETUP.MODEL_DESC.

Terry Watkins 06-01-2004
  Modified to pull DENOM, COINS_BET, and LINES_BET FROM CASINO_TRANS instead of
  FROM DEAL_SETUP.

  TAB_AMT is now calculated instead of being pulled directly from DEAL_SETUP

  Changed ORDER BY clause to use CASINO_TRANS.TRANS_NO
  instead of DTIMESTAMP (should be a little faster).

Terry Watkins 10-26-2004
  Removed ct.TRANS_TYPE and added ct.TRANS_ID and trn.REPORT_TEXT

Terry Watkins 05-02-2005     v4.1.0
  Added retrieval of VOUCHER.BARCODE

Terry Watkins 09-06-2005     v4.2.0
  Modified Tab amount calculation to support Keno.

Terry Watkins 06-15-2006     v5.0.4
  Modified to pull REPORT_TEXT from CASINO_EVENT_LOG.EVENT_DESC if the TranID
  is 61 (X trans).

Edris Khestoo 9/3/2013      v3.1.4
Edris Khestoo 9-3-2013       3.1.4
  Added Parameter that cotnrols if the last 4 digits or the full validation number are displayed. 
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality.
  Added an hour to the 24 hours of activity to ensure balance adjustments are correctly displayed.
-------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Machine_Activity]
   @BeginDT    DateTime,
   @EndDT      DateTime,
   @Mach_No    VarChar(8),
   @UseRange   Bit,
   @HideVoucherNumber BIT = 1
AS

-- Variable Declarations
DECLARE @DTEnd   DateTime
DECLARE @DTStart DateTime

-- Set the starting and ending DateTimes based upon the @UseRange flag.
IF (@UseRange = 0)
   -- User wants only the last 24 hours of activity.
   BEGIN
      SELECT @DTEnd = ISNULL(LAST_ACTIVITY, GetDate()) FROM MACH_SETUP WHERE CASINO_MACH_NO = @Mach_No
      SET @DTStart =  @DTEnd - 1
      SET @DTEnd = DATEADD(HOUR,1,@DTEnd)
   END
ELSE
   -- User wants to use the specified range.
   BEGIN
      SET @DTStart = @BeginDT
      SET @DTEnd   = @EndDT
   END

-- Retrieve the data...
SELECT
   ct.TRANS_NO,
   ms.CASINO_MACH_NO + ' - ' + ms.MODEL_DESC AS MACH_NO,
   ct.TRANS_AMT,
   ct.BALANCE,
   ISNULL(ct.TRANS_ID, 0) AS TRANS_ID,
   CASE ct.TRANS_ID WHEN 61 THEN ISNULL(cel.EVENT_DESC, trn.REPORT_TEXT)
                            ELSE ISNULL(trn.REPORT_TEXT, '<undefined>') END AS REPORT_TEXT,
   ct.DTIMESTAMP,
   CASE 
WHEN ct.TRANS_ID = 22 AND @HideVoucherNumber = 1 THEN '**************' + RIGHT(v1.BARCODE, 4) 
WHEN ct.TRANS_ID = 22 AND @HideVoucherNumber = 0 THEN v1.BARCODE
WHEN ct.TRANS_ID = 21 AND @HideVoucherNumber = 1 THEN '**************' + RIGHT(v2.BARCODE, 4)
WHEN ct.TRANS_ID = 21 AND @HideVoucherNumber = 0 THEN v2.BARCODE
WHEN ct.TRANS_ID = 90 AND @HideVoucherNumber = 1 THEN '**************' + RIGHT(v2.BARCODE, 4)
WHEN ct.TRANS_ID = 90 AND @HideVoucherNumber = 0 THEN v1.BARCODE

ELSE ct.CARD_ACCT_NO  END AS CARD_ACCT_NO,
   CASE ds.TYPE_ID
      WHEN 'K' THEN ct.COINS_BET * CAST(ct.DENOM AS MONEY)
      ELSE (ct.PRESSED_COUNT + 1) * ct.COINS_BET * ct.LINES_BET * CAST(ct.DENOM AS MONEY) END AS TAB_AMT,
   ct.TICKET_NO,
   ISNULL(ct.DENOM, 0) AS DENOMINATION,
   ct.COINS_BET,
   ct.LINES_BET,
   ISNULL(cf.IS_PAPER, 0) AS IS_PAPER,
   ct.PRESSED_COUNT,
   ct.MACH_TIMESTAMP
FROM CASINO_TRANS ct
   JOIN MACH_SETUP                   ms ON ms.MACH_NO   = ct.MACH_NO
   JOIN DEAL_SETUP                   ds ON ds.DEAL_NO   = ct.DEAL_NO
   LEFT OUTER JOIN CASINO_FORMS      cf ON ds.FORM_NUMB = cf.FORM_NUMB
   LEFT OUTER JOIN TRANS            trn ON ct.TRANS_ID  = trn.TRANS_ID
   LEFT OUTER JOIN VOUCHER           v1 ON ct.TRANS_NO  = v1.CT_TRANS_NO_VC
   LEFT OUTER JOIN VOUCHER           v2 ON ct.TRANS_NO  = v2.CT_TRANS_NO_VR
   LEFT OUTER JOIN CASINO_EVENT_LOG cel ON cel.ID_VALUE = ct.TRANS_NO
WHERE
   (ct.DTIMESTAMP BETWEEN @DTStart AND @DTEnd) AND
   (ms.CASINO_MACH_NO = @Mach_No)

ORDER BY ct.TRANS_NO
GO
