SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: dsInsertDealSetup

 Created By:    Terry Watkins

Create Date:    12-20-2005

Description:    Inserts a row into DEAL_SETUP.

  Called By:    Deal Server Service

    Returns:    Number of rows inserted (1 = success)

 Parameters:    @DealNumber  New Deal Number
                @FormNumber  Form number to use for DEAL_SETUP column values
                @CreatedBy   User or process name calling this procedure

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-21-2005     v5.0.1
  Initial coding

Terry Watkins 08-18-2009     v7.0.0
  Dropped retrieval and update for removed columns PROG_IND, PROG_PCT, and
  PROG_VAL which were dropped from table DEAL_SETUP.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[dsInsertDealSetup]
   @DealNumber   Int,
   @FormNumber   VarChar(10),
   @CreatedBy    VarChar(32)
AS

-- Variable Declaration
DECLARE @Debug        Bit
DECLARE @MsgText      VarChar(3072)
DECLARE @ErrorID      Int
DECLARE @InsertCount  Int

-- Variable Initialization
SET @InsertCount = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'dsInsertDealSetup'

-- If Debug mode, save argument values...
IF (@Debug = 1)
   -- Record argument values.
   BEGIN
      SET @MsgText =
         'dsInsertDealSetup Argument Values:  ' + 
         '  FormNumber: ' + @FormNumber +
         '  DealNumber: ' + CAST (@DealNumber AS VarChar) +
         '  CreatedBy:  ' + @CreatedBy
      
      EXEC InsertDebugInfo 0, @MsgText, 0
   END

-- Insert the row.
INSERT INTO DEAL_SETUP
   (DEAL_NO, TYPE_ID, DEAL_DESCR, NUMB_ROLLS, TABS_PER_ROLL, TAB_AMT,
    COST_PER_TAB, CREATED_BY, SETUP_DATE, JP_AMOUNT, FORM_NUMB,
    GAME_CODE, DENOMINATION, COINS_BET, LINES_BET)
SELECT
   @DealNumber, DEAL_TYPE AS TYPE_ID, FORM_DESC AS DEAL_DESCR, NUMB_ROLLS,
   TABS_PER_ROLL, TAB_AMT, COST_PER_TAB, @CreatedBy AS CREATED_BY,
   GetDate() AS SETUP_DATE, JP_AMOUNT, FORM_NUMB, GAME_CODE, DENOMINATION,
   COINS_BET, LINES_BET
FROM CASINO_FORMS
WHERE FORM_NUMB = @FormNumber

-- Store Error code and InsertCount.
SELECT @ErrorID = @@ERROR, @InsertCount = @@ROWCOUNT

-- If Debug mode, save results...
IF (@Debug = 1)
   BEGIN
      SET @MsgText = 'dsInsertDealSetup Status:  ' + 
         '  DealNumber:  '   + CAST (@DealNumber  AS VarChar) +
         '  Insert Count:  ' + CAST (@InsertCount AS VarChar) +
         '  Insert Error:  ' + CAST (@ErrorID     AS VarChar)
      
      EXEC InsertDebugInfo 0, @MsgText, 0
   END

-- Set the return value.
RETURN @InsertCount
GO
