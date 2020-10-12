SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[uvwJackpotInfo]
/*
--------------------------------------------------------------------------------
01-19-2012 Terry Watkins
  Removed left outer join of MASTER_DEAL table and select of column
  md.TABLE_NAME AS MASTER_DEAL_TABLE_NAME.  MASTER_DEAL table dropped for
  LotteryRetail use.
--------------------------------------------------------------------------------
*/
AS
SELECT
   j.TRANS_NO,
   j.DTIMESTAMP,
   dbo.ufnGetAcctDateFromDate(j.DTIMESTAMP) AS ACCT_DATE,
   j.MACH_NO,
   j.CASINO_MACH_NO,
   j.DEAL_NO,
   j.TICKET_NO,
   j.PLAY_COST,
   j.TRANS_ID,
   j.TRANS_AMT,
   j.PROG_AMT,
   b.LOCKUP_AMOUNT,
   cf.JP_AMOUNT,
   cf.JACKPOT_COUNT,
   cf.TAB_AMT,
   cf.DENOMINATION,
   cf.COINS_BET,
   cf.LINES_BET,
   cf.FORM_NUMB,
   cf.GAME_TYPE_CODE,
   ps.PAYSCALE_NAME,
   (SELECT MIN(COINS_WON) * CAST(cf.DENOMINATION AS MONEY) * cf.COINS_BET FROM dbo.PAYSCALE_TIER WHERE PAYSCALE_NAME = ps.PAYSCALE_NAME AND TIER_WIN_TYPE IN (5,6)) AS MIN_JP_AMOUNT
FROM dbo.JACKPOT j
   JOIN dbo.DEAL_SETUP   ds ON j.DEAL_NO = ds.DEAL_NO
   JOIN dbo.CASINO_FORMS cf ON cf.FORM_NUMB = ds.FORM_NUMB
   JOIN dbo.PAYSCALE     ps ON ps.GAME_TYPE_CODE = cf.GAME_TYPE_CODE
   JOIN dbo.MACH_SETUP   ms ON ms.MACH_NO = j.MACH_NO
   JOIN dbo.BANK          b ON b.BANK_NO = ms.BANK_NO

GO
