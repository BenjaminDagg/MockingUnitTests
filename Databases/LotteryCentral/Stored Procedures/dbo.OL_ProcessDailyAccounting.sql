SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure: OL_ProcessDailyAccounting user stored procedure.

Created: 08-13-2014 by Cj Price

Purpose: This procedure will collect all machine stat data from each remote 
server daily. It will run for each job created in JobStatus and will collect
data and store in OL_DailyAccounting.

Arguments: None


Change Log:

Changed By    Date           Database Version 3.2.7
  Change Description
--------------------------------------------------------------------------------
Cj Price   08-13-2014     
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[OL_ProcessDailyAccounting] 

AS

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @AccountingDate DATETIME
DECLARE @Date DATETIME
DECLARE @DatabaseName AS VARCHAR(64)
DECLARE @EpochDays INT
DECLARE @ErrorDescription VARCHAR(4000)
DECLARE @ErrorID INT
DECLARE @EventTypeID INT
DECLARE @JulianDate INT
DECLARE @LocationID INT
DECLARE @RemoteServer VARCHAR(64)
DECLARE @RowID INT
DECLARE @ServerName VARCHAR(32)
DECLARE @TransactionDate INT

/*
--------------------------------------------------------------------------------
   Declare Variable Tables
--------------------------------------------------------------------------------
*/
DECLARE @Location TABLE
(RowID INT
 ,LocationID INT
 ,ServerName NVARCHAR(32)
 ,DatabaseName VARCHAR(64))

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/

SET @Date = DATEADD(day, -1, GETDATE())
SET @AccountingDate = DATEADD(DAY, DATEDIFF(DAY, 0, @Date), 0)
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())

SELECT @EventTypeID = EventTypeId FROM dbo.EventType WHERE EventName = 'OLLotteryAccounting'

SET @JulianDate = RIGHT(CAST(YEAR(@AccountingDate) AS CHAR(4)),2) +
                  RIGHT('000' + CAST(DATEPART(dy, @AccountingDate) AS VARCHAR(3)),3)

SET @TransactionDate = REPLACE(CAST(@Date AS DATE), '-', '')

/*
--------------------------------------------------------------------------------
   Collect data from all locations and insert into OL tables.
--------------------------------------------------------------------------------
*/
BEGIN TRY    
   INSERT INTO @Location
      SELECT
         ROW_NUMBER() OVER(ORDER BY LocationID)
         ,LocationID
         ,ServerName
         ,DatabaseName
      FROM dbo.JobStatus
      WHERE
         JobName = 'OL_InsertDailyAccountingData'
         AND Success = 1
         AND DATEADD(DAY, DATEDIFF(DAY, 0, ExecutedDate), 0) = DATEADD(DAY, 1, @AccountingDate)

   SELECT @RowID = COUNT(RowID) FROM @Location

   WHILE @RowID > 0
      BEGIN
         SELECT
            @LocationID = LocationID       
            ,@ServerName = ServerName
            ,@DatabaseName = DatabaseName
         FROM @Location
         WHERE RowID = @RowID

         SET @RemoteServer = @ServerName + '.' + @DatabaseName
         
         EXEC dbo.OL_RetrieveRemoteDailyAccountingData
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
      (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + @ErrorID,  @ErrorDescription, 'OL_ProcessDailyAccounting', -1)
END CATCH

GO
