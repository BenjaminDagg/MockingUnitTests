SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: DailyGeneralLedger user stored procedure.

Created: 2011-05-05 by Aldo Zamora

Purpose: Returns data for the Daily General Ledger file sent to DCLB daily.

Arguments:
   @AccountingDate: DateTime for the resultset

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   2011-05-05
  Initial coding.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[DailyGeneralLedger] @AccountingDate DATETIME

AS

-- Declare Variables.
DECLARE @AgentCommissionsExpense MONEY
DECLARE @AmounntDueFromAgents    MONEY
DECLARE	@BigIntValue             BIGINT
DECLARE @ContractorFees          MONEY
DECLARE @ExpiredVoucherAmount    MONEY
DECLARE @NetRevenue              MONEY
DECLARE @UnClaimedVoucherAmount  MONEY

-- Store summarized data.
SELECT
   @UnClaimedVoucherAmount  = SUM(UnClaimedVoucherAmount),
   @NetRevenue              = SUM(NetRevenue),
   @AgentCommissionsExpense = SUM(AgentCommissionsExpense),
   @AmounntDueFromAgents    = SUM(AmounntDueFromAgents),
   @ContractorFees          = SUM(ContractorFees),
   @ExpiredVoucherAmount    = SUM(ExpiredVoucherAmount)
FROM
   GLInfo
WHERE
   IsProcessed = 0

/*
--------------------------------------------------------------------------------
641 - NET PROCEEDS - ELECTRONIC DC SCRATCHERS
--------------------------------------------------------------------------------
*/
SELECT
   CAST('NEW' AS VARCHAR(3)) AS LineIndicator,
   CAST('DCITVM' AS VARCHAR(6)) AS JournalEntrySourceName,
   CAST('DCITVM' AS VARCHAR) AS JournalEntryCategoryName,
   UPPER(REPLACE(CONVERT(VARCHAR(12), @AccountingDate, 6), ' ', '-')) AS AccountingDate,
   CAST('USD' AS VARCHAR) AS Currency,
   CAST('A' AS VARCHAR) AS TransactionFlag,
   CAST('0420' AS VARCHAR) AS Fund,
   CAST('000' AS VARCHAR) AS TCode,
   CAST('00000' AS VARCHAR) AS [Index],
   CAST('0013' AS VARCHAR) AS Game,
   CAST('641' AS VARCHAR) AS GLClass,
   CAST('3100' AS VARCHAR) AS GLAccount,
   CAST('003' AS VARCHAR) AS GLSubAccount,
   CAST('00' AS VARCHAR) AS ControllerClass,
   CAST('6110' AS VARCHAR) AS ControllerObject,
   CAST('6009' AS VARCHAR) AS AgencyObject,
   CAST('         000' AS VARCHAR(12)) AS DebitAmount,
   STR(CAST((@NetRevenue * 100) AS BIGINT), 12) AS CreditAmount,
   CAST('NET PROCEEDS - ELECTRONIC DC SCRATCHERS' AS VARCHAR(40)) AS JournalDescription

/*
--------------------------------------------------------------------------------
642 - AGENTS COMMISSIONS EXPENSE
--------------------------------------------------------------------------------
*/
UNION SELECT
   CAST('NEW' AS VARCHAR(3)) AS LineIndicator,
   CAST('DCITVM' AS VARCHAR) AS JournalEntrySourceName,
   CAST('DCITVM' AS VARCHAR) AS JournalEntryCategoryName,
   UPPER(REPLACE(CONVERT(VARCHAR(12), @AccountingDate, 6), ' ', '-')) AS AccountingDate,
   CAST('USD' AS VARCHAR) AS Currency,
   CAST('A' AS VARCHAR) AS TransactionFlag,
   CAST('0420' AS VARCHAR) AS Fund,
   CAST('000' AS VARCHAR) AS TCode,
   CAST('00000' AS VARCHAR) AS [Index],
   CAST('0013' AS VARCHAR) AS Game,
   CAST('642' AS VARCHAR) AS GLClass,
   CAST('3500' AS VARCHAR) AS GLAccount,
   CAST('000' AS VARCHAR) AS GLSubAccount,
   CAST('50' AS VARCHAR) AS ControllerClass,
   CAST('0520' AS VARCHAR) AS ControllerObject,
   CAST('5201' AS VARCHAR) AS AgencyObject,
   STR(CAST((@AgentCommissionsExpense * 100) AS BIGINT), 12) AS DebitAmount,
   CAST('         000' AS VARCHAR) AS CreditAmount,
   CAST('AGENTS COMMISSIONS EXPENSE' AS VARCHAR(40)) AS JournalDescription

