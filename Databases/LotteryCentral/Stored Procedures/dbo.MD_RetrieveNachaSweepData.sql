SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: MD_RetrieveNachaSweepData user stored procedure.

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
CREATE PROCEDURE [dbo].[MD_RetrieveNachaSweepData] 
	@Date DATETIME


AS

DECLARE @FormattedDate VARCHAR(6)
DECLARE @FormattedTime VARCHAR(4)
DECLARE @EpochDays INT
DECLARE @ErrorDescription VARCHAR(1024)
DECLARE @ErrorID INT
DECLARE @EventTypeID INT
DECLARE @LotteryBankAccountNumber NVARCHAR(4000)
DECLARE @LotteryBankRoutingNumber NVARCHAR(4000)
DECLARE @LotteryIRSFederalTaxID NVARCHAR(4000)
DECLARE @EntryRowCount INT
DECLARE @FDOW INT
DECLARE @PeriodStartDate DATETIME
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @FillerRowsToCreate INT
DECLARE @BlockCount INT
DECLARE @TrailerRowCount INT

/*
--------------------------------------------------------------------------------
   Declare Variables
--------------------------------------------------------------------------------
*/
DECLARE @Adjustments TABLE (RetailerNumber VARCHAR(8)
                           ,Amount MONEY)

DECLARE @SweepAmount TABLE (RetailerNumber VARCHAR(8)
                           ,SweepAmount MONEY)

DECLARE @FileHeader TABLE (RecordTypeCode CHAR(1)
                          ,PriorityCode VARCHAR(2)
                          ,ImmediateDestination VARCHAR(10)
                          ,ImmediateOrigin VARCHAR(10)
                          ,FileCreationDate VARCHAR(6)
                          ,FileCreationTime VARCHAR(4)
                          ,FileIDModifier CHAR(1)
                          ,RecordeSize VARCHAR(3)
                          ,BlockingFactor VARCHAR(2)
                          ,FormatCode CHAR(1)                        
                          ,ImmediateDestinationName VARCHAR(23)
                          ,ImmediateOriginName VARCHAR(23)
                          ,ReferenceCode VARCHAR(8))

DECLARE @BatchHeader TABLE (RecordTypeCode CHAR(1)
                           ,ServiceClassCode VARCHAR(3)
                           ,CompanyName VARCHAR(16)
                           ,CompanyDiscretionaryData VARCHAR(20)
                           ,CompanyIdentification VARCHAR(10)
                           ,StandardEntryClassCode VARCHAR(3)
                           ,CompanyEntryDesription VARCHAR(10)
                           ,CompanyDescriptiveDate VARCHAR(6)
                           ,EffectiveEntryDate VARCHAR(6)
                           ,SettlementDate VARCHAR(3)                        
                           ,OriginatorStatusCode CHAR(1)
                           ,OriginatingDFIIdentification VARCHAR(8)
                           ,BatchNumber VARCHAR(7))
                            
DECLARE @CCDEntryDetail TABLE (RecordTypeCode CHAR(1)
                              ,TransactionCode VARCHAR(2)
                              ,ReceivingDFIIdentification VARCHAR(8)
                              ,CheckDigit CHAR(1)
                              ,DFIAccountNumber VARCHAR(17)
                              ,Amount VARCHAR(10)
                              ,IndividualIdentificationNumber VARCHAR(15)
                              ,IndividualName VARCHAR(22)
                              ,DiscretionaryData VARCHAR(2)
                              ,AddendaRecordIndicator CHAR(1)
                              ,TraceNumber VARCHAR(15))

DECLARE @BatchControlRecord TABLE (RecordTypeCode CHAR(1)
                                  ,ServiceClassCode VARCHAR(3)
                                  ,EntryAddendaCount VARCHAR(6)
                                  ,EntryHash VARCHAR(10)
                                  ,TotalDebitEntryDollarAmount VARCHAR(12)
                                  ,TotalCreditEntryDollarAmount VARCHAR(12)
                                  ,CompanyIdentification VARCHAR(10)
                                  ,MessageAuthenticationCode VARCHAR(19)
                                  ,Reserved VARCHAR(6)
                                  ,OriginatingDFIIdentification VARCHAR(8)
                                  ,BatchNumber VARCHAR(7))

DECLARE @FileTrailer TABLE(Filler VARCHAR(94))

