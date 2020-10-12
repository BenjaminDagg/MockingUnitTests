SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: tpSAS_TransferDone user stored procedure.

  Created: 07-31-2008 by Terry Watkins

  Purpose: Records balance transfers to or from the EGM and SAS Host system

Arguments: 
   @MachineNbr             Machine number
   @CardAccount            Card Account Number
   @MachineBalance         Machine balance after transfer
   @PromoBalance           Promo balance after transfer
   @MachineBalanceTransAmt Amount of machine transfer
   @PromoBalanceTransAmt   Amount of Promo transfer
   @TransferDirection      0 = Host to EGM, 1 = EGM to Host

Change Log:

Date       By                Database version
  Change Description
--------------------------------------------------------------------------------
07-31-2008 Terry Watkins     v6.0.2
  Initial coding

Terry Watkins 11-03-2009     v7.0.0
  Added code to disallow balance adjustments that exceed the value set in
  CASINO.MAX_BAL_ADJUSTMENT.
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.
  
Louis Epstein 06-18-2014     v3.2.3
  Modified stat recording functionality to use tpUpdatePlayStatsHourlyAndDaily
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpSAS_TransferDone]
   @MachineNumber          Char(5),
   @CardAccount            VarChar(20),
   @MachineBalance         Int,
   @PromoBalance           Int,
   @MachineBalanceTransAmt Int,
   @PromoBalanceTransAmt   Int,
   @TransferDirection      Bit
AS

-- SET NOCOUNT ON added to suppress return of unwanted stats
SET NOCOUNT ON

-- Variable Declarations
DECLARE @AccountingDate     DateTime
DECLARE @Balance            Money
DECLARE @Barcode            VarChar(128)
DECLARE @CardRequired       Bit
DECLARE @CasinoID           VarChar(6)
DECLARE @CasinoMachNo       VarChar(8)
DECLARE @CoinsBet           Int
DECLARE @DealNo             Int
DECLARE @Debug              Bit
DECLARE @ErrorDescription   VarChar(256)
DECLARE @ErrorID            Int
DECLARE @ErrorSource        VarChar(64)
DECLARE @ErrorText          VarChar(1024)
DECLARE @EventCode          VarChar(2)
DECLARE @EventLogDesc       VarChar(1024)
DECLARE @LinesBet           Int
DECLARE @LockupMachine      Int
DECLARE @MachGameCode       Char(3)
DECLARE @MachineBalDollars  Money
DECLARE @MachineDenom       SmallMoney
DECLARE @MachNbrAsInt       Int
DECLARE @MaxBalAdjust       Money
DECLARE @MsgText            VarChar(2048)
DECLARE @NewBalanceEGM      Money
DECLARE @NewBalancePromo    Money
DECLARE @PressUpCount       SmallInt
DECLARE @PromoBalDollars    Money
DECLARE @RollNo             Int
DECLARE @SysPromoBalance    Money
DECLARE @TicketNo           Int
DECLARE @TierLevel          SmallInt
DECLARE @TimeStamp          DateTime
DECLARE @ToTime             DateTime
DECLARE @TpiID              Int
DECLARE @TransAmt           Money
DECLARE @TransID            Int
DECLARE @TransDollarsEGM    Money
DECLARE @TransDollarsPromo  Money
DECLARE @LocationID int

-- Variable Initialization
SET @MachineBalDollars  = CAST(@MachineBalance AS MONEY) / 100          -- Machine balance that the machine reported converted to money
SET @PromoBalDollars    = CAST(@PromoBalance AS MONEY) / 100            -- Promo balance that the machine reported converted to money
SET @TransDollarsPromo  = CAST(@PromoBalanceTransAmt AS MONEY) / 100    -- Promo transaction amount reported by the machine converted to money
SET @TransDollarsEGM    = CAST(@MachineBalanceTransAmt AS MONEY) / 100  -- Machine transaction amount reported by the machine converted to money
SET @TransAmt           = @TransDollarsEGM + @TransDollarsPromo         -- Total transaction amount