/*
--------------------------------------------------------------------------------
120 - AMOUNT DUE FROM AGENTS
--------------------------------------------------------------------------------
*/
UNION SELECT
   CAST('NEW' AS VARCHAR(3)) AS LineIndicator,
   CAST('DCITVM' AS VARCHAR) AS JournalEntrySourceName,
   CAST('DCITVM' AS VARCHAR) AS JournalEntryCategoryName,
   UPPER(REPLACE(CONVERT(VARCHAR(12), @AccountingDate, 6), ' ', '-')) AS AccountingDate,
   CAST('USD' AS VARCHAR) AS Currency,
   CAST('A' AS VARCHAR) AS TransactionFlag,
   CAST('0420' AS VARCHAR) AS Fund,
   CAST('000' AS VARCHAR) AS TCode,
   CAST('00000' AS VARCHAR) AS [Index],
   CAST('0013' AS VARCHAR) AS Game,
   CAST('120' AS VARCHAR) AS GLClass,
   CAST('0503' AS VARCHAR) AS GLAccount,
   CAST('003' AS VARCHAR) AS GLSubAccount,
   CAST('00' AS VARCHAR) AS ControllerClass,
   CAST('0000' AS VARCHAR) AS ControllerObject,
   CAST('0000' AS VARCHAR) AS AgencyObject,
   STR(CAST((@AmounntDueFromAgents * 100) AS BIGINT), 12) AS DebitAmount,
   CAST('         000' AS VARCHAR) AS CreditAmount,
   CAST('AMOUNT DUE FROM AGENTS' AS VARCHAR(40)) AS JournalDescription

/*
--------------------------------------------------------------------------------
642 - CONTRACTOR FEES - GAMING CONTRACTOR
--------------------------------------------------------------------------------
*/
UNION SELECT
   CAST('NEW' AS VARCHAR(3)) AS LineIndicator,
   CAST('DCITVM' AS VARCHAR) AS JournalEntrySourceName,
   CAST('DCITVM' AS VARCHAR) AS JournalEntryCategoryName,
   UPPER(REPLACE(CONVERT(VARCHAR(12), @AccountingDate, 6), ' ', '-')) AS AccountingDate,
   CAST('USD' AS VARCHAR) AS Currency,
   CAST('A' AS VARCHAR) AS TransactionFlag,
   CAST('0420' AS VARCHAR) AS Fund,
   CAST('000' AS VARCHAR) AS TCode,
   CAST('00000' AS VARCHAR) AS [Index],
   CAST('0013' AS VARCHAR) AS Game,
   CAST('642' AS VARCHAR) AS GLClass,
   CAST('3500' AS VARCHAR) AS GLAccount,
   CAST('000' AS VARCHAR) AS GLSubAccount,
   CAST('40' AS VARCHAR) AS ControllerClass,
   CAST('0408' AS VARCHAR) AS ControllerObject,
   CAST('4081' AS VARCHAR) AS AgencyObject,
   STR(CAST((@ContractorFees * 100) AS BIGINT), 12) AS DebitAmount,
   CAST('         000' AS VARCHAR) AS CreditAmount,
   CAST('CONTRACTOR FEES - GAMING CONTRACTOR' AS VARCHAR(40)) AS JournalDescription

