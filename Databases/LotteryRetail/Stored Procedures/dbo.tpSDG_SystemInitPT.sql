SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpSDG_SystemInitPT

Created 01-14-2005 by A. Murthy

Purpose: Loads "PlayerTracking" values returned by SDG "SYSTEMINIT" call into the TPI_SETTING table.

Return Dataset: ReturnCode

Called by: SdgServer.vb\processSystemInitPT

Arguments:
   @CountTypeDefault            Type of counting method (0,1,2,3,4,5)
   @CountdownResetDefault       Starting or ending point for countdown register
   @AwardDefault                Number of points to be awarded to player per  @CountTypeDefault
   @HotPlayerEvalTimeDefault    Time in Secs for an uncarded player to meet criteria    
   @HotPlayerWagerDefault       Total wager in cents made by uncarded player during  @HotPlayerEvalTimeDefault
   @HotPlayerGamesDefault       Total #of games played by uncarded player during  @HotPlayerEvalTimeDefault
   @HotPlayerResetTimeDefault   Total # of seconds uncarded player inactive during  @HotPlayerEvalTimeDefault
   @AbandonedCardTimeDefault    Total # of seconds carded player is inactive
   @StatusUpdateTimeDefault     How often a status message is sent by TPS to SDG for carded player
   @GameStartMsgDefault         The displayed msg for game inititation
   @GameEndMsgDefault           The displayed msg for game completion
   @VoucherInMsgDefault         The displayed msg for Voucher insertion.
   @VoucherOutMsgDefault        The displayed msg for Voucher printout.
   @CashInMsgDefault            The displayed msg for Cash insertion
   @CashOutMsgDefault           The displayed msg for PlayerTracking Cashout.
   @AccountValidMsgDefault      The displayed msg when Player is accepted by PlayerTracking system
   @AccountInvalidMsgDefault    The displayed msg when Player is rejected by PlayerTracking system
   @CardReadErrorMsgDefault     The displayed msg when PlayerTracking system fails to read a card
   @AbandonedCardMsgDefault     The displayed msg when PlayerTracking system determines that card is abandoned
   @IdleMsgDefault              The displayed msg when PlayerTracking system determines that card is idle
   @OfflineMsgDefault           The displayed msg when PlayerTracking system is known to be offline
   @CardInMsgDefault            The displayed msg when card is inserted into Player terminal
   @CardOutMsgDefault           The displayed msg when card is removed from Player terminal
   @AwardMsgDefault             The displayed msg when awarded 1 or more points
   @AttractMsgDefault           The displayed msg to an uncarded player after completing a game
   @AttractIdleMsgDefault       The displayed msg to an uncarded player after inactivity
   @VIPAccountValidMsgDefault   The displayed msg to a VIP player after account validation 
   @AnnAccountValidMsgDefault   The displayed msg to a carded player after account validation & whose anniv. is today
   @EmpAccountValidMsgDefault   The displayed msg to a carded player who is an employee
   @CertificateInMsgDefault     The displayed msg when prize certificate is inserted
   @CertificateOutMsgDefault    The displayed msg when prize certificate is printed
   @SendEventsDefault           Boolean indicating if Player Terminal event msg should be sent to gateway by SDG
   @BirAccountValidMsgDefault   The displayed msg to a carded player after account validation & whose B'Day is today
   @DebugLevel                  Causes different levels of error logging to occur. (currently ignored)
   @AccountNumberTrack          Account Number track that will be used with PlayerTracking at a player terminal
   @Optimization                Off=0, On=1, cuts down transmission of unnecessary Card Inserted/Removed msgs.

Change Log:

Changed By    Change Date    Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     01-14-2005     v4.1.0
  Initial Version

A. Murthy     08-19-2005     v4.2.0
  Truncate TPI_SETTING table first, before loading it.

