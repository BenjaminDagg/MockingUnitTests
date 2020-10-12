SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: Get_Archive_Info user stored procedure.

  Created: 07-29-2004 by Terry Watkins  

  Purpose: Retrieves Archive information.

Arguments: @TableName - The Accounting Date for the required data.

Change Log:

Date       Changed By        Database Version
  Change Description
--------------------------------------------------------------------------------
2004-07-29 Terry Watkins
  Initial Coding.

06-15-2005 Terry Watkins     v4.1.4
  Changed datatype for card account numbers from Char(16) to VarChar(20)

04-20-2006 Terry Watkins     v5.0.2
  Added ISNULL check to MIN and MAX for high and low CARD_ACCT_NO values.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Get_Archive_Info]
AS
DECLARE @FilterDate                DateTime

DECLARE @CardAcctNoHigh            VarChar(20)
DECLARE @CardAcctNoLow             VarChar(20)
DECLARE @DefaultCasinoID           Char(6)

DECLARE @CashierTransIdStart       Integer
DECLARE @CashierTransIdEnd         Integer
DECLARE @CashierTransRowCount      Integer

DECLARE @CasinoEventLogIdStart     Integer
DECLARE @CasinoEventLogIdEnd       Integer
DECLARE @CasinoEventLogRowCount    Integer

DECLARE @CasinoTransIdStart        Integer
DECLARE @CasinoTransIdEnd          Integer
DECLARE @CasinoTransRowCount       Integer

DECLARE @CardAcctLow               Integer
DECLARE @CardAcctHigh              Integer
DECLARE @CardAcctRowCount          Integer


-- Retrieve the default Casino ID.
SELECT @DefaultCasinoID = CAS_ID FROM CASINO WHERE SETASDEFAULT = 1

-- Set filter date
SELECT @FilterDate = MAX(ACCT_DATE) FROM MACHINE_STATS

IF @FilterDate IS NULL
   SELECT @FilterDate = MAX(ACCT_DATE) FROM CASINO_TRANS

SET @FilterDate = DATEADD(Day, -45, @FilterDate)

--PRINT 'Default Casino ID: ' + @DefaultCasinoID
--PRINT 'FilterDate: ' + CAST(@FilterDate AS VarChar)

-- Retrieve CASHIER_TRANS data
SELECT
   @CashierTransIdStart  = ISNULL(MIN(CASHIER_TRANS_ID), 0),
   @CashierTransIdEnd    = ISNULL(MAX(CASHIER_TRANS_ID), 0),
   @CashierTransRowCount = COUNT(*)
FROM CASHIER_TRANS
WHERE CREATE_DATE < @FilterDate


-- Retrieve CASINO_EVENT_LOG data
SELECT
   @CasinoEventLogIdStart  = ISNULL(MIN(CASINO_EVENT_LOG_ID), 0),
   @CasinoEventLogIdEnd    = ISNULL(MAX(CASINO_EVENT_LOG_ID), 0),
   @CasinoEventLogRowCount = COUNT(*)
FROM CASINO_EVENT_LOG
WHERE EVENT_DATE_TIME < @FilterDate


-- Retrieve CASINO_TRANS data
SELECT @CasinoTransIdEnd   = ISNULL(MAX(TRANS_NO), 0)
FROM CASINO_TRANS WHERE ACCT_DATE < @FilterDate

IF (@CasinoTransIdEnd = 0)
   BEGIN
      SET @CasinoTransIdStart = 0
      SET @CasinoTransRowCount = 0
   END
ELSE
   BEGIN
      SELECT @CasinoTransIdStart = ISNULL(MIN(TRANS_NO), 0)
      FROM CASINO_TRANS WHERE ACCT_DATE < @FilterDate
      
      SET @CasinoTransRowCount = (@CasinoTransIdEnd - @CasinoTransIdStart + 1)
   END

-- Retrieve CARD_ACCT info.
SELECT
   @CardAcctNoLow    = ISNULL(MIN(CARD_ACCT_NO), '0'),
   @CardAcctNoHigh   = ISNULL(MAX(CARD_ACCT_NO), '0'),
   @CardAcctRowCount = COUNT(*)
FROM CARD_ACCT
WHERE
   (MODIFIED_DATE < @FilterDate) AND
   (LEFT(CARD_ACCT_NO, 6) = @DefaultCasinoID) AND
   (ISNUMERIC(RIGHT(CARD_ACCT_NO, 10)) = 1)

SET @CardAcctLow  = CAST(RIGHT(@CardAcctNoLow,  10) AS Integer)
SET @CardAcctHigh = CAST(RIGHT(@CardAcctNoHigh, 10) AS Integer)

-- Return resultset.
SELECT
   @CashierTransIdStart     AS CASHIER_TRANS_ID_START,
   @CashierTransIdEnd       AS CASHIER_TRANS_ID_END,
   @CashierTransRowCount    AS CASHIER_TRANS_ROW_COUNT,
   @CasinoEventLogIdStart   AS CASINO_EVENT_LOG_ID_START,
   @CasinoEventLogIdEnd     AS CASINO_EVENT_LOG_ID_END,
   @CasinoEventLogRowCount  AS CASINO_EVENT_LOG_ROW_COUNT,
   @CasinoTransIdStart      AS CASINO_TRANS_ID_START,
   @CasinoTransIdEnd        AS CASINO_TRANS_ID_END,
   @CasinoTransRowCount     AS CASINO_TRANS_ROW_COUNT,
   @CardAcctLow             AS CARD_ACCT_LOW,
   @CardAcctHigh            AS CARD_ACCT_HIGH,
   @CardAcctRowCount        AS CARD_ACCT_ROW_COUNT,
   @FilterDate              AS FILTER_DATE
GO
