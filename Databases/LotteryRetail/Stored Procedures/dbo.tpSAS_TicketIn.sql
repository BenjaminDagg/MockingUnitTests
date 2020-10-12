SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpSAS_TicketIn

Created 02-02-2009 by Terry Watkins

Purpose:
   Handles the SASTicketIn message which happens in response to a user inserting
   a ticket/voucher into a machine in a SAS environment.  This procedure has been
   added to support recording of TITO data in a SAS casino.

Return value: None

Returned dataset: ErrorCode, ErrorDescription, ShutdownFlag

Called by: TransactionPortal

Parameters:
   @MachineNumber       The DGE machine number
   @TransAmt            The transaction amount in cents
   @MachineBalance      The new balance in cents sent from the Machine to the TP
   @PromoBalance        The new promo balance in cents sent from the Machine to the TP
   @CardAccount         Player Account number if present in the machine
   @CreditType          Type of Credit: 0=Normal, 1=Promo, 2=???


Note: This procedure makes the assumption that it will only be called while in
      Cardless Play mode (CASINO.PLAYER_CARD = 0) and retrieves that Balance
      from the MACH_SETUP table.  If we ever need to support Card Required mode
      (CASINO.PLAYER_CARD = 1), then the balance will need to be retrieved from
      the CARD_ACCT table.


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 02-02-2009     v6.0.3
  Initial coding.

Terry Watkins 11-03-2009     v7.0.0
  Added code to disallow balance adjustments that exceed the value set in
  CASINO.MAX_BAL_ADJUSTMENT.
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AccountingDate changed from VarChar(16) to DateTime.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added retrieval of @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID
  Added insertion into (or updating of) table PLAY_STATS_HOURLY.
  
Louis Epstein 06-18-2014     v3.2.3
  Modified stat recording functionality to use tpUpdatePlayStatsHourlyAndDaily
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpSAS_TicketIn]
   @MachineNumber       Char(5),
   @TransAmt            Int,
   @MachineBalance      Int,
   @PromoBalance        Int,
   @CardAccount         VarChar(20),
   @CreditType          SmallInt
AS

-- Variable Declarations
DECLARE @AccountingDate    DateTime
DECLARE @Balance           Money
DECLARE @CardRequired      Bit
DECLARE @CasinoID          VarChar(6)
DECLARE @CasinoMachNo      VarChar(8)
DECLARE @CasinoTransID     Int
DECLARE @CTBalance         Money
DECLARE @DealNo            Int
DECLARE @Debug             Bit
DECLARE @ErrorID           Int
DECLARE @ErrorSource       VarChar(64)
DECLARE @ErrorText         VarChar(1024)
DECLARE @ErrorDescription  VarChar(256)
DECLARE @EventCode         VarChar(2)
DECLARE @EventLogDesc      VarChar(1024)
DECLARE @HourOfDay         Int
DECLARE @LocationID        Int
DECLARE @LockupMachine     Int
DECLARE @MachineBal        Money
DECLARE @MachineStatsID    Int
DECLARE @MachGameCode      VarChar(3)
DECLARE @MachNbrAsInt      Int
DECLARE @MaxBalAdjust      Money
DECLARE @MsgText           VarChar(2048)
DECLARE @NewMachBalance    Money
DECLARE @NewPromoBalance   Money
DECLARE @PlayStatsHourlyID Int
DECLARE @PromoBal          Money
DECLARE @SysPromoBalance   Money
DECLARE @TierLevel         SmallInt
DECLARE @TimeStamp         DateTime
DECLARE @ToTime            DateTime
DECLARE @TransAmount       Money
DECLARE @TransID           SmallInt

SET NOCOUNT ON

-- Variable Initialization
SET @Balance          = 0
SET @CardRequired     = 1
SET @CasinoMachNo     = ''
SET @CTBalance        = 0
SET @DealNo           = 0
SET @ErrorID          = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpSAS_TicketIn Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'SP'
SET @EventLogDesc     = ''
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachineBal       = CAST(@MachineBalance AS Money) / 100
SET @MachGameCode     = ''
SET @MachNbrAsInt     = CAST(@MachineNumber AS Int)
SET @PromoBal         = CAST(@PromoBalance AS Money) / 100
SET @SysPromoBalance  = 0
SET @TierLevel        = 0
SET @TransAmount      = CAST(@TransAmt AS Money) / 100
SET @TransID          = 21
SET @TimeStamp        = GetDate()

