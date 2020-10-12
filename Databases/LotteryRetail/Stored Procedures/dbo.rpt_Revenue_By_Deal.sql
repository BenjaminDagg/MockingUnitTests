SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Revenue_By_Deal user stored procedure.

  Created: 07/18/2002 by Norm Symonds and Terry Watkins  

  Purpose: Returns summarized data for the Revenue By Deal report

Arguments: @StartDate:  Starting Accounting Date for the resultset
           @EndDate:    Ending Accounting Date for the resultset


Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
2002-07-30 Terry Watkins
  Added TabsPerDeal to enable display of percent complete for each Deal on the
  Revenue By Deal report.

2002-08-02 Terry Watkins
  Added TabsTotal to enable display of percent complete up to the EndDate.  This
  was done to enable the report to be run on a daily basis instead of only for
  the entire date range in CASINO_TRANS.  The percent complete on the Revenue By
  Deal report now shows the value up to and including the EndDate.

2003-01-03 Norm Symonds
  Revamped Stored Procedure to gather information from the DAILY_DEAL_STATS
  table which stores the information in a summarized fashion. This was done to
  speed up the reports

2004-03-03 Terry Watkins
  Modified to retrieve report data from new MACHINE_STATS table instead of the
  DAILY_DEAL_STATS table.

2005-08-01 Terry Watkins     v4.1.9
  Modified the WHERE clause to filter out Deal Number 0 and Deals where the
  tabs per roll or number of rolls is null.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Revenue_By_Deal] (@StartDate SmallDateTime, @EndDate SmallDateTime)
AS

-- Variables for the cursors...
DECLARE @DealNumber      Integer 
DECLARE @TypeID          VarChar(10)
DECLARE @TabAmount       SmallMoney
DECLARE @DealTypeName    VarChar(48)
DECLARE @GameDesc        VarChar(64)
DECLARE @TabsDispensed   Integer
DECLARE @TabsPerDeal     Integer
DECLARE @WinningTabs     Integer
DECLARE @DollarsPlayed   Money
DECLARE @DollarsWon      Money
DECLARE @GameCode        VarChar(10)
DECLARE @NetAmount       Money
DECLARE @TabsForfeited   Integer
DECLARE @TabsTotal       Integer

-- Set NOCOUNT ON to suppress return of unwanted information.
SET NOCOUNT ON

-- Create a temporary table to store results
CREATE TABLE #DealRevenue (
   DealNumber     Integer     NOT NULL,
   TypeID         VarChar(10) NOT NULL,
   TabAmount      Smallmoney  NOT NULL,
   DealTypeName   VarChar(48) NULL,
   GameDesc       VarChar(64) NULL,      -- Game description
   TabsPerDeal    Integer     NOT NULL,  -- Number of Tabs per Deal
   TabsDispensed  Integer     NOT NULL,  -- Tabs dispensed between @StartDate and @EndDate
   TabsTotal      Integer     NOT NULL,  -- Total tabs dispensed since the inception of the deal
   WinningTabs    Integer     NOT NULL,  -- Number of winning tabs between @StartDate and @EndDate
   DollarsPlayed  Money       NOT NULL,  -- Dollars played for the deal between @StartDate and @EndDate
   DollarsWon     Money       NOT NULL,  -- Dollars won for the deal between @StartDate and @EndDate
   NetAmount      Money       NOT NULL,  -- Net Revenue for the deal between @StartDate and @EndDate
   TabsForfeited  Integer     NOT NULL   -- Number of forfeited tabs between @StartDate and @EndDate
)

ALTER TABLE #DealRevenue WITH NOCHECK ADD CONSTRAINT [PK_DEALREV_DEALNBR] PRIMARY KEY NONCLUSTERED ([DealNumber])

-- Declare a cursor to retrieve most of the deal information required for the report.
DECLARE DealRevenue CURSOR FAST_FORWARD
FOR
SELECT
   ms.DEAL_NO                     AS DealNumber,
   ds.TYPE_ID                     AS TypeID,
   ds.TAB_AMT                     AS TabAmount,
   SUM(ms.PLAY_COUNT)             AS TabsDispensed,
   ds.TABS_PER_ROLL * NUMB_ROLLS  AS TabsPerDeal,
   SUM(ms.AMOUNT_PLAYED)          AS DollarsPlayed,
   SUM(ms.AMOUNT_WON) + SUM(ms.AMOUNT_FORFEITED) + SUM(ms.AMOUNT_JACKPOT) AS DollarsWon,
   SUM(ms.WIN_COUNT)  + SUM(ms.FORFEIT_COUNT)    + SUM(ms.JACKPOT_COUNT)  AS WinningTabs,
   SUM(ms.FORFEIT_COUNT)          AS TabsForfeited
