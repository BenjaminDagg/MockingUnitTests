SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Revenue_By_Deal_EDS user stored procedure.

  Created: 01/21/2003 by Terry Watkins

  Purpose: Returns summarized data from Casino_Trans Table for the Revenue By
           Deal report for the entire data set (hence the _EDS in the proc name).

Arguments: None

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
2003-01-21 Terry Watkins
  Initial Coding.

2005-07-06 Nat Mogilevsky    v4.1.5
  Modified Where clause to exclude NULL for NUMB_ROLLS and TABS_PER_ROLL 

2007-08-21 Terry Watkins     v6.0.1
  Excluded Bingo Deals by JOINing GAME_TYPE and adding 'gt.PRODUCT_ID <> 3' to
  the WHERE clause.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Revenue_By_Deal_EDS]
AS

SELECT
   ds.DEAL_NO                      AS DealNumber,
   ds.TYPE_ID                      AS TypeID,
   ISNULL(ds.TAB_AMT, 0)           AS TabAmount,
   dt.DEAL_TYPE_NAME               AS DealTypeName,
   gs.GAME_DESC                    AS GameDesc,
   ISNULL(cf.TABS_PER_DEAL, 0)     AS TabsPerDeal,
   ISNULL(cf.TAB_TYPE_ID,0)    AS TabTypeId,
   ISNULL(dst.PLAY_COUNT, 0)       AS TabsDispensed,
   ISNULL(dst.PLAY_COUNT, 0)       AS TabsTotal,
   ISNULL(dst.WIN_COUNT, 0) + 
   ISNULL(dst.JACKPOT_COUNT, 0) +
   ISNULL(dst.FORFEIT_COUNT, 0)    AS WinningTabs,
   ISNULL(dst.AMOUNT_PLAYED, 0)    AS DollarsPlayed,
   ISNULL(dst.TOTAL_WIN_AMOUNT, 0) AS DollarsWon,
   ISNULL(dst.AMOUNT_PLAYED, 0) - ISNULL(DST.TOTAL_WIN_AMOUNT, 0) AS NetAmount,
   ISNULL(dst.FORFEIT_COUNT, 0)    AS TabsForfeited
FROM DEAL_SETUP ds
   LEFT OUTER JOIN DEAL_STATS  dst ON ds.DEAL_NO = dst.DEAL_NO
   JOIN CASINO_FORMS            cf ON ds.FORM_NUMB = cf.FORM_NUMB
   JOIN GAME_TYPE               gt ON gt.GAME_TYPE_CODE = cf.GAME_TYPE_CODE
   JOIN GAME_SETUP              gs ON cf.GAME_CODE = gs.GAME_CODE
   JOIN DEAL_TYPE               dt ON cf.DEAL_TYPE = dt.TYPE_ID
WHERE
   ds.DEAL_NO > 0               AND
   ds.TYPE_ID IS NOT NULL       AND
   ds.NUMB_ROLLS IS NOT NULL    AND
   ds.TABS_PER_ROLL IS NOT NULL AND
   gt.PRODUCT_ID <> 3
ORDER BY ds.TYPE_ID, ds.TAB_AMT, gs.GAME_DESC, ds.DEAL_NO
GO
