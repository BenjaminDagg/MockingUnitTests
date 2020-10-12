SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: Get_Cash_Drawer_Balance user stored procedure.

  Created: 05/15/2002 by Terry Watkins

  Purpose: Returns Cash Drawer Balance for a Cashier Session

Arguments: @SessionID:    Payout screen session id


Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
Terry Watkins 05-15-2002 Original coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Get_Cash_Drawer_Balance] @SessionID VarChar(40)
AS

DECLARE @MoneyIn  Money
DECLARE @MoneyOut Money

-- Get total of session starting amount plus all additions...
SELECT @MoneyIn = ISNULL(SUM(TRANS_AMT), 0)
FROM CASHIER_TRANS
WHERE SESSION_ID = @SessionID AND TRANS_TYPE IN ('S','A')

-- Get total of session payouts and removals...
SELECT @MoneyOut = ISNULL(SUM(TRANS_AMT), 0)
FROM CASHIER_TRANS
WHERE SESSION_ID = @SessionID AND TRANS_TYPE IN ('P','R')

-- Return single row and column calc as ending balance.
SELECT (@MoneyIn - @MoneyOut) AS ENDING_BALANCE

GO
