SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpTransX

Created 04-11-2003 by Chris Coddington

Desc: Handles all shutdown requests.

Return values: ErrorID,
               ErrorDescription,
               ShutDownFlag

Called by: Transaction Portal

Parameters:
   @Error            Error Number
   @MachineNumber    Machine Number
   @MachineSequence  Transaction Sequence number
   @TimeStamp        DateTime


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Chris C.      12-15-2003

  Changed parameter name from @ErrorID to @Error.

Chris C.      02-10-2004
  Changed float datatypes to money datatypes.

Terry Watkins 03-01-2004
  Added insertion of the Game Code of the Machine into CASINO_TRANS.

Terry Watkins 11-01-2004     v4.0.0
  Added insertion of TransID into CASINO_TRANS.
  Added call to udf CardlessErrorText when in Cardless Play mode.

Terry Watkins 11-01-2004     v4.1.4
  Changed datatype of @CardAccount from Char(16) to VarChar(20).

A. Murthy     01-16-2006     v5.0.1
  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
  to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

A. Murthy     03-10-2006     v5.0.2
  Force MACH_SETUP.ACTIVE_FLAG to 0 irrespective of @LockupMachine. Per Dom 

Terry Watkins 06-14-2006     v5.0.4
  Added link from CASINO_TRANS to CASINO_EVENT_LOG by populating
  CASINO_EVENT_LOG.ID_VALUE with CASINO_TRANS.TRANS_NO.

A. Murthy     09-29-2006     v5.0.7
  Force the machine to go Active (i.e. Startup machine) if input parmameter
  @Error = 0. Per Dave Nessen to support starting the machine from the machine
  maintenance screen.

Terry Watkins 10-04-2006     v5.0.8
  Removed @TicketStatusID. No longer needed because column
  CASINO_TRANS.TICKET_STATUS_ID has been removed.

Terry Watkins 11-03-2009     v7.0.0
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AcctDate changed from VarChar(16) to DateTime.

Terry Watkins 05-11-2010     v7.2.1
  Updates new columns ERROR_NO and MACH_NO in CASINO_EVENT_LOG.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added retrieval of @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID

Aldo Zamora 04-22-2013     Lottery Retail v3.1.0
  Added LocationID WHEN updating the TabError table.
  
Louis Epstein 09-23-2013     Lottery Retail v3.1.5
  Added functionality for tracking ticket numbers
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransX]
   @Error           Int,
   @MachineNumber   VarChar(5),
   @MachineSequence Int,
   @TimeStamp       DateTime,
   @TicketNumber    Int = 0
AS

-- Variables
DECLARE @AcctDate         DateTime
DECLARE @Balance          Money
DECLARE @Barcode          VarChar(20)
DECLARE @CardAccount      VarChar(20)
DECLARE @CardRequired     Bit
DECLARE @CasinoID         VarChar(6)
DECLARE @CasinoTransID    Int
DECLARE @CoinsBet         Int
DECLARE @DealNo           Int
DECLARE @Debug            Bit
DECLARE @ErrorDescription VarChar(256)
DECLARE @ErrorSource      VarChar(64)
DECLARE @ErrorText        VarChar(1024)
DECLARE @ErrorTypeID      Int
DECLARE @EventCode        VarChar(2)
DECLARE @EventLogDesc     VarChar(1024)
DECLARE @LinesBet         Int
DECLARE @LocationID       Int
DECLARE @LockupMachine    Int
DECLARE @MachGameCode     VarChar(3)
DECLARE @MachNbrAsInt     Int
DECLARE @MsgText          VarChar(3072)
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
SET @CardAccount      = 'INTERNAL'
SET @CardRequired     = 1
SET @CoinsBet         = 0
SET @DealNo           = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpTransX Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'SD'
SET @EventLogDesc     = ''
SET @LinesBet         = 0
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachNbrAsInt     = CAST(@MachineNumber AS Int)
SET @RollNo           = 0
SET @TicketNo         = 0
SET @TierLevel        = 0
SET @TransAmt         = 0
SET @TransID          = 61
SET @TimeStamp        = GetDate()