SET @Balance            = 0
SET @Barcode            = ''
SET @CoinsBet           = 0
SET @DealNo             = 0
SET @ErrorDescription   = ''
SET @ErrorSource        = 'tpSAS_TransferDone Stored Procedure'
SET @ErrorText          = ''
SET @EventCode          = 'SP'
SET @EventLogDesc       = ''
SET @LinesBet           = 0
SET @LockupMachine      = 0
SET @MachineDenom       = 0
SET @MachNbrAsInt       = CAST(@MachineNumber AS Int)
SET @PressUpCount       = 0
SET @RollNo             = 0
SET @SysPromoBalance    = 0
SET @TicketNo           = 0
SET @TierLevel          = 0
SET @TimeStamp          = GetDate()
SET @TransID            = 80 + CAST(@TransferDirection AS Int)
SET @LocationID = 0


-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpSAS_TransferDone'

-- If Debug mode, save argument values...
IF (@Debug = 1)
   -- Record argument values.
   BEGIN
      SET @MsgText =
         'tpSAS_TransferDone Argument Values:  ' + 
         '  MachineNumber: '          + ISNULL(@MachineNumber, '<null>') +
         '  CardAccount: '            + ISNULL(@CardAccount, '<null>') +
         '  MachineBalance: '         + ISNULL(CAST(@MachineBalance AS VarChar), '<null>') +
         '  PromoBalance: '           + ISNULL(CAST(@PromoBalance AS VarChar), '<null>') +
         '  MachineBalanceTransAmt: ' + ISNULL(CAST(@MachineBalanceTransAmt AS VarChar), '<null>') +
         '  PromoBalanceTransAmt: '   + ISNULL(CAST(@PromoBalanceTransAmt AS VarChar), '<null>') +
         '  TransferDirection: '      + ISNULL(CAST(@TransferDirection AS VarChar), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve CASINO information.
SELECT
   @CasinoID      = CAS_ID,
   @ToTime        = TO_TIME,
   @CardRequired  = PLAYER_CARD,
   @TpiID         = TPI_ID,
   @MaxBalAdjust  = MAX_BAL_ADJUSTMENT,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- If @CardRequired is 0 (TITO), set @CardAccount to 'INTERNAL'
IF (@CardRequired = 0)
   SET @CardAccount = 'INTERNAL'

-- If Card Account is null or empty, set it to 'INVALID'.
IF (ISNULL(@CardAccount, '') = '')
   SET @CardAccount = 'INVALID'

-- Get Current Accounting Date.
SET @AccountingDate = dbo.ufnGetAcctDate()

-- Check for existance, active, removed status of machine.
SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

-- If the MACH_SETUP row was found, retrieve Machine information.
IF (@ErrorID <> 104)
   SELECT
      @MachGameCode    = GAME_CODE,
      @Balance         = BALANCE,
      @SysPromoBalance = PROMO_BALANCE,
      @CasinoMachNo    = CASINO_MACH_NO
   FROM MACH_SETUP
   WHERE MACH_NO = @MachineNumber

-- Is a player card required?
IF (@CardRequired = 1)
   -- Yes, does the card account exist?
   IF EXISTS (SELECT * FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAccount)
      -- Yes, retrieve the machine balance from the CARD_ACCT table.
      SELECT @Balance = BALANCE FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAccount
   ELSE
      -- Card Account row not found, must be an invalid card.
      SET @ErrorID = 102

-- Are we still error free?
IF (@ErrorID = 0)
   -- Yes, is the TPI_ID value in the CASINO table is 4 (SAS)?
   IF (@TpiId <> 4)
      -- No, so the TransferDone event should not be occurring...
      BEGIN
         SET @ErrorID = 301
         SET @ErrorText = ', TPI identifier in the Casino table is not SAS.'
      END

-- Are we still error free?
IF (@ErrorID = 0)
   BEGIN
      IF (@TransferDirection = 0)
         -- Transfer direction is Host to EGM.
         BEGIN
            -- Calculate the new machine and promo balances...
            SET @NewBalanceEGM = @Balance + @TransDollarsEGM
            SET @NewBalancePromo = @SysPromoBalance + @TransDollarsPromo
            
            -- Validate new promo and egm balances...
            IF (@NewBalancePromo <> @PromoBalDollars)
               BEGIN
                  SET @ErrorID = 302
                  SET @ErrorText = ', EGM to System Promo Balance mismatch (Host to EGM transfer). EGM reported ' +
                                   CAST(@PromoBalDollars AS VarChar) + ' - System calculates ' +
                                   CAST(@NewBalancePromo AS VarChar) + '.'
               END
            ELSE IF (@NewBalanceEGM <> @MachineBalDollars)
               -- The calculated machine balance does not match what the machine reported.
               BEGIN
                  SET @ErrorID = 303
                  SET @ErrorText = ', EGM to System Machine Balance mismatch (Host to EGM transfer). EGM reported ' +
                                   CAST(@MachineBalDollars AS VarChar) + ' - System calculates ' +
                                   CAST(@NewBalanceEGM AS VarChar) + '.'
               END
         END
      ELSE
         -- Transfer direction is EGM to Host.
         BEGIN
            -- Calculate the new machine and promo balances...
            SET @NewBalanceEGM = @Balance - @TransDollarsEGM
            SET @NewBalancePromo = @SysPromoBalance - @TransDollarsPromo
            
            -- Validate new promo and egm balances...
            IF (@NewBalancePromo <> @PromoBalDollars)
               BEGIN
                  SET @ErrorID = 302
                  SET @ErrorText = ', EGM to System Promo Balance mismatch (EGM to Host transfer). EGM reported ' +
                                   CAST(@PromoBalDollars AS VarChar) + ' - System calculates ' +
                                   CAST(@NewBalancePromo AS VarChar) + '.'
               END
            ELSE IF (@NewBalanceEGM <> @MachineBalDollars)
               -- The calculated machine balance does not match what the machine reported.
               BEGIN
                  SET @ErrorID = 303
                  SET @ErrorText = ', EGM to System Machine Balance mismatch (EGM to Host transfer). EGM reported ' +
                                   CAST(@MachineBalDollars AS VarChar) + ' - System calculates ' +
                                   CAST(@NewBalanceEGM AS VarChar) + '.'
               END
            ELSE IF (@NewBalancePromo < 0)
               BEGIN
                  SET @ErrorID = 304
                  SET @ErrorText = ', (EGM to Host transfer) Calculated PromoBalance is ' +
                                   CAST(@NewBalancePromo AS VarChar) + '.'
               END
            ELSE IF (@NewBalanceEGM < 0)
               BEGIN
                  SET @ErrorID = 305
                  SET @ErrorText = ', (EGM to Host transfer) Calculated Machine Balance is ' +
                                   CAST(@NewBalanceEGM AS VarChar) + '.'
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
      
      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription +
                          '  Error ID: ' + CAST(@ErrorID AS VarChar) +
                          ', Card Account: ' + @CardAccount +
                          ', Machine Number: ' + @MachineNumber +
                          ', Casino Machine Number: ' + ISNULL(@CasinoMachNo, '<null>')
      
      IF (LEN(@ErrorText) > 0)
         SET @EventLogDesc = @EventLogDesc + @ErrorText
      
      -- Test if the Machine should be loocked up.
      IF (@LockupMachine <> 0)
         BEGIN
            -- Reset ACTIVE_FLAG to 0 if ACTIVE_FLAG is 1.
            UPDATE MACH_SETUP
            SET ACTIVE_FLAG = 0
            WHERE MACH_NO = @MachineNumber AND ACTIVE_FLAG = 1
            
            -- Reset casino event log event code to 'shut down'
            SET @EventCode = 'SD'
         END
      
      -- Insert Error into the Casino_Event_Log
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)
      
      -- Update Machine_Last_Play
      UPDATE MACH_LAST_PLAY SET ERROR_NO = @ErrorID WHERE MACH_NO = @MachineNumber
   END

