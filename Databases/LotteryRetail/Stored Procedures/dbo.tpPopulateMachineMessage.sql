SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpPopulateMachineMessage

Created 08-19-2005 by A. Murthy

Purpose: Loads "PlayerTracking" values returned by SDG "SYSTEMINIT" call into the MACHINE_MESSAGE table.

Return Dataset: ReturnCode

Called by: SdgServer.vb\PopulateMachineMessage

Arguments:
   @BirAccountValidMsgDefault   The displayed msg to a carded player after account validation & whose B'Day is today
   @AnnAccountValidMsgDefault   The displayed msg to a carded player after account validation & whose anniv. is today
   @VIPAccountValidMsgDefault   The displayed msg to a VIP player after account validation 
   @AccountValidMsgDefault      The displayed msg when Player is accepted by PlayerTracking system
   @AccountInvalidMsgDefault    The displayed msg when Player is rejected by PlayerTracking system
   @AttractIdleMsgDefault       The displayed msg to an uncarded player after inactivity
   @AttractMsgDefault           The displayed msg to an uncarded player after completing a game

Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     08-19-2005     v4.2.0
  Intitial coding.

A. Murthy     09-28-2005     v4.2.3
  Find and replace the "," that SDG puts in its messages with a blank space.
  
C. Coddington 01-31-2006     v5.0.1
  Added debug check before return value insertion.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpPopulateMachineMessage]
     @BirAccountValidMsgDefault         VarChar(512),
     @AnnAccountValidMsgDefault         VarChar(512),
     @VIPAccountValidMsgDefault         VarChar(512),
     @AccountValidMsgDefault            VarChar(512),
     @AccountInvalidMsgDefault          VarChar(512),
     @AttractIdleMsgDefault             VarChar(512),
     @AttractMsgDefault                 VarChar(512)
     
AS

-- Variable Declarations
DECLARE @CommaPos       Int
DECLARE @Current_Error  Int
DECLARE @Debug          Bit
DECLARE @MsgText        VarChar(4096)

SET NOCOUNT ON

-- Variable Initialization
SET @Current_Error = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpPopulateMachineMessage'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpPopulateMachineMessage Argument Values:  ' + 
         '    @BirAccountValidMsgDefault: ' +  @BirAccountValidMsgDefault +
         '    @AnnAccountValidMsgDefault: ' +  @AnnAccountValidMsgDefault +
         '    @VIPAccountValidMsgDefault: ' +  @VIPAccountValidMsgDefault +
         '    @AccountValidMsgDefault: '    +  @AccountValidMsgDefault +
         '    @AccountInvalidMsgDefault: '  +  @AccountInvalidMsgDefault +
         '    @AttractIdleMsgDefault: '     +  @AttractIdleMsgDefault +
         '    @AttractMsgDefault: '         +  @AttractMsgDefault
      
      EXEC InsertDebugInfo 0, @MsgText, 0
   END

-- initialize @MsgText to store any Errors from Insert/Updates into MACHINE_MESSAGE table
SET @MsgText = ''

-- Replace all occurences of a "comma" with a "blank" space if any.
SELECT @BirAccountValidMsgDefault = REPLACE (@BirAccountValidMsgDefault, ',', ' ')

-- Update "TPI_MESSAGE" col. in "MACHINE_MESSAGE" table with "BirAccountValidMsgDefault"
UPDATE MACHINE_MESSAGE SET TPI_MESSAGE = @BirAccountValidMsgDefault WHERE MACHINE_MESSAGE_ID = 1

-- If the MACHINE_MESSAGE_ID col. does not have 1 then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO MACHINE_MESSAGE
	(MACHINE_MESSAGE_ID, TPI_MESSAGE, IS_ACTIVE)
    VALUES
	(1, @BirAccountValidMsgDefault, 1)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 628
      SET @MsgText = 'tpPopulateMachineMessage Insert/Update of MACHINE_MESSAGE failed for BirAccountValidMsgDefault'
   END

-- Replace all occurences of a "comma" with a "blank" space if any.
SELECT @AnnAccountValidMsgDefault = REPLACE (@AnnAccountValidMsgDefault, ',', ' ')

-- Update "TPI_MESSAGE" col. in "MACHINE_MESSAGE" table with "AnnAccountValidMsgDefault"
UPDATE MACHINE_MESSAGE SET TPI_MESSAGE = @AnnAccountValidMsgDefault WHERE MACHINE_MESSAGE_ID = 2

-- If the MACHINE_MESSAGE_ID col. does not have 2 then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO MACHINE_MESSAGE
	(MACHINE_MESSAGE_ID, TPI_MESSAGE, IS_ACTIVE)
    VALUES
	(2, @AnnAccountValidMsgDefault, 1)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 628
      SET @MsgText = 'tpPopulateMachineMessage Insert/Update of MACHINE_MESSAGE failed for AnnAccountValidMsgDefault'
   END


