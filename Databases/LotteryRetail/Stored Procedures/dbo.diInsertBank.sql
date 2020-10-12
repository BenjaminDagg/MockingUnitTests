SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertBank

Created By:     Terry Watkins

Create Date:    09/09/2003

Description:    Inserts a row into the Bank table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     Each field from the Bank table.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-08-2003
  Set PROG_AMT to 0 when inserting a new Bank record.

Terry Watkins 12-14-2005     v5.0.0
  Added support for new arguments @BankDesc and @ProductLineID.

Terry Watkins 01-31-2006     v5.0.1
  Added @UpdateFlag (Bit default 0) to control updating of existing records.
  Returns 2 (update ignored) if record exists and Update flag = 0.

Terry Watkins 12-19-2007     v6.0.2
  Added @LockupAmount to support new Bank column.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertBank]
   @BankNo         Int,
   @GameTypeCode   VarChar(2),
   @ProgFlag       Bit,
   @IsPaper        Bit,
   @IsActive       Bit,
   @BankDesc       VarChar(128) = '',
   @ProductLineID  SmallInt     = 2,
   @LockupAmount   SmallMoney,
   @UpdateFlag     Bit = 0
AS

-- Variable Declaration
DECLARE @ReturnValue      Int
DECLARE @BankDescription  VarChar(128)


SET NOCOUNT ON

-- Variable Initialization
SET @ReturnValue = 0

-- Make sure bank description is not null.
IF @BankDesc IS NULL SET @BankDesc = ''

-- Test to see if the Bank record already exists.
IF EXISTS (SELECT * FROM BANK WHERE BANK_NO = @BankNo )
   BEGIN
      -- Record already exists.
      IF (@UpdateFlag = 1)
         BEGIN
            UPDATE BANK SET 
               GAME_TYPE_CODE   = @GameTypeCode,
               PROG_FLAG        = @ProgFlag,
               IS_PAPER         = @IsPaper,
               PRODUCT_LINE_ID  = @ProductLineID,
               IS_ACTIVE        = @IsActive,
               LOCKUP_AMOUNT    = @LockupAmount,
               @BankDescription = ISNULL(BANK_DESCR, '')
            WHERE BANK_NO = @BankNo
            
            -- Store error code from update.
            SET @ReturnValue = @@ERROR
            
            -- If no errors, update the bank description if it does not already
            -- have a value and we received a value that is not an empty string.
            IF (@ReturnValue = 0 AND LEN(@BankDescription) = 0 AND LEN(@BankDesc) > 0)
               BEGIN
                  UPDATE BANK SET BANK_DESCR = @BankDesc
                  -- Store error code from update.
                  SET @ReturnValue = @@ERROR
               END
            
            IF @ReturnValue = 0 SET @ReturnValue = 1
         END
      ELSE
         -- Update flag not set, so ignore update and return 2.
         SET @ReturnValue = 2
   END
ELSE
   BEGIN
      -- Record doesn't exist, so insert it.
      INSERT INTO Bank
         (BANK_NO, BANK_DESCR, GAME_TYPE_CODE, PRODUCT_LINE_ID,
          PROG_FLAG, PROG_AMT, LOCKUP_AMOUNT, IS_PAPER, IS_ACTIVE)
      VALUES
         (@BankNo, @BankDesc, @GameTypeCode, @ProductLineID,
          @ProgFlag, 0, @LockupAmount, @IsPaper, @IsActive)
      
      -- Store error code from insert
      SET @ReturnValue = @@ERROR
   END   

-- Set the Return value.
RETURN @ReturnValue

GO
