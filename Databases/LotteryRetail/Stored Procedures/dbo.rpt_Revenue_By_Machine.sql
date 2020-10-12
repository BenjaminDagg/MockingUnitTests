SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Revenue_By_Machine user stored procedure.

Created: 09/05/2002 by Norm Symonds

Purpose: Returns summarized data for the Daily Revenue by Machine report

Arguments: @Acct_Date:  Accounting date to use for the resultset


Change Log:

Changed By      Date         Database Version
  Change Description
--------------------------------------------------------------------------------
Norm Symonds    2002-09-09
  Initial Coding

Terry Watkins   2004-03-03
  Complete rewrite.  Uses new MACHINE_STATS table.

Terry Watkins   2004-12-18   v4.0.0
  Added VoucherInTotal in support of Ticket In/Ticket Out play.

Nat Mogilevsky  06-24-2005   v4.1.4
  Added VoucherOutTotal field from MACHINE_STATS table. 

Terry Watkins   2005-07-25   v4.1.7
  Minor formatting change to force update in schema upgrade script.

Terry Watkins   2010-06-10   v7.2.2
  Removed check for Millennium machines and attempt to get the denomination of
  the machine from the MACH_SETUP.MACH_DENOM column which has been removed.

Louis Epstein 2014-03-21 v3.2.0
  Added promo credits to report calculations
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Revenue_By_Machine] @Acct_Date DateTime
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
   ms.MACH_NO                                  AS MachineNbr,
   ms.CASINO_MACH_NO                           AS CasinoMachineNbr,
   ms.ACCT_DATE                                AS AccountingDate,
   ms.GAME_CODE                                AS GameCode,
   gs.GAME_DESC                                AS GameName,
   gs.GAME_TYPE_CODE                           AS GameTypeCode,
   p.PRODUCT_ID                                AS ProductID,
   p.PRODUCT_DESCRIPTION                       AS ProductName,
   CAST(0 AS SmallMoney)                       AS MinDenom,
   CAST(0 AS VarChar(32))                      AS DenomRange,
   SUM(ms.AMOUNT_IN)                           AS CashDeposited,
   SUM(ms.PLAY_COUNT)                          AS TabsPlayed,
   SUM(ms.AMOUNT_PLAYED - ms.AMOUNT_PLAYED_PROMO)                       AS DollarsPlayed,
   SUM(ms.WIN_COUNT) + SUM(JACKPOT_COUNT)      AS WinningTabs,
   SUM(ms.AMOUNT_WON) + SUM(AMOUNT_JACKPOT)    AS MoneyWon,
   SUM(ms.FORFEIT_COUNT)                       AS TabsForfeited,
   SUM(ms.AMOUNT_PLAYED - ms.AMOUNT_PLAYED_PROMO - ms.AMOUNT_WON - ms.AMOUNT_JACKPOT) AS NetToCasino,
   SUM(TICKET_IN_AMOUNT)                       AS VoucherInTotal, 
   SUM(TICKET_OUT_AMOUNT)                      AS VoucherOutTotal,
   SUM(ms.AMOUNT_PLAYED_PROMO) AS PromoAmountPlayed,
   SUM(ms.PROMO_IN_AMOUNT) AS PromoVoucherIn
INTO #RevenueByMachine
FROM MACHINE_STATS ms
   JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
   JOIN GAME_TYPE  gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN PRODUCT     p ON gt.PRODUCT_ID = p.PRODUCT_ID
WHERE ACCT_DATE = @Acct_Date
GROUP BY
   ms.MACH_NO,
   ms.CASINO_MACH_NO,
   ms.ACCT_DATE,
   ms.GAME_CODE,
   gs.GAME_DESC,
   gs.GAME_TYPE_CODE,
   p.PRODUCT_ID,
   p.PRODUCT_DESCRIPTION
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
      -- Build the DenomRange column value. Get denom range from DENOM_TO_GAME_TYPE.DENOM_VALUE
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
   MachineNbr, CasinoMachineNbr, AccountingDate, GameCode, GameName,
   GameTypeCode, ProductID, ProductName, MinDenom, DenomRange,
   CashDeposited, TabsPlayed, DollarsPlayed, WinningTabs, MoneyWon,
   TabsForfeited, NetToCasino, VoucherInTotal, VoucherOutTotal, PromoAmountPlayed, PromoVoucherIn
FROM #RevenueByMachine
ORDER BY ProductID, GameCode, MinDenom, CasinoMachineNbr
GO