-- Are we still error free?
IF (@ErrorID = 0)
   BEGIN
      -- Update the machine record...
      UPDATE MACH_SETUP SET
         BALANCE       = @MachineBalDollars,
         PROMO_BALANCE = @PromoBalDollars,
         LAST_ACTIVITY = @TimeStamp
      WHERE MACH_NO = @MachineNumber
      
      
      
      -- Now there is a MACHINE_STATS row to update and the PK identifier value is stored in @MachineStatsID...
      IF (@TransferDirection = 0)
         -- Transfer direction is Host to EGM so update the EFT IN column values...
         BEGIN
            -- Update EFT_IN columns...
            IF (@TransDollarsEGM > 0)
               EXEC tpUpdatePlayStatsHourlyAndDaily 
               @LocationIdPass = @LocationID,
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AccountingDate,
@DealNoPass = 0,
@GameCodePass = @MachGameCode,
@EftInAmountPass = @TransDollarsEGM,
@EftInCountPass = 1


            
            -- Update EFT_PROMO_IN columns...
            IF (@TransDollarsPromo > 0)
               EXEC tpUpdatePlayStatsHourlyAndDaily 
               @LocationIdPass = @LocationID,
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AccountingDate,
@DealNoPass = 0,
@GameCodePass = @MachGameCode,
@EftPromoInAmountPass = @TransDollarsPromo,
@EftPromoInCountPass = 1
         END
      ELSE
         -- Transfer direction is EGM to Host so update the EFT OUT column values...
         BEGIN
            -- Update EFT_OUT columns...
            IF (@TransDollarsEGM > 0)
               EXEC tpUpdatePlayStatsHourlyAndDaily 
               @LocationIdPass = @LocationID,
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AccountingDate,
@DealNoPass = 0,
@GameCodePass = @MachGameCode,
@EftOutAmountPass = @TransDollarsEGM,
@EftOutCountPass = 1
            
            -- Update EFT_PROMO_OUT columns...
            IF (@TransDollarsPromo > 0)
               EXEC tpUpdatePlayStatsHourlyAndDaily 
               @LocationIdPass = @LocationID,
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AccountingDate,
@DealNoPass = 0,
@GameCodePass = @MachGameCode,
@EftPromoOutAmountPass = @TransDollarsPromo,
@EftPromoOutCountPass = 1
         END
   END

