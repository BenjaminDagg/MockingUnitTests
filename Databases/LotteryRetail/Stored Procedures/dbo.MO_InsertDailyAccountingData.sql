SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: MO_InsertDailyAccountingData

Created: 05-24-2013 by Aldo Zamora

Purpose: Collects all of the daily AR data needed to generate central AR file.

Arguments: @Date = DATEADD(DAY, -1, GETDATE()) Date data is being collected for.

Change Log:

Changed By    Date           Database Version
   Change Description
--------------------------------------------------------------------------------
Aldo Zamora   05-24-2013     
   Initial coding.

Aldo Zamora   11-28-2013
   Updated SQL selects to use the MACH_SETUP table as the primary table
   in place of MACHINE_STATS to prevent missing data due to no play.

Aldo Zamora   12-20-2014
   Added filter to exclude vouchers where IS_VALID = 0.
   
Louis Epstein   03-31-2014
   Modified voucher expiration to use new ufnIsVoucherExpired function
---------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[MO_InsertDailyAccountingData] @Date DATETIME

AS

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @AccountingDate DATETIME
DECLARE @CasinoGameID INT
DECLARE @CentralID INT
DECLARE @DateTransferred DATETIME
DECLARE @DocumentCode INT
DECLARE @DocumentNumber INT
DECLARE @ErrorNumber INT
DECLARE @ErrorMessage AS VARCHAR(4000)
DECLARE @JulianDate INT
DECLARE @LocationID INT
DECLARE @SequenceNumber INT
DECLARE @StoredProc VARCHAR(64)
DECLARE @Success BIT
DECLARE @TransactionAmount INT
DECLARE @Transferred BIT

/*
--------------------------------------------------------------------------------
   Declare Variable Tables
--------------------------------------------------------------------------------
*/
DECLARE @PullTabSales TABLE
   (LocationID INT
   ,MachNo CHAR(5)
   ,CasinoMachNo VARCHAR(8)
   ,AccountingDate VARCHAR(8)
   ,CasinoGameID INT 
   ,GameDescription VARCHAR(64)
   ,AmountPlayed INT  
   ,PlayCount INT  
   ,AmountWon INT  
   ,WinCount INT 
   ,CommissionsAmount INT
   ,Transferred BIT
   ,DateTransferred DATETIME)

DECLARE @SequenceTable TABLE
   (NewSequenceNumber INT
    ,DailyARDataID INT)

DECLARE @VoucherTable TABLE
   (VoucherID INT
   ,LocationID INT
   ,MachineNumber CHAR(5)
   ,CasinoGameID INT
   ,ExpiredVoucherAmount MONEY)

DECLARE @PulltabVoucherSummary TABLE
    (LocationID INT
    ,MachineNumber CHAR(5)
    ,CasinoGameID INT
    ,ExpiredVoucherAmount MONEY)

DECLARE @ARData TABLE
   (LocationID INT
    ,DocumentNumber INT
    ,CasinoGameID INT
    ,DocumentCode INT
    ,TransactionAmount INT)

DECLARE @MachineStats TABLE
   (LocationID INT
   ,MachineNumber CHAR(5)
   ,CasinoGameID INT
   ,AmountPlayed MONEY
   ,AmountWon MONEY)

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SET @AccountingDate = DATEADD(DAY, DATEDIFF(DAY, 0, @Date), 0)
SET @CentralID = NULL
SET @DateTransferred = NULL
SET @SequenceNumber = 1
SET @Success = 1
SET @StoredProc = 'MO_InsertDailyAccountingData'
SET @Transferred = 0

SET @JulianDate = RIGHT(CAST(YEAR(@AccountingDate) AS CHAR(4)),2) +
                  RIGHT('000' + CAST(DATEPART(dy, @AccountingDate) AS VARCHAR(3)),3)

SELECT @LocationID = LOCATION_ID
FROM dbo.CASINO
WHERE SETASDEFAULT = 1

