SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_CashierActivity user stored procedure.

  Created: 01/01/2011 by Aldo Zamora

  Purpose: Returns data for the Cashier Activity report
   
Arguments:
   @StartDate:    Starting DateTime for the resultset
   @EndDate:      Ending DateTime for the resultset
   
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora 01-01-2011
  Initial Coding
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[rpt_CashierActivity]
   @StartDate DATETIME,
   @EndDate   DATETIME
   
AS

-- Declare Variables
DECLARE @HideVoucherID BIT

-- Set Variables
SELECT @HideVoucherID = ItemValueBit FROM dbo.SSRSSetting WHERE ItemKey = 'HideVoucherID'

SELECT
   au.FirstName + ' ' + au.LastName AS Cashier
  ,vp.LocationID AS LocationID
  ,cas.CAS_NAME AS Location
  ,vp.VoucherID AS VoucherID
  ,CASE @HideVoucherID
     WHEN 1 THEN REPLICATE('*', 14) + RIGHT(vp.BARCODE, 4)
     WHEN 0 THEN vp.BARCODE
   END AS ValidationID
  ,vp.TransAmount AS Amount
  ,vp.PosWorkStation AS WorkStation
  ,vp.PayDateTime AS PayDate
FROM
   VoucherPayout vp
   JOIN AppUser au ON vp.AppUserID = au.AppUserID
   JOIN dbo.CASINO cas ON vp.LocationID = cas.LOCATION_ID
WHERE
   vp.PayDateTime BETWEEN @StartDate AND @EndDate

GO
GRANT EXECUTE ON  [dbo].[rpt_CashierActivity] TO [SSRS]
GO
