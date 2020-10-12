SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User View uvwEDealPurgeList

Created 05-11-2005 by Terry Watkins

Purpose:
  Retrieves Deal numbers and information for those Deals that are candidates
  for purging from the eDeal database.

Remarks:
  The WHERE clause restricts the resultset to those Deals that:
    
    - Exist in the eDeal database
    
    - Are flagged as closed in DEAL_SETUP and are net current in DEAL_SEQUENCE or
    
    - Next Ticket = Last Ticket (exhausted) and not current in DEAL_SEQUENCE and
      has not had activity within the last 2 weeks.
--------------------------------------------------------------------------------
*/
CREATE VIEW [dbo].[uvwEDealPurgeList]
AS
SELECT
   dsq.DEAL_NO,
   dsq.FORM_NUMB,
   dsq.UPDATE_DATE,
   dsq.DENOMINATION,
   dsq.COINS_BET,
   dsq.LINES_BET,
   dsq.LAST_TICKET,
   dsq.NEXT_TICKET,
   CASE dsq.CURRENT_DEAL_FLAG WHEN 1 THEN 'Yes' ELSE 'No' END AS CURRENT_DSEQ_DEAL,
   ds.DEAL_DESCR AS DEAL_DESC,
   ds.GAME_CODE,
   gs.GAME_TYPE_CODE,
   ds.IS_OPEN
FROM DEAL_SEQUENCE dsq
   JOIN DEAL_SETUP ds ON dsq.DEAL_NO = ds.DEAL_NO
   JOIN GAME_SETUP gs ON ds.GAME_CODE = gs.GAME_CODE
WHERE
   -- It is closed and not current in DEAL_SEQUENCE OR
   ((ds.IS_OPEN = 0 AND dsq.CURRENT_DEAL_FLAG = 0) OR
   -- It is exhausted and not current and no activity for 2 weeks.
   (dsq.NEXT_TICKET = LAST_TICKET AND dsq.CURRENT_DEAL_FLAG = 0 AND DATEDIFF(Day, dsq.UPDATE_DATE, GetDate()) > 14)) AND
   -- There is a matching Deal table in eDeal
   dsq.DEAL_NO IN
   (SELECT CAST(SUBSTRING(TABLE_NAME, 5, 8) AS INT) AS DealNo
   FROM eDeal.INFORMATION_SCHEMA.TABLES
   WHERE TABLE_NAME LIKE 'Deal%' AND ISNUMERIC(SUBSTRING(TABLE_NAME, 5, 8)) = 1)


GO
