SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpMGAM_RegisterGame

Created 02-07-2005 by A. Murthy

Purpose: Returns all the parms. needed for MGAM "RegisterGame"

Return Dataset: GameDescription, LinesBet, CoinsBet, HoldPercent, Denomination

Called by: MgamClient.vb\RegisterGameXML

Arguments:
   @GameCode          
   @GameTypeCode  
   @MachineNumber Char(5) Machine identifier 
   @BankNo        int          

Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     02-07-2005     v5.0.0    Initial Version

A. Murthy     12-21-2005     v5.0.1
   Merged selects for Paper & EZTabs into a Single Select based on GameTypeCode.
   Added final write to DEBUG_INFO if Debugging mode is on.
   Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
   to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

A. Murthy     09-04-2006     v5.0.8
   Added PROG_FLAG from BANK table to ResultSet because MGAM V 1.06 needs it.

Terry Watkins 05-12-2010     v7.2.1
  Modified insert into CASINO_EVENT_LOG to update new columns ERROR_NO and
  MACH_NO.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpMGAM_RegisterGame]
   @GameCode           VarChar(3),
   @GameTypeCode       VarChar(2),
   @MachineNumber      Char(5),
   @BankNo             Integer
AS

-- Variable Declarations
DECLARE @CardRequired            Bit
DECLARE @CasinoID                Varchar(6)
DECLARE @CoinsBet                Int
DECLARE @Current_Error           Int
DECLARE @Debug                   Bit
DECLARE @Denomination            SmallMoney
DECLARE @DenominationAsInt       Int
DECLARE @ErrorID                 Int
DECLARE @ErrorDescription        VarChar(256)
DECLARE @ErrorSource             VarChar(64)
DECLARE @EventCode               VarChar(2)
DECLARE @EventLogDesc            VarChar(1024)
DECLARE @GameDescription         VarChar(64)
DECLARE @HoldPercent             Decimal
DECLARE @IsActive                TinyInt
DECLARE @IsPaper                 Int
DECLARE @LinesBet                Int
DECLARE @LockupMachine           Int
DECLARE @MachNbrAsInt            Int
DECLARE @MsgText                 VarChar(2048)
DECLARE @ProgFlag                Bit
DECLARE @TimeStamp               DateTime
DECLARE @ToTime                  DateTime

SET NOCOUNT ON

-- Variable Initialization
SET @CardRequired         = 1
SET @CoinsBet             = 0
SET @Current_Error        = 0
SET @Denomination         = 0
SET @DenominationAsInt    = 0
SET @ErrorID              = 0
SET @ErrorDescription     = ''
SET @ErrorSource          = 'tpMGAM_RegisterGame Stored Procedure'
SET @EventCode            = 'SP'
SET @GameDescription      = ''
SET @HoldPercent          = 0
SET @IsActive             = 0
SET @IsPaper              = 0
SET @LinesBet             = 0
SET @LockupMachine        = 0
SET @MachNbrAsInt         = CAST(@MachineNumber AS Int)
SET @MsgText              = ''
SET @ProgFlag             = 0
SET @TimeStamp            = GetDate()

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Retreive Casino Information.
SELECT @CasinoID     = CAS_ID,
       @ToTime       = TO_TIME,
       @CardRequired = PLAYER_CARD
FROM CASINO
WHERE SETASDEFAULT = 1

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpMGAM_RegisterGame'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpMGAM_RegisterGame Argument Values:  ' + 
         '  GameCode: '      + @GameCode +
         '  GameTypeCode: '  + @GameTypeCode +
         '  MachineNumber: ' + @MachineNumber +
         '  BankNo: '        + CAST(@BankNo AS VarChar)
      
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END

-- Update last activity and retrieve the IsActive flag...
UPDATE MACH_SETUP
SET @IsActive = ACTIVE_FLAG, LAST_ACTIVITY = @TimeStamp
WHERE MACH_NO = @MachineNumber

-- Find out if the Bank this machine is in plays Paper
SELECT @IsPaper = IS_PAPER FROM BANK WHERE BANK_NO = @BankNo

