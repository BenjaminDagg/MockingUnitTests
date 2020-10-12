SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpTransR

Created 07-14-2003 by Chris Coddington

Desc: Handles all requests for setup.

Return values: Multiple Result sets with Machine and Game setup information.

Called by: Transaction Portal

Parameters:
   @MachineNumber  Machine Number (identifier)
   @TpVersion      Release # of the TP in the form MajorVersion.YY.MMDD.Sequence#

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 10-17-2003
  Cast Lockup amount as money to avoid an overflow when the lockup amount has
  a large value in the second SELECT statement.

Terry Watkins 06-30-2004
  Appended a delimiter ('^') + CASINO_MACH_NO to the MachineModelDescription
  value that is returned.

Terry Watkins 06-30-2004     v4.0.0
  Added retrieval of selected values from the TPI_SETTTING table if the TPI_ID
  is 1 (SDG).

Ashok Murthy 03-10-2005      v4.0.1
  Added retrieval of new column GAME_TYPE.SHOW_PAY_CREDITS.  This flag tells
  a machine to display payscale and win amounts in Credits or Dollars.

Terry Watkins 06-15-2005     v4.1.4
  Added logic to select payscale tier data for new Keno game from the new
  PAYSCALE_TIER_KENO table.
  Simplified the WHERE clauses when selecting from Payscale, Payscale_Tier,
  or Payscale_Tier_Keno by retrieving the PAYSCALE_NAME in the initial select.

A. Murthy     08-19-2005     v4.2.0
  Added new 5th select on the MACHINE_MESSAGE table to support ** NEW ** "R"
  trans format. The 1st & 2nd select now return Key=Value pairs. The 5th select
  also returns Count & Key=Value pairs.
  All data is now returned combined and pre-separated with commas.

Terry Watkins 10-15-2005     v4.2.4
  Modified the award amount for Keno payscale tiers to factor in the
  minimum possible denomination for the Game Type since the game has changed
  and is no longer limited to a 10 cent denom.

A. Murthy     11-04-2005     v5.0.0
  Added argument @TpVersion which is returned in Select_1
  Added "AND TPI_ID <>2" to filter out MGAM data from TpiSettingCursor.
  Added "NumCoinBetLevels" & "NumLineBetLevels" to "Select_1".
  Added "Select_5" to output Coin Bet Level collection.
  Added "Select_6" to output Line Bet Level collection.

Terry Watkins 12-01-2005     v5.0.0
  Added retrieval of ProductLine and GameClass to Select_1

A. Murthy     01-09-2006     v5.0.1
  Added "JackpotLockup", "CashoutTimeOut", "LotteryVariableCount" to Select_1.
  Added "Select_7" which calls new function GetIowaLotteryParms to obtain values
  from TPI_SETTING table.

A. Murthy     03-15-2006     v5.0.2
  Added "IsProgressive" (=BANK.PROG_FLAG) to Select_1.
  Added IF statement to retrieve different values from TPI_SETTING tbl for
  DGE_TITO/MGAM & SDG.

Terry Watkins 05-18-2006     v5.0.3
  Modified concatenation for select 1 to be a little more effecient
  (done mainly to force this proc into the 502 to 503 schema update script).

Terry Watkins 05-18-2006     v5.0.4
  Added retrieval of AUTO_DROP flag from the CASINO table.  This flag tells the
  machine whether or not drop events are triggered when the Cash Door is opened.
  
  Added logic to restrict the number of Payscale Tiers to 20 for the 9 Reel
  8 Line games.

  Added retrieval of new GAME_SETUP.GAME_TITLE_ID column value and return
  GameTitleID=Value key/value pair in Select1.

Terry Watkins 08-11-2006     v5.0.5
  Added retrieval of PRINT_ENTRY_TICKET flag and ENTRY_TICKET_FACTOR value from
  the BANK table.  This flag tells the machine whether or not to print
  promotional entry tickets and the value is the number of plays after which an
  entry ticket is created if the flag is set.

Terry Watkins 06-14-2006     v5.0.6
   Changed @CasinoMachineNumber from VarChar(5) to VarChar(8)

A. Murthy     09-01-2006     v5.0.7
  Removed "LotteryVariableCount" & SELECT_7 as these were from Iowa Lottery.

A. Murthy     09-29-2006     v5.0.8
  Added retrieval of new CASINO.REPRINT_TICKET column value and return
  ReprintTicket=Value key/value pair in Select1.

Terry Watkins 12-07-2006     v5.0.8
   Added ISNULL checks to prevent Select_1 from returning NULL if there are
   null values in the CASINO table.
   
   Changed the logic that limits the number of tiers sent to a machine
   so that it evaluates the GameTitleID.  Made that logic data-driven by
   performing a lookup on the CASINO_SYSTEM_PARAMETERS table.