C. Coddington 01-31-2006     v5.0.1
  Added debug check before return value insertion.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpSDG_SystemInitPT]
     @CountTypeDefault                  VarChar(512),
     @CountdownResetDefault             VarChar(512),
     @AwardDefault                      VarChar(512),
     @HotPlayerEvalTimeDefault          VarChar(512),
     @HotPlayerWagerDefault             VarChar(512),
     @HotPlayerGamesDefault             VarChar(512),
     @HotPlayerResetTimeDefault         VarChar(512),
     @AbandonedCardTimeDefault          VarChar(512),
     @StatusUpdateTimeDefault           VarChar(512),
     @GameStartMsgDefault               VarChar(512),
     @GameEndMsgDefault                 VarChar(512),
     @VoucherInMsgDefault               VarChar(512),
     @VoucherOutMsgDefault              VarChar(512),
     @CashInMsgDefault                  VarChar(512),
     @CashOutMsgDefault                 VarChar(512),
     @AccountValidMsgDefault            VarChar(512),
     @AccountInvalidMsgDefault          VarChar(512),
     @CardReadErrorMsgDefault           VarChar(512),
     @AbandonedCardMsgDefault           VarChar(512),
     @IdleMsgDefault                    VarChar(512),
     @OfflineMsgDefault                 VarChar(512),
     @CardInMsgDefault                  VarChar(512),
     @CardOutMsgDefault                 VarChar(512),
     @AwardMsgDefault                   VarChar(512),
     @AttractMsgDefault                 VarChar(512),
     @AttractIdleMsgDefault             VarChar(512),
     @VIPAccountValidMsgDefault         VarChar(512),
     @AnnAccountValidMsgDefault         VarChar(512),
     @EmpAccountValidMsgDefault         VarChar(512),
     @CertificateInMsgDefault           VarChar(512),
     @CertificateOutMsgDefault          VarChar(512),
     @SendEventsDefault                 VarChar(512),
     @BirAccountValidMsgDefault         VarChar(512),
     @DebugLevel                        VarChar(512),
     @AccountNumberTrack                VarChar(512),
     @Optimization                      VarChar(512)

AS

-- Variable Declarations
DECLARE @Current_Error  Int
DECLARE @Debug          Bit
DECLARE @MsgText        VarChar(4096)

SET NOCOUNT ON

-- Variable Initialization
SET @Current_Error = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpSDG_SystemInitPT'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpSDG_SystemInitPT Argument Values:  ' + 
         '    @CountTypeDefault: ' +  @CountTypeDefault +
         '    @CountdownResetDefault: ' +  @CountdownResetDefault +
         '    @AwardDefault: ' +  @AwardDefault +
         '    @HotPlayerEvalTimeDefault: ' +  @HotPlayerEvalTimeDefault +
         '    @HotPlayerWagerDefault: ' +  @HotPlayerWagerDefault +
         '    @HotPlayerGamesDefault: ' +  @HotPlayerGamesDefault +
         '    @HotPlayerResetTimeDefault: ' +  @HotPlayerResetTimeDefault +
         '    @AbandonedCardTimeDefault: ' +  @AbandonedCardTimeDefault +
         '    @StatusUpdateTimeDefault: ' +  @StatusUpdateTimeDefault +
         '    @GameStartMsgDefault: ' +  @GameStartMsgDefault +
         '    @GameEndMsgDefault: ' +  @GameEndMsgDefault +
         '    @VoucherInMsgDefault: ' +  @VoucherInMsgDefault +
         '    @VoucherOutMsgDefault: ' +  @VoucherOutMsgDefault +
         '    @CashInMsgDefault: ' +  @CashInMsgDefault +
         '    @CashOutMsgDefault: ' +  @CashOutMsgDefault +
         '    @AccountValidMsgDefault: ' +  @AccountValidMsgDefault +
         '    @AccountInvalidMsgDefault: ' +  @AccountInvalidMsgDefault +
         '    @CardReadErrorMsgDefault: ' +  @CardReadErrorMsgDefault +
         '    @AbandonedCardMsgDefault: ' +  @AbandonedCardMsgDefault +
         '    @IdleMsgDefault: ' +  @IdleMsgDefault +
         '    @OfflineMsgDefault: ' +  @OfflineMsgDefault +         '    @CardInMsgDefault: ' +  @CardInMsgDefault +
         '    @CardOutMsgDefault: ' +  @CardOutMsgDefault +
         '    @AwardMsgDefault: ' +  @AwardMsgDefault +
         '    @AttractMsgDefault: ' +  @AttractMsgDefault +
         '    @AttractIdleMsgDefault: ' +  @AttractIdleMsgDefault +
         '    @VIPAccountValidMsgDefault: ' +  @VIPAccountValidMsgDefault +
         '    @AnnAccountValidMsgDefault: ' +  @AnnAccountValidMsgDefault +
         '    @EmpAccountValidMsgDefault: ' +  @EmpAccountValidMsgDefault +
         '    @CertificateInMsgDefault: ' +  @CertificateInMsgDefault +
         '    @CertificateOutMsgDefault: ' +  @CertificateOutMsgDefault +
         '    @SendEventsDefault: ' +  @SendEventsDefault +
         '    @BirAccountValidMsgDefault: ' +  @BirAccountValidMsgDefault +
         '    @DebugLevel: ' +  @DebugLevel +
         '    @AccountNumberTrack: ' +  @AccountNumberTrack +
         '    @Optimization: ' +  @Optimization
      
      EXEC InsertDebugInfo 0, @MsgText, 0
   END

-- initialize @MsgText to store any Errors from Insert/Updates into TPI_SETTING table
SET @MsgText = ''

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Truncate of TPI_SETTING failed.'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "CountTypeDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @CountTypeDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'CountTypeDefault'

