SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: SetVoucherTransferFlag

  Created: Aldo Zamora

  Purpose: Sets the voucher transfer flag on.

Arguments: None.
   
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   2011-04-07     
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SetVoucherTransferFlag]
AS
	
-- Suppress return of message data.
SET NOCOUNT ON

-- Variable Declarations
DECLARE @TransferDate         DateTime
DECLARE @VoucherTransferDays  Int

-- Variable Initialization
SELECT @VoucherTransferDays = CAST(VALUE1 AS INT) FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'VOUCHER_TRANSFER_DAYS'

SET @TransferDate = DATEADD(d, -@VoucherTransferDays, GETDATE())

UPDATE VOUCHER
SET
   UCV_TRANSFERRED   = 1,
   UCV_TRANSFER_DATE = GETDATE()
WHERE
   UCV_TRANSFERRED = 0 AND
   VOUCHER_TYPE    < 2 AND
   REDEEMED_STATE  = 0 AND
   CREATE_DATE     <= @TransferDate
GO
