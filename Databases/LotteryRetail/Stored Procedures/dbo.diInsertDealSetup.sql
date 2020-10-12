SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertDealSetup

Created By:     Chris Coddington

Create Date:    09-09-2003

Description:    Inserts a row into the DEAL_SETUP table.

Returns:        0 = Successful row insertion
                1 = Record Already Exists
                n = TSQL Error Code

Parameters:     Each field from the DEAL_SETUP table.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-08-2003
  Added GameCode

Terry Watkins 09-18-2007     v6.0.1
  Added default values for a few of the procedure parameters.

Terry Watkins 08-18-2009     v7.0.0
  Dropped arguments @ProgInd, @ProgPct, and @ProgVal (corresponding columns
  were dropped from table CASINO_FORMS).
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[diInsertDealSetup]
   @DealNo           Int,
   @TypeID           Char(1),
   @DealDescr        VarChar(64),
   @NumbRolls        Int,
   @TabsPerRoll      Int,
   @TabAmt           SmallMoney,
   @CostPerTab       SmallMoney = 0,
   @CreatedBy        VarChar(32),
   @SetupDate        DateTime   = NULL,
   @JPAmount         Money,
   @FormNumb         VarChar(10),
   @IsOpen           Bit        = 1,
   @Denomination     SmallMoney,
   @CoinsBet         SmallInt,
   @LinesBet         TinyInt,
   @GameCode         VarChar(3),
   @ExportedDate	 DateTime = NULL
AS

-- Suppress unwanted return data.
SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

-- Test to see if the record already exists.
IF EXISTS(SELECT * FROM DEAL_SETUP WHERE DEAL_NO = @DealNo)
   -- Record already exists.
   SET @ReturnValue = 1
ELSE
   BEGIN
      -- Record doesn't exist, so insert it.
      -- If @SetupDate parameter was not set, use current date and time.
      IF @SetupDate IS NULL SET @SetupDate = GetDate()
      INSERT INTO DEAL_SETUP 
         (DEAL_NO, [TYPE_ID], DEAL_DESCR, NUMB_ROLLS, TABS_PER_ROLL, TAB_AMT,
          COST_PER_TAB, CREATED_BY, SETUP_DATE, JP_AMOUNT, FORM_NUMB, IS_OPEN,
          DENOMINATION, COINS_BET, LINES_BET, GAME_CODE, EXPORTED_DATE)
      VALUES
         (@DealNo, @TypeID, @DealDescr, @NumbRolls, @TabsPerRoll, @TabAmt,
          @CostPerTab, @CreatedBy, @SetupDate, @JPAmount, @FormNumb, @IsOpen,
          @Denomination, @CoinsBet, @LinesBet, @GameCode, @ExportedDate)
      
      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
