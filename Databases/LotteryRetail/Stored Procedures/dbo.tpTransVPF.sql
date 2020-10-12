SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpTransVPF (tpTrans Voucher Print Failed)

Created 03-11-2009 by Terry Watkins

Purpose:
   Records voucher print failure in CASINO_TRANS and CASINO_EVENT_LOG.

Return value:
   None

Returned dataset:
   ErrorCode, ErrorDescription, ShutdownFlag


Called by: TransactionPortal
           TpiClient::HandleVoucherPrintFailed


Parameters:
   @MachineNumber    The DGE machine number
   @MachineBalance   Balance in cents that the Machine is showing
   @CardAccount      CardAccount in machine
   @ErrorCode        Error code indicating why print failed


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-11-2009     v6.0.4
  Initial coding

Terry Watkins 11-03-2009     v7.0.0
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AcctDate changed from VarChar(16) to DateTime.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added retrieval of @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransVPF]
   @MachineNumber       Char(5),
   @MachineBalance      Int,
   @CardAccount         VarChar(20),
   @ErrorCode           Int,
   @TimeStamp			DateTime
AS

-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @Balance           Money
DECLARE @CardRequired      Bit
DECLARE @CasinoID          VarChar(6)
DECLARE @CasinoTransID     Int
DECLARE @Debug             Bit
DECLARE @ErrorID           Int
DECLARE @ErrorSource       VarChar(64)
DECLARE @ErrorText         VarChar(1024)
DECLARE @ErrorDescription  VarChar(256)
DECLARE @EventCode         VarChar(2)
DECLARE @EventLogDesc      VarChar(1024)
DECLARE @LocationID        Int
DECLARE @LockupMachine     Int
DECLARE @MachGameCode      Char(3)
DECLARE @MachNbrAsInt      Int
DECLARE @MsgText           VarChar(2048)
DECLARE @MachineTimeStamp  DateTime
DECLARE @TransID           SmallInt

SET NOCOUNT ON

-- Variable Initialization
SET @MachineTimeStamp = @TimeStamp
SET @Balance          = 0
SET @ErrorDescription = ''
SET @ErrorID          = 0
SET @ErrorSource      = 'tpTransVPF Stored Procedure'
SET @ErrorText        = ''
SET @EventCode        = 'VE'
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachGameCode     = ''
SET @MachNbrAsInt     = CAST(@MachineNumber AS Int)
SET @TransID          = 17
SET @TimeStamp        = GetDate()

-- If the Card Account is null or empty, set to INTERNAL.
IF ISNULL(@CardAccount, '') = '' SET @CardAccount = 'INTERNAL'

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransVPF'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVPF Arguments - MachineNumber: ' + @MachineNumber +
         '  MachineBalance: ' + CAST(@MachineBalance AS VarChar) +
         '  CardAccount: '    + @CardAccount +
         '  ErrorCode: '      + CAST(@ErrorCode AS VarChar)
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve CASINO information.
SELECT
   @CasinoID     = CAS_ID,
   @CardRequired = PLAYER_CARD,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Call GetMachineStatus function (checks for Machine not found, inactive, or removed).
SET @ErrorID = dbo.GetMachineStatus(@MachineNumber)

IF (@Debug = 1)
   BEGIN
      SET @MsgText = 'GetMachineStatus returned: ' + CAST(@ErrorID AS VarChar)
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Set last activity and retrieve the Machine Balance if the machine record exists in MACH_SETUP.
IF (@ErrorID <> 104)
   UPDATE MACH_SETUP SET
      LAST_ACTIVITY = @TimeStamp,
      @Balance      = BALANCE,
      @MachGameCode = GAME_CODE
   WHERE
      MACH_NO = @MachineNumber

-- Test that machine exists in the MACH_SETUP table.
IF (@ErrorID = 0)
   -- Machine exists and is Active and not flagged as Removed...
   BEGIN
      -- Log transaction.
      EXEC @CasinoTransID = tpInsertCasinoTrans
         @CasinoID        = @CasinoID,
         @DealNo          = 0,
         @TransAmt        = 0,
         @TransID         = @TransID,
         @CurrentAcctDate = @AcctDate,
         @TimeStamp       = @TimeStamp,
         @MachineNumber   = @MachineNumber,
         @CardAccount     = @CardAccount,
         @Balance         = @Balance,
         @GameCode        = @MachGameCode,
         @LocationID      = @LocationID,
         @MachineTimeStamp = @MachineTimeStamp
      
      -- Insert into the CASINO_EVENT_LOG table...
      IF (@ErrorCode <> 0)
         -- Error Code (reason for the print failure) is non-zero,
         -- so lookup the description in the ERROR_LOOKUP table.
         IF EXISTS(SELECT * FROM ERROR_LOOKUP WHERE ERROR_NO = @ErrorCode)
            SELECT @ErrorDescription = [DESCRIPTION] FROM ERROR_LOOKUP WHERE ERROR_NO = @ErrorCode
         
      SET @EventLogDesc = 'Voucher print failed.  Machine ' + @MachineNumber +
                          '.  ErrorCode ' + CAST(@ErrorCode AS VarChar) + '.'
      
      -- If we retrieved an error description from the ERROR_LOOKUP table, append it.
      IF (LEN(@ErrorDescription) > 0)
         SET @EventLogDesc = @EventLogDesc + '  ' + @ErrorDescription
      
      -- Insert the CASINO_EVENT_LOG row.
      -- Note that the @ErrorCode value from the machine is inserted.
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ID_VALUE, ERROR_NO, MACH_NO)
      VALUES
         (@EventCode, @ErrorSource, @EventLogDesc, @CasinoTransID, @ErrorCode, @MachineNumber)
      
      -- Set the error decription back to an empty string.
      SET @ErrorDescription = ''
   END
ELSE
   -- ErrorID was not zero, handle the error.   BEGIN
      SELECT
         @ErrorDescription = [DESCRIPTION],         @LockupMachine    = LOCKUP_MACHINE
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
      
      IF (@@ROWCOUNT = 0)
         -- ERROR_LOOKUP row not found.
         BEGIN
            SET @LockupMachine = 1
            SET @ErrorDescription = 'Undefined Error (Error: '
            IF (@ErrorID IS NULL)
               SET @ErrorDescription = @ErrorDescription + 'NULL)'
            ELSE
               SET @ErrorDescription = @ErrorDescription + CAST(@ErrorID AS VarChar) + ')'
         END
      
      -- If in Cardless Play mode, reset error text.
      IF (@CardRequired = 0)
         SET @ErrorDescription = dbo.CardlessErrorText(@ErrorDescription)
      
      -- Build Error Message
      SET @EventLogDesc = 'Description:' + @ErrorDescription + 
                          ', Machine Number:' + @MachineNumber + @ErrorText
      
      -- Test if the Machine should be locked up.
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
   END


-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVPF Return Values - ErrorID: ' + CAST(ISNULL(@ErrorID, 0) AS VarChar(10)) +
         '  ErrorDescription: ' + @ErrorDescription +
         '  LockupMachine: ' + CAST(@LockupMachine AS VarChar(10))
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,   @LockupMachine    AS ShutDownFlag
GO
