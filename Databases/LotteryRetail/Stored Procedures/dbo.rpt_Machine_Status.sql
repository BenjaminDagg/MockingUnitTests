SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Machine_Status user stored procedure.

  Created: 04/20/2005 by Terry Watkins

  Purpose: Return data for the Machine Activity Report.

Arguments:

Change Log:

Changed By    Change Date    Database Version
 Change Description
--------------------------------------------------------------------------------
Terry Watkins 04-20-2005     v4.1.0
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Machine_Status] @AcctDate DateTime

AS

-- Variable Declarations
DECLARE @AmountPlayed   Money
DECLARE @AmountWon      Money
DECLARE @GameCode       VarChar(3)
DECLARE @MachineNbr     Char(5)
DECLARE @PlayCount      Integer

-- Cursor Declaration
DECLARE MachineList CURSOR FAST_FORWARD
FOR
SELECT MACH_NO, GAME_CODE FROM MACH_SETUP WHERE REMOVED_FLAG = 0 AND MACH_NO <> '0' ORDER BY MACH_NO


-- Create a temporary table to store results
CREATE TABLE #MachineInfo (
   MachNo              Char(5),
   GameCode            VarChar(3),
   PlayCount           Integer,
   AmountPlayed        Money,
   AmountWon           Money
)


-- Open the cursor.
OPEN MachineList

FETCH FROM MachineList INTO @MachineNbr, @GameCode

WHILE (@@FETCH_STATUS = 0)
   -- Successfully FETCHed a record, so insert a new row into the temp table.
   BEGIN
      SELECT
         @PlayCount    = ISNULL(SUM(PLAY_COUNT), 0),
         @AmountPlayed = ISNULL(SUM(AMOUNT_PLAYED), 0),
         @AmountWon    = ISNULL(SUM(AMOUNT_WON + AMOUNT_JACKPOT + AMOUNT_FORFEITED), 0)
      FROM MACHINE_STATS WHERE MACH_NO = @MachineNbr AND ACCT_DATE = @AcctDate
      
      INSERT INTO #MachineInfo
         (MachNo, GameCode, PlayCount, AmountPlayed, AmountWon)
      VALUES
         (@MachineNbr, @GameCode, @PlayCount, @AmountPlayed, @AmountWon)
      -- Get the next machine number.
      FETCH NEXT FROM MachineList INTO @MachineNbr, @GameCode
   END

-- Close and Deallocate Cursor
CLOSE MachineList
DEALLOCATE MachineList


-- Retrieve the data...
SELECT
   mi.MachNo,
   mi.GameCode,
   gs.GAME_DESC,
   mi.PlayCount,
   mi.AmountPlayed,
   mi.AmountWon,
   mi.AmountPlayed - mi.AmountWon AS NetAmount
FROM #MachineInfo mi
   LEFT OUTER JOIN GAME_SETUP gs ON mi.GameCode = gs.GAME_CODE
ORDER BY GameCode, MachNo

DROP TABLE #MachineInfo
GO
