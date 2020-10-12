SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User View uvwJackpotByAcctDate

Created 04-09-2007 by Terry Watkins

Summarizes Jackpot info by Accounting Date and Machine Number
--------------------------------------------------------------------------------
*/
CREATE VIEW [dbo].[uvwJackpotByAcctDate]
AS
SELECT
   MACH_NO,
   CASINO_MACH_NO,
   ACCT_DATE,
   SUM(JACKPOT_COUNT)  AS JP_COUNT,
   SUM(AMOUNT_JACKPOT) AS JP_AMOUNT
FROM dbo.MACHINE_STATS
GROUP BY MACH_NO, CASINO_MACH_NO, ACCT_DATE
HAVING (SUM(JACKPOT_COUNT) > 0)
GO
