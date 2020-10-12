SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure rpt_DealInventoryPaper

   Author: Terry Watkins - 07-08-2004

  Purpose: Retrieve data for the 'Inventory Report - Millennium'

Arguments: @DealNo - Deal Number to report on or 0 for all Deals


Change Log

Who           When           Database Version
  Description
--------------------------------------------------------------------------------
Terry Watkins 10-08-2003
  Initial coding

Terry Watkins 03-29-2005     v4.0.1
  Added @ShowClosedDeals argument to control whether closed deals are included
  in the resultset.

Terry Watkins 06-20-2005     v4.1.4
  Filtered out Deals that are not setup.

Terry Watkins 06-20-2005     v5.0.2
  Renamed rpt_InventoryByDeal_MD to rpt_DealInventoryPaper

Terry Watkins 06-20-2005     v3.0.6 (LotteryRetail)
  Added retrieval of the Game Description of the Deal.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_DealInventoryPaper] @DealNo Integer, @ShowClosedDeals Bit = 0
AS

SELECT
   di.DEAL_NO            AS DEAL_NO,
   di.ROLL_NO            AS ROLL_NO,
   ms.CASINO_MACH_NO     AS MACH_NO,
   di.FIRST_PLAY         AS FIRST_TRAN,
   di.LAST_PLAY          AS LAST_TRAN,
   ds.TABS_PER_ROLL      AS TABS_PER_ROLL,
   ds.NUMB_ROLLS         AS NUMB_ROLLS,
   ds.DEAL_DESCR         AS DEAL_DESC,
   di.PLAY_COUNT         AS TABS_DISPENSED,
   gs.GAME_DESC          AS GAME_DESC
FROM DEAL_INVENTORY di
   JOIN DEAL_SETUP     ds ON ds.DEAL_NO = di.DEAL_NO
   JOIN MACH_SETUP     ms ON di.MACH_NO = ms.MACH_NO
   JOIN dbo.GAME_SETUP gs ON ds.GAME_CODE = gs.GAME_CODE
WHERE
   (di.DEAL_NO = @DealNo OR @DealNo = 0) AND
   (ds.NUMB_ROLLS IS NOT NULL )          AND
   (ds.TABS_PER_ROLL IS NOT NULL )       AND
   (ds.IS_OPEN <> @ShowClosedDeals OR @ShowClosedDeals = 1)
ORDER BY di.DEAL_NO, di.ROLL_NO
GO
