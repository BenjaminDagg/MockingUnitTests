SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
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

DECLARE @ProductID         Int

DECLARE @MaxDenom          SmallMoney
DECLARE @MinDenom          SmallMoney


SET NOCOUNT ON

-- Set the Start Date to the first day of the month and year specified.
SET @StartDate = CAST(@YearValue AS VarChar(4)) + '-' + CAST(@MonthValue AS VarChar(2)) + '-01'
-- Make EndDate the last day of the month.
SET @EndDate = DATEADD(Month, 1, @StartDate) - 1


--PRINT 'Start Date: ' + CONVERT(VarChar(32), @StartDate, 101)
--PRINT 'End Date: ' + CONVERT(VarChar(32), @EndDate, 101)

-- Select data into #MonthlyRevByGame temp table.
SELECT
   ms.MACH_NO                                     AS DGE_MachineNbr,
   ms.CASINO_MACH_NO                              AS Casino_MachineNbr,
   ms.GAME_CODE                                   AS GameCode,
   p.PRODUCT_ID                                   AS ProductID,
   p.PRODUCT_DESCRIPTION                          AS ProductDesc,
   gs.GAME_DESC                                   AS GameCodeDesc,
   gt.GAME_TYPE_CODE                              AS GameTypeCode,
   ds.DENOMINATION                                AS MinDenom,
   '$' + CONVERT(VarChar(32), ds.DENOMINATION, 0) AS DenomRange,
   SUM(ms.AMOUNT_PLAYED)                          AS AmountPlayed,
   SUM(ms.AMOUNT_WON + ms.AMOUNT_JACKPOT)         AS AmountWon
INTO #MonthlyRevByGame
FROM MACHINE_STATS ms
   JOIN GAME_SETUP   gs ON ms.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE    gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN DEAL_SETUP   ds ON ms.DEAL_NO = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
   JOIN PRODUCT       p ON gt.PRODUCT_ID = p.PRODUCT_ID
WHERE
   ms.ACCT_DATE BETWEEN @StartDate AND @EndDate
GROUP BY
   ms.MACH_NO,
   ms.CASINO_MACH_NO,
   ms.GAME_CODE,
   p.PRODUCT_ID,
   p.PRODUCT_DESCRIPTION,
   gs.GAME_DESC,
   gt.GAME_TYPE_CODE,
   ds.DENOMINATION

-- Declare a cursor to move through the rows in the temp table.
DECLARE MonthlyRevByGame CURSOR
FOR
SELECT
   DGE_MachineNbr,
   GameTypeCode,
   ProductID
FROM #MonthlyRevByGame

-- Open the DealTabsTotal cursor.
OPEN MonthlyRevByGame
-- Get the first row of data.
FETCH FROM MonthlyRevByGame INTO @DGE_MachineNbr, @GameTypeCode, @ProductID
WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- FETCH was successful.
      -- Build the DenomRange column value based upon the ProductID.
      IF @ProductID > 0
         -- Non-Millennium Machine, get denom range from DENOM_TO_GAME_TYPE.DENOM_VALUE
         BEGIN
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
         END
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM MonthlyRevByGame INTO @DGE_MachineNbr, @GameTypeCode, @ProductID
   END

-- Close and Deallocate the Cursor...
CLOSE MonthlyRevByGame
DEALLOCATE MonthlyRevByGame

-- Select the data to be returned for the report.
SELECT
   Casino_MachineNbr AS MachineNo,
   ProductDesc,
   GameCode,
   GameCodeDesc,
   MinDenom,
   DenomRange,
   SUM(AmountPlayed) AS AmountPlayed,
   SUM(AmountWon)    AS AmountWon
FROM #MonthlyRevByGame
GROUP BY Casino_MachineNbr, ProductDesc, GameCode, GameCodeDesc, MinDenom, DenomRange
ORDER BY Casino_MachineNbr,ProductDesc, GameCode, MinDenom
GO
