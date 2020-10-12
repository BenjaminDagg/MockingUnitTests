SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_ZeroPlay user stored procedure.

  Created: 07-12-2010 by Terry Watkins

  Purpose: Retrieves a list of Hand Pay transactions that occurred within the
           specified date range.

Arguments:
   @AcctDate: Accounting date on which to report

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-12-2010     v7.2.2
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_ZeroPlay] @AcctDate DateTime
AS

-- SET NOCOUNT ON added to prevent return of unwanted data.
SET NOCOUNT ON

-- Variable Declarations
DECLARE @MachineNumber CHAR(5)
DECLARE @PlayCount     INT

-- Variable Initialization

-- Create the resultset.
SELECT
   ms.MACH_NO     AS MachineNbr,
   gs.GAME_DESC   AS GameName,
   CAST(0 AS Int) AS PlayCount
INTO #MachinePlayCount
FROM dbo.MACH_SETUP ms
   JOIN dbo.GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE ms.MACH_NO <> '0' AND ms.REMOVED_FLAG = 0


-- Cursor declaration.
DECLARE MachineList CURSOR FOR
   SELECT MachineNbr FROM #MachinePlayCount
   
-- Open MachineList cursor.
OPEN MachineList

-- Begin Cursor processing...
FETCH FROM MachineList INTO @MachineNumber

WHILE (@@FETCH_STATUS = 0)
   -- Successfully FETCHed a record, so update the temporary table.
   BEGIN
      -- Check for Current and FollowOn Deals
      SELECT @PlayCount = ISNULL(SUM(PLAY_COUNT), 0) FROM MACHINE_STATS WHERE ACCT_DATE = @AcctDate
      
      -- Update HasCurrentDeal and HasFollowOnDeal columns in the temp table.
      UPDATE #MachinePlayCount SET PlayCount = @PlayCount WHERE CURRENT OF MachineList
      
      -- Reset variables...
      SET @PlayCount = 0
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM MachineList INTO @MachineNumber
   END

-- Close and Deallocate Cursor
CLOSE MachineList
DEALLOCATE MachineList

-- Create the result set for the report.
SELECT MachineNbr, GameName FROM #MachinePlayCount WHERE PlayCount = 0

-- Drop the temp table.
DROP TABLE #MachinePlayCount
GO
