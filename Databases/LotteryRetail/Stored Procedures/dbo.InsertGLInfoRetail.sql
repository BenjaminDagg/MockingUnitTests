SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: InsertGLInfoRetail user stored procedure.

Created: 2011-07-26 by Aldo Zamora

Purpose: Summarizes revenue data and inserts a row into the GL_INFO table.

Arguments:
   @AccountingDate     Date for the resultset

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   2011-07-26     v2.0.4
  Initial coding.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[InsertGLInfoRetail] @AccountingDate DATETIME

AS

-- Declare Variables.
DECLARE @AgentCommissionsExpense  MONEY
DECLARE @AmounntDueFromAgents     MONEY
DECLARE @BigIntValue              BIGINT
DECLARE @ContractorFees           MONEY
DECLARE @DateTransferred          DATETIME
DECLARE @EventLogDescription      VARCHAR(256)
DECLARE @ExpiredVoucherAmount     MONEY
DECLARE @GLInfoID                 INT
DECLARE @LinkedServerSP           VARCHAR(64)
DECLARE @LocationID               INT
DECLARE @NetRevenue               MONEY
DECLARE @RetailRevenuePercent     DECIMAL(4,2)
DECLARE @SPReturnValue            INT
DECLARE @StoredProcedure          VARCHAR(64)
DECLARE @SQLErrorDescription      VARCHAR(256)
DECLARE @SQLErrorID               INT
DECLARE @UnClaimedVoucherAmount   MONEY
DECLARE @VoucherExpirationDays    INTEGER

-- Initialize Variables...
SET @DateTransferred = GETDATE()

-- Get and set the LOCATION_ID and RETAIL_REV_SHARE.
SELECT
   @LocationID = LOCATION_ID,
   @RetailRevenuePercent = RETAIL_REV_SHARE
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get and set the VOUCHER_EXPIRATION_DAYS value.
SELECT @VoucherExpirationDays = VALUE1
FROM CASINO_SYSTEM_PARAMETERS
WHERE PAR_NAME = 'VOUCHER_EXPIRATION_DAYS'

-- Get and set CENTRAL_SERVER_LINK value.
SELECT @LinkedServerSP = VALUE1 + '.InsertGLInfoCentral'
FROM dbo.CASINO_SYSTEM_PARAMETERS
WHERE PAR_NAME = 'CENTRAL_SERVER_LINK'

-- Store summarized Unclaimed Voucher Amount.
SELECT @UnClaimedVoucherAmount = ISNULL(SUM(VOUCHER_AMOUNT), 000)
FROM VOUCHER
WHERE
   UCV_TRANSFERRED = 1 AND
   dbo.ufnGetAcctDateFromDate(UCV_TRANSFER_DATE) = @AccountingDate

-- Store summarized Net Revenue value.
SELECT
   @NetRevenue = ISNULL(SUM(AMOUNT_PLAYED - AMOUNT_WON - AMOUNT_JACKPOT), 000) - ISNULL(@UnClaimedVoucherAmount, 000)
FROM MACHINE_STATS
WHERE ACCT_DATE = @AccountingDate

-- Calculate and set Agent Commissions Expense.
SET @AgentCommissionsExpense = @NetRevenue * @RetailRevenuePercent / 100

-- Calculate and set Amounnt Due From Agents.
SET @AmounntDueFromAgents    = @NetRevenue - @AgentCommissionsExpense

-- Calculate and set Contractor Fees.
SET @ContractorFees          = @NetRevenue * 0.4

-- Store summarized Expired Voucher Amount.
SELECT @ExpiredVoucherAmount = ISNULL(SUM(VOUCHER_AMOUNT), 000)
FROM VOUCHER
WHERE
   dbo.ufnGetAcctDateFromDate(CREATE_DATE) = DATEADD(dd, -@VoucherExpirationDays, @AccountingDate) AND
   REDEEMED_STATE = 0