-- If the ITEM_VALUE col. does not have 'CountTypeDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO TPI_SETTING
	(TPI_ID, ITEM_KEY, ITEM_VALUE)
    VALUES
	(1, 'CountTypeDefault', @CountTypeDefault)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for CountTypeDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "CountdownResetDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @CountdownResetDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'CountdownResetDefault'

-- If the ITEM_VALUE col. does not have 'CountdownResetDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'CountdownResetDefault', @CountdownResetDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for CountdownResetDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AwardDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @AwardDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'AwardDefault'

-- If the ITEM_VALUE col. does not have 'AwardDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AwardDefault', @AwardDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for AwardDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "HotPlayerEvalTimeDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @HotPlayerEvalTimeDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'HotPlayerEvalTimeDefault'

-- If the ITEM_VALUE col. does not have 'HotPlayerEvalTimeDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'HotPlayerEvalTimeDefault', @HotPlayerEvalTimeDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for HotPlayerEvalTimeDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "HotPlayerWagerDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @HotPlayerWagerDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'HotPlayerWagerDefault'

-- If the ITEM_VALUE col. does not have 'HotPlayerWagerDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'HotPlayerWagerDefault', @HotPlayerWagerDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for HotPlayerWagerDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "HotPlayerGamesDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @HotPlayerGamesDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'HotPlayerGamesDefault'

-- If the ITEM_VALUE col. does not have 'HotPlayerGamesDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'HotPlayerGamesDefault', @HotPlayerGamesDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for HotPlayerGamesDefault'
   END


-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "HotPlayerResetTimeDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @HotPlayerResetTimeDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'HotPlayerResetTimeDefault'

-- If the ITEM_VALUE col. does not have 'HotPlayerResetTimeDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'HotPlayerResetTimeDefault', @HotPlayerResetTimeDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for HotPlayerResetTimeDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AbandonedCardTimeDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @AbandonedCardTimeDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'AbandonedCardTimeDefault'

-- If the ITEM_VALUE col. does not have 'AbandonedCardTimeDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AbandonedCardTimeDefault', @AbandonedCardTimeDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for AbandonedCardTimeDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "StatusUpdateTimeDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @StatusUpdateTimeDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'StatusUpdateTimeDefault'

-- If the ITEM_VALUE col. does not have 'StatusUpdateTimeDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
  BEGIN
    INSERT INTO TPI_SETTING
	(TPI_ID, ITEM_KEY, ITEM_VALUE)
    VALUES
	(1, 'StatusUpdateTimeDefault', @StatusUpdateTimeDefault)
  END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for StatusUpdateTimeDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "GameStartMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @GameStartMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'GameStartMsgDefault'

-- If the ITEM_VALUE col. does not have 'GameStartMsgDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'GameStartMsgDefault', @GameStartMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for GameStartMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "GameEndMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @GameEndMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'GameEndMsgDefault'

-- If the ITEM_VALUE col. does not have 'GameEndMsgDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'GameEndMsgDefault', @GameEndMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for GameEndMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "VoucherInMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @VoucherInMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'VoucherInMsgDefault'

-- If the ITEM_VALUE col. does not have 'VoucherInMsgDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'VoucherInMsgDefault', @VoucherInMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for VoucherInMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "VoucherOutMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @VoucherOutMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'VoucherOutMsgDefault'

-- If the ITEM_VALUE col. does not have 'VoucherOutMsgDefault" then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'VoucherOutMsgDefault', @VoucherOutMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for VoucherOutMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "CashInMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @CashInMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'CashInMsgDefault'

-- If the ITEM_VALUE col. does not have 'CashInMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'CashInMsgDefault', @CashInMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for CashInMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "CashOutMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @CashOutMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'CashOutMsgDefault'

-- If the ITEM_VALUE col. does not have 'CashOutMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'CashOutMsgDefault', @CashOutMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for CashOutMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AccountValidMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @AccountValidMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'AccountValidMsgDefault'

-- If the ITEM_VALUE col. does not have 'AccountValidMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AccountValidMsgDefault', @AccountValidMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for AccountValidMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AccountInvalidMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @AccountInvalidMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'AccountInvalidMsgDefault'

-- If the ITEM_VALUE col. does not have 'AccountInvalidMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AccountInvalidMsgDefault', @AccountInvalidMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for AccountInvalidMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "CardReadErrorMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @CardReadErrorMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'CardReadErrorMsgDefault'

-- If the ITEM_VALUE col. does not have 'CardReadErrorMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'CardReadErrorMsgDefault', @CardReadErrorMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for CardReadErrorMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AbandonedCardMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @AbandonedCardMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'AbandonedCardMsgDefault'

