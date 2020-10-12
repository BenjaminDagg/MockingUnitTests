SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure: MD_RetrieveDunningData user stored procedure.

Created: 04-10-2014 by Aldo Zamora

Purpose: Used by the MD_DunningFile SSIS job.

Arguments: 


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   04-10-2014     
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[MD_RetrieveDunningData] 

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

/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SET @Date = GETDATE()
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())
SELECT @EventTypeID = EventTypeId FROM dbo.EventType WHERE EventName = 'MDLotteryAccounting'

/*
--------------------------------------------------------------------------------
   Collect data from all locations and insert into MO tables.
--------------------------------------------------------------------------------
*/
BEGIN TRY    
   SELECT
      LEFT(s.FullName + SPACE(30), 30) AS FullName
     ,LEFT(ISNULL(s.RetailerNumber, '') + SPACE(8), 8) AS RetailerNumber
     ,LEFT(s.StreetAddress + SPACE(30), 30) AS StreetAddress
     ,LEFT(s.City + SPACE(18), 18) AS City
     ,LEFT(s.[State] + SPACE(2), 2) AS [State]
     ,LEFT(s.ZipCode + SPACE(9), 9) AS ZipCode
     ,LEFT(s.PhoneNumber + SPACE(10), 10) AS PhoneNumber
     ,LEFT(s.CountyCode + SPACE(2), 2) AS CountyCode
     ,SPACE(20) AS EmptyColumn1
     ,LEFT(s.TerritoryNumber + SPACE(4), 4) AS TerritoryNumber
     ,SPACE(30) AS EmptyColumn2
     ,SPACE(50) AS EmptyColumn3
     ,LEFT(CONVERT(CHAR(1), ss.StatusCode) + SPACE(1), 1) AS Active
     ,LEFT(s.StartTimeSunday + SPACE(4), 4) AS StartTimeSunday
     ,LEFT(s.CloseTimeSunday + SPACE(4), 4) AS CloseTimeSunday
     ,LEFT(s.StartTimeMonday + SPACE(4), 4) AS StartTimeMonday
     ,LEFT(s.CloseTimeMonday + SPACE(4), 4) AS CloseTimeMonday
     ,LEFT(s.StartTimeTuesday + SPACE(4), 4) AS StartTimeTuesday
     ,LEFT(s.CloseTimeTuesday + SPACE(4), 4) AS CloseTimeTuesday
     ,LEFT(s.StartTimeWednesday + SPACE(4), 4) AS StartTimeWednesday
     ,LEFT(s.CloseTimeWednesday + SPACE(4), 4) AS CloseTimeWednesday
     ,LEFT(s.StartTimeThursday + SPACE(4), 4) AS StartTimeThursday
     ,LEFT(s.CloseTimeThursday + SPACE(4), 4) AS CloseTimeThursday
     ,LEFT(s.StartTimeFriday + SPACE(4), 4) AS StartTimeFriday
     ,LEFT(s.CloseTimeFriday + SPACE(4), 4) AS CloseTimeFriday
     ,LEFT(s.StartTimeSaturday + SPACE(4), 4) AS StartTimeSaturday
     ,LEFT(s.CloseTimeSaturday + SPACE(4), 4) AS CloseTimeSaturday
     ,SPACE(8) AS EmptyColumn4
     ,SPACE(8) AS EmptyColumn5
     ,SPACE(8) AS EmptyColumn6
     ,SPACE(8) AS EmptyColumn7
     ,SPACE(8) AS EmptyColumn8
     ,SPACE(8) AS EmptyColumn9
     ,SPACE(8) AS EmptyColumn10
     ,SPACE(8) AS EmptyColumn11
     ,SPACE(8) AS EmptyColumn12
     ,SPACE(8) AS EmptyColumn13
     ,SPACE(8) AS EmptyColumn14
     ,LEFT(CONVERT(CHAR(1), sbond.IsBonded) + SPACE(1), 1) AS IsBonded
     ,LEFT('0' + SPACE(11), 11) AS NetSales
     ,CASE WHEN sf.FederalIDNumber IS NULL
        THEN SPACE(9)
        ELSE LEFT(dbo.unf_DecryptValue(sf.FederalIDNumber) + SPACE(9), 9)
      END AS FederalIDNumber
     ,CASE WHEN sf.IRSNumber IS NULL
         THEN SPACE(9)
         ELSE LEFT(dbo.unf_DecryptValue(sf.IRSNumber) + SPACE(9), 9)
      END AS IRSNumber
     ,LEFT(sf.CorporationName + SPACE(30), 30) AS CorporationName
     ,LEFT(sbank.BankAccountName + SPACE(30), 30) AS BankAccountName
     ,LEFT(sbank.FinancialContactName + SPACE(30), 30) AS FinancialContactName
     ,LEFT(sbank.FinancialContactNumber + SPACE(10), 10) AS FinancialContactNumber
     ,LEFT(sbank.BankRoutingNumber + SPACE(9), 9) AS BankRoutingNumber
     ,CASE WHEN sbank.BankAccountNumber IS NULL
        THEN SPACE(17)
        ELSE LEFT(dbo.unf_DecryptValue(sbank.BankAccountNumber) + SPACE(17), 17)
      END AS BankAccountNumber
     ,LEFT(sbank.BankAccountType + SPACE(1), 1) AS BankAccountType
     ,CASE WHEN s.FirstSalesDate IS NULL 
         THEN SPACE(8)
         ELSE LEFT(CONVERT(VARCHAR(8), ISNULL(s.FirstSalesDate, ''), 112) + SPACE(8), 8) 
      END AS FirstSalesDate
     ,LEFT(so.FirstName + ' ' + ISNULL(so.MiddleInitial + ' ', '') + so.LastName + SPACE(35), 35) AS OwnerFullName
     ,CASE WHEN so.SSN IS NULL
         THEN SPACE(9)
         ELSE LEFT(dbo.unf_DecryptValue(so.SSN) + SPACE(9), 9)
      END AS OwnerSSN
     ,LEFT(so.StreetAddress + SPACE(30), 30) AS OwnerStreetAddress
     ,LEFT(so.City + SPACE(18), 18) AS OwnerCity
     ,LEFT(so.[State] + SPACE(2), 2) AS OwnerState
     ,LEFT(so.ZipCode + SPACE(9), 9) AS OwnerZipCode
     ,LEFT(so.PhoneNumber + SPACE(10), 10) AS OwnerPhoneNumber
     ,CASE WHEN so.DateOfBirth IS NULL
         THEN SPACE(6)
         ELSE LEFT(REPLACE(CONVERT(VARCHAR(10), so.DateOfBirth, 1), '/', '') + SPACE(6), 6)
      END AS OwnerDOB
     ,LEFT(so.Gender + SPACE(1), 1) AS OwnerGender
     ,LEFT(so.Race + SPACE(1), 1) AS OwnerRace
     ,SPACE(80) AS EmptyColumn15
     ,SPACE(3) AS EmptyColumn16
     ,SPACE(35) AS EmptyColumn17
     ,SPACE(9) AS EmptyColumn18
     ,SPACE(30) AS EmptyColumn19
     ,SPACE(18) AS EmptyColumn20
     ,SPACE(2) AS EmptyColumn21
     ,SPACE(9) AS EmptyColumn22
     ,SPACE(10) AS EmptyColumn23
     ,SPACE(6) AS EmptyColumn24
     ,SPACE(1) AS EmptyColumn25
     ,SPACE(1) AS EmptyColumn26
     ,SPACE(80) AS EmptyColumn27
     ,SPACE(3) AS EmptyColumn28
     ,SPACE(35) AS EmptyColumn29
     ,SPACE(9) AS EmptyColumn30
     ,SPACE(30) AS EmptyColumn31
     ,SPACE(18) AS EmptyColumn32
     ,SPACE(2) AS EmptyColumn33
     ,SPACE(9) AS EmptyColumn34
     ,SPACE(10) AS EmptyColumn35
     ,SPACE(6) AS EmptyColumn36
     ,SPACE(1) AS EmptyColumn37
     ,SPACE(1) AS EmptyColumn38
     ,SPACE(80) AS EmptyColumn39
     ,SPACE(3) AS EmptyColumn40
     ,SPACE(35) AS EmptyColumn41
     ,SPACE(9) AS EmptyColumn42
     ,SPACE(30) AS EmptyColumn43
     ,SPACE(18) AS EmptyColumn44
     ,SPACE(2) AS EmptyColumn45
     ,SPACE(9) AS EmptyColumn46
     ,SPACE(10) AS EmptyColumn47
     ,SPACE(6) AS EmptyColumn48
     ,SPACE(1) AS EmptyColumn49
     ,SPACE(1) AS EmptyColumn50
     ,SPACE(80) AS EmptyColumn51
     ,SPACE(3) AS EmptyColumn52
     ,SPACE(35) AS EmptyColumn53
     ,SPACE(9) AS EmptyColumn54
     ,SPACE(30) AS EmptyColumn55
     ,SPACE(18) AS EmptyColumn56
     ,SPACE(2) AS EmptyColumn57
     ,SPACE(9) AS EmptyColumn58
     ,SPACE(10) AS EmptyColumn59
     ,SPACE(6) AS EmptyColumn60
     ,SPACE(1) AS EmptyColumn61
     ,SPACE(1) AS EmptyColumn62
     ,SPACE(80) AS EmptyColumn63
     ,SPACE(3) AS EmptyColumn64
     ,SPACE(35) AS EmptyColumn65
     ,SPACE(9) AS EmptyColumn66
     ,SPACE(30) AS EmptyColumn67
     ,SPACE(18) AS EmptyColumn68
     ,SPACE(2) AS EmptyColumn69
     ,SPACE(9) AS EmptyColumn70
     ,SPACE(10) AS EmptyColumn71
     ,SPACE(6) AS EmptyColumn72
     ,SPACE(1) AS EmptyColumn73
     ,SPACE(1) AS EmptyColumn74
     ,SPACE(80) AS EmptyColumn75
     ,SPACE(3) AS EmptyColumn76
     ,SPACE(35) AS EmptyColumn77
     ,SPACE(9) AS EmptyColumn78
     ,SPACE(30) AS EmptyColumn79
     ,SPACE(18) AS EmptyColumn80
     ,SPACE(2) AS EmptyColumn81
     ,SPACE(9) AS EmptyColumn82
     ,SPACE(10) AS EmptyColumn83
     ,SPACE(6) AS EmptyColumn84
     ,SPACE(1) AS EmptyColumn85
     ,SPACE(1) AS EmptyColumn86
     ,SPACE(80) AS EmptyColumn87
     ,SPACE(3) AS EmptyColumn88
     ,SPACE(35) AS EmptyColumn89
     ,SPACE(9) AS EmptyColumn90
     ,SPACE(30) AS EmptyColumn91
     ,SPACE(18) AS EmptyColumn92
     ,SPACE(2) AS EmptyColumn93
     ,SPACE(9) AS EmptyColumn94
     ,SPACE(10) AS EmptyColumn95
     ,SPACE(6) AS EmptyColumn96
     ,SPACE(1) AS EmptyColumn97
     ,SPACE(1) AS EmptyColumn98
     ,SPACE(80) AS EmptyColumn99
     ,SPACE(3) AS EmptyColumn100
     ,SPACE(35) AS EmptyColumn101
     ,SPACE(9) AS EmptyColumn102
     ,SPACE(30) AS EmptyColumn103
     ,SPACE(18) AS EmptyColumn104
     ,SPACE(2) AS EmptyColumn105
     ,SPACE(9) AS EmptyColumn106
     ,SPACE(10) AS EmptyColumn107
     ,SPACE(6) AS EmptyColumn108
     ,SPACE(1) AS EmptyColumn109
     ,SPACE(1) AS EmptyColumn110
     ,SPACE(80) AS EmptyColumn111
     ,SPACE(3) AS EmptyColumn112
     ,SPACE(35) AS EmptyColumn113
     ,SPACE(9) AS EmptyColumn114
     ,SPACE(30) AS EmptyColumn115
     ,SPACE(18) AS EmptyColumn116
     ,SPACE(2) AS EmptyColumn117
     ,SPACE(9) AS EmptyColumn118
     ,SPACE(10) AS EmptyColumn119
     ,SPACE(6) AS EmptyColumn120
     ,SPACE(1) AS EmptyColumn121
     ,SPACE(1) AS EmptyColumn122
     ,SPACE(80) AS EmptyColumn123
     ,SPACE(3) AS EmptyColumn124
     ,SPACE(4) AS EmptyColumn125
     ,LEFT(sbond.BondCompanyName + SPACE(30), 30) AS BondCompanyName
     ,LEFT(CONVERT(VARCHAR(8), sbond.BondAmount) + SPACE(8), 8) AS BondAmount
     ,SPACE(30) AS EmptyColumn126
     ,CASE
         WHEN sbond.BondReleaseDate IS NULL THEN SPACE(8)
         WHEN sbond.BondAmount <= 0 THEN SPACE(8)
         ELSE LEFT(CONVERT(VARCHAR(8), sbond.BondReleaseDate, 112) + SPACE(8), 8) 
      END AS BondReleaseDate
     ,LEFT(sbond.BondType + SPACE(2), 2) AS BondType
     ,SPACE(30) AS EmptyColumn127
     ,LEFT(CONVERT(CHAR(1), sbond.BondRenewal) + SPACE(1), 1) AS BondRenewal
     ,SPACE(80) AS EmptyColumn128
     ,CASE
         WHEN s.ApprovalDate IS NULL THEN SPACE(8)
         ELSE LEFT(CONVERT(VARCHAR(8), s.ApprovalDate, 112) + SPACE(8), 8)
      END AS ApprovalDate
     ,SPACE(2) AS EmptyColumn129
     ,SPACE(100) AS EmptyColumn130
     ,LEFT(ss.StatusCode + SPACE(1), 1) AS AgentStatus
     ,SPACE(12) AS EmptyColumn131
   FROM
      dbo.[Site] s
      LEFT OUTER JOIN dbo.SiteBond sbond ON s.SiteId = sbond.SiteId
      LEFT OUTER JOIN dbo.SiteBanking sbank ON s.SiteID = sbank.SiteID
      JOIN dbo.SiteStatus ss ON s.SiteId = ss.SiteId
      LEFT OUTER JOIN dbo.SiteFederal sf ON s.SiteId = sf.SiteId
      LEFT OUTER JOIN dbo.SiteOwner so ON s.SiteId = so.SiteID
   WHERE s.SiteApplicationComplete = 1
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT   INTO EventLog
            (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
            (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)), @ErrorDescription, 'MD_RetrieveDunningInfo', -1)
END CATCH
GO
