SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: tpGetMachineBalance

Desc: Gets the current machine balance

Called by: Transaction Portal

Parameters: @MachineNbr  Machine Number
            @CardAcct    Card Account Number

Auth: Terry Watkins

Date: 12-14-2007

Change Log:
Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-14-2007     v6.0.2
  Initial coding
  Note that the Promo amount always comes from the MACH_SETUP table.
  The balance will come from the MACH_SETUP table when in non-card play mode and
  will come from the CARD_ACCT table when in card play mode.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetMachineBalance]
   @MachineNumber       Char(5),
   @CardAccount         VarChar(20)
AS

-- Variable Declarations
DECLARE @Balance            Money
DECLARE @PromoBalance       Money

DECLARE @CardRequired       Bit
DECLARE @Debug              Bit

DECLARE @TransID            SmallInt

DECLARE @ErrorCode          Int
DECLARE @ErrorID            Int
DECLARE @LockupMachine      Int
DECLARE @MachNbrAsInt       Int
DECLARE @RowCount           Int

DECLARE @BalanceTable       VarChar(32)
DECLARE @ErrorDescription   VarChar(256)
DECLARE @MsgText            VarChar(2048)

-- Suppress return of extra data.
SET NOCOUNT ON

-- Variable Initialization
SET @Balance           = 0
SET @BalanceTable      = ''
SET @ErrorDescription  = ''
SET @ErrorID           = 0
SET @LockupMachine     = 0
SET @MachNbrAsInt      = CAST(@MachineNumber AS Int)
SET @PromoBalance      = 0
SET @TransID           = 65

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpGetMachineBalance'

-- If Debug mode, save argument values...
IF (@Debug = 1)
   -- Record argument values.
   BEGIN
      SET @MsgText = 'tpGetMachineBalance Argument Values:  MachineNumber: ' +
          @MachineNumber + '  CardAccount: ' + @CardAccount
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve Casino PlayerCard value
SELECT @CardRequired  = PLAYER_CARD FROM CASINO WHERE SETASDEFAULT = 1
SELECT @ErrorCode = @@ERROR, @RowCount = @@ROWCOUNT

-- We expect exactly one row and no errors.
IF (@ErrorCode <> 0 OR @RowCount <> 1) SET @ErrorID = 201

-- Any errors yet?
IF (@ErrorID = 0)
   -- No errors, so we can continue.
   BEGIN
      -- Retrieve the PromoAmount and the balance from the MACH_SETUP table.
      -- If in Card Play mode, we will reset the balance by retrieving it from
      -- the CARD_ACCT table below.
      SELECT
         @Balance      = BALANCE,
         @PromoBalance = PROMO_BALANCE
      FROM MACH_SETUP
      WHERE MACH_NO = @MachineNumber
      
      -- Again, we expect exactly one row and no errors.
      SELECT @ErrorCode = @@ERROR, @RowCount = @@ROWCOUNT
      IF (@ErrorCode <> 0 OR @RowCount <> 1) SET @ErrorID = 104
      
      -- Are we in Card Play mode?
      IF (@ErrorID = 0 AND @CardRequired = 0)
         BEGIN
            -- No player card in use so retrieve from the MACH_SETUP table.
            SET @BalanceTable = 'MACH_SETUP'
         END
      IF (@ErrorID = 0 AND @CardRequired = 1)
         BEGIN
            -- Player card in use so retrieve Balance the CARD_ACCT table.
            SET @BalanceTable = 'CARD_ACCT'
            SELECT @Balance = BALANCE FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAccount
            
            -- Again, we expect exactly one row and no errors.
            SELECT @ErrorCode = @@ERROR, @RowCount = @@ROWCOUNT
            IF (@ErrorCode <> 0 OR @RowCount <> 1) SET @ErrorID = 102
         END
   END

-- Handle errors...
IF (@ErrorID <> 0)
   BEGIN
      -- Retrieve ERROR_LOOKUP information...
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 0)
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
   END

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpGetMachineBalance Return Values - ErrorID: ' + CAST(@ErrorID AS VarChar) +
         '  ErrorDescription: '  + @ErrorDescription               +
         '  LockupMachine: '     + CAST(@LockupMachine AS VarChar) +
         '  Balance: '           + CAST(@Balance AS VarChar)       +
         '  PromoAmount: '       + CAST(@PromoBalance AS VarChar)  +
         '  Balance came from: ' + @BalanceTable
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Return data
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag,
   @Balance          AS Balance,
   @PromoBalance     AS PromoBalance

GO