-- Are we in cardless play mode?
IF (@CardRequired = 0)
   -- Yes, so if machine or promo balance from the machine does not agree with system,
   -- then we will adjust the system to match the machine if values are not negative.
   BEGIN
      -- If the machine balance is not negative and also not the same as the system balance,
      -- then adjust the system balance (assumes that the balance from the machine is correct).
      IF (@NewBalanceEGM > 0 AND @MachineBalDollars <> @NewBalanceEGM)
         BEGIN
            IF ((@MachineBalDollars - @NewBalanceEGM) < @MaxBalAdjust)
               BEGIN
                  EXEC tpAdjustMachineBalance
                     @MachineNumber, @CardRequired, @MachineBalDollars, @NewBalanceEGM,
                     'tpSAS_TransferDone', @TimeStamp, @CasinoID, @AccountingDate, @MachGameCode, @LocationID
               END
            ELSE
               BEGIN
                  -- Balance is off but over adjustment threshhold, set the lockup flag.
                  SET @LockupMachine = 1
               END
         END
      
      -- If the promo balance is not negative and also not the same as the system promo balance,
      -- then adjust the system promo balance (assumes that the promo balance from machine is correct).
      IF (@PromoBalDollars > 0 AND @PromoBalDollars <> @NewBalancePromo)
         BEGIN
            IF ((@PromoBalDollars - @NewBalancePromo) < @MaxBalAdjust)
               BEGIN
                  EXEC tpAdjustMachinePromoBalance
                     @MachineNumber, @CardRequired, @PromoBalDollars, @NewBalancePromo,
                     'tpSAS_TransferDone', @TimeStamp, @CasinoID, @AccountingDate, @MachGameCode, @LocationID
               END
            ELSE
               BEGIN
                  -- Promo Balance is off but over adjustment threshhold, set the lockup flag.
                  SET @LockupMachine = 1
               END
         END
   END

-- Log transaction.
IF (@ErrorID = 0)
   BEGIN
      -- The balance recorded in CASINO_TRANS is the sum of the egm and promo balances.
      SET @Balance = @NewBalanceEGM + @NewBalancePromo
      
      -- Record the transfer...
      EXEC tpInsertCasinoTrans
         @CasinoID, @DealNo, @RollNo, @TicketNo, @MachineDenom, @TransAmt, @Barcode,
         @TransID, @AccountingDate, @TimeStamp, @MachineNumber, @CardAccount,
         @Balance, @MachGameCode, @CoinsBet, @LinesBet, @TierLevel, @PressUpCount
   END

-- Return standard resultset to caller.
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag
GO
