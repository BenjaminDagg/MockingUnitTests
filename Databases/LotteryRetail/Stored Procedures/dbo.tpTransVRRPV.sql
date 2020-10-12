SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpTransVRRPV

Created 11-15-2011 by Terry Watkins

Purpose:
   Handles Voucher Redeemed messages for Restricted Promotional Vouchers which
   happens in response to a user inserting a promotional voucher into a machine.

Return value: None

Returned dataset: ErrorCode, ErrorDescription, ShutdownFlag, CasinoTransID

Called by: TransactionPortal

Parameters:
   @MachineNumber       The DGE machine number
   @TransAmt            The Promotional Voucher amount in cents
   @MachineBalance      The normal (cashable) balance in cents sent from the Machine to the TP
   @CardAccount         Player Account number if present in the machine


Note: This procedure makes the assumption that it will only be called while in
      Cardless Play mode (CASINO.PLAYER_CARD = 0) and retrieves that Balance
      from the MACH_SETUP table.  If we ever need to support Card Required mode
      (CASINO.PLAYER_CARD = 1), then the balance will need to be retrieved from
      the CARD_ACCT table.


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-15-2011     v7.2.5
  Initial coding, copied tpTransVR and modified for Promo Voucher support.
  
Louis Epstein 01-09-2014     v3.1.7
  Added LocationID and MachineTimestamp functionality.
  
Louis Epstein 06-18-2014     v3.2.3
  Modified stat recording functionality to use tpUpdatePlayStatsHourlyAndDaily
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransVRRPV]
   @MachineNumber       Char(5),
   @TransAmt            Int,
   @MachineBalance      Int,
   @CardAccount         VarChar(20),
   @TimeStamp DateTime
AS

-- Variable Declarations
DECLARE @AcctDate         DateTime
DECLARE @Balance          Money
DECLARE @Barcode          VarChar(20)
DECLARE @CardRequired     Bit
DECLARE @CasinoID         VarChar(6)
DECLARE @CasinoMachNo     VarChar(8)
DECLARE @CasinoTransID    Int
DECLARE @CoinsBet         Int
DECLARE @CTBalance        Money
DECLARE @DealNo           Int
DECLARE @Debug            Bit
DECLARE @ErrorID          Int
DECLARE @ErrorSource      VarChar(64)
DECLARE @ErrorText        VarChar(1024)
DECLARE @ErrorDescription VarChar(256)
DECLARE @EventCode        VarChar(2)
DECLARE @EventLogDesc     VarChar(1024)
DECLARE @LinesBet         Int
DECLARE @LocationID       Int
DECLARE @LockupMachine    Int
DECLARE @MachineBal       Money
DECLARE @MachGameCode     VarChar(3)
DECLARE @MachNbrAsInt     Int
DECLARE @MachNo           VarChar(5)
DECLARE @MsgText          VarChar(2048)
DECLARE @NewPromoBalance       Money
DECLARE @PromoBalance     Money
DECLARE @RollNo           Int
DECLARE @TicketNo         Int
DECLARE @TierLevel        SmallInt
DECLARE @MachineTimeStamp DateTime
DECLARE @TransAmount      Money
DECLARE @TransID          SmallInt

SET NOCOUNT ON

-- Variable Initialization
SET @MachineTimeStamp = @TimeStamp
SET @Balance          = 0
SET @Barcode          = ''
SET @CardRequired     = 1
SET @CasinoMachNo     = ''
SET @CoinsBet         = 0
SET @CTBalance        = 0
SET @DealNo           = 0
SET @ErrorID          = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpTransVRRPV Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'SP'
SET @LinesBet         = 0
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachineBal       = CAST(@MachineBalance AS Money) / 100
SET @MachGameCode     = ''
SET @MachNbrAsInt     = CAST(@MachineNumber AS Int)
SET @PromoBalance     = 0
SET @RollNo           = 0
SET @TicketNo         = 0
SET @TierLevel        = 0
SET @TransAmount      = CAST(@TransAmt AS Money) / 100
SET @TransID          = 90
SET @TimeStamp        = GetDate()

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransVRRPV'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVRRPV Arguments - MachineNumber: ' + @MachineNumber +
         '  TransAmt: ' + CAST(@TransAmt AS VarChar(10)) +
         '  MachineBalance: ' + CAST(@MachineBalance AS VarChar(10)) +
         '  CardAccount: ' + @CardAccount
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve Casino Information.
SELECT
   @CasinoID     = CAS_ID,
   @CardRequired = PLAYER_CARD,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- If @CardRequired is 0 (TITO), set @CardAccount to 'INTERNAL'
IF (@CardRequired = 0)
   SET @CardAccount = 'INTERNAL'

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

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
         LAST_ACTIVITY = @TimeStamp,
         @CasinoMachNo = CASINO_MACH_NO,
         @MachGameCode = GAME_CODE,
         @PromoBalance = PROMO_BALANCE,
         @Balance      = BALANCE
      WHERE
         MACH_NO = @MachineNumber
      
      -- Calculate what the new Promotional Balance should be:
      -- (Add the transaction amount to the promo balance from MACH_SETUP).
      SET @NewPromoBalance = @PromoBalance + @TransAmount
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
      
      EXEC tpUpdatePlayStatsHourlyAndDaily 
      @LocationIdPass = @LocationID,
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AcctDate,
@DealNoPass = @DealNo,
@GameCodePass = @MachGameCode,
@PromoInCountPass = 1,
@PromoInAmountPass = @TransAmount
      
      -- Reset the BALANCE in the MACH_SETUP table.
      UPDATE MACH_SETUP SET PROMO_BALANCE = @NewPromoBalance WHERE MACH_NO = @MachineNumber
      
      -- Attempt to update the MACHINE_METER table.
      UPDATE MACHINE_METER SET
         TICKET_IN_COUNT = TICKET_IN_COUNT + 1,
         TICKET_IN_TOTAL = TICKET_IN_TOTAL + @TransAmount
      WHERE MACH_NO = @MachineNumber
      
      -- If no rows were modified, the record doesn't exist - so create it.
      IF (@@ROWCOUNT = 0)
         BEGIN
            INSERT INTO MACHINE_METER
               (MACH_NO, TICKET_IN_COUNT, TICKET_IN_TOTAL)
            VALUES
               (@MachineNumber, 1, @TransAmount)
         END
END

-- Calculate the CASINO_TRANS balance as the normal cashable
-- balance plus the incremented promotional balance.
SET @CTBalance = @Balance + @NewPromoBalance

-- Log transaction.
EXEC @CasinoTransID = tpInsertCasinoTrans
   @CasinoID, @DealNo, @RollNo, @TicketNo, 0, @TransAmount, @Barcode,
   @TransID, @AcctDate, @TimeStamp, @MachineNumber, @CardAccount,
   @CTBalance, @MachGameCode, @CoinsBet, @LinesBet, @TierLevel, 0, @LocationID, @MachineTimeStamp

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVRRPV Return Values - ErrorID: ' + CAST(@ErrorID AS VarChar) +
         '  ErrorDescription: ' + @ErrorDescription +
         '  LockupMachine: ' + CAST(@LockupMachine AS VarChar) +
         '  CasinoTransID: ' + CAST(@CasinoTransID AS VarChar)
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @CasinoTransID    AS CasinoTransNo
GO
