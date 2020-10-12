SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: Recommend_Deal_For_Close  user stored procedure.

  Created: 01/09/2003 by Norm Symonds

  Purpose: Sets the CLOSE_RECOMMENDED flag on a Deal record in the DEAL_SETUP table if:
           1. The Deal is Open (IS_OPEN flag is true) AND

           2a. The Deal is 98% played out or more and there has been no play on the Deal for 10 days OR
           2b. There has been no play on the Deal for 30 days

  Method: Does an update of the CLOSE_RECOMMENDED Flag upon reviewing the DEAL_SETUP 
          and DEAL_STATS records for each Deal

Arguments: None

--------------------------------------------------------------------------------
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Norm Symonds  01-09-2003
  Initial Coding

Terry Watkins 08-21-2007     v6.0.1
  Modified to exclude update of Deals that are Bingo deals
--------------------------------------------------------------------------------
*/
-- drop proc Recommend_Deal_For_Close 

CREATE PROCEDURE [dbo].[Recommend_Deal_For_Close] 
AS

-- Local variable declarations...
DECLARE @Current_Date  AS DateTime

SET @Current_Date = (SELECT MAX(DTIMESTAMP) FROM CASINO_TRANS)

-- First, clear the CLOSE_RECOMMENDED flag where the current value is set and
-- the Deal is not closed.  This will reset the flag if a deal is reopened. 
UPDATE DEAL_SETUP SET CLOSE_RECOMMENDED = 0 WHERE IS_OPEN = 1 AND CLOSE_RECOMMENDED = 1

-- Now, set the CLOSE_RECOMMENDED flag on the appropriate Deals
UPDATE DEAL_SETUP SET CLOSE_RECOMMENDED = 1
WHERE DEAL_NO IN 
   (SELECT ds.DEAL_NO
    FROM DEAL_SETUP ds
       JOIN CASINO_FORMS cf ON cf.FORM_NUMB = ds.FORM_NUMB
       JOIN GAME_TYPE    gt ON gt.GAME_TYPE_CODE = cf.GAME_TYPE_CODE
       JOIN DEAL_STATS  dst ON dst.DEAL_NO = ds.DEAL_NO
    WHERE
       (ds.IS_OPEN = 1)    AND
       (gt.PRODUCT_ID < 3) AND
       ((dst.PLAY_COUNT * 1.0 / (ds.NUMB_ROLLS * ds.TABS_PER_ROLL) > 0.98 AND
         DATEDIFF(day, dst.LAST_PLAY, @Current_Date) >= 10) OR
         DATEDIFF(day, dst.LAST_PLAY, @Current_Date) >= 30))
GO
