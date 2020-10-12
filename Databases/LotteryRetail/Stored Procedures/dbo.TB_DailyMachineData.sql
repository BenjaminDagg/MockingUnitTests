SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: TB_DailyMachineData user stored procedure.

  Created: 04-20-2006 by Terry Watkins  

  Purpose: Retrieves Daily Machine Summary data for the used to create a
           datafile.  Created to support a request from the Thunderbird
           Shawnee Tribe casino.

Arguments: @AcctDate - The Accounting Date for the required data.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 04-20-2006     v5.0.3
  Initial Coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[TB_DailyMachineData] @AcctDate DateTime
AS

SELECT
   ms.CASINO_MACH_NO                                        AS SerialID,
   'B' + CAST(mset.BANK_NO AS VARCHAR)                      AS Location,
   gs.GAME_DESC                                             AS GameName,
   ms.TICKET_IN_AMOUNT                                      AS TicketInAmount,
   ms.AMOUNT_IN                                             AS BillInAmount,
   ms.AMOUNT_IN + ms.TICKET_IN_AMOUNT                       AS BillAcceptorAmount,
   ms.TICKET_OUT_AMOUNT                                     AS TicketOutAmount,
   CASE WHEN ms.DEAL_NO = 0 THEN 0 ELSE ms.PLAY_COUNT END   AS PlayCount,
   CASE WHEN ms.DEAL_NO = 0 THEN 0 ELSE b.BANK_NO END       AS BankNbr,
   CASE WHEN ms.DEAL_NO = 0 THEN 0
        ELSE CAST(ds.DENOMINATION * 100 AS INT) END         AS Denom,
   'PT' + ISNULL(cf.FORM_NUMB, '0')                         AS PaytableCode,
   CASE WHEN ms.DEAL_NO = 0 THEN 0 ELSE cf.HOLD_PERCENT END AS TheoreticalHold,
   CASE WHEN ms.DEAL_NO = 0 THEN 0 ELSE ms.AMOUNT_PLAYED END AS AmountPlayed,
   CASE WHEN ms.DEAL_NO = 0 THEN 0
        ELSE ms.AMOUNT_WON + ms.AMOUNT_FORFEITED +
             ms.AMOUNT_JACKPOT END                          AS AmountWon,
   ms.WIN_COUNT + ms.JACKPOT_COUNT + ms.FORFEIT_COUNT       AS WinCount,
   ms.LOSS_COUNT                                            AS LoseCount,
   ms.PLAY_COUNT                                            AS PlayCount
FROM MACHINE_STATS ms
   JOIN MACH_SETUP mset ON mset.MACH_NO = ms.MACH_NO
   JOIN GAME_SETUP   gs ON gs.GAME_CODE = ms.GAME_CODE
   JOIN DEAL_SETUP   ds ON ds.DEAL_NO = ms.DEAL_NO
   LEFT OUTER JOIN CASINO_FORMS cf ON cf.FORM_NUMB = ds.FORM_NUMB
   JOIN BANK b ON b.BANK_NO = mset.BANK_NO
WHERE ACCT_DATE = @AcctDate
ORDER BY ms.CASINO_MACH_NO, ms.GAME_CODE, ds.COINS_BET, ds.LINES_BET
GO
