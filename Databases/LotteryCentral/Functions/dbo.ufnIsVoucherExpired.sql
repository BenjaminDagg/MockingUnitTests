SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
User Defined Function ufnIsVoucherExpired

Created 03-31-2014 by Louis Epstein

Purpose: Returns a boolean value indicating if a Voucher has expired

Returns: Bit value of 1 to indicate voucher is expired


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 03-31-2014     v3.2.1
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnIsVoucherExpired]
(
@LocationID int,
@VoucherID int
)
RETURNS bit
AS
BEGIN
RETURN (SELECT CASE WHEN dbo.ufnVoucherExpirationDate(@LocationID, @VoucherID) < GETDATE() THEN 1 ELSE 0 END)
END

GO
