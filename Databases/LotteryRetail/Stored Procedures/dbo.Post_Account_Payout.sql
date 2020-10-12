SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: Post_Account_Payout user stored procedure.

  Created: 04/07/2002 by Terry Watkins

  Purpose: Properly updates tables when a customer receives full or partial
           payment of remaining smartcard balance.

Arguments: @Card_Account: Card Account Number (CARD_ACCT.Card_Acct_No and CASINO_TRANS.CARD_ACCT_NO)
           @Casino_ID:    Casino Identifier
           @Mod_User:     User that initiated payout
           @Auth_User:    User that authorized the payout (when required)
           @Payment_Amt:  Amount to deduct from the current balance
           @Session_ID:   Cashiers current session id
           @Work_Station: Cashiers workstation
           @Payment_Type: Payment Type (A=Automatic, M=Manual)
           @Trans_Nbr:    Output argument will contain the CASHIER_TRANS_ID from the
                          insert into CASHIER_TRANS on success or -1 on failure.
                          This value prints on cashier receipts as the Ref Nbr.


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 05-03-2002
  Updated to work with multiple database schema changes.
  The CASINO_TRANS.TRANS_NO column changed to in integer identity column so it
  is no longer necessary to create a new value for insertion into the table.

Terry Watkins 05-24-2002
  Modified the procedure so that the output parameter @Trans_Nbr will contain
  the value of the primary key value for the row inserted into the CASHIER_TRANS
  table.

Terry Watkins 06-03-2002
  Added argument @Auth_User to be used when a machine lockup occurs (winning
  amount exceeds specified amount) requiring a supervisor level payout approval.
  Also set MODIFIED_DATE = @Current_Date in CARD_ACCT UPDATE.

Terry Watkins 01-23-2003
  Added Code to insert accounting date into new ACCT_DATE column in CASINO_TRANS.

Terry Watkins 10-25-2004
  Added insert of TransID into CASINO_TRANS.

Terry Watkins 06-15-2005     v4.1.4
  Changed datatype of @Card_Account from Char(16) to VarChar(20).

Terry Watkins 02-01-2007     v5.0.8
  Updates new CASHIER_TRANS.AUTH_USER column.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Post_Account_Payout]
   @Card_Account VarChar(20),
   @Casino_ID    Char(6),
   @Mod_User     Varchar(10),
   @Auth_User    Varchar(10),
   @Payment_Amt  Money,
   @Session_ID   Varchar(40),
   @Work_Station VarChar(32),
   @Payment_Type Char(1),
   @Trans_Nbr    Int   OUTPUT
AS

-- Local variable declarations...
DECLARE @CardAcctSeqNum   Integer
DECLARE @CashierTransID   Integer
DECLARE @CasinoTransID    Integer
DECLARE @ErrorNbr         Integer
DECLARE @OffsetMinutes    Integer

DECLARE @TransID          SmallInt

DECLARE @AccountingDate   DateTime
DECLARE @CurrentDate      DateTime
DECLARE @ToDate           Datetime
DECLARE @ToTime           DateTime

DECLARE @CurrentBalance   Money
DECLARE @NewBalance       Money

DECLARE @PORflag          Char(30)            -- Payout Override Required flag

DECLARE @CardAcctStatus   VarChar(1)
DECLARE @ErrorText        VarChar(1024)
DECLARE @ErrorSource      VarChar(64)
DECLARE @DescText         VarChar(1024)


-- Store the current server date/time and initialize return code (@ErrorNbr) to 0.
SET @CurrentDate = GetDate()
SET @ErrorNbr = 0
SET @TransID = 24

-- Calc the accounting date based upon the current DateTime and the accounting offset...
SELECT @ToTime = TO_TIME FROM CASINO WHERE SETASDEFAULT = 1
SET @ToDate = CONVERT(DATETIME, CONVERT(CHAR(10), @ToTime, 101))
SET @OffsetMinutes = DATEDIFF(Minute, @ToDate, @ToTime)
SET @AccountingDate = CONVERT(CHAR(10), DATEADD(Minute, -@OffsetMinutes, @CurrentDate), 101)

