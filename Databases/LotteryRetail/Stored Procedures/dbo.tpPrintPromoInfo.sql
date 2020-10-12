SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpPrintPromoInfo

Created 03-28-2007 by Terry Watkins

Returns: Bank number and Promo ticket information

Called by: Transaction Portal

Parameters: Flag value
   

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-28-2007     v5.0.8
  Initial coding.

Terry Watkins 08-26-2008     v6.0.2
  Added retrieval of new BANK.ENTRY_TICKET_AMOUNT column.
  Note that it is converted to cents and returned as an integer.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpPrintPromoInfo]
AS

DECLARE @PrintPromoValue Bit

-- Retrieve the resultset.
SELECT
   BANK_NO,
   ENTRY_TICKET_FACTOR,
   CAST(ENTRY_TICKET_AMOUNT * 100 AS INT) AS ENTRY_TICKET_AMOUNT
FROM BANK
ORDER BY BANK_NO
GO