-- The default TransID is 21 (Voucher In).
-- If CreditType is 1 reset the TransID to 83 (SAS Promo Ticket In).
IF (@CreditType = 1)
   SET @TransID = 83

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpSAS_TicketIn'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpSAS_TicketIn Arguments - MachineNumber: ' + @MachineNumber +
         '  TransAmt: '       + CAST(@TransAmt AS VarChar)       +
         '  MachineBalance: ' + CAST(@MachineBalance AS VarChar) +
         '  PromoBalance: '   + CAST(@PromoBalance AS VarChar)   +
         '  CardAccount: '    + @CardAccount                     +
         '  CreditType: '     + CAST(@CreditType AS VarChar)
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve Casino Information.
SELECT
   @CasinoID     = CAS_ID,
   @ToTime       = TO_TIME,
   @CardRequired = PLAYER_CARD,
   @MaxBalAdjust = MAX_BAL_ADJUSTMENT,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- If @CardRequired is 0 (TITO), set @CardAccount to 'INTERNAL'
IF (@CardRequired = 0)
   SET @CardAccount = 'INTERNAL'

-- Get Current Accounting Date and hour of the day.
SET @AccountingDate = dbo.ufnGetAcctDate()
SET @HourOfDay      = dbo.ufnCurrentHour()

-- Call GetMachineStatus function (checks for Machine not found, inactive, or removed).
SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

IF (@Debug = 1)
   BEGIN
      SET @MsgText = 'GetMachineStatus returned @ErrorID = ' + CAST(@ErrorID AS VarChar)
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Set last activity and retrieve Casino Machine Number and the Game Code of the machine
-- if the Machine record was found in MACH_SETUP.
IF (@ErrorID <> 104)
   BEGIN
      UPDATE MACH_SETUP SET
         LAST_ACTIVITY    = @TimeStamp,
         @CasinoMachNo    = CASINO_MACH_NO,
         @MachGameCode    = GAME_CODE,
         @SysPromoBalance = PROMO_BALANCE,
         @Balance         = BALANCE
      WHERE
         MACH_NO = @MachineNumber
      
      -- Is this is a SAS Ticket In?
      IF (@TransID = 21)
         BEGIN
            -- Yes, so calculate what the new machine balance should be:
            -- (Add the transaction amount to the balance from MACH_SETUP).
            SET @NewMachBalance = @Balance + @TransAmount
            
            -- Calculate the CASINO_TRANS balance as the new machine balance plus the system promo balance.
            SET @CTBalance = @NewMachBalance + @SysPromoBalance
            
            -- If no errors so far, set bad balance error if machine and system do not agree...
            IF (@ErrorID = 0 AND @MachineBal <> @NewMachBalance)
               BEGIN
                  -- The new calculated balance does not agree with the balance sent from the machine.
                  -- If in Cardless Play mode set 105 (no lockup) otherwise 120 (locks up machine).
                  IF (@CardRequired = 0)
                     SET @ErrorID = 105
                  ELSE
                     SET @ErrorID = 120
                  
                  -- Set the error text...
                  SET @ErrorText = ', Server balance: ' + CONVERT(VarChar(16), @Balance) +
                                   ', Machine submitted: ' + CONVERT(VarChar(16), @MachineBal)
               END
         END
      
      -- Is this a SAS Promo Ticket In?
      IF (@TransID = 83)
         BEGIN
            -- Yes, so calculate what the new Promo balance should be:
            -- (Add the transaction amount to the PromoBalance from MACH_SETUP).
            SET @NewPromoBalance = @SysPromoBalance + @TransAmount
            
            -- Calculate the CASINO_TRANS balance as the account plus the new promo balances.
            SET @CTBalance = @Balance + @NewPromoBalance
            
            -- If no errors so far, set bad balance error if machine and system do not agree...
            IF (@ErrorID = 0 AND @PromoBal <> @NewPromoBalance)
               BEGIN
                  -- The new calculated Promo balance does not agree with the promo balance sent from the machine.
                  SET @ErrorID = 132
                  -- Set the error text...
                  SET @ErrorText = ', Server Promo Balance: ' + CONVERT(VarChar(16), @Balance) +
                                   ', Machine submitted: ' + CONVERT(VarChar(16), @MachineBal)
               END
         END
   END

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
      
      -- If in Cardless Play mode, reset error text.
      IF (@CardRequired = 0)
         SET @ErrorDescription = dbo.CardlessErrorText(@ErrorDescription)
      
      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription +
                          ', Card Account: ' + @CardAccount +
                          ', Machine Number: ' + @MachineNumber + @ErrorText
      
      -- Test if the Machine should be locked up.
      IF (@LockupMachine <> 0)
         BEGIN
            UPDATE MACH_SETUP SET ACTIVE_FLAG = 0 WHERE MACH_NO = @MachineNumber AND ACTIVE_FLAG = 1
            SET @EventCode = 'SD'
         END
      
      -- Insert Error into the Casino_Event_Log
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)
   END