DECLARE @FileControlRecord TABLE (RecordTypeCode CHAR(1)
                                  ,BatchCount VARCHAR(6)
                                  ,BlockCount VARCHAR(6)
                                  ,EntryAddendaCount VARCHAR(8)
                                  ,EntryHash VARCHAR(10)
                                  ,TotalDebitEntryDollar VARCHAR(12)
                                  ,TotalCreditEntryDollarAmountInFile VARCHAR(12)
                                  ,Reserved VARCHAR(39))

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/

SET @FormattedDate = RIGHT(CONVERT(VARCHAR(10), @Date, 112) ,6)
SET @FormattedTime = REPLACE(CONVERT(VARCHAR(5), @Date, 108), ':', '')
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())

SELECT @EventTypeID = EventTypeId
FROM dbo.EventType
WHERE EventName = 'MDLotteryAccounting'

SELECT @LotteryBankAccountNumber = dbo.unf_DecryptValue(ConfigValue)
FROM dbo.AccountingConfig
WHERE ConfigKey = 'LotteryBankAccountNumber'

SELECT @LotteryBankRoutingNumber = dbo.unf_DecryptValue(ConfigValue)
FROM dbo.AccountingConfig
WHERE ConfigKey = 'LotteryBankRoutingNumber'

SELECT @LotteryIRSFederalTaxID = dbo.unf_DecryptValue(ConfigValue)
FROM dbo.AccountingConfig
WHERE ConfigKey = 'LotteryIRSFederalTaxID'

SELECT @FDOW = ConfigValue
FROM AccountingConfig
WHERE ConfigKey = 'FirstDayOfWeek'

SET DATEFIRST @FDOW

SET @PeriodStartDate = DATEADD(DAY, 1 - DATEPART(WEEKDAY, @Date), @Date)
SET @StartDate = DATEADD(dd, DATEDIFF(dd, 0, @PeriodStartDate), 0)
SET @EndDate = DATEADD(dd, 6, @StartDate)

/*
--------------------------------------------------------------------------------
   Populate Variable Tables
--------------------------------------------------------------------------------
*/
INSERT   INTO @Adjustments
         SELECT
            s.RetailerNumber
           ,ISNULL(SUM(aa.Amount), 0)
         FROM
            dbo.[Site] s
            JOIN dbo.SiteStatus ss ON s.SiteId = ss.SiteId
            LEFT OUTER JOIN dbo.AccountingAdjustments aa ON s.SiteId = aa.SiteId
         WHERE
            s.SiteApplicationComplete = 1
            AND aa.AdjustmentTypeId <> 2
            AND aa.AdjustmentDate BETWEEN @StartDate AND @EndDate
            AND aa.IsActive = 1
            AND aa.Transferred = 1
         GROUP BY
            s.RetailerNumber
         ORDER BY
            s.RetailerNumber

INSERT   INTO @SweepAmount
         SELECT
            s.RetailerNumber
           ,ISNULL(SUM(md.MLGCAShare), 0) + ISNULL(a.Amount, 0)
         FROM
            dbo.[Site] s
            JOIN dbo.SiteStatus ss ON s.SiteId = ss.SiteId
            LEFT OUTER JOIN dbo.MD_DailyAccounting md ON s.RetailerNumber = md.RetailerNumber
            LEFT OUTER JOIN @Adjustments a ON md.RetailerNumber = a.RetailerNumber
         WHERE
            s.SiteApplicationComplete = 1
            AND md.Processed = 1
            AND DATEADD(DAY, 0, DATEDIFF(d, 0, md.DateProcessed)) BETWEEN DATEADD(DAY, 1, @StartDate)
                                                                  AND     DATEADD(DAY, 1, @EndDate)
            AND s.RetailerNumber NOT IN (SELECT
                                          s.RetailerNumber
                                         FROM
                                          dbo.[Site] s
                                          LEFT OUTER JOIN dbo.AccountingAdjustments aa ON s.SiteId = aa.SiteId
                                         WHERE
                                          s.SiteApplicationComplete = 1
                                          AND aa.AdjustmentTypeId = 2
                                          AND aa.AdjustmentDate BETWEEN @StartDate AND @EndDate
                                          AND aa.IsActive = 1
                                         UNION
                                         SELECT
                                          s.RetailerNumber
                                         FROM
                                          dbo.[Site] s
                                          LEFT OUTER JOIN dbo.SiteStatus ss ON s.SiteId = ss.SiteId
                                         WHERE
                                          s.SiteApplicationComplete = 1
                                          AND ss.StatusCode = 3
                                          AND ss.TerminationDate BETWEEN @StartDate
                                                                 AND     @EndDate)
         GROUP BY
            s.RetailerNumber
           ,a.Amount

