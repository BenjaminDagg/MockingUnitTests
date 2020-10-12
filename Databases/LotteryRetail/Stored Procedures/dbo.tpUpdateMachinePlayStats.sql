SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpUpdateMachinePlayStats

Desc: Inserts or updates MACHINE_PLAY_Stats information.

Written: 10-03-2006 by Terry Watkins

Called by: tpTrans* (Play transactions)

Parameters:
   @MachineNumber     DGE Machine Identifier
   @CasinoMachineNbr  Casino Machine Identifier
   @DealNo            Deal Number
   @GameCode          Game Code of the machine
   @Denom             Denomination played
   @CoinsBet          Coins bet
   @LinesBet          Lines bet
   @AmountPlayed      Tab cost, cost of play
   @AmountWon         Amount won
   @AcctDate          Accounting date
   @LocationID        Location Identifier


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 10-03-2006     v5.0.8
  Initial coding.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added arg @LocationID to support new MACHINE_PLAY_STATS.LOCATION_ID column.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpUpdateMachinePlayStats]
   @MachineNumber     Char(5),
   @CasinoMachineNbr  VarChar(8),
   @DealNo            Int,
   @GameCode          VarChar(3),
   @Denom             SmallMoney,
   @CoinsBet          Int,
   @LinesBet          Int,
   @AmountPlayed      Money,
   @AmountWon         Money,
   @AcctDate          DateTime,
   @LocationID        Int
AS

-- Variable Declarations
DECLARE @AccountingMonth  Int
DECLARE @AccountingYear   Int

-- Variable Initialization
IF @DealNo           IS NULL SET @DealNo = 0
IF @CoinsBet         IS NULL SET @CoinsBet = 0
IF @LinesBet         IS NULL SET @LinesBet = 0
IF @Denom            IS NULL SET @Denom = 0.01
IF @MachineNumber    IS NULL SET @MachineNumber = ''
IF @CasinoMachineNbr IS NULL SET @CasinoMachineNbr = ''
IF @GameCode         IS NULL SET @GameCode = ''

SET @AccountingMonth = MONTH(@AcctDate)
SET @AccountingYear  = YEAR(@AcctDate)

-- Update or Insert data in MACHINE_PLAY_STATS table...
IF EXISTS (SELECT * FROM MACHINE_PLAY_STATS
           WHERE
              MACH_NO        = @MachineNumber    AND
              CASINO_MACH_NO = @CasinoMachineNbr AND
              DEAL_NO        = @DealNo           AND
              GAME_CODE      = @GameCode         AND
              DENOM          = @Denom            AND
              COINS_BET      = @CoinsBet         AND
              LINES_BET      = @LinesBet         AND
              ACCT_MONTH     = @AccountingMonth  AND
              ACCT_YEAR      = @AccountingYear)
   BEGIN
      -- Record exists, so update it.
      UPDATE MACHINE_PLAY_STATS SET
         PLAY_COUNT    = PLAY_COUNT + 1,
         AMOUNT_PLAYED = AMOUNT_PLAYED + @AmountPlayed,
         AMOUNT_WON    = AMOUNT_WON    + @AmountWon
      WHERE
        MACH_NO        = @MachineNumber    AND
        CASINO_MACH_NO = @CasinoMachineNbr AND
        DEAL_NO        = @DealNo           AND
        GAME_CODE      = @GameCode         AND
        DENOM          = @Denom            AND
        COINS_BET      = @CoinsBet         AND
        LINES_BET      = @LinesBet         AND
        ACCT_MONTH     = @AccountingMonth  AND
        ACCT_YEAR      = @AccountingYear
   END
ELSE
   -- Record does not exist, so insert a new row.
   BEGIN
      INSERT INTO MACHINE_PLAY_STATS
         (MACH_NO, CASINO_MACH_NO, DEAL_NO, GAME_CODE, LOCATION_ID,
          DENOM, COINS_BET, LINES_BET, PLAY_COUNT, AMOUNT_PLAYED, AMOUNT_WON,
          ACCT_MONTH, ACCT_YEAR)
      VALUES
         (@MachineNumber, @CasinoMachineNbr, @DealNo, @GameCode, @LocationID,
          @Denom, @CoinsBet, @LinesBet, 1, @AmountPlayed, @AmountWon,
          @AccountingMonth, @AccountingYear)
   END
GO
