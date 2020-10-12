SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertCasinoForms

Created By:     Chris Coddington

Create Date:    09/09/2003

Description:    Inserts a row into the Casino_Forms table

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     Each field from the CASINO_FORMS table.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-08-2003
  Added code to update the GAME_CODE column if a new Form record is being
  inserted.

Terry Watkins 01-30-2006     v5.0.1
  Changed @FormNbr argument size from 10 to 16.
  Changed @DealType argument from VarChar(10) to Char(1).
  Added @MasterDealID (Int default 0).
  Added @UpdateFlag (Bit default 0) to control updating of existing records.
  Returns 2 if record exists and Update flag = 0.

  Note: if updating, the GAME_CODE and IS_ACTIVE columns are not modified.

Terry Watkins 09-13-2007     v6.0.1
  Added @BingoMasterID (Int default 0).

Terry Watkins 01-24-2008     v6.0.2
  Changed the datatype of the @ProgPct argument from Numeric to Decimal(6,4)
  Added @IsMicroTab (default 0) to update new CASINO_FORMS.IS_MICRO_TAB column.
  Added @JackpotCount (default 0) to update new CASINO_FORMS.JACKPOT_COUNT
  column.

Terry Watkins 08-18-2009     v7.0.0
  Dropped arguments @ProgInd and @ProgPct (corresponding columns were dropped
  from table CASINO_FORMS).

Terry Watkins 08-26-2010     v7.2.3
  Dropped argument @IsMicroTab (dropped column CASINO_FORMS.IS_MICRO_TAB).
  Added argument @TabTypeID to handle new column CASINO_FORMS.TAB_TYPE_ID.

Terry Watkins 08-26-2010     Lottery Retail v2.0.1
  Modified size of argument @FormDesc from 30 to 64.

Terry Watkins 02-29-2012     Lottery Retail v3.0.4
  Added argument @MasterHash to insert into new column CASINO_FORMS.MASTER_HASH.

Aldo Zamora 06-10-2014
  Added argument @ReelAnimationTypeID to insert into new column ReelAnimationTypeID.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[diInsertCasinoForms]
   @FormNbr             VarChar(16),
   @DealType            Char(1),
   @CostPerTab          SmallMoney,
   @NbrRolls            Int,
   @TabsPerRoll         Int,
   @TabsPerDeal         Int,
   @WinsPerDeal         Int,
   @TotalAmtIn          Money,
   @TotalAmtOut         Money,
   @FormDesc            VarChar(64),
   @TabAmt              SmallMoney,
   @IsRevShare          Bit,
   @DGERevPercent       TinyInt,
   @JPAmount            Money,
   @JackpotCount        Int = 0,
   @Denomination        SmallMoney,
   @CoinsBet            TinyInt,
   @LinesBet            SmallInt,
   @GameTypeCode        VarChar(2),
   @PayscaleMultiplier  TinyInt,
   @MasterDealID        Int = 0,
   @BingoMasterID       Int = 0,
   @HoldPercent         Decimal,
   @IsPaper             Bit,
   @TabTypeID           Int = -1,
   @MasterHash          Binary(20) = NULL,
   @MasterChecksum Binary(20) = NULL,
   @IsActive            Bit,
   @UpdateFlag          Bit = 0,
   @ReelAnimationTypeID Int = 1

AS

-- Variable Declaration
DECLARE @ReturnValue Int
DECLARE @GameCode    VarChar(3)

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

-- Test to see if the form already exists.
IF EXISTS (SELECT * FROM CASINO_FORMS WHERE FORM_NUMB = @FormNbr)
   -- Record already exists.
   BEGIN
   IF @MasterChecksum IS NOT NULL AND (SELECT MASTER_CHECKSUM FROM CASINO_FORMS WHERE FORM_NUMB = @FormNbr) IS NULL
   BEGIN
