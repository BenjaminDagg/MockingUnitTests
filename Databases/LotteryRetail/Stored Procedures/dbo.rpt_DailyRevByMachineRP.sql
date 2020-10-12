SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_DailyRevByMachineRP user stored procedure.

Created: 03-15-2011 by Terry Watkins

Purpose: Returns summarized data for the Daily Revenue by Machine report that is
         printed on a Lottery receipt printer

Arguments: @Acct_Date:  Accounting date to use for the resultset


Change Log:

Changed By      Date         Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins   03-15-2011   v7.2.4
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_DailyRevByMachineRP] @Acct_Date DateTime
AS

-- Variable Declarations
DECLARE @CasinoMachNbr     VarChar(8)
DECLARE @EndAcctDate       DateTime
DECLARE @GameCode          VarChar(3)
DECLARE @GameName          VarChar(64)
DECLARE @GameTypeCode      VarChar(2)
DECLARE @MachineNbr        Char(5)
DECLARE @VoucherPaidTotal  Money

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Variable Initialization
SET @VoucherPaidTotal = 0

-- Retrieve data into a temporary table.
SELECT
   ms.MACH_NO                                  AS MachineNbr,
   ms.CASINO_MACH_NO                           AS CasinoMachineNbr,
   ms.GAME_CODE                                AS GameCode,
   gs.GAME_DESC                                AS GameName,
   gs.GAME_TYPE_CODE                           AS GameTypeCode,
   SUM(ms.AMOUNT_IN)                           AS CashDeposited,
   SUM(ms.PLAY_COUNT)                          AS TabsPlayed,
   SUM(ms.AMOUNT_PLAYED)                       AS DollarsPlayed,
   SUM(ms.WIN_COUNT) + SUM(ms.JACKPOT_COUNT)   AS WinningTabs,
   SUM(ms.AMOUNT_WON) + SUM(ms.AMOUNT_JACKPOT) AS MoneyWon,
   SUM(ms.FORFEIT_COUNT)                       AS TabsForfeited,
   SUM(ms.AMOUNT_PLAYED) - SUM(ms.AMOUNT_WON)
                      - SUM(ms.AMOUNT_JACKPOT) AS NetRevenue,
   SUM(TICKET_IN_AMOUNT)                       AS VoucherInTotal, 
   SUM(TICKET_OUT_AMOUNT)                      AS VoucherOutTotal,
   CAST(0 AS MONEY)                            AS VoucherPaidTotal
INTO #RevenueByMachine
FROM MACHINE_STATS ms
   JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE ACCT_DATE = @Acct_Date
GROUP BY
   ms.MACH_NO,
   ms.CASINO_MACH_NO,
   ms.GAME_CODE,
   gs.GAME_DESC,
   gs.GAME_TYPE_CODE
ORDER BY CasinoMachineNbr

-- If there are active machines that are not in the temp table, insert rows.
DECLARE MachineList CURSOR
FOR
SELECT
   ms.MACH_NO,
   ms.CASINO_MACH_NO,
   ms.GAME_CODE,
   gs.GAME_DESC,
   gs.GAME_TYPE_CODE
FROM dbo.MACH_SETUP ms
   JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE
   MACH_NO <> '0'   AND
   REMOVED_FLAG = 0 AND
   MACH_NO NOT IN (SELECT MachineNbr FROM #RevenueByMachine)

-- Open the MachineList cursor.
OPEN MachineList

-- Get the first row of data.
FETCH FROM MachineList INTO @MachineNbr, @CasinoMachNbr, @GameCode, @GameName, @GameTypeCode

WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- FETCH was successful, so insert a row into the temp table.
      INSERT INTO #RevenueByMachine
         (MachineNbr, CasinoMachineNbr, GameCode, GameName, GameTypeCode, CashDeposited,
          TabsPlayed, DollarsPlayed, WinningTabs, MoneyWon, TabsForfeited, NetRevenue,
          VoucherInTotal, VoucherOutTotal, VoucherPaidTotal)
      VALUES
         (@MachineNbr, @CasinoMachNbr, @GameCode, @GameName, @GameTypeCode, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM MachineList INTO @MachineNbr, @CasinoMachNbr, @GameCode, @GameName, @GameTypeCode
   END

-- Close and Deallocate the MachineList Cursor...
CLOSE MachineList
DEALLOCATE MachineList

-- Declare a cursor to move through the rows in the temp table.
DECLARE RevByMachine CURSOR
FOR
SELECT MachineNbr FROM #RevenueByMachine

-- Open the DealTabsTotal cursor.
OPEN RevByMachine

-- Get the first row of data.
FETCH FROM RevByMachine INTO @MachineNbr

WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- FETCH was successful.
      -- Get the VoucherPaidTotal column value.
      -- Join the CASHIER_TRANS table so only vouchers paid at a POS will be included.
      SELECT @VoucherPaidTotal = ISNULL(SUM(v.VOUCHER_AMOUNT), 0)
      FROM VOUCHER v
         JOIN dbo.CASHIER_TRANS ct ON v.VOUCHER_ID = ct.VOUCHER_ID
      WHERE
         v.CREATED_LOC    = @MachineNbr AND
         v.REDEEMED_STATE = 1           AND
         dbo.ufnGetAcctDateFromDate(v.REDEEMED_DATE) = @Acct_Date
      
      -- Update DenomRange and MinDenom columns in the temp table.
      UPDATE #RevenueByMachine
      SET VoucherPaidTotal = @VoucherPaidTotal
      WHERE CURRENT OF RevByMachine
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM RevByMachine INTO @MachineNbr
   END

-- Close and Deallocate the DealTabsTotal Cursor...
CLOSE RevByMachine
DEALLOCATE RevByMachine

-- Select the result set that is returned by this procedure.
SELECT
   MachineNbr, CasinoMachineNbr, GameCode, GameName, GameTypeCode,
   CashDeposited, TabsPlayed, DollarsPlayed, WinningTabs, MoneyWon,
   TabsForfeited, NetRevenue, VoucherInTotal, VoucherOutTotal, VoucherPaidTotal
FROM #RevenueByMachine
ORDER BY CasinoMachineNbr
GO
