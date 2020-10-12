SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_BingoRevenueByDeal user stored procedure.

  Created: 10-11-2007 by Andy Chen

  Purpose: Returns summarized data for the Bingo Revenue By Deal report.

Arguments: @ShowAll flags if close deals are included.

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
10-11-2007 Andy Chen         v6.0.1
  Initial coding

07-30-2008 Terry Watkins     v6.0.2
  Minor formatting change to force update of this procedure.

04-06-2009 Terry Watkins     v6.0.4
  Added 'dst.PLAY_COUNT IS NOT NULL' to WHERE clause to prevent divide by zero
  errors in the report.  Bingo Deals with no activity will no longer occur in
  the report.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_BingoRevenueByDeal] @ShowAll Bit = 0
AS

SELECT
   ds.DEAL_NO                       AS DealNumber,
   ds.TYPE_ID                       AS TypeID,
   ISNULL(ds.TAB_AMT, 0)            AS TabAmount,
   dt.DEAL_TYPE_NAME                AS DealTypeName,
   gt.LONG_NAME                     AS GameDesc,
   cf.LINES_BET                     AS LinesBet,
   CAST(cf.DENOMINATION AS Char(4)) AS Denom,
   ISNULL(cf.TABS_PER_DEAL, 0)      AS TabsPerDeal,
   ISNULL(dst.PLAY_COUNT, 0)        AS TabsDispensed,
   ISNULL(dst.PLAY_COUNT, 0)        AS TabsTotal,
   ISNULL(dst.WIN_COUNT, 0)     + 
   ISNULL(dst.JACKPOT_COUNT, 0) +
   ISNULL(dst.FORFEIT_COUNT, 0)     AS WinningTabs,
   ISNULL(dst.AMOUNT_PLAYED, 0)     AS DollarsPlayed,
   ISNULL(dst.TOTAL_WIN_AMOUNT, 0)  AS DollarsWon,
   ISNULL(dst.AMOUNT_PLAYED, 0) - ISNULL(DST.TOTAL_WIN_AMOUNT, 0) AS NetAmount,
   ISNULL(dst.FORFEIT_COUNT, 0)     AS TabsForfeited,
   cf.HOLD_PERCENT                  AS TargetHoldPct,
   CASE dst.AMOUNT_PLAYED
      WHEN 0 THEN 0
      ELSE (dst.AMOUNT_PLAYED - dst.TOTAL_WIN_AMOUNT) / dst.AMOUNT_PLAYED * 100 END AS HoldPct
FROM DEAL_SETUP ds
   LEFT OUTER JOIN DEAL_STATS  dst ON ds.DEAL_NO = dst.DEAL_NO
   JOIN CASINO_FORMS            cf ON ds.FORM_NUMB = cf.FORM_NUMB
   JOIN GAME_TYPE               gt ON gt.GAME_TYPE_CODE = cf.GAME_TYPE_CODE
   JOIN GAME_SETUP              gs ON cf.GAME_CODE = gs.GAME_CODE
   JOIN DEAL_TYPE               dt ON cf.DEAL_TYPE = dt.TYPE_ID
WHERE
   ds.DEAL_NO > 0                   AND
   ds.TYPE_ID IS NOT NULL           AND
   ds.NUMB_ROLLS IS NOT NULL        AND
   ds.TABS_PER_ROLL IS NOT NULL     AND
   (ds.IS_OPEN = 1 OR @ShowAll = 1) AND
   dst.PLAY_COUNT IS NOT NULL       AND
   gt.PRODUCT_ID = 3
ORDER BY ds.TYPE_ID, ds.TAB_AMT, gt.LONG_NAME, ds.DEAL_NO

GO
