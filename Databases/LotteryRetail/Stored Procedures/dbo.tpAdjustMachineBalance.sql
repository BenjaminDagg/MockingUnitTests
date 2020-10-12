SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpAdjustMachineBalance

  Created: 12/07/2004 by Terry Watkins

  Purpose: Resets MACH_SETUP.BALANCE value

Arguments:
   @MachineNumber   Machine Number
   @CardRequired    Flag indicating if in Card or Cardless Play mode
   @MachineBalance  The balance (converted to Money) at the machine
   @ServerBalance   The current MACH_SETUP balance
   @EventSource     Transaction event that called this procedure
   @TimeStamp       Date and Time to be recorded
   @CasinoID        Casino Identifier for insertion into CASINO_TRANS
   @AcctDate        Accounting Date for insertion into CASINO_TRANS
   @GameCode        Game Code of Machine for insertion into CASINO_TRANS

Returns:  0 = Success
          1 = Not in Cardless Play mode


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-07-2004     v4.0.0
  Initial coding.

Terry Watkins 09-07-2005     v4.2.2
  Changed the value inserted into CASINO_TRANS.BALANCE to be the total of the
  account balance plus the promo balance.

Terry Watkins 10-04-2006     v5.0.8
  Removed argument @TicketStatusID from call to tpInsertCasinoTrans.

Terry Watkins 11-03-2009     v7.0.0
  Changed datatype of argument @AcctDate from VarChar(16) to DateTime.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new MACH_NO column.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added argument @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpAdjustMachineBalance]
   @MachineNumber   Char(5),
   @CardRequired    Bit,
   @MachineBalance  Money,
   @ServerBalance   Money,
   @EventSource     VarChar(64),
   @MachineTimeStamp DateTime,
   @CasinoID        VarChar(6),
   @AcctDate        DateTime,
   @GameCode        VarChar(3),
   @LocationID      Int
AS

-- Variable Declarations
DECLARE @BalanceChange Money
DECLARE @CasinoMachNo  VarChar(8)
DECLARE @CTBalance     Money
DECLARE @PromoBalance  Money
DECLARE @EventDesc     VarChar(1024)
DECLARE @ReturnCode    Integer
DECLARE @TransID       SmallInt
DECLARE @TransNo       Integer
DECLARE @TimeStamp     DateTime

-- Variable Initialization.
SET @BalanceChange = @MachineBalance - @ServerBalance
SET @ReturnCode    = 0
SET @TransID       = 28
SET @TimeStamp     = GETDATE()

-- We will only adjust the balance if in Cardless Play mode.
IF (@CardRequired = 0)
   BEGIN
      -- Update MACH_SETUP.BALANCE.
      UPDATE MACH_SETUP SET
         BALANCE       = @MachineBalance,
         @CasinoMachNo = CASINO_MACH_NO,
         @PromoBalance = PROMO_BALANCE
      WHERE MACH_NO = @MachineNumber
      
      -- Calc the balance we insert into CASINO_TRANS as account + promo balances.
      SET @CTBalance = @MachineBalance + @PromoBalance
      
      -- Insert into CasinoTrans.
      EXEC @TransNo = tpInsertCasinoTrans
         @CasinoID        = @CasinoID,
         @DealNo          = 0,
         @RollNo          = 0,
         @TicketNo        = 0,
         @Denom           = 0,
         @TransAmt        = @BalanceChange,
         @Barcode         = '',
         @TransID         = @TransID,
         @CurrentAcctDate = @AcctDate,
         @TimeStamp       = @TimeStamp,
         @MachineNumber   = @MachineNumber,
         @CardAccount     = 'INTERNAL',
         @Balance         = @CTBalance,
         @GameCode        = @GameCode,
         @CoinsBet        = 0,
         @LinesBet        = 0,
         @TierLevel       = 0,
         @LocationID      = @LocationID,
         @MachineTimeStamp = @MachineTimeStamp
      
      -- Build the log event description text.
      SET @EventDesc = 'Server Balance Adjusted ' + CONVERT(VarChar, @BalanceChange) +
         ' from ' + CONVERT(VarChar, @ServerBalance) + ' to ' + CONVERT(VarChar, @MachineBalance) + 
         ', Machine Nbr: ' + @MachineNumber + ', Casino Machine Nbr: ' + @CasinoMachNo + '.'
      
      -- Insert a log record.
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, EVENT_DATE_TIME, ID_VALUE, MACH_NO)
      VALUES
         ('BA', @EventSource, @EventDesc, @TimeStamp, @TransNo, @MachineNumber)
   END
ELSE
   -- Not in Cardless Play mode.
   BEGIN
      SET @ReturnCode = 1
   END

-- Set the return value.
RETURN @ReturnCode
GO
