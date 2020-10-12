SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Account_Summary user stored procedure.

  Created: 09/05/2002 by Norm Symonds

  Purpose: Returns summarized data from Casino_Trans Table for the report
           cr_Account_Summary_Report

Arguments: @StartDate:  Starting DateTime for the resultset
           @EndDate:    Ending DateTime for the resultset


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Norm Symonds  09-05-2002
  Initial Coding

Terry Watkins 11-11-2003
  Filtered out DGE rows (DGE Tech accounts). Line 67.
  Added JOIN (line 115) to get correct Tab amount.

Terry Watkins 07-12-2004
  Modified calculation of TabsPlayedInDollars to use
  CASINO_TRANS DENOM * COINS_BET * LINES_BET instead of DEAL_SETUP TAB_AMT.
  Was getting incorrect values for multi-denom games.

Terry Watkins 03-28-2005     v4.0.1
  Modified calculation of TabsPlayedInDollars to use new column PRESSED_COUNT.

Terry Watkins 06-15-2005     v4.1.4
  Changed datatype of @AccountNbr from Char(16) to VarChar(20).

Terry Watkins 10-18-2005     v4.2.3
  Modified to correctly calculate Dollar amount Played for Keno games.
  Added ELSE 0 to end of TabsPlayedInDollars calculation in the CURSOR SELECT
  statement to prevent return of a NULL value when there is no play activity.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Account_Summary] (@StartDate DateTime, @EndDate DateTime)
AS

-- Variables for the cursor...
DECLARE @AccountNbr          VarChar(20)

DECLARE @MinTransNo          Int
DECLARE @MaxTransNo          Int

DECLARE @CashDeposited       Money
DECLARE @TabsPlayedInDollars Money
DECLARE @MoneyWonInDollars   Money
DECLARE @CashWithdrawn       Money
DECLARE @BalanceCleared      Money

-- Variables for the table that are computed from transaction information called from the cursor information...
--DECLARE @FirstTxnType        Char(2)
DECLARE @FirstTransAmt       Money 
DECLARE @FirstTabAmt         Money 
DECLARE @FirstEndingBalance  Money 
DECLARE @BeginningBalance    Money
DECLARE @EndingBalance       Money
DECLARE @FirstTransID        SmallInt

SET NOCOUNT ON

DECLARE AccountSummary CURSOR  FAST_FORWARD
FOR
SELECT
   ct.CARD_ACCT_NO  AS AccountNbr,
   MIN(ct.TRANS_NO) AS MinTransNo,
   MAX(ct.TRANS_NO) AS MaxTransNo,
   SUM(CASE ct.TRANS_ID  WHEN 20 THEN ISNULL(ct.TRANS_AMT, 0) ELSE 0 END) AS CashDeposited,
   SUM(CASE ct.TRANS_ID
      WHEN 10 THEN
         CASE ISNULL(ds.TYPE_ID, '')
            WHEN 'K' THEN ISNULL(ct.DENOM * ct.COINS_BET, 0)
                     ELSE ISNULL(ct.DENOM * ct.COINS_BET * ct.LINES_BET * (ct.PRESSED_COUNT + 1), 0) END
      WHEN 11 THEN
         CASE ISNULL(ds.TYPE_ID, '')
            WHEN 'K' THEN ISNULL(ct.DENOM * ct.COINS_BET, 0)
                     ELSE ISNULL(ct.DENOM * ct.COINS_BET * ct.LINES_BET * (ct.PRESSED_COUNT + 1), 0) END
      WHEN 12 THEN
         CASE ISNULL(ds.TYPE_ID, '')
            WHEN 'K' THEN ISNULL(ct.DENOM * ct.COINS_BET, 0)
                     ELSE ISNULL(ct.DENOM * ct.COINS_BET * ct.LINES_BET * (ct.PRESSED_COUNT + 1), 0) END
      WHEN 13 THEN
         CASE ISNULL(ds.TYPE_ID, '')
            WHEN 'K' THEN ISNULL(ct.DENOM * ct.COINS_BET, 0)
                     ELSE ISNULL(ct.DENOM * ct.COINS_BET * ct.LINES_BET * (ct.PRESSED_COUNT + 1), 0) END
      ELSE 0
         END) AS TabsPlayedInDollars,
   SUM(CASE TRANS_ID  WHEN 11 THEN ISNULL(ct.TRANS_AMT, 0)
                      WHEN 12 THEN ISNULL(ct.TRANS_AMT, 0) ELSE 0 END) AS MoneyWonInDollars,
   SUM(CASE TRANS_ID  WHEN 24 THEN ISNULL(ct.TRANS_AMT, 0) ELSE 0 END) AS CashWithdrawn,
   SUM(CASE TRANS_ID  WHEN 25 THEN ISNULL(ct.TRANS_AMT, 0) ELSE 0 END) AS BalanceCleared
