SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure Clear_Account_Balances

Created: 06-10-2002 by Norm Symonds

 Purpose: Clears non-zero Smart Card Balances and Creates a type 'Z' transaction
          in CASINO_TRANS to record the action of clearing the Account balance.

 Notes: - Uses a cursor called Accounts_to_Clear to get the set of all accounts
          to be cleared.

        - The criteria for clearing an account is that it have a non-zero
          balance account with an account balance less than the maximum allowed
          to be cleared.

        - The stored procedure then creates a TRANS_ID 25 (TRANS_TYPE 'Z')
          CASINO_TRANS record for each qualifying account and also updates
          the CARD_ACCT table, setting the BALANCE field to zero.

        - A record of the actions taken is inserted into the CASINO_EVENT_LOG
          table with an event code of 'CB' (Cleared Balances)

Arguments:
   @Max_Balance:  Maximum Card Account Balance that should be cleared...allows
                  Casinos to clear the small accounts while still carrying
                  larger balances

Change Log:

Changed By    Date          DB Version
  Change Description
--------------------------------------------------------------------------------
Norm Symonds  06-10-2002
  Initial Coding

Terry Watkins 11-10-2003
  Added logic to clear SESSION_DATE and reset MACH_NO to '0' on the CARD_ACCT
  table where the MODIFIED_DATE has not changed in the last 24 hours.
  Accounts that are currently in play are not cleared.

Terry Watkins 10-25-2004    v4.0.0
  Added insert of TRANS_ID into CASINO_TRANS.

Terry Watkins 03-10-2005    v4.0.1
  Added logic to check the CASINO_SYSTEM_PARAMETERS table for retention days and
  will not clear accounts until there has been no activity for more than the
  specified number of days.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Clear_Account_Balances] @Max_Balance Money
AS

-- Local variable declarations...
DECLARE @ErrorNbr              AS Int
DECLARE @Nbr_Accounts_to_Clear AS Int
DECLARE @Nbr_Accounts_Cleared  AS Int
DECLARE @RetentionDays         AS Int
DECLARE @ToMinutesOffset       AS Integer


DECLARE @Current_Balance       AS Money
DECLARE @New_Balance           AS Money
DECLARE @Cleared_Amt           AS Money
DECLARE @Tot_Amount_Cleared    AS Money

DECLARE @Casino_ID             AS Char(6)

DECLARE @CurrentAcctDate       AS SmallDateTime

DECLARE @CurrentDate           AS DateTime
DECLARE @RetentionDate         AS DateTime
DECLARE @ToTime                AS DateTime
DECLARE @ToDate                AS DateTime

DECLARE @CA_Status             AS VarChar(1)
DECLARE @Card_Account          AS VarChar(20)
DECLARE @Event_Text            AS VarChar(1024)
DECLARE @Event_Source          AS VarChar(64)
DECLARE @Desc_Text             AS VarChar(1024)

-- Store the current server date and time.
SET @CurrentDate = GetDate()

-- Clear Machine Number and Session Date values on the CARD_ACCT table
-- where there has been no activity for more than 1 day.
UPDATE CARD_ACCT SET SESSION_DATE = NULL, MACH_NO = '0'
WHERE 
   MACH_NO <> '0' AND
   DATEDIFF(Hour, MODIFIED_DATE, @CurrentDate) >= 24

-- Retrieve retention days from Casino_System_Parameters.
SELECT @RetentionDays = CAST(ISNULL(VALUE1, '0') AS INT)
FROM CASINO_SYSTEM_PARAMETERS
WHERE PAR_NAME = 'ACCT_RETENTION_DAYS'

-- Is the value of retention days greater than zero?
IF (@RetentionDays > 0)
   -- Yes, so subtract that number of days from the current DateTime.
   SET @RetentionDate = @CurrentDate - @RetentionDays
ELSE
   -- No so use the current DateTime value.
   SET @RetentionDate = @CurrentDate


-- Declare the Accounts_to_Clear Cursor
DECLARE Accounts_to_Clear  CURSOR FOR
   SELECT CARD_ACCT_NO, BALANCE, STATUS
   FROM CARD_ACCT
   WHERE BALANCE <> 0                   AND
         BALANCE <= @Max_Balance        AND
         SESSION_DATE IS NULL           AND
         MODIFIED_DATE < @RetentionDate

-- Initialize return code (@ErrorNbr) to 0 and set the Event Source text...
SET @ErrorNbr = 0
SET @Event_Source = 'Procedure Clear_Account_Balances ' 

-- Initialize Number of Accounts Cleared and Amount Cleared
SET @Nbr_Accounts_Cleared = 0
SET @Tot_Amount_Cleared = 0

SELECT @Casino_ID = CAS_ID, @ToTime = TO_TIME  FROM CASINO WHERE SETASDEFAULT = 1;

-- Get Current Accounting Date based on Offset
SET @ToDate = CONVERT(DATETIME, CONVERT(CHAR(10), @ToTime, 101))
SET @ToMinutesOffset = DATEDIFF(minute, @ToDate, @ToTime)
SET @CurrentAcctDate = CONVERT(Char(10), DATEADD(minute, -@ToMinutesOffset, GetDate()), 101)