Terry Watkins 05-25-2007     v6.0.1
  Added ClaimTimeout, DaubTimeout, and FreeSquareDisplay, DBALockupAmt to Select_1.

A. Murthy     12-19-2007     v6.0.2
  Moved retrieval of LOCKUP_AMOUNT from the CASINO table to BANK table for this
  MachineNumber and use it to initialize @CasinoLockupAmount.

Terry Watkins 08-07-2008     v6.0.2
  Modified logic so TpiSettingCursor is created when TPI_ID = 4.
  Added retrieval of 2 new Casino table columns (PRINT_REDEMPTION_TICKETS and
  PRINT_RAFFLE_TICKETS).
  Added retrieval of Prize Redemption message from CASINO_SYSTEM_PARAMETERS.

Terry Watkins 03-20-2009     v6.0.4
  Added payscale tier overflow check.

Terry Watkins 03-20-2009     v6.0.5
  Added MaxCoinsWon and MaxTierLevel to Select_1 so machines can check that
  their decryption routines are not returning invalid values.  Also added
  IsBuyAPay flag.

Terry Watkins 07-06-2009     v7.0.0
  Added ProgressiveTypeID, GameCategoryID, BarcodeTypeID, ProductID and
  ProgRequstSeconds to Select_1.
  Removed IsProgressive from Select_1 (EGM can use ProgressiveTypeID value).
  Changed the logic that limited the number of returned payscale tiers from
  doing a CASINO_SYSTEM_PARAMETERS lookup (PARAM38) to using flag value of
  GAME_CATEGORY.LIMIT_RTRANS_TIERS.

Terry Watkins 07-06-2009     v7.0.0
  Fixed calculation of @PayscaleTierCount (when less than 20 and limit is true)
  
Terry Watkins 07-06-2009     v7.2.4
  Added retrieval of ActiveFlag from MACH_SETUP to Select_1.
  
Terry Watkins 04-18-2011     LotteryRetail v2.0.1
  Added retrieval OF minimum hold per denom AS Select_7
  Modified all Selects TO return '<null>,' instead or NULL.
  
Louis Epstein 10-01-2013     LotteryRetail v3.1.5
  Added TicketNumOnError to indicated ticket number in tab error functionality.
  
Louis Epstein 10-10-2013     LotteryRetail v3.1.5
  Added SendDoorState for reporting door closed transactions.
  
Louis Epstein 03-24-2014     LotteryRetail v3.2.0
  Added LogEntryTickets for loggin promo entry tickets
  
Louis Epstein 06-24-2014     LotteryRetail v3.2.3
  Added ReelAnimationTypeID functionality
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransR]
   @MachineNumber VarChar(5), 
   @TpVersion     VarChar(20) = 'Unknown'
AS

DECLARE @CasinoMachineNumber        VarChar(8)
DECLARE @CasinoName                 VarChar(31)
DECLARE @CSPValue1                  VarChar(64)
DECLARE @CSPValue2                  VarChar(64)
DECLARE @CSPValue3                  VarChar(64)
DECLARE @CursorResults              VarChar(8000)
DECLARE @GameTypeCode               VarChar(8)
DECLARE @IconMask                   VarChar(32)
DECLARE @Icons                      VarChar(32)
DECLARE @MachineIpAddress           VarChar(24)
DECLARE @MachineGameCode            VarChar(16)
DECLARE @MachineModelDescription    VarChar(64)
DECLARE @MachinePrizeMessage        VarChar(256)
DECLARE @Message                    VarChar(256)
DECLARE @MessageParameters          VarChar(2048)
DECLARE @HoldsByDenom               VarChar(512)
DECLARE @PayscaleName               VarChar(16)
DECLARE @PlayerTracking             VarChar(10)
DECLARE @TempString                 VarChar(512)

DECLARE @TimeStamp                  DateTime

DECLARE @DealTypeCode               Char(1)

DECLARE @AutoDrop                   Bit
DECLARE @BingoFreeSquare            Bit
DECLARE @EntryTicketOn              Bit
DECLARE @IsBuyAPay                  Bit
DECLARE @JackpotLockup              Bit
DECLARE @LimitPSTiers               Bit
DECLARE @MachineIsPaper             Bit
DECLARE @RaffleTicketOn             Bit
DECLARE @RedeemTicketOn             Bit
DECLARE @ReprintTicket              Bit
DECLARE @ShowPayCredits             Bit
DECLARE @LogPromoTickets             Bit

