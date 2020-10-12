SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure: MD_InsertUpdateRemoteAdjustments user stored procedure.

Created: 04-10-2014 by Aldo Zamora

Purpose: 

Arguments: 


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   04-10-2014     
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[MD_InsertUpdateRemoteAdjustments]
   @RemoteServer VARCHAR(64)
   ,@LocationID INT
   ,@SiteID INT
   ,@StartDate DATETIME
   ,@EndDate DATETIME
AS

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @CentralID INT
DECLARE @Date DATETIME
DECLARE @EpochDays INT
DECLARE @ErrorDescription VARCHAR(4000)
DECLARE @ErrorID INT
DECLARE @EventTypeID INT
DECLARE @RetrieveRetailAdjustmentIDsSQL VARCHAR(MAX)
DECLARE @RowID INT
DECLARE @SQL VARCHAR(MAX)
DECLARE @AdjustmentTypeId VARCHAR(11)
DECLARE @Amount VARCHAR(11)
DECLARE @AdjustmentDate VARCHAR(20)
DECLARE @Comment VARCHAR(256)
DECLARE @IsCommissionAffected CHAR(1)
DECLARE @CreatedByUserId VARCHAR(11)
DECLARE @CreatedDate VARCHAR(20)
DECLARE @ModifiedByUserId VARCHAR(11)
DECLARE @ModifiedDate VARCHAR(20)
DECLARE @IsActive CHAR(1)

/*
--------------------------------------------------------------------------------
   Declare Variable Tables
--------------------------------------------------------------------------------
*/
DECLARE @RetailAdjustmentIDs TABLE (AccountingAdjustmentId INT
                                   ,CentralAccountingAdjustmentID INT)

DECLARE @CentralAdjustments TABLE (RowID INT
                                  ,AccountingAdjustmentId INT
                                  ,AdjustmentTypeId INT
                                  ,SiteId INT
                                  ,Amount MONEY
                                  ,AdjustmentDate DATETIME
                                  ,RetailerNumber VARCHAR(8)
                                  ,Comment VARCHAR(256)
                                  ,IsCommissionAffected BIT
                                  ,CreatedByUserId INT
                                  ,CreatedDate DATETIME
                                  ,ModifiedByUserId INT
                                  ,ModifiedDate DATETIME
                                  ,IsActive BIT)

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SET @Date =  GETDATE()
SET @ErrorID = 0
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())

SELECT @EventTypeID = EventTypeId
FROM dbo.EventType 
WHERE EventName = 'MDLotteryAccounting'

SET @RetrieveRetailAdjustmentIDsSQL = 
   'SELECT
       AccountingAdjustmentId
      ,CentralAccountingAdjustmentID
   FROM ' + @RemoteServer + '.dbo.AccountingAdjustments'

/*
--------------------------------------------------------------------------------
   Retrieve MD_DailyAccounting
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT INTO @RetailAdjustmentIDs EXECUTE(@RetrieveRetailAdjustmentIDsSQL)
   
   INSERT   INTO @CentralAdjustments
            SELECT
               ROW_NUMBER() OVER (ORDER BY AccountingAdjustmentId)          
              ,AccountingAdjustmentId
              ,AdjustmentTypeId
              ,SiteId
              ,Amount
              ,AdjustmentDate
              ,RetailerNumber
              ,Comment
              ,IsCommissionAffected
              ,CreatedByUserId
              ,CreatedDate
              ,ModifiedByUserId
              ,ModifiedDate
              ,IsActive
            FROM dbo.AccountingAdjustments
            WHERE
               SiteId = @SiteID
               AND Transferred = 0
               AND IsActive = 1   

   SELECT @RowID = COUNT(RowID) FROM @CentralAdjustments

   WHILE @RowID > 0 
      BEGIN
         -- Initialize variables  
         SELECT
           @CentralID             = CONVERT(VARCHAR(11), AccountingAdjustmentId)
           ,@AdjustmentTypeId     = CONVERT(VARCHAR(11), AdjustmentTypeId)
           ,@Amount               = CONVERT(VARCHAR(11), Amount)
           ,@AdjustmentDate       = CONVERT(VARCHAR, AdjustmentDate, 120)
           ,@Comment              = Comment
           ,@IsCommissionAffected = CONVERT(CHAR(1), IsCommissionAffected)
           ,@CreatedByUserId      = CONVERT(VARCHAR(11), CreatedByUserId)
           ,@CreatedDate          = CONVERT(VARCHAR, CreatedDate, 120)
           ,@ModifiedByUserId     = CONVERT(VARCHAR(11), ModifiedByUserId)
           ,@ModifiedDate         = CONVERT(VARCHAR, ModifiedDate, 120)
           ,@IsActive             = CONVERT(CHAR(1), IsActive)
         FROM @CentralAdjustments
         WHERE RowID = @RowID

          -- Is this going to be an update or insert...
         IF EXISTS (SELECT * FROM @RetailAdjustmentIDs WHERE CentralAccountingAdjustmentID = CAST(@CentralID AS INT)) 
            BEGIN
        	      -- Update existing row...
               SET @SQL =
                 'UPDATE ' + @RemoteServer + '.dbo.AccountingAdjustments
                  SET
                     AdjustmentTypeId     = ' + @AdjustmentTypeId + '
                    ,Amount               = ' + @Amount + '
                    ,AdjustmentDate       = ' + '''' + @AdjustmentDate + '''' + '
                    ,Comment              = ' + '''' + REPLACE(@Comment, '''', '''''') + '''' + '
                    ,IsCommissionAffected = ' + @IsCommissionAffected + '
                    ,ModifiedByUserId     = ' + @ModifiedByUserId + '
                    ,ModifiedDate         = ' + '''' + @ModifiedDate + '''' + ' 
                    ,IsActive             = ' + @IsActive + '
                   WHERE CentralAccountingAdjustmentID = ' + CONVERT(VARCHAR(11), @CentralID)
                   
               EXECUTE (@SQL)
            END
         ELSE 
            BEGIN
           	   -- Insert new row...
               SET @SQL =
                  'INSERT INTO ' + @RemoteServer + '.dbo.AccountingAdjustments
                     (CentralAccountingAdjustmentID, AdjustmentTypeId, SiteId, Amount, AdjustmentDate, Comment
                     ,IsCommissionAffected, CreatedByUserId, CreatedDate, ModifiedByUserId, ModifiedDate, IsActive)
                  VALUES
                     (' + CONVERT(VARCHAR(11), @CentralID) + ',' + @AdjustmentTypeId + ',' + CONVERT(VARCHAR(11), @SiteId) + ',' + @Amount + ',' + '''' + @AdjustmentDate + '''' + ',' + 
					       '''' + REPLACE(@Comment, '''', '''''') + '''' + ',' + @IsCommissionAffected + ',' + @CreatedByUserId + ',' + 
					      '''' + @CreatedDate + '''' + ',' + @ModifiedByUserId + ',' + '''' + @ModifiedDate + '''' + ',' + @IsActive + ')'

               EXECUTE (@SQL)
            END
             
         -- Update row count.   
         SET @RowID = @RowID - 1
         
         -- Update transferred rows.
         UPDATE dbo.AccountingAdjustments
         SET
            Transferred = 1
            ,DateTransferred = @Date
         WHERE
            SiteId = CAST(@SiteID AS INT)
            AND AccountingAdjustmentId = @CentralID
      END

END TRY

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT INTO EventLog
      (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
      (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)),  @ErrorDescription, 'MD_InsertUpdateRemoteAdjustments', -1)
END CATCH
GO
