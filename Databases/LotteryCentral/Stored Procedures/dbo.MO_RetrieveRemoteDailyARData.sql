SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure: MO_RetrieveRemoteDailyARData user stored procedure.

Created: 07-07-2013 by Aldo Zamora

Purpose: 

Arguments: 


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   07-07-2013     
  Initial coding.

Josh Brown    12-30-2015
  Case 62063 - Added @Date as a parameter. If @Date is NULL, then default to the prior accounting date.
  This is to allow shutdown script to pass the current date instead of the assumed Day before
  
Edris Khestoo 12-31-2015
  Case 61909 -  Implemented fix of issue that created duplicate entries on central if the data was on central but transfred flag = 0. This is because a network hiccup or spike could prevent the 
	@UpdateARTransferredSQL and 	 @UpdateARTransferredSQL from executing event if other queries were run successfully. 
  
Louis Epstein 06-08-2018
	Add functionality to calculate transaction date
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[MO_RetrieveRemoteDailyARData]
   @RemoteServer VARCHAR(64)
   ,@LocationID INT
   ,@Date DATETIME = NULL

AS
--------------------------------
--Log Execution Time Variables--
--------------------------------
Declare @StartTime as DateTime
Declare @EndTime as DateTime
Declare @LogMessage as Varchar(200)
--------------------------------
--------------------------------
--Log Execution Time StartTime--
--------------------------------
set @StartTime = getdate()
--------------------------------

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @CorrectTransferedFlagsSQL VARCHAR(MAX)

DECLARE @ARDataSQL VARCHAR(MAX)

DECLARE @EpochDays INT
DECLARE @ErrorDescription VARCHAR(4000)
DECLARE @ErrorID INT
DECLARE @EventTypeID INT
DECLARE @EventSource VARCHAR(MAX)
DECLARE @PulltabSalesSQL VARCHAR(MAX)
DECLARE @TransactionDate INT
DECLARE @UpdateARTransferredSQL VARCHAR(MAX)
DECLARE @UpdatePulltabSalesTransferredSQL VARCHAR(MAX)

DECLARE @ARData TABLE
   (DailyARDataID INT
    ,LocationID INT
    ,SequenceNumber INT
    ,DocumentNumber INT
    ,CasinoGameID INT
    ,DocumentCode INT
    ,TransactionAmount INT)

DECLARE @PulltabSales TABLE
   (DailyPulltabSalesID INT
    ,LocationID INT
    ,MachNo CHAR(5)
    ,CasinoMachNo VARCHAR(8)
    ,AccountingDate VARCHAR(8)
    ,CasinoGameID INT
    ,GameDescription VARCHAR(64)
    ,AmountPlayed INT
    ,PlayCount INT
    ,AmountWon INT
    ,WinCount INT
    ,CommissionsAmount INT)

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
IF @Date IS NULL
BEGIN
	SET @Date = GETDATE()
END

SET @ErrorID = 0
SET @TransactionDate = REPLACE(CAST(@Date AS DATE), '-', '')
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())

SELECT @EventTypeID = EventTypeId FROM dbo.EventType WHERE EventName = 'MOLotteryAccounting'

-- SQL Query will update date transfered and transfered flag if they are null or false but are already transfered to central (in case of network hiccups between the last transfer and update)
SET @CorrectTransferedFlagsSQL = 
'  UPDATE R2
  SET	R2.Transferred =1,
		R2.DateTransferred =	(SELECT ISNULL(MIN(DateProcessed), GETDATE()) FROM MO_DailyPulltabSales C WHERE C.DailyPulltabSalesId = R2.DailyPullTabSalesId AND C.LocationId = R2.LocationId GROUP BY C.DailyPullTabSalesId)
   FROM ' + @RemoteServer + '.dbo.MO_DailyPulltabSales R2
   WHERE R2.DailyPulltabSalesID IN (SELECT DailyPulltabSalesID FROM dbo.MO_DailyPulltabSales C WHERE C.DailyPulltabSalesId = R2.DailyPullTabSalesId AND C.LocationId = R2.LocationId)
   AND (R2.Transferred = 0 OR R2.DateTransferred IS NULL);
   
  UPDATE R1
  SET	R1.Transferred =1,
		R1.DateTransferred =	(SELECT ISNULL(MIN(DateProcessed), GETDATE()) FROM MO_DailyARData C WHERE C.DailyARDataID = R1.DailyARDataID AND C.LocationId = R1.LocationId GROUP BY C.DailyARDataID)
    FROM ' + @RemoteServer + '.dbo.MO_DailyARData R1
   WHERE R1.DailyARDataID IN (SELECT DailyARDataID FROM dbo.MO_DailyARData C WHERE C.DailyARDataID = R1.DailyARDataID AND C.LocationId = R1.LocationId)
   AND (R1.Transferred = 0 OR R1.DateTransferred IS NULL);'


SET @ARDataSQL =
   'SELECT
      DailyARDataID
      ,LocationID
      ,SequenceNumber
      ,DocumentNumber
      ,CasinoGameID
      ,DocumentCode
      ,TransactionAmount
   FROM ' + @RemoteServer + '.dbo.MO_DailyARData R1
   WHERE Transferred = 0 
   AND R1.DailyARDataID NOT IN (SELECT DailyARDataID FROM dbo.MO_DailyARData C WHERE C.DailyARDataID = R1.DailyARDataID AND C.LocationId = R1.LocationId)'