-- Replace all occurences of a "comma" with a "blank" space if any.
SELECT @VIPAccountValidMsgDefault = REPLACE (@VIPAccountValidMsgDefault, ',', ' ')

-- Update "TPI_MESSAGE" col. in "MACHINE_MESSAGE" table with "VIPAccountValidMsgDefault"
UPDATE MACHINE_MESSAGE SET TPI_MESSAGE = @VIPAccountValidMsgDefault WHERE MACHINE_MESSAGE_ID = 3

-- If the MACHINE_MESSAGE_ID col. does not have 3 then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO MACHINE_MESSAGE
	(MACHINE_MESSAGE_ID, TPI_MESSAGE, IS_ACTIVE)
    VALUES
	(3, @VIPAccountValidMsgDefault, 1)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 628
      SET @MsgText = 'tpPopulateMachineMessage Insert/Update of MACHINE_MESSAGE failed for VIPAccountValidMsgDefault'
   END


-- Replace all occurences of a "comma" with a "blank" space if any.
SELECT @AccountValidMsgDefault = REPLACE (@AccountValidMsgDefault, ',', ' ')

-- Update "TPI_MESSAGE" col. in "MACHINE_MESSAGE" table with "AccountValidMsgDefault"
UPDATE MACHINE_MESSAGE SET TPI_MESSAGE = @AccountValidMsgDefault WHERE MACHINE_MESSAGE_ID = 4

-- If the MACHINE_MESSAGE_ID col. does not have 4 then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO MACHINE_MESSAGE
	(MACHINE_MESSAGE_ID, TPI_MESSAGE, IS_ACTIVE)
    VALUES
	(4, @AccountValidMsgDefault, 1)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 628
      SET @MsgText = 'tpPopulateMachineMessage Insert/Update of MACHINE_MESSAGE failed for AccountValidMsgDefault'
   END


-- Replace all occurences of a "comma" with a "blank" space if any.
SELECT @AccountInValidMsgDefault = REPLACE (@AccountInValidMsgDefault, ',', ' ')

-- Update "TPI_MESSAGE" col. in "MACHINE_MESSAGE" table with "AccountInValidMsgDefault"
UPDATE MACHINE_MESSAGE SET TPI_MESSAGE = @AccountInValidMsgDefault WHERE MACHINE_MESSAGE_ID = 5

-- If the MACHINE_MESSAGE_ID col. does not have 5 then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO MACHINE_MESSAGE
	(MACHINE_MESSAGE_ID, TPI_MESSAGE, IS_ACTIVE)
    VALUES
	(5, @AccountInValidMsgDefault, 1)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 628
      SET @MsgText = 'tpPopulateMachineMessage Insert/Update of MACHINE_MESSAGE failed for AccountInValidMsgDefault'
   END


-- Replace all occurences of a "comma" with a "blank" space if any.
SELECT @AttractIdleMsgDefault = REPLACE (@AttractIdleMsgDefault, ',', ' ')

-- Update "TPI_MESSAGE" col. in "MACHINE_MESSAGE" table with "AttractIdleMsgDefault"
UPDATE MACHINE_MESSAGE SET TPI_MESSAGE = @AttractIdleMsgDefault WHERE MACHINE_MESSAGE_ID = 10

-- If the MACHINE_MESSAGE_ID col. does not have 10 then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO MACHINE_MESSAGE
	(MACHINE_MESSAGE_ID, TPI_MESSAGE, IS_ACTIVE)
    VALUES
	(10, @AttractIdleMsgDefault, 1)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 628
      SET @MsgText = 'tpPopulateMachineMessage Insert/Update of MACHINE_MESSAGE failed for AttractIdleMsgDefault'
   END


-- Replace all occurences of a "comma" with a "blank" space if any.
SELECT @AttractMsgDefault = REPLACE (@AttractMsgDefault, ',', ' ')

-- Update "TPI_MESSAGE" col. in "MACHINE_MESSAGE" table with "AttractMsgDefault"
UPDATE MACHINE_MESSAGE SET TPI_MESSAGE = @AttractMsgDefault WHERE MACHINE_MESSAGE_ID = 20

-- If the MACHINE_MESSAGE_ID col. does not have 20 then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO MACHINE_MESSAGE
	(MACHINE_MESSAGE_ID, TPI_MESSAGE, IS_ACTIVE)
    VALUES
	(20, @AttractMsgDefault, 1)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 628
      SET @MsgText = 'tpPopulateMachineMessage Insert/Update of MACHINE_MESSAGE failed for AttractMsgDefault'
   END

IF (@Debug = 1)
   BEGIN
      -- make the final entry into DEBUG_INFO table
      SET @MsgText = @MsgText + '  Return Value: ' + CAST(@Current_Error AS VarChar)
      EXEC InsertDebugInfo 0, @MsgText, 0
   END
   
-- Return the error code as a resultset.
SELECT @Current_Error AS ReturnCode
GO
