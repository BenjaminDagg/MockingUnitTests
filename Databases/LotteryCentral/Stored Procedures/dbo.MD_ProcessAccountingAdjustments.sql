SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure: MD_ProcessAccountingAdjustments user stored procedure.

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
CREATE PROCEDURE [dbo].[MD_ProcessAccountingAdjustments] 

AS

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @DatabaseName AS VARCHAR(64)
DECLARE @Date DATETIME
DECLARE @EndDate DATETIME
DECLARE @EpochDays INT
DECLARE @ErrorDescription VARCHAR(4000)
DECLARE @ErrorID INT
DECLARE @EventTypeID INT
DECLARE @FDOW INT
DECLARE @LocationID INT
DECLARE @PeriodStartDate DATETIME
DECLARE @RemoteServer VARCHAR(64)
DECLARE @RetailerNumber VARCHAR(8)
DECLARE @RowID INT
DECLARE @SiteID INT
DECLARE @ServerName VARCHAR(32)
DECLARE @StartDate DATETIME

/*
--------------------------------------------------------------------------------
   Declare Variable Tables
--------------------------------------------------------------------------------
*/
DECLARE @Location TABLE (RowID INT
                        ,LocationID INT
                        ,SiteID INT
                        ,ServerName NVARCHAR(32)
                        ,DatabaseName VARCHAR(64))

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SET @Date = GETDATE()
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())
SELECT @EventTypeID = EventTypeId FROM dbo.EventType WHERE EventName = 'MDLotteryAccounting'

SELECT @FDOW = ConfigValue
FROM AccountingConfig
WHERE ConfigKey = 'FirstDayOfWeek'

SET DATEFIRST @FDOW

SET @PeriodStartDate = CONVERT(VARCHAR(10), DATEADD(DD, -6, @Date), 111)

-- Set Start and End date.
SET @StartDate = DATEADD(DD, 1 - DATEPART(DW, @PeriodStartDate), @PeriodStartDate)
SET @EndDate = DATEADD(DD, 6, @StartDate)

/*
--------------------------------------------------------------------------------
   Collect LocationIDs to process and execute Insert/Update.
--------------------------------------------------------------------------------
*/
BEGIN TRY    
   INSERT   INTO @Location
            SELECT
               ROW_NUMBER() OVER (ORDER BY cas.LOCATION_ID)
              ,cas.LOCATION_ID
              ,aa.SiteId
              ,dbinfo.SERVER_NAME
              ,dbinfo.DatabaseName              
            FROM
               dbo.AccountingAdjustments aa
               JOIN dbo.CASINO cas ON aa.RetailerNumber = cas.RETAILER_NUMBER
               JOIN dbo.DB_INFO dbinfo ON cas.LOCATION_ID = dbinfo.LocationID
            WHERE
               aa.Transferred = 0
               AND aa.IsActive = 1

   SELECT @RowID = COUNT(RowID) FROM @Location

   WHILE @RowID > 0
      BEGIN
         SELECT
            @LocationID = LocationID 
            ,@SiteID = SiteId
            ,@ServerName = ServerName
            ,@DatabaseName = DatabaseName
         FROM @Location
         WHERE RowID = @RowID

         SET @RemoteServer = '[' + @ServerName + '].' + @DatabaseName
         
         EXEC dbo.MD_InsertUpdateRemoteAdjustments
              @RemoteServer = @RemoteServer
              ,@LocationID = @LocationID
              ,@SiteID = @SiteID
              ,@StartDate = @StartDate
              ,@EndDate = @EndDate
      
         SET @RowID = @RowID - 1
      END
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT INTO EventLog
      (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
      (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)),  @ErrorDescription, 'MD_ProcessAccountingAdjustments', -1)
END CATCH
GO
