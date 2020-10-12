SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure: MD_RetrievePositivePayData user stored procedure.

Created: 05-15-2014 by Cj Price

Purpose: Used by the iLMS export view

Arguments: 


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Cj Price   05-15-2014     
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[MD_RetrievePositivePayData] 
		@StartDate DATETIME
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
DECLARE @LotteryBankAccountNumber NVARCHAR(4000)
/*
--------------------------------------------------------------------------------
   Initialize Variables
--------------------------------------------------------------------------------
*/
SET @Date = GETDATE()
SET @EpochDays = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())
SELECT @EventTypeID = EventTypeId FROM dbo.EventType WHERE EventName = 'MDLotteryAccounting'
SELECT @LotteryBankAccountNumber = dbo.unf_DecryptValue(ConfigValue) FROM dbo.AccountingConfig WHERE ConfigKey = 'LotteryBankAccountNumber'
/*
--------------------------------------------------------------------------------
   Collect data from all locations and insert into MO tables.
--------------------------------------------------------------------------------
*/
BEGIN TRY    
   SELECT
        replicate('0', 12 - len(@LotteryBankAccountNumber)) + @LotteryBankAccountNumber AS BankAccountNumber
		,CASE cp.IsVoid WHEN '1' THEN 'V'
					   WHEN '0' THEN ' ' END AS VoidIndicator
		,SPACE(2) AS Filler1
		,replicate('0', 10 - len(cp.CheckNumber)) + CONVERT(VARCHAR(10),cp.CheckNumber) AS CheckNumber
		,replicate('0', 12 - len(CONVERT(VARCHAR(10),CAST((cp.CheckAmount * 100) AS INT)))) + CONVERT(VARCHAR(10),CAST((cp.CheckAmount * 100) AS INT)) AS Amount
		,CONVERT(CHAR(2),cp.DatePrinted,101) + CONVERT(CHAR(2),cp.DatePrinted,103)+CONVERT(CHAR(2),cp.DatePrinted,12) AS IssuedDate
		,SPACE(3) AS Filler2
		,LEFT(cpi.FirstName+' '+cpi.LastName + SPACE(45), 45) AS FullName
   FROM
		[dbo].[CheckProcessing] cp
		INNER JOIN [dbo].[CustomerPayoutInfo] cpi ON cpi.CheckId = cp.CheckId
	WHERE 
		cp.DatePrinted BETWEEN @StartDate AND @StartDate+1
		AND cp.CheckNumber IS NOT NULL		
END TRY   

BEGIN CATCH
   SET @ErrorID = ERROR_NUMBER()
   SET @ErrorDescription = ERROR_MESSAGE()
   
   INSERT   INTO EventLog
            (PartionKey, EventDate, EventTypeID, [Description], Details, EventSource, UserId)
   VALUES
            (@EpochDays, @Date, @EventTypeID, 'SQL Error Number: ' + CAST(@ErrorID AS VARCHAR(1024)), @ErrorDescription, 'MD_RetrievePositivePayInfo', -1)
END CATCH
GO