/*
--------------------------------------------------------------------------------
   Delete non transferred data to avoid duplicate data for the same date.
--------------------------------------------------------------------------------
*/
DELETE FROM dbo.MO_DailyPulltabSales
WHERE AccountingDate = @AccountingDate AND Transferred = 0

DELETE FROM dbo.MO_DailyARData
WHERE DocumentNumber = @JulianDate AND Transferred = 0

/*
--------------------------------------------------------------------------------
   Select expired voucher data.
--------------------------------------------------------------------------------
*/
--INSERT   INTO @VoucherTable
  -- SELECT
  --    v.VOUCHER_ID
  --   ,v.LOCATION_ID
  --   ,ms.MACH_NO
  --   ,gs.CASINO_GAME_ID
  --   ,v.VOUCHER_AMOUNT
  -- FROM
  --    dbo.VOUCHER v
  --    JOIN dbo.MACH_SETUP ms ON v.CREATED_LOC = ms.MACH_NO
  --    JOIN dbo.GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
  -- WHERE
  --    v.IS_VALID = 1 AND
  --    v.UCV_TRANSFERRED = 0 AND
  --    v.VOUCHER_TYPE < 2 AND
  --    v.REDEEMED_STATE = 0 AND
  --dbo.ufnIsVoucherExpired(v.VOUCHER_ID) = 1
  -- GROUP BY
  --    v.VOUCHER_ID
  --   ,v.LOCATION_ID
  --   ,ms.MACH_NO
  --   ,gs.CASINO_GAME_ID
  --   ,v.VOUCHER_AMOUNT
  -- ORDER BY
  --    v.VOUCHER_ID

--INSERT INTO @PulltabVoucherSummary
   --SELECT
   --   LocationID
   --   ,MachineNumber
   --   ,CasinoGameID
   --   ,SUM(ExpiredVoucherAmount)
   --FROM @VoucherTable
   --GROUP BY
   --   LocationID
   --   ,MachineNumber
   --   ,CasinoGameID

