SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Monthly_Revenue_By_Game user stored procedure.

  Created: 04/12/2004 by Terry Watkins

  Purpose: Returns summarized data from MACHINE_STATS Table for the report
           cr_Monthly_Revenue_By_Game for a 1 month period.

Arguments: @MonthValue: Month to report on.
            @YearValue: Year to report on.

Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
Terry Watkins 04-12-2004 Initial coding

--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[rpt_Monthly_Revenue_By_Game] @MonthValue Int, @YearValue Int

AS
-- Variable Declaration
DECLARE @EndDate           DateTime
DECLARE @StartDate         DateTime

DECLARE @DenomRange        VarChar(32)
DECLARE @GameTypeCode      VarChar(2)
   
DECLARE @DGE_MachineNbr    Char(5)

DECLARE @MaxDenom          SmallMoney
DECLARE @MinDenom          SmallMoney


-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Set the Start Date to the first day of the month and year specified.
SET @StartDate = CAST(@YearValue AS VarChar(4)) + '-' + CAST(@MonthValue AS VarChar(2)) + '-01'
-- Make EndDate the last day of the month.
SET @EndDate = DATEADD(Month, 1, @StartDate) - 1

--PRINT 'Start Date: ' + CONVERT(VarChar(32), @StartDate, 101)
--PRINT 'End Date: ' + CONVERT(VarChar(32), @EndDate, 101)

-- Select data into #MonthlyRevByGame temp table.
SELECT
   ms.LOCATION_ID                                 AS LocationID,
   cas.CAS_NAME                                   AS LocationName,
   ms.MACH_NO                                     AS DGE_MachineNbr,
   ms.CASINO_MACH_NO                              AS Casino_MachineNbr,
   ms.GAME_CODE                                   AS GameCode,
   gs.GAME_DESC                                   AS GameCodeDesc,
   gt.GAME_TYPE_CODE                              AS GameTypeCode,
   ds.DENOMINATION                                AS MinDenom,
   '$' + CONVERT(VarChar(32), ds.DENOMINATION, 0) AS DenomRange,
   SUM(ms.AMOUNT_PLAYED)                          AS AmountPlayed,
   SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT)         AS AmountWon,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Played') AS HeaderAmountPlayed,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Won') AS HeaderAmountWon,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Net Revenue') AS HeaderNetRevenue
INTO #MonthlyRevByGame
FROM MACHINE_STATS ms
   JOIN CASINO      cas ON ms.LOCATION_ID = cas.LOCATION_ID
   JOIN GAME_SETUP   gs ON ms.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE    gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN DEAL_SETUP   ds ON ms.DEAL_NO = ds.DEAL_NO
WHERE
   ms.ACCT_DATE BETWEEN @StartDate AND @EndDate
GROUP BY
   ms.LOCATION_ID,
   cas.CAS_NAME ,
   ms.MACH_NO,
   ms.CASINO_MACH_NO,
   ms.GAME_CODE,
   gs.GAME_DESC,
   gt.GAME_TYPE_CODE,
   ds.DENOMINATION

-- Declare a cursor to move through the rows in the temp table.
DECLARE MonthlyRevByGame CURSOR
FOR
SELECT
   DGE_MachineNbr,
   GameTypeCode
FROM #MonthlyRevByGame

-- Open the DealTabsTotal cursor.
OPEN MonthlyRevByGame
-- Get the first row of data.
FETCH FROM MonthlyRevByGame INTO @DGE_MachineNbr, @GameTypeCode
WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- FETCH was successful.
      -- Get denom range from DENOM_TO_GAME_TYPE.DENOM_VALUE
      SELECT
         @MinDenom = MIN(DENOM_VALUE),
         @MaxDenom = MAX(DENOM_VALUE)
      FROM DENOM_TO_GAME_TYPE
      WHERE GAME_TYPE_CODE = @GameTypeCode
      
      -- Build the Denom Range string...
      SET @DenomRange = '$' + CONVERT(VarChar(8), @MinDenom)
      IF @MaxDenom <> @MinDenom
         SET @DenomRange = @DenomRange + ' to $' + CONVERT(VarChar(8), @MaxDenom)
      
      -- Update DenomRange and MinDenom columns in the temp table.
      UPDATE #MonthlyRevByGame SET
         DenomRange = @DenomRange,
         MinDenom   = @MinDenom
      WHERE CURRENT OF MonthlyRevByGame
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM MonthlyRevByGame INTO @DGE_MachineNbr, @GameTypeCode
   END

-- Close and Deallocate the Cursor...
CLOSE MonthlyRevByGame
DEALLOCATE MonthlyRevByGame

-- Select the data to be returned for the report.
SELECT
   LocationID,
   LocationName,
   DGE_MachineNbr    AS DGEMachineNo,
   Casino_MachineNbr AS CasinoMachineNo,
   GameCode,
   GameCodeDesc,
   MinDenom,
   DenomRange,
   SUM(AmountPlayed) AS AmountPlayed,
   SUM(AmountWon)    AS AmountWon,
   HeaderAmountPlayed,
   HeaderAmountWon,
   HeaderNetRevenue
FROM #MonthlyRevByGame
GROUP BY LocationID, LocationName, DGE_MachineNbr, Casino_MachineNbr, GameCode, GameCodeDesc, MinDenom, DenomRange,HeaderAmountPlayed, HeaderAmountWon, HeaderNetRevenue
ORDER BY LocationID, LocationName, DGE_MachineNbr, Casino_MachineNbr, GameCode, MinDenom

-- Clean up.
DROP TABLE #MonthlyRevByGame
GO
GRANT EXECUTE ON  [dbo].[rpt_Monthly_Revenue_By_Game] TO [SSRS]
GO
