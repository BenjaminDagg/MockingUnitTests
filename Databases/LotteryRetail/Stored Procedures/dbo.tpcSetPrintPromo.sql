SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpcSetPrintPromo

Created 03-28-2007 by Terry Watkins

Returns: Zero if successful, Error code if an error occurs

Called by: Transaction Portal Control

Parameters: Flag value
   

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-28-2007     v5.0.8
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpcSetPrintPromo] @PrintPromoValue Bit
AS

UPDATE CASINO SET PRINT_PROMO_TICKETS = @PrintPromoValue WHERE SETASDEFAULT = 1
GO
