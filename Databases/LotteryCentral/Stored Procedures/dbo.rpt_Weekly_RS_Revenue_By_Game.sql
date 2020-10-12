SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Weekly_RS_Revenue_By_Game user stored procedure.

  Created: 03/02/2003 by Terry Watkins

  Purpose: Returns summarized data from MACHINE_STATS Table for the report
           cr_Weekly_RS_Revenue_By_Game for a period of 1 week.

Arguments:    @StartDate: Starting Accounting Date for the resultset.
           @FdowIsMonday: True (1) if Monday is the first day of week,
                          False (0) if Sunday is the the first day of week.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-02-2004
  Initial coding

Terry Watkins 04-07-2004
  Modified to allow the first day to be Sunday or Monday.

Terry Watkins 05-05-2005     v4.1.1
  Added number of days played so we can accurately calculate report averages.

Terry Watkins 06-02-2005     v4.1.4
  Changed the ORDER BY clause of the final select so the Reporting Services
  report works correctly.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[rpt_Weekly_RS_Revenue_By_Game] @StartDate DateTime

AS
-- Variable Declaration
DECLARE @EndDate           DateTime
DECLARE @FirstPlay         DateTime

DECLARE @DenomRange        VarChar(32)
DECLARE @GameCode          VarChar(3)
DECLARE @GameTypeCode      VarChar(2)
   
DECLARE @DGE_MachineNbr    Char(5)

DECLARE @DaysPlayed        INT
DECLARE @FDOW              INT

DECLARE @MaxDenom          SmallMoney
DECLARE @MinDenom          SmallMoney

SET NOCOUNT ON
   
-- Make EndDate 6 days more than the StartDate to cover 1 week.
SET @EndDate = DATEADD(Day, 6, @StartDate)

-- Get and set the first day of the week.
SELECT @FDOW = ItemValueInt FROM dbo.AppSetting WHERE ItemKey = 'FirstDayOfWeek'
IF @FDOW = 0 SET @FDOW = 7

SET DATEFIRST @FDOW

-- Select data into #WeeklyRevShareByGame temp table.
SELECT
   ms.LOCATION_ID          AS LocationID,
   cas.CAS_NAME            AS LocationName, 
   ms.MACH_NO              AS DGE_MachineNbr,
   ms.CASINO_MACH_NO       AS Casino_MachineNbr,
   ms.GAME_CODE            AS GameCode,
   gs.GAME_DESC            AS GameCodeDesc,
   gt.GAME_TYPE_CODE       AS GameTypeCode,
   ds.DENOMINATION         AS MinDenom,
   CAST(7 AS SmallInt)     AS DaysPlayed,
   '$' + CONVERT(VarChar(32), ds.DENOMINATION, 0)  AS DenomRange,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
       WHEN 1 THEN AMOUNT_PLAYED - AMOUNT_WON - AMOUNT_JACKPOT
       ELSE 0 END) AS Day1,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
       WHEN 2 THEN AMOUNT_PLAYED - AMOUNT_WON - AMOUNT_JACKPOT
       ELSE 0 END) AS Day2,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
       WHEN 3 THEN AMOUNT_PLAYED - AMOUNT_WON - AMOUNT_JACKPOT
       ELSE 0 END) AS Day3,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
       WHEN 4 THEN AMOUNT_PLAYED - AMOUNT_WON - AMOUNT_JACKPOT
       ELSE 0 END) AS Day4,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
       WHEN 5 THEN AMOUNT_PLAYED - AMOUNT_WON - AMOUNT_JACKPOT
       ELSE 0 END) AS Day5,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
       WHEN 6 THEN AMOUNT_PLAYED - AMOUNT_WON - AMOUNT_JACKPOT
       ELSE 0 END) AS Day6,
   SUM(CASE DATEPART(dw, ms.ACCT_DATE)
       WHEN 7 THEN AMOUNT_PLAYED - AMOUNT_WON - AMOUNT_JACKPOT
       ELSE 0 END) AS Day7
INTO #WeeklyRevShareByGame
FROM MACHINE_STATS ms
   JOIN dbo.CASINO  cas ON ms.LOCATION_ID = cas.LOCATION_ID
   JOIN GAME_SETUP   gs ON ms.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE    gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN DEAL_SETUP   ds ON ms.DEAL_NO = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
WHERE
   ms.ACCT_DATE BETWEEN @StartDate AND @EndDate AND
   cf.IS_REV_SHARE = 1
GROUP BY
   ms.LOCATION_ID,
   cas.CAS_NAME, 
   ms.MACH_NO,
   ms.CASINO_MACH_NO,
   ms.GAME_CODE,
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


-- Open the DealTabsTotal cursor.
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
      FROM DENOM_TO_GAME_TYPE
      WHERE GAME_TYPE_CODE = @GameTypeCode
            
      -- Build the Denom Range string...
      SET @DenomRange = '$' + CONVERT(VarChar(8), @MinDenom)
      IF @MaxDenom <> @MinDenom
         SET @DenomRange = @DenomRange + ' to $' + CONVERT(VarChar(8), @MaxDenom)
            
     -- Update DenomRange and MinDenom columns in the temp table.
     UPDATE #WeeklyRevShareByGame SET
        DenomRange = @DenomRange,
        MinDenom   = @MinDenom
     WHERE CURRENT OF WRSRevByGame
     
         
     -- Get the first date this machine played this game within the last 2 weeks.
     SELECT @FirstPlay = MIN(ACCT_DATE)
     FROM MACHINE_STATS
     WHERE
        MACH_NO = @DGE_MachineNbr AND
        GAME_CODE = @GameCode     AND
        ACCT_DATE > DATEADD(Day, -14, @StartDate)
         
     -- Do we need to reset the number of play days?
     IF (@FirstPlay > @StartDate)
        -- Yes, so update the DaysPlayed value.
        BEGIN
           SET @DaysPlayed = DATEDIFF(Day, @FirstPlay, @EndDate) + 1
           UPDATE #WeeklyRevShareByGame SET DaysPlayed = @DaysPlayed WHERE CURRENT OF WRSRevByGame
        END
      
     -- Get the next row of the resultset.
     FETCH NEXT FROM WRSRevByGame INTO @DGE_MachineNbr, @GameTypeCode, @GameCode
   END

-- Close and Deallocate the Cursor...
CLOSE WRSRevByGame
DEALLOCATE WRSRevByGame

-- Select the data to be returned for the report.
SELECT
   LocationID,
   LocationName,
   DGE_MachineNbr AS DGEMachineNbr,
   Casino_MachineNbr AS CasinoMachineNo,
   GameCode,
   GameCodeDesc,
   MinDenom,
   DenomRange,
   SUM(Day1)    AS Day1,
   SUM(Day2)    AS Day2,
   SUM(Day3)    AS Day3,
   SUM(Day4)    AS Day4,
   SUM(Day5)    AS Day5,
   SUM(Day6)    AS Day6,
   SUM(Day7)    AS Day7,
   MIN(DaysPlayed) AS DaysPlayed
FROM #WeeklyRevShareByGame
GROUP BY LocationID, LocationName, DGE_MachineNbr, Casino_MachineNbr, GameCode, GameCodeDesc, MinDenom, DenomRange
ORDER BY LocationID, GameCode, MinDenom, Casino_MachineNbr
GO
GRANT EXECUTE ON  [dbo].[rpt_Weekly_RS_Revenue_By_Game] TO [SSRS]
GO