FROM CASINO_TRANS ct
   LEFT OUTER JOIN DEAL_SETUP ds ON ct.DEAL_NO = ds.DEAL_NO
WHERE
   ct.DTIMESTAMP BETWEEN @StartDate AND @EndDate AND
   ct.TRANS_ID IN (10,11,12,13,20,24,25,40,41)   AND  --(old trans types: L,W,J,F,M,P,Z,I,E)
   ct.CARD_ACCT_NO NOT IN ('INVALID','INTERNAL') AND
   ct.CARD_ACCT_NO NOT LIKE 'DGE001%'
GROUP BY ct.CARD_ACCT_NO
ORDER BY ct.CARD_ACCT_NO

-- Create a temporary table to store results
CREATE TABLE #DailyAccountSummary (
   AccountNbr          VARCHAR(20) NOT NULL, 
   BeginningBalance    MONEY, --  min(dtimestamp) AS FirstTxn, 
   CashDeposited       MONEY, 
   TabsPlayedInDollars MONEY,
   MoneyWonInDollars   MONEY,
   NetToCasino         MONEY,
   CashWithdrawn       MONEY,
   BalanceCleared      MONEY,
   EndingBalance       MONEY --  max(dtimestamp) AS LastTxn,
)

ALTER TABLE #DailyAccountSummary WITH NOCHECK
   ADD CONSTRAINT [PK_Acct_NBR] PRIMARY KEY NONCLUSTERED (AccountNbr)

-- Open the cursor.
OPEN AccountSummary

-- Get the first row of data.
-- PRINT 'Fetching first row'
FETCH FROM AccountSummary INTO
   @AccountNbr, @MinTransNo, @MaxTransNo, @CashDeposited,
   @TabsPlayedInDollars, @MoneyWonInDollars, @CashWithdrawn, @BalanceCleared

WHILE (@@FETCH_STATUS = 0)
      -- Successfully FETCHed a record, so insert a new row into the temp table.
   BEGIN
      INSERT INTO #DailyAccountSummary
          (AccountNbr, BeginningBalance, CashDeposited, TabsPlayedInDollars,
           MoneyWonInDollars, NetToCasino, CashWithdrawn, BalanceCleared, EndingBalance)
      VALUES
          (@AccountNbr, 0, @CashDeposited, @TabsPlayedInDollars, 
           @MoneyWonInDollars, @TabsPlayedInDollars - @MoneyWonInDollars, @CashWithdrawn, @BalanceCleared, 0)
      
      -- Retrieve Beginning values...
      SELECT
         @FirstEndingBalance = BALANCE, 
         @FirstTransID       = TRANS_ID,
         @FirstTransAmt      = TRANS_AMT,
         @FirstTabAmt        = ISNULL(DENOM * COINS_BET * LINES_BET, 0)
      FROM CASINO_TRANS
      WHERE TRANS_NO = @MinTransNo
      
      SET @BeginningBalance = 
          CASE WHEN @FirstTransID IN (40,41) THEN @FirstEndingBalance
               WHEN @FirstTransID = 20       THEN @FirstEndingBalance - @FirstTransAmt
               WHEN @FirstTransID IN (24,25) THEN @FirstEndingBalance + @FirstTransAmt
               WHEN @FirstTransID IN (11,12) THEN @FirstEndingBalance + @FirstTabAmt - @FirstTransAmt
               WHEN @FirstTransID IN (10,13) THEN @FirstEndingBalance + @FirstTabAmt
               ELSE 0 END
      
      -- Retrieve Ending Balance.
      SELECT @EndingBalance = BALANCE
      FROM CASINO_TRANS
      WHERE TRANS_NO = @MaxTransNo
      
      -- Update the Temp table..
      UPDATE #DailyAccountSummary
      SET BeginningBalance = @BeginningBalance, EndingBalance = @EndingBalance
      WHERE AccountNbr = @AccountNbr
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM AccountSummary INTO
         @AccountNbr, @MinTransNo, @MaxTransNo, @CashDeposited,
         @TabsPlayedInDollars, @MoneyWonInDollars, @CashWithdrawn, @BalanceCleared
   END

-- Close and Deallocate Cursor
CLOSE AccountSummary
DEALLOCATE AccountSummary

-- Now select all rows from the temp table as the returned recordset.
SELECT
   AccountNbr, BeginningBalance, CashDeposited, TabsPlayedInDollars,
   MoneyWonInDollars, NetToCasino, CashWithdrawn, BalanceCleared, EndingBalance
FROM #DailyAccountSummary ORDER BY AccountNbr
GO
