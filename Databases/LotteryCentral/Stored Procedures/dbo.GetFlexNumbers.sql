SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: GetFlexNumbers

Created on: 04-13-2011

   Purpose: Gets all of the flex numbers

 Arguments:
   
 Called by: Lottery Management System 
   
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   09-15-2010
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetFlexNumbers]
AS
	
-- Suppress return of message data.
SET NOCOUNT ON

SELECT
(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount In' ) AS AmountIn,
(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher In' ) AS VoucherIn,
(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Voucher Out') AS VoucherOut,
(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Played') AS AmountPlayed,
(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Amount Won') AS AmountWon,
(SELECT FlexNumber FROM RevenueType WHERE RevenueTypeDescription = 'Net Revenue') AS NetRevenue
GO
