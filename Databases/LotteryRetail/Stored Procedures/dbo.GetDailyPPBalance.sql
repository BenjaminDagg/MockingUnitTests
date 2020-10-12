SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: GetDailyPPBalance user stored procedure.

  Created: 02-11-2010 by Aldo Zamora  

  Purpose: Retrieves the daily balance for each progressive pool.

Arguments: None

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
2010-02-11 Aldo Zamora       v7.1.0
  Initial coding.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[GetDailyPPBalance]
AS
-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @AcctDateYesterday DateTime
DECLARE @Pool1             Money
DECLARE @Pool2             Money
DECLARE @Pool3             Money
DECLARE @ProgressivePoolID Int
DECLARE @TimeStamp         DateTime

-- Variable Initialization
SET @AcctDate           = [dbo].[ufnGetAcctDate]()
SET @AcctDateYesterday  = DATEADD(day, -1, @AcctDate)
SET @TimeStamp          = GETDATE()

DECLARE PPStartingBalance CURSOR FAST_FORWARD FOR 
   SELECT PROGRESSIVE_POOL_ID, POOL_1, POOL_2, POOL_3
   FROM PROGRESSIVE_POOL
   ORDER BY PROGRESSIVE_POOL_ID

OPEN PPStartingBalance

-- Perform the first fetch and store the values in variables.
FETCH NEXT FROM PPStartingBalance INTO @ProgressivePoolID, @Pool1, @Pool2, @Pool3

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- Insert the ending balance from the previous day for pool 1 into the POOL_EVENT table.
      INSERT INTO POOL_EVENT
         (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
      VALUES
         (5, @ProgressivePoolID, 1, @TimeStamp, @AcctDateYesterday, @Pool1)
      
      -- Insert the ending balance from the previous day for pool 2 into the POOL_EVENT table.
      INSERT INTO POOL_EVENT
         (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
      VALUES
         (5, @ProgressivePoolID, 2, @TimeStamp, @AcctDateYesterday, @Pool2)
      
      -- Insert the ending balance from the previous day for pool 3 into the POOL_EVENT table.
      INSERT INTO POOL_EVENT
         (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
      VALUES
         (5, @ProgressivePoolID, 3, @TimeStamp, @AcctDateYesterday, @Pool3)

      -- Insert the daily starting balance from pool 1 into the POOL_EVENT table.
      INSERT INTO POOL_EVENT
         (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
      VALUES
         (4, @ProgressivePoolID, 1, @TimeStamp, @AcctDate, @Pool1)
      
      -- Insert the daily starting balance from pool 2 into the POOL_EVENT table.
      INSERT INTO POOL_EVENT
         (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
      VALUES
         (4, @ProgressivePoolID, 2, @TimeStamp, @AcctDate, @Pool2)
      
      -- Insert the daily starting balance from pool 3 into the POOL_EVENT table.
      INSERT INTO POOL_EVENT
         (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
      VALUES
         (4, @ProgressivePoolID, 3, @TimeStamp, @AcctDate, @Pool3)
      
      -- This is executed as long as the previous fetch succeeds.
      FETCH NEXT FROM PPStartingBalance INTO @ProgressivePoolID, @Pool1, @Pool2, @Pool3
   END 

-- Clean up.
CLOSE PPStartingBalance
DEALLOCATE PPStartingBalance
GO
