SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpGetMachine

Desc: Gets a machines properties.

Return values:

Called by: Transaction Portal

Parameters: @IP_Address - IP Address of the Machine for which
                          information is required.

Auth: Chris Coddington

Date: 4/9/2003

Change Log:
Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-13-2004
  Added 'AND REMOVED_FLAG = 0 to the WHERE clause.
  Throws an error if multiple machines are found.

Terry Watkins 10-25-2004
  Pulling back data from BANK, GAME_TYPE, and GAME_SETUP tables.

Terry Watkins 05-19-2005     v4.1.1
  Added retrieval of GAME_SETUP.TYPE_ID to resultset.

A. Murthy 01-16-2006         v5.0.1
  Added INSERT of CASINO_TRANS table TRANS_ID=33 for POWER_UP_COUNT for
  IowaLottery Machine Meters.

Terry Watkins 09-11-2006     v5.0.6
  Changed @CasinoMachNo from VarChar(5) to VarChar(8).

Terry Watkins 10-04-2006     v5.0.8
  Removed @TicketStatusID. No longer needed because column
  CASINO_TRANS.TICKET_STATUS_ID has been removed.

A. Murthy     11-07-2006     v5.0.8
  Added retrieval of MACH_SETUP.REBOOT_AFTER_DROP and VOUCHER_PRINTING for the
  first result-set.

Terry Watkins 09-24-2008     v6.0.2
  Added retrieval of BANK.LOCKUP_AMOUNT to the first resultset.
  Added ISNULL checks to values retrieved in the first resultset.
  Added code to throw an error if the setup is invalid.

Terry Watkins 03-06-2009     v6.0.4
  Added retrieval of BANK.PRODUCT_LINE_ID to the first resultset.

Terry Watkins 03-06-2009     v7.0.0
  Added retrieval of MACH_SETUP.OS_VERSION to the first resultset.
  Added logging to the DEBUG_INFO table if debug mode is set.
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AccountingDate changed from VarChar(16) to DateTime.

Terry Watkins 03-06-2009     v7.2.0
  Changed
    SET @MachNbrAsInt = CAST(@MachineNumber AS INT)
  to
    SET @MachNbrAsInt = ISNULL(CAST(@MachineNumber AS INT), -1)
  to prevent INSERT error if debug mode is set and the machine is
  not found in the MACH_SETUP table.

Terry Watkins 03-06-2009     v7.2.2
  Added retrieval of 7 new version columns from the MACH_SETUP table.

Terry Watkins 11-11-2010     DCLottery v1.0.0
  Added retrieval of @LocationID to support addition of column
  CASINO_TRANS.LOCATION_ID
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetMachine] @IP_ADDRESS VARCHAR(32)
AS

-- Variable Declarations
DECLARE @AccountingDate     DateTime
DECLARE @Balance            Money
DECLARE @Barcode            VarChar(20)
DECLARE @CardRequired       Bit
DECLARE @CasinoID           VarChar(6)
DECLARE @CasinoMachNo       VarChar(8)
DECLARE @Debug              Bit
DECLARE @ErrorText          VarChar(128)
DECLARE @GameRelease        VarChar(16)
DECLARE @LocationID         Int
DECLARE @MachineNumber      VarChar(5)
DECLARE @MachGameCode       VarChar(3)
DECLARE @MachNbrAsInt       Int
DECLARE @MsgText            VarChar(2048)
DECLARE @OSVersion          VarChar(16)
DECLARE @SystemVersion      VarChar(16)
DECLARE @SysCoreLibVersion  VarChar(16)
DECLARE @SysLibAVersion     VarChar(16)
DECLARE @RowCount           Int
DECLARE @TimeStamp          DateTime
DECLARE @TransID            SmallInt

SET NOCOUNT ON

SET @Balance            = 0
SET @Barcode            = ''
SET @LocationID         = 0
SET @MachNbrAsInt       = 0
SET @TimeStamp          = GetDate()
SET @TransID            = -33

