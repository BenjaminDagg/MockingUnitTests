SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_TPP_Deal_Analysis user stored procedure.

  Created: 05/10/2004 by Jack Herter

  Purpose: Returns summarized data from Machine Stats Table for the report
           crTPPDealAnalysis.

Arguments: @DealNbr  Deal Number to report on or -1 to retrieve results for all
                     Triple Play Paper Deals


Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
Jack H.       5/10/2004  Intial Coding
Terry Watkins 10-11-2004 Fixed MoneyOut and Hold amounts to include Jackpots.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_TPP_Deal_Analysis] @DealNbr Int
AS 

--Suppress return of message data.
SET  NOCOUNT ON

--Select data for the resultset that is returned.
SELECT 
   ms.DEAL_NO              AS DealNumber,
   ds.FIRST_PLAY           AS FirstPlay,
   ds.LAST_PLAY            AS LastPlay,   
   SUM(ms.PLAY_COUNT)	   AS PlayCount,
   SUM(ms.AMOUNT_PLAYED)   AS MoneyIn,
   SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT) AS MoneyOut,
   SUM(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT)) AS Hold
FROM MACHINE_STATS ms
   JOIN DEAL_STATS   ds ON ms.DEAL_NO = ds.DEAL_NO
   JOIN DEAL_SETUP  dst ON ms.DEAL_NO = dst.DEAL_NO
   JOIN CASINO_FORMS cf ON dst.FORM_NUMB = cf.FORM_NUMB
   JOIN GAME_TYPE    gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE 
WHERE
   ms.DEAL_NO <> 0   AND
   dst.IS_OPEN = 1   AND
   ms.PLAY_COUNT > 0 AND
   gt.PRODUCT_ID = 1 AND
   cf.IS_PAPER = 1   AND
   (@DealNbr = -1 OR ms.DEAL_NO = @DealNbr)  
GROUP BY
   ms.DEAL_NO,
   ds.FIRST_PLAY,
   ds.LAST_PLAY 
ORDER BY ms.DEAL_NO
GO
