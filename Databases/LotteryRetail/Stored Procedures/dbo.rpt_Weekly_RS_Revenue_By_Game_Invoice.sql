SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Weekly_RS_Revenue_By_Game_Invoice user stored procedure.

  Created: 03-06-2004 by Terry Watkins

  Purpose: Returns summarized data for Weekly RS Invoice report.

Arguments: @StartDate:  Starting DateTime for the resultset


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-06-2004
  Initial coding

Terry Watkins 07-27-2005     v4.1.8
  Added logic to add one more detail line for RevShare + PlayPerPlay locations.

Terry Watkins 02-23-2006
  Changed ' Tabs @ $' to ' Tabs Played @ $' (ogkw) for Miguel and Norm.

Andy Chen     11-02-2007     v6.0.1
  Modified select statement for PPP tabs played to select only paper tabs.
  Also fixed formatting problem of LineItem description for the Adjustment line.

Terry Watkins 06-17-2008     v6.0.2
  Final select limits LineItemDescription to 64 characters to prevent overflow
  in the invoice report.

Aldo Zamora   03-03-2010     v7.2.0
  Modified the summary select from the temp table to limit LineItemDescription to
  64 characters to prevent overflow in the invoice report.

Terry Watkins   2010-06-10   v7.2.2
  Removed check for Millennium machines and attempt to get the denomination of
  the machine from the MACH_SETUP.MACH_DENOM column which has been removed.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[rpt_Weekly_RS_Revenue_By_Game_Invoice] @StartDate DateTime
AS

-- Variable Declaration
DECLARE @IsRSandPPP     Bit

DECLARE @FDOW           INT
DECLARE @DealNbr        Int
DECLARE @TotalPlayCount Int

DECLARE @MaxDenom       SmallMoney
DECLARE @MinDenom       SmallMoney
DECLARE @PppAmount      SmallMoney

DECLARE @TabRevenue     Money

DECLARE @EndDate        DateTime

DECLARE @GameTypeCode   VarChar(2)
DECLARE @DenomRange     VarChar(32)
DECLARE @LineDesc       VarChar(96)
DECLARE @PlayCountText  VarChar(32)

-- Suppress return of message data.
SET NOCOUNT ON

-- Get first day of the week setting.
SELECT @FDOW = VALUE1
FROM dbo.CASINO_SYSTEM_PARAMETERS
WHERE PAR_ID = 'PARAM25'

SET DATEFIRST @FDOW

-- Add 6 days to starting date for the EndDate to cover 1 week.   
SET @EndDate = DATEADD(Day, 6, @StartDate)

-- First pass select...
SELECT
   p.PRODUCT_ID            AS ProductID,
   ms.GAME_CODE            AS GameCode,
   gs.GAME_DESC            AS GameCodeDesc,
   gt.GAME_TYPE_CODE       AS GameTypeCode,
   ms.DEAL_NO              AS DealNbr,
   CAST(0 AS SmallMoney)   AS MinDenom,
   CAST(0 AS VarChar(32))  AS DenomRange,
   cf.DGE_REV_PERCENT      AS RevPercent,
   SUM(AMOUNT_PLAYED - AMOUNT_WON - AMOUNT_JACKPOT) AS NetToCasino
INTO #WRSByGameInv
FROM MACHINE_STATS ms
   JOIN GAME_SETUP   gs ON ms.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE    gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN DEAL_SETUP   ds ON ms.DEAL_NO = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
   JOIN PRODUCT       p ON gt.PRODUCT_ID = p.PRODUCT_ID
WHERE
   ms.ACCT_DATE BETWEEN @StartDate AND @EndDate AND
   cf.IS_REV_SHARE = 1 AND
   ms.DEAL_NO > 0
GROUP BY
   p.PRODUCT_ID,
   ms.GAME_CODE,
   gs.GAME_DESC,
   gt.GAME_TYPE_CODE,
   ms.DEAL_NO,
   cf.DGE_REV_PERCENT
ORDER BY
   p.PRODUCT_ID,
   ms.GAME_CODE,
   ms.DEAL_NO


-- Declare a cursor to move through the rows in the temp table.
DECLARE WRSRevByGameInv CURSOR
FOR
SELECT
   DealNbr,
   GameTypeCode
FROM #WRSByGameInv

