SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: tpTransP

Desc: Handles Progressive Amount requests.

Called by: Transaction Portal

Parameters:
   @MachineNumber       Char(5) Machine identifier
   @DenomBet            Int     Denomination of the Play expressed in cents
   @CoinsBet            Int     Number of Coins that were bet per Line
   @LinesBet            Int     Number of Lines played
   @ProgressivePoolID   Int     Progressive pool identifier
   @ResetPool           Bit     Indicates if the Progressive Pool Amount is to be reset

Author: Terry Watkins

Date: 02-28-2006

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 02-28-2006     v5.0.2
  Initial coding.

Terry Watkins 07-07-2006     v7.0.0
  ReWrite of this stored procedure.
  Replaced DealNumber argument with ProgressivePoolID.
  Changed argument @MachineDenomination to @DenomBet.
  Changed datatype of local var @AcctDate from VarChar(16) to DateTime.

Aldo Zamora  02-10-2010      v7.1.0
  Modified to record all transfer in and transfer out events in the POOL_EVENT
  table associated with a progressive win. Stores the POOL_EVENT_ID from the
  insert into the POOL_EVENT table and inserts that value into the into the
  PROGRESSIVE_CLAIMED table to link the rows from both tables.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.
  
Terry Watkins 08-10-2010     v7.2.3
  Added 'EXEC tpUpdatePoolContribution' to update pool contributions to this
  procedure. Aldo modified tpTransJ to NOT update Progressive pools or pool
  contributions if win is a progressive win.  Fixes issue of updating pool
  values twice.
  
Louis Epstein 04-10-2014     v3.2.1
  Added functionality to contribute to multi level progressive pools
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransP]
   @MachineNumber       Char(5),
   @DenomBet            Int,
   @CoinsBet            SmallInt,
   @LinesBet            SmallInt,
   @ProgressivePoolID   Int,
   @ResetPool           Bit = 0
AS

-- Variable Declarations
DECLARE @AcctDate           DateTime
DECLARE @BankNo             Int
DECLARE @CasinoMachNo       VarChar(8)
DECLARE @Debug              Bit
DECLARE @DenomAsMoney       Money
DECLARE @DenomBetAsSM       SmallMoney
DECLARE @ErrorID            Int
DECLARE @ErrorDescription   VarChar(256)
DECLARE @ErrorSource        VarChar(64)
DECLARE @EventCode          VarChar(2)
DECLARE @EventLogDesc       VarChar(1024)
DECLARE @GameCode           VarChar(3)
DECLARE @GTCodeBank         VarChar(2)
DECLARE @GTCodePP           VarChar(2)
DECLARE @GTTypeID           Char(1)
DECLARE @LockupMachine      Int
DECLARE @MachNbrAsInt       Int
DECLARE @MsgText            VarChar(2048)
DECLARE @PlayCost           Money
DECLARE @PPCoinsBet         SmallInt
DECLARE @PPLinesBet         TinyInt
DECLARE @PPDenom            Int
DECLARE @PPPool1            Money
DECLARE @PPPool2            Money
DECLARE @PPPool3            Money
DECLARE @PPWinLevel         Int
DECLARE @ProgTypeID         Int
DECLARE @PoolEventID        Int
DECLARE @PoolAmount         BigInt
DECLARE @TimeStamp          DateTime
DECLARE @TransID            Int

