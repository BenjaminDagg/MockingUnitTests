SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpTransCOG

Created 04-11-2003 by Chris Coddington

Desc: Handles all door requests.

Return values: Varies...

Called by: Transaction Portal

Parameters:
   @CardAccount     Card Account Number
   @MachineNumber   Machine Number
   @MachineSequence Machine Sequence Number
   @TimeStamp       Machine date and time value
   @TransType       Transaction type


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 02-20-2004
  Changed datatype of @Balance and @TransAmt variables from Float to Money.
  Added retrieval of the Game Code of the Machine for insert into CASINO_TRANS.

Terry Watkins 10-22-2004     v4.0.0
  Added insertion of TransID into CASINO_TRANS.

Terry Watkins 06-15-2005     v4.1.4
  Changed size of @CardAccount from 16 to 20.

Terry Watkins 01-16-2006     v5.0.1
  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
  to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

A.Murthy      04-17-2006     v5.0.3
  Changed size of @TransType from 2 to 8 to accomodate new "BaseDoor" trans.

Terry Watkins 06-14-2006     v5.0.4
   Added logic to update the new MACHINE_STATS door open count columns.

A.Murthy      08-01-2006     v5.0.5
  Added logic to set @CardAccount to 'INTERNAL' if input @CardAccount is null.
  To handle Door Opens without a preceding Tech. Card Insert.

Terry Watkins 06-14-2006     v5.0.6
   Changed @CasinoMachNo from VarChar(5) to VarChar(8)

Terry Watkins 10-04-2006     v5.0.8
  Removed @TicketStatusID. No longer needed because column
  CASINO_TRANS.TICKET_STATUS_ID has been removed.
  Added logic to set the CardAccount number to 'INVALID' prior to insertion
  into CASINO_TRANS if the incoming card account is not valid.

Terry Watkins 11-03-2009     v7.0.0
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AcctDate changed from VarChar(16) to DateTime.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added retrieval of @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID

Terry Watkins 11-11-2010     LotteryRetail v3.0.4
  Added use of named parameters when calling tpInsertCasinoTrans.  This fixes a
  bug that caused the LocationID to be inserted into the PressUpCount column.
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
  
Louis Epstein 06-18-2014     v3.2.3
  Modified stat recording functionality to use tpUpdatePlayStatsHourlyAndDaily
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[tpTransCOG]
   @CardAccount       VarChar(20),
   @MachineNumber     VarChar(5),
   @MachineSequence   Int,
   @TimeStamp         DateTime,
   @TransType         VarChar(8)
AS

-- Variable Declarations
DECLARE @AcctDate         DateTime
DECLARE @Balance          Money
DECLARE @Barcode          VarChar(128)
DECLARE @CardRequired     Bit
DECLARE @CasinoMachNo     VarChar(8)
DECLARE @CasinoID         VarChar(6)
DECLARE @CasinoTransID    Int
DECLARE @CoinsBet         Int
DECLARE @DealNo           Int
DECLARE @ErrorID          Int
DECLARE @ErrorSource      VarChar(64)
DECLARE @ErrorDescription VarChar(256)
DECLARE @EventCode        VarChar(2)
DECLARE @EventLogDesc     VarChar(1024)
DECLARE @LinesBet         Int
DECLARE @LocationID       Int
DECLARE @LockupMachine    Int
DECLARE @MachGameCode     VarChar(3)
DECLARE @RollNo           Int
DECLARE @TicketNo         Int
DECLARE @TierLevel        SmallInt
DECLARE @TransAmt         Money
DECLARE @TransID          SmallInt
DECLARE @MachineTimeStamp DateTime

SET NOCOUNT ON

-- Variable Initialization
SET @MachineTimeStamp = @TimeStamp
SET @Balance          = 0
SET @Barcode          = ''
SET @CoinsBet         = 0
SET @DealNo           = 0
SET @ErrorID          = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpTransCOG Stored Procedure'
SET @EventCode        = 'SP'
SET @EventLogDesc     = ''
SET @LinesBet         = 0
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @RollNo           = 0
SET @TicketNo         = 0
SET @TierLevel        = 0
SET @TransAmt         = 0
SET @TimeStamp        = GetDate()


-- Retrieve Casino Information
SELECT
   @CasinoID     = CAS_ID,
   @CardRequired = PLAYER_CARD,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Update MACH_SETUP.LAST_ACTIVITY and retrieve the Game Code, Balance, CasinoMachNo associated with the machine.
