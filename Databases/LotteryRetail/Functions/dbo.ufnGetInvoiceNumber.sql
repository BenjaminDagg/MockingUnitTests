SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnGetInvoiceNumber

Created 08-06-2008 by Terry Watkins

Purpose: Creates an Invoice number for the active Casino based upon the
         End Date argument value.

Returns: VarChar invoice number value

Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-06-2005     v6.0.2
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnGetInvoiceNumber](@EndDate DateTime) RETURNS VarChar(16)
AS

BEGIN
   -- Variable Declarations
   DECLARE @CasinoID     Char(6)
   DECLARE @ReturnValue  VarChar(16)
   
   -- Retrieve the Casino Identifier of the default casino...
   SELECT @CasinoID = CAS_ID
   FROM CASINO
   WHERE SETASDEFAULT = 1
   
   -- Now assemble the invoice number using the Casino ID and the Start Date...
   SET @ReturnValue = @CasinoID + '_' +
                      RIGHT(CAST(YEAR(@EndDate) AS VarChar(4)), 2) +
                      dbo.ufnLeftPadIntValue(MONTH(@EndDate), '0', 2) +
                      dbo.ufnLeftPadIntValue(DAY(@EndDate), '0', 2)
   
   -- Set the function return value.
   RETURN @ReturnValue
END
GO
