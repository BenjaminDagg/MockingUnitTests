SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_DailyAvgRevenueByWeek user stored procedure.

  Created: 05-20-2005 by Natalya Mogilevsky

  Purpose: Returns calculated Average Monthly Revenue for 6 month period starting
           from entered AccounDate 
           Data retrieved from MACHINE_STATS Table.
           Average calculated using days played by machine per week.

Arguments: Accounting Date will show Average Revenue by machine by Game for 6 months period.
           It will be a starting point. End Date for report will be 6 months back.
          
Change Log:

Changed By      Date         Database Version
  Change Description
--------------------------------------------------------------------------------
Nat Mogilevsky 05-20-2005    v4.2.2
  Initial coding.

Terry Watkins     2010-11-29  v7.2.4
  Changed Machine number from MACH_NO to CASINO_MACH_NO + (MACH_NO)
  
Aldo Zamora   04-19-2011     Lottery Retail v3.0.9
  Added SSRS flag to control how the first day is calculated between SSRS reports and 
  crystal reports. 
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_DailyAvgRevenueByWeek]
@AccountDate DATETIME,
@SSRS BIT = 0

AS

DECLARE @CasinoMachineNbr  VarChar(8)
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
DECLARE @PlayDays1         SmallInt
DECLARE @PlayDays2         SmallInt
DECLARE @PlayDays3         SmallInt
DECLARE @PlayDays4         SmallInt
DECLARE @PlayDays5         SmallInt
DECLARE @PlayDays6         SmallInt
DECLARE @PlayDays7         SmallInt
DECLARE @PlayDays8         SmallInt
DECLARE @PlayDays9         SmallInt
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

DECLARE	@FDOW              INT
DECLARE @PlayDays1_26      Int
DECLARE @WeekNumber        Int

DECLARE @NetAmount1        Money
DECLARE @NetAmount2        Money
DECLARE @NetAmount3        Money
DECLARE @NetAmount4        Money
DECLARE @NetAmount5        Money
DECLARE @NetAmount6        Money
DECLARE @NetAmount7        Money
DECLARE @NetAmount8        Money
DECLARE @NetAmount9        Money
DECLARE @NetAmount10       Money
DECLARE @NetAmount11       Money
DECLARE @NetAmount12       Money
DECLARE @NetAmount13       Money
DECLARE @NetAmount14       Money
DECLARE @NetAmount15       Money
DECLARE @NetAmount16       Money
DECLARE @NetAmount17       Money
DECLARE @NetAmount18       Money
DECLARE @NetAmount19       Money
DECLARE @NetAmount20       Money
DECLARE @NetAmount21       Money
DECLARE @NetAmount22       Money
DECLARE @NetAmount23       MONEY
DECLARE @NetAmount24       Money
DECLARE @NetAmount25       Money
DECLARE @NetAmount26       Money
DECLARE @NetAmount1_26     Money

IF @SSRS = 0
   BEGIN
      SET NOCOUNT ON
      SET DATEFIRST 1

      -- Set @WeeksEndPeriod to Monday.
      SET @WeeksEndPeriod = DATEADD(yyyy, DATEPART(yyyy, DATEADD(weekday, 1 - DATEPART(weekday, @AccountDate), @AccountDate)) - 1900, 0) 
                          + DATEADD(dy, DATEPART(dy, DATEADD(weekday, 1 - DATEPART(weekday, @AccountDate), @AccountDate)) - 1, 0)
      SET @WeeksStartPeriod = DATEADD(week, -26, @WeeksEndPeriod)
      SET @EndDate   = DATEADD(Day, -1, @WeeksEndPeriod)
   END
ELSE
   BEGIN
      SELECT @FDOW = VALUE1
      FROM dbo.CASINO_SYSTEM_PARAMETERS
      WHERE PAR_ID = 'PARAM25'
	  	  
      SET DATEFIRST @FDOW

   	  SET @WeeksStartPeriod = @AccountDate
	  SET @EndDate = DATEADD(week, 26, DATEADD(day, -1, @WeeksStartPeriod))
   END