-- Initialize output arg @Trans_Nbr to -1.  It will be reset to the transaction number
SET @Trans_Nbr = -1

-- Get the current balance for this SmartCard.
SELECT @CurrentBalance = BALANCE, @CardAcctStatus = STATUS, @CardAcctSeqNum = SEQ_NUM FROM CARD_ACCT WHERE CARD_ACCT_NO=@Card_Account
SET @ErrorNbr = @@ERROR

-- Check for error...
IF (@ErrorNbr <> 0)
   -- There was an error, set the error text...
   SET @ErrorText = 'SELECT Failed retrieving from CARD_ACCT, CARD_ACCT_NO=' + @Card_Account

IF (@ErrorNbr = 0)
   -- No error, so check that the the payment is not greater than the current balance.
   BEGIN
      IF (@Payment_Amt > @CurrentBalance)
         BEGIN
            SET @ErrorNbr = -1
            SET @ErrorText = 'Payment Amount greater than remaining balance in CARD_ACCT, CARD_ACCT_NO=' +
                             @Card_Account
         END
   END

IF (@ErrorNbr = 0)
   -- Passed initial error checking, now attempt database inserts and updates...
   BEGIN
      -- Calculate the new balance.
      SET @NewBalance = @CurrentBalance - @Payment_Amt

      -- Begin a Transaction.
      BEGIN TRANSACTION

      -- Insert a new transaction row into the Casino_Trans table...
      IF (@ErrorNbr = 0)
         BEGIN
            -- Perform the Insert.
            INSERT INTO CASINO_TRANS
                (CAS_ID, DEAL_NO, ROLL_NO, TICKET_NO, TRANS_ID, BALANCE, CARD_ACCT_NO,
                 DTIMESTAMP, ACCT_DATE, MODIFIED_BY, TRANS_AMT, MACH_NO)
             VALUES
                (@Casino_ID, 0, 0, 0, @TransID, @NewBalance, @Card_Account,
                 @CurrentDate, @AccountingDate, @Mod_User, @Payment_Amt, '0')
            
            -- Store resulting error code.
            SET @ErrorNbr = @@ERROR
            
            IF (@ErrorNbr <> 0)
               BEGIN
                  SET @ErrorText = 'Error on INSERT INTO CASINO_TRANS, attempted to insert CARD_ACCT_NO=' + CONVERT(VarChar(10), @Card_Account) + '. Error: ' + CONVERT(VarChar(10),@ErrorNbr)
               END
            ELSE
               BEGIN
                  SET @CasinoTransID = @@IDENTITY
               END
         END
      
      -- Now, update the current balance in the Card_Acct table...
      IF (@ErrorNbr = 0)
         BEGIN
            UPDATE CARD_ACCT SET
               BALANCE       = @NewBalance,
               STATUS        = '1',
               SEQ_NUM       = NULL,
               MODIFIED_DATE = @CurrentDate
            WHERE CARD_ACCT_NO = @Card_Account
            
            -- Store resulting error code.
            SET @ErrorNbr = @@ERROR
            
            -- Was there an error?
            IF (@ErrorNbr <> 0)
               -- Yes, so set the error text.
               BEGIN
                  SET @ErrorText = 'Error on UPDATE CARD_ACCT, attempted to update CARD_ACCT_NO=' +
                                   @Card_Account + '. Error: ' + CONVERT(VarChar(10), @ErrorNbr)
               END
         END
      
      -- Now, we'll insert a row into CASHIER_TRANS
      IF (@ErrorNbr = 0)
         BEGIN
            INSERT INTO CASHIER_TRANS
               (TRANS_TYPE, TRANS_AMT, TRANS_NO, SESSION_ID, CREATED_BY,
                AUTH_USER, CREATE_DATE, CASHIER_STN, PAYMENT_TYPE)
            VALUES
               ('P', @Payment_Amt, @CasinoTransID, @Session_ID, @Mod_User,
                @Auth_User, @CurrentDate, @Work_Station, @Payment_Type)
            
            -- Store resulting error code.
            SET @ErrorNbr = @@ERROR
            
            IF (@ErrorNbr <> 0)
               BEGIN
                  SET @ErrorText = 'Error on INSERT INTO CASHIER_TRANS, attempted to insert Trans_No=' +
                     CONVERT(VarChar(10), @CasinoTransID) + '. Error: ' + CONVERT(VarChar(10), @ErrorNbr)
               END
            ELSE
               BEGIN
                  SET @CashierTransID = @@IDENTITY
               END
         END
      
      -- Now, we'll insert a row into CASINO_EVENT_LOG if this payment required supervisor authorization.
      /*
      If paying a lockup amount payout, and if authorization is required, then a row is inserted into the
      CASINO_EVENT_LOG with an EVENT_CODE of 'PO'.  The value inserted into the ID_VALUE column will be the
      CASINO_TRANS.TRANS_NO of the winning transaction (Jackpot or Winner >= the lockup amount).  The value
      inserted into the CREATED_BY column will be the user id of the authorizing user.
      */
      IF (@ErrorNbr = 0) AND (@CardAcctStatus = '2')
         BEGIN
            SELECT @PORflag = VALUE1 FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'PAY_OVERRIDE_REQUIRED'
            IF (@@ROWCOUNT > 0)
               BEGIN
                  SET @PORflag = RTRIM(@PORflag)
                  IF (@PORflag <> 'False' And @PORflag <> '0' And @PORflag <> 'No')
                     BEGIN
                        SET @DescText = 'Payout Override. Payout Amount of ' + CONVERT(VarChar(16), @Payment_Amt) + 
                           '. Initiated by ' + @Mod_User + '. Authorized by ' + @Auth_User +
                           '. CASINO_TRANS.TRANS_NO = ' + CONVERT(VarChar(10), @CasinoTransID) + 
                           '. CASHIER_TRANS.CASHIER_TRANS_ID = ' + CONVERT(VarChar(10), @CashierTransID)
                        
                        INSERT INTO CASINO_EVENT_LOG
                           (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, EVENT_DATE_TIME, ID_VALUE, CREATED_BY)
                        VALUES
                           ('PO', 'Procedure Post_Account_Payout', @DescText, @CurrentDate, @CardAcctSeqNum, @Auth_User)
                        
                        -- Store resulting error code.
                        SET @ErrorNbr = @@ERROR
                        IF (@ErrorNbr <> 0)
                          BEGIN
                             SET @ErrorText = 'Error on INSERT INTO CASINO_EVENT_LOG, attempted to insert Trans_No=' + 
                                CONVERT(VarChar(10), @CasinoTransID) + '. Error: ' + CONVERT(VarChar(10), @ErrorNbr)
                          END
                     END
               END
         END

      -- Commit or Rollback changes
      IF (@ErrorNbr = 0)
         BEGIN
            SET @Trans_Nbr = @CashierTransID
            COMMIT
         END
      ELSE
         BEGIN
            ROLLBACK
         END
   END
   
-- Now write to the Event Log table if necessary...
-- Event_Code will be FP (Failed Payout).
IF (@ErrorNbr <> 0)
   BEGIN
      SET @ErrorSource = 'Procedure Post_Account_Payout - UserID ' + 
         CONVERT(VarChar(10), @Mod_User) + ' at Workstation ' + RTRIM(CONVERT(Char(32), @Work_Station))
      
      INSERT INTO CASINO_EVENT_LOG (EVENT_CODE, EVENT_SOURCE, EVENT_DESC) VALUES ('FP', @ErrorSource, @ErrorText)
   END

-- Return @ErrorNbr
Return @ErrorNbr
GO
