SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: MD_InsertDailyAccountingData

Created: 05-24-2013 by Aldo Zamora

Purpose: Collects all of the daily AR data needed to generate central AR file.

Arguments: @Date = DATEADD(DAY, -1, GETDATE()) Date data is being collected for.

Change Log:

Changed By    Date           Database Version
   Change Description
--------------------------------------------------------------------------------
Aldo Zamora   05-24-2013     
   Initial coding.
---------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[MD_InsertDailyAccountingData]
   @Date DATETIME

AS

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @AccountingDate DATETIME
DECLARE @ErrorNumber INT
DECLARE @ErrorMessage AS VARCHAR(4000)
DECLARE @LocationID INT
DECLARE @SiteStatus INT
DECLARE @StoredProc VARCHAR(64)
DECLARE @Success BIT
DECLARE @Transferred BIT
DECLARE @VoucherTransferDate DATETIME
DECLARE @VoucherEpirationDays INT

DECLARE @SalesCommissions DECIMAL(7,3)
DECLARE @CashingCommissions DECIMAL(7,2)
DECLARE @Bonus DECIMAL(7,3)
DECLARE @ITLM DECIMAL(7,4)

/*
--------------------------------------------------------------------------------
   Declare Variable Tables
--------------------------------------------------------------------------------
*/
DECLARE @ExpiredVouchers TABLE (VoucherID INT
                               ,DGMachineNumber CHAR(5)
                               ,VoucherAmount MONEY)

DECLARE @Machines TABLE (LocationID INT
                        ,RetailerNumber VARCHAR(8)
                        ,DGMachineNumber CHAR(5))

DECLARE @MachineStats TABLE (DGMachineNumber CHAR(5)
                            ,AmountPlayed MONEY
                            ,AmountWon MONEY)

DECLARE @VouchersIssued TABLE (DGMachineNumber CHAR(5)
                              ,VoucherAmount MONEY
                              ,VoucherCount INT)
                             
DECLARE @VoucherLiability TABLE (DGMachineNumber CHAR(5)
                                  ,VoucherAmount MONEY
                                  ,VoucherCount INT)

DECLARE @VouchersRedeemed TABLE (DGMachineNumber CHAR(5)
                                ,VoucherAmount MONEY
                                ,VoucherCount INT)

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SET @AccountingDate = DATEADD(DAY, DATEDIFF(DAY, 0, @Date), 0)
SET @Bonus = 0.005
SET @CashingCommissions = 0.03
SET @SalesCommissions = 0.055
SET @ITLM = 0.4174
SET @StoredProc = 'MD_InsertDailyAccountingData'
SET @Success = 1
SET @Transferred = 0

SELECT @LocationID = LOCATION_ID FROM dbo.CASINO WHERE SETASDEFAULT = 1

SELECT @SiteStatus = StatusCode FROM dbo.RetailSiteStatus

SELECT @VoucherEpirationDays = CAST(VALUE1 AS INT)
FROM CASINO_SYSTEM_PARAMETERS
WHERE PAR_NAME = 'VOUCHER_EXPIRATION_DAYS'

SET @VoucherTransferDate = DATEADD(d, -@VoucherEpirationDays, GETDATE())

/*
--------------------------------------------------------------------------------
   Delete non transferred data to avoid duplicate data for the same date.
--------------------------------------------------------------------------------
*/
DELETE FROM dbo.MD_DailyAccounting
WHERE AccountingDate = @AccountingDate AND Transferred = 0