-- Cursor Declaration
DECLARE MachineList CURSOR FAST_FORWARD
FOR
SELECT DISTINCT MACH_NO, CASINO_MACH_NO, GAME_CODE
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
  CasinoMachineNbr VarChar(8),
  NetAmount1       Money,
  NetAmount2       Money,
  NetAmount3       Money,
  NetAmount4       Money,
  NetAmount5       Money,
  NetAmount6       Money,
  NetAmount7       Money,
  NetAmount8       Money,
  NetAmount9       Money,
  NetAmount10      Money,
  NetAmount11      Money,
  NetAmount12      Money,
  NetAmount13      Money,
  NetAmount14      Money,
  NetAmount15      Money,
  NetAmount16      Money,
  NetAmount17      Money,
  NetAmount18      Money,
  NetAmount19      Money,
  NetAmount20      Money,
  NetAmount21      Money,
  NetAmount22      Money,
  NetAmount23      Money,
  NetAmount24      Money,
  NetAmount25      Money,
  NetAmount26      Money,
  NetAmount1_26    Money,
  PlayDays1        SmallInt,
  PlayDays2        SmallInt,
  PlayDays3        SmallInt,
  PlayDays4        SmallInt,
  PlayDays5        SmallInt,
  PlayDays6        SmallInt,
  PlayDays7        SmallInt,
  PlayDays8        SmallInt,
  PlayDays9        SmallInt,
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

-- Open the cursor 
OPEN MachineList

FETCH FROM MachineList INTO @MachineNbr, @CasinoMachineNbr, @GameCode

WHILE (@@FETCH_STATUS = 0)
   -- Successfully FETCHed a record, so insert a new row into the temp table.
   -- Select data into #MonthlyRevenuebyGame  temp table.
   BEGIN
      SELECT
         @GameTypeCode = gs.GAME_TYPE_CODE,
         @GameDesc     = gs.GAME_DESC,
         @NetAmount1   = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 0 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0) 
                  ELSE 0  END),
         @NetAmount2   = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 1 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
		    ELSE 0  END),
         @NetAmount3   = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 2 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount4   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 3 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount5   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 4 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount6   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 5 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                   ELSE 0  END),
         @NetAmount7   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 6 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END),
         @NetAmount8   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 7 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END),
         @NetAmount9   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 8 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount10   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 9 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount11   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 10 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END),
         @NetAmount12   = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 11 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount13   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 12 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount14   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 13 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END),
         @NetAmount15   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 14 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END),
         @NetAmount16   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 15 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount17   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 16 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END),
         @NetAmount18   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 17 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END), 
         @NetAmount19   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 18 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount20   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 19 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END),
         @NetAmount21   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 20 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount22   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 21 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount23   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 22 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END),
         @NetAmount24   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 23 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount25   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 24 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                     ELSE 0  END),
         @NetAmount26   = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 25 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount1_26 = SUM(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED))
      FROM MACHINE_STATS ms
           JOIN GAME_SETUP gs  ON gs.GAME_CODE = ms.GAME_CODE
           JOIN GAME_TYPE gt  ON gt.GAME_TYPE_CODE = gs.GAME_TYPE_CODE
      WHERE 
          (ms.ACCT_DATE BETWEEN @WeeksStartPeriod AND @EndDate) AND   
           ms.MACH_NO   = @MachineNbr AND 
           ms.GAME_CODE = @GameCode
      GROUP BY
         ms.MACH_NO,
         ms.GAME_CODE,
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
               SET @PlayDays1 = @PlayDays
            ELSE IF (@WeekNumber = 1)
               SET @PlayDays2 = @PlayDays
            ELSE IF (@WeekNumber = 2)
               SET @PlayDays3 = @PlayDays
            ELSE IF (@WeekNumber = 3)
               SET @PlayDays4 = @PlayDays
            ELSE IF (@WeekNumber = 4)
               SET @PlayDays5 = @PlayDays
            ELSE IF (@WeekNumber = 5)
               SET @PlayDays6 = @PlayDays
            ELSE IF (@WeekNumber = 6)
               SET @PlayDays7 = @PlayDays
            ELSE IF (@WeekNumber = 7)
               SET @PlayDays8 = @PlayDays
            ELSE IF (@WeekNumber = 8)
               SET @PlayDays9 = @PlayDays
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
         (GameCode, GameTypeCode, GameDesc, MachineNbr, CasinoMachineNbr,
          NetAmount1, NetAmount2, NetAmount3, NetAmount4, NetAmount5,
          NetAmount6, NetAmount7, NetAmount8, NetAmount9, NetAmount10,
          NetAmount11, NetAmount12, NetAmount13, NetAmount14, NetAmount15,      
          NetAmount16, NetAmount17, NetAmount18, NetAmount19, NetAmount20,       
          NetAmount21, NetAmount22, NetAmount23, NetAmount24, NetAmount25,     
          NetAmount26, NetAmount1_26, PlayDays1, PlayDays2, PlayDays3, PlayDays4, PlayDays5,
          PlayDays6, PlayDays7, PlayDays8, PlayDays9, PlayDays10, PlayDays11,
          PlayDays12, PlayDays13, PlayDays14, PlayDays15, PlayDays16, PlayDays17,
          PlayDays18, PlayDays19, PlayDays20, PlayDays21, PlayDays22, PlayDays23,
          PlayDays24, PlayDays25, PlayDays26, PlayDays1_26)
      VALUES
         (@GameCode, @GameTypeCode, @GameDesc, @MachineNbr, @CasinoMachineNbr,
          @NetAmount1, @NetAmount2, @NetAmount3, @NetAmount4, @NetAmount5,
          @NetAmount6, @NetAmount7, @NetAmount8, @NetAmount9, @NetAmount10,
          @NetAmount11, @NetAmount12, @NetAmount13, @NetAmount14, @NetAmount15,      
          @NetAmount16, @NetAmount17, @NetAmount18, @NetAmount19, @NetAmount20,       
          @NetAmount21, @NetAmount22, @NetAmount23, @NetAmount24, @NetAmount25,    
          @NetAmount26, @NetAmount1_26, @PlayDays1, @PlayDays2, @PlayDays3, @PlayDays4, @PlayDays5,
          @PlayDays6,  @PlayDays7,  @PlayDays8,  @PlayDays9,  @PlayDays10, @PlayDays11,
          @PlayDays12, @PlayDays13, @PlayDays14, @PlayDays15, @PlayDays16, @PlayDays17,
          @PlayDays18, @PlayDays19, @PlayDays20, @PlayDays21, @PlayDays22, @PlayDays23,
          @PlayDays24, @PlayDays25, @PlayDays26, @PlayDays1_26)
        
      -- Reset monthly revenue amounts and Number of days played by machine every week.
      SET @NetAmount1 = 0
      SET @NetAmount2 = 0 
      SET @NetAmount3 = 0
      SET @NetAmount4 = 0
      SET @NetAmount5 = 0 
      SET @NetAmount6 = 0
      SET @NetAmount7 = 0
      SET @NetAmount8 = 0
      SET @NetAmount9 = 0
      SET @NetAmount10 = 0 
      SET @NetAmount11 = 0
      SET @NetAmount12 = 0  
      SET @NetAmount13 = 0
      SET @NetAmount14 = 0  
      SET @NetAmount15 = 0  
      SET @NetAmount16 = 0  
      SET @NetAmount17 = 0  
      SET @NetAmount18 = 0  
      SET @NetAmount19 = 0
      SET @NetAmount20 = 0 
      SET @NetAmount21 = 0 
      SET @NetAmount22 = 0  
      SET @NetAmount23 = 0
      SET @NetAmount24 = 0  
      SET @NetAmount25 = 0 
      SET @NetAmount26 = 0  
     
      FETCH NEXT FROM MachineList INTO @MachineNbr, @CasinoMachineNbr, @GameCode
   END