FROM MACHINE_STATS ms
   INNER JOIN DEAL_SETUP ds ON ms.DEAL_NO = ds.DEAL_NO
WHERE
   ms.ACCT_DATE BETWEEN @StartDate AND @EndDate AND
   ds.DEAL_NO > 0                               AND
   ds.NUMB_ROLLS IS NOT NULL                    AND
   ds.TABS_PER_ROLL IS NOT NULL                 AND
   ds.TYPE_ID IS NOT NULL
GROUP BY ds.TYPE_ID, ds.TAB_AMT, ms.DEAL_NO, ds.TABS_PER_ROLL, ds.NUMB_ROLLS
-- Open the cursor.
OPEN DealRevenue

-- Get the first row of data.
FETCH FROM DealRevenue INTO
   @DealNumber, @TypeID, @TabAmount, @TabsDispensed, @TabsPerDeal,
   @DollarsPlayed, @DollarsWon, @WinningTabs, @TabsForfeited

WHILE (@@FETCH_STATUS = 0)
   -- Successfully FETCHed a record, insert a row into the temp table if the TypeID is not null.
   BEGIN
      -- Calculate then Net Amount.
      SET @NetAmount = @DollarsPlayed - @DollarsWon

      -- Insert data into the temp table.
      INSERT INTO #DealRevenue
         (DealNumber, TypeID, TabAmount, DealTypeName, GameDesc, TabsPerDeal, TabsDispensed,
          TabsTotal, WinningTabs, DollarsPlayed, DollarsWon, NetAmount, TabsForfeited)
      VALUES
         (@DealNumber, @TypeID, @TabAmount, NULL, NULL, @TabsPerDeal, @TabsDispensed,
          0, @WinningTabs, @DollarsPlayed, @DollarsWon, @NetAmount, @TabsForfeited)

      -- Get the next row of the resultset.
      FETCH NEXT FROM DealRevenue INTO
         @DealNumber, @TypeID, @TabAmount, @TabsDispensed, @TabsPerDeal,
         @DollarsPlayed, @DollarsWon, @WinningTabs, @TabsForfeited
   END

-- Close and Deallocate Cursor
CLOSE DealRevenue
DEALLOCATE DealRevenue

-- Declare a cursor to retrieve the total number of tabs dispensed
-- for each deal, up to and including the EndDate.
DECLARE DealTabsTotal CURSOR FAST_FORWARD
FOR
SELECT
   ms.DEAL_NO         AS DealNumber,
   SUM(ms.PLAY_COUNT) AS TabsTotal
FROM MACHINE_STATS ms
   INNER JOIN DEAL_SETUP ds ON ms.DEAL_NO = ds.DEAL_NO
WHERE
   ms.ACCT_DATE <= @EndDate AND
   ds.TYPE_ID IS NOT NULL
GROUP BY ms.DEAL_NO

-- Open the DealTabsTotal cursor.
OPEN DealTabsTotal
-- Get the first row of data.
FETCH FROM DealTabsTotal INTO @DealNumber, @TabsTotal
WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- Successfully FETCHed a record, so update the TabsTotal column in the temp table...
      UPDATE #DealRevenue SET TabsTotal = @TabsTotal WHERE DealNumber = @DealNumber

      -- Get the next row of the resultset.
      FETCH NEXT FROM DealTabsTotal INTO @DealNumber, @TabsTotal
   END

-- Close and Deallocate the DealTabsTotal Cursor...
CLOSE DealTabsTotal
DEALLOCATE DealTabsTotal

-- Update the Deal Type and Game Description
UPDATE #DealRevenue SET
   DealTypeName = (SELECT dt.DEAL_TYPE_NAME FROM DEAL_TYPE dt WHERE dt.TYPE_ID = TypeID)

UPDATE #DealRevenue SET 
   GameDesc = (SELECT gs.GAME_DESC
               FROM GAME_SETUP gs, DEAL_SETUP ds
               WHERE ds.DEAL_NO = DealNumber AND gs.GAME_CODE = ds.GAME_CODE)

-- Now select all rows from the temp table as the returned recordset.
SELECT
   DealNumber, TypeID, TabAmount, DealTypeName, GameDesc,
   TabsPerDeal, TabsDispensed, TabsTotal, WinningTabs,
   DollarsPlayed, DollarsWon, NetAmount, TabsForfeited
FROM #DealRevenue
ORDER BY TypeID, TabAmount, GameDesc, DealNumber
GO
