SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure: OL_RetrieveRemoteDailyAccountingData user stored procedure.

Created: 08-13-2014 by Cj Price

Purpose: This stored procedure retrieves all data from remote retail table
LotteryRetail/OL_DailyAccounting and inserts it into 
LotteryCentral/OL_DailyAccounting.

Arguments: @RemoteServer - Retail Servers Database Name to connect to 
                           LotteryRetail
           @LocationID - Retail Casino's Location Id


Change Log:

Changed By    Date           Database Version 3.2.7
  Change Description
--------------------------------------------------------------------------------
Cj Price   08-13-2014     
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[OL_RetrieveRemoteDailyAccountingData]
   @RemoteServer VARCHAR(64)
   ,@LocationID INT

AS

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @Date DATETIME
DECLARE @EpochDays INT
DECLARE @ErrorDescription VARCHAR(4000)
DECLARE @ErrorID INT
DECLARE @EventTypeID INT
DECLARE @OLDailyAccountingSQL VARCHAR(MAX)
DECLARE @UpdateOLDailyAccountingTransferredSQL VARCHAR(MAX)

DECLARE @OLDailyAccounting TABLE (RetailOLDailyAccountingID INT
                                 ,LocationID INT                           
                                 ,MachineNumber VARCHAR(8)
                                 ,CasinoMachineNumber VARCHAR(8)
                                 ,GameDescription VARCHAR(64)
                                 ,GameTitleId INT
                                 ,FormNumber VARCHAR(20)
                                 ,DealNumber INT
                                 ,TabTypeId INT
                                 ,GameCode VARCHAR(3)
                                 ,GameTypeCode VARCHAR(2)
                                 ,AmountPlayed MONEY
                                 ,AmountWon MONEY
                                 ,AmountJackpot MONEY
                                 ,AmountProg MONEY
                                 ,PlayCount INT
                                 ,WinCount INT
                                 ,JackpotCount INT
                                 ,PurchaseAmount VARCHAR(20)
                                 ,CommissionsAmount MONEY
                                 ,AccountingDate DATETIME)

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
WHERE EventName = 'OLLotteryAccounting'

SET @OLDailyAccountingSQL = 
   'SELECT
      RetailOLDailyAccountingID
     ,LocationId
     ,MachineNumber
     ,CasinoMachineNumber
     ,GameDescription
     ,GameTitleId
     ,FormNumber
     ,DealNumber
     ,TabTypeId
     ,GameCode
     ,GameTypeCode
     ,AmountPlayed
     ,AmountWon
     ,AmountJackpot
     ,AmountProg
     ,PlayCount
     ,WinCount
     ,JackpotCount
     ,PurchaseAmount
     ,CommissionsAmount
     ,AccountingDate
   FROM ' + @RemoteServer + '.dbo.OL_DailyAccounting WHERE Transferred = 0'

SET @UpdateOLDailyAccountingTransferredSQL =
   'UPDATE ' + @RemoteServer + '.dbo.OL_DailyAccounting
    SET Transferred = 1, DateTransferred = GETDATE()
    WHERE Transferred = 0'

/*
--------------------------------------------------------------------------------
   Retrieve OL_DailyAccounting
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT INTO @OLDailyAccounting EXECUTE(@OLDailyAccountingSQL)

   EXECUTE(@UpdateOLDailyAccountingTransferredSQL)

   INSERT   INTO dbo.OL_DailyAccounting
            SELECT
               RetailOLDailyAccountingID
              ,LocationId
              ,MachineNumber
              ,CasinoMachineNumber
              ,GameDescription
              ,GameTitleId
              ,FormNumber
              ,DealNumber
              ,TabTypeId
              ,GameCode
              ,GameTypeCode
              ,AmountPlayed
              ,AmountWon
              ,AmountJackpot
              ,AmountProg
              ,PlayCount
              ,WinCount
              ,JackpotCount
              ,PurchaseAmount
              ,CommissionsAmount
              ,AccountingDate
              ,0
              ,NULL
            FROM @OLDailyAccounting
END TRY

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT INTO EventLog
      (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
      (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)),  @ErrorDescription, 'OL_RetrieveRemoteDailyAccountingData', -1)
END CATCH

GO
