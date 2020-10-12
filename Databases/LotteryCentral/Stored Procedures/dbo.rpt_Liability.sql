SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Liability user stored procedure.

Created: 01/04/2011 by Aldo Zamora

Purpose: Returns data for the Liability report

Arguments: 


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   2004-08-16
  Initial coding.
  
Louis Epstein 2014-04-03
  Modified voucher expiration to use new expiration date function
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Liability]
AS


-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Retrieve data into a temporary table.
SELECT
   v.VOUCHER_ID       AS VoucherID,
   v.LOCATION_ID      AS LocationID,
   cas.CAS_NAME       AS LocationName,
   v.VOUCHER_AMOUNT   AS VoucherAmount,
   ms.CASINO_MACH_NO  AS LocationMachine,
   ms.MACH_NO         AS DGMachine, 
   v.CREATE_DATE      AS CreatedDate
FROM
   VOUCHER v
   JOIN CASINO   cas   ON v.LOCATION_ID = cas.LOCATION_ID
   JOIN MACH_SETUP ms  ON v.CREATED_LOC = ms.MACH_NO AND v.LOCATION_ID = ms.LOCATION_ID
WHERE
   v.REDEEMED_STATE = 0 AND
   dbo.ufnIsVoucherExpired(v.LOCATION_ID, VOUCHER_ID) = 0
ORDER BY
   cas.CAS_NAME
GO
GRANT EXECUTE ON  [dbo].[rpt_Liability] TO [SSRS]
GO
