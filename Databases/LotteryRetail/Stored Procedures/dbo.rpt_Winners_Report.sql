SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Winners_Report user stored procedure.

  Created: 05/22/02 by Miguel Zavala

  Purpose:
   Gathers data from the Player_Track, Card_Acct and Casino_Trans Tables for the
   cr_Winners_Report report in the millennium accounting application.

Arguments:
   @StartAmount   Minimum win amount to report upon
   @EndAmount     Maximum win amount to report upon
   @StartDate     Start of date range to report upon
   @EndDate       End of date range to report upon
   @DealNbr       Deal Number to include or all deals if NULL


Change Log:

Changed By    Date       
 Change Description
---------------------------------------------------------------------------------------
Terry Watkins 06-12-2002 Added DEAL_SETUP.DEAL_DESCR to the resultset.
 Changed the datatype of the arguments @inSTART_AMT and @inENDING_AMT from
 Decimal(9,2) to Money.

Terry Watkins 06-13-2002
 Removed pt.SEX,pt.DOB. Added ct.DEAL_NO, ct.TICKET_NO.
 Added AUTH_USER (CASINO_EVENT_LOG.CREATED_BY) which is the user that authorized a
 lockup amount payout.
 Added an ORDER BY clause.

Norm Symonds  09-25-2002
 Added Handling for Deal Number - select for all deals if Deal Number passed is
 NULL - select for the specific deal if a non-null Deal Number is passed.

Terry Watkins 11-05-2002
 Added Cashier to the resultset. Required new join to CASHIER_TRANS table.

Terry Watkins 02-13-2003
 Reversed the order of first and last names so they display properly on the
 Winner By Amount report.

Terry Watkins 10-27-2004
 Changed references to TRANS_TYPE to TRANS_ID.
 Retrieves CASINO_MACH_NO as the machine number.
 Added TRANS_DESC to returned dataset.
 Changed argument names to make them meaningful.
 Replaced ds.TAB_AMT with ct.COINS_BET * ct.LINES_BET * ct.DENOM AS PLAY_COST.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Winners_Report]
   @StartAmount   Money,
   @EndAmount     Money,
   @StartDate     DateTime,
   @EndDate       DateTime,
   @DealNbr       Integer
AS
   SELECT
      pt.FNAME,
      pt.LNAME,
      ct.DEAL_NO,
      ct.TICKET_NO,
      ca.CARD_ACCT_NO,
      ISNULL(ms.CASINO_MACH_NO, ct.MACH_NO)  AS MACH_NO,
      ct.TRANS_AMT,
      ct.TRANS_ID,
      ISNULL(trn.REPORT_TEXT, '<undefined>') AS TRANS_DESC,
      ct.DTIMESTAMP                          AS TRANS_DATE,
      ct.COINS_BET * ct.LINES_BET * ct.DENOM AS PLAY_COST,
      ds.DEAL_DESCR                          AS DEAL_DESC,
      cel.CREATED_BY                         AS AUTH_USER,
      csht.CREATED_BY                        AS CASHIER
   FROM PLAYER_TRACK pt
      RIGHT JOIN CARD_ACCT         ca ON pt.PLAYER_ID        = ca.PLAYER_ID
      INNER JOIN CASINO_TRANS      ct ON ct.CARD_ACCT_NO     = ca.CARD_ACCT_NO
      INNER JOIN DEAL_SETUP        ds ON ds.DEAL_NO          = ct.DEAL_NO
      LEFT  JOIN CASINO_EVENT_LOG cel ON ct.TRANS_NO         = cel.ID_VALUE
      LEFT  JOIN CASHIER_TRANS   csht ON cel.EVENT_DATE_TIME = csht.CREATE_DATE
      LEFT OUTER JOIN TRANS       trn ON ct.TRANS_ID         = trn.TRANS_ID
      LEFT OUTER JOIN MACH_SETUP   ms ON ct.MACH_NO          = ms.MACH_NO
   WHERE
      (ct.TRANS_AMT BETWEEN @StartAmount AND @EndAmount) AND
      (ct.TRANS_ID BETWEEN 11 AND 13)                    AND
      (ct.TRANS_AMT <> 0)                                AND
      (ct.DTIMESTAMP BETWEEN @StartDate AND @EndDate)    AND
      (@DealNbr IS NULL OR ct.DEAL_NO = @DealNbr)
   ORDER BY ct.TRANS_AMT, pt.LNAME, pt.FNAME, ca.CARD_ACCT_NO, ct.DTIMESTAMP

GO
