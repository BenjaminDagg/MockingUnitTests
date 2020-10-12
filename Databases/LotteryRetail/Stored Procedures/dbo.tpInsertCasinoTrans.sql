SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: tpInsertCasinoTrans

Desc: Inserts Data into Casino trans.

Return values: None

Called by: tpTrans*

Parameters: Parameters match columns in CASINO_TRANS

Auth: Chris Coddington

Date: 4/16/2003

Change Log:
Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Chris C.      06-26-2003
  Added TierLevel parameter for insert into Casino_Trans.

Chris C.      02-10-2004
  Changed float datatypes to money datatypes.

Terry Watkins 05-12-2004
  Insert empty string into Barcode since Triple Play barcodes are all stored in
  eDeal database.

Terry Watkins 10-22-2004
  Added insertion of TRANS_ID column value.
  Removed output parameter CasinoTransID and return the TRANS_NO value
  via @@IDENTITY.

Terry Watkins 02-02-2005     v4.0.1
  Added argument @PressUpCount for new CASINO_TRANS.PRESSED_COUNT column.

Terry Watkins 05-22-2005     v4.1.3
  Changed @CardAccount argument from 16 to 20 characters.

Terry Watkins 10-04-2006     v5.0.8
  Removed argument @TicketStatusID. No longer needed because column
  CASINO_TRANS.TICKET_STATUS_ID has been removed.

Terry Watkins 02-02-2009     v6.0.3
   Added Default values for @RollNo, @TicketNo, @Denom, @Barcode, @CoinsBet,
   @LinesBet, @TierLevel

Terry Watkins 10-16-2009     v7.0.0
  Changed datatype of argument @CurrentAcctDate from VarChar(16) to DateTime.
  
Terry Watkins 11-10-2010     DCLRetail v1.0.0
  Added retrieval of Location ID from the CASINO table for insertion into
  CASINO_TRANS.
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[tpInsertCasinoTrans]
   @CasinoID        VarChar(6),
   @DealNo          Int,
   @RollNo          Int          = 0,
   @TicketNo        Int          = 0,
   @Denom           SmallMoney   = 0,
   @TransAmt        Money,
   @Barcode         VarChar(128) = '',
   @TransID         SmallInt,
   @CurrentAcctDate DateTime,
   @TimeStamp       DateTime,
   @MachineNumber   VarChar(5),
   @CardAccount     VarChar(20),
   @Balance         Money,
   @GameCode        VarChar(3),
   @CoinsBet        Int          = 0,
   @LinesBet        Int          = 0,
   @TierLevel       SmallInt     = 0,
   @PressUpCount    SmallInt     = 0,
   @LocationID      Int          = 0,
   @MachineTimeStamp DateTime    = NULL
AS

-- Variable Declarations

-- Variable Initialization
SET @Barcode    = ''

IF @DealNo         IS NULL SET @DealNo = 0
IF @RollNo         IS NULL SET @RollNo = 0
IF @TicketNo       IS NULL SET @TicketNo = 0
IF @TransAmt       IS NULL SET @TransAmt = 0
IF @Balance        IS NULL SET @Balance = 0
IF @TransID        IS NULL SET @TransID = 0
IF @CoinsBet       IS NULL SET @CoinsBet = 0
IF @LinesBet       IS NULL SET @LinesBet = 0
IF @CardAccount    IS NULL SET @CardAccount = ''
IF @MachineNumber  IS NULL SET @MachineNumber = ''

-- Perform the Insert.
INSERT INTO CASINO_TRANS
   (CAS_ID, DEAL_NO, ROLL_NO, TICKET_NO, DENOM, TRANS_AMT, BARCODE_SCAN, TRANS_ID,
    ACCT_DATE, DTIMESTAMP, MACH_NO, MODIFIED_BY, CARD_ACCT_NO, BALANCE, GAME_CODE,
    COINS_BET, LINES_BET, TIER_LEVEL, PRODUCT_ID, PRESSED_COUNT, LOCATION_ID, MACH_TIMESTAMP)
VALUES
   (@CasinoID, @DealNo, @RollNo, @TicketNo, @Denom, @TransAmt, @Barcode, @TransID,
    @CurrentAcctDate, @TimeStamp, @MachineNumber, USER_NAME(), @CardAccount, @Balance,
    @GameCode, @CoinsBet, @LinesBet, @TierLevel, 1, @PressUpCount, @LocationID, @MachineTimeStamp)

-- Return the TRANS_NO (PK Identity Int) value.
RETURN SCOPE_IDENTITY()
GO