DECLARE @ActiveFlag                 TinyInt
DECLARE @CasinoCardType             TinyInt
DECLARE @ScatterCount               TinyInt
DECLARE @TierWinType                TinyInt

DECLARE @BarcodeTypeID              SmallInt
DECLARE @ClaimTimeout               SmallInt
DECLARE @DaubTimeout                SmallInt
DECLARE @GameClass                  SmallInt
DECLARE @ProductID                  SmallInt
DECLARE @ProductLine                SmallInt
DECLARE @ProgReqSeconds             SmallInt
DECLARE @TierLevel                  SmallInt

DECLARE @CashoutTimeout             Int
DECLARE @CasinoLockupAmount         Int
DECLARE @CoinsWon                   Int
DECLARE @CountEqualSign             Int
DECLARE @DBALockupAmt               Int
DECLARE @DenomCount                 Int
DECLARE @DefaultCasinoCount         Int
DECLARE @EntryTicketLimit           Int
DECLARE @EntryTicketAmountLimit smallmoney
DECLARE @EqualSign                  Int
DECLARE @FieldsPerTier              Int
DECLARE @FormCount                  Int
DECLARE @GameCategoryID             Int
DECLARE @GameMaxCoinsBet            Int
DECLARE @GameMaxLinesBet            Int
DECLARE @GameTitleID                Int
DECLARE @MachineMessageID           Int
DECLARE @MaxCoinsWon                Int
DECLARE @MaxTierLevel               Int
DECLARE @MessageCount               Int
DECLARE @MinDenom                   Int
DECLARE @NumCoinBetLevels           Int
DECLARE @NumLineBetLevels           Int
DECLARE @PayscaleTierCount          Int
DECLARE @PlayerTrackingEnabled      Int
DECLARE @ProgressiveTypeID          Int
DECLARE @SystemType                 Int
DECLARE @TierCount                  Int
DECLARE @TpiSystem                  Int
DECLARE @VariableCount              INT
DECLARE @ReelAnimationTypeID int

DECLARE @MinFormHold                Decimal(7,4)
DECLARE @MinGameTypeHold            Decimal(7,4)

DECLARE @DenomValue                 SmallMoney

SET NOCOUNT ON

-- Variable Initialization.
SET @CursorResults       = ''
SET @MachinePrizeMessage = ''
SET @HoldsByDenom        = ''
SET @TempString          = ''
SET @TierCount           = 0
SET @VariableCount       = 0

-- Store the current system Date and Time.
SET @TimeStamp = GetDate()

-- Update MACH_SETUP.LAST_ACTIVITY.
UPDATE MACH_SETUP SET LAST_ACTIVITY = @TimeStamp WHERE MACH_NO = @MachineNumber

SELECT @DefaultCasinoCount = COUNT(*) FROM CASINO WHERE SETASDEFAULT = 1
IF @DefaultCasinoCount <> 1
   BEGIN
      -- Return error in select 1 and empty strings for 2-6
      IF @DefaultCasinoCount = 0
         SELECT 'No default Casino has been setup.' AS Select_1
      ELSE
         SELECT 'Multiple default Casinos have been setup.' AS Select_1

      SELECT '' AS Select_2
      SELECT '' AS Select_3
      SELECT '' AS Select_4
      SELECT '' AS Select_5
      SELECT '' AS Select_6
      SELECT '' AS Select_7
      RETURN -1
   END

-- Retrieve Machine, Bank, and GameType info.
SELECT
   @MachineIpAddress        = ms.IP_ADDRESS, 
   @MachineGameCode         = ms.GAME_CODE, 
   @MachineModelDescription = LEFT(ms.MODEL_DESC, 55),
   @CasinoMachineNumber     = ms.CASINO_MACH_NO,
   @ActiveFlag              = ms.ACTIVE_FLAG,
   @MachineIsPaper          = b.IS_PAPER,
   @ProductLine             = b.PRODUCT_LINE_ID,
   @EntryTicketLimit        = b.ENTRY_TICKET_FACTOR,
   @EntryTicketAmountLimit = b.ENTRY_TICKET_AMOUNT,
   @DBALockupAmt            = CAST(b.DBA_LOCKUP_AMOUNT * 100 AS INTEGER),
   @CasinoLockupAmount      = CAST((CAST(b.LOCKUP_AMOUNT AS MONEY) * 100) AS INTEGER),
   @GameMaxCoinsBet         = gt.MAX_COINS_BET,
   @GameMaxLinesBet         = gt.MAX_LINES_BET,
   @GameTypeCode            = gt.GAME_TYPE_CODE,
   @ShowPayCredits          = gt.SHOW_PAY_CREDITS,
   @DealTypeCode            = gt.TYPE_ID,
   @ProductID               = gt.PRODUCT_ID,
   @GameTitleID             = gs.GAME_TITLE_ID,
   @PayscaleName            = ps.PAYSCALE_NAME,
   @GameClass               = pl.GAME_CLASS,
   @ProgressiveTypeID       = gt.PROGRESSIVE_TYPE_ID,
   @GameCategoryID          = gt.GAME_CATEGORY_ID,
   @BarcodeTypeID           = gt.BARCODE_TYPE_ID,
   @LimitPSTiers            = gc.LIMIT_RTRANS_TIERS,
   @IsBuyAPay               = dbo.ufnIsBuyAPayGame(gt.GAME_TYPE_CODE)
