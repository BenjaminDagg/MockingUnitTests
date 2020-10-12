SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: UpdateProgressivePools

Desc: Updates progressive pools amounts with the necessary contributions.

Called by: tpTransW,tpTransF,tpTransJ,tpTransL,tpTransProgC3Play

Parameters:
   @@ProgressiveTypeID int
   @GameTypeCode varchar(2)
   @MachineDenomination int
   @TabCost smallmoney
   @PRate1 decimal(9,8)
   @PRate2 decimal(9,8)
   @PRate3 decimal(9,8)

Author: Louis Epstein

Date: 07-16-2013

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 07-16-2013     v7.3.2
   Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[UpdateProgressivePools]
   @ProgressiveTypeID int,
   @AcctDate datetime,
   @GameTypeCode varchar(2),
   @MachineDenomination int,
   @TabCost smallmoney,
   @ProgressiveWinPoolID int = -1,
   @TimeStamp datetime = NULL
AS

DECLARE @Pool1Contribution money, @Pool2Contribution money, @Pool3Contribution money, @CurrentProgressivePoolID int,
@NewPool1 money, @NewPool2 money, @NewPool3 money, @SeedCount int, @PoolEventID int, @PoolAmount bigint

DECLARE ProgressivePoolCursor CURSOR FOR 
SELECT PROGRESSIVE_POOL_ID
FROM PROGRESSIVE_POOL
WHERE
 PROGRESSIVE_TYPE_ID = @ProgressiveTypeID   AND
 GAME_TYPE_CODE      = @GameTypeCode        AND
 DENOMINATION        = @MachineDenomination

OPEN ProgressivePoolCursor

FETCH NEXT FROM ProgressivePoolCursor 
INTO @CurrentProgressivePoolID

WHILE @@FETCH_STATUS = 0
BEGIN

SELECT 
@Pool1Contribution = ((@TabCost) * (Rate1 / 100)),
@Pool2Contribution = ((@TabCost) * (Rate2 / 100)),
@Pool3Contribution = ((@TabCost) * (Rate3 / 100)),
@NewPool1 = POOL_1 + ((@TabCost) * (Rate1 / 100)),
@NewPool2 = POOL_2 + ((@TabCost) * (Rate2 / 100)),
@NewPool3 = POOL_3 + ((@TabCost) * (Rate3 / 100)),
@SeedCount = SeedCount
FROM PROGRESSIVE_POOL
WHERE PROGRESSIVE_POOL_ID = @CurrentProgressivePoolID

IF @CurrentProgressivePoolID = @ProgressiveWinPoolID
BEGIN

-- Insert progressive win event into the POOL_EVENT table.
          INSERT INTO POOL_EVENT
             (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
          VALUES
             (1, @CurrentProgressivePoolID, 1, @TimeStamp, @AcctDate, @NewPool1)
          
          -- Insert progressive transfer out of pool1 event into the POOL_EVENT table.
          INSERT INTO POOL_EVENT
             (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
          VALUES
             (3, @CurrentProgressivePoolID, 1, @TimeStamp, @AcctDate, @NewPool1)
          
          -- Insert progressive transfer into pool1 from pool2 event into the POOL_EVENT table.
          INSERT INTO POOL_EVENT
             (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
          VALUES
             (2, @CurrentProgressivePoolID, 1, @TimeStamp, @AcctDate, @NewPool2)
          
          -- Insert progressive transfer out pool2 into pool1 event into the POOL_EVENT table.
          INSERT INTO POOL_EVENT
             (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
          VALUES
             (3, @CurrentProgressivePoolID, 2, @TimeStamp, @AcctDate, @NewPool2)
          
          -- Insert progressive transfer into pool2 from pool3 event into the POOL_EVENT table.
          INSERT INTO POOL_EVENT
             (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
          VALUES
             (2, @CurrentProgressivePoolID, 2, @TimeStamp, @AcctDate, @NewPool3)
          
          -- Insert progressive transfer out of pool3 into pool2 event into the POOL_EVENT table.
          INSERT INTO POOL_EVENT
             (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
          VALUES
             (3, @CurrentProgressivePoolID, 3, @TimeStamp, @AcctDate, @NewPool3)
          
          -- Insert progressive transfer in pool3 event into the POOL_EVENT table.
          INSERT INTO POOL_EVENT
             (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
          VALUES
             (2, @CurrentProgressivePoolID, 3, @TimeStamp, @AcctDate, CAST(@SeedCount * @MachineDenomination AS Money) / 100)
          
          -- Reset all progressive pool amounts, moving pool 2 to pool 1, pool 3 to pool 2, and reseed pool 3.
          UPDATE PROGRESSIVE_POOL SET
             POOL_1 = @NewPool2,
             POOL_2 = @NewPool3,
             POOL_3 = CAST(@SeedCount * @MachineDenomination AS Money) / 100
          WHERE PROGRESSIVE_POOL_ID = @CurrentProgressivePoolID

END
ELSE
BEGIN
-- Update the progressive pool values...
UPDATE PROGRESSIVE_POOL SET
POOL_1 = @NewPool1,
POOL_2 = @NewPool2,
POOL_3 = @NewPool3
WHERE PROGRESSIVE_POOL_ID = @CurrentProgressivePoolID
END

-- Update progressive contributions.
EXEC tpUpdatePoolContribution @CurrentProgressivePoolID, @Pool1Contribution, @Pool2Contribution, @Pool3Contribution, @AcctDate


FETCH NEXT FROM ProgressivePoolCursor 
INTO @CurrentProgressivePoolID

END

CLOSE ProgressivePoolCursor;
DEALLOCATE ProgressivePoolCursor;
GO
