SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: InsertGLInfoCentral user stored procedure.

Created: 2011-07-26 by Aldo Zamora

Purpose: Inserts a GL data row

Returns:
   0 = Successful INSERT.
   1 = Row already exist.
   2 = INSERT failed.

Arguments:
   @GLInfoID                 Retail location Identity
   @LocationID               Location ID
   @TransferredDate          Date row was inserted
   @AccountingDate           Accounting date
   @NetRevenue               Location net revenue
   @AgentCommissionsExpense  Location commissions expense
   @AmounntDueFromAgents     Amount due from location
   @ContractorFees           Contractor fees
   @UnClaimedVoucherAmount   Location's unclaimed vouchers
   @ExpiredVoucherAmount     Location's expired vouchers
   
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   2011-07-26     2.0.4
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[InsertGLInfoCentral]
   @GLInfoID                INT,
   @LocationID              INT,
   @DateInserted            DATETIME,
   @AccountingDate          DATETIME,
   @NetRevenue              MONEY,
   @AgentCommissionsExpense MONEY,
   @AmounntDueFromAgents    MONEY,
   @ContractorFees          MONEY,
   @UnClaimedVoucherAmount  MONEY,
   @ExpiredVoucherAmount    MONEY
   
AS

-- Declare Variables
DECLARE @ReturnValue         INT
DECLARE @StoredProcedure     VARCHAR(64)
DECLARE @SQLErrorDescription VARCHAR(256)
DECLARE @SQLErrorID          INT

-- Initialize Variables
SET @ReturnValue = 0

-- Does a matching row exist in the Retail database GLInfo table?
IF NOT EXISTS (SELECT * FROM GLInfo WHERE GLInfoID = @GLInfoID AND LocationID = @LocationID AND AccountingDate = @AccountingDate)
   -- No, insert row...
   BEGIN TRY
      INSERT INTO GLInfo
         (GLInfoID, LocationID, DateInserted, AccountingDate, NetRevenue, AgentCommissionsExpense,
          AmounntDueFromAgents, ContractorFees, UnClaimedVoucherAmount, ExpiredVoucherAmount)
      VALUES
          (@GLInfoID, @LocationID, @DateInserted, @AccountingDate, @NetRevenue, @AgentCommissionsExpense,
           @AmounntDueFromAgents, @ContractorFees, @UnClaimedVoucherAmount, @ExpiredVoucherAmount)
   END TRY
   
   BEGIN CATCH
      -- Retrieve error information.
      SET @SQLErrorID          = ERROR_NUMBER()
      SET @SQLErrorDescription = ERROR_MESSAGE()
      SET @StoredProcedure     = ERROR_PROCEDURE() 
      
      -- Insert Error into the Casino_Event_Log
      INSERT INTO EventLog
         (EventCode, EventSource, EventDescription, ErrorNumber)
      VALUES
         ('SP', @StoredProcedure, @SQLErrorDescription, @SQLErrorID)   
      
      -- If the error value is not zero, set the return value to 2.
      IF (@SQLErrorID <> 0)
         SET @ReturnValue = 2
            
   END CATCH
   
ELSE
   -- Row already exists, so set the return value to 1.
   BEGIN
      SET @ReturnValue = 1
   END

-- Set the Return value.
RETURN @ReturnValue
GO
