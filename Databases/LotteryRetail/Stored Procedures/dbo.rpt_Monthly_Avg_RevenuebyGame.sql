SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Monthly_Avg_RevenuebyGame user stored procedure.

  Created: 05-20-2005 by Natalya Mogilevsky

  Purpose: Returns calculated Monthly Revenue for selected Year from
           MACHINE_STATS Table for the report.  Used in Report thar calculates
           average Monthly Play Count and Net Revenue.

Arguments: Accounting Date will identify Year for report
          
Change Log:

Changed By      Date         Database Version
  Change Description
--------------------------------------------------------------------------------
Nat Mogilevsky 05-20-2005    v4.1.5
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Monthly_Avg_RevenuebyGame] @AccountDate DateTime
AS

-- Variable Declarations
DECLARE @ReportYear        Int

DECLARE @ProductId         VarChar(1)
DECLARE @GameCode          VarChar(3)
DECLARE @GameTypeCode      VarChar(2)
DECLARE @MachineNbr        VarChar(5)

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

SET NOCOUNT ON

SET @ReportYear = DATEPART(Year, @AccountDate)

-- Cursor Declaration
DECLARE MachList CURSOR FAST_FORWARD
FOR
SELECT MACH_NO, GAME_CODE
FROM MACH_SETUP
WHERE REMOVED_FLAG = 0 AND MACH_NO <> '0'
ORDER BY GAME_CODE

-- Create a temporary table to store results
CREATE TABLE #MonthlyRevenueByGame  (
  ProductID          VarChar(1),
  GameCode           VarChar(3),
  GameTypeCode       VarChar(2),
  MachineNbr         VarChar(5),
  NetAmount1         Money,
  NetAmount2         Money,
  NetAmount3         Money,
  NetAmount4         Money,
  NetAmount5         Money,
  NetAmount6         Money,
  NetAmount7         Money,
  NetAmount8         Money,
  NetAmount9         Money,
  NetAmount10        Money,
  NetAmount11        Money,
  NetAmount12        Money 
)

-- Open the cursor 
OPEN MachList

FETCH FROM MachList INTO @MachineNbr, @GameCode

WHILE (@@FETCH_STATUS = 0)
     -- Successfully FETCHed a record, so insert a new row into the temp table.
     -- Select data into #MonthlyRevenuebyGame  temp table.
   BEGIN
      SELECT
         @ProductId    =   p.PRODUCT_ID,  
         @GameTypeCode =  gs.GAME_TYPE_CODE,
         @NetAmount1   =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 1 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*  
         @NetAmount2 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 2 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*  
         @NetAmount3 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 3 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*  
         @NetAmount4 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 4 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*
         @NetAmount5 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 5 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*
         @NetAmount6 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 6 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*
         @NetAmount7 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 7 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*  
         @NetAmount8 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 8 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*  
         @NetAmount9 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 9 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*  
         @NetAmount10 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 10 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*  
         @NetAmount11 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 11 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END),
       --*  
         @NetAmount12 =  SUM(CASE DATEPART(month, ms.ACCT_DATE)
            WHEN 12 THEN ISNULL(ms.AMOUNT_PLAYED - (ms.AMOUNT_WON + ms.AMOUNT_JACKPOT + ms.AMOUNT_FORFEITED), 0)
                   ELSE 0 END)
      FROM MACHINE_STATS ms
           JOIN GAME_SETUP gs  ON gs.GAME_CODE = ms.GAME_CODE
           JOIN GAME_TYPE gt  ON gt.GAME_TYPE_CODE = gs.GAME_TYPE_CODE
           JOIN PRODUCT    p  ON gt.PRODUCT_ID = p.PRODUCT_ID
      WHERE DATEPART(Year, ms.ACCT_DATE) = @ReportYear AND ms.MACH_NO = @MachineNbr AND ms.GAME_CODE = @GameCode
      GROUP BY
         p.PRODUCT_ID,
--         ms.MACH_NO,
         ms.GAME_CODE,
         gs.GAME_TYPE_CODE
  
      INSERT INTO #MonthlyRevenuebyGame
         (ProductID,  GameCode, GameTypeCode, MachineNbr,
          NetAmount1,
          NetAmount2,
          NetAmount3,
          NetAmount4,
          NetAmount5,
          NetAmount6,
          NetAmount7,
          NetAmount8,
          NetAmount9,
          NetAmount10,
          NetAmount11,
          NetAmount12)
      VALUES
         (@ProductId, @GameCode, @GameTypeCode, @MachineNbr,
          @NetAmount1,
          @NetAmount2, 
          @NetAmount3,
          @NetAmount4,
          @NetAmount5,
          @NetAmount6,
          @NetAmount7, 
          @NetAmount8,
          @NetAmount9,
          @NetAmount10,
          @NetAmount11,
          @NetAmount12)
      
      -- Reset monthly revenue amounts.
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
      
      -- Get the next machine number.
      FETCH NEXT FROM MachList INTO  @MachineNbr, @GameCode
   END

-- Close and Deallocate Cursor
CLOSE MachList
DEALLOCATE MachList

-- Retrieve the data...
SELECT
   mi.ProductId              AS ProductID,
   p.PRODUCT_DESCRIPTION     AS ProductDesc,
   ISNULL(mi.GameCode, '')   AS GameCode,
   mi.GameTypeCode           AS GameTypeCode,
   gs.GAME_DESC, 
   mi.MachineNbr             AS MachineNbr,
   ISNULL(mi.NetAmount1, 0)  AS F2,  ISNULL(mi.NetAmount2,0)  AS F4,  
   ISNULL(mi.NetAmount3, 0)  AS F6,  ISNULL(mi.NetAmount4,0)  AS F8,  
   ISNULL(mi.NetAmount5, 0)  AS F10, ISNULL(mi.NetAmount6,0)  AS F12,
   ISNULL(mi.NetAmount7, 0)  AS F14, ISNULL(mi.NetAmount8,0)  AS F16,  
   ISNULL(mi.NetAmount9, 0)  AS F18, ISNULL(mi.NetAmount10,0) AS F20,  
   ISNULL(mi.NetAmount11, 0) AS F22, ISNULL(mi.NetAmount12,0) AS F24        
FROM #MonthlyRevenuebyGame mi
  JOIN GAME_SETUP gs  ON mi.GameCode = gs.GAME_CODE
  JOIN PRODUCT    p   ON mi.ProductId = p.PRODUCT_ID
ORDER BY  mi.ProductId, p.PRODUCT_DESCRIPTION, mi.GameCode, mi.GameTypeCode, gs.GAME_DESC, mi.MachineNbr
DROP TABLE #MonthlyRevenuebyGame
GO
