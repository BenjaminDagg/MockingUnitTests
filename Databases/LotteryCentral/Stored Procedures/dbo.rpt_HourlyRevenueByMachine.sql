SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_HourlyRevenueByMachine user stored procedure.

Created: 01/12/2011 Aldo Zamora

Purpose: Returns summarized data for the Hourly Revenue by Machine report

Arguments: @AcctDate: Starting Accounting date to use for the resultset
           


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   2011-01-12
  Initial coding.

--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_HourlyRevenueByMachine] @AcctDate DateTime
AS

-- Variable Declarations
DECLARE @HourOfDay          SmallInt

DECLARE @MinDenom           SmallMoney
DECLARE @MaxDenom           SmallMoney

DECLARE @DGMachineNbr       Char(5)

DECLARE @LocationMachineNbr VarChar(8)
DECLARE @DenomRange         VarChar(32)
DECLARE @GameTypeCode       VarChar(2)


-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Retrieve data into a temporary table.
SELECT
   psh.LOCATION_ID                               AS LocationID,
   cas.CAS_NAME                                  AS LocationName,
   psh.MACH_NO                                   AS DGMachineNbr,
   psh.CASINO_MACH_NO                            AS LocationMachineNbr,
   psh.Hour_OF_DAY                               AS HourOfDay,
   psh.GAME_CODE                                 AS GameCode,
   gs.GAME_DESC                                  AS GameName,
   gs.GAME_TYPE_CODE                             AS GameTypeCode,
   CAST(0 AS SmallMoney)                         AS MinDenom,
   CAST(0 AS VarChar(32))                        AS DenomRange,
   SUM(psh.AMOUNT_IN)                            AS CashDeposited,
   SUM(psh.PLAY_COUNT)                           AS TabsPlayed,
   SUM(psh.AMOUNT_PLAYED)                        AS DollarsPlayed,
   SUM(psh.WIN_COUNT) + SUM(psh.JACKPOT_COUNT)   AS WinningTabs,
   SUM(psh.AMOUNT_WON) + SUM(psh.AMOUNT_JACKPOT) AS MoneyWon,
   SUM(psh.FORFEIT_COUNT)                        AS TabsForfeited,
   SUM(psh.AMOUNT_PLAYED) - 
   SUM(psh.AMOUNT_WON) - 
   SUM(psh.AMOUNT_JACKPOT)                       AS NetToCasino,
   SUM(psh.TICKET_IN_AMOUNT)                     AS VoucherInTotal,
   SUM(psh.TICKET_OUT_AMOUNT)                    AS VoucherOutTotal,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount In' ) AS HeaderAmountIn,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher In' ) AS HeaderVoucherIn,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher Out') AS HeaderVoucherOut,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Played') AS HeaderAmountPlayed,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Won') AS HeaderAmountWon,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Net Revenue') AS HeaderNetRevenue
INTO #HourlyRevenueByMachine
FROM PLAY_STATS_HOURLY psh
   JOIN CASINO     cas ON psh.LOCATION_ID   = cas.LOCATION_ID
   JOIN GAME_SETUP gs  ON psh.GAME_CODE     = gs.GAME_CODE
   JOIN GAME_TYPE  gt  ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
WHERE ACCT_DATE = @AcctDate
GROUP BY
   psh.LOCATION_ID,
   cas.CAS_NAME,
   psh.MACH_NO,
   psh.CASINO_MACH_NO,
   psh.HOUR_OF_DAY,
   psh.GAME_CODE,
   gs.GAME_DESC,
   gs.GAME_TYPE_CODE
ORDER BY LocationID, DGMachineNbr, HourOfDay

-- Declare a cursor to move through the rows in the temp table.
DECLARE HourlyRevByMachine CURSOR
FOR
SELECT
   DGMachineNbr,
   LocationMachineNbr,
   HourOfDay,
   GameTypeCode
FROM #HourlyRevenueByMachine

-- Open the DealTabsTotal cursor.
OPEN HourlyRevByMachine
-- Get the first row of data.
FETCH FROM HourlyRevByMachine INTO @DGMachineNbr, @LocationMachineNbr, @HourOfDay, @GameTypeCode


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
      
      -- Update DenomRange and MinDenom columns in the temp table.
      UPDATE #HourlyRevenueByMachine SET
         DenomRange = @DenomRange,
         MinDenom   = @MinDenom
      WHERE CURRENT OF HourlyRevByMachine
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM HourlyRevByMachine INTO @DGMachineNbr, @LocationMachineNbr, @HourOfDay, @GameTypeCode
   END

-- Close and Deallocate the DealTabsTotal Cursor...
CLOSE HourlyRevByMachine
DEALLOCATE HourlyRevByMachine

-- Select the result set that is returned by this procedure.
SELECT
   LocationID, LocationName, DGMachineNbr, LocationMachineNbr, HourOfDay, GameCode, GameName,
   GameTypeCode, MinDenom, DenomRange, CashDeposited, TabsPlayed, DollarsPlayed,
   WinningTabs, MoneyWon, TabsForfeited, NetToCasino, VoucherInTotal, VoucherOutTotal,
   HeaderAmountIn, HeaderVoucherIn, HeaderVoucherOut, HeaderAmountPlayed, HeaderAmountWon,
   HeaderNetRevenue
FROM #HourlyRevenueByMachine
ORDER BY LocationID, GameCode, MinDenom, DGMachineNbr, HourOfDay
GO
GRANT EXECUTE ON  [dbo].[rpt_HourlyRevenueByMachine] TO [SSRS]
GO
