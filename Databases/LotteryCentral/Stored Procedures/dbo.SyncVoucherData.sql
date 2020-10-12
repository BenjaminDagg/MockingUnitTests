SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: SyncVoucherData user stored procedure.

Created: 2011-07-27 by Aldo Zamora

Purpose: Synchronize the location and central voucher table.

Arguments: None


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   2011-07-27     v2.0.4
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SyncVoucherData]

AS

-- Declare Variables.
DECLARE @ErrorDescription VARCHAR(255)
DECLARE @ErrorID          INT
DECLARE @LocationID       INT
DECLARE @PayoutAmount     INT
DECLARE @PayoutUser       VARCHAR(10)
DECLARE @SPName           VARCHAR(64)
DECLARE @SPNameBase       VARCHAR(64)
DECLARE @SQLErrorID       INT
DECLARE @VoucherID        INT
DECLARE @WorkStation      VARCHAR(32)

DECLARE @ResultSet TABLE(CashierTransID Integer, ErrorID INT, ErrorDescription VarChar(1024))

-- Initialize Variables...
SET @ErrorID = 0
SET @SPNameBase = 'DCxxxx.LotteryRetail.dbo.Post_Voucher_Payout'

-- Declare a cursor to move through the rows in the variable table.
DECLARE GetVoucherData CURSOR FOR
   SELECT
      VoucherID,
      AppUserID,
      TransAmount,
      PosWorkStation,
      LocationID
   FROM dbo.VoucherPayout
   WHERE LocationUpdated = 0

-- Open the cursor.
OPEN GetVoucherData

-- Get the first row of data.
FETCH FROM GetVoucherData INTO
   @VoucherID, @PayoutUser, @PayoutAmount, @WorkStation, @LocationID
   
WHILE (@@FETCH_STATUS = 0)
   -- FETCH was successful
   BEGIN
      -- Initialize variables for each fetch iteration...
      SET @SQLErrorID = 0
      SET @ErrorDescription = ''
      SET @SPName = REPLACE(@SPNameBase, 'xxxx', CAST(@LocationID AS VARCHAR))
      
      -- Attempt to call retail Post_Voucher_Payout and store resultset
      -- in variable table @ResultSet.
      BEGIN TRY               
         INSERT INTO @ResultSet (CashierTransID, ErrorID, ErrorDescription)
         EXECUTE @SPName
            @VoucherID    = @VoucherID,
            @PayoutUser   = @PayoutUser,
            @AuthUser     = '',
            @PayoutAmount = @PayoutAmount,
            @SessionID    = '',
            @WorkStation  = @WorkStation,
            @PaymentType  = 'A',
            @LocationID   = @LocationID
            
            -- Store result set data.
            SELECT @ErrorID = ErrorID, @ErrorDescription = ErrorDescription FROM @ResultSet
            
            -- Empty the variable table.
            DELETE FROM @ResultSet
      END TRY
      
      BEGIN CATCH
         -- Retrieve error information.
         SET @SQLErrorID = ERROR_NUMBER()
         SET @ErrorDescription = ERROR_MESSAGE()
         
         -- Insert Error into the Casino_Event_Log
         INSERT INTO EventLog
            (EventCode, EventSource, EventDescription, ErrorNumber)
         VALUES
            ('SP', 'InsertGLInfoRetail', @ErrorDescription, @SQLErrorID)
      END CATCH
      
      -- Any SQL Error?
      IF (@SQLErrorID = 0)
         -- No, did Post_Voucher_Payout return zero?
         BEGIN
            IF @ErrorID = 0
               BEGIN
                  -- Yes, so update voucher payout table.
	              UPDATE VoucherPayout
	              SET LocationUpdated = 1
	           WHERE
	              VoucherID  = @VoucherID AND
	              LocationID = @LocationID
               END
            ELSE
               BEGIN
                  -- Post_Voucher_Payout returned non-zero, so insert error into the EventLog table.
                  INSERT INTO EventLog
                     (EventCode, EventSource, EventDescription, ErrorNumber)
                  VALUES
                     ('SP', 'InsertGLInfoRetail', @ErrorDescription, @ErrorID)
               END
         END
      
      -- Get the next row of the resultset.
      FETCH NEXT FROM GetVoucherData INTO
         @VoucherID, @PayoutUser, @PayoutAmount, @WorkStation, @LocationID
   END
   
-- Close and Deallocate the Cursor...
CLOSE GetVoucherData
DEALLOCATE GetVoucherData
GO