-- Get the current balance for this SmartCard.
SELECT @Nbr_Accounts_to_Clear = COUNT(*) FROM CARD_ACCT 
WHERE
   BALANCE <> 0                   AND
   BALANCE <= @Max_Balance        AND
   SESSION_DATE IS NULL           AND
   MODIFIED_DATE < @RetentionDate

-- Are there accounts to clear?
IF @Nbr_Accounts_to_Clear > 0 
   BEGIN
      -- Yes, so open the Cursor which will sequentially process the Card Accounts.
      OPEN Accounts_to_Clear
      
      -- Get the information for the first qualified account.
      FETCH NEXT FROM Accounts_to_Clear INTO @Card_Account, @Current_Balance, @CA_Status
      
      WHILE (@@FETCH_STATUS = 0)
        -- Successfully FETCHed a Card Account record, so check that the current balance is not zero.
         BEGIN
            IF (@Current_Balance) = 0
               BEGIN
                  SET @ErrorNbr = -1
                  SET @Event_Text = 'Card Account with zero balance selected, CARD_ACCT_NO = ' + @Card_Account
               END
            
            IF (@ErrorNbr = 0)
               -- Passed initial error checking, now attempt database inserts and updates...
               BEGIN
                  SET @Cleared_Amt = @Current_Balance 
                  
                  -- Begin a Transaction.
                  BEGIN TRANSACTION
                  
                  -- Insert a new transaction row into the Casino_Trans table...
                  IF (@ErrorNbr = 0)
                     BEGIN
                        -- Perform the Insert.
                        INSERT INTO CASINO_TRANS
                            (CAS_ID, DEAL_NO, ROLL_NO, TICKET_NO, TRANS_ID, BALANCE,
                             CARD_ACCT_NO, DTIMESTAMP, ACCT_DATE, MODIFIED_BY, TRANS_AMT, MACH_NO)
                         VALUES
                            (@Casino_ID, 0, 0, 0, 25, 0,
                             @Card_Account, @CurrentDate, @CurrentAcctDate, 'dbo', @Cleared_Amt, '0')
                        
                        -- Store resulting error code.
                        SET @ErrorNbr = @@ERROR
                        
                        IF (@ErrorNbr <> 0)
                        BEGIN
                           SET @Event_Text = 
                              'Error on CASINO_TRANS INSERT, attempting to insert a ''Z'' record for CARD_ACCT_NO = '
                              + @Card_Account + '. Error: ' + CAST(@ErrorNbr AS VARCHAR)
                        END
                     END
               
               -- Now, update the current balance in the Card_Acct table...
               IF (@ErrorNbr = 0)
                  BEGIN
                     UPDATE CARD_ACCT
                     SET BALANCE        = 0,
                         MACH_NO        = '0',
                         STATUS         ='1',
                         SEQ_NUM        = NULL,
                         MODIFIED_DATE  = @CurrentDate
                     WHERE CARD_ACCT_NO = @Card_Account
                     
                     -- Store resulting error code.
                     SET @ErrorNbr = @@ERROR
                     
                     IF (@ErrorNbr <> 0)
                        BEGIN
                           SET @Event_Text = 'Error on UPDATE OF CARD_ACCT, attempted to update Card_acct_no = ' 
                                             + @Card_Account + '. Error: ' + CONVERT(VarChar(10), @ErrorNbr)
                        END
                  END
               
               -- Show the Account that will be updated
               -- Print 'CA #: ' + @Card_Account + ', Balance Cleared: ' + CONVERT(VarChar(10), @Cleared_Amt)
               
               -- Commit or Rollback changes
               IF (@ErrorNbr = 0)
                  BEGIN
                     SET @Nbr_Accounts_Cleared = @Nbr_Accounts_Cleared + 1
                     SET @Tot_Amount_Cleared = @Tot_Amount_Cleared + @Cleared_Amt
                     COMMIT
                  END
               ELSE
                  BEGIN
                     ROLLBACK
                     
                     INSERT INTO CASINO_EVENT_LOG
                        (EVENT_CODE, EVENT_SOURCE, EVENT_DESC) 
                     VALUES
                        ('CB', @Event_Source, @Event_Text)
                     
                     SET @ErrorNbr = 0
                  END
            END
            
            -- Get the information for the next qualified account.
            FETCH NEXT FROM Accounts_to_Clear INTO @Card_Account, @Current_Balance, @CA_Status
         
         END
      
      -- Close and Deallocate the Cursor
      CLOSE Accounts_to_Clear
   END

-- Deallocate Cursor
DEALLOCATE Accounts_to_Clear

-- Write a summary of activity to the Event Log table.
-- Show Number of Accounts Cleared, Total of Amounts Cleared, and Maximum Balance passed
-- Event_Code will be CB (Cleared Balances for SC Accounts).
SET @Event_Text = ' Accounts Cleared: ' + CONVERT(VarChar(12), @Nbr_Accounts_Cleared) + 
                  ', Total of Balances Cleared: ' + CONVERT(VarChar(16), @Tot_Amount_Cleared)  

INSERT INTO CASINO_EVENT_LOG
   (EVENT_CODE, EVENT_SOURCE, EVENT_DESC)
VALUES
   ('CB', @Event_Source, @Event_Text)

-- This procedure is to be run as a scheduled job and therefore does not return a resultset.
GO