-- Does the row exist?
IF NOT EXISTS (SELECT GL_INFO_ID FROM GL_INFO WHERE ACCT_DATE = @AccountingDate)
   -- No, Insert it...
   BEGIN TRY
      INSERT INTO GL_INFO
         (LOCATION_ID, ACCT_DATE, NET_REVENUE, AGENT_COMMISSIONS_EXPENSE, AMOUNT_DUE_FROM_AGENTS,
          CONTRACTOR_FEES, UNCLAIMED_VOUCHER_AMOUNT, EXPIRED_VOUCHER_AMOUNT)
      VALUES
          (@LocationID, @AccountingDate, @NetRevenue, @AgentCommissionsExpense, @AmounntDueFromAgents,
           @ContractorFees, @UnClaimedVoucherAmount, @ExpiredVoucherAmount)
   END TRY
   
   BEGIN CATCH 
      -- Retrieve error information.
      SET @SQLErrorID          = ERROR_NUMBER()
      SET @SQLErrorDescription = ERROR_MESSAGE()
      SET @StoredProcedure     = ERROR_PROCEDURE() 
      SET @EventLogDescription = @SQLErrorID + '-' + @SQLErrorDescription
      
      -- Insert Error into the CASINO_EVENT_LOG
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         ('SP', @StoredProcedure, @EventLogDescription, 0, 0)
   END CATCH
   
-- Insert GLInfo into Central server database that have not been transferred...
DECLARE TransferGLInfo CURSOR FOR
   SELECT
      GL_INFO_ID,
      LOCATION_ID,
      ACCT_DATE,
      NET_REVENUE,
      AGENT_COMMISSIONS_EXPENSE,
      AMOUNT_DUE_FROM_AGENTS,
      CONTRACTOR_FEES,
      UNCLAIMED_VOUCHER_AMOUNT,
      EXPIRED_VOUCHER_AMOUNT
   FROM GL_INFO
   WHERE TRANSFERRED = 0

-- Open the cursor.
OPEN TransferGLInfo

-- Get the first row of data.
FETCH FROM TransferGLInfo INTO
   @GLInfoID, @LocationID, @AccountingDate, @NetRevenue, @AgentCommissionsExpense,
   @AmounntDueFromAgents, @ContractorFees, @UnClaimedVoucherAmount, @ExpiredVoucherAmount
   
WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- FETCH was successful, so insert a row into the GLInfo table on Central server...
      BEGIN TRY
         EXECUTE @SPReturnValue = @LinkedServerSP
            @GLInfoID                = @GLInfoID,
            @LocationID              = @LocationID,
            @DateInserted            = @DateTransferred,
            @AccountingDate          = @AccountingDate,
            @NetRevenue              = @NetRevenue,
            @AgentCommissionsExpense = @AgentCommissionsExpense,
            @AmounntDueFromAgents    = @AmounntDueFromAgents,
            @ContractorFees          = @ContractorFees,
            @UnClaimedVoucherAmount  = @UnClaimedVoucherAmount,
            @ExpiredVoucherAmount    = @ExpiredVoucherAmount
         
         -- Set transfer flag to True and insert transfer date.
         IF @SPReturnValue IN (0,1)
            BEGIN
               UPDATE GL_INFO
               SET TRANSFERRED = 1, DATE_TRANSFERRED = @DateTransferred
               WHERE GL_INFO_ID = @GLInfoID
            END
      END TRY
      
      BEGIN CATCH
         -- Retrieve error information.
         SET @SQLErrorID          = ERROR_NUMBER()
         SET @SQLErrorDescription = ERROR_MESSAGE()
         SET @StoredProcedure     = ERROR_PROCEDURE() 
         SET @EventLogDescription = @SQLErrorID + '-' + @SQLErrorDescription
         
         -- Insert Error into the CASINO_EVENT_LOG
         INSERT INTO CASINO_EVENT_LOG
            (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
         VALUES
            ('SP', @StoredProcedure, @EventLogDescription, 0, 0)
      END CATCH
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM TransferGLInfo INTO
         @GLInfoID, @LocationID, @AccountingDate, @NetRevenue, @AgentCommissionsExpense,
         @AmounntDueFromAgents, @ContractorFees, @UnClaimedVoucherAmount, @ExpiredVoucherAmount
   END
   
-- Close and Deallocate the Cursor...
CLOSE TransferGLInfo
DEALLOCATE TransferGLInfo
GO
