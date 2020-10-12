SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpcGetPrintPromo

Created 03-28-2007 by Terry Watkins

Returns: Flag indicating if machines are to print Promo Tickets.

Called by: Transaction Portal Control

Parameters: <none>
   

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-28-2007     v5.0.8
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpcGetPrintPromo]
AS

SELECT CAST(PRINT_PROMO_TICKETS AS INTEGER) AS PrintPromoTickets
FROM CASINO
WHERE SETASDEFAULT = 1
GO
