SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Player_Yearly_Summary user stored procedure.

  Created: 05/21/2002 by Miguel Zavala

  Purpose: Returns data for the Player Yearly Summary Report

Arguments: @PlayerID:  Player ID to report on.
           @StartDate: Starting DateTime for the resultset
           @EndDate:   Ending DateTime for the resultset

Change Log:

Who    When       Change Description
------ ---------- --------------------------------------------------------------
DGETAW 07/01/2002 Modified to expect a Player ID to be passed as the first
                  parameter instead of passing player first and last name.
                  If @PlayerID is 0 then all PLAYER_TRACK table records with
                  matching rows in CASINO_TRANS will be returned.
Terry Watkins 10-27-2004
 Changed argument names so they are meaningful.
 Changed reference to TRANS_TYPE to TRANS_ID.
 Replaced ds.TAB_AMT with ct.COINS_BET * ct.LINES_BET * ct.DENOM AS PLAY_COST
 Joined TRANS table to retrieve transaction description.
 Removed join to DEAL_SETUP.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Player_Yearly_Summary] @PlayerID Int, @StartDate DateTime, @EndDate DateTime
AS

SELECT
   pt.PLAYER_ID,
   pt.LNAME,
   pt.FNAME,
   pt.SEX,
   pt.DOB,
   ca.CARD_ACCT_NO,
   ct.TRANS_AMT,
   ct.BALANCE,
   ct.TRANS_ID,
   ISNULL(trn.REPORT_TEXT, '<undefined>') AS TRANS_DESC,
   ct.COINS_BET * ct.LINES_BET * ct.DENOM AS PLAY_COST,
   ct.DTIMESTAMP
FROM PLAYER_TRACK pt
   JOIN CARD_ACCT         ca ON pt.PLAYER_ID    = ca.PLAYER_ID
   JOIN CASINO_TRANS      ct ON ct.CARD_ACCT_NO = ca.CARD_ACCT_NO
   LEFT OUTER JOIN TRANS trn ON ct.TRANS_ID     = trn.TRANS_ID
WHERE
   (ct.DTIMESTAMP BETWEEN @StartDate AND @EndDate) AND
   (ct.TRANS_ID BETWEEN 10 AND 13)                 AND
   (@PlayerID = 0 OR @PlayerID = pt.PLAYER_ID)

GO
