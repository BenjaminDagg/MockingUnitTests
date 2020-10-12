SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Weekly_Machine_Status user stored procedure.

  Created:04/25/2005 by Nataly Mogilevsky

  Purpose: Returns summarized data from MACHINE_STATS Table for the report
           cr_Weekly_Machine_Status for a period of 1 week with a breakdown by day.

Arguments:    @StartDate: Starting Accounting Date for the resultset.
           
Change Log:

Changed By        Date        Database version
  Change Description
--------------------------------------------------------------------------------
Nataly Mogilevsky 04-26-2005  v4.2.2
  Initial coding

Terry Watkins     2010-06-10  v7.2.2
  Removed check for Millennium machines and attempt to get the denomination of
  the machine from the MACH_SETUP.MACH_DENOM column which has been removed.

Terry Watkins     2010-11-29  v7.2.4
  Changed Machine number from MACH_NO to CASINO_MACH_NO + (MACH_NO)
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Weekly_Machine_Status] @StartDate DateTime
AS
-- Variable Declaration
DECLARE @EndDate             DateTime
DECLARE @DenomRange          VarChar(32)
DECLARE @MaxDenom            SmallMoney
DECLARE @MinDenom            SmallMoney
DECLARE @GameCode            VarChar(3)
DECLARE @GameTypeCode        VarChar(2)
   
DECLARE @DGE_MachineNbr      Char(5)


SET NOCOUNT ON
SET DATEFIRST 1
-- Make EndDate 6 days more than the StartDate to cover 1 week.
SET @EndDate = DATEADD(Day, 6, @StartDate)
   
-- Select data into #WeeklyRevShareByGame temp table.
SELECT
   ms.MACH_NO                   AS DGE_MachineNbr,
   ms.CASINO_MACH_NO            AS Casino_MachineNbr,
   ms.GAME_CODE                 AS GameCode,
   p.PRODUCT_ID                 AS ProductID,
   p.PRODUCT_DESCRIPTION        AS ProductDesc,
   gs.GAME_DESC                 AS GameCodeDesc,
   gt.GAME_TYPE_CODE            AS GameTypeCode,
   ds.DENOMINATION              AS MinDenom,
   '$' + CONVERT(VarChar(32), ds.DENOMINATION, 0)  AS DenomRange,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
      WHEN 1 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0) 
             ELSE 0 END) AS Day1_Net,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
      WHEN 2 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0) 
             ELSE 0 END) AS Day2_Net,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
      WHEN 3 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0) 
             ELSE 0 END) AS Day3_Net,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
      WHEN 4 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0) 
             ELSE 0 END) AS Day4_Net,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
      WHEN 5 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0) 
             ELSE 0 END) AS Day5_Net,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
      WHEN 6 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0) 
             ELSE 0 END) AS Day6_Net,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
      WHEN 7 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0) 
             ELSE 0 END) AS Day7_Net 
INTO #WeeklyRevShareByGame
FROM MACHINE_STATS ms
   JOIN GAME_SETUP   gs ON ms.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE    gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN DEAL_SETUP   ds ON ms.DEAL_NO = ds.DEAL_NO
   JOIN PRODUCT      p  ON gt.PRODUCT_ID = p.PRODUCT_ID
WHERE
   ms.ACCT_DATE BETWEEN @StartDate AND @EndDate --AND ms.DEAL_NO > 0
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
DECLARE WRSRevByGame CURSOR
FOR
SELECT
   DGE_MachineNbr,
   GameTypeCode,
   GameCode
FROM #WeeklyRevShareByGame

-- Open the WRSRevByGame cursor.
OPEN WRSRevByGame
-- Get the first row of data.
FETCH FROM WRSRevByGame INTO @DGE_MachineNbr, @GameTypeCode, @GameCode
WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- FETCH was successful.
      -- Get denom range from DENOM_TO_GAME_TYPE.DENOM_VALUE
      SELECT
         @MinDenom = MIN(DENOM_VALUE),
         @MaxDenom = MAX(DENOM_VALUE)
      FROM DENOM_TO_GAME_TYPE WHERE GAME_TYPE_CODE = @GameTypeCode
      
      IF (@MinDenom = @MaxDenom)
         SET @DenomRange = '$' + CONVERT(VarChar(12), @MinDenom, 0)
      ELSE
         SET @DenomRange = '$' + CONVERT(VarChar(12), @MinDenom, 0) +
                       ' to $' + CONVERT(VarChar(12), @MaxDenom, 0)
      
      UPDATE #WeeklyRevShareByGame SET
          DenomRange = @DenomRange,
          MinDenom   = @MinDenom
      WHERE CURRENT OF WRSRevByGame
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM WRSRevByGame INTO @DGE_MachineNbr, @GameTypeCode, @GameCode
   END

-- Close and Deallocate the Cursor...
CLOSE WRSRevByGame
DEALLOCATE WRSRevByGame

-- Select the data to be returned for the report.
SELECT
   Casino_MachineNbr + ' (' + DGE_MachineNbr + ')' AS MachineNo,
   ProductDesc,
   GameCode,
   GameCodeDesc,
   MinDenom,
   DenomRange,
   SUM(Day1_Net)      AS Net1,
   SUM(Day2_Net)      AS Net2,
   SUM(Day3_Net)      AS Net3,
   SUM(Day4_Net)      AS Net4,
   SUM(Day5_Net)      AS Net5,
   SUM(Day6_Net)      AS Net6,
   SUM(Day7_Net)      AS Net7
FROM #WeeklyRevShareByGame
GROUP BY DGE_MachineNbr, Casino_MachineNbr, ProductDesc, GameCode, GameCodeDesc, MinDenom, DenomRange 
ORDER BY ProductDesc, Casino_MachineNbr, DGE_MachineNbr, GameCode
GO