/*
--------------------------------------------------------------------------------
   Populate File Header Table.
--------------------------------------------------------------------------------
*/
BEGIN TRY
   INSERT   INTO @FileHeader
            SELECT
               '1'
              ,'01'
              ,RIGHT(SPACE(10) + @LotteryBankRoutingNumber , 10)
              ,LEFT(@LotteryIRSFederalTaxID + SPACE(10), 10)
              ,@FormattedDate
              ,@FormattedTime
              ,'A'
              ,'094'
              ,'10'
              ,'1'
              ,LEFT('BANK OF AMERICA (MD)' + SPACE(23), 23)
              ,LEFT('STATE TREASURER/LOTTERY' + SPACE(23), 23)
              ,SPACE(8)
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT   INTO EventLog
            (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
            (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)), @ErrorDescription, 'MD_RetrieveNachaSweepData_FileHeader', -1)
END CATCH

/*
--------------------------------------------------------------------------------
   Populate Batch Header Table.
--------------------------------------------------------------------------------
*/
BEGIN TRY  
   INSERT   INTO @BatchHeader
            SELECT
               '5'
              ,'200'
              ,LEFT('MD LOTTERY AGCY' + SPACE(16), 16)
              ,LEFT('WEEKLY DRAW DOWNS' + SPACE(20), 20)
              ,LEFT(@LotteryIRSFederalTaxID + SPACE(10), 10)
              ,LEFT('CCD' + SPACE(3), 3)
              ,LEFT(' EFT-DRAW' + SPACE(10), 10)
              ,SPACE(6)
              ,@FormattedDate
              ,SPACE(3)
              ,'1'
              ,'05200163'
              ,'0000001'
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT   INTO EventLog
            (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
            (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)), @ErrorDescription, 'MD_RetrieveNachaSweepData_BatchHeader', -1)
END CATCH

/*
--------------------------------------------------------------------------------
   Populate CCD Entry Detail Table.
--------------------------------------------------------------------------------
*/
BEGIN TRY  
   INSERT   INTO @CCDEntryDetail
            SELECT
               '6'
              ,CASE 
                 WHEN sa.SweepAmount > -1 AND sb.BankAccountType = 'C' THEN 27
                 WHEN sa.SweepAmount > -1 AND sb.BankAccountType = 'S' THEN 37
                 WHEN sa.SweepAmount <  0 AND sb.BankAccountType = 'C' THEN 22
                 WHEN sa.SweepAmount <  0 AND sb.BankAccountType = 'S' THEN 32
               END
              ,LEFT(sb.BankRoutingNumber + SPACE(8), 8)
              ,SUBSTRING(sb.BankRoutingNumber, 9, 1)
              ,LEFT(dbo.unf_DecryptValue(sb.BankAccountNumber) + SPACE(17), 17)
              ,RIGHT('0000000000' + ISNULL(REPLACE(REPLACE(CAST(sa.SweepAmount AS VARCHAR(10)), '.', ''), '-', ''), '0'), 10)
              ,LEFT(ISNULL(s.RetailerNumber, '') + SPACE(15), 15)
              ,LEFT(s.FullName + SPACE(22), 22)
              ,SPACE(2)
              ,'0'
              ,'05200163' + RIGHT('0000000' + CONVERT(VARCHAR(7), ROW_NUMBER() OVER (ORDER BY s.RetailerNumber)), 7)
            FROM
               [Site] s
               JOIN SiteBanking sb ON s.SiteID = sb.SiteID
               LEFT OUTER JOIN @SweepAmount sa ON s.RetailerNumber = sa.RetailerNumber
            WHERE
               s.SiteApplicationComplete = 1
               AND sa.SweepAmount <> 0
            GROUP BY
               sb.BankAccountType
              ,sb.BankRoutingNumber
              ,sb.BankAccountNumber
              ,sa.SweepAmount
              ,s.RetailerNumber
              ,s.FullName

END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT   INTO EventLog
            (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
            (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)), @ErrorDescription, 'MD_RetrieveNachaSweepData_CCDEntryDetail', -1)
END CATCH

