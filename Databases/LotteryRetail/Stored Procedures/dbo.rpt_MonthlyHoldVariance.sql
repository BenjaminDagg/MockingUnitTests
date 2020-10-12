SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_MonthlyHoldVariance user stored procedure.

  Created: 07/15/2008 by Aldo Zamora

  Purpose: Returns summarized data from MACHINE_STATS Table for the report
           Monthly Hold Variance for a 1 month period.

Arguments: @MonthValue: Month to report on.
           @YearValue:  Year to report on.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   07/15/2008     v6.0.1
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_MonthlyHoldVariance] @MonthValue Int, @YearValue Int
AS

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Retrieve data
SELECT
   ms.MACH_NO               AS DGIdentifier,
   ms.CASINO_MACH_NO        AS PlayerTerminal,
   ms.DEAL_NO               AS DealNumber,
   ms.GAME_CODE             AS GameCode,
   gs.GAME_DESC             AS GameTheme,
   SUM(ms.PLAY_COUNT)       AS PlayCount,
   SUM(ms.JACKPOT_COUNT)    AS JackpotCount,
   SUM(ms.AMOUNT_JACKPOT)   AS JackpotTotalAmount,
   SUM(ms.AMOUNT_PLAYED)    AS AmountPlayed,
   SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED) AS AmountWon,
   ((SUM(ms.AMOUNT_PLAYED) - SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED)) / SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED)) * 100 AS ActualHold,
   cf.HOLD_PERCENT          AS TheoreticalHold
FROM MACHINE_STATS ms
   JOIN DEAL_SETUP   ds ON ms.DEAL_NO   = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
   JOIN GAME_SETUP   gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE
   DATEPART(MM, ms.ACCT_DATE)  = @MonthValue AND
   DATEPART(YY, ms.ACCT_DATE)  = @YearValue  AND
   ms.DEAL_NO > '0'                           
GROUP BY
   ms.MACH_NO,
   ms.CASINO_MACH_NO,
   ms.DEAL_NO,
   ms.GAME_CODE,
   gs.GAME_DESC,
   cf.HOLD_PERCENT
HAVING SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED) > 0
ORDER BY ms.GAME_CODE

GO