FROM MACH_SETUP ms
   JOIN BANK            b ON ms.BANK_NO = b.BANK_NO
   JOIN GAME_TYPE      gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   JOIN GAME_SETUP     gs ON ms.GAME_CODE = gs.GAME_CODE
   JOIN PAYSCALE       ps ON gt.GAME_TYPE_CODE = ps.GAME_TYPE_CODE
   JOIN PRODUCT_LINE   pl ON b.PRODUCT_LINE_ID = pl.PRODUCT_LINE_ID
   JOIN GAME_CATEGORY  gc ON gt.GAME_CATEGORY_ID = gc.GAME_CATEGORY_ID
WHERE ms.MACH_NO = @MachineNumber

-- Retrieve Casino info.
SELECT
   @CasinoName               = ISNULL(LEFT(CAS_NAME, 31), '<null>'),
   @CasinoCardType           = ISNULL(CARD_TYPE, 1),
   @SystemType               = PLAYER_CARD,
   @TpiSystem                = TPI_ID,
   @JackpotLockup            = JACKPOT_LOCKUP,
   @CashoutTimeout           = CASHOUT_TIMEOUT,
   @AutoDrop                 = AUTO_DROP,
   @EntryTicketOn            = PRINT_PROMO_TICKETS,
   @ReprintTicket            = ISNULL(REPRINT_TICKET, 0),
   @RedeemTicketOn           = PRINT_REDEMPTION_TICKETS,
   @RaffleTicketOn           = PRINT_RAFFLE_TICKETS,
   @BingoFreeSquare          = BINGO_FREE_SQUARE,
   @ClaimTimeout             = CLAIM_TIMEOUT,
   @DaubTimeout              = DAUB_TIMEOUT,
   @ProgReqSeconds           = PROG_REQUEST_SECONDS
FROM CASINO WHERE SETASDEFAULT = 1

-- Retrieve and build the Machine Prize Redemption message.
IF (@RedeemTicketOn = 1)
   BEGIN
      IF EXISTS(SELECT * FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'MACHMSGREDEEM')
         BEGIN
            SELECT
               @CSPValue1 = ISNULL(VALUE1, ''),
               @CSPValue2 = ISNULL(VALUE2, ''),
               @CSPValue3 = ISNULL(VALUE3, '')
            FROM CASINO_SYSTEM_PARAMETERS
            WHERE PAR_NAME = 'MACHMSGREDEEM'
            
            -- Build the message, use '\r' for linefeeds...
            SET @MachinePrizeMessage = @CSPValue1
            IF (LEN(@CSPValue2) > 0) SET @MachinePrizeMessage = @MachinePrizeMessage + '%r' + @CSPValue2
            IF (LEN(@CSPValue3) > 0) SET @MachinePrizeMessage = @MachinePrizeMessage + '%r' + @CSPValue3
         END
      ELSE
         SET @MachinePrizeMessage = 'Remit Ticket to Cashier%rfor Internet Time Redemption.'
   END
ELSE
   SET @MachinePrizeMessage = 'Off'

-- Make sure @MachinePrizeMessage does not contain comma characters.
IF CHARINDEX(',',  @MachinePrizeMessage, 1) > 0
   SET @MachinePrizeMessage = REPLACE(@MachinePrizeMessage, ',', ' ')

-- Set the @PlayerTrackingEnabled
SELECT @PlayerTracking = ITEM_VALUE FROM TPI_SETTING WHERE ITEM_KEY = 'PlayerTracking' AND TPI_ID = @TpiSystem
IF (@PlayerTracking IS NULL)
   SET @PlayerTracking = 'False'

IF (@PlayerTracking = 'True')
   SET @PlayerTrackingEnabled = 1
ELSE
   SET @PlayerTrackingEnabled = 0

-- Get the count and lowest value of valid denominations for the GameType of the Machine.
SELECT
   @DenomCount = COUNT(*),
   @MinDenom   = CAST(MIN(DENOM_VALUE) * 100 AS Int)