UPDATE MACH_SETUP SET
   LAST_ACTIVITY = @TimeStamp,
   @MachGameCode = GAME_CODE,
   @Balance      = BALANCE,
   @CasinoMachNo = CASINO_MACH_NO
WHERE MACH_NO = @MachineNumber

-- If in Card Required play mode, set the balance variable value to zero.
IF @CardRequired = 1 SET @Balance = 0

-- If NULL Card Account, set it to 'INTERNAL'
IF @CardAccount IS NULL SET @CardAccount = 'INTERNAL'

-- If no Card Account, set it to 'INTERNAL'
IF LEN(@CardAccount) = 0 SET @CardAccount = 'INTERNAL'

-- Retrieve the TransID based upon the TransType.
SELECT @TransID = ISNULL(TRANS_ID, 0) FROM TRANS WHERE SHORT_NAME = @TransType

      IF (@TransID = 30)
         EXEC tpUpdatePlayStatsHourlyAndDaily 
         @LocationIdPass = @LocationID, 
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AcctDate,
@DealNoPass = 0,
@GameCodePass = @MachGameCode,
@MainDoorOpenCountPass = 1
      
      IF (@TransID = 31)
  EXEC tpUpdatePlayStatsHourlyAndDaily 
  @LocationIdPass = @LocationID, 
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AcctDate,
@DealNoPass = 0,
@GameCodePass = @MachGameCode,
@CashDoorOpenCountPass = 1
      
      IF (@TransID = 32)
         EXEC tpUpdatePlayStatsHourlyAndDaily 
         @LocationIdPass = @LocationID, 
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AcctDate,
@DealNoPass = 0,
@GameCodePass = @MachGameCode,
@LogicDoorOpenCountPass = 1
      
      IF (@TransID = 34)
         EXEC tpUpdatePlayStatsHourlyAndDaily 
         @LocationIdPass = @LocationID, 
@TimeStampPass = @TimeStamp,
@MachNoPass = @MachineNumber,
@CasinoMachNoPass = @CasinoMachNo,
@AcctDatePass = @AcctDate,
@DealNoPass = 0,
@GameCodePass = @MachGameCode,
@BaseDoorOpenCountPass = 1

-- Test that the card exists.
IF NOT EXISTS (SELECT STATUS FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAccount)
   BEGIN
      SET @ErrorID = 102
      SET @CardAccount = 'INVALID'
   END

-- Handle any errors
IF @ErrorID <> 0
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
      
      -- Build Error Message
      SET @EventLogDesc = 'Description: ' + @ErrorDescription +
                          ' Card Account: ' + @CardAccount +
                          ' Machine Number:' + @MachineNumber
      
      -- Test if the Machine should be loocked up.
      IF @LockupMachine <> 0
         BEGIN
            UPDATE MACH_SETUP SET ACTIVE_FLAG = 0 WHERE MACH_NO = @MachineNumber AND ACTIVE_FLAG = 1
            SET @EventCode = 'SD'
         END
      
      -- Insert Error into the Casino_Event_Log
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @ErrorID, @MachineNumber)
      
      -- Reset balance to zero if in Card Play mode (so balance in CASINO_TRANS will show 0).
      IF (@CardRequired = 1 AND @Balance <> 0) SET @Balance = 0
   END

-- Log transaction.
EXEC @CasinoTransID = tpInsertCasinoTrans
   @CasinoID        = @CasinoID,
   @DealNo          = @DealNo,
   @RollNo          = @RollNo,
   @TicketNo        = @TicketNo,
   @Denom           = 0,
   @TransAmt        = @TransAmt,
   @Barcode         = @Barcode,
   @TransID         = @TransID,
   @CurrentAcctDate = @AcctDate,
   @TimeStamp       = @TimeStamp,
   @MachineNumber   = @MachineNumber,
   @CardAccount     = @CardAccount,
   @Balance         = @Balance,
   @GameCode        = @MachGameCode,
   @CoinsBet        = @CoinsBet,
   @LinesBet        = @LinesBet,
   @TierLevel       = @TierLevel,
   @PressUpCount    = 0,
   @LocationID      = @LocationID,
   @MachineTimeStamp = @MachineTimeStamp

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag
GO
