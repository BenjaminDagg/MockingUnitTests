SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Weekly_PPP_Revenue_By_Game user stored procedure.

Created: 09/22/2003 by Chris Coddington

Purpose: Returns summarized data for the report Weekly Revenue by Game report
         (cr_Weekly_PPP_RevenueByGame_Report).

Arguments: @StartDate:  Starting ACCT_DATE for the resultset


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Chris C.      10-30-2003
  Modified @StartDate by stripping out the time.

Terry Watkins 12-02-2003
  Changed WHERE Clause to use ACCT_DATE (was DTIMESTAMP).

Terry Watkins 03-08-2004
  The data is retrieved from MACHINE_STATS table instead of CASINO_TRANS.

Terry Watkins 03-26-2008     6.0.2
  Removed gt.PRODUCT_ID = 0 from the WHERE clause.
  CostPerTab and Denomination are now retrieved from the CASINO_FORMS table
  instead of the DEAL_SETUP table (less likely to cause problems if the forms
  are updated but the deals are not).
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Weekly_PPP_Revenue_By_Game] @StartDate DateTime
AS

-- Variable Declaration
DECLARE @EndDate    DateTime
   
-- Suppress return of message data.
SET NOCOUNT ON

-- Make Monday the first day of the week.
SET DATEFIRST 1
   
-- Set End date, add 6 days to the @StartDate to cover 1 week.
SET @EndDate = DATEADD(Day, 6, @StartDate)
   
SELECT
   ms.CASINO_MACH_NO     AS MachNo,
   p.PRODUCT_ID          AS ProductID,
   p.PRODUCT_DESCRIPTION AS ProductDesc,
   cf.DENOMINATION       AS Denomination,
   cf.COST_PER_TAB       AS CostPerTab,
   gs.GAME_CODE          AS GameCode,
   gs.GAME_DESC          AS GameCodeDesc,
   gt.GAME_TYPE_CODE     AS GameTypeCode,
   gt.LONG_NAME          AS GameTypeLongName,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE) WHEN 1 THEN ms.PLAY_COUNT ELSE 0 END) AS Monday,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE) WHEN 2 THEN ms.PLAY_COUNT ELSE 0 END) AS Tuesday,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE) WHEN 3 THEN ms.PLAY_COUNT ELSE 0 END) AS Wednesday,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE) WHEN 4 THEN ms.PLAY_COUNT ELSE 0 END) AS Thursday,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE) WHEN 5 THEN ms.PLAY_COUNT ELSE 0 END) AS Friday,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE) WHEN 6 THEN ms.PLAY_COUNT ELSE 0 END) AS Saturday,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE) WHEN 7 THEN ms.PLAY_COUNT ELSE 0 END) AS Sunday
FROM MACHINE_STATS ms
   JOIN GAME_SETUP   gs ON ms.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE    gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN DEAL_SETUP   ds ON ms.DEAL_NO = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
   JOIN PRODUCT       p ON gt.PRODUCT_ID = p.PRODUCT_ID
WHERE
   ACCT_DATE BETWEEN @StartDate AND @EndDate AND
   ms.DEAL_NO > 0                            AND
   cf.IS_REV_SHARE = 0
GROUP BY
   ms.CASINO_MACH_NO,
   p.PRODUCT_ID,
   p.PRODUCT_DESCRIPTION,
   cf.DENOMINATION,
   cf.COST_PER_TAB,
   gs.GAME_CODE,
   gs.GAME_DESC,
   gt.GAME_TYPE_CODE,
   gt.LONG_NAME
GO
