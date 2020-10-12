SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: MO_ProcessDailyARData user stored procedure.

Created: 07-07-2013 by Aldo Zamora

Purpose: 

Arguments: 


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   07-07-2013     
  Initial coding.

Edris Khestoo 10-04-2018
  Add fix to only include vouchers when UCV_TRANSFERRED = 1
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[MO_ProcessDailyARData] 

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
DECLARE @Identity INT
DECLARE @JulianDate INT
DECLARE @LocationID INT
DECLARE @RemoteServer VARCHAR(64)
DECLARE @RowID INT
DECLARE @ServerName VARCHAR(32)
DECLARE @TransactionDate INT
DECLARE @VoucherTransferDate DATETIME
DECLARE @VoucherEpirationDays INT

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

DECLARE @VoucherTable TABLE
   (VoucherID INT
   ,LocationID INT
   ,CasinoGameID INT
   ,ExpiredVoucherAmount MONEY)

DECLARE @PulltabVoucherSummary TABLE
    (LocationID INT
    ,CasinoGameID INT
    ,ExpiredVoucherAmount MONEY)

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SELECT @VoucherEpirationDays = ItemValueInt
FROM dbo.AppSetting
WHERE ItemKey = 'VoucherExpirationDays'

SET @Date = DATEADD(day, -1, GETDATE())
SET @AccountingDate = DATEADD(DAY, DATEDIFF(DAY, 0, @Date), 0)
SET @VoucherTransferDate = DATEADD(DAY, -@VoucherEpirationDays, GETDATE())
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())

SELECT @EventTypeID = EventTypeId FROM dbo.EventType WHERE EventName = 'MOLotteryAccounting'

SET @JulianDate = RIGHT(CAST(YEAR(@AccountingDate) AS CHAR(4)),2) +
                  RIGHT('000' + CAST(DATEPART(dy, @AccountingDate) AS VARCHAR(3)),3)
SELECT @Identity =
CASE
   WHEN MAX(DailyARDataID) IS NULL THEN 1
   WHEN MAX(DailyARDataID) > 0 THEN MAX(DailyARDataID) + 1
END
FROM dbo.MO_DailyARData WHERE LocationID = 0

SET @TransactionDate = REPLACE(CAST(@Date AS DATE), '-', '')

/*
--------------------------------------------------------------------------------
   Process Central expired vouchers.
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT INTO @VoucherTable
      SELECT
         v.VOUCHER_ID   
         ,v.LOCATION_ID
         ,gs.CASINO_GAME_ID
         ,v.VOUCHER_AMOUNT
      FROM
         dbo.VOUCHER v
         JOIN dbo.MACH_SETUP ms ON v.CREATED_LOC = ms.MACH_NO
         JOIN dbo.GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE AND gs.GAME_TITLE_ID = v.GAME_TITLE_ID
      WHERE
         v.VOUCHER_TYPE < 2 AND
         v.REDEEMED_STATE = 0 AND
         v.CREATE_DATE <= @VoucherTransferDate AND
		 v.UCV_TRANSFERRED = 1 AND		 
         v.IS_VALID = 1 AND  
         v.VOUCHER_ID NOT IN (SELECT VoucherID
                              FROM dbo.VouchersToARFile
                              WHERE
                                 DocumentNumber > 0
                                 AND VoucherID = v.VOUCHER_ID
                                 AND LocationID = v.LOCATION_ID)
      GROUP BY
         v.VOUCHER_ID       
         ,v.LOCATION_ID
         ,gs.CASINO_GAME_ID
         ,v.VOUCHER_AMOUNT
      ORDER BY
         v.LOCATION_ID    
         ,v.VOUCHER_ID         
         ,gs.CASINO_GAME_ID
   
   INSERT INTO @PulltabVoucherSummary
      SELECT
         LocationID
         ,CasinoGameID
         ,ISNULL(SUM(ExpiredVoucherAmount), 0)
      FROM @VoucherTable
      GROUP BY
         LocationID
         ,CasinoGameID

   INSERT INTO dbo.MO_DailyARData
      SELECT
         @Identity
         ,LocationID
         ,ROW_NUMBER() OVER (ORDER BY CasinoGameID)
         ,@JulianDate
         ,CasinoGameID
         ,6009
         ,CAST(ROUND((SUM(ExpiredVoucherAmount) *.2) * 100, 0) AS INT)
         ,@TransactionDate
         ,0
         ,NULL
         ,NULL    
      FROM @PulltabVoucherSummary
      GROUP BY
         LocationID
         ,CasinoGameID
      UNION ALL
        SELECT
         @Identity
         ,LocationID
         ,ROW_NUMBER() OVER (ORDER BY CasinoGameID)
         ,@JulianDate
         ,CasinoGameID
         ,6010
         ,CAST(REPLACE(SUM(ExpiredVoucherAmount), '.', '') AS INT)
         ,@TransactionDate
         ,0
         ,NULL
         ,NULL    
      FROM @PulltabVoucherSummary
      GROUP BY
         LocationID
         ,CasinoGameID    

      UPDATE dbo.VouchersToARFile
      SET DocumentNumber = @JulianDate
      WHERE
         VoucherID IN (SELECT VoucherID FROM @VoucherTable)
         AND LocationID IN (SELECT LocationID FROM @VoucherTable)
		 
END TRY

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()

   INSERT INTO EventLog
      (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId, LocationID)
   VALUES
      (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CONVERT(VARCHAR(10), @ErrorID),  @ErrorDescription, 'MO_ProcessDailyARData', -1, 0)

END CATCH

/*
--------------------------------------------------------------------------------
   Collect data from all locations and insert into MO tables.
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
         JobName = 'MO_InsertDailyAccountingData'
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
         
         EXEC dbo.MO_RetrieveRemoteDailyARData
              @RemoteServer = @RemoteServer
              ,@LocationID = @LocationID
      
         SET @RowID = @RowID - 1
      END
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT INTO EventLog
      (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId, LocationID)
   VALUES
      (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CONVERT(VARCHAR(10), @ErrorID),  @ErrorDescription, 'MO_ProcessDailyARData', -1, @LocationID)
END CATCH
GO