IF @TicketNumber <= 0
	SET @TicketNumber = NULL


-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransX'

-- Retrieve Casino information.
SELECT
   @CasinoID     = CAS_ID,
   @CardRequired = PLAYER_CARD,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

UPDATE MACH_SETUP SET
   LAST_ACTIVITY = @TimeStamp,
   @MachGameCode = GAME_CODE
WHERE MACH_NO = @MachineNumber

-- If input parameter @Error = 0 then force machine to go Active (i.e. Startup machine).
IF (@Error = 0)
   UPDATE MACH_SETUP SET ACTIVE_FLAG = 1 WHERE MACH_NO = @MachineNumber
ELSE
   BEGIN
      -- Process the Non-Zero @Error value.
      IF EXISTS(SELECT * FROM ERROR_LOOKUP WHERE ERROR_NO = @Error)
         BEGIN
            SELECT
               @ErrorDescription = [DESCRIPTION],
               @LockupMachine    = LOCKUP_MACHINE,
               @ErrorTypeID      = ERROR_TYPE_ID
            FROM ERROR_LOOKUP
            WHERE ERROR_NO = @Error
         END
      ELSE
         BEGIN
            SET @ErrorDescription = 'Undefined Error ' + CAST(@Error AS VarChar)
            SET @LockupMachine    = 1
            SET @ErrorTypeID      = 0
         END
      
      -- If in Cardless Play mode, reset error text.
      IF (@CardRequired = 0)
         SET @ErrorDescription = dbo.CardlessErrorText(@ErrorDescription)

      -- If the lockup flag is set, reset the ACTIVE_FLAG in the MACH_SETUP table to 0 (i.e. shutdown machine).
      IF (@LockupMachine = 1)
         UPDATE MACH_SETUP SET ACTIVE_FLAG = 0 WHERE MACH_NO = @MachineNumber AND ACTIVE_FLAG = 1            -- If the ErrorTypeID is 1 then it is a tab error so record it in the TAB_ERROR table.      IF (@ErrorTypeID = 1)         INSERT INTO TAB_ERROR (MACH_NO, ERROR_NO, EVENT_TIME, LOCATION_ID, TICKET_NO) VALUES (@MachineNumber, @Error, @TimeStamp, @LocationID, @TicketNumber)   END

-- Build Error Message
SET @EventLogDesc =
   'Description: '      + @ErrorDescription +
   ' Error: '           + CAST(@Error AS VarChar) +
   '. Machine Number: ' + @MachineNumber +
   '. Lockup Flag: '    + CAST(@LockupMachine AS VarChar)

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpTransX Values:  Error: ' + ISNULL(CAST(@Error AS VarChar), '<null>') +
         '  MachineNumber: '         + ISNULL(@MachineNumber, '<null>') +
         '  MachineSequence: '       + ISNULL(CAST(@MachineSequence AS VarChar), '<null>') +
         '  TimeStamp: '             + ISNULL(CAST(@TimeStamp AS VarChar), '<null>') +
         '  EventLog Text: '         + @EventLogDesc
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Log transaction.
EXEC @CasinoTransID = tpInsertCasinoTrans
   @CasinoID, @DealNo, @RollNo, @TicketNo, 0, @TransAmt, @Barcode,
   @TransID, @AcctDate, @TimeStamp, @MachineNumber, @CardAccount,
   @Balance, @MachGameCode, @CoinsBet, @LinesBet, @TierLevel,
   0, @LocationID, @MachineTimeStamp

-- Insert Error into the Casino_Event_Log
INSERT INTO CASINO_EVENT_LOG
   (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ID_VALUE, ERROR_NO, MACH_NO)
VALUES
   (@EventCode, @ErrorSource, @EventLogDesc, @CasinoTransID, @Error, @MachineNumber)

-- Return results to client
SELECT
   @Error            AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag
GO