/*
--------------------------------------------------------------------------------
   Select pulltab sales data and insert into MO_DailyPulltabSales.
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT   INTO @PullTabSales
            SELECT
               msetup.LOCATION_ID AS LocationID
              ,msetup.MACH_NO AS MachineNumber
              ,msetup.CASINO_MACH_NO AS CasinoMachineNumber
              ,CONVERT(VARCHAR(8), @AccountingDate, 112) AS AccountingDate
              ,gsetup.CASINO_GAME_ID AS GameNumber
              ,gsetup.GAME_DESC AS GameDescription
              ,ISNULL(CAST(REPLACE(SUM(mstats.AMOUNT_PLAYED), '.', '') AS INT), 0) AS AmountPlayed
              ,ISNULL(CAST(REPLACE(SUM(mstats.PLAY_COUNT), '.', '') AS INT), 0) AS PlayCount
              ,ISNULL(CAST(REPLACE(SUM(mstats.AMOUNT_WON + mstats.AMOUNT_JACKPOT), '.', '') AS INT), 0) AS AmountWon
              ,ISNULL(CAST(REPLACE(SUM(mstats.WIN_COUNT + mstats.JACKPOT_COUNT), '.', '') AS INT), 0) AS WinCount
              ,CAST(ROUND(((ISNULL(SUM(mstats.AMOUNT_PLAYED - (mstats.AMOUNT_WON + mstats.AMOUNT_JACKPOT)), 0) + ISNULL(pvs.ExpiredVoucherAmount, 0)) * .2) * 100, 0) AS INT) AS CommissionsAmount
              ,@Transferred
              ,@DateTransferred
            FROM
               dbo.MACH_SETUP msetup
               JOIN dbo.GAME_SETUP gsetup ON msetup.GAME_CODE = gsetup.GAME_CODE
               LEFT OUTER JOIN dbo.MACHINE_STATS mstats ON msetup.MACH_NO = mstats.MACH_NO
                                                           AND mstats.ACCT_DATE = @AccountingDate
               LEFT OUTER JOIN @PulltabVoucherSummary pvs ON msetup.MACH_NO = pvs.MachineNumber
            WHERE
               NOT EXISTS (SELECT * 
                           FROM dbo.MO_DailyPulltabSales
                           WHERE MachNo = mstats.MACH_NO AND AccountingDate = mstats.ACCT_DATE)
               AND msetup.REMOVED_FLAG = 0
               AND msetup.MACH_NO <> 0
            GROUP BY
               msetup.LOCATION_ID
              ,msetup.MACH_NO
              ,msetup.CASINO_MACH_NO
              ,mstats.ACCT_DATE
              ,gsetup.CASINO_GAME_ID
              ,gsetup.GAME_DESC
              ,pvs.ExpiredVoucherAmount
            ORDER BY
               gsetup.CASINO_GAME_ID
END TRY

BEGIN CATCH
   SELECT
      @ErrorNumber =  ERROR_NUMBER()
      ,@ErrorMessage = ERROR_MESSAGE()
   
   INSERT INTO CASINO_EVENT_LOG
      (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
   VALUES
      ('SP', @StoredProc, @ErrorMessage, @ErrorNumber, '00000')
END CATCH

/*
--------------------------------------------------------------------------------
   Update non transferred rows with new sequence numbers.
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT INTO @SequenceTable
      SELECT
         ROW_NUMBER() OVER(ORDER BY DailyARDataID) + 4999 AS RowNumber
         ,DailyARDataID
      FROM dbo.MO_DailyARData
      WHERE Transferred = 0 AND DocumentNumber <> @JulianDate

   UPDATE dbo.MO_DailyARData
   SET SequenceNumber = NewSequenceNumber
   FROM
      dbo.MO_DailyARData dard
      JOIN @SequenceTable st ON dard.DailyARDataID = st.DailyARDataID
END TRY

BEGIN CATCH
   SELECT
      @ErrorNumber =  ERROR_NUMBER()
      ,@ErrorMessage = ERROR_MESSAGE()

   INSERT INTO CASINO_EVENT_LOG
      (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
   VALUES
      ('SP', @StoredProc, @ErrorMessage, @ErrorNumber, '00000')
END CATCH

/*
--------------------------------------------------------------------------------
   Select AR data and insert into MO_DailyARData table.
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT   INTO @MachineStats
            SELECT
               cas.LOCATION_ID
              ,ms.MACH_NO
              ,gs.CASINO_GAME_ID
              ,ISNULL(SUM(mstats.AMOUNT_PLAYED), 0)
              ,ISNULL(SUM(mstats.AMOUNT_WON + mstats.AMOUNT_JACKPOT), 0)
            FROM
               dbo.MACH_SETUP ms
               JOIN dbo.CASINO cas ON ms.LOCATION_ID = cas.LOCATION_ID
               JOIN dbo.GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
               LEFT OUTER JOIN dbo.MACHINE_STATS mstats ON ms.MACH_NO = mstats.MACH_NO AND mstats.ACCT_DATE = @AccountingDate
            WHERE
               ms.REMOVED_FLAG = 0
               AND ms.MACH_NO <> 0
            GROUP BY
               cas.LOCATION_ID
              ,ms.MACH_NO
              ,gs.CASINO_GAME_ID
            ORDER BY
               gs.CASINO_GAME_ID
              ,ms.MACH_NO

   INSERT INTO @ARData
      SELECT
         LocationID AS LocationID
         ,@JulianDate AS DocumentNumber
         ,CasinoGameID AS CasinoGameID
         ,6007 AS DocumentCode
         ,CAST(REPLACE(SUM(AmountPlayed), '.', '') AS INT) AS TransactionAmount
      FROM @MachineStats
      GROUP BY
         LocationID
         ,CasinoGameID
      UNION ALL
      SELECT
         LocationID AS LocationID
        ,@JulianDate AS DocumentNumber
        ,CasinoGameID AS CasinoGameID
        ,6008 AS DocumentCode
        ,CAST(REPLACE(SUM(AmountWon), '.', '') AS INT) AS TransactionAmount
      FROM @MachineStats
      GROUP BY
         LocationID
         ,CasinoGameID
      UNION ALL
      SELECT
         mstats.LocationID AS LocationID
        ,@JulianDate AS DocumentNumber
        ,mstats.CasinoGameID AS CasinoGameID
        ,6009 AS DocumentCode
        ,CAST(ROUND((SUM(mstats.AmountPlayed - mstats.AmountWon + ISNULL(pvs.ExpiredVoucherAmount, 0)) *.2) * 100, 0) AS INT) AS TransactionAmount
      FROM
         @MachineStats mstats
         LEFT OUTER JOIN @PulltabVoucherSummary pvs ON mstats.MachineNumber = pvs.MachineNumber
      GROUP BY
         mstats.LocationID
         ,mstats.CasinoGameID
     --UNION ALL
     -- SELECT
     --    LocationID
     --   ,@JulianDate AS DocumentNumber
     --   ,CasinoGameID
     --   ,6010 AS DocumentCode
     --   ,ISNULL(CAST(REPLACE(SUM(ExpiredVoucherAmount), '.', '') AS INT), 0)  AS ExpiredVoucherTotalAmount
     -- FROM @VoucherTable
     -- GROUP BY
     --    LocationID
     --    ,CasinoGameID      
END TRY

BEGIN CATCH
   SELECT
      @ErrorNumber =  ERROR_NUMBER()
      ,@ErrorMessage = ERROR_MESSAGE()

   INSERT INTO CASINO_EVENT_LOG
      (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
   VALUES
      ('SP', @StoredProc, @ErrorMessage, @ErrorNumber, '00000')
END CATCH

/*
--------------------------------------------------------------------------------
   Insert data from variable tables into database.
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT INTO dbo.MO_DailyARData
      SELECT
         ard.LocationID
         ,ROW_NUMBER() OVER (ORDER BY ard.CasinoGameID) AS SequenceNumber
         ,ard.DocumentNumber
         ,ard.CasinoGameID
         ,ard.DocumentCode
         ,ard.TransactionAmount
         ,@Transferred
         ,@DateTransferred
      FROM
         @ARData ard
      WHERE NOT EXISTS
         (SELECT * FROM dbo.MO_DailyARData
           WHERE LocationID = ard.LocationID AND
                 DocumentNumber = ard.DocumentNumber AND
                 CasinoGameID = ard.CasinoGameID AND
                 DocumentCode = ard.DocumentCode AND
                TransactionAmount = ard.TransactionAmount)
      ORDER BY
         ard.CasinoGameID
         ,ard.DocumentCode

   INSERT INTO dbo.MO_DailyPulltabSales
      SELECT
         LocationID
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
         ,Transferred
         ,DateTransferred
      FROM @PulltabSales

   --INSERT INTO dbo.VouchersToARFile
   --   SELECT
   --      LocationID
   --      ,VoucherID
   --      ,@JulianDate
   --   FROM @VoucherTable
      
END TRY

BEGIN CATCH
   SELECT
      @ErrorNumber =  ERROR_NUMBER()
      ,@ErrorMessage = ERROR_MESSAGE()
      
   INSERT INTO CASINO_EVENT_LOG
      (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
   VALUES
      ('SP', @StoredProc, @ErrorMessage, @ErrorNumber, '00000')
END CATCH

/*
--------------------------------------------------------------------------------
   Set UCV_Transferred flag to true for all expired vouchers.
--------------------------------------------------------------------------------
*/
--BEGIN TRY
--   UPDATE dbo.VOUCHER
--      SET
--         UCV_TRANSFERRED = 1
--         ,UCV_TRANSFER_DATE = GETDATE()
--      WHERE VOUCHER_ID IN (SELECT VoucherID FROM @VoucherTable)
--END TRY

--BEGIN CATCH
--   SELECT
--      @ErrorNumber =  ERROR_NUMBER()
--      ,@ErrorMessage = ERROR_MESSAGE()
      
--   INSERT INTO CASINO_EVENT_LOG
--      (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
--   VALUES
--      ('SP', @StoredProc, @ErrorMessage, @ErrorNumber, '00000')
--END CATCH

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