-- Any errors encountered?
IF (@ErrorID = 0)
   -- No, so update MACHINE_STATS.TICKET_IN_COUNT & TICKET_IN_AMOUNT and MACH_SETUP.BALANCE columns...
   BEGIN
                   
      -- Is this a SAS Ticket In?
      IF (@TransID = 21)
         BEGIN
            
            EXEC tpUpdatePlayStatsHourlyAndDaily 
            @LocationIdPass = @LocationID, 
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AccountingDate,
@DealNoPass = @DealNo,
@GameCodePass = @MachGameCode,
@TicketInCountPass = 1,
@TicketInAmountPass = @TransAmount


            
            -- Reset the BALANCE in the MACH_SETUP table.
            UPDATE MACH_SETUP SET BALANCE = @NewMachBalance WHERE MACH_NO = @MachineNumber
            
            -- Update the MACHINE_METER table.
            -- Note, this is done even though the MACHINE_METER table is only used for SDG reporting.
            IF EXISTS(SELECT * FROM MACHINE_METER WHERE MACH_NO = @MachineNumber)
               -- Row exists, update it.
               BEGIN
                  UPDATE MACHINE_METER SET
                     TICKET_IN_COUNT = TICKET_IN_COUNT + 1,
                     TICKET_IN_TOTAL = TICKET_IN_TOTAL + @TransAmount
                  WHERE MACH_NO = @MachineNumber
               END
            ELSE
               -- Row does not exist, insert a new row.
               BEGIN
                  INSERT INTO MACHINE_METER
                     (MACH_NO, TICKET_IN_COUNT, TICKET_IN_TOTAL)
                  VALUES
                     (@MachineNumber, 1, @TransAmount)
               END
         END
      
      -- Is this a SAS Promo Ticket In?
      IF (@TransID = 83)
         BEGIN
         
            EXEC tpUpdatePlayStatsHourlyAndDaily 
            @LocationIdPass = @LocationID, 
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AccountingDate,
@DealNoPass = @DealNo,
@GameCodePass = @MachGameCode,
@PromoInCountPass = 1,
@PromoInAmountPass = @TransAmount
            
            -- Reset the PROMO_BALANCE in the MACH_SETUP table.
            UPDATE MACH_SETUP SET PROMO_BALANCE = @NewPromoBalance WHERE MACH_NO = @MachineNumber
         END
END

-- Log transaction.
EXEC @CasinoTransID = tpInsertCasinoTrans
   @CasinoID        = @CasinoID,
   @DealNo          = @DealNo,
   @TransAmt        = @TransAmount,
   @TransID         = @TransID,
   @CurrentAcctDate = @AccountingDate,
   @TimeStamp       = @TimeStamp,
   @MachineNumber   = @MachineNumber,
   @CardAccount     = @CardAccount,
   @Balance         = @CTBalance,
   @GameCode        = @MachGameCode,
   @LocationID      = @LocationID

-- Did we get a balance error in Cardless Play mode where the machine
-- balance vs system balance <= max allowable balance adjustment amount?
IF (@ErrorID = 105 AND @CardRequired = 0 AND ((@MachineBal - @NewMachBalance) <= @MaxBalAdjust))
   BEGIN
      -- Yes, so we need to adjust the machine balance...
      EXEC tpAdjustMachineBalance
         @MachineNumber, @CardRequired, @MachineBal, @Balance, 'tpSAS_TicketIn',
         @TimeStamp, @CasinoID, @AccountingDate, @MachGameCode, LocationID         
   END

-- If we have a balance mismatch greater than max allowable, force
-- a lockup regardless of the ERROR_LOOKUP setting for 105.
IF ((@ErrorID = 105) AND ((@MachineBal - @NewMachBalance) > @MaxBalAdjust))
   SET @LockupMachine = 1

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpSAS_TicketIn Return Values - ErrorID: ' + CAST(@ErrorID AS VarChar(10)) +
         '  ErrorDescription: ' + @ErrorDescription +
         '  LockupMachine: ' + CAST(@LockupMachine AS VarChar(10))
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag
GO