SET @PulltabSalesSQL = 
   'SELECT
      DailyPulltabSalesID
      ,LocationID
      ,MachNo
      ,CasinoMachNo
      ,AccountingDate
      ,CasinoGameID
      ,GameDescription
      ,AmountPlayed
      ,PlayCount
      ,AmountWon
      ,WinCount
      ,CommissionsAmount
   FROM ' + @RemoteServer + '.dbo.MO_DailyPulltabSales R2
   WHERE Transferred = 0 
   AND R2.DailyPulltabSalesID NOT IN (SELECT DailyPulltabSalesID FROM dbo.MO_DailyPulltabSales C WHERE C.DailyPulltabSalesId = R2.DailyPullTabSalesId AND C.LocationId = R2.LocationId) '

SET @UpdateARTransferredSQL =
   N'UPDATE ' + @RemoteServer + '.dbo.MO_DailyARData
    SET Transferred = 1, DateTransferred = GETDATE()
    WHERE Transferred = 0'

SET @UpdatePulltabSalesTransferredSQL =
   'UPDATE ' + @RemoteServer + '.dbo.MO_DailyPulltabSales
    SET Transferred = 1, DateTransferred = GETDATE()
    WHERE Transferred = 0'

BEGIN TRY

/*
--------------------------------------------------------------------------------
   -- First execute CorrectTransferedFlagsSQL in case there are records on retail that are not transfered but were populated to central
   -- This used to occur if connection issue after the commit of this transaction but before the comitt of the next transaction below
--------------------------------------------------------------------------------
*/

 SET @EventSource = 'MO_RetrieveDailyARData - CorrectTransferedFlagsSQL'
 EXECUTE(@CorrectTransferedFlagsSQL)
 
END TRY
BEGIN CATCH   

   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT INTO EventLog
      (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId, LocationID)
   VALUES
      (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CONVERT(VARCHAR(10), @ErrorID),  @ErrorDescription, @EventSource, -1, @LocationID)
      
END CATCH

/*
--------------------------------------------------------------------------------
   Retrieve DailyARData and DailyPulltabSales
--------------------------------------------------------------------------------
*/

IF @ErrorID = 0 
BEGIN 
	BEGIN TRANSACTION RetrieveData
	BEGIN TRY
	   

	   SET @EventSource = 'MO_RetrieveDailyARData - DailyARData'

	   INSERT   INTO @ARData
				EXECUTE (@ARDataSQL)
	     
	   SET @EventSource = 'MO_RetrieveDailyARData - DailyPulltabSales'

	   INSERT   INTO @PulltabSales
				EXECUTE (@PulltabSalesSQL)

	   INSERT   INTO dbo.MO_DailyARData
				SELECT
				   DailyARDataID
				  ,LocationID
				  ,SequenceNumber
				  ,DocumentNumber
				  ,CasinoGameID
				  ,DocumentCode
				  ,TransactionAmount
				  ,REPLACE(CAST(DATEADD(dd, (([DocumentNumber] + 100000) - ((([DocumentNumber] + 100000)/1000) * 1000)) - 1, dateadd(yy, ([DocumentNumber] + 100000)/1000, 0)) AS DATE), '-', '')
				  ,0
				  ,NULL
				  ,NULL
				FROM
				   @ARData
				WHERE
				   TransactionAmount <> 0

	   INSERT   INTO dbo.MO_DailyPulltabSales
				SELECT
				   DailyPulltabSalesID
				  ,LocationID
				  ,MachNo
				  ,CasinoMachNo
				  ,AccountingDate
				  ,CasinoGameID
				  ,GameDescription
				  ,AmountPlayed
				  ,PlayCount
				  ,AmountWon
				  ,WinCount
				  ,CommissionsAmount
				  ,0
				  ,NULL
				  ,NULL
				FROM
				   @PulltabSales
				WHERE
				   (AmountPlayed > 0
					OR AmountWon > 0
					OR PlayCount > 0
					OR WinCount > 0
					OR CommissionsAmount > 0)

	   COMMIT TRANSACTION RetrieveData

	END TRY

	BEGIN CATCH

	   ROLLBACK TRANSACTION RetrieveData

	   SET @ErrorID = ERROR_NUMBER()
	   SET @ErrorDescription = ERROR_MESSAGE()
	   
	   INSERT INTO EventLog
		  (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId, LocationID)
	   VALUES
		  (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CONVERT(VARCHAR(10), @ErrorID),  @ErrorDescription, @EventSource, -1, @LocationID)
	END CATCH
END


/*
--------------------------------------------------------------------------------
   Update retail site and mark rows as processed.
--------------------------------------------------------------------------------
*/

BEGIN TRY
   IF @ErrorID = 0
      BEGIN
         SET @EventSource = 'MO_RetrieveDailyARData - Update DailyARData'
         
         EXECUTE(@UpdateARTransferredSQL)
         
         SET @EventSource = 'MO_RetrieveDailyARData - Update DailyPulltabSales'
         
         EXECUTE(@UpdatePulltabSalesTransferredSQL)
      END
END TRY

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT INTO EventLog
      (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId, LocationID)
   VALUES
      (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CONVERT(VARCHAR(10), @ErrorID),  @ErrorDescription, @EventSource, -1, @LocationID)
END CATCH

--------------------------------
--Log Execution Time Insertlog--
--------------------------------
set @EndTime = getdate()
set @LogMessage= 'ExecutionTime Start: ' +  CONVERT(VARCHAR(30),@StartTime,120) + ' End: ' + CONVERT(VARCHAR(30),@EndTime,120) 
  
   INSERT INTO EventLog
      (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId, LocationID)
   VALUES
      (@EpochDays, @Date, @EventTypeID, @LogMessage,  CONVERT(VARCHAR(10),DATEDIFF(MINUTE,@StartTime,@EndTime)), 'MO_ProcessDailyARData', -1, @LocationID)
---------------------------------
GO
