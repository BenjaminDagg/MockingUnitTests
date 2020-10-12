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
Louis Epstein 03-31-2014     v3.2.1
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnVoucherExpirationDate]
(
@VoucherID int
)
RETURNS datetime
AS
BEGIN

DECLARE @ReturnBit bit, @ExpirationDays int, @NormalizeAccountingDate bit, @SecondsOffset int, @AccountingHours int

SELECT @ExpirationDays = CAST(VALUE1 AS int), @NormalizeAccountingDate = CAST(VALUE2 AS bit), @SecondsOffset = CAST(VALUE3 AS int) FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'VOUCHER_EXPIRATION_DAYS'
SELECT @AccountingHours = DATEPART(HOUR, TO_TIME) FROM CASINO

RETURN (SELECT DATEADD(SECOND, @SecondsOffset, DATEADD(DAY, @ExpirationDays, CASE WHEN @NormalizeAccountingDate = 1 THEN DATEADD(HOUR, @AccountingHours, DATEADD(DAY, 1, CAST(CAST(CREATE_DATE AS date) AS datetime))) ELSE CREATE_DATE END)) FROM VOUCHER WHERE VOUCHER_ID = @VoucherID)

END
GO
