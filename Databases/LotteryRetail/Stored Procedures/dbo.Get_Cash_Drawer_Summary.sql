SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: Get_Cash_Drawer_Summary user stored procedure.

  Created: 05/17/2002 by Terry Watkins

  Purpose: Returns Cash Drawer Summary for a Cashier Session

Arguments: @SessionID:    Payout screen session id


Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
DGETAW        05/17/2002 Original coding
DGETAW        05/24/2002 Added retrieval of the CASHIER_TRANS_ID for the 'E'nd
                         of session CASHIER_TRANS record so it can be displayed
                         on the Session Summary CD (cash drawer) receipt.
                         
Louis Epstein 10-09-2013 Added multi-voucher transaction count
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Get_Cash_Drawer_Summary] @SessionID VarChar(40)
AS

-- Variable Declarations
DECLARE @StartingBalance Money
DECLARE @EndingBalance   Money
DECLARE @PayoutSum       Money
DECLARE @CashAdded       Money
DECLARE @CashRemoved     Money
DECLARE @PayoutCount     Int
DECLARE @CashierTransID  Int
DECLARE @TransUserName   VarChar(30)
DECLARE @TransactionCount Int

-- Get the session userid.
SELECT @TransUserName = ISNULL(MAX(CREATED_BY), '') FROM CASHIER_TRANS WHERE SESSION_ID = @SessionID

-- Get total, count, and UserID for all payout transactions...
SELECT @PayoutSum = ISNULL(SUM(TRANS_AMT), 0), @PayoutCount = ISNULL(COUNT(*), 0)
FROM CASHIER_TRANS
WHERE SESSION_ID = @SessionID AND TRANS_TYPE = 'P'

-- Get starting and ending amounts...
SELECT @StartingBalance = ISNULL(TRANS_AMT, 0)
FROM CASHIER_TRANS
WHERE SESSION_ID = @SessionID AND TRANS_TYPE = 'S'

SELECT @EndingBalance = ISNULL(TRANS_AMT, 0), @CashierTransID = ISNULL(CASHIER_TRANS_ID, 0)
FROM CASHIER_TRANS
WHERE SESSION_ID = @SessionID AND TRANS_TYPE = 'E'

-- Get Cash Drawer Adds and Removals...
SELECT @CashAdded = ISNULL(SUM(TRANS_AMT), 0)
FROM CASHIER_TRANS
WHERE SESSION_ID = @SessionID AND TRANS_TYPE = 'A'

SELECT @CashRemoved = ISNULL(SUM(TRANS_AMT), 0)
FROM CASHIER_TRANS
WHERE SESSION_ID = @SessionID AND TRANS_TYPE = 'R'

SELECT @TransactionCount = COUNT(VOUCHER_RECEIPT_NO) FROM
(
	SELECT DISTINCT VOUCHER_RECEIPT_NO
	FROM VOUCHER_RECEIPT_DETAILS VRD
	JOIN CASHIER_TRANS CT ON VRD.CashierTransID = CASHIER_TRANS_ID
	WHERE SESSION_ID = @SessionID
) AS T0


-- Resultset we will return...
SELECT
   @SessionID          AS SESSION_ID,
   @TransUserName      AS TRANS_USER,
   @StartingBalance    AS START_BALANCE,
   @EndingBalance      AS ENDING_BALANCE, 
   (@PayoutSum * -1)   AS PAYOUT_SUM,
   @PayoutCount        AS PAYOUT_COUNT,
   @CashAdded          AS CASH_ADDED,
   (@CashRemoved * -1) AS CASH_REMOVED,
   @CashierTransID     AS CASHIER_TRANS_ID,
   @TransactionCount   AS TransactionCount

GO
