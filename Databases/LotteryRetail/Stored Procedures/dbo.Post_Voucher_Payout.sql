SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: Post_Voucher_Payout user stored procedure.

  Created: 04/07/2005 by Terry Watkins

  Purpose: Properly updates tables when a customer receives payment of voucher balance.

Arguments: @VoucherID     Identifies the Voucher being paid
           @PayoutUser    User that initiated payout
           @AuthUser      User that authorized the payout (when required)
           @PayoutAmount  Amount paid out in pennies
           @SessionID     Cashiers current Session ID
           @WorkStation   Cashiers Workstation name
           @PaymentType   Payment Type (A=Automatic, M=Manual)
           @LocationID    Location Identifier

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 04-07-2005     4.1.0
  Initial coding.

Terry Watkins 08-15-2005     4.2.0
  Added SET NOCOUNT ON to prevent error when called from VB6 app.
  Added update to VOUCHER columns REDEEMED_LOC, REDEEMED_STATE, and
  REDEEMED_DATE so the calling application does not need to make 2 round trips
  to the database.

Terry Watkins 03-07-2006     5.0.2
  Added argument @CheckValue which will contain the encrypted checksum value
  for the voucher record.

Terry Watkins 01-31-2007     5.0.8
  Changed insert into CASHIER_TRANS to update new AUTH_USER column.
  Added logging of payout override autherization to the CASINO_EVENT_LOG table.

Terry Watkins 07-24-2008     6.0.2
  Removed argument @CheckValue.  The voucher table check value will be
  automatically populated by calling the dbo.mfnGetVoucherCheckValue function.

Terry Watkins 11-04-2009     v7.0.0
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.

Terry Watkins 03-02-2010     v7.2.0
  Added a check that the user is a member of the VMod role to be able to
  update the VOUCHER table.
  Added a Voucher ID lookup in the CASHIER_TRANS table so a voucher cannot be
  paid a second time in the event that the first payout did not update the
  Voucher table.  Also recheck the IsValid and IsRedeemed status (double check
  as the MAS system checks before calling, but could prevent a voucher from
  being processed simultaneously from multiple POS locations.
  Also added Debug support.

Terry Watkins 05-14-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new ERROR_NO column.

Terry Watkins 11-15-2010     DCLottery v1.0.0
  Added @LocationID for insertion into CASINO_TRANS.LOCATION_ID.
  
Edris Khestoo 9-24-2012		
  Added @VoucherReceiptNo For multi Voucher support. Backwards compatiable. 
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Post_Voucher_Payout]
   @VoucherID          Int,
   @PayoutUser         VarChar(10),
   @AuthUser           VarChar(10),
   @PayoutAmount       Integer,
   @SessionID          VarChar(40),
   @WorkStation        VarChar(32),
   @PaymentType        Char(1),
   @LocationID         INT,
   @VoucherReceiptNo  INT = 0 
   
AS

-- Variable Declarations...
DECLARE @Debug            Bit
DECLARE @IsInRole         Bit
DECLARE @IsRedeemed       Bit
DECLARE @IsValid          Bit

DECLARE @CashierTransID   Integer
DECLARE @CasinoTransID    Integer
DECLARE @ErrorNbr         Integer
DECLARE @MachNbrAsInt     Integer
DECLARE @RowCount         Integer
DECLARE @TransID          Integer
DECLARE @TransNbr         Integer

DECLARE @TransAmount      Money

DECLARE @AcctDate         DateTime
DECLARE @CurrentDate      DateTime
DECLARE @RedeemedDate     DateTime

DECLARE @Barcode          VarChar(18)
DECLARE @CasID            VarChar(6)
DECLARE @ErrorText        VarChar(1024)
DECLARE @ErrorSource      VarChar(64)
DECLARE @EventText        VarChar(1024)
DECLARE @MsgText          VarChar(2048)
DECLARE @RedeemedLoc      VarChar(32)

-- Suppress unwanted statistics
SET NOCOUNT ON

-- Variable Initialization.
SET @Barcode        = ''
SET @CashierTransID = 0
SET @CasinoTransID  = 0
SET @CurrentDate    = GetDate()
SET @ErrorNbr       = 0
SET @ErrorSource    = ''
SET @ErrorText      = ''
SET @EventText      = ''
SET @MachNbrAsInt   = 0
SET @TransAmount    = CAST(@PayoutAmount AS Money) / 100
SET @TransID        = 24

