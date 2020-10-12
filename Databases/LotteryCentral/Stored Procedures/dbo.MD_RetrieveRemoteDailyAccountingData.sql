SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure: MD_RetrieveRemoteDailyAccountingData user stored procedure.

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
CREATE PROCEDURE [dbo].[MD_RetrieveRemoteDailyAccountingData]
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
DECLARE @MDDailyAccountingSQL VARCHAR(MAX)
DECLARE @UpdateMDDailyAccountingTransferredSQL VARCHAR(MAX)

DECLARE @MDDailyAccounting TABLE (MDDailyAccountingID INT
                                 ,LocationID INT
                                 ,RetailerNumber VARCHAR(8)                               
                                 ,DGMachineNumber INT
                                 ,AmountPlayed MONEY
                                 ,AmountWon MONEY
                                 ,VouchersIssuedAmount MONEY
                                 ,VouchersIssuedCount INT
                                 ,VoucherLiabilitiesAmount MONEY
                                 ,VoucherLiabilitiesCount INT
                                 ,VouchersRedeemedAmount MONEY
                                 ,VouchersRedeemedCount INT
                                 ,ExpiredVoucherAmount MONEY
                                 ,ExpiredVoucherCount INT
                                 ,SalesCommissions MONEY
                                 ,CashingCommissions MONEY
                                 ,Bonus MONEY
                                 ,ITLMLeaseFees MONEY
                                 ,MLGCAShare MONEY                             
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
WHERE EventName = 'MDLotteryAccounting'

SET @MDDailyAccountingSQL = 
   'SELECT
      MDDailyAccountingID
     ,LocationID
     ,RetailerNumber
     ,DGMachineNumber
     ,AmountPlayed
     ,AmountWon
     ,VouchersIssuedAmount
     ,VouchersIssuedCount
     ,VoucherLiabilitiesAmount
     ,VoucherLiabilitiesCount
     ,VouchersRedeemedAmount
     ,VouchersRedeemedCount
     ,ExpiredVoucherAmount
     ,ExpiredVoucherCount
     ,SalesCommissions
     ,CashingCommissions
     ,Bonus
     ,ITLMLeaseFee
     ,MLGCAShare
     ,AccountingDate
   FROM ' + @RemoteServer + '.dbo.MD_DailyAccounting WHERE Transferred = 0'

SET @UpdateMDDailyAccountingTransferredSQL =
   'UPDATE ' + @RemoteServer + '.dbo.MD_DailyAccounting
    SET Transferred = 1, DateTransferred = GETDATE()
    WHERE Transferred = 0'

/*
--------------------------------------------------------------------------------
   Retrieve MD_DailyAccounting
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT INTO @MDDailyAccounting EXECUTE(@MDDailyAccountingSQL)

   EXECUTE(@UpdateMDDailyAccountingTransferredSQL)

   INSERT   INTO MD_DailyAccounting
            SELECT
               MDDailyAccountingID
              ,LocationID
              ,RetailerNumber
              ,DGMachineNumber
              ,AmountPlayed
              ,AmountWon
              ,VouchersIssuedAmount
              ,VouchersIssuedCount
              ,VoucherLiabilitiesAmount
              ,VoucherLiabilitiesCount
              ,VouchersRedeemedAmount
              ,VouchersRedeemedCount
              ,ExpiredVoucherAmount
              ,ExpiredVoucherCount
              ,SalesCommissions
              ,CashingCommissions
              ,Bonus
              ,ITLMLeaseFees
              ,MLGCAShare
              ,AccountingDate
              ,NULL
              ,0
              ,NULL
            FROM @MDDailyAccounting
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