FROM DENOM_TO_GAME_TYPE
WHERE GAME_TYPE_CODE = @GameTypeCode

-- Retrieve the maximum number of coins that can be won by this machine.
SELECT @MaxCoinsWon = [dbo].[ufnGetMaxCoinsWon] (@GameTypeCode,@DealTypeCode, @PayscaleName,@GameMaxCoinsBet,@GameMaxLinesBet, @IsBuyAPay)

-- All forms that have the same GAME_TYPE_CODE are going to have the same payscale.
-- FielsPerTier holds # of fields for each Tier_Level
IF (@DealTypeCode = 'K')
   BEGIN
      SELECT
         @PayscaleTierCount = COUNT(DISTINCT(TIER_LEVEL)),
         @FieldsPerTier     = 5,
         @MaxTierLevel      = MAX(TIER_LEVEL)
      FROM PAYSCALE_TIER_KENO
      WHERE PAYSCALE_NAME = @PayscaleName
   END
ELSE
   BEGIN
      SELECT
         @PayscaleTierCount = COUNT(DISTINCT(TIER_LEVEL)),
         @FieldsPerTier     = 6,
         @MaxTierLevel      = MAX(TIER_LEVEL)
      FROM PAYSCALE_TIER
      WHERE PAYSCALE_NAME = @PayscaleName
      
      -- If the GAME_CATEGORY.LIMIT_RTRANS_TIERS flag is set, only return 20 payscale tiers.
      IF (@LimitPSTiers = 1 AND @PayscaleTierCount > 20)
         SET @PayscaleTierCount = 20
   END

-- Get the count of active messages for PlayerTracking.
SELECT @MessageCount = COUNT(*) FROM MACHINE_MESSAGE WHERE IS_ACTIVE = 1

-- Get the count of Coin Bet Levels.
SELECT @NumCoinBetLevels = COUNT(*) FROM COINS_BET_TO_GAME_TYPE WHERE GAME_TYPE_CODE = @GameTypeCode

-- Get the count of Line Bet Levels.
SELECT @NumLineBetLevels = COUNT(*) FROM LINES_BET_TO_GAME_TYPE WHERE GAME_TYPE_CODE = @GameTypeCode

SET @LogPromoTickets = 0
IF EXISTS (SELECT * FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'LOG_PROMO_ENTRY_TICKETS')
BEGIN
SELECT @LogPromoTickets = CAST(VALUE1 AS bit) FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'LOG_PROMO_ENTRY_TICKETS'
END

-- Store the minimum hold percent possible for the game type.
SELECT @FormCount = COUNT(*) FROM dbo.CASINO_FORMS WHERE GAME_TYPE_CODE = @GameTypeCode
IF (@FormCount > 0)
BEGIN
   SELECT @MinGameTypeHold = MIN(HOLD_PERCENT) FROM dbo.CASINO_FORMS WHERE GAME_TYPE_CODE = @GameTypeCode
   SELECT DISTINCT @ReelAnimationTypeID = ReelAnimationTypeID FROM dbo.CASINO_FORMS WHERE GAME_TYPE_CODE = @GameTypeCode
END
ELSE
   SET @MinGameTypeHold = 0.0

