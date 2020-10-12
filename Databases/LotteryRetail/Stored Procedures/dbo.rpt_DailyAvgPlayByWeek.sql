SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_DailyAvgPlayByWeek user stored procedure.

  Created: 12-14-2009 by Terry Watkins

  Purpose: Returns calculated Average Play Amount per machine for 6 month period
           starting from the specified AccountingDate.
           Data is retrieved from the MACHINE_STATS summary table.
           Average calculated using days played by machine per week.

Arguments: Accounting Date:
             This procedure will use the specified date if it is a Sunday.
             If not a Sunday, procedure will calculate the previous Sunday Date.
             The end date will be the day before the Sunday date. The starting
             date will be the Sunday date minus 26 weeks.

     Note: This procedure began as a clone of rpt_DailyAvgReveunueByWeek and
           was modified to return Play Amount data instead of Revenue data.


Change Log:

Changed By      Date         Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins   12-14-2009   v7.0.0
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_DailyAvgPlayByWeek] @AccountDate DateTime
AS

DECLARE @GameDesc          VarChar(64)
DECLARE @GameCode          VarChar(3)
DECLARE @GameTypeCode      VarChar(2)
DECLARE @MachineNbr        VarChar(5)

DECLARE @EndDate           DateTime
DECLARE @EndWeek           DateTime
DECLARE @WeeksEndPeriod    DateTime
DECLARE @WeeksStartPeriod  DateTime
DECLARE @StartDate         DateTime

DECLARE @PlayDays          SmallInt
DECLARE @PlayDays01        SmallInt
DECLARE @PlayDays02        SmallInt
DECLARE @PlayDays03        SmallInt
DECLARE @PlayDays04        SmallInt
DECLARE @PlayDays05        SmallInt
DECLARE @PlayDays06        SmallInt
DECLARE @PlayDays07        SmallInt
DECLARE @PlayDays08        SmallInt
DECLARE @PlayDays09        SmallInt
DECLARE @PlayDays10        SmallInt
DECLARE @PlayDays11        SmallInt
DECLARE @PlayDays12        SmallInt
DECLARE @PlayDays13        SmallInt
DECLARE @PlayDays14        SmallInt
DECLARE @PlayDays15        SmallInt
DECLARE @PlayDays16        SmallInt
DECLARE @PlayDays17        SmallInt
DECLARE @PlayDays18        SmallInt
DECLARE @PlayDays19        SmallInt
DECLARE @PlayDays20        SmallInt
DECLARE @PlayDays21        SmallInt
DECLARE @PlayDays22        SmallInt
DECLARE @PlayDays23        SmallInt
DECLARE @PlayDays24        SmallInt
DECLARE @PlayDays25        SmallInt
DECLARE @PlayDays26        SmallInt
DECLARE @PlayDays1_26      Int

DECLARE @WeekNumber        Int

DECLARE @AmountPlayed01    Money
DECLARE @AmountPlayed02    Money
DECLARE @AmountPlayed03    Money
DECLARE @AmountPlayed04    Money
DECLARE @AmountPlayed05    Money
DECLARE @AmountPlayed06    Money
DECLARE @AmountPlayed07    Money
DECLARE @AmountPlayed08    Money
DECLARE @AmountPlayed09    Money
DECLARE @AmountPlayed10    Money
DECLARE @AmountPlayed11    Money
DECLARE @AmountPlayed12    Money
DECLARE @AmountPlayed13    Money
DECLARE @AmountPlayed14    Money
DECLARE @AmountPlayed15    Money
DECLARE @AmountPlayed16    Money
DECLARE @AmountPlayed17    Money
DECLARE @AmountPlayed18    Money
DECLARE @AmountPlayed19    Money
DECLARE @AmountPlayed20    Money
DECLARE @AmountPlayed21    Money
DECLARE @AmountPlayed22    Money
DECLARE @AmountPlayed23    Money
DECLARE @AmountPlayed24    Money
DECLARE @AmountPlayed25    Money
DECLARE @AmountPlayed26    Money
DECLARE @AmountPlayed1_26  Money


SET NOCOUNT ON
SET DATEFIRST 1

-- Set @WeeksEndPeriod.
SET @WeeksEndPeriod = DATEADD(yyyy, DATEPART(yyyy, DATEADD(weekday, 1 - DATEPART(weekday, @AccountDate), @AccountDate)) - 1900, 0) +
                      DATEADD(dy, DATEPART(dy, DATEADD(weekday, 1 - DATEPART(weekday, @AccountDate), @AccountDate)) - 1, 0)