/*
--------------------------------------------------------------------------------
474 - ACCRUED GAMING CONTRACTOR FEES
--------------------------------------------------------------------------------
*/
UNION SELECT
   CAST('NEW' AS VARCHAR(3)) AS LineIndicator,
   CAST('DCITVM' AS VARCHAR) AS JournalEntrySourceName,
   CAST('DCITVM' AS VARCHAR) AS JournalEntryCategoryName,
   UPPER(REPLACE(CONVERT(VARCHAR(12), @AccountingDate, 6), ' ', '-')) AS AccountingDate,
   CAST('USD' AS VARCHAR) AS Currency,
   CAST('A' AS VARCHAR) AS TransactionFlag,
   CAST('0420' AS VARCHAR) AS Fund,
   CAST('000' AS VARCHAR) AS TCode,
   CAST('00000' AS VARCHAR) AS [Index],
   CAST('0013' AS VARCHAR) AS Game,
   CAST('474' AS VARCHAR) AS GLClass,
   CAST('1230' AS VARCHAR) AS GLAccount,
   CAST('003' AS VARCHAR) AS GLSubAccount,
   CAST('00' AS VARCHAR) AS ControllerClass,
   CAST('0000' AS VARCHAR) AS ControllerObject,
   CAST('0000' AS VARCHAR) AS AgencyObject,
   CAST('         000' AS VARCHAR) AS DebitAmount,
   STR(CAST((@ContractorFees * 100) AS BIGINT), 12) AS CreditAmount,
   CAST('ACCRUED GAMING CONTRACTOR FEES' AS VARCHAR(40)) AS JournalDescription

/*
--------------------------------------------------------------------------------
120 - AMOUNT DUE FROM AGENTS
--------------------------------------------------------------------------------
*/
UNION SELECT
   CAST('NEW' AS VARCHAR(3)) AS LineIndicator,
   CAST('DCITVM' AS VARCHAR) AS JournalEntrySourceName,
   CAST('DCITVM' AS VARCHAR) AS JournalEntryCategoryName,
   UPPER(REPLACE(CONVERT(VARCHAR(12), @AccountingDate, 6), ' ', '-')) AS AccountingDate,
   CAST('USD' AS VARCHAR) AS Currency,
   CAST('A' AS VARCHAR) AS TransactionFlag,
   CAST('0420' AS VARCHAR) AS Fund,
   CAST('000' AS VARCHAR) AS TCode,
   CAST('00000' AS VARCHAR) AS [Index],
   CAST('0013' AS VARCHAR) AS Game,
   CAST('120' AS VARCHAR) AS GLClass,
   CAST('0503' AS VARCHAR) AS GLAccount,
   CAST('003' AS VARCHAR) AS GLSubAccount,
   CAST('00' AS VARCHAR) AS ControllerClass,
   CAST('0000' AS VARCHAR) AS ControllerObject,
   CAST('0000' AS VARCHAR) AS AgencyObject,
   STR(CAST((@UnClaimedVoucherAmount * 100) AS BIGINT), 12) AS DebitAmount,
   CAST('         000' AS VARCHAR) AS CreditAmount,
   CAST('AMOUNT DUE FROM AGENTS' AS VARCHAR(40)) AS JournalDescription

/*
--------------------------------------------------------------------------------
474 - JACKPOTS AND CREDIT SLIPS PAYABLE
--------------------------------------------------------------------------------
*/
UNION SELECT
   CAST('NEW' AS VARCHAR(3)) AS LineIndicator,
   CAST('DCITVM' AS VARCHAR) AS JournalEntrySourceName,
   CAST('DCITVM' AS VARCHAR) AS JournalEntryCategoryName,
   UPPER(REPLACE(CONVERT(VARCHAR(12), @AccountingDate, 6), ' ', '-')) AS AccountingDate,
   CAST('USD' AS VARCHAR) AS Currency,
   CAST('A' AS VARCHAR) AS TransactionFlag,
   CAST('0420' AS VARCHAR) AS Fund,
   CAST('000' AS VARCHAR) AS TCode,
   CAST('00000' AS VARCHAR) AS [Index],
   CAST('0013' AS VARCHAR) AS Game,
   CAST('474' AS VARCHAR) AS GLClass,
   CAST('1228' AS VARCHAR) AS GLAccount,
   CAST('003' AS VARCHAR) AS GLSubAccount,
   CAST('00' AS VARCHAR) AS ControllerClass,
   CAST('0000' AS VARCHAR) AS ControllerObject,
   CAST('0000' AS VARCHAR) AS AgencyObject,
   CAST('         000' AS VARCHAR) AS DebitAmount,
   STR(CAST((@UnClaimedVoucherAmount * 100) AS BIGINT), 12) AS CreditAmount,
   CAST('JACKPOTS AND CREDIT SLIPS PAYABLE' AS VARCHAR(40)) AS JournalDescription
   
