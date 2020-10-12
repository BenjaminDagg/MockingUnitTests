SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Jackpot user stored procedure.

  Created: 07/07/2002 by Terry Watkins

  Purpose: Returns data for the Jackpot report
   The Information is displayed on Report cr_Jackpot_Report


Arguments:
   @PlayerID:     Player ID to report on or 0 for all
   @StartDate:    Starting DateTime for the resultset
   @EndDate:      Ending DateTime for the resultset
   @JackpotsOnly: Flag indicating if only Jackpot wins should be returned

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-18-2004
  Added argument @JackpotsOnly to allow display of only Jackpots
  (exclude lockup amount wins).

Terry Watkins 01-31-2007     v5.0.8
  Modified to handle DG TITO mode play.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[rpt_Jackpot]
   @PlayerID     Int,
   @StartDate    DateTime,
   @EndDate      DateTime,
   @JackpotsOnly Bit
AS

-- Disable return of unwanted info.
SET NOCOUNT ON

-- Variable Declarations
DECLARE @CardRequired       Bit
DECLARE @IsDGTito           Bit
DECLARE @TpiID              Int

-- Variable Initialization
SET @IsDGTito = 0

-- Retrieve CASINO information.
SELECT
   @CardRequired  = PLAYER_CARD,
   @TpiID         = TPI_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Set the DG Tito flag.
IF (@TpiID = 0 AND @CardRequired = 0) SET @IsDGTito = 1


-- PRINT @IsDgTito

-- Perform the appropriate select based upon the DG Tito flag value.
IF (@IsDGTito = 0)
   -- Not DG Tito mode...
   BEGIN
      SELECT
         jp.TICKET_NO      AS TicketNo,
         jp.CARD_ACCT_NO   AS AccountNo,
         ms.CASINO_MACH_NO AS MachNo,
         jp.TRANS_AMT      AS TransAmt,
         jp.DTIMESTAMP     AS TransDat,
         trn.REPORT_TEXT   AS TransText,
         pt.FNAME          AS Fname,
         pt.LNAME          AS Lname,
         jp.DEAL_NO        AS DealNo,
         jp.TRANS_NO       AS TransNo,
         cel.CREATED_BY    AS AuthorizedBy,
         csht.CREATED_BY   AS PaidBy,
         ds.DEAL_DESCR     AS GameDesc,
         jp.PLAY_COST      AS PlayCost
      FROM JACKPOT jp
         JOIN CARD_ACCT                    ca ON jp.CARD_ACCT_NO = ca.CARD_ACCT_NO
         JOIN DEAL_SETUP                   ds ON jp.DEAL_NO = ds.DEAL_NO
         JOIN MACH_SETUP                   ms ON jp.MACH_NO = ms.MACH_NO
         LEFT OUTER JOIN CASINO_EVENT_LOG cel ON jp.TRANS_NO = cel.ID_VALUE
         LEFT OUTER JOIN PLAYER_TRACK      pt ON pt.PLAYER_ID = ca.PLAYER_ID
         LEFT  JOIN CASHIER_TRANS        csht ON cel.EVENT_DATE_TIME = csht.CREATE_DATE
         LEFT OUTER JOIN TRANS            trn ON jp.TRANS_ID = trn.TRANS_ID
      WHERE
         (jp.DTIMESTAMP BETWEEN @StartDate AND @EndDate) AND
         (@PlayerID = 0 OR @PlayerID = pt.PLAYER_ID) AND
         (@JackpotsOnly = 0 OR jp.TRANS_ID = 12)
      ORDER BY pt.LNAME, pt.FNAME, jp.DTIMESTAMP
   END
ELSE
   -- DG Tito mode...
   BEGIN
      SELECT
         jp.TICKET_NO      AS TicketNo,
         jp.CARD_ACCT_NO   AS AccountNo,
         ms.CASINO_MACH_NO AS MachNo,
         jp.TRANS_AMT      AS TransAmt,
         jp.DTIMESTAMP     AS TransDat,
         trn.REPORT_TEXT   AS TransText,
         ''                AS Fname,
         ''                AS Lname,
         jp.DEAL_NO        AS DealNo,
         jp.TRANS_NO       AS TransNo,
         csht.AUTH_USER    AS AuthorizedBy,
         csht.CREATED_BY   AS PaidBy,
         ds.DEAL_DESCR     AS GameDesc,
         jp.PLAY_COST      AS PlayCost
      FROM JACKPOT jp
         JOIN DEAL_SETUP                 ds ON jp.DEAL_NO = ds.DEAL_NO
         JOIN MACH_SETUP                 ms ON jp.MACH_NO = ms.MACH_NO
         LEFT OUTER JOIN VOUCHER          v ON v.CT_TRANS_NO_JP = JP.TRANS_NO
         LEFT OUTER JOIN CASHIER_TRANS csht ON v.VOUCHER_ID = csht.VOUCHER_ID
         LEFT OUTER JOIN TRANS          trn ON jp.TRANS_ID = trn.TRANS_ID
      WHERE
         (jp.DTIMESTAMP BETWEEN @StartDate AND @EndDate) AND
         (@JackpotsOnly = 0 OR jp.TRANS_ID = 12)
      ORDER BY jp.DTIMESTAMP
   END
GO
