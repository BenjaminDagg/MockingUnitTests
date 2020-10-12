SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_PlayByBetLevel user stored procedure.

  Created: 05/13/2004 by Jack Herter

  Purpose: Returns data for Play activity by Deal
           
Arguments: @DealNbr  Deal Number to report on or -1 to retrieve results for all
                     Deals



Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
Terry Watkins 10-27-2004 Changed references to TRANS_TYPE to TRANS_ID.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_PlayByBetLevel] @DealNbr Int
AS

--Suppress return of message data.
SET  NOCOUNT ON

--Run the query for the resultset 
SELECT 
   p.PRODUCT_ID            AS ProductID,
   p.PRODUCT_DESCRIPTION   AS Product,
   gt.GAME_TYPE_CODE       AS GameTypeCode,
   gs.GAME_CODE		   AS GameCode,
   gs.GAME_DESC            AS GameDesc,  
   ct.DEAL_NO              AS DealNumber,
   ct.DENOM 		   AS Denom,
   ct.COINS_BET	           AS CoinsBet,
   ct.LINES_BET		   AS LinesBet,
   ct.COINS_BET * ct.LINES_BET * ct.DENOM AS TabCost,
   COUNT(*)        	   AS TabsSold,
   SUM(ct.DENOM * ct.COINS_BET * ct.LINES_BET) AS TotalSales,
   SUM(CASE WHEN TRANS_ID = 10 THEN 0 ELSE ct.TRANS_AMT END) AS TotalWon,
   MAX(((cf.TOTAL_AMT_IN - cf.TOTAL_AMT_OUT) / cf.TOTAL_AMT_IN) * 100) AS ExpectedHoldPct
FROM CASINO_TRANS ct   
   JOIN PRODUCT       p ON ct.PRODUCT_ID = p.PRODUCT_ID
   JOIN GAME_SETUP   gs ON ct.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE    gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN DEAL_SETUP   ds ON ct.DEAL_NO = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
WHERE
   (ct.TRANS_ID BETWEEN 10 AND 13) AND
   (ct.DEAL_NO <> 0)               AND
   (@DealNbr = -1 OR ct.DEAL_NO = @DealNbr)  
GROUP BY
   p.PRODUCT_ID, 
   p.PRODUCT_DESCRIPTION,
   gt.GAME_TYPE_CODE, 
   gs.GAME_CODE,	
   gs.GAME_DESC, 
   ct.DEAL_NO, 
   ct.DENOM,
   ct.COINS_BET,
   ct.LINES_BET
ORDER BY
   p.PRODUCT_ID,
   gt.GAME_TYPE_CODE,
   gs.GAME_CODE,
   ct.DEAL_NO,
   ct.DENOM,
   ct.COINS_BET,
   ct.LINES_BET

GO
