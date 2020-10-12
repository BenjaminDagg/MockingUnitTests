SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: RecordInvoiceHistory user stored procedure.

  Created: 08-08-2008 by Terry Watkins  

  Purpose: Inserts or updates an INVOICE_HISTORY row.
           Should be called after an invoice if printed or reprinted.

Arguments: @InvoiceNbr - Invoice number.
           @StartDate  - Starting date that the invoice covers.
           @EndDate    - Ending date that the invoice covers.
           @UserName   - User that printed/created or reprinted the invoice.

Change Log:

Date       By                Database version
  Change Description
--------------------------------------------------------------------------------
08-08-2008 Terry Watkins     v6.0.2
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[RecordInvoiceHistory]
   @InvoiceNbr VarChar(16),
   @StartDate  DateTime,
   @EndDate    DateTime,
   @UserName   VarChar(16)
AS

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Variable Declarations
DECLARE @CurrentDate DateTime

-- Variable Initialization
SET @CurrentDate = GETDATE()

-- Does the invoice already exist?
IF EXISTS(SELECT * FROM INVOICE_HISTORY WHERE INVOICE_NO = @InvoiceNbr)
   -- Yes, so update reprint info...
   BEGIN
      UPDATE INVOICE_HISTORY SET
         REPRINTED_DATE = @CurrentDate,
         REPRINTED_BY   = @UserName
      WHERE INVOICE_NO = @InvoiceNbr
   END
ELSE
   -- No, so insert a row updating date range and printed by info...
   BEGIN
      INSERT INTO INVOICE_HISTORY
         (INVOICE_NO, RANGE_DATE_FROM, RANGE_DATE_TO, PRINTED_DATE, PRINTED_BY)
      VALUES
         (@InvoiceNbr, @StartDate, @EndDate, @CurrentDate, @UserName)
   END
GO
