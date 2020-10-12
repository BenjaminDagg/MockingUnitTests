SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure: Get_PS_Interface_Detail user stored procedure.

  Created: 01/12/2004 by Terry Watkins  

  Purpose: Retrieves Machine data for the detail records of the Cherokee
           Peoplesoft Interface file.

Arguments: @AcctDate - The Accounting Date for the required data.

Change Log:

Changed By    Date
  Change Description      DB Version
--------------------------------------------------------------------------------
Terry Watkins 2004-01-12
  Initial Coding.

Terry Watkins 2004-03-10
  Per request from Sun Dee at CNC, modified to create all Money_In values in a
  zero denom row.

Terry Watkins 2004-03-11
  Modified to run against MACHINE_STATS and to use CASINO_MACH_NO as the Machine
  Number.

Terry Watkins 2004-03-11  v4.0.0
  Change TICKET_IN and TICKET_OUT values from hard-coded zero to using new
  columns TICKET_IN_AMOUNT and TICKET_OUT_AMOUNT in MACHINE_STATS.

Terry Watkins 2005-05-02  v4.1.0
  Modified CASH_IN row to include rows having
  TICKET_IN_AMOUNT > 0 OR TICKET_OUT_AMOUNT > 0
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Get_PS_Interface_Detail] @AcctDate DateTime
AS

-- Get one CASH_IN row for each machine.
-- All of the other amount values will be zero.

SELECT
   ISNULL(ms.MACH_SERIAL_NO, '')  AS SERIAL_ID,
   ms.CASINO_MACH_NO              AS MACHINE_NBR,
   MAX(LEFT(gs.GAME_DESC, 30))    AS MODEL_NAME,
   CAST(0 AS SMALLMONEY)          AS DENOMINATION,
   SUM(mst.AMOUNT_IN)             AS CASH_IN,
   CAST(0 AS MONEY)               AS PLAY_BACK,
   SUM(TICKET_IN_AMOUNT)          AS TICKET_IN,
   CAST(0 AS MONEY)               AS CASH_OUT,
   CAST(0 AS MONEY)               AS CASH_WON,
   SUM(TICKET_OUT_AMOUNT)         AS TICKET_OUT
FROM MACHINE_STATS mst
   JOIN MACH_SETUP ms ON mst.MACH_NO  = ms.MACH_NO
   JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE
   mst.ACCT_DATE = @AcctDate AND
   (mst.AMOUNT_IN > 0 OR mst.TICKET_IN_AMOUNT > 0 OR mst.TICKET_OUT_AMOUNT > 0)
GROUP BY ms.CASINO_MACH_NO, ms.MACH_SERIAL_NO

UNION

-- Retrieve Machine play related data (but not Money In transactions)
SELECT
   ISNULL(ms.MACH_SERIAL_NO, '')            AS SERIAL_ID,
   ms.CASINO_MACH_NO                        AS MACHINE_NBR,
   LEFT(gs.GAME_DESC, 30)                   AS MODEL_NAME,
   cf.DENOMINATION                          AS DENOMINATION,
   CAST(0 AS MONEY)                         AS CASH_IN,
   SUM(mst.AMOUNT_PLAYED)                   AS PLAY_BACK,
   SUM(mst.TICKET_IN_AMOUNT)                AS TICKET_IN,
   CAST(0 AS MONEY)                         AS CASH_OUT,
   SUM(mst.AMOUNT_WON + mst.AMOUNT_JACKPOT) AS CASH_WON,
   SUM(mst.TICKET_OUT_AMOUNT)               AS TICKET_OUT
FROM MACHINE_STATS mst
   JOIN DEAL_SETUP ds   ON mst.DEAL_NO = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB
   JOIN MACH_SETUP ms   ON mst.MACH_NO = ms.MACH_NO
   JOIN GAME_SETUP gs   ON ms.GAME_CODE = gs.GAME_CODE
WHERE
   mst.ACCT_DATE = @AcctDate AND
   mst.PLAY_COUNT > 0
GROUP BY ms.MACH_SERIAL_NO, ms.CASINO_MACH_NO, cf.DENOMINATION, LEFT(gs.GAME_DESC, 30)
ORDER BY 2, 4
GO
