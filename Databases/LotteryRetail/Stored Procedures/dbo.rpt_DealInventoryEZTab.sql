SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/* 
--------------------------------------------------------------------------------
Procedure: rpt_DealInventoryEZTab

  Purpose: Returns Inventory of Triple Play (Dakota) Deals.

Arguments: @ShowClosedDeals - Set to 0 to show only open Deals
                            - Set to 1 to show all Deals

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
2003-10-08 Terry Watkins
  Initial coding as rpt_InventoryByDealTP.

2006-02-14 Terry Watkins     v5.0.2
  Changed name to rpt_DealInventoryEZTab.
  Limited resultset to EZTab Deals.
  Added @ShowClosedDeals (defaulted to True) to control whether Closed Deals
  are included in the resultset.

2007-08-21 Terry Watkins     v6.0.1
  Excluded Compact and Bingo Deals (by JOINing the GAME_TYPE table and adding
  'AND gt.PRODUCT_ID < 3' to the WHERE clause).
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_DealInventoryEZTab] @ShowClosedDeals Bit = 1
AS
SELECT
   ds.DEAL_NO,
   dsu.DEAL_DESCR,
   CAST(ds.DENOMINATION AS MONEY) / 100 AS DENOMINATION,
   ds.COINS_BET,
   ds.LINES_BET,
   ds.CURRENT_DEAL_FLAG,
   ds.NEXT_TICKET,
   ds.LAST_TICKET,
   dst.LAST_PLAY,
   dst.FIRST_PLAY,
   dsn.DEAL_NO AS NEXT_DEAL
FROM DEAL_SEQUENCE ds
   JOIN DEAL_SETUP               dsu ON ds.DEAL_NO = dsu.DEAL_NO
   JOIN CASINO_FORMS              cf ON dsu.FORM_NUMB = cf.FORM_NUMB
   JOIN GAME_TYPE                 gt ON gt.GAME_TYPE_CODE = cf.GAME_TYPE_CODE
   LEFT OUTER JOIN DEAL_STATS    dst ON ds.DEAL_NO = dst.DEAL_NO
   LEFT OUTER JOIN DEAL_SEQUENCE dsn ON ds.NEXT_DEAL = dsn.DEAL_SEQUENCE_ID
WHERE
   (cf.IS_PAPER = 0)   AND
   (gt.PRODUCT_ID < 3) AND
   (dsu.IS_OPEN <> @ShowClosedDeals OR @ShowClosedDeals = 1)
ORDER BY
   ds.CURRENT_DEAL_FLAG DESC,
   ds.DENOMINATION,
   ds.COINS_BET,
   ds.LINES_BET,
   ds.DEAL_NO

GO
