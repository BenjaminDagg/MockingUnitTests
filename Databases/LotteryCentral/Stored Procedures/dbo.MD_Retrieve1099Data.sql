SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure: MD_Retrieve1099Data user stored procedure.

Created: 07-08-2014 by Cj Price

Purpose: Used by the iLMS export view

Arguments: 


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Cj Price   07-08-2014     
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[MD_Retrieve1099Data]
		@StartDate DATETIME
		,@EndDate DATETIME
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
DECLARE @AdjustmentAmount MONEY

SELECT @AdjustmentAmount = ISNULL(SUM(Amount), 0)
FROM dbo.AccountingAdjustments
WHERE
   AdjustmentDate BETWEEN @StartDate AND @EndDate AND 
   IsActive = 1

SELECT 
      LEFT(s.[RetailerNumber] + SPACE(8), 8) AS AgentNumber
      ,LEFT(s.[FullName] + SPACE(30), 30) AS AgentName
      ,LEFT(s.[StreetAddress] + SPACE(30), 30) AS AgentAddress
      ,LEFT(s.[City] + SPACE(18), 18) AS AgentCity
      ,LEFT(s.[State] + SPACE(2), 2) AS StateCode
      ,LEFT(s.[ZipCode] + SPACE(5), 5) AS ZipCode
      ,LEFT([dbo].unf_DecryptValue(so.[SSN]) + SPACE(9), 9) AS SocialSecurityNumber
      ,LEFT(s.[TerritoryNumber] + SPACE(2), 2) AS AgentTerritory
      ,LEFT(s.[CountyCode] + SPACE(1), 1) AS CompanyCode
      ,LEFT('1' + SPACE(1), 1) AS FederalIdIndicator
      ,RIGHT('00000000000' + convert(varchar,cast(ISNULL(da.SalesCommissions + da.CashingCommissions, 0) as money),1) ,11) AS Commissions
      ,RIGHT('00000000000' + convert(varchar,cast(0 as money),1) ,11) AS Fees
      ,RIGHT('00000000000' + convert(varchar,cast(0 as money),1) ,11) AS InstantBonus
      ,RIGHT('00000000000' + convert(varchar,cast(0 as money),1) ,11) AS Miscellanous
      ,RIGHT('000000000000' + convert(varchar,cast(ISNULL(da.Bonus, 0) as money),1) ,12) AS RetailerBonus
      ,RIGHT('00000000000000' + convert(varchar,cast(ISNULL(da.SalesCommissions + da.CashingCommissions + da.Bonus, 0) as money),1) ,14) AS TotalAmount
      
  FROM [dbo].[Site] s
  INNER JOIN [dbo].[SiteOwner] so ON so.SiteId = s.SiteId
  INNER JOIN [dbo].[MD_DailyAccounting] da ON da.RetailerNumber = s.RetailerNumber
        AND DATEADD(dd, DATEDIFF(dd, 0, da.DateProcessed), 0) BETWEEN DATEADD(dd, 1, @StartDate) AND DATEADD(dd, 1, @EndDate)
	
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT   INTO EventLog
            (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
            (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)), @ErrorDescription, 'MD_Retrieve1099Data', -1)
END CATCH
GO
