SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
-- Batch submitted through debugger: SQLQuery4.sql|7|0|C:\Documents and Settings\terryw\Local Settings\Temp\~vsCAA.sql
/*
--------------------------------------------------------------------------------
Procedure: rpt_Daily4WeekMachineAverage user stored procedure.

  Created: 04-30-2007 by Terry Watkins

  Purpose: Returns calculated Average Revenue per Machine for a 4 week period
           starting from entered AccounDate.
           Averages are calculated using days actually played.

Arguments: Accounting Date
           The report will use this as an ending date.
          
Change Log:

Changed By    Date         Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 04-30-2007    v5.0.8
  Initial coding.
  
Aldo Zamora   04-19-2011     Lottery Retail v3.0.9
  Added SSRS flag to control how the first day is calculated between SSRS reports and 
  crystal reports. 
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Daily4WeekMachineAverage]
   @AccountDate DATETIME,
   @SSRS BIT = 0   

AS

DECLARE @CasinoMachNbr     VarChar(8)
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
DECLARE @PlayDays4         SMALLINT

DECLARE @FDOW              Int
DECLARE @PlayDays1_4       Int
DECLARE @WeekNumber        Int

DECLARE @NetAmount1        Money
DECLARE @NetAmount2        Money
DECLARE @NetAmount3        Money
DECLARE @NetAmount4        Money
DECLARE @NetAmount1_4      Money

IF @SSRS = 0
   BEGIN
      SET NOCOUNT ON
      SET DATEFIRST 1

      -- Set @WeeksEndPeriod to Monday.
      SET @WeeksEndPeriod = DATEADD(yyyy, DATEPART(yyyy, DATEADD(weekday, 1 - DATEPART(weekday, @AccountDate), @AccountDate)) - 1900, 0) 
                    + DATEADD(dy, DATEPART(dy, DATEADD(weekday, 1 - DATEPART(weekday, @AccountDate), @AccountDate)) - 1, 0)
      
      SET @WeeksStartPeriod = DATEADD(week, -4, @WeeksEndPeriod)
      SET @EndDate   = DATEADD(Day, -1, @WeeksEndPeriod)
	
   END
ELSE
   BEGIN
      SELECT @FDOW = VALUE1
      FROM dbo.CASINO_SYSTEM_PARAMETERS
      WHERE PAR_ID = 'PARAM25'

	  SET DATEFIRST @FDOW

      SET @WeeksStartPeriod = @AccountDate
      SET @EndDate = DATEADD(week, 4, DATEADD(day, -1, @WeeksStartPeriod))
   END

-- Cursor Declaration
DECLARE MachineList CURSOR FAST_FORWARD
FOR
SELECT DISTINCT MACH_NO, GAME_CODE
FROM MACHINE_STATS
WHERE
   MACH_NO <> '0' AND
   ACCT_DATE BETWEEN @WeeksStartPeriod AND @EndDate
ORDER BY GAME_CODE, MACH_NO

-- Create a temporary table to store results
CREATE TABLE #Daily4WeekMachineAverage  (
  GameCode         VarChar(3),
  GameTypeCode     VarChar(2),
  GameDesc         VarChar(64),
  MachineNbr       VarChar(5),
  CasinoMachNbr    VarChar(8),
  NetAmount1       Money,
  NetAmount2       Money,
  NetAmount3       Money,
  NetAmount4       Money,
  NetAmount1_4     Money,
  PlayDays1        SmallInt,
  PlayDays2        SmallInt,
  PlayDays3        SmallInt,
  PlayDays4        SmallInt,
  PlayDays1_4      Int)

-- Open the cursor 
OPEN MachineList

FETCH FROM MachineList INTO @MachineNbr, @GameCode

WHILE (@@FETCH_STATUS = 0)
   -- Successfully FETCHed a record, so insert a new row into the temp table.
   -- Select data into #Daily4WeekMachineAverage temp table.
   BEGIN
      SELECT
         @GameTypeCode  = gs.GAME_TYPE_CODE,
         @GameDesc      = gs.GAME_DESC,
         @CasinoMachNbr = MAX(ms.CASINO_MACH_NO),
         @NetAmount1    = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1)
           WHEN 0 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0) 
                  ELSE 0  END),
         @NetAmount2    = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 1 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
		    ELSE 0  END),
         @NetAmount3    = SUM(CASE DATEDIFF(week, @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 2 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount4    = SUM(CASE DATEDIFF(week,  @WeeksStartPeriod, ms.ACCT_DATE - 1) 
           WHEN 3 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED),0)
                    ELSE 0  END),
         @NetAmount1_4  = SUM(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED))
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
      SET @PlayDays1_4 = 0
      WHILE @WeekNumber < 4
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
            SET @PlayDays1_4 = @PlayDays1_4 + @PlayDays
            
            -- Populate the appropriate variable...
            IF (@WeekNumber = 0)
               SET @PlayDays1 = @PlayDays
            ELSE IF (@WeekNumber = 1)
               SET @PlayDays2 = @PlayDays
            ELSE IF (@WeekNumber = 2)
               SET @PlayDays3 = @PlayDays
            ELSE IF (@WeekNumber = 3)
               SET @PlayDays4 = @PlayDays

            -- Increment the Week number counter.
            SET @WeekNumber = @WeekNumber + 1
         END
      
      -- Insert the row into the temp table.
      INSERT INTO #Daily4WeekMachineAverage
         (GameCode,    GameTypeCode,  GameDesc,    MachineNbr,  CasinoMachNbr,
          NetAmount1,  NetAmount2,    NetAmount3,  NetAmount4,  NetAmount1_4,
          PlayDays1,   PlayDays2,     PlayDays3,   PlayDays4,   PlayDays1_4)
      VALUES
         (@GameCode,   @GameTypeCode, @GameDesc,   @MachineNbr, @CasinoMachNbr,
          @NetAmount1, @NetAmount2,   @NetAmount3, @NetAmount4, @NetAmount1_4,
          @PlayDays1,  @PlayDays2,    @PlayDays3,  @PlayDays4,  @PlayDays1_4)
      
      -- Reset net amounts and Number of days played by machine every week.
      SET @NetAmount1 = 0
      SET @NetAmount2 = 0 
      SET @NetAmount3 = 0
      SET @NetAmount4 = 0
     
      FETCH NEXT FROM MachineList INTO  @MachineNbr, @GameCode
   END

-- Close and Deallocate Cursor
CLOSE MachineList
DEALLOCATE MachineList

-- Retrieve the report data...
SELECT
   ISNULL(GameCode, '')  AS GameCode,
   GameTypeCode          AS GameTypeCode,
   GameDesc              AS GameDesc, 
   MachineNbr            AS MachineNbr,
   CasinoMachNbr         AS CasinoMachNbr,
   NetAmount1            AS Net1,
   PlayDays1             AS Play1,
   CASE PlayDays1
      WHEN 0 THEN 0 ELSE NetAmount1 /PlayDays1 END AS WeeklyAvg1,
   NetAmount2            AS Net2,
   PlayDays2             AS Play2,
   CASE PlayDays2
      WHEN 0 THEN 0 ELSE NetAmount2 /PlayDays2 END AS WeeklyAvg2,
   NetAmount3            AS Net3,  
   PlayDays3             AS Play3,
   CASE PlayDays3
      WHEN 0 THEN 0 ELSE NetAmount3 /PlayDays3 END AS WeeklyAvg3,
   NetAmount4            AS Net4,  
   PlayDays4             AS Play4,
   CASE PlayDays4
      WHEN 0 THEN 0 ELSE NetAmount4 /PlayDays4 END AS WeeklyAvg4,  
   NetAmount1_4          AS Net1_4,
   PlayDays1_4           AS Play1_4,
   CASE PlayDays1_4
      WHEN 0 THEN 0 ELSE NetAmount1_4 /PlayDays1_4 END AS WeeklyAvg1_4
FROM #Daily4WeekMachineAverage
ORDER BY GameCode, MachineNbr

-- Drop the temp table.
DROP TABLE #Daily4WeekMachineAverage
GO