-- Retrieve Machine, Casino info to be returned.  (Select #1)
SELECT @CursorResults =
   'TpVersion='              + @TpVersion +
   ',MachineNumber='         + @MachineNumber +
   ',MachineIpAddress='      + @MachineIpAddress +
   ',ProductLine='           + CONVERT(VarChar, @ProductLine) +
   ',GameCode='              + @MachineGameCode +
   ',ModelDescription='      + @MachineModelDescription +
   ',CasinoMachineNumber='   + @CasinoMachineNumber +
   ',CasinoName='            + @CasinoName +
   ',CasinoLockupAmount='    + CONVERT(VarChar, @CasinoLockupAmount) +
   ',MaxCoinsBet='           + CONVERT(VarChar, @GameMaxCoinsBet) +
   ',MaxLinesBet='           + CONVERT(VarChar, @GameMaxLinesBet) +
   ',NumCoinBetLevels='      + CONVERT(VarChar, @NumCoinBetLevels) +
   ',NumLineBetLevels='      + CONVERT(VarChar, @NumLineBetLevels) +
   ',DenominationCount='     + CONVERT(VarChar, @DenomCount) +
   ',TierCount='             + CONVERT(VarChar, @PayscaleTierCount) +
   ',FieldsPerTier='         + CONVERT(VarChar, @FieldsPerTier) +
   ',MessageCount='          + CONVERT(VarChar, @MessageCount) +
   ',SystemType='            + CONVERT(VarChar, @SystemType) +
   ',MachineIsPaper='        + CONVERT(VarChar, @MachineIsPaper) +
   ',PlayerTrackingEnabled=' + CONVERT(VarChar, @PlayerTrackingEnabled) +
   ',TpiSystem='             + CONVERT(VarChar, @TpiSystem) +
   ',ShowPayCredits='        + CONVERT(VarChar, @ShowPayCredits) +
   ',GameClass='             + CONVERT(VarChar, @GameClass) +
   ',JackpotLockup='         + CONVERT(VarChar, @JackpotLockup) +
   ',CashoutTimeout='        + CONVERT(VarChar, @CashoutTimeout) +
   ',GameTitleID='           + CONVERT(VarChar, @GameTitleID) +
   ',AutoDrop='              + CONVERT(VarChar, @AutoDrop) +
   ',EntryTicketOn='         + CONVERT(VarChar, @EntryTicketOn) +
   ',EntryTicketLimit='      + CONVERT(VarChar, @EntryTicketLimit) +
   ',EntryTicketAmountLimit='  + CONVERT(VarChar, @EntryTicketAmountLimit) +
   ',ReprintTicket='         + CONVERT(VarChar, @ReprintTicket) +
   ',DaubTimeout='           + CONVERT(VarChar, @DaubTimeout) +
   ',ClaimTimeout='          + CONVERT(VarChar, @ClaimTimeout) +
   ',FreeSquareDisplay='     + CONVERT(VarChar, @BingoFreeSquare) +
   ',RedeemTicketOn='        + CONVERT(VarChar, @RedeemTicketOn) +
   ',RaffleTicketOn='        + CONVERT(VarChar, @RaffleTicketOn) +
   ',RedeemPrizeMessage='    + @MachinePrizeMessage +
   ',DBALockupAmt='          + CONVERT(VarChar, @DBALockupAmt) +
   ',IsBuyAPay='             + CONVERT(VarChar, @IsBuyAPay) +
   ',MaxCoinsWon='           + CONVERT(VarChar, @MaxCoinsWon) +
   ',MaxTierLevel='          + CONVERT(VarChar, @MaxTierLevel) +
   ',ProgressiveTypeID='     + CONVERT(VarChar, @ProgressiveTypeID) +
   ',ProgRequestSeconds='    + CONVERT(VarChar, @ProgReqSeconds) +
   ',GameCategoryID='        + CONVERT(VarChar, @GameCategoryID) +
   ',BarcodeTypeID='         + CONVERT(VarChar, @BarcodeTypeID) +
   ',ProductID='             + CONVERT(VarChar, @ProductID) +
   ',ActiveFlag='            + CONVERT(VarChar, @ActiveFlag) +
   ',TicketNumOnError=1,SendDoorState=1,LogEntryTickets=' + CONVERT(VarChar, @LogPromoTickets) + 
   ',ReelAnimationTypeId=' + CONVERT(VarChar, @ReelAnimationTypeID) + ','

-- Set VariableCount = # of items in above select
SET @VariableCount = 51

-- Return Key/Value pairs in the TPI_SETTING table.
SET @TempString = ''

IF (@TpiSystem = 1)
   -- TPI_SETTING values for SDG
   DECLARE TpiSettingCursor CURSOR FOR
     SELECT ITEM_KEY + '=' + ITEM_VALUE + ',' 
       FROM TPI_SETTING WHERE TPI_ID=1 AND ITEM_KEY NOT LIKE '%msg%'
ELSE
   -- TPI_SETTING values for DGE_TITO, MGAM, SAS
   DECLARE TpiSettingCursor CURSOR FOR
     SELECT ITEM_KEY + '=' + ITEM_VALUE + ',' 
       FROM TPI_SETTING WHERE TPI_ID = 0 AND ITEM_KEY NOT LIKE '%checksum:%'

OPEN TpiSettingCursor

FETCH NEXT FROM TpiSettingCursor INTO @TempString
WHILE @@FETCH_STATUS = 0
   BEGIN
      -- Increment the VariableCount
      SET @VariableCount = @VariableCount + 1
      
      -- Concatenate the results of this select to the select above
      SET @CursorResults = @CursorResults + @TempString
      
      FETCH NEXT FROM TpiSettingCursor INTO @TempString
   END

CLOSE TpiSettingCursor
DEALLOCATE TpiSettingCursor

-- Pre-pend "VariableCount" to the results of the Select above
SET @CursorResults = 'VariableCount=' + CONVERT(VarChar, @VariableCount) + ',' + @CursorResults

SELECT ISNULL(@CursorResults, '<null>,') AS Select_1
--PRINT @CursorResults

-- Retrieve valid machine denominations.  (Select #2)
SET @CursorResults = ''
SET @TempString = ''


-- Declare a cursor to retrieve data from the DENOM_TO_GAME_TYPE table.
DECLARE DenomCursor CURSOR FOR
   SELECT DENOM_VALUE, CONVERT(VarChar, CONVERT(Int, DENOM_VALUE * 100)) + ','
   FROM DENOM_TO_GAME_TYPE
   WHERE GAME_TYPE_CODE = @GameTypeCode
   ORDER BY DENOM_VALUE ASC

OPEN DenomCursor FETCH NEXT FROM DenomCursor INTO @DenomValue, @TempString

WHILE @@FETCH_STATUS = 0
   BEGIN
      -- Add denom converted to Int pennies, then to VarChar.
      SET @CursorResults = @CursorResults + @TempString
      
      -- Retrieve minimum hold for this game type and denomination.
      IF EXISTS(SELECT * FROM dbo.CASINO_FORMS WHERE GAME_CODE = @GameTypeCode AND DENOMINATION = @DenomValue)
         SELECT @MinFormHold = MIN(HOLD_PERCENT) FROM dbo.CASINO_FORMS WHERE GAME_CODE = @GameTypeCode AND DENOMINATION = @DenomValue
      ELSE
         SET @MinFormHold = @MinGameTypeHold
      
      -- Add the hold.
      SET @HoldsByDenom = @HoldsByDenom + CAST(@MinFormHold AS VARCHAR) + ','
      
      -- Fetch next row
      FETCH NEXT FROM DenomCursor INTO @DenomValue, @TempString
   END

CLOSE DenomCursor
DEALLOCATE DenomCursor

SELECT ISNULL(@CursorResults, '<null>,') AS Select_2
--PRINT @CursorResults

-- Retrieve Payscale Tier information.  (Select #3)
-- If Keno, retrieve PAYSCALE_TIER_KENO rows.
-- Tier Level, Pick Count, Hit Count, Amount Won (in cents for a 10cent bet), TierWinType
SET @CursorResults = ''
SET @TempString = ''
IF (@DealTypeCode = 'K')
   -- Keno Game.
   BEGIN
      DECLARE PayscaleTierCursor CURSOR FOR
         SELECT
            CONVERT(VarChar, TIER_LEVEL) + ',' +
            CONVERT(VarChar, PICK_COUNT) + ',' +
            CONVERT(VarChar, HIT_COUNT) + ',' +
            CONVERT(VarChar, CAST(AWARD_FACTOR * @MinDenom AS Int)) + ',' +
            CONVERT(VarChar, TIER_WIN_TYPE) + ','
         FROM PAYSCALE_TIER_KENO
         WHERE PAYSCALE_NAME = @PayscaleName
         ORDER BY TIER_LEVEL ASC
      
      OPEN PayscaleTierCursor
      FETCH NEXT FROM PayscaleTierCursor INTO @TempString
      WHILE @@FETCH_STATUS = 0
         BEGIN
            SET @CursorResults = @CursorResults + @TempString
            FETCH NEXT FROM PayscaleTierCursor INTO @TempString
         END
   END
ELSE
   -- Non-Keno Game
   BEGIN
      DECLARE PayscaleTierCursor CURSOR FOR
         SELECT DISTINCT(TIER_LEVEL), COINS_WON, ICONS, ICON_MASK, TIER_WIN_TYPE, SCATTER_COUNT
      FROM PAYSCALE_TIER 
      WHERE PAYSCALE_NAME = @PayscaleName
      ORDER BY TIER_LEVEL ASC
      
      OPEN PayscaleTierCursor
      FETCH NEXT FROM PayscaleTierCursor INTO @TierLevel, @CoinsWon, @Icons, @IconMask, @TierWinType, @ScatterCount
      WHILE (@@FETCH_STATUS = 0 AND @TierCount < @PayscaleTierCount AND LEN(@CursorResults) < 8000)
         BEGIN
            SET @TierCount = @TierCount + 1
            SET @CursorResults = @CursorResults + CONVERT(VarChar, @TierLevel) + ',' +
                                 CONVERT(VarChar, @CoinsWon) + ',' + @Icons + ',' +
                                 @IconMask + ',' + CONVERT(VarChar, @TierWinType) + ',' +
                                 CONVERT(VarChar, @ScatterCount) + ','
            
            FETCH NEXT FROM PayscaleTierCursor
            INTO @TierLevel, @CoinsWon, @Icons, @IconMask, @TierWinType, @ScatterCount
         END
   END

CLOSE PayscaleTierCursor
DEALLOCATE PayscaleTierCursor

IF LEN(@CursorResults) = 0
   SET @CursorResults = ','
ELSE 
   -- If the last character is not a comma, we overflowed @CursorResults. 
   IF (SUBSTRING(@CursorResults, LEN(@CursorResults),1) <> ',')
      SET @CursorResults = 'PAYSCALE TIER OVERFLOW,'

SELECT ISNULL(@CursorResults, '<null>,') AS Select_3
--PRINT @CursorResults

-- Retrieve PlayerTracking Messages. (Select #4)
SET @CursorResults = ''
SET @TempString = ''

DECLARE MessageCursor CURSOR FOR
   SELECT MACHINE_MESSAGE_ID, ISNULL(TPI_MESSAGE, DGE_MESSAGE), ISNULL(MESSAGE_PARAMETERS, '')
   FROM MACHINE_MESSAGE
   WHERE IS_ACTIVE = 1

OPEN MessageCursor

FETCH NEXT FROM MessageCursor INTO @MachineMessageID, @Message, @MessageParameters
WHILE @@FETCH_STATUS = 0
   BEGIN
      SET @TempString = @MessageParameters
      SET @CountEqualSign = 0
      
      -- See if @MessageParameters contains a value
      IF (LEN(@MessageParameters) > 0)
         BEGIN
            -- Count the number of "=" signs in MessageParameters
            SELECT @EqualSign = CHARINDEX('=', @MessageParameters)
            
            WHILE @EqualSign > 0
               BEGIN
                  SET @CountEqualSign = @CountEqualSign + 1
                  -- Set the search string to everything after the = sign.
                  SET @TempString = RIGHT(@TempString, LEN(@TempString) - @EqualSign)
                  -- Find the next '=' character.
                  SELECT @EqualSign = CHARINDEX('=', @TempString)
               END
          END
      
      -- Get the # of fields = 2 + @CountEqualSign
      SET @CursorResults = @CursorResults + CONVERT(VarChar, 2 + @CountEqualSign) +
                           ',MachineMessageId=' + CONVERT(VarChar, @MachineMessageID) +
                           ',Message='+ @Message + ','
      IF (LEN(@MessageParameters) > 0)
         SET @CursorResults = @CursorResults + @MessageParameters + ','
      
      FETCH NEXT FROM MessageCursor INTO @MachineMessageID, @Message, @MessageParameters
   END

CLOSE MessageCursor
DEALLOCATE MessageCursor

--SELECT @CursorResults AS Select_4
SELECT ISNULL(@CursorResults, '<null>,') AS Select_4

-- Retrieve Coin Bet Level Collection.  (Select #5)
SET @CursorResults = ''
SET @TempString = ''

DECLARE CoinBetLevelCursor CURSOR FOR
   SELECT CONVERT(VarChar, COINS_BET) + ','
   FROM COINS_BET_TO_GAME_TYPE
   WHERE GAME_TYPE_CODE = @GameTypeCode
   ORDER BY COINS_BET ASC

OPEN CoinBetLevelCursor
FETCH NEXT FROM CoinBetLevelCursor INTO @TempString

WHILE @@FETCH_STATUS = 0
   BEGIN
      SET @CursorResults = @CursorResults + @TempString
      FETCH NEXT FROM CoinBetLevelCursor INTO @TempString
   END

CLOSE CoinBetLevelCursor
DEALLOCATE CoinBetLevelCursor

--SELECT @CursorResults AS Select_5
SELECT ISNULL(@CursorResults, '<null>,') AS Select_5

-- Retrieve Line Bet Level Collection.  (Select #6)
SET @CursorResults = ''
SET @TempString = ''

DECLARE LineBetLevelCursor CURSOR FOR
   SELECT CONVERT(VarChar, LINES_BET) + ','
   FROM LINES_BET_TO_GAME_TYPE
   WHERE GAME_TYPE_CODE = @GameTypeCode
   ORDER BY LINES_BET ASC

OPEN LineBetLevelCursor
FETCH NEXT FROM LineBetLevelCursor INTO @TempString

WHILE @@FETCH_STATUS = 0
   BEGIN
      SET @CursorResults = @CursorResults + @TempString
      FETCH NEXT FROM LineBetLevelCursor INTO @TempString
   END

CLOSE LineBetLevelCursor
DEALLOCATE LineBetLevelCursor

--SELECT @CursorResults AS Select_6
SELECT ISNULL(@CursorResults, '<null>,') AS Select_6

-- Retrieve minimum hold percent for each denomination.
SELECT ISNULL(@HoldsByDenom, '<null>,') AS Select_7
GO
