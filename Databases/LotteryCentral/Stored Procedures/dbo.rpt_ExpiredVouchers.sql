SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_ExpiredVouchers user stored procedure.

Created: 2011-03-16 by Aldo Zamora

Purpose: Returns data for the Expired Vouchers report.

Arguments:
   @StartDate:    Starting DateTime for the resultset
   @EndDate:      Ending DateTime for the resultset

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   2011-03-16
  Initial coding.

Louis Epstein 2014-04-03
  Modified voucher expiration to use new expiration date function
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[rpt_ExpiredVouchers]
   @StartDate DATETIME,
   @EndDate DATETIME

AS

-- Declare Variables
DECLARE @ExpirationDays INT
DECLARE @HideVoucherID BIT
DECLARE @NumberOfDigitsToDisplay INT

-- Set Variables
SELECT @ExpirationDays = ItemValueInt FROM dbo.AppSetting WHERE ItemKey = 'VoucherExpirationDays'
SELECT
   @HideVoucherID = ItemValueBit
   ,@NumberOfDigitsToDisplay = ItemValueInt
FROM dbo.SSRSSetting WHERE ItemKey = 'HideVoucherID'

SELECT
   LOCATION_ID AS LocationID
  ,CASE @HideVoucherID
     WHEN 1 THEN REPLICATE('*', 14) + RIGHT(BARCODE, @NumberOfDigitsToDisplay)
     WHEN 0 THEN BARCODE
   END AS VoucherID
  ,VOUCHER_AMOUNT AS VoucherAmount
  ,CREATE_DATE AS CreatedDate
  ,dbo.ufnVoucherExpirationDate(LOCATION_ID, VOUCHER_ID) AS ExpirationDate
FROM
   dbo.VOUCHER
WHERE
   REDEEMED_STATE = 0
   AND CREATE_DATE BETWEEN DATEADD(d, -@ExpirationDays, @StartDate)
                   AND     DATEADD(d, -@ExpirationDays, @EndDate)
GROUP BY
   LOCATION_ID
  ,BARCODE
  ,VOUCHER_ID
  ,VOUCHER_AMOUNT
  ,CREATE_DATE
ORDER BY
   CREATE_DATE
GO
GRANT EXECUTE ON  [dbo].[rpt_ExpiredVouchers] TO [SSRS]
GO
