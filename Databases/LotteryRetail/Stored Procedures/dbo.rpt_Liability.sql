SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Liability user stored procedure.

  Created: 06/11/2002 by Terry Watkins

  Purpose: Returns Cleared Account data for the Liability report

Arguments: @StartDate:  Starting DateTime for the resultset
           @EndDate:    Ending DateTime for the resultset


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 06-11-2002
  Original coding

Terry Watkins 09-05-2002
  Added column TRANS_TYPE and include 'F'orfeit transactions.

Terry Watkins 10-26-2004
  Replaced ct.TRANS_TYPE with ct.TRANS_ID

Terry Watkins 02-14-2006     v5.0.2
  Added unredeemed Vouchers to the resultset.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Liability] @StartDate DateTime, @EndDate DateTime
AS
SELECT
   ct.CARD_ACCT_NO            AS CardAccount,
   CASE 
      WHEN (pt.LNAME IS NULL)
      THEN ''
      ELSE pt.LNAME + ', ' + ISNULL(pt.FNAME, '') END
                              AS PlayerName,
   ct.TRANS_AMT               AS TransAmt,
   ct.DTIMESTAMP              AS TransDateTime,
   ct.TRANS_ID                AS TransID
FROM CASINO_TRANS ct
   LEFT OUTER JOIN CARD_ACCT    ca ON ct.CARD_ACCT_NO = ca.CARD_ACCT_NO
   LEFT OUTER JOIN PLAYER_TRACK pt ON ca.PLAYER_ID    = pt.PLAYER_ID
WHERE
   (ct.DTIMESTAMP BETWEEN @StartDate AND @EndDate) AND
   (ct.TRANS_ID IN (13,25))
UNION
SELECT
   ct.CARD_ACCT_NO            AS CardAccount,
   CASE 
      WHEN (pt.LNAME IS NULL)
      THEN ''
      ELSE pt.LNAME + ', ' + ISNULL(pt.FNAME, '') END
                              AS PlayerName,
   v.VOUCHER_AMOUNT           AS TransAmt,
   ct.DTIMESTAMP              AS TransDateTime,
   ct.TRANS_ID                AS TransID
FROM VOUCHER v
   JOIN CASINO_TRANS            ct ON v.CT_TRANS_NO_VC = ct.TRANS_NO
   LEFT OUTER JOIN CARD_ACCT    ca ON ct.CARD_ACCT_NO  = ca.CARD_ACCT_NO
   LEFT OUTER JOIN PLAYER_TRACK pt ON ca.PLAYER_ID     = pt.PLAYER_ID
WHERE
   (v.CREATE_DATE BETWEEN @StartDate AND @EndDate) AND
   (v.REDEEMED_STATE = 0)
ORDER BY 2, 1, 4
GO
