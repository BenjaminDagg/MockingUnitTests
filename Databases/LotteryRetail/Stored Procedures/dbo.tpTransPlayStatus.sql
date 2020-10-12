SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpTransPlayStatus

Created 05-06-2011 by Terry Watkins

Desc: Handles PlayStatus messages from machines.

Return values: ErrorID
               ErrorDescription
               ShutDownFlag
 
Called by: Transaction Portal

Parameters:
   @MachineNumber       Machine number
   @CardAccount         Card Account Number in the machine
   @DealNumber          Deal Number of Roll being put in machine
   @MachineDenomination Denom of the machine or 0 if multi-denom
   @MachineSequence     Transaction Sequence number
   @TicketNumber        Ticket number
   @TimeStamp           Date and time sent


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
  
Louis Epstein 10-25-2013     v3.1.6
  Added play status logging functionality
  
Edris Khestoo 08-28-2014     v3.2.7
  Changed logic selecting balance on @Balance variable mach setup to use where clause.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransPlayStatus]
   @MachineNumber       VarChar(5),
   @PlayStatus          Bit,
   @TimeStamp DateTime
AS
-- SET NOCOUNT ON to prevent return of unwanted messages
SET NOCOUNT ON

-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @Balance           Money
DECLARE @CasinoID          VarChar(6)
DECLARE @CasinoTransID     Int
DECLARE @Debug             Bit
DECLARE @ErrorDescription  VarChar(256)
DECLARE @ErrorSource       VarChar(64)
DECLARE @ErrorID           Int
DECLARE @GameCode          VarChar(3)
DECLARE @LocationID        Int
DECLARE @LockupMachine     Int
DECLARE @MachNbrAsInt      Int
DECLARE @MsgText           VarChar(2048)
DECLARE @MachineTimeStamp         DateTime
DECLARE @TransID           SmallInt

-- Variable Initialization
SET @MachineTimeStamp = @TimeStamp
SET @Balance          = 0
SET @Debug            = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpTransPlayStatus Stored Procedure'
SET @ErrorID          = 0
SET @GameCode         = ''
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachNbrAsInt     = ISNULL(CAST(@MachineNumber AS Int), 0)
SET @MsgText          = ''
SET @TimeStamp        = GETDATE()
SET @TransID          = 35

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransPlayStatus'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransPlayStatus Arguments - MachineNumber: ' + ISNULL(@MachineNumber, '<null>') +
         '  PlayStatus: ' + ISNULL(CAST(@PlayStatus AS VarChar), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve Casino Information.
SELECT
   @CasinoID     = CAS_ID,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get Current Accounting Date to record in the audit table.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Update MACH_SETUP.PLAY_STATUS
IF EXISTS (SELECT * FROM dbo.MACH_SETUP WHERE MACH_NO = @MachineNumber)
BEGIN

EXEC ChangePlayStatus @MachineNumber, @PlayStatus

   SELECT @GameCode = GAME_CODE,
          @Balance  = BALANCE
   FROM dbo.MACH_SETUP 
   WHERE MACH_NO = @MachineNumber
      
END
ELSE
   -- Invalid machine
   SET @ErrorID = 104

-- If the machine exists, log Play Status message event in the audit table.
IF (@ErrorID = 0)
   EXEC @CasinoTransID = dbo.tpInsertCasinoTrans
      @CasinoID        = @CasinoID,
      @DealNo          = 0,
      @RollNo          = 0,
      @TicketNo        = 0,
      @Denom           = 0,
      @TransAmt        = 0,
      @Barcode         = '',
      @TransID         = @TransID,
      @CurrentAcctDate = @AcctDate,
      @TimeStamp       = @TimeStamp,
      @MachineNumber   = @MachineNumber,
      @CardAccount     = 'INTERNAL',
      @Balance         = @Balance,
      @GameCode        = @GameCode,
      @CoinsBet        = 0,
      @LinesBet        = 0,
      @TierLevel       = 0,
      @PressUpCount    = 0,
      @LocationID      = @LocationID,
      @MachineTimeStamp = @MachineTimeStamp

-- Return results to client
SELECT
   @ErrorID            AS ErrorID,
   @ErrorDescription   AS ErrorDescription,
   @LockupMachine      AS ShutDownFlag
GO
