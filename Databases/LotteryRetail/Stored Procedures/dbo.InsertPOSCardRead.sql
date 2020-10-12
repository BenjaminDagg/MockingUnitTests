SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure InsertPOSCardRead

Created 11-24-2004 by Terry Watkins

Purpose: Records POS station Card Reads.

Called by: Accounting Application

Parameters:
   @CardAcctNbr   Card Account Number
   @SessionID     Cashier Session ID
   @CreatedBy     Cashier
   @WorkStation   Cashier Workstation Name


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-24-2004
  Initial coding

Terry Watkins 06-15-2005
  Changed size of argument @CardAcctNbr from 16 to 20.

Terry Watkins 10-05-2005     v5.0.8
  Removed insertion into CASINO_TRANS.TICKET_STATUS_ID (column removed).

Terry Watkins 11-04-2009     v7.0.0
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[InsertPOSCardRead]
   @CardAcctNbr  VarChar(20),
   @SessionID    VarChar(40),
   @CreatedBy    VarChar(30),
   @WorkStation  VarChar(32),
   @CardBalance  Money
AS

-- Variable Declarations
DECLARE @CasinoID  Char(6)
DECLARE @AcctDate  DateTime
DECLARE @TimeStamp DateTime
DECLARE @TransID   SmallInt
DECLARE @TransNo   Int

-- Variable Initialization
SET @TimeStamp = GetDate()
SET @TransID = 44

-- Retrieve Casino information.
SELECT @CasinoID = CAS_ID FROM CASINO WHERE SETASDEFAULT = 1

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Test for valid card.
IF NOT EXISTS(SELECT * FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAcctNbr)
   SET @CardAcctNbr = 'INVALID'

-- Insert a record into CASINO_TRANS
INSERT INTO CASINO_TRANS
   (CAS_ID, CARD_ACCT_NO, DEAL_NO, MACH_NO, ROLL_NO, TICKET_NO, DENOM,
    TRANS_AMT, BARCODE_SCAN, TRANS_ID, DTIMESTAMP, ACCT_DATE,
    MODIFIED_BY, COINS_BET, LINES_BET, TIER_LEVEL, GAME_CODE, BALANCE)
VALUES
   (@CasinoID, @CardAcctNbr, 0, '0', 0, 0, 0,
    0, '', @TransID, @TimeStamp, @AcctDate,
    @CreatedBy, 0, 0, 0, 'N/A', @CardBalance)

-- Store the PK of the inserted CASINO_TRANS row.
SET @TransNo = @@IDENTITY

-- Now insert a row into CASHIER_TRANS
INSERT INTO CASHIER_TRANS
   (TRANS_TYPE, TRANS_AMT, TRANS_NO, SESSION_ID, CREATED_BY, CASHIER_STN)
VALUES
   ('CR', 0, @TransNo, @SessionID, @CreatedBy, @WorkStation)
GO