-- Calc the accounting date based upon the current DateTime and the accounting offset...
SELECT @CasID = CAS_ID FROM CASINO WHERE SETASDEFAULT = 1

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'Post_Voucher_Payout'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'Post_Voucher_Payout Arguments - VoucherID: ' +
         ISNULL(CAST(@VoucherID AS VarChar), '<null>') +
         '  PayoutUser: '   + ISNULL(@PayoutUser, '<null>') +
         '  AuthUser: '     + ISNULL(@AuthUser,   '<null>') +
         '  PayoutAmount: ' + ISNULL(CAST(@PayoutAmount AS VarChar), '<null>') +
         '  SessionID: '    + ISNULL(@SessionID,   '<null>') +
         '  WorkStation: '  + ISNULL(@WorkStation, '<null>') +
         '  PaymentType: '  + ISNULL(@PaymentType, '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Initialize @TransNbr to -1.
-- It will be reset to the value of the inserted CASHIER_TRANS_ID if the insert succeeds.
SET @TransNbr = -1

-- Retrieve the BARCODE value.
SELECT
   @Barcode    = BARCODE ,
   @IsRedeemed = REDEEMED_STATE,
   @IsValid    = IS_VALID
FROM VOUCHER
WHERE VOUCHER_ID = @VoucherID

-- Store row count and error (if any) from the BARCODE table SELECT above.
SELECT @ErrorNbr = @@ERROR, @RowCount = @@ROWCOUNT

-- If in Debug mode, save retrieved values...
IF (@Debug = 1 AND @RowCount > 0)
   BEGIN
      SET @MsgText =
         '  P_V_P retrieved values:  Barcode: ' + ISNULL(@Barcode, '<null>') +
         '  IsRedeemed: ' + CAST(@IsRedeemed AS VarChar) +
         '  IsValid: '    + CAST(@IsValid AS VarChar)
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Any errors?
IF (@ErrorNbr = 0)
   BEGIN
      -- No errors, check for a VOUCHER table row...
      IF @RowCount < 1
         BEGIN
            -- No row for the specified VOUCHER_ID...
            SET @ErrorNbr = 1
            SET @ErrorText = 'Voucher not found for VOUCHER_ID ' + CAST(@VoucherID AS VarChar) + '.'
         END
   END

-- Any errors?
IF (@ErrorNbr = 0)
   -- No errors, check if Voucher is already redeemed row...
   BEGIN
      IF (@IsRedeemed = 1)
         BEGIN
            -- Already redeemed...
            SET @ErrorNbr = 1
            SET @ErrorText = 'Voucher with VOUCHER_ID ' + CAST(@VoucherID AS VarChar) + ' has already been redeemed.'
         END
   END

-- Any errors?
IF (@ErrorNbr = 0)
   -- No errors, check if Voucher is valid...
   BEGIN
      IF (@IsValid = 0)
         BEGIN
            -- Invalid...
            SET @ErrorNbr = 1
            SET @ErrorText = 'Voucher with VOUCHER_ID ' + CAST(@VoucherID AS VarChar) + ' is flagged as Invalid.'
         END
   END

-- Any errors?
IF (@ErrorNbr = 0)
   -- No errors, check if current user can modify the VOUCHER table...
   BEGIN
      SET @IsInRole = [dbo].[UserInRole]('VMod', CURRENT_USER)
      IF (@IsInRole <> 1)
         BEGIN
            -- Only members of VMod role can modify the VOUCHER table.
            SET @ErrorNbr = 1
            SET @ErrorText = 'Current user does not have permissions to update Voucher data.'
         END
   END

-- If no errors, make sure voucher was not already marked as paid by the existance of a row in the CASHIER_TRANS table...
IF (@ErrorNbr = 0)
   BEGIN
      IF EXISTS(SELECT * FROM CASHIER_TRANS WHERE VOUCHER_ID = @VoucherID)
         BEGIN
            -- Just in case there are multiple rows in CASHIER_TRANS with the same VOUCHER_ID, get the max value.
            SELECT @CashierTransID = MAX(CASHIER_TRANS_ID)FROM CASHIER_TRANS WHERE VOUCHER_ID = @VoucherID
            
            -- Now retrieve data from that row to build error text...
            SELECT               
               @TransAmount   = TRANS_AMT,
               @CasinoTransID = TRANS_NO,
               @RedeemedLoc   = CASHIER_STN,
               @RedeemedDate  = CREATE_DATE
            FROM CASHIER_TRANS
            WHERE CASHIER_TRANS_ID = @CashierTransID
            
            -- Set error number and text...
            SET @ErrorNbr = 1
            SET @ErrorText = 'Voucher with VOUCHER_ID '     + CAST(@VoucherID AS VarChar) +
                             ' already exists in the CASHIER_TRANS table and may not be paid again.' +
                             ' CASHIER_TRANS.TRANS_NO: '    + CAST(@CasinoTransID AS VarChar) +
                             ' CASHIER_TRANS.TRANS_AMT: '   + CAST(@TransAmount AS VarChar) +
                             ' CASHIER_TRANS.CASHIER_STN: ' + @RedeemedLoc +
                             ' @PayoutUser: '               + @PayoutUser +
                             ' @PayoutAmount: '             + CAST(@PayoutAmount AS VarChar) +
                             ' @SessionID: '                + @SessionID +
                             ' @WorkStation: '              + @WorkStation +
                             ' @PaymentType: '              + @PaymentType
            
            -- Mark the voucher record so it cannot be paid again.
            UPDATE VOUCHER SET
               CT_TRANS_NO_VR = @CasinoTransID,
               REDEEMED_LOC   = LEFT(@RedeemedLoc, 16),
               REDEEMED_STATE = 1,
               REDEEMED_DATE  = @RedeemedDate,
               CHECK_VALUE    = dbo.mfnGetVoucherCheckValue(@Barcode, @PayoutAmount, 1)
            WHERE VOUCHER_ID = @VoucherID
         END
   END

IF (@ErrorNbr = 0)
   -- Passed initial error checking, now attempt database inserts and updates...
   BEGIN
      -- Begin a Transaction.
      BEGIN TRANSACTION
      
      -- Insert a new transaction row into the Casino_Trans table...
      IF (@ErrorNbr = 0)
         BEGIN
            -- Perform the Insert.
            INSERT INTO CASINO_TRANS
                (CAS_ID, DEAL_NO, ROLL_NO, TICKET_NO, TRANS_ID, BALANCE, CARD_ACCT_NO,
                 DTIMESTAMP, ACCT_DATE, MODIFIED_BY, TRANS_AMT, MACH_NO, LOCATION_ID)
             VALUES
                (@CasID, 0, 0, 0, 24, 0, 'INTERNAL',
                 @CurrentDate, @AcctDate, @PayoutUser, @TransAmount, 0, @LocationID)
            
            -- Store resulting error code.
            SELECT @ErrorNbr = @@ERROR, @CasinoTransID = SCOPE_IDENTITY()
            
            IF (@ErrorNbr <> 0)
               BEGIN
                  SET @ErrorText = 'Error on INSERT INTO CASINO_TRANS, attempted insert of VoucherID  ' + 
                                   CAST(@VoucherID AS VarChar) +
                                   '. Error: ' + CAST(@ErrorNbr AS VarChar)
               END
         END
      
      -- Now, we'll insert a row into CASHIER_TRANS
      IF (@ErrorNbr = 0)
         BEGIN
            INSERT INTO CASHIER_TRANS
               (TRANS_TYPE, TRANS_AMT, TRANS_NO, SESSION_ID, CREATED_BY, AUTH_USER,
                CREATE_DATE, CASHIER_STN, PAYMENT_TYPE, VOUCHER_ID, LOCATION_ID)
            VALUES
               ('P', @TransAmount, @CasinoTransID, @SessionID, @PayoutUser, @AuthUser,
                @CurrentDate, @WorkStation, @PaymentType, @VoucherID, @LocationID)
            
            -- Store the CASHIER_TRANS.CASHIER_TRANS_ID and any resulting error code...
            SELECT @ErrorNbr = @@ERROR, @CashierTransID = SCOPE_IDENTITY()
            
            IF (@ErrorNbr <> 0)
               -- INSERT into the CASHIER_TRANS table failed, build error text...
               BEGIN
                  SET @ErrorText = 'Error on INSERT INTO CASHIER_TRANS, attempted to insert TRANS_NO = ' + 
                                   CAST(@CasinoTransID AS VarChar) + '. Error: ' + CAST(@ErrorNbr AS VarChar)
               END
            ELSE
               -- No errors so far.
               BEGIN
                  -- Update the VOUCHER table...
                  UPDATE VOUCHER SET
                     CT_TRANS_NO_VR = @CasinoTransID,
                     REDEEMED_LOC   = @WorkStation,
                     REDEEMED_STATE = 1,
                     REDEEMED_DATE  = GetDate(),
                     CHECK_VALUE    = dbo.mfnGetVoucherCheckValue(@Barcode, @PayoutAmount, 1)
                  WHERE VOUCHER_ID = @VoucherID
                  
                  -- Store resulting error code (if any).
                  SELECT @ErrorNbr = @@ERROR
                  IF (@ErrorNbr <> 0)
                        SET @ErrorText = 'Error on UPDATE of VOUCHER table. Error: ' + CAST(@ErrorNbr AS VarChar)
                        
                  -- Multi Voucher Support
                  IF (@VoucherReceiptNo > 0) 
                  BEGIN 
                        INSERT INTO [dbo].[VOUCHER_RECEIPT_DETAILS] ([VOUCHER_RECEIPT_NO], [VOUCHER_ID],[LOCATION_ID],[CashierTransID])
                        VALUES (@VoucherReceiptNo, @VoucherID, @LocationId, @CashierTransID)

                        -- Store resulting error code (if any).
                        SELECT @ErrorNbr = @@ERROR
                        IF (@ErrorNbr <> 0)
                           SET @ErrorText = 'Error on INSERT INTO VOUCHER_RECIEPT_DETAILS. Error: ' + CAST(@ErrorNbr AS VarChar)
                  END                               
                  
               END
         END
      
      -- Commit or Rollback changes
      IF (@ErrorNbr = 0)
         BEGIN
            SET @TransNbr = @CashierTransID
            COMMIT
         END
      ELSE
         BEGIN
            ROLLBACK
         END
   END

-- If no errors and payout authorization was necessary, record it in the CASINO_EVENT_LOG table.
IF (@ErrorNbr = 0)
   BEGIN
      IF (@AuthUser IS NULL) SET @AuthUser = ''
      IF (LEN(@AuthUser) > 0)
         BEGIN
            -- Build event text...
            SET @EventText = 'Payout Override. Payout Amount of ' + CONVERT(VarChar(16), @TransAmount) + 
                             '. Initiated by ' + @PayoutUser + '. Authorized by ' + @AuthUser +
                             '. CASINO_TRANS.TRANS_NO = ' + CONVERT(VarChar(10), @CasinoTransID) + 
                             '. CASHIER_TRANS.CASHIER_TRANS_ID = ' + CONVERT(VarChar(10), @CashierTransID)
            
            -- Perform the insertion.
            INSERT INTO CASINO_EVENT_LOG
               (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO)
            VALUES
               ('PO', 'Procedure Post_Voucher_Payout', @EventText, 0)
         END
   END


-- Now write to the Event Log table if necessary...
-- Event_Code will be FP (Failed Payout).
IF (@ErrorNbr <> 0)
   BEGIN
      SET @ErrorSource = 'Post_Voucher_Payout - ID ' + @PayoutUser + ' at ' + @WorkStation
      
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO)
      VALUES
         ('FP', @ErrorSource, @ErrorText, @ErrorNbr)
      
      -- If debugging, write the error text...
      IF (@Debug = 1)
         BEGIN
            SET @MsgText = 'P_V_P Error: ' + @ErrorText
            EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
         END
   END

-- If in Debug mode, save SELECT return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'P_V_P return values:  CashierTransID: ' +
         ISNULL(CAST(@TransNbr AS VarChar), '<null>') +
         '  ErrorID: ' + ISNULL(CAST(@ErrorNbr AS VarChar), '<null>') +
         '  ErrorDescription: ' + ISNULL(@ErrorText, '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return Error number and error text in a dataset.
SELECT @TransNbr AS CashierTransID, @ErrorNbr AS ErrorID, @ErrorText AS ErrorDescription
GO