SET @WeeksStartPeriod = DATEADD(week, -26, @WeeksEndPeriod)
SET @EndDate = DATEADD(Day, -1, @WeeksEndPeriod)

-- Cursor Declaration to retrieve machines that have had activity.
DECLARE MachineList CURSOR FAST_FORWARD
FOR
SELECT DISTINCT MACH_NO, GAME_CODE
FROM MACHINE_STATS
WHERE
   MACH_NO <> '0' AND
   ACCT_DATE BETWEEN @WeeksStartPeriod AND @EndDate
ORDER BY GAME_CODE, MACH_NO

-- Create a temporary table to store results
CREATE TABLE #MonthlyRevenueByGame  (
  GameCode         VarChar(3),
  GameTypeCode     VarChar(2),
  GameDesc         VarChar(64),
  MachineNbr       VarChar(5),
  AmountPlayed01   Money,
  AmountPlayed02   Money,
  AmountPlayed03   Money,
  AmountPlayed04   Money,
  AmountPlayed05   Money,
  AmountPlayed06   Money,  AmountPlayed07   Money,
  AmountPlayed08   Money,
  AmountPlayed09   Money,
  AmountPlayed10   Money,
  AmountPlayed11   Money,
  AmountPlayed12   Money,
  AmountPlayed13   Money,
  AmountPlayed14   Money,
  AmountPlayed15   Money,
  AmountPlayed16   Money,
  AmountPlayed17   Money,
  AmountPlayed18   Money,
  AmountPlayed19   Money,
  AmountPlayed20   Money,
  AmountPlayed21   Money,
  AmountPlayed22   Money,
  AmountPlayed23   Money,
  AmountPlayed24   Money,
  AmountPlayed25   Money,
  AmountPlayed26   Money,
  AmountPlayed1_26 Money,
  PlayDays01       SmallInt,
  PlayDays02       SmallInt,
  PlayDays03       SmallInt,
  PlayDays04       SmallInt,
  PlayDays05       SmallInt,
  PlayDays06       SmallInt,
  PlayDays07       SmallInt,
  PlayDays08       SmallInt,
  PlayDays09       SmallInt,
  PlayDays10       SmallInt,
  PlayDays11       SmallInt,
  PlayDays12       SmallInt,
  PlayDays13       SmallInt,
  PlayDays14       SmallInt,
  PlayDays15       SmallInt,
  PlayDays16       SmallInt,
  PlayDays17       SmallInt,
  PlayDays18       SmallInt,
  PlayDays19       SmallInt,
  PlayDays20       SmallInt,
  PlayDays21       SmallInt,
  PlayDays22       SmallInt,
  PlayDays23       SmallInt,
  PlayDays24       SmallInt,
  PlayDays25       SmallInt,
  PlayDays26       SmallInt,
  PlayDays1_26     Int)

-- Open the cursor and perform the first FETCH...
OPEN MachineList
FETCH FROM MachineList INTO @MachineNbr, @GameCode