UPDATE CASINO_FORMS SET
            MASTER_CHECKSUM     = @MasterChecksum
         WHERE FORM_NUMB = @FormNbr
   END
   
   IF (@UpdateFlag = 1)
      -- Update flag is set.
      BEGIN
         UPDATE CASINO_FORMS SET
            DEAL_TYPE           = @DealType,
            COST_PER_TAB        = @CostPerTab,
            NUMB_ROLLS          = @NbrRolls,
            TABS_PER_ROLL       = @TabsPerRoll,
            TABS_PER_DEAL       = @TabsPerDeal,
            WINS_PER_DEAL       = @WinsPerDeal,
            TOTAL_AMT_IN        = @TotalAmtIn,
            TOTAL_AMT_OUT       = @TotalAmtOut,
            FORM_DESC           = @FormDesc,
            TAB_AMT             = @TabAmt,
            IS_REV_SHARE        = @IsRevShare,
            DGE_REV_PERCENT     = @DgeRevPercent,
            JP_AMOUNT           = @JPAmount,
            JACKPOT_COUNT       = @JackpotCount,
            DENOMINATION        = @Denomination,
            MASTER_DEAL_ID      = @MasterDealID,
            BINGO_MASTER_ID     = @BingoMasterID,
            COINS_BET           = @CoinsBet,
            LINES_BET           = @LinesBet,
            GAME_TYPE_CODE      = @GameTypeCode,
            PAYSCALE_MULTIPLIER = @PayscaleMultiplier,
            HOLD_PERCENT        = @HoldPercent,
            IS_PAPER            = @IsPaper,
            TAB_TYPE_ID         = @TabTypeID,
            MASTER_HASH         = @MasterHash,
            MASTER_CHECKSUM     = @MasterChecksum,
            ReelAnimationTypeID = @ReelAnimationTypeID
         WHERE FORM_NUMB = @FormNbr
         
         -- Store SQL error code.
         SET @ReturnValue = @@ERROR
         
         -- If no error, reset return value to 1 to indicate successful update.
         IF @ReturnValue = 0 SET @ReturnValue = 1
      END
   ELSE
      -- Record exists and update flag no set, so return 2 to indicate existing row ignored.
      SET @ReturnValue = 2
   END
ELSE
   BEGIN
      -- Record doesn't exist, so insert it.
      INSERT INTO CASINO_FORMS
         (FORM_NUMB, DEAL_TYPE, COST_PER_TAB, NUMB_ROLLS, TABS_PER_ROLL, TABS_PER_DEAL,
          WINS_PER_DEAL, TOTAL_AMT_IN, TOTAL_AMT_OUT, FORM_DESC, TAB_AMT, IS_REV_SHARE,
          DGE_REV_PERCENT, JP_AMOUNT, JACKPOT_COUNT, GAME_CODE, DENOMINATION,
          MASTER_DEAL_ID, BINGO_MASTER_ID, COINS_BET, LINES_BET, GAME_TYPE_CODE,
          PAYSCALE_MULTIPLIER, HOLD_PERCENT, IS_PAPER, TAB_TYPE_ID, MASTER_HASH, MASTER_CHECKSUM, IS_ACTIVE, ReelAnimationTypeID)
      VALUES
         (@FormNbr, @DealType, @CostPerTab, @NbrRolls, @TabsPerRoll, @TabsPerDeal,
          @WinsPerDeal, @TotalAmtIn, @TotalAmtOut, @FormDesc, @TabAmt, @IsRevShare,
          @DgeRevPercent, @JPAmount, @JackpotCount, NULL, @Denomination,
          @MasterDealID, @BingoMasterID, @CoinsBet, @LinesBet, @GameTypeCode,
          @PayscaleMultiplier, @HoldPercent, @IsPaper, @TabTypeID, @MasterHash, @MasterChecksum, @IsActive, @ReelAnimationTypeID)
      
      SET @ReturnValue = @@ERROR
      
      IF @ReturnValue = 0
         BEGIN
            -- Get the first game code from GAME_SETUP for the Game Type Code passed to this proc.
            SELECT @GameCode = MIN(GAME_CODE) FROM GAME_SETUP WHERE GAME_TYPE_CODE = @GameTypeCode
            
            -- If not null, insert the Game Code into the Form record...
            IF NOT @GameCode IS NULL
               UPDATE CASINO_FORMS SET GAME_CODE = @GameCode WHERE FORM_NUMB = @FormNbr
         END
   END   

RETURN @ReturnValue
GO