-- Check Debug mode...
IF EXISTS(SELECT * FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpGetMachine')
   SELECT @Debug = DEBUG_MODE FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpGetMachine'
ELSE
   SET @Debug = 0

-- If Debug mode, save argument values...
IF (@Debug = 1)
   -- Record argument values.
   BEGIN
      SET @MsgText = 'tpGetMachine Argument Values:  IP Address: ' + ISNULL(@IP_ADDRESS, '<null>')
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve Casino Information.
SELECT
   @CasinoID   = CAS_ID,
   @LocationID = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get Current Accounting Date.
SET @AccountingDate = dbo.ufnGetAcctDate()

-- Get the number of rows for non-removed machines with the specified IP Address.
SELECT @RowCount = COUNT(*) FROM MACH_SETUP WHERE IP_ADDRESS = @IP_ADDRESS AND REMOVED_FLAG = 0

-- Check for duplicates...
IF (@RowCount > 1)
   BEGIN
      SET @ErrorText = 'Duplicate IP Addresses (' + @IP_ADDRESS + ') in Machine table.'
      IF (@Debug = 1) EXEC InsertDebugInfo @TransID, @ErrorText, @MachNbrAsInt
      RAISERROR (@ErrorText, 16, 1)
   END

-- Check for existance...
IF (@RowCount = 0)
   BEGIN
      SET @ErrorText = 'IP Addresses (' + @IP_ADDRESS + ') was not found in the Machine table for non-removed Machine.'
      IF (@Debug = 1) EXEC InsertDebugInfo @TransID, @ErrorText, @MachNbrAsInt
      RAISERROR (@ErrorText, 16, 1)
   END

-- Get the MACH_NO, GAME_CODE, CASINO_MACH_NO
SELECT 
   @Balance           = BALANCE,
   @MachineNumber     = MACH_NO,
   @MachGameCode      = GAME_CODE,
   @CasinoMachNo      = CASINO_MACH_NO,
   @GameRelease       = ISNULL(GAME_RELEASE, ''),
   @OSVersion         = ISNULL(OS_VERSION, '')
FROM MACH_SETUP
WHERE IP_ADDRESS = @IP_ADDRESS AND REMOVED_FLAG = 0

-- Now we have the machine number and can store it for debug messages.
SET @MachNbrAsInt = ISNULL(CAST(@MachineNumber AS INT), -1)

-- Record setup values if debug mode is set.
IF (@Debug = 1)
   -- Record argument values.
   BEGIN
      SET @MsgText = 'tpGetMachine retrieved values:  Machine Number: ' + ISNULL(@MachineNumber, '<null>') +
                     '  CasinoMachNo: ' + ISNULL(@CasinoMachNo, '<null>') +
                     '  GameCode: '     + ISNULL(@MachGameCode, '<null>') +
                     '  GameRelease: '  + ISNULL(@GameRelease, '<null>') +
                     '  OSVersion: '    + ISNULL(@OSVersion, '<null>') +
                     '  Balance: '      + CAST(@Balance AS VarChar) 
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Now check row count with joins, this checks for a valid setup.
SELECT @RowCount = COUNT(*)
FROM MACH_SETUP ms
   INNER JOIN BANK        b ON ms.BANK_NO = b.BANK_NO
   INNER JOIN GAME_TYPE  gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   INNER JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE ms.IP_ADDRESS = @IP_ADDRESS AND ms.REMOVED_FLAG = 0

IF (@RowCount = 0)
   BEGIN
      SET @ErrorText = 'Invalid Machine setup for Machine ' + @MachineNumber + '.'
      IF (@Debug = 1) EXEC InsertDebugInfo @TransID, @ErrorText, @MachNbrAsInt
      RAISERROR (@ErrorText, 16, 1)
   END

-- No errors so far, so generate the first resultset of Machine, Bank, and Game information.
SELECT
   ms.MACH_NO,
   ISNULL(ms.BANK_NO, 0)                  AS BANK_NO,
   ISNULL(ms.MACH_SERIAL_NO, '')          AS MACH_SERIAL_NO,
   ISNULL(ms.IP_ADDRESS, '')              AS IP_ADDRESS,
   ISNULL(ms.GAME_CODE, '')               AS GAME_CODE,
   CAST(ms.ACTIVE_FLAG AS INT)            AS ACTIVE_FLAG,
   @GameRelease                           AS GAME_RELEASE,
   @OSVersion                             AS OS_VERSION,
   ISNULL(ms.SYSTEM_VERSION, '')          AS SYSTEM_VERSION,
   ISNULL(ms.SYSTEM_LIB_A_VERSION, '')    AS SYSTEM_LIB_A_VERSION,
   ISNULL(ms.SYSTEM_CORE_LIB_VERSION, '') AS SYSTEM_CORE_LIB_VERSION,
   ISNULL(ms.MATH_DLL_VERSION, '')        AS MATH_DLL_VERSION,
   ISNULL(ms.GAME_CORE_LIB_VERSION, '')   AS GAME_CORE_LIB_VERSION,
   ISNULL(ms.GAME_LIB_VERSION, '')        AS GAME_LIB_VERSION,
   ISNULL(ms.MATH_LIB_VERSION, '')        AS MATH_LIB_VERSION,
   ISNULL(ms.CASINO_MACH_NO, '')          AS CASINO_MACH_NO,
   CAST (0 AS BIT)                        AS REBOOT_AFTER_DROP,
   CAST (ms.VOUCHER_PRINTING AS INT)      AS VOUCHER_PRINTING,
   ISNULL(b.BANK_DESCR, '')               AS BANK_DESCR,
   ISNULL(b.GAME_TYPE_CODE, '')           AS GAME_TYPE_CODE,
   CAST(b.PRODUCT_LINE_ID AS INT)         AS PRODUCT_LINE_ID,
   CAST((CAST(b.LOCKUP_AMOUNT AS MONEY) * 100) AS INTEGER) AS LOCKUP_AMOUNT,
   ISNULL(gt.LONG_NAME, '')               AS LONG_NAME,
   ISNULL(gs.GAME_DESC, '')               AS GAME_DESC,
   ISNULL(gs.TYPE_ID, '')                 AS TYPE_ID
FROM  MACH_SETUP ms
   INNER JOIN BANK        b ON ms.BANK_NO = b.BANK_NO
   INNER JOIN GAME_TYPE  gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   INNER JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE
WHERE ms.IP_ADDRESS = @IP_ADDRESS AND ms.REMOVED_FLAG = 0

-- Second resultset returns the Denoms for this machine.
SELECT d.DENOM_VALUE
FROM MACH_SETUP ms
   INNER JOIN BANK               b ON ms.BANK_NO = b.BANK_NO
   INNER JOIN DENOM_TO_GAME_TYPE d ON b.GAME_TYPE_CODE = d.GAME_TYPE_CODE
WHERE ms.IP_ADDRESS = @IP_ADDRESS AND ms.REMOVED_FLAG = 0

-- Check for Error
IF (@@ERROR = 0) AND (@RowCount = 1)
   BEGIN
	   -- Update CASINO_TRANS for POWER_UP_COUNT with TransID = 33
	   EXEC dbo.tpInsertCasinoTrans
		   @CasinoID        = @CasinoID, 
		   @DealNo          = 0,
		   @RollNo          = 0,
		   @TicketNo        = 0,
		   @Denom           = 0,
		   @TransAmt        = 0,
		   @Barcode         = @Barcode,
		   @TransID         = 33,
		   @CurrentAcctDate = @AccountingDate,
		   @TimeStamp       = @TimeStamp,
		   @MachineNumber   = @MachineNumber,
		   @CardAccount     = 'INTERNAL',
		   @Balance         = @Balance,
		   @GameCode        = @MachGameCode,
		   @CoinsBet        = 0,
		   @LinesBet        = 0,
		   @TierLevel       = 0,
		   @PressUpCount    = 0,
		   @LocationID      = @LocationID
   END
GO
