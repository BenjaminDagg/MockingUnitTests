SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_VoucherLot user stored procedure.

  Created: 01-27-2011 by Terry Watkins

  Purpose: Retrieve voucher lot report data for cr_Voucher_Lot report.

Arguments: None

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 01-27-2011     7.2.4DC
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Voucher_Lot]
AS

-- Suppress unwanted statistics
SET NOCOUNT ON

-- Get Voucher Lot data
SELECT LOCATION_ID, LOT_NUMBER, DATE_RECEIVED
FROM VOUCHER_LOT
ORDER BY VOUCHER_LOT_ID
GO