-- Open the DealTabsTotal cursor.
OPEN WRSRevByGameInv
-- Get the first row of data.
FETCH FROM WRSRevByGameInv INTO @DealNbr, @GameTypeCode
WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- FETCH was successful.
      -- Build denom range from DENOM_TO_GAME_TYPE.DENOM_VALUE
      SELECT
         @MinDenom = MIN(DENOM_VALUE),
         @MaxDenom = MAX(DENOM_VALUE)
      FROM DENOM_TO_GAME_TYPE
      WHERE GAME_TYPE_CODE = @GameTypeCode
      
      -- Build the Denom Range string.
      SET @DenomRange = '$' + CONVERT(VarChar(8), @MinDenom)
      IF @MinDenom <> @MaxDenom
         SET @DenomRange = @DenomRange + ' to $' + CONVERT(VarChar(8), @MaxDenom)
      
      -- Update DenomRange and MinDenom columns in the temp table.
      UPDATE #WRSByGameInv SET
         DenomRange = @DenomRange,
         MinDenom   = @MinDenom
      WHERE CURRENT OF WRSRevByGameInv
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM WRSRevByGameInv INTO @DealNbr, @GameTypeCode
   END

-- Close and Deallocate the Cursor...
CLOSE WRSRevByGameInv
DEALLOCATE WRSRevByGameInv

-- Now summarize the data in the temp table into a second temp table...
SELECT
   LEFT(DenomRange + ' ' + GameCodeDesc, 64) AS LineItemDescription,
   CAST(0 AS Int)                  AS MachineCount,
   SUM(NetToCasino)                AS WeeklyRevenue,
   RevPercent,
   GameCode,
   MinDenom,
   ProductID
INTO #WRSByGameSummary
FROM #WRSByGameInv
GROUP BY DenomRange, GameCode, GameCodeDesc, RevPercent, MinDenom, ProductID

-- We are done with the first temp table, so drop it.
DROP TABLE #WRSByGameInv

ALTER TABLE #WRSByGameSummary ALTER COLUMN LineItemDescription VarChar(64)

-- Update the Machine Counts
UPDATE #WRSByGameSummary
SET MachineCount = 
   (SELECT COUNT(DISTINCT CASINO_MACH_NO)
    FROM MACHINE_STATS
    WHERE
       ACCT_DATE BETWEEN @StartDate AND @EndDate AND
       GAME_CODE = #WRSByGameSummary.GameCode)
WHERE ProductID > 0

-- Check to see if we want to add a pay per play amount to the invoice...
SELECT @IsRSandPPP = RS_AND_PPP, @PppAmount = PPP_AMOUNT FROM CASINO WHERE SETASDEFAULT = 1

-- If RevShare plus RevPerTab then add one more line...
IF (@IsRSandPPP = 1)
   BEGIN
      -- Retrieve total number of tabs sold.
      SELECT @TotalPlayCount = ISNULL(SUM(PLAY_COUNT), 0)
      FROM MACHINE_STATS ms
         JOIN DEAL_SETUP   ds ON ms.DEAL_NO   = ds.DEAL_NO
         JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
      WHERE
         (ACCT_DATE BETWEEN @StartDate AND @EndDate) AND 
         (cf.IS_PAPER = 1)
      
      -- Calculate the tab revenue
      SET @TabRevenue = @TotalPlayCount * CAST(@PppAmount AS MONEY)
      
      -- Convert number of tabs sold to formatted text...
      -- Build the detail line description text.
      SET @PlayCountText = CONVERT(VARCHAR, CAST(@TotalPlayCount AS MONEY), 1)
      SET @LineDesc = LEFT(@PlayCountText, LEN(@PlayCountText) - 3) +
                      ' Paper Tabs Played @ $' + CONVERT(VARCHAR, @PppAmount, 2)
      
      -- Insert the PPP line into the summary table.
      INSERT INTO #WRSByGameSummary
         (LineItemDescription, MachineCount, WeeklyRevenue, RevPercent, GameCode, MinDenom, ProductID)
      VALUES
         (@LineDesc, 0, @TabRevenue, 100, 'PPP', 0, 99)
   END

-- Return the report data.
SELECT
   LEFT(LineItemDescription, 64) AS LineItemDescription,
   MachineCount,
   WeeklyRevenue,
   RevPercent,
   WeeklyRevenue * RevPercent / 100 AS AmountDue
FROM #WRSByGameSummary
ORDER BY ProductID, GameCode, LineItemDescription

GO