/*
--------------------------------------------------------------------------------
   Populate Batch Control Record.
--------------------------------------------------------------------------------
*/
BEGIN TRY  
   
   SELECT @EntryRowCount = COUNT(*) FROM @CCDEntryDetail

   INSERT   INTO @BatchControlRecord
            SELECT
               '8'
              ,'200'
              ,RIGHT('000000' + CONVERT(VARCHAR(6), @EntryRowCount), 6)
              ,RIGHT('0000000000' + CAST((SELECT SUM (CAST( ReceivingDFIIdentification AS INT)) FROM @CCDEntryDetail) AS VARCHAR(10)), 10)
              ,RIGHT('000000000000' +  REPLACE(REPLACE(CAST((SELECT ISNULL(SUM(SweepAmount), 0) FROM @SweepAmount WHERE SweepAmount > 0) AS VARCHAR(12)), '.', ''), '-', ''), 12)
              ,RIGHT('000000000000' +  REPLACE(REPLACE(CAST((SELECT ISNULL(SUM(SweepAmount), 0) FROM @SweepAmount WHERE SweepAmount < 0) AS VARCHAR(12)), '.', ''), '-', ''), 12)
              --,CASE WHEN SweepAmount > -1 THEN RIGHT('000000000000' + ISNULL(REPLACE(REPLACE(CAST(SweepAmount AS VARCHAR(12)), '.', ''), '-', ''), '0'), 12)
              --      ELSE '000000000000'
              -- END
              --,CASE WHEN SweepAmount < 0 THEN RIGHT('000000000000' + ISNULL(REPLACE(REPLACE(CAST(SweepAmount AS VARCHAR(12)), '.', ''), '-', ''), '0'), 12)
              --      ELSE '000000000000'
              -- END
              ,LEFT(@LotteryIRSFederalTaxID + SPACE(10), 10)
              ,SPACE(19)
              ,SPACE(6)
              ,'05200163'
              ,'0000001'
            
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT   INTO EventLog
            (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
            (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)), @ErrorDescription, 'MD_RetrieveNachaSweepData_BatchControlRecord', -1)
END CATCH

/*
--------------------------------------------------------------------------------
   Generate File Trailers.
--------------------------------------------------------------------------------
*/
BEGIN TRY  
     
   SELECT @FillerRowsToCreate = 10 - ((@EntryRowCount + 4)%10)

   WHILE @FillerRowsToCreate > 0
   BEGIN
   	INSERT INTO @FileTrailer
   	         (Filler)
   	VALUES
   	         (REPLICATE('9', 94))

      SET @FillerRowsToCreate = @FillerRowsToCreate - 1
   END
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT   INTO EventLog
            (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
            (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)), @ErrorDescription, 'MD_RetrieveNachaSweepData_FileTrailers', -1)
END CATCH

/*
--------------------------------------------------------------------------------
   Populate File Control Record.
--------------------------------------------------------------------------------
*/
BEGIN TRY
     
     SELECT @TrailerRowCount = COUNT(*) FROM @FileTrailer
     SET @BlockCount = ((@TrailerRowCount + @EntryRowCount) + 4) / 10
     
     INSERT INTO @FileControlRecord
            SELECT
               '9'
              ,'000001'
              ,RIGHT('000000' + CONVERT(VARCHAR(6), @BlockCount), 6)
              ,RIGHT('00000000' + CONVERT(VARCHAR(8), @EntryRowCount), 8)
              ,RIGHT('0000000000' + CAST((SELECT SUM (CAST(ReceivingDFIIdentification AS INT)) FROM @CCDEntryDetail) AS VARCHAR(10)), 10)
              ,RIGHT('000000000000' +  REPLACE(REPLACE(CAST((SELECT ISNULL(SUM(SweepAmount), 0) FROM @SweepAmount WHERE SweepAmount > 0) AS VARCHAR(12)), '.', ''), '-', ''), 12)
              ,RIGHT('000000000000' +  REPLACE(REPLACE(CAST((SELECT ISNULL(SUM(SweepAmount), 0) FROM @SweepAmount WHERE SweepAmount < 0) AS VARCHAR(12)), '.', ''), '-', ''), 12)
              ,SPACE(39)

END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT   INTO EventLog
            (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
            (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)), @ErrorDescription, 'MD_RetrieveNachaSweepData_FileControlRecord', -1)
END CATCH

SELECT * FROM @FileHeader
SELECT * FROM @BatchHeader
SELECT * FROM @CCDEntryDetail
SELECT * FROM @BatchControlRecord
SELECT * FROM @FileControlRecord
SELECT * FROM @FileTrailer
GO
