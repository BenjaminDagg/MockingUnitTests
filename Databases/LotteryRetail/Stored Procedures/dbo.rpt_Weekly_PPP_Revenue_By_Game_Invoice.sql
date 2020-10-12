SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Weekly_PPP_Revenue_By_Game_Invoice user stored procedure.

Created: 09/22/2003 by Chris Coddington

Purpose: Returns summarized data from Casino_Trans Table for the report
         cr_Weekly_PPP_RevenueByGame_Report

Arguments: @StartDate:  Starting DateTime for the resultset


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Chris C.      10-30-2003
  Modified @StartDate by stripping out the time.

Terry Watkins 12-02-2003
  Changed WHERE Clause to use ACCT_DATE (was DTIMESTAMP).

Terry Watkins 03-09-2004
  The data is retrieved from MACHINE_STATS table instead of CASINO_TRANS.

Terry Watkins 03-26-2008     6.0.2
  Removed gt.PRODUCT_ID = 0 from the WHERE clause.
  CostPerTab and Denomination are now retrieved from the CASINO_FORMS table
  instead of the DEAL_SETUP table (less likely to cause problems if the forms
  are updated but the deals are not).
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Weekly_PPP_Revenue_By_Game_Invoice] @StartDate DateTime
AS

-- Variable Declaration
DECLARE @EndDate        DateTime
   
-- Suppress return of unwanted informational data.
SET NOCOUNT ON

-- Add 6 days to the StartDate to cover a one week period.   
SET @EndDate = DATEADD(Day, 6, @StartDate)
   
-- Retrieve data into a temp table.
SELECT
   ms.MACH_NO             AS MachNo,
   p.PRODUCT_ID           AS ProductID,
   p.PRODUCT_DESCRIPTION  AS ProductDesc,
   cf.DENOMINATION        AS Denomination,
   cf.COST_PER_TAB        AS CostPerTab,
   gs.GAME_CODE           AS GameCode,
   gs.GAME_DESC           AS GameCodeDesc,
   gt.GAME_TYPE_CODE      AS GameTypeCode,
   gt.LONG_NAME           AS GameTypeLongName,
   SUM(ms.PLAY_COUNT)     AS TabCount
INTO #rpt_Weekly_PPP_Revenue_By_Game_Invoice
FROM MACHINE_STATS ms
   JOIN DEAL_SETUP   ds ON ms.DEAL_NO        = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON ds.FORM_NUMB      = cf.FORM_NUMB
   JOIN GAME_SETUP   gs ON ds.GAME_CODE      = gs.GAME_CODE
   JOIN GAME_TYPE    gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN PRODUCT       p ON gt.PRODUCT_ID     = p.PRODUCT_ID
WHERE
   ms.ACCT_DATE BETWEEN @StartDate AND @EndDate AND
   ms.DEAL_NO > 0                               AND
   cf.IS_REV_SHARE = 0
GROUP BY
   p.PRODUCT_ID, 
   p.PRODUCT_DESCRIPTION, 
   gt.GAME_TYPE_CODE,
   gt.LONG_NAME,
   gs.GAME_CODE,
   gs.GAME_DESC,
   ms.MACH_NO,
   cf.DENOMINATION,
   cf.COST_PER_TAB

SELECT
   COUNT(MachNo) AS MachineCount,
   ProductID,
   ProductDesc,
   GameCode,
   GameCodeDesc,
   GameTypeCode,
   GameTypeLongName,
   Denomination,
   CostPerTab,
   SUM(TabCount) AS Tabs
FROM #rpt_Weekly_PPP_Revenue_By_Game_Invoice
GROUP BY
   ProductID,
   ProductDesc,
   GameTypeCode,
   GameTypeLongName,
   GameCode,
   GameCodeDesc,
   Denomination,
   CostPerTab
ORDER BY
   GameTypeLongName,
   GameCodeDesc,
   Denomination
GO
