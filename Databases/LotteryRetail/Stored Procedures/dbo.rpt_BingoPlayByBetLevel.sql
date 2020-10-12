SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure: rpt_BingoPlayByBetLevel user stored procedure.

  Created: 10/10/2007 by Andy Chen

  Purpose: Returns data for Play activity by Deal
           
Arguments: @Month & @Year  


Change Log:

Changed By    Date           Database version 
  Change Description
--------------------------------------------------------------------------------
Andy Chen     10-10-2007     v6.0.1
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_BingoPlayByBetLevel] @Month Int, @Year Int
AS

--Suppress return of message data.
SET  NOCOUNT ON

--Run the query for the resultset 
SELECT 
   gt.LONG_NAME             AS  GameDesc,
   mps.DEAL_NO              AS  DealNumber,
   mps.DENOM                AS  Denom,
   mps.COINS_BET            AS  CoinsBet,
   mps.LINES_BET            AS  LinesBet,
   mps.COINS_BET * mps.LINES_BET * mps.DENOM AS TabCost,
   SUM(mps.PLAY_COUNT)      AS  TabsSold,
   SUM(mps.AMOUNT_PLAYED)   AS  TotalSales,
   SUM(mps.AMOUNT_WON)      AS  TotalWon,
   CASE MAX(cf.TOTAL_AMT_IN)
      WHEN 0 THEN 0
      ELSE
      MAX(((cf.TOTAL_AMT_IN - cf.TOTAL_AMT_OUT) / cf.TOTAL_AMT_IN) * 100) END AS ExpectedHoldPct,
   CASE SUM(mps.AMOUNT_PLAYED)
      WHEN 0 THEN 0
      ELSE
         (SUM(mps.AMOUNT_PLAYED) - SUM(mps.AMOUNT_WON)) / SUM(mps.AMOUNT_PLAYED) * 100 END AS ActualHoldPct,
   mps.ACCT_MONTH           AS  AcctMonth,
   mps.ACCT_YEAR            AS  AcctYear
FROM MACHINE_PLAY_STATS mps
   JOIN GAME_SETUP   gs ON mps.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE    gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN DEAL_SETUP   ds ON mps.DEAL_NO = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
   JOIN PRODUCT       p ON gt.PRODUCT_ID = p.PRODUCT_ID
WHERE gt.PRODUCT_ID = 3      AND
   mps.ACCT_MONTH   = @Month AND
   mps.ACCT_YEAR    = @Year
GROUP BY
   gt.LONG_NAME,
   mps.DEAL_NO,
   mps.DENOM,
   mps.COINS_BET,
   mps.LINES_BET,
   mps.ACCT_MONTH,
   mps.ACCT_YEAR


GO
