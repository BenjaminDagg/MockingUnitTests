SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Revenue_By_Machine_Range user stored procedure.

Created: 08/16/2004 by Terry Watkins

Purpose: Returns summarized data for the Revenue by Machine for Range report

Arguments: @AcctDateStart: Starting Accounting date to use for the resultset
           @AcctDateEnd:   Ending Accounting date to use for the resultset


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins  2004-08-16
  Initial coding.

Terry Watkins  2004-12-18    v4.0.0
  Added VoucherInTotal in support of Ticket In/Ticket Out play.

Nat Mogilevsky 07-07-2005    v4.1.4
  Added VoucherOutTotal field from MACHINE_STATS table.

Terry Watkins  2010-06-10    v7.2.2
  Removed check for Millennium machines and attempt to get the denomination of
  the machine from the MACH_SETUP.MACH_DENOM column which has been removed.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Revenue_By_Machine_Range] @AcctDateStart DateTime, @AcctDateEnd DateTime
AS

-- Variable Declarations
DECLARE @AccountingDate    DateTime

DECLARE @MinDenom          SmallMoney
DECLARE @MaxDenom          SmallMoney

DECLARE @MachineNbr        Char(5)

DECLARE @CasinoMachineNbr  VarChar(8)
DECLARE @DenomRange        VarChar(32)
DECLARE @GameTypeCode      VarChar(2)


-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Retrieve data into a temporary table.
SELECT
   ms.LOCATION_ID                             AS LocationID,
   cas.CAS_NAME                               AS LocationName,
   ms.MACH_NO                                 AS MachineNbr,
   ms.CASINO_MACH_NO                          AS CasinoMachineNbr,
   '2000-01-01'                               AS AccountingDate,
   ms.GAME_CODE                               AS GameCode,
   gs.GAME_DESC                               AS GameName,
   gs.GAME_TYPE_CODE                          AS GameTypeCode,
   CAST(0 AS SmallMoney)                      AS MinDenom,
   CAST(0 AS VarChar(32))                     AS DenomRange,
   SUM(ms.AMOUNT_IN)                          AS CashDeposited,
   SUM(ms.PLAY_COUNT)                         AS TabsPlayed,
   SUM(ms.AMOUNT_PLAYED)                      AS DollarsPlayed,
   SUM(ms.WIN_COUNT) + SUM(JACKPOT_COUNT)     AS WinningTabs,
   SUM(ms.AMOUNT_WON) + SUM(AMOUNT_JACKPOT)   AS MoneyWon,
   SUM(ms.FORFEIT_COUNT)                      AS TabsForfeited,
   SUM(ms.AMOUNT_PLAYED) - 
   SUM(ms.AMOUNT_WON) - 
   SUM(AMOUNT_JACKPOT)                        AS NetToCasino,
   SUM(TICKET_IN_AMOUNT)                      AS VoucherInTotal,
   SUM(TICKET_OUT_AMOUNT)                     AS VoucherOutTotal,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount In' ) AS HeaderAmountIn,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher In' ) AS HeaderVoucherIn,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher Out') AS HeaderVoucherOut,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Played') AS HeaderAmountPlayed,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Won') AS HeaderAmountWon,
   (SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Net Revenue') AS HeaderNetRevenue
INTO #RevenueByMachine
FROM MACHINE_STATS ms
   JOIN CASINO     cas ON ms.LOCATION_ID = cas.LOCATION_ID
   JOIN GAME_SETUP gs  ON ms.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE  gt  ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
WHERE ACCT_DATE BETWEEN @AcctDateStart AND @AcctDateEnd
GROUP BY
   ms.LOCATION_ID,
   cas.CAS_NAME,
   ms.MACH_NO,
   ms.CASINO_MACH_NO,
   ms.GAME_CODE,
   gs.GAME_DESC,
   gs.GAME_TYPE_CODE
ORDER BY CasinoMachineNbr

-- Declare a cursor to move through the rows in the temp table.
DECLARE RevByMachine CURSOR
FOR
SELECT
   MachineNbr,
   CasinoMachineNbr,
   AccountingDate,
   GameTypeCode
FROM #RevenueByMachine

-- Open the DealTabsTotal cursor.
OPEN RevByMachine
-- Get the first row of data.
FETCH FROM RevByMachine INTO @MachineNbr, @CasinoMachineNbr, @AccountingDate, @GameTypeCode


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
      UPDATE #RevenueByMachine SET
         DenomRange = @DenomRange,
         MinDenom   = @MinDenom
      WHERE CURRENT OF RevByMachine
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM RevByMachine INTO @MachineNbr, @CasinoMachineNbr, @AccountingDate, @GameTypeCode
   END

-- Close and Deallocate the DealTabsTotal Cursor...
CLOSE RevByMachine
DEALLOCATE RevByMachine

-- Select the result set that is returned by this procedure.
SELECT
   LocationID, LocationName, MachineNbr, CasinoMachineNbr, AccountingDate, GameCode, GameName,
   GameTypeCode, MinDenom, DenomRange, CashDeposited, TabsPlayed, DollarsPlayed,
   WinningTabs, MoneyWon, TabsForfeited, NetToCasino, VoucherInTotal, VoucherOutTotal,
   HeaderAmountIn, HeaderVoucherIn, HeaderVoucherOut, HeaderAmountPlayed, HeaderAmountWon,
   HeaderNetRevenue
FROM #RevenueByMachine
ORDER BY LocationID, GameCode, MinDenom, CasinoMachineNbr
GO
GRANT EXECUTE ON  [dbo].[rpt_Revenue_By_Machine_Range] TO [SSRS]
GO
