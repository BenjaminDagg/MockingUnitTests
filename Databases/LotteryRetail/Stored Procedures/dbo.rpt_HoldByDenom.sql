SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_HoldByDenom user stored procedure.

  Created: 01-09-2006 by Terry Watkins

  Purpose: Returns data for the Hold by Denom report
   The Information is displayed on Report cr_HoldByDenom


Arguments:
   @AcctMonth:     Player ID to report on or 0 for all
   @AcctYear:     Starting DateTime for the resultset

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-18-2004     v5.0.8
  Initial coding
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[rpt_HoldByDenom]
   @AcctMonth  Int,
   @AcctYear   Int
AS

SELECT
   mps.MACH_NO             AS DGEMachNbr,
   mps.CASINO_MACH_NO      AS CasinoMachNbr,
   gs.GAME_DESC            AS GameTheme,
   mps.DENOM               AS Denom,
   SUM(mps.PLAY_COUNT)     AS PlayCount,
   SUM(mps.AMOUNT_PLAYED)  AS AmountPlayed,
   SUM(mps.AMOUNT_WON)     AS AmountWon,
   cf.HOLD_PERCENT         AS TheoreticalHold,
   (SUM(mps.AMOUNT_PLAYED) - SUM(mps.AMOUNT_WON)) / SUM(mps.AMOUNT_PLAYED) AS ActualHold
FROM MACHINE_PLAY_STATS mps
   JOIN DEAL_SETUP      ds ON mps.DEAL_NO   = ds.DEAL_NO
   JOIN CASINO_FORMS    cf ON ds.FORM_NUMB  = cf.FORM_NUMB
   JOIN GAME_SETUP      gs ON mps.GAME_CODE = gs.GAME_CODE
WHERE
   (mps.ACCT_MONTH = @AcctMonth) AND
   (mps.ACCT_YEAR  = @AcctYear)  AND
   (mps.AMOUNT_PLAYED > 0)
GROUP BY mps.MACH_NO, mps.CASINO_MACH_NO, gs.GAME_DESC, mps.DENOM, cf.HOLD_PERCENT
ORDER BY gs.GAME_DESC, mps.DENOM, mps.CASINO_MACH_NO
GO
