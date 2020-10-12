SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnIsVoucherExpired

Created 03-31-2014 by Louis Epstein

Purpose: Returns a datetime value indicating a vouchers expiration date

Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 04-03-2014     v3.1.3
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnVoucherExpirationDate]
(
@LocationID int,
@VoucherID int
)
RETURNS datetime
AS
BEGIN

DECLARE @ReturnBit bit, @ExpirationDays int, @NormalizeAccountingDate bit, @SecondsOffset int, @AccountingHours int

SELECT @ExpirationDays = CAST(ConfigValue AS int) FROM AppConfig WHERE ConfigKey = 'VoucherExpirationDays'
SELECT @NormalizeAccountingDate = CAST(ConfigValue AS bit) FROM AppConfig WHERE ConfigKey = 'VoucherExpirationNormalizeAccountingTime'
SELECT @SecondsOffset = CAST(ConfigValue AS int) FROM AppConfig WHERE ConfigKey = 'VoucherExpirationAdditionalSeconds'
SELECT @AccountingHours = DATEPART(HOUR, TO_TIME) FROM CASINO WHERE LOCATION_ID = @LocationID

RETURN (SELECT DATEADD(SECOND, @SecondsOffset, DATEADD(DAY, @ExpirationDays, CASE WHEN @NormalizeAccountingDate = 1 THEN DATEADD(HOUR, @AccountingHours, DATEADD(DAY, 1, CAST(CAST(CREATE_DATE AS date) AS datetime))) ELSE CREATE_DATE END)) FROM VOUCHER WHERE VOUCHER_ID = @VoucherID AND LOCATION_ID = @LocationID)

END
GO
