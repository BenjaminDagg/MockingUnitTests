SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: usp_DuplicateTickets user stored procedure.

  Created: 09-23-2004 by Terry Watkins

  Purpose: Returns CASINO_TRANS data for tickets dispensed more than once

Arguments: None

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 2006-10-04     v5.0.8
  Removed update of CASINO_TRANS.TICKET_STATUS_ID (column removed from table).
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[usp_DuplicateTickets]
AS

-- Local variable declarations --
DECLARE @DealNbr      Int
DECLARE @TicketNbr    Int
DECLARE @DupeCount    Int
DECLARE @MinTransNo   Int
DECLARE @MaxTransNo   Int

DECLARE @TotalTransAmt  Money


-- Declare cursor --
DECLARE DupTicketInfo CURSOR FAST_FORWARD
FOR
SELECT
   DEAL_NO,
   TICKET_NO,
   COUNT(*) AS DuplicateCount,
   MIN(TRANS_NO) AS MinTransNo,
   MAX(TRANS_NO) AS MaxTransNo
FROM CASINO_TRANS
WHERE
   (DEAL_NO > 0)   AND
   (TICKET_NO > 0)
GROUP BY DEAL_NO, TICKET_NO
HAVING COUNT(*) > 1
ORDER BY DEAL_NO, TICKET_NO


-- Build a temporary table that mirrors CASINO_TRANS
CREATE TABLE #CT_Temp
    (
  [TRANS_NO]         [int]           NOT NULL ,
  [CAS_ID]           [char] (6)      NOT NULL ,
  [DEAL_NO]          [int]           NOT NULL ,
  [MACH_NO]          [char] (5)      NULL ,
  [ROLL_NO]          [smallint]      NOT NULL ,
  [TICKET_NO]        [int]           NOT NULL ,
  [DENOM]            [smallmoney]    NULL ,
  [TRANS_AMT]        [money]         NULL ,
  [BARCODE_SCAN]     [varchar] (128) NULL ,
  [TRANS_ID]         [smallint]      NULL ,
  [DTIMESTAMP]       [datetime]      NOT NULL ,
  [ACCT_DATE]        [smalldatetime] NULL ,
  [MODIFIED_BY]      [varchar] (32)  NULL ,
  [CARD_ACCT_NO]     [char] (16)     NULL ,
  [BALANCE]          [money]         NULL ,
  [GAME_CODE]        [varchar] (3)   NULL ,
  [COINS_BET]        [smallint]      NULL ,
  [LINES_BET]        [tinyint]       NULL ,
  [TIER_LEVEL]       [smallint]      NULL ,
  [PRODUCT_ID]       [tinyint]       NULL 
)

-- Open the cursor.
OPEN DupTicketInfo

-- Get the first row of data.
-- PRINT 'Fetching first row'
FETCH FROM DupTicketInfo INTO @DealNbr, @TicketNbr, @DupeCount, @MinTransNo, @MaxTransNo


WHILE (@@FETCH_STATUS = 0)
   -- Successfully FETCHed a record, so check if we need a new row for the
   -- temp table or if we need to update the current row in the temp table...
   BEGIN
      INSERT INTO #CT_Temp
         SELECT
            TRANS_NO, CAS_ID, DEAL_NO, MACH_NO, ROLL_NO, TICKET_NO, DENOM, TRANS_AMT,
            BARCODE_SCAN, TRANS_ID, DTIMESTAMP, ACCT_DATE, MODIFIED_BY, CARD_ACCT_NO,
            BALANCE, GAME_CODE, COINS_BET, LINES_BET, TIER_LEVEL, PRODUCT_ID
         FROM CASINO_TRANS
         WHERE
            (TRANS_NO BETWEEN @MinTransNo AND @MaxTransNo) AND
            (DEAL_NO = @DealNbr) AND
            (TICKET_NO = @TicketNbr)
      
      FETCH NEXT FROM DupTicketInfo INTO @DealNbr, @TicketNbr, @DupeCount, @MinTransNo, @MaxTransNo
   END


CLOSE DupTicketInfo
DEALLOCATE DupTicketInfo

PRINT 'Fetch Loop finished...'
PRINT 'Retrieving total TransAmt...'
SELECT @TotalTransAmt = SUM(TRANS_AMT) FROM #CT_Temp
PRINT 'Total Transaction Amount: ' + CAST(@TotalTransAmt AS VarChar)


PRINT 'Fetch Loop finished, retreiving dataset...'
SELECT * FROM #CT_Temp ORDER BY DEAL_NO, TICKET_NO, TRANS_NO


-- Drop the temp table.
DROP TABLE #CT_Temp
GO