-- Close and Deallocate Cursor
CLOSE MachineList
DEALLOCATE MachineList

-- Retrieve the report data...
SELECT
   ISNULL(GameCode, '')         AS GameCode,
   GameTypeCode                 AS GameTypeCode,
   GameDesc                     AS GameDesc, 
   CasinoMachineNbr + ' (' + MachineNbr + ')'      AS MachineNbr,
   NetAmount1    As Net1,
   PlayDays1     AS Play1,
   Case PlayDays1
      WHEN 0 THEN 0 ELSE NetAmount1 /PlayDays1 END AS WeeklyAvg1,
   NetAmount2    As Net2,
   PlayDays2    AS Play2,
   Case PlayDays2
      WHEN 0 THEN 0 ELSE NetAmount2 /PlayDays2 END AS WeeklyAvg2,
   NetAmount3    As Net3,  
   PlayDays3     AS Play3,
   Case PlayDays3
      WHEN 0 THEN 0 ELSE NetAmount3 /PlayDays3 END AS WeeklyAvg3,
   NetAmount4    As Net4,  
   PlayDays4     AS Play4,
   Case PlayDays4
      WHEN 0 THEN 0 ELSE NetAmount4 /PlayDays4 END AS WeeklyAvg4,  
   NetAmount5    As Net5,   
   PlayDays5     AS Play5,
   Case PlayDays5
      WHEN 0 THEN 0 ELSE NetAmount5 /PlayDays5 END AS WeeklyAvg5,
   NetAmount6    As Net6,  
   PlayDays6     AS Play6,
   Case PlayDays6
      WHEN 0 THEN 0 ELSE NetAmount6 /PlayDays6 END AS WeeklyAvg6,
   NetAmount7    As Net7, 
   PlayDays7     AS Play7,
   Case PlayDays7
      WHEN 0 THEN 0 ELSE NetAmount7 /PlayDays7 END AS WeeklyAvg7,
   NetAmount8    As Net8, 
   PlayDays8     AS Play8,
   Case PlayDays8
      WHEN 0 THEN 0 ELSE NetAmount8 /PlayDays8 END AS WeeklyAvg8, 
   NetAmount9    As Net9,   
   PlayDays9     AS Play9,
   Case PlayDays9
      WHEN 0 THEN 0 ELSE NetAmount9 /PlayDays9 END AS WeeklyAvg9,
   NetAmount10   As Net10,
   PlayDays10    AS Play10,
   Case PlayDays10
      WHEN 0 THEN 0 ELSE NetAmount10 /PlayDays10 END AS WeeklyAvg10,  
   NetAmount11   As Net11,
   PlayDays11    AS Play11,
   Case PlayDays11
      WHEN 0 THEN 0 ELSE NetAmount11 /PlayDays11 END AS WeeklyAvg11,
   NetAmount12   As Net12,
   PlayDays12    AS Play12,
   Case PlayDays12
      WHEN 0 THEN 0 ELSE NetAmount12 /PlayDays12 END AS WeeklyAvg12,
   NetAmount13   As Net13,
   PlayDays13    AS Play13,
   Case PlayDays13
      WHEN 0 THEN 0 ELSE NetAmount13 /PlayDays13 END AS WeeklyAvg13,
   NetAmount14   As Net14,
   PlayDays14    AS Play14,  
      Case PlayDays14
      WHEN 0 THEN 0 ELSE NetAmount14 /PlayDays14 END AS WeeklyAvg14,
   NetAmount15   As Net15,
   PlayDays15    AS Play15,
   Case PlayDays15
      WHEN 0 THEN 0 ELSE NetAmount15 /PlayDays15 END AS WeeklyAvg15,
   NetAmount16   As Net16,
   PlayDays16    AS Play16,
   Case PlayDays16
      WHEN 0 THEN 0 ELSE NetAmount16 /PlayDays16 END AS WeeklyAvg16,
   NetAmount17   As Net17,
   PlayDays17    AS Play17,
   Case PlayDays17
      WHEN 0 THEN 0 ELSE NetAmount17 /PlayDays17 END AS WeeklyAvg17,
   NetAmount18   As Net18,
   PlayDays18    AS Play18,
   Case PlayDays18
      WHEN 0 THEN 0 ELSE NetAmount18 /PlayDays18 END AS WeeklyAvg18,  
   NetAmount19   As Net19, 
   PlayDays19    AS Play19,
   Case PlayDays19
      WHEN 0 THEN 0 ELSE NetAmount19 /PlayDays19 END AS WeeklyAvg19,
   NetAmount20   As Net20,
   PlayDays20    AS Play20,
   Case PlayDays20
      WHEN 0 THEN 0 ELSE NetAmount20 /PlayDays20 END AS WeeklyAvg20, 
   NetAmount21   As Net21,
   PlayDays21    AS Play21,
   Case PlayDays21
      WHEN 0 THEN 0 ELSE NetAmount21 /PlayDays21 END AS WeeklyAvg21,
   NetAmount22   As Net22,
   PlayDays22    AS Play22,
   Case PlayDays22
      WHEN 0 THEN 0 ELSE NetAmount22 /PlayDays22 END AS WeeklyAvg22,  
   NetAmount23   As Net23,
   PlayDays23    AS Play23,
   Case PlayDays23
      WHEN 0 THEN 0 ELSE NetAmount23 /PlayDays23 END AS WeeklyAvg23,
   NetAmount24   As Net24,
   PlayDays24    AS Play24,
   Case PlayDays24
      WHEN 0 THEN 0 ELSE NetAmount24 /PlayDays24 END AS WeeklyAvg24,
   NetAmount25   As Net25,
   PlayDays25    AS Play25,
   Case PlayDays25
      WHEN 0 THEN 0 ELSE NetAmount25 /PlayDays25 END AS WeeklyAvg25,
   NetAmount26   As Net26,
   PlayDays26    AS Play26,
   Case PlayDays26
      WHEN 0 THEN 0 ELSE NetAmount26 /PlayDays26 END AS WeeklyAvg26,
   NetAmount1_26 As Net1_26,
   PlayDays1_26  AS Play1_26,
   Case PlayDays1_26
      WHEN 0 THEN 0 ELSE NetAmount1_26 /PlayDays1_26 END AS WeeklyAvg1_26   
FROM #MonthlyRevenuebyGame
ORDER BY GameCode, MachineNbr

-- Drop the temp table.
DROP TABLE #MonthlyRevenuebyGame
GO
