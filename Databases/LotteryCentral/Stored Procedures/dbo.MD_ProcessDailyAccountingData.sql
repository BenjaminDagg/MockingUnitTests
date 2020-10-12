SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure: MD_ProcessDailyAccountingData user stored procedure.

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
CREATE PROCEDURE [dbo].[MD_ProcessDailyAccountingData] 

AS

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @AccountingDate DATETIME
DECLARE @DatabaseName AS VARCHAR(64)
DECLARE @Date DATETIME
DECLARE @EpochDays INT
DECLARE @ErrorDescription VARCHAR(4000)
DECLARE @ErrorID INT
DECLARE @EventTypeID INT
DECLARE @LocationID INT
DECLARE @RemoteServer VARCHAR(64)
DECLARE @RowID INT
DECLARE @ServerName VARCHAR(32)

/*
--------------------------------------------------------------------------------
   Declare Variable Tables
--------------------------------------------------------------------------------
*/
DECLARE @Location TABLE (RowID INT
                        ,LocationID INT
                        ,ServerName NVARCHAR(32)
                        ,DatabaseName VARCHAR(64))

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SET @Date = GETDATE()
SET @AccountingDate = DATEADD(DAY, DATEDIFF(DAY, 0, @Date), 0)
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())
SELECT @EventTypeID = EventTypeId FROM dbo.EventType WHERE EventName = 'MDLotteryAccounting'

/*
--------------------------------------------------------------------------------
   Collect data from all locations and insert into MO tables.
--------------------------------------------------------------------------------
*/
BEGIN TRY    
   INSERT INTO @Location
      SELECT
         ROW_NUMBER() OVER (ORDER BY LocationID) AS RowID
        ,*
      FROM
         (SELECT DISTINCT
            LocationID
           ,ServerName
           ,DatabaseName
          FROM
            dbo.JobStatus
          WHERE
            JobName = 'MD_InsertDailyAccountingData'
            AND Success = 1
            AND DATEADD(DAY, DATEDIFF(DAY, 0, ExecutedDate), 0) = @AccountingDate) Base

   SELECT @RowID = COUNT(RowID) FROM @Location

   WHILE @RowID > 0
      BEGIN
         SELECT
            @LocationID = LocationID       
            ,@ServerName = ServerName
            ,@DatabaseName = DatabaseName
         FROM @Location
         WHERE RowID = @RowID

         SET @RemoteServer = '[' + @ServerName + '].' + @DatabaseName
         
         EXEC dbo.MD_RetrieveRemoteDailyAccountingData
              @RemoteServer = @RemoteServer
              ,@LocationID = @LocationID
      
         SET @RowID = @RowID - 1
      END
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT INTO EventLog
      (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
      (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)),  @ErrorDescription, 'MD_RetrieveRemoteDailyAccountingData', -1)
END CATCH
GO
