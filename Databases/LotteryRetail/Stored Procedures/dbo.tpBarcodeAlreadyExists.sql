SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpBarcodeAlreadyExists

Created 05-26-2005 by A. Murthy

Desc: Checks if a newly generated BarCode is already in the "Voucher" table.

Return values: Count of rows holding the Barcode : either 0 or 1

Called by: TPIClient.vb\BarcodeAlreadyExists

Parameters:
   @Barcode             Barcode of the Ticket

Change Log:

Changed By    Date          Database Version
  Change Description
--------------------------------------------------------------------------------
Ashok Murthy  05-26-2005    v4.1.4
  Initial coding.

Ashok Murthy  01-05-2006    v5.0.1
  Changed @Barcode to VarChar to support 12 char. Iowa Barcodes.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[tpBarcodeAlreadyExists]
   @Barcode             VarChar(18)
AS

-- Variable Declarations

SET NOCOUNT ON

-- check to see if the BarCode already exists (DUPLICATE BarCode)
SELECT COUNT(*) FROM VOUCHER WHERE BARCODE = @BarCode
GO
