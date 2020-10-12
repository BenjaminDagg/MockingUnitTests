SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*
--------------------------------------------------------------------------------
Procedure: QCL_InsertDailyAccountingData

Created: 08-26-2014 by Cj Price

Purpose: Collects all of the daily pay per play accounting.

Arguments: @Date = DATEADD(DAY, -1, GETDATE()) Date data is being collected for.

Change Log:

Changed By    Date           Database Version 3.2.7
   Change Description
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[QCL_InsertDailyAccountingData] @Date DATETIME

AS

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @AccountingDate DATETIME
DECLARE @CentralID INT
DECLARE @DateTransferred DATETIME
DECLARE @ErrorNumber INT
DECLARE @ErrorMessage AS VARCHAR(4000)
DECLARE @JulianDate INT
DECLARE @LocationID INT
DECLARE @StoredProc VARCHAR(64)
DECLARE @Success BIT
DECLARE @Transferred BIT

/*
--------------------------------------------------------------------------------
   Declare Variable Tables
--------------------------------------------------------------------------------
*/
DECLARE @AccountingData TABLE
   (LocationID INT
   ,MachineNumber VARCHAR(8)
   ,CasinoMachineNumber VARCHAR(8)
   ,GameDescription VARCHAR(64)
   ,GameTitleId INT
   ,FormNumber VARCHAR(20)
   ,DealNumber INT
   ,TabTypeId INT
   ,GameCode VARCHAR(3)
   ,GameTypeCode VARCHAR(2) 
   ,HoldPercent DECIMAL(7,4)
   ,AmountPlayed MONEY  
   ,AmountWon MONEY
   ,AmountJackpot MONEY
   ,AmountProg MONEY
   ,PlayCount INT  
   ,WinCount INT
   ,JackpotCount INT 
   ,PurchaseAmount VARCHAR(20)
   ,CommissionsAmount MONEY
   ,AccountingDate DATETIME
   ,Transferred BIT
   ,DateTransferred DATETIME)

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SET @AccountingDate = DATEADD(DAY, DATEDIFF(DAY, 0, @Date), 0)
SET @CentralID = NULL
SET @DateTransferred = NULL
SET @Success = 1
SET @StoredProc = 'QCL_InsertDailyAccountingData'
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
DELETE FROM dbo.QCL_DailyAccounting
WHERE AccountingDate = @AccountingDate AND Transferred = 0

/*
--------------------------------------------------------------------------------
   Select machine stats data and insert into QCL_DailyAccounting.
--------------------------------------------------------------------------------
*/
DECLARE @PurchaseAmountRangeTable TABLE (GameTypeCode VARCHAR(2), PurchaseAmountRange VARCHAR(32), DenomAmount VARCHAR(10),LinesBet INT)


         
BEGIN TRY

INSERT   INTO @PurchaseAmountRangeTable
     SELECT
     dgt.GAME_TYPE_CODE AS GameCodeType
     ,CASE WHEN (MIN(lgt.LINES_BET) * MIN(cgt.COINS_BET) * MIN(dgt.DENOM_VALUE)) = (MAX(lgt.LINES_BET) * MAX(cgt.COINS_BET) * MAX(dgt.DENOM_VALUE)) 
       THEN '$' + CAST((MIN(lgt.LINES_BET) * MIN(cgt.COINS_BET) * MIN(dgt.DENOM_VALUE)) AS VARCHAR(32)) 
       ELSE '$' + CAST((MIN(lgt.LINES_BET) * MIN(cgt.COINS_BET) * MIN(dgt.DENOM_VALUE)) AS VARCHAR(32)) + ' - ' + '$' + CAST(MAX(lgt.LINES_BET) * MAX(cgt.COINS_BET) * MAX(dgt.DENOM_VALUE) AS VARCHAR(32)) END AS PurchaseAmountRange
 
      ,dgt.DENOM_VALUE AS DenomValue
      ,lgt.LINES_BET AS LinesBet
     FROM dbo.DENOM_TO_GAME_TYPE dgt
     JOIN dbo.COINS_BET_TO_GAME_TYPE cgt ON cgt.GAME_TYPE_CODE = dgt.GAME_TYPE_CODE
     JOIN dbo.LINES_BET_TO_GAME_TYPE lgt ON lgt.GAME_TYPE_CODE = dgt.GAME_TYPE_CODE

     GROUP BY 
       dgt.GAME_TYPE_CODE,dgt.DENOM_VALUE,lgt.LINES_BET
     ORDER BY dgt.GAME_TYPE_CODE
     
     
   INSERT   INTO @AccountingData
SELECT 
  ms.LOCATION_ID AS LocationId
  ,ms.MACH_NO AS MachineNumber
  ,ms.CASINO_MACH_NO AS CasinoMachineNumber
  ,gs.GAME_DESC AS GameDescription
  ,gs.GAME_TITLE_ID AS GameTitleId
  ,cf.FORM_NUMB AS FormNumber
  ,ms.DEAL_NO AS DealNumber
  ,cf.TAB_TYPE_ID AS TabTypeId
  ,ms.GAME_CODE As GameCode
  ,gs.GAME_TYPE_CODE AS GameTypeCode
  ,cf.HOLD_PERCENT AS HoldPercent
  ,ms.AMOUNT_PLAYED AS AmountPlayed
  ,ms.AMOUNT_WON AS AmountWon
  ,ms.AMOUNT_JACKPOT AS AmountJackpot      
  ,ms.AMOUNT_PROG AS AmountProg
  ,ms.PLAY_COUNT AS PlayCount
  ,ms.WIN_COUNT AS WinCount
  ,ms.JACKPOT_COUNT AS JackpotCount
  ,purch.PurchaseAmountRange AS PurchaseAmount 
  ,0 AS CommissionsAmount     
  ,ms.ACCT_DATE AS AccountingDate
  ,@Transferred
  ,@DateTransferred
      
  FROM dbo.MACHINE_STATS ms
  JOIN dbo.GAME_SETUP gs ON gs.GAME_CODE = ms.GAME_CODE 
  JOIN dbo.DEAL_SETUP ds ON ds.DEAL_NO = ms.DEAL_NO
  JOIN dbo.CASINO_FORMS cf ON cf.GAME_TYPE_CODE = gs.GAME_TYPE_CODE AND cf.FORM_NUMB = ds.FORM_NUMB
  JOIN @PurchaseAmountRangeTable purch ON purch.GameTypeCode = gs.GAME_TYPE_CODE
  JOIN dbo.MACH_SETUP machsetup ON machsetup.MACH_NO = ms.MACH_NO
  WHERE ms.DEAL_NO <> 0
AND machsetup.REMOVED_FLAG = 0
AND machsetup.MACH_NO <> 0

   AND NOT EXISTS (SELECT * 
   FROM dbo.QCL_DailyAccounting
   WHERE MachineNumber = ms.MACH_NO AND AccountingDate = ms.ACCT_DATE)
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

   INSERT INTO dbo.QCL_DailyAccounting
      SELECT
         LocationID
         ,MachineNumber
         ,CasinoMachineNumber
         ,GameDescription
         ,GameTitleId
         ,FormNumber
         ,DealNumber
         ,TabTypeId
         ,GameCode
         ,GameTypeCode
         ,HoldPercent
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
         ,Transferred
         ,DateTransferred
      FROM @AccountingData
      
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