-- If the ITEM_VALUE col. does not have 'AbandonedCardMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AbandonedCardMsgDefault', @AbandonedCardMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for AbandonedCardMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "IdleMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @IdleMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'IdleMsgDefault'

-- If the ITEM_VALUE col. does not have 'IdleMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'IdleMsgDefault', @IdleMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for IdleMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "OfflineMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @OfflineMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'OfflineMsgDefault'

-- If the ITEM_VALUE col. does not have 'OfflineMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'OfflineMsgDefault', @OfflineMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for OfflineMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "CardInMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @CardInMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'CardInMsgDefault'

-- If the ITEM_VALUE col. does not have 'CardInMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'CardInMsgDefault', @CardInMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for CardInMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "CardOutMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @CardOutMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'CardOutMsgDefault'

-- If the ITEM_VALUE col. does not have 'CardOutMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'CardOutMsgDefault', @CardOutMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for CardOutMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AwardMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @AwardMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'AwardMsgDefault'

-- If the ITEM_VALUE col. does not have 'AwardMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AwardMsgDefault', @AwardMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for AwardMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AttractMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @AttractMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'AttractMsgDefault'

-- If the ITEM_VALUE col. does not have 'AttractMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AttractMsgDefault', @AttractMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for AttractMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AttractIdleMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @AttractIdleMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'AttractIdleMsgDefault'

-- If the ITEM_VALUE col. does not have 'AttractIdleMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AttractIdleMsgDefault', @AttractIdleMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for AttractIdleMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "VIPAccountValidMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @VIPAccountValidMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'VIPAccountValidMsgDefault'

-- If the ITEM_VALUE col. does not have 'VIPAccountValidMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'VIPAccountValidMsgDefault', @VIPAccountValidMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for VIPAccountValidMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AnnAccountValidMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @AnnAccountValidMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'AnnAccountValidMsgDefault'

-- If the ITEM_VALUE col. does not have 'AnnAccountValidMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AnnAccountValidMsgDefault', @AnnAccountValidMsgDefault)
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "EmpAccountValidMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @EmpAccountValidMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'EmpAccountValidMsgDefault'

-- If the ITEM_VALUE col. does not have 'EmpAccountValidMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'EmpAccountValidMsgDefault', @EmpAccountValidMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for EmpAccountValidMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "CertificateInMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @CertificateInMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'CertificateInMsgDefault'

-- If the ITEM_VALUE col. does not have 'CertificateInMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'CertificateInMsgDefault', @CertificateInMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for CertificateInMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "CertificateOutMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @CertificateOutMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'CertificateOutMsgDefault'

-- If the ITEM_VALUE col. does not have 'CertificateOutMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'CertificateOutMsgDefault', @CertificateOutMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for CertificateOutMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "SendEventsDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @SendEventsDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'SendEventsDefault'

-- If the ITEM_VALUE col. does not have 'SendEventsDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'SendEventsDefault', @SendEventsDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for SendEventsDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "BirAccountValidMsgDefault"
UPDATE TPI_SETTING SET ITEM_VALUE = @BirAccountValidMsgDefault WHERE TPI_ID = 1 AND ITEM_KEY = 'BirAccountValidMsgDefault'

-- If the ITEM_VALUE col. does not have 'BirAccountValidMsgDefault' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'BirAccountValidMsgDefault', @BirAccountValidMsgDefault)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for BirAccountValidMsgDefault'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "DebugLevel"
UPDATE TPI_SETTING SET ITEM_VALUE = @DebugLevel WHERE TPI_ID = 1 AND ITEM_KEY = 'DebugLevel'

-- If the ITEM_VALUE col. does not have 'DebugLevel' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'DebugLevel', @DebugLevel)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for DebugLevel'
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "AccountNumberTrack"
UPDATE TPI_SETTING SET ITEM_VALUE = @AccountNumberTrack WHERE TPI_ID = 1 AND ITEM_KEY = 'AccountNumberTrack'

-- If the ITEM_VALUE col. does not have 'AccountNumberTrack' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'AccountNumberTrack', @AccountNumberTrack)
   END

-- Update "ITEM_VALUE" col. in TPI_SETTING" table with "Optimization"
UPDATE TPI_SETTING SET ITEM_VALUE = @Optimization WHERE TPI_ID = 1 AND ITEM_KEY = 'Optimization'

-- If the ITEM_VALUE col. does not have 'Optimization' then INSERT a new record
IF (@@ROWCOUNT = 0)
   BEGIN
      INSERT INTO TPI_SETTING
         (TPI_ID, ITEM_KEY, ITEM_VALUE)
      VALUES
         (1, 'Optimization', @Optimization)
   END

-- Check for Error
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 619
      SET @MsgText = 'tpSDG_SystemInitPT Insert/Update of TPI_SETTING failed for Optimization'
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
