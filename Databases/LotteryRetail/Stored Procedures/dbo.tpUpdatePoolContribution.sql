SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpUpdatePoolContribution

Desc: Updates the POOL_CONTRIBUTION table.

Written: 02-08-2010 by Terry Watkins

Called by: Play transaction handling stored procedures
           (tpTransL, tpTransW, tpTransJ, tpTransF)

Parameters:
   @ProgressivePoolID Identifies a PROGRESSIVE_POOL row
   @AcctDate          Accounting Date
   @PlayCost          Amount wagered
   @PRate1            Pool 1 Contribution Rate
   @PRate2            Pool 2 Contribution Rate
   @PRate3            Pool 3 Contribution Rate

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 02-08-2010     v7.1.0
  Initial coding.

Louis Epstein 05-28-2013     v7.3.2
  Rewrite of stored procedure to support multi level progressives.
  
Cj Price 09-10-2013     v7.3.6
  Update of stored procedure to update correct pool for multi level progressives.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpUpdatePoolContribution]
   @ProgressivePoolID Int,
   @Pool1Contribution Money,
   @Pool2Contribution Money,
   @Pool3Contribution Money,
   @AcctDate          DateTime
AS

IF NOT EXISTS (SELECT * FROM POOL_CONTRIBUTION WHERE
           PROGRESSIVE_POOL_ID = @ProgressivePoolID AND
           ACCT_DATE           = @AcctDate)
	BEGIN
		INSERT POOL_CONTRIBUTION (PROGRESSIVE_POOL_ID, POOL_NUMBER, ACCT_DATE, AMOUNT)
			 SELECT PROGRESSIVE_POOL_ID, 1, @AcctDate, 0
			 FROM PROGRESSIVE_POOL
			 WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID
			 
		INSERT POOL_CONTRIBUTION (PROGRESSIVE_POOL_ID, POOL_NUMBER, ACCT_DATE, AMOUNT)
			 SELECT PROGRESSIVE_POOL_ID, 2, @AcctDate, 0
			 FROM PROGRESSIVE_POOL
			 WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID
			 
		INSERT POOL_CONTRIBUTION (PROGRESSIVE_POOL_ID, POOL_NUMBER, ACCT_DATE, AMOUNT)
			 SELECT PROGRESSIVE_POOL_ID, 3, @AcctDate, 0
			 FROM PROGRESSIVE_POOL
			 WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID

	END

	UPDATE POOL_CONTRIBUTION SET AMOUNT = AMOUNT + @Pool1Contribution
      WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID AND
         POOL_NUMBER = 1 AND
         ACCT_DATE           = @AcctDate

	UPDATE POOL_CONTRIBUTION SET AMOUNT = AMOUNT + @Pool2Contribution
      WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID AND
         POOL_NUMBER = 2 AND
         ACCT_DATE           = @AcctDate
         
    UPDATE POOL_CONTRIBUTION SET AMOUNT = AMOUNT + @Pool3Contribution
      WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID AND
         POOL_NUMBER = 3 AND
         ACCT_DATE           = @AcctDate
GO
