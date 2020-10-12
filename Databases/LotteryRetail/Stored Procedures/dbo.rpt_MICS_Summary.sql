SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/* 
--------------------------------------------------------------------------------
Procedure: rpt_MICS_Summary user stored procedure.

  Created: 07-13-2004 by Terry Watkins

  Purpose: Returns data for the report MICS requirements report.
           Uses new MICS_STATS summary table and replaces rpt_MICS stored proc.

Arguments: @DealNumber:  Deal number to report on.


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-13-2004     
  Initial coding

Terry Watkins 08-17-2009     v7.0.0
  Modified to retrieve progressive info from the GAME_TYPE table and from the
  new PROGRESSIVE_TYPE table.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[rpt_MICS_Summary] @DealNumber Integer
AS

SET NOCOUNT ON

-- Variables for initial data retrieval.
DECLARE @CoinsBet              SmallInt
DECLARE @DealDesc              VarChar(64)
DECLARE @Denomination          SmallMoney
DECLARE @FormNumber            VarChar(10)
DECLARE @IsProgressive         Bit
DECLARE @LinesBet              TinyInt
DECLARE @PercentPlayed         Decimal(9,6) 
DECLARE @ProductDesc           VarChar(64)
DECLARE @ProgressiveTotal      Money
DECLARE @ProgressiveTypeID     Int
DECLARE @TabAmount             SmallMoney
DECLARE @TabsPerDeal           Integer
DECLARE @TabsPlayed            Integer
DECLARE @TotalProgCont         Decimal(8,6)


-- Retrieve the Deal Setup information.
SELECT
   @FormNumber        = ds.FORM_NUMB,
   @DealDesc          = ds.DEAL_DESCR,
   @ProgressiveTypeID = gt.PROGRESSIVE_TYPE_ID,
   @TotalProgCont     = pt.TOTAL_CONTRIBUTION,
   @Denomination      = ds.DENOMINATION,
   @CoinsBet          = ds.COINS_BET,
   @LinesBet          = ds.LINES_BET,
   @TabsPerDeal       = ds.NUMB_ROLLS * ds.TABS_PER_ROLL,
   @TabAmount         = ds.TAB_AMT,
   @ProductDesc       = p.PRODUCT_DESCRIPTION
FROM DEAL_SETUP ds
   JOIN CASINO_FORMS     cf ON ds.FORM_NUMB = cf.FORM_NUMB
   JOIN GAME_TYPE        gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN PRODUCT           p ON gt.PRODUCT_ID = p.PRODUCT_ID
   JOIN PROGRESSIVE_TYPE pt ON gt.PROGRESSIVE_TYPE_ID = pt.PROGRESSIVE_TYPE_ID
WHERE DEAL_NO = @DealNumber

-- Retrieve total tabs played in the Deal...
SELECT @TabsPlayed = ISNULL(SUM(PLAY_COUNT), 0) FROM DEAL_STATS WHERE DEAL_NO = @DealNumber

-- Compute the Deal play percent complete...
IF @@ROWCOUNT > 0
   SET @PercentPlayed = 100.0 * @TabsPlayed / @TabsPerDeal
ELSE
   SET @PercentPlayed = 0

-- Set the IsProgressive flag and total accumulated progressive amount for the deal...
IF (@ProgressiveTypeID > 0)
   BEGIN
      SET @IsProgressive = 1
      SET @ProgressiveTotal = (@TotalProgCont / 100) * @TabsPerDeal * @TabAmount
   END
ELSE
   BEGIN
      SET @IsProgressive = 0
      SET @ProgressiveTotal = 0
   END


-- Create a temporary table to store results
CREATE TABLE #MICSReport (
   FormNumber            VARCHAR(10) NOT NULL,
   DealDesc		          VARCHAR(64) NOT NULL,
   TabAmount             SMALLMONEY NOT NULL,
   IsProgressive         BIT NOT NULL,
   PercentPlayed         DECIMAL(5,2) NOT NULL,
   PayoutTier            SMALLMONEY NOT NULL,
   TabsPlayed            INTEGER NULL,
   TabsPerDeal           INTEGER NULL,
   ExpectedWinsToDate    DECIMAL(9,2) NOT NULL,
   ActualWinsToDate      INTEGER NOT NULL,
   TotalTierWinners      INTEGER NOT NULL,
   ExpectedPayoutToDate  MONEY NOT NULL,
   BasePayoutToDate      MONEY NOT NULL,
   ActualPayoutToDate    MONEY NOT NULL,
   TotalTierPayout       MONEY NOT NULL,
   ProgressiveTotal      MONEY NOT NULL,
   Denomination          SMALLMONEY,
   CoinsBet              SMALLINT,
   LinesBet              TINYINT,
   ProductDesc           VARCHAR(64)
)

ALTER TABLE #MICSReport WITH NOCHECK ADD CONSTRAINT [PK_MICSReport] PRIMARY KEY NONCLUSTERED ([PayoutTier])

-- Insert summary report data into temp table...
INSERT INTO #MICSReport
SELECT
   @FormNumber              AS FormNumber,
   @DealDesc                AS DealDesc,
   @TabAmount               AS TabAmount,
   @IsProgressive           AS IsProgressive,
   @PercentPlayed           AS PercentPlayed,
   wt.WINNING_AMOUNT        AS PayoutTier,
   @TabsPlayed              AS TabsPlayed,
   @TabsPerDeal             AS TabsPerDeal,
   (SUM(wt.NUMB_OF_WINNERS) * @PercentPlayed) / 100 AS ExpectedWinsToDate,
   ms.WIN_COUNT             AS ActualWinsToDate,
   SUM(wt.NUMB_OF_WINNERS)  AS TotalTierWinners,
   (wt.WINNING_AMOUNT * SUM(wt.NUMB_OF_WINNERS) * @PercentPlayed) / 100 AS ExpectedPayoutToDate,
   ms.WIN_AMOUNT * ms.WIN_COUNT AS BasePayoutToDate,
   (ms.WIN_AMOUNT  * ms.WIN_COUNT) + SUM(ms.PROG_AMOUNT) AS ActualPayoutToDate,
   SUM(wt.NUMB_OF_WINNERS) * ms.WIN_AMOUNT AS TotalTierPayout,
   @ProgressiveTotal        AS ProgressiveTotal,
   @Denomination            AS Denomination,
   @CoinsBet                AS CoinsBet,
   @LinesBet                AS LinesBet,
   @ProductDesc             AS ProductDesc
FROM WINNING_TIERS wt
   JOIN MICS_STATS ms ON DEAL_NO = @DealNumber AND wt.WINNING_AMOUNT = ms.WIN_AMOUNT
WHERE wt.FORM_NUMB = @FormNumber
GROUP BY wt.WINNING_AMOUNT, ms.WIN_COUNT, ms.WIN_AMOUNT
ORDER BY wt.WINNING_AMOUNT


-- Insert data for tiers that have no data...
INSERT INTO #MICSReport
SELECT
   @FormNumber             AS FormNumber,
   @DealDesc               AS DealDesc,
   @TabAmount              AS TabAmount,
   @IsProgressive          AS IsProgressive,
   @PercentPlayed          AS PercentPlayed,
   wt.WINNING_AMOUNT       AS PayoutTier,
   @TabsPlayed             AS TabsPlayed,
   @TabsPerDeal            AS TabsPerDeal,
   (SUM(wt.NUMB_OF_WINNERS) * @PercentPlayed) / 100 AS ExpectedWinsToDate,
   0                       AS ActualWinsToDate,
   SUM(wt.NUMB_OF_WINNERS) AS TotalTierWinners,
   (wt.WINNING_AMOUNT * SUM(wt.NUMB_OF_WINNERS) * @PercentPlayed) / 100 AS ExpectedPayoutToDate,
   0                       AS BasePayoutToDate,
   0                       AS ActualPayoutToDate,
   SUM(wt.NUMB_OF_WINNERS * wt.WINNING_AMOUNT) AS TotalTierPayout,
   @ProgressiveTotal       AS ProgressiveTotal,
   @Denomination           AS Denomination,
   @CoinsBet               AS CoinsBet,
   @LinesBet               AS LinesBet,
   @ProductDesc            AS ProductDesc
FROM WINNING_TIERS wt
WHERE
   wt.FORM_NUMB = @FormNumber AND
   wt.WINNING_AMOUNT NOT IN (SELECT PayoutTier FROM #MICSReport)
GROUP BY wt.WINNING_AMOUNT
ORDER BY wt.WINNING_AMOUNT

-- Retrieve the data for the report.
SELECT
   FormNumber, DealDesc, TabAmount, IsProgressive, PercentPlayed, PayoutTier,
   TabsPlayed, TabsPerDeal, ExpectedWinsToDate, ActualWinsToDate, TotalTierWinners,
   ExpectedPayoutToDate, BasePayoutToDate, ActualPayoutToDate, TotalTierPayout,
   ProgressiveTotal, Denomination, CoinsBet, LinesBet, ProductDesc
FROM #MICSReport
ORDER BY PayoutTier
GO
