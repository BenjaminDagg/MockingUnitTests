SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpAdjustMachinePromoBalance

  Created: 08-05-2008 by Terry Watkins

  Purpose: Resets MACH_SETUP.PROMO_BALANCE value

Arguments:
   @MachineNumber        Machine Number
   @CardRequired         Flag indicating if in Card or Cardless Play mode
   @MachinePromoBalance  The promo balance (converted to Money) at the machine
   @ServerPromoBalance   The current MACH_SETUP.PROMO_BALANCE value
   @EventSource          Transaction event that called this procedure
   @TimeStamp            Date and Time to be recorded
   @CasinoID             Casino Identifier for insertion into CASINO_TRANS
   @AcctDate             Accounting Date for insertion into CASINO_TRANS
   @GameCode             Game Code of Machine for insertion into CASINO_TRANS

Returns:  0 = Success
          1 = Not in Cardless Play mode
          2 = New promo balance is negative


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-05-2008     v6.0.2
  Initial coding.

Terry Watkins 11-03-2009     v7.0.0
  Changed datatype of argument @AcctDate from VarChar(16) to DateTime.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new MACH_NO column.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added argument @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpAdjustMachinePromoBalance]
   @MachineNumber        Char(5),
   @CardRequired         Bit,
   @MachinePromoBalance  Money,
   @ServerPromoBalance   Money,
   @EventSource          VarChar(64),
   @TimeStamp            DateTime,
   @CasinoID             VarChar(6),
   @AcctDate             DateTime,
   @GameCode             VarChar(3),
   @LocationID           Int
AS

-- Variable Declarations
DECLARE @BalanceChange  Money
DECLARE @CasinoMachNo   VarChar(8)
DECLARE @CTBalance      Money
DECLARE @EventDesc      VarChar(1024)
DECLARE @MachineBalance Money
DECLARE @ReturnCode     Integer
DECLARE @TransID        SmallInt
DECLARE @TransNo        Integer

-- Variable Initialization.
SET @BalanceChange = @MachinePromoBalance - @ServerPromoBalance
SET @ReturnCode    = 0
SET @TransID       = 82

IF (@CardRequired = 1)
   -- Not in Cardless Play mode.
   SET @ReturnCode = 1
ELSE IF (@MachinePromoBalance < 0)
   -- Machine is reporting a negative promo balance.
   SET @ReturnCode = 2
ELSE
-- Not a negative promo balance and in Cardless Play mode, so continue...
   BEGIN
      -- Update MACH_SETUP.PROMO_BALANCE and retrieve the machine CASINO_MACH_NO and BALANCE values...
      UPDATE MACH_SETUP SET
         PROMO_BALANCE   = @MachinePromoBalance,
         @CasinoMachNo   = CASINO_MACH_NO,
         @MachineBalance = BALANCE
      WHERE MACH_NO = @MachineNumber
      
      -- Calc the balance to insert into CASINO_TRANS as account + promo balances.
      SET @CTBalance = @MachineBalance + @ServerPromoBalance
      
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
         @LocationID      = @LocationID
      
      -- Build the log event description text.
      SET @EventDesc = 'Server Promo Balance Adjusted ' + CONVERT(VarChar, @BalanceChange) +
         ' from ' + CONVERT(VarChar, @ServerPromoBalance) + ' to ' + CONVERT(VarChar, @MachinePromoBalance) + 
         ', Machine Nbr: ' + @MachineNumber + ', Casino Machine Nbr: ' + @CasinoMachNo + '.'
      
      -- Insert a log record.
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, EVENT_DATE_TIME, ID_VALUE, MACH_NO)
      VALUES
         ('BA', @EventSource, @EventDesc, @TimeStamp, @TransNo, @MachineNumber)
   END

-- Set the return value.
RETURN @ReturnCode
GO