/*
--------------------------------------------------------------------------------
474 - JACKPOTS AND CREDIT SLIPS PAYABLE
--------------------------------------------------------------------------------
*/
UNION SELECT
   CAST('NEW' AS VARCHAR(3)) AS LineIndicator,
   CAST('DCITVM' AS VARCHAR) AS JournalEntrySourceName,
   CAST('DCITVM' AS VARCHAR) AS JournalEntryCategoryName,
   UPPER(REPLACE(CONVERT(VARCHAR(12), @AccountingDate, 6), ' ', '-')) AS AccountingDate,
   CAST('USD' AS VARCHAR) AS Currency,
   CAST('A' AS VARCHAR) AS TransactionFlag,
   CAST('0420' AS VARCHAR) AS Fund,
   CAST('000' AS VARCHAR) AS TCode,
   CAST('00000' AS VARCHAR) AS [Index],
   CAST('0013' AS VARCHAR) AS Game,
   CAST('474' AS VARCHAR) AS GLClass,
   CAST('1228' AS VARCHAR) AS GLAccount,
   CAST('003' AS VARCHAR) AS GLSubAccount,
   CAST('00' AS VARCHAR) AS ControllerClass,
   CAST('0000' AS VARCHAR) AS ControllerObject,
   CAST('0000' AS VARCHAR) AS AgencyObject,
   STR(CAST((@ExpiredVoucherAmount * 100) AS BIGINT), 12) AS DebitAmount,
   CAST('         000' AS VARCHAR) AS CreditAmount,
   CAST('JACKPOTS AND CREDIT SLIPS PAYABLE' AS VARCHAR(40)) AS JournalDescription
   
/*
--------------------------------------------------------------------------------
641 - LAPSED JACKPOTS AND CREDIT SLIPS
--------------------------------------------------------------------------------
*/
UNION SELECT
   CAST('NEW' AS VARCHAR(3)) AS LineIndicator,
   CAST('DCITVM' AS VARCHAR) AS JournalEntrySourceName,
   CAST('DCITVM' AS VARCHAR) AS JournalEntryCategoryName,
   UPPER(REPLACE(CONVERT(VARCHAR(12), @AccountingDate, 6), ' ', '-')) AS AccountingDate,
   CAST('USD' AS VARCHAR) AS Currency,
   CAST('A' AS VARCHAR) AS TransactionFlag,
   CAST('0420' AS VARCHAR) AS Fund,
   CAST('000' AS VARCHAR) AS TCode,
   CAST('00000' AS VARCHAR) AS [Index],
   CAST('0013' AS VARCHAR) AS Game,
   CAST('641' AS VARCHAR) AS GLClass,
   CAST('3100' AS VARCHAR) AS GLAccount,
   CAST('003' AS VARCHAR) AS GLSubAccount,
   CAST('00' AS VARCHAR) AS ControllerClass,
   CAST('6110' AS VARCHAR) AS controllerObject,
   CAST('6009' AS VARCHAR) AS AgencyObject,
   CAST('         000' AS VARCHAR) AS DebitAmount,
   STR(CAST((@ExpiredVoucherAmount * 100) AS BIGINT), 12) AS CreditAmount,
   CAST('LAPSED JACKPOTS AND CREDIT SLIPS' AS VARCHAR(40)) AS JournalDescription
GO