/*
--------------------------------------------------------------------------------
   Select pulltab sales data and insert into MO_DailyPulltabSales.
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT   INTO @ExpiredVouchers
            SELECT
               VOUCHER_ID
              ,CREATED_LOC
              ,VOUCHER_AMOUNT
            FROM dbo.VOUCHER
            WHERE
               CREATE_DATE <= @VoucherTransferDate
               AND IS_VALID = 1
               AND REDEEMED_STATE = 0
               AND UCV_TRANSFERRED = 0
               AND VOUCHER_TYPE < 2
            ORDER BY VOUCHER_ID
  
   INSERT   INTO @Machines
            SELECT
               ms.LOCATION_ID
              ,cas.RETAILER_NUMBER
              ,ms.MACH_NO
            FROM
               dbo.MACH_SETUP ms
               JOIN dbo.CASINO cas ON ms.LOCATION_ID = cas.LOCATION_ID
            WHERE MACH_NO > 0

   INSERT   INTO @MachineStats
            SELECT
               MACH_NO
              ,AMOUNT_PLAYED
              ,SUM(AMOUNT_WON + AMOUNT_JACKPOT)
            FROM dbo.MACHINE_STATS
            WHERE
               MACH_NO > 0
               AND ACCT_DATE = @AccountingDate
               AND DEAL_NO > 0
            GROUP BY
               MACH_NO
              ,AMOUNT_PLAYED

   INSERT   INTO @VouchersIssued
            SELECT
               CREATED_LOC
              ,SUM(VOUCHER_AMOUNT)
              ,COUNT(VOUCHER_ID)
            FROM dbo.VOUCHER
            WHERE
               DATEADD(DAY, DATEDIFF(DAY, 0, CREATE_DATE), 0) = @AccountingDate
               AND IS_VALID = 1
               AND VOUCHER_TYPE < 2
            GROUP BY CREATED_LOC

   INSERT   INTO @VoucherLiability
            SELECT
               CREATED_LOC
              ,SUM(VOUCHER_AMOUNT)
              ,COUNT(VOUCHER_ID)
            FROM dbo.VOUCHER
            WHERE
               IS_VALID = 1
               AND VOUCHER_TYPE < 2
               AND REDEEMED_STATE = 0
               AND CREATE_DATE > @VoucherTransferDate
            GROUP BY CREATED_LOC

   INSERT   INTO @VouchersRedeemed
            SELECT
               CREATED_LOC
              ,SUM(VOUCHER_AMOUNT)
              ,COUNT(VOUCHER_ID)
            FROM dbo.VOUCHER
            WHERE
               IS_VALID = 1
               AND VOUCHER_TYPE < 2
               AND REDEEMED_STATE = 1
               AND UPPER(REDEEMED_LOC) <> 'LMS'
               AND DATEADD(DAY, DATEDIFF(DAY, 0, REDEEMED_DATE), 0) = @AccountingDate
            GROUP BY CREATED_LOC

   INSERT   INTO dbo.MD_DailyAccounting
            SELECT
               m.LocationID AS LocationID
              ,m.RetailerNumber AS RetailerNumber
              ,m.DGMachineNumber AS DGMachineNumber
              ,ISNULL(SUM(ms.AmountPlayed), 0) AS AmountPlayed
              ,ISNULL(SUM(ms.AmountWon), 0) AS AmountWon
              ,ISNULL(vi.VoucherAmount, 0) AS VouchersIssued
              ,ISNULL(vi.VoucherCount, 0) AS VouchersIssuedCount
              ,ISNULL(vl.VoucherAmount, 0) AS VoucherLiabilities
              ,ISNULL(vl.VoucherCount, 0) AS VoucherLiabilitiesCount
              ,ISNULL(vr.VoucherAmount, 0) AS VouchersRedeemedAmount
              ,ISNULL(vr.VoucherCount, 0) AS VouchersRedeemedCount
              ,ISNULL(SUM(ev.VoucherAmount), 0) AS ExpiredVoucherAmount
              ,ISNULL(COUNT(ev.VoucherID), 0) AS ExpiredVoucherCount
              ,ISNULL(CAST(ROUND((SUM(ms.AmountPlayed) * @SalesCommissions), 2) AS MONEY), 0) AS SalesCommissions
              ,ISNULL(CAST(ROUND((SUM(ms.AmountWon) * @CashingCommissions), 2) AS MONEY), 0) AS CashingCommissions
              ,ISNULL(CAST(ROUND((SUM(ms.AmountPlayed) * @Bonus), 2) AS MONEY), 0) Bonus
              ,ISNULL(CAST(ROUND((SUM(ms.AmountPlayed - ms.AmountWon) * @ITLM), 2) AS MONEY), 0) ITLMLeaseFee
              ,(SUM(ISNULL(ms.AmountPlayed, 0) - ISNULL(ms.AmountWon, 0)) -
               (ISNULL(CAST(ROUND((SUM(ms.AmountPlayed) * @SalesCommissions), 2) AS MONEY), 0) +
                ISNULL(CAST(ROUND((SUM(ms.AmountWon) * @CashingCommissions), 2) AS MONEY), 0) +
                ISNULL(CAST(ROUND((SUM(ms.AmountPlayed) * @Bonus), 2) AS MONEY), 0))) + 
                ISNULL(CAST(ROUND((SUM(ms.AmountPlayed - ms.AmountWon) * @ITLM), 2) AS MONEY), 0) + 
                SUM(ISNULL(vi.VoucherAmount, 0) - ISNULL(vr.VoucherAmount, 0)) AS MLGCAShare
              ,@AccountingDate AS AccountingDate
              ,GETDATE()
              ,@Transferred
              ,NULL
            FROM
               @Machines m
               LEFT OUTER JOIN @MachineStats ms ON m.DGMachineNumber = ms.DGMachineNumber
               LEFT OUTER JOIN @ExpiredVouchers ev ON m.DGMachineNumber = ev.DGMachineNumber
               LEFT OUTER JOIN @VouchersIssued vi ON m.DGMachineNumber = vi.DGMachineNumber
               LEFT OUTER JOIN @VoucherLiability vl ON m.DGMachineNumber = vl.DGMachineNumber
               LEFT OUTER JOIN @VouchersRedeemed vr ON m.DGMachineNumber = vr.DGMachineNumber
            GROUP BY
               m.LocationID
              ,m.RetailerNumber
              ,m.DGMachineNumber
              ,vi.VoucherAmount
              ,vi.VoucherCount
              ,vl.VoucherAmount
              ,vl.VoucherCount
              ,vr.VoucherAmount
              ,vr.VoucherCount
END TRY

BEGIN CATCH
   SELECT
      @ErrorNumber = ERROR_NUMBER()
     ,@ErrorMessage = ERROR_MESSAGE()
   
   INSERT   INTO CASINO_EVENT_LOG
            (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
   VALUES
            ('SP', @StoredProc, @ErrorMessage, @ErrorNumber, '00000')
END CATCH

/*
--------------------------------------------------------------------------------
 Set UCV_Transferred flag to true for all expired vouchers or termindated sites.
--------------------------------------------------------------------------------
*/
BEGIN TRY

   IF @SiteStatus = 3 
      BEGIN
         UPDATE
            dbo.VOUCHER
         SET
            UCV_TRANSFERRED = 1
           ,UCV_TRANSFER_DATE = GETDATE()
         WHERE
            IS_VALID = 1
            AND VOUCHER_TYPE < 2
            AND REDEEMED_STATE = 0
      END
   ELSE 
      BEGIN
         UPDATE
            dbo.VOUCHER
         SET
            UCV_TRANSFERRED = 1
           ,UCV_TRANSFER_DATE = GETDATE()
         WHERE
            VOUCHER_ID IN (SELECT VoucherID FROM @ExpiredVouchers) 
      END
END TRY

BEGIN CATCH
   SELECT
      @ErrorNumber = ERROR_NUMBER()
     ,@ErrorMessage = ERROR_MESSAGE()
      
   INSERT   INTO CASINO_EVENT_LOG
            (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
   VALUES
            ('SP', @StoredProc, @ErrorMessage, @ErrorNumber, '00000')
END CATCH

/*
--------------------------------------------------------------------------------
   Insert row into the JobStatus table.
--------------------------------------------------------------------------------
*/
IF @ErrorNumber > 0 
   BEGIN
      SET @Success = 0
   END

EXEC [dbo].[InsertJobStatus]
   @LocationID = @LocationID
   ,@JobName = @StoredProc
   ,@Success = @Success
   ,@DateDataCollectedFor = @AccountingDate
GO