WHILE (@@FETCH_STATUS = 0)
   -- Successfully FETCHed a record, so insert a new row into temporary table #MonthlyRevenuebyGame.
   BEGIN
      SELECT
         @GameTypeCode = gs.GAME_TYPE_CODE,
         @GameDesc     = gs.GAME_DESC,
         @AmountPlayed01   = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 0 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed02   = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1) 
            WHEN 1 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed03   = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1) 
            WHEN 2 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed04   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
            WHEN 3 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed05   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
            WHEN 4 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed06   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 5 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed07   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 6 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed08   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 7 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),         @AmountPlayed09   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 8 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed10   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 9 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed11   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 10 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed12   = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 11 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed13   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 12 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed14   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
            WHEN 13 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed15   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
            WHEN 14 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed16   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 15 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed17   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 16 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed18   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
            WHEN 17 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END), 
         @AmountPlayed19   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 18 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed20   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 19 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed21   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 20 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed22   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
            WHEN 21 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed23   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 22 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed24   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 23 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed25   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 24 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed26   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
            WHEN 25 THEN ISNULL(ms.AMOUNT_PLAYED, 0)
            ELSE 0  END),
         @AmountPlayed1_26 = SUM(ms.AMOUNT_PLAYED)
      FROM MACHINE_STATS ms
           JOIN GAME_SETUP gs  ON gs.GAME_CODE = ms.GAME_CODE
           JOIN GAME_TYPE gt  ON gt.GAME_TYPE_CODE = gs.GAME_TYPE_CODE
      WHERE 
          (ms.ACCT_DATE BETWEEN @WeeksStartPeriod AND @EndDate) AND   
           ms.MACH_NO   = @MachineNbr AND 
           ms.GAME_CODE = @GameCode
      GROUP BY
         ms.MACH_NO,         ms.GAME_CODE,
         gs.GAME_DESC,
         gs.GAME_TYPE_CODE
      
      -- Get number of days of play for each week.
      SET @WeekNumber = 0
      SET @PlayDays1_26 = 0
      WHILE @WeekNumber < 26
         BEGIN
            SET @StartDate = DATEADD(Week, @WeekNumber, @WeeksStartPeriod)
            SET @EndWeek   = DATEADD(Day, 6, @StartDate)
            
            SELECT @PlayDays = COUNT(DISTINCT ACCT_DATE)
            FROM MACHINE_STATS
            WHERE
               ACCT_DATE BETWEEN @StartDate AND @EndWeek AND   
               MACH_NO = @MachineNbr                     AND 
               GAME_CODE = @GameCode                     AND
               PLAY_COUNT > 0       
                          
            -- Add PlayDays to Total PlayDays.
            SET @PlayDays1_26 = @PlayDays1_26 + @PlayDays
            
            -- Populate the appropriate variable...
            IF (@WeekNumber = 0)
               SET @PlayDays01 = @PlayDays
            ELSE IF (@WeekNumber = 1)
               SET @PlayDays02 = @PlayDays
            ELSE IF (@WeekNumber = 2)
               SET @PlayDays03 = @PlayDays
            ELSE IF (@WeekNumber = 3)
               SET @PlayDays04 = @PlayDays
            ELSE IF (@WeekNumber = 4)
               SET @PlayDays05 = @PlayDays
            ELSE IF (@WeekNumber = 5)
               SET @PlayDays06 = @PlayDays
            ELSE IF (@WeekNumber = 6)
               SET @PlayDays07 = @PlayDays
            ELSE IF (@WeekNumber = 7)
               SET @PlayDays08 = @PlayDays
            ELSE IF (@WeekNumber = 8)
               SET @PlayDays09 = @PlayDays
            ELSE IF (@WeekNumber = 9)
               SET @PlayDays10 = @PlayDays
            ELSE IF (@WeekNumber = 10)
               SET @PlayDays11 = @PlayDays
            ELSE IF (@WeekNumber = 11)
               SET @PlayDays12 = @PlayDays
            ELSE IF (@WeekNumber = 12)
               SET @PlayDays13 = @PlayDays
            ELSE IF (@WeekNumber = 13)
               SET @PlayDays14 = @PlayDays
            ELSE IF (@WeekNumber = 14)
               SET @PlayDays15 = @PlayDays
            ELSE IF (@WeekNumber = 15)
               SET @PlayDays16 = @PlayDays
            ELSE IF (@WeekNumber = 16)
               SET @PlayDays17 = @PlayDays
            ELSE IF (@WeekNumber = 17)
               SET @PlayDays18 = @PlayDays
            ELSE IF (@WeekNumber = 18)
               SET @PlayDays19 = @PlayDays
            ELSE IF (@WeekNumber = 19)
               SET @PlayDays20 = @PlayDays
            ELSE IF (@WeekNumber = 20)
               SET @PlayDays21 = @PlayDays
            ELSE IF (@WeekNumber = 21)
               SET @PlayDays22 = @PlayDays
            ELSE IF (@WeekNumber = 22)
               SET @PlayDays23 = @PlayDays
            ELSE IF (@WeekNumber = 23)
               SET @PlayDays24 = @PlayDays
            ELSE IF (@WeekNumber = 24)
               SET @PlayDays25 = @PlayDays
            ELSE IF (@WeekNumber = 25)
               SET @PlayDays26 = @PlayDays
            
            -- Increment the Week number counter.
            SET @WeekNumber = @WeekNumber + 1
         END
      
      -- Insert the row into the temp table.
      INSERT INTO #MonthlyRevenuebyGame
         (GameCode, GameTypeCode, GameDesc, MachineNbr,
          AmountPlayed01, AmountPlayed02, AmountPlayed03, AmountPlayed04, AmountPlayed05,
          AmountPlayed06, AmountPlayed07, AmountPlayed08, AmountPlayed09, AmountPlayed10,
          AmountPlayed11, AmountPlayed12, AmountPlayed13, AmountPlayed14, AmountPlayed15,      
          AmountPlayed16, AmountPlayed17, AmountPlayed18, AmountPlayed19, AmountPlayed20,       
          AmountPlayed21, AmountPlayed22, AmountPlayed23, AmountPlayed24, AmountPlayed25,     
          AmountPlayed26, AmountPlayed1_26,  PlayDays01, PlayDays02, PlayDays03, PlayDays04,
          PlayDays05, PlayDays06, PlayDays07, PlayDays08, PlayDays09, PlayDays10, PlayDays11,
          PlayDays12, PlayDays13, PlayDays14, PlayDays15, PlayDays16, PlayDays17,
          PlayDays18, PlayDays19, PlayDays20, PlayDays21, PlayDays22, PlayDays23,
          PlayDays24, PlayDays25, PlayDays26, PlayDays1_26)
      VALUES
         (@GameCode, @GameTypeCode, @GameDesc, @MachineNbr, 
          @AmountPlayed01, @AmountPlayed02, @AmountPlayed03, @AmountPlayed04, @AmountPlayed05,
          @AmountPlayed06, @AmountPlayed07, @AmountPlayed08, @AmountPlayed09, @AmountPlayed10,
          @AmountPlayed11, @AmountPlayed12, @AmountPlayed13, @AmountPlayed14, @AmountPlayed15,      
          @AmountPlayed16, @AmountPlayed17, @AmountPlayed18, @AmountPlayed19, @AmountPlayed20,       
          @AmountPlayed21, @AmountPlayed22, @AmountPlayed23, @AmountPlayed24, @AmountPlayed25,    
          @AmountPlayed26, @AmountPlayed1_26, @PlayDays01,   @PlayDays02, @PlayDays03, @PlayDays04,
          @PlayDays05, @PlayDays06, @PlayDays07, @PlayDays08, @PlayDays09, @PlayDays10,
          @PlayDays11, @PlayDays12, @PlayDays13, @PlayDays14, @PlayDays15, @PlayDays16,
          @PlayDays17, @PlayDays18, @PlayDays19, @PlayDays20, @PlayDays21, @PlayDays22,
          @PlayDays23, @PlayDays24, @PlayDays25, @PlayDays26, @PlayDays1_26)
        
      -- Reset amount played values and Number of days played by machine every week.
      SET @AmountPlayed01 = 0
      SET @AmountPlayed02 = 0 
      SET @AmountPlayed03 = 0
      SET @AmountPlayed04 = 0
      SET @AmountPlayed05 = 0 
      SET @AmountPlayed06 = 0
      SET @AmountPlayed07 = 0
      SET @AmountPlayed08 = 0
      SET @AmountPlayed09 = 0
      SET @AmountPlayed10 = 0 
      SET @AmountPlayed11 = 0
      SET @AmountPlayed12 = 0  
      SET @AmountPlayed13 = 0
      SET @AmountPlayed14 = 0  
      SET @AmountPlayed15 = 0  
      SET @AmountPlayed16 = 0        SET @AmountPlayed17 = 0  
      SET @AmountPlayed18 = 0  
      SET @AmountPlayed19 = 0
      SET @AmountPlayed20 = 0 
      SET @AmountPlayed21 = 0 
      SET @AmountPlayed22 = 0  
      SET @AmountPlayed23 = 0
      SET @AmountPlayed24 = 0  
      SET @AmountPlayed25 = 0 
      SET @AmountPlayed26 = 0  
     
      FETCH NEXT FROM MachineList INTO  @MachineNbr, @GameCode
   END

