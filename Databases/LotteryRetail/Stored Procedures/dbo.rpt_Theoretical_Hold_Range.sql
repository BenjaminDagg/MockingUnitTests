SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Theoretical_Hold_Range user stored procedure.

  Created: 08/17/2004 by Terry Watkins  

  Purpose: Returns summarized data for the Theoretical Hold for Date Range report

Arguments: @DealCode 0 = All Deals
                     1 = Open Deals
                     2 = Closed Deals
                     3 = Specific Deal
           @DealNumber - Deal Number to retrieve when @DealCode = 3
           @StartDate  - Starting Accounting Date of date range
           @EndDate    - Ending Accounting Date of date range

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
2004-08-17 Terry Watkins
  Initial Coding.

2007-08-21 Terry Watkins     v6.0.1
  Modified to exclude Bingo Deals.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[rpt_Theoretical_Hold_Range]
   @DealCode Integer, 
   @DealNumber Integer,
   @StartDate DateTime,
   @EndDate DateTime
AS

SELECT
   ms.DEAL_NO                AS DealNbr,
   p.PRODUCT_DESCRIPTION     AS ProductID,
   cf.DENOMINATION           AS Denomination,
   cf.COINS_BET              AS CoinsBet,
   cf.LINES_BET              AS LinesBet,
   cf.GAME_CODE              AS GameCode,
   cf.FORM_NUMB              AS FormNumber,
   cf.TABS_PER_DEAL          AS TabsPerDeal,
   cf.TAB_AMT                AS TabAmount,
   cf.DEAL_TYPE              AS DealType,
   dt.DEAL_TYPE_NAME         AS DealTypeName,
   ds.DEAL_DESCR             AS DealDesc,
   gs.GAME_DESC              AS GameDesc,
   ABS(ds.IS_OPEN)           AS IsOpen,
   ABS(ds.CLOSE_RECOMMENDED) AS CloseRecommended,
   SUM(ms.PLAY_COUNT)        AS PlayCount,
   CAST(SUM(ms.PLAY_COUNT) AS DECIMAL) / cf.TABS_PER_DEAL * 100.0 AS PercentPlayed,
   CASE cf.TABS_PER_DEAL
      WHEN 0 THEN 0
      WHEN NULL THEN 0 
      ELSE
         (CAST(cf.WINS_PER_DEAL AS DECIMAL) /
          CAST(cf.TABS_PER_DEAL AS DECIMAL)) * SUM(ms.PLAY_COUNT)
      END AS ExpectedWins,
   SUM(ms.WIN_COUNT + ms.JACKPOT_COUNT + ms.FORFEIT_COUNT) AS ActualWins,
   SUM(ms.AMOUNT_PLAYED)     AS DollarsPlayed,
   CASE SUM(ms.PLAY_COUNT)
      WHEN 0 THEN 0
      WHEN NULL THEN 0
      ELSE
         SUM(ms.AMOUNT_PLAYED) * 
         (CAST(1.0 AS DECIMAL) - 
         ((CAST(cf.TOTAL_AMT_IN AS DECIMAL) -
         CAST(cf.TOTAL_AMT_OUT AS DECIMAL)) / CAST(cf.TOTAL_AMT_IN AS DECIMAL)))
      END AS ExpectedPayout,
   SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED) AS ActualPayout,
   CASE cf.TOTAL_AMT_IN
      WHEN 0 THEN 0
      WHEN NULL THEN 0
      ELSE
         SUM(ms.AMOUNT_PLAYED) * 
         ((CAST(cf.TOTAL_AMT_IN AS DECIMAL) - 
         CAST(cf.TOTAL_AMT_OUT AS DECIMAL)) / CAST(cf.TOTAL_AMT_IN AS DECIMAL))
      END AS TheoreticalHold,
      SUM(ms.AMOUNT_PLAYED) - SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED) AS ActualHold,
      CASE cf.TOTAL_AMT_IN
         WHEN 0 THEN 0
         ELSE ((cf.TOTAL_AMT_IN - cf.TOTAL_AMT_OUT)  * 100/ cf.TOTAL_AMT_IN)
         END AS TheoreticalHoldPC,
      CASE SUM(ms.AMOUNT_PLAYED)
         WHEN NULL THEN 0
         WHEN 0 THEN 0
         ELSE
            ((SUM(ms.AMOUNT_PLAYED) - SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED)) * 100 / SUM(ms.AMOUNT_PLAYED))
         END AS ActualHoldPC,
      dst.FIRST_PLAY AS FirstPlay,
      dst.LAST_PLAY  AS LastPlay
FROM  MACHINE_STATS ms
      JOIN DEAL_STATS dst  ON ms.DEAL_NO = dst.DEAL_NO
      RIGHT OUTER JOIN DEAL_SETUP ds ON dst.DEAL_NO = ds.DEAL_NO
      JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
      JOIN GAME_SETUP gs   ON cf.GAME_CODE = gs.GAME_CODE
      JOIN GAME_TYPE gt    ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
      JOIN PRODUCT p       ON gt.PRODUCT_ID = p.PRODUCT_ID
      JOIN DEAL_TYPE dt    ON cf.DEAL_TYPE = dt.TYPE_ID
WHERE
   (gt.PRODUCT_ID <> 3) AND
   (ms.ACCT_DATE BETWEEN @StartDate AND @EndDate) AND
   (@DealCode = 0 OR
   (@DealCode = 1 AND ds.IS_OPEN = 1) OR
   (@DealCode = 2 AND ds.IS_OPEN = 0) OR
   (@DealCode = 3 AND ms.DEAL_NO = @DealNumber)) AND
   (ms.DEAL_NO > 0)
GROUP BY ms.DEAL_NO, p.PRODUCT_DESCRIPTION, cf.DENOMINATION,
   cf.COINS_BET,
   cf.LINES_BET,
   cf.GAME_CODE,
   cf.FORM_NUMB,
   cf.TABS_PER_DEAL,
   cf.TAB_AMT,
   cf.DEAL_TYPE,
   dt.DEAL_TYPE_NAME,
   ds.DEAL_DESCR,
   gs.GAME_DESC,
   ds.IS_OPEN,
   ds.CLOSE_RECOMMENDED,
   cf.WINS_PER_DEAL,
   cf.TOTAL_AMT_IN,
   cf.TOTAL_AMT_OUT,
   dst.FIRST_PLAY,
   dst.LAST_PLAY
ORDER BY cf.DEAL_TYPE, cf.TAB_AMT, ms.DEAL_NO
GO