-- Find out if the Bank this machine is in supports Progressive wins.
SELECT @ProgFlag = CAST(PROGRESSIVE_TYPE_ID AS Bit)
FROM GAME_TYPE
WHERE GAME_TYPE_CODE = @GameTypeCode

-- Is the machine active?
IF (@IsActive = 1)
   -- Yes, so we can continue...
   BEGIN
      -- SELECT "GAME_DESC" col. in GAME_SETUP" table with @GameCode & @GameTypeCode
      SELECT @GameDescription = GAME_DESC
      FROM GAME_SETUP
      WHERE GAME_CODE = @GameCode AND GAME_TYPE_CODE = @GameTypeCode
      
      -- Check if we got a row back.
      IF (@@ROWCOUNT = 0)
          SET @ErrorID = 806
      
      IF (@ErrorID = 0)
         BEGIN
            -- Retrieve the Denomination, coins_bet, lines_bet, hold_percent
            SELECT DISTINCT
               @ErrorID                                  AS ErrorID,
               @ErrorDescription                         AS ErrorDescription,
               @LockupMachine                            AS ShutDownFlag,
               @GameDescription                          AS GameDescription,
               cbgt.COINS_BET                            AS CoinsBet,
               lbgt.LINES_BET                            AS LinesBet,
               CAST(dtgt.DENOM_VALUE * 100 AS INT)       AS Denomination,
               cf.HOLD_PERCENT                           AS HoldPercent,
               @ProgFlag                                 AS ProgressiveFlag
            FROM GAME_TYPE gt
               INNER JOIN DENOM_TO_GAME_TYPE     dtgt ON dtgt.GAME_TYPE_CODE = @GameTypeCode
               INNER JOIN COINS_BET_TO_GAME_TYPE cbgt ON cbgt.GAME_TYPE_CODE = @GameTypeCode
               INNER JOIN LINES_BET_TO_GAME_TYPE lbgt ON lbgt.GAME_TYPE_CODE = @GameTypeCode
               INNER JOIN CASINO_FORMS             cf ON cf.GAME_TYPE_CODE   = @GameTypeCode
               INNER JOIN DEAL_SEQUENCE           dsq ON cf.FORM_NUMB        = dsq.FORM_NUMB
            WHERE
               gt.GAME_TYPE_CODE = @GameTypeCode AND
               cf.IS_ACTIVE=1                    AND
               (dsq.CURRENT_DEAL_FLAG = 1 OR cf.IS_PAPER = 1)
             
             -- Check if we got a row back.
             IF (@@ROWCOUNT = 0)
                SET @ErrorID = 807
          END
   END
ELSE
   -- Machine is inactive
   SET @ErrorID = 103

-- Handle any errors
IF (@ErrorID <> 0)
   BEGIN
      SELECT
         @ErrorDescription = ISNULL([DESCRIPTION], 'Undefined Error ' + CAST(@ErrorID AS VarChar(10))),
         @LockupMachine    = ISNULL(LOCKUP_MACHINE, 1)
      FROM ERROR_LOOKUP
      WHERE ERROR_NO = @ErrorID
      
      -- If in Cardless Play mode, reset error text
      IF (@CardRequired = 0)
         SET @ErrorDescription = dbo.CardlessErrorText(@ErrorDescription)
      
      -- Build Error Message
      SET @EventLogDesc = 'Machine Number:' + @MachineNumber + ', Description:' + @ErrorDescription
      
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
      
      -- Return ERROR results to client
      SELECT
         @ErrorID           AS ErrorID,
         @ErrorDescription  AS ErrorDescription,
         @LockupMachine     AS ShutDownFlag,
         @GameDescription   AS GameDescription,
         @CoinsBet          AS CoinsBet,
         @LinesBet          AS LinesBet,
         @DenominationAsInt AS Denomination,
         @HoldPercent       AS HoldPercent,
         @ProgFlag          AS ProgressiveFlag
    END

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText = 'tpMGAM_RegisterGame - Return Values: ErrorID: ' + CAST(@ErrorID AS VarChar) +
                     '  ErrorDescription: ' + @ErrorDescription +
                     '  LockupMachine: '    + CAST(@LockupMachine AS VarChar)
      EXEC InsertDebugInfo 0, @MsgText, @MachNbrAsInt
   END
GO