-- Variable Initialization
SET @DenomBetAsSM          = CAST(@DenomBet AS SmallMoney) / 100
SET @ErrorID               = 0
SET @ErrorDescription      = ''
SET @ErrorSource           = 'tpTransP Stored Procedure'
SET @EventCode             = 'SP'
SET @GTCodeBank            = ''
SET @LockupMachine         = 0
SET @MachNbrAsInt          = CAST(@MachineNumber AS Int)
SET @TimeStamp             = GetDate()
SET @TransID               = 64

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransP'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText = 'tpTransP Arguments -  MachineNumber: ' + @MachineNumber +
         '  DenomBet: '          + ISNULL(CAST(@DenomBet AS VarChar), '<null>') +
         '  CoinsBet: '          + ISNULL(CAST(@CoinsBet AS VarChar), '<null>') +
         '  LinesBet: '          + ISNULL(CAST(@LinesBet AS VarChar), '<null>') +
         '  ProgressivePoolID: ' + ISNULL(CAST(@ProgressivePoolID AS VarChar), '<null>') +
         '  ResetPool: '         + ISNULL(CAST(@ResetPool AS VarChar), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Get Current Accounting Date.
SET @AcctDate = [dbo].[ufnGetAcctDate]()

-- Check for existance, active, removed status of machine.
SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

-- Does the machine number exist in the MACH_SETUP table?
IF (@ErrorID <> 104)
   -- Yes, so retrieve the GameTypeCode of the Bank of the machine.
   SELECT
      @GTCodeBank   = BANK_GTC,
      @GTTypeID     = GT_TYPE_ID,
      @GameCode     = GAME_CODE,
      @BankNo       = BANK_NO,
      @CasinoMachNo = CASINO_MACH_NO
   FROM uvwMachineSetup
   WHERE MACH_NO = @MachineNumber

-- Any errors?
IF (@ErrorID = 0)
   BEGIN
      -- No, so update Last Activity for the machine.
      UPDATE MACH_SETUP SET LAST_ACTIVITY = @TimeStamp WHERE MACH_NO = @MachineNumber
      
      -- Does the requested Progressive Pool row exist?
      IF EXISTS(SELECT * FROM PROGRESSIVE_POOL WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID)
         BEGIN
            -- Yes, so retrieve ProgressivePool data.
            SELECT
               @ProgTypeID = PROGRESSIVE_TYPE_ID,
               @GTCodePP   = GAME_TYPE_CODE,
               @PPDenom    = DENOMINATION,
               @PPCoinsBet = COINS_BET,
               @PPLinesBet = LINES_BET,
               @PPPool1    = POOL_1,
               @PPPool2    = POOL_2,
               @PPPool3    = POOL_3,
               @PPWinLevel = WinLevel
            FROM PROGRESSIVE_POOL
            WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID
            
            -- If debugging, save retrieved values...
            IF (@Debug = 1)
               BEGIN
                  -- Build the debug message text.
                  SET @MsgText = 'tpTransP Retrieved Values - ProgTypeID: '  +
                      ISNULL(CAST(@ProgTypeID AS VarChar), '<null>') +
                      '  GTC_PP: '      + ISNULL(@GTCodePP, '<null>') +
                      '  Denom_PP: '    + ISNULL(CAST(@PPDenom AS VarChar), '<null>') +
                      '  CoinsBet_PP: ' + ISNULL(CAST(@PPCoinsBet AS VarChar), '<null>') +
                      '  LinesBet_PP: ' + ISNULL(CAST(@PPLinesBet AS VarChar), '<null>') +
                      '  Pool1: '       + ISNULL(CAST(@PPPool1 AS VarChar), '<null>') +
                      '  Pool2: '       + ISNULL(CAST(@PPPool2 AS VarChar), '<null>') +
                      '  Pool3: '       + ISNULL(CAST(@PPPool3 AS VarChar), '<null>') +
                      '  Bank GTC: '    + ISNULL(@GTCodeBank, '<null>') +
                      '  GT TYPE ID: '  + ISNULL(@GTTypeID, '<null>')
                  
                  -- Insert the debug text.
                  EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
               END
            
            -- Validate values
            IF (@GTCodePP   <>  @GTCodeBank) SET @ErrorID = 331
            IF (@PPDenom    <>  @DenomBet)   SET @ErrorID = 332
            
            IF (@PPWinLevel < 1)
            BEGIN
IF (@PPCoinsBet <>  @CoinsBet)   SET @ErrorID = 333
IF (@LinesBet   <>  @PPLinesBet) SET @ErrorID = 334
END
         END
      ELSE
         BEGIN
            -- Progressive data was not found for the specified ProgressivePoolID.
            SET @ErrorID = 330
         END
   END

-- Any errors?
IF (@ErrorID = 0)
   BEGIN
      -- Is the ResetPool flag set?
      IF (@ResetPool = 1)
         BEGIN
            -- Yes, so retrieve seed count and rates to calculate the new pool amounts...
            IF EXISTS(SELECT * FROM PROGRESSIVE_TYPE WHERE PROGRESSIVE_TYPE_ID = @ProgTypeID)
               BEGIN
                  
                  -- Convert Integer denom to Money.
                  SET @DenomAsMoney = CAST(@PPDenom AS Money) / 100
                  
                  -- Calculate the Play Cost.
                  IF (@GTTypeID <> 'K')
                     -- Non-Keno game.
                     SET @PlayCost = @DenomAsMoney * @CoinsBet * @LinesBet
                  ELSE
                     -- Keno game.
                     SET @PlayCost = @DenomAsMoney * @CoinsBet
                  
                  SELECT 
    @PoolAmount = CAST((POOL_1 + ((@PlayCost) * (Rate1 / 100))) * 100 AS bigint)
  FROM PROGRESSIVE_POOL
                  WHERE PROGRESSIVE_POOL_ID = @ProgressivePoolID
                  
                  EXEC UpdateProgressivePools @ProgTypeID, @AcctDate, @GTCodePP, @PPDenom, @PlayCost, @ProgressivePoolID, @TimeStamp

                  SELECT @PoolEventID = IDENT_CURRENT ('dbo.POOL_EVENT') - 6
                  
                  -- Log the claim event.
                  INSERT INTO PROGRESSIVE_CLAIMED
                     (POOL_EVENT_ID, MACH_NO, CASINO_MACH_NO, CLAIMED_DATE, ACCT_DATE, PROGRESSIVE_POOL_ID,
                      AMOUNT_CLAIMED, BANK_NO, GAME_CODE, DENOMINATION, COINS_BET, LINES_BET)
                  VALUES
                     (@PoolEventID, @MachineNumber, @CasinoMachNo, @TimeStamp, @AcctDate, @ProgressivePoolID,
                      CAST(@PoolAmount AS MONEY) / 100, @BankNo, @GameCode, @DenomBetAsSM, @CoinsBet, @LinesBet)
                  
                  -- If debugging, save values...
                  IF (@Debug = 1)
                     BEGIN
                        SET @MsgText = 'tpTransP ResetPool is True - PlayCost: ' +
                            ISNULL(CAST(@PlayCost AS VarChar), '<null>') +
                            '  New Pool1 value: ' + ISNULL(CAST(@PPPool1 AS VarChar), '<null>') +
                            '  New Pool2 value: ' + ISNULL(CAST(@PPPool2 AS VarChar), '<null>') +
                            '  New Pool3 value: ' + ISNULL(CAST(@PPPool3 AS VarChar), '<null>')
                        
                        EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
                     END
               END
            ELSE
               -- PROGRESSIVE_TYPE row was not found.
               BEGIN
                  SET @ErrorID = 335
               END
         END
   END

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      -- Reset the Progressive Pool amount being returned to zero.
      SET @PoolAmount = 0
      
      -- Does the ErrorID value exist in ERROR_LOOKUP?
      IF EXISTS(SELECT * FROM ERROR_LOOKUP WHERE ERROR_NO = @ErrorID)
         BEGIN
            -- Yes, so retrieve ERROR_LOOKUP table information.
            SELECT
               @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
               @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
            FROM ERROR_LOOKUP
            WHERE ERROR_NO = @ErrorID
         END
      ELSE
         BEGIN
            -- No, so manually set error information.
            SET @ErrorDescription = 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))
            SET @LockupMachine = 1
         END
      
      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription + ', Machine Number: ' + @MachineNumber
      
      -- Test if the Machine should be loocked up.
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
      
      -- Update Machine_Last_Play
      UPDATE MACH_LAST_PLAY SET ERROR_NO = @ErrorID WHERE MACH_NO = @MachineNumber
   END

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText = 'tpTransP Return Values - ErrorID: ' + ISNULL(CAST(@ErrorID AS VarChar), '<null>') +
         '  ErrorDescription: ' + ISNULL(@ErrorDescription, '<null>') +
         '  LockupMachine: '    + ISNULL(CAST(@LockupMachine AS VarChar), '<null>') +
         '  ProgressivePool: '  + ISNULL(CAST(@PoolAmount AS VarChar), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID           AS ErrorID,
   @ErrorDescription  AS ErrorDescription,
   @LockupMachine     AS ShutDownFlag,
   @PoolAmount        AS ProgressiveAmount
GO