-- Close and Deallocate Cursor
CLOSE MachineList
DEALLOCATE MachineList

-- Retrieve the report data...
SELECT
   ISNULL(GameCode, '')         AS GameCode,
   GameTypeCode                 AS GameTypeCode,
   GameDesc                     AS GameDesc, 
   MachineNbr                   AS MachineNbr,
   AmountPlayed01,
   PlayDays01,
   Case PlayDays01 WHEN 0 THEN 0 ELSE AmountPlayed01 /PlayDays01 END AS WeeklyAvg01,
   AmountPlayed02,
   PlayDays02,
   Case PlayDays02 WHEN 0 THEN 0 ELSE AmountPlayed02 /PlayDays02 END AS WeeklyAvg02,
   AmountPlayed03,
   PlayDays03,
   Case PlayDays03 WHEN 0 THEN 0 ELSE AmountPlayed03 /PlayDays03 END AS WeeklyAvg03,
   AmountPlayed04,
   PlayDays04,
   Case PlayDays04 WHEN 0 THEN 0 ELSE AmountPlayed04 /PlayDays04 END AS WeeklyAvg04,  
   AmountPlayed05,
   PlayDays05,
   Case PlayDays05 WHEN 0 THEN 0 ELSE AmountPlayed05 /PlayDays05 END AS WeeklyAvg05,
   AmountPlayed06,
   PlayDays06,
   Case PlayDays06 WHEN 0 THEN 0 ELSE AmountPlayed06 /PlayDays06 END AS WeeklyAvg06,
   AmountPlayed07,
   PlayDays07,
   Case PlayDays07 WHEN 0 THEN 0 ELSE AmountPlayed07 /PlayDays07 END AS WeeklyAvg07,
   AmountPlayed08,
   PlayDays08,
   Case PlayDays08 WHEN 0 THEN 0 ELSE AmountPlayed08 /PlayDays08 END AS WeeklyAvg08, 
   AmountPlayed09,
   PlayDays09,
   Case PlayDays09 WHEN 0 THEN 0 ELSE AmountPlayed09 /PlayDays09 END AS WeeklyAvg09,
   AmountPlayed10,
   PlayDays10,
   Case PlayDays10 WHEN 0 THEN 0 ELSE AmountPlayed10 /PlayDays10 END AS WeeklyAvg10,  
   AmountPlayed11,
   PlayDays11,
   Case PlayDays11 WHEN 0 THEN 0 ELSE AmountPlayed11 /PlayDays11 END AS WeeklyAvg11,
   AmountPlayed12,
   PlayDays12,
   Case PlayDays12 WHEN 0 THEN 0 ELSE AmountPlayed12 /PlayDays12 END AS WeeklyAvg12,
   AmountPlayed13,
   PlayDays13,
   Case PlayDays13 WHEN 0 THEN 0 ELSE AmountPlayed13 /PlayDays13 END AS WeeklyAvg13,
   AmountPlayed14,
   PlayDays14,  
   Case PlayDays14 WHEN 0 THEN 0 ELSE AmountPlayed14 /PlayDays14 END AS WeeklyAvg14,
   AmountPlayed15,
   PlayDays15,
   Case PlayDays15 WHEN 0 THEN 0 ELSE AmountPlayed15 /PlayDays15 END AS WeeklyAvg15,
   AmountPlayed16,
   PlayDays16,
   Case PlayDays16 WHEN 0 THEN 0 ELSE AmountPlayed16 /PlayDays16 END AS WeeklyAvg16,
   AmountPlayed17,
   PlayDays17,
   Case PlayDays17 WHEN 0 THEN 0 ELSE AmountPlayed17 /PlayDays17 END AS WeeklyAvg17,
   AmountPlayed18,
   PlayDays18,
   Case PlayDays18 WHEN 0 THEN 0 ELSE AmountPlayed18 /PlayDays18 END AS WeeklyAvg18,  
   AmountPlayed19,
   PlayDays19,
   Case PlayDays19 WHEN 0 THEN 0 ELSE AmountPlayed19 /PlayDays19 END AS WeeklyAvg19,
   AmountPlayed20,
   PlayDays20,
   Case PlayDays20 WHEN 0 THEN 0 ELSE AmountPlayed20 /PlayDays20 END AS WeeklyAvg20, 
   AmountPlayed21,
   PlayDays21,
   Case PlayDays21 WHEN 0 THEN 0 ELSE AmountPlayed21 /PlayDays21 END AS WeeklyAvg21,
   AmountPlayed22,
   PlayDays22,
   Case PlayDays22 WHEN 0 THEN 0 ELSE AmountPlayed22 /PlayDays22 END AS WeeklyAvg22,  
   AmountPlayed23,
   PlayDays23,
   Case PlayDays23 WHEN 0 THEN 0 ELSE AmountPlayed23 /PlayDays23 END AS WeeklyAvg23,
   AmountPlayed24,
   PlayDays24,
   Case PlayDays24 WHEN 0 THEN 0 ELSE AmountPlayed24 /PlayDays24 END AS WeeklyAvg24,
   AmountPlayed25,
   PlayDays25,
   Case PlayDays25 WHEN 0 THEN 0 ELSE AmountPlayed25 /PlayDays25 END AS WeeklyAvg25,
   AmountPlayed26,
   PlayDays26,
   Case PlayDays26 WHEN 0 THEN 0 ELSE AmountPlayed26 /PlayDays26 END AS WeeklyAvg26,
   AmountPlayed1_26,
   PlayDays1_26,
   Case PlayDays1_26 WHEN 0 THEN 0 ELSE AmountPlayed1_26 /PlayDays1_26 END AS WeeklyAvg1_26   
FROM #MonthlyRevenuebyGame
ORDER BY GameCode, MachineNbr

-- Drop the temp table.
DROP TABLE #MonthlyRevenuebyGame
GO
