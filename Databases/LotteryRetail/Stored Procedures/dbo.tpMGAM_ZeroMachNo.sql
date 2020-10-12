SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpMGAM_ZeroMachNo

Created 11-08-2005 by A. Murthy

Purpose: Stores '0' in the MACH_NO col. of CARD_ACCT tbl. during MGAM Server start/restart.
         and MGAM client startup.

Return Dataset: ErrorID.

Called by: MgamClient.vb\DbTpMGAM_ZeroMachNo with @CardAccount = MACH_NO
           MgamServer.vb\DbTpMGAM_ZeroMachNo with default @CardAccount = 'ALL'

Arguments:
   @CardAccount         Card Account Number or Mach_No

Change Log:

Changed By    Change Date         Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy     03-08-2006          v5.0.2
  Initial Version
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpMGAM_ZeroMachNo]
   @CardAccount         VarChar(20)='ALL'
AS

-- Variable Declarations
DECLARE @Current_Error  Int
DECLARE @Debug          Bit
DECLARE @MsgText        VarChar(1024)

SET NOCOUNT ON

-- Variable Initialization
SET @Current_Error = 0

-- Check Debug mode...
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpMGAM_ZeroMachNo'

-- Are we in Debug mode?
IF (@Debug = 1)
   -- Yes, so record incoming argument values...
   BEGIN
      SET @MsgText =
         'tpMGAM_ZeroMachNo Argument Values:  ' + 
          '  CardAccount: ' + @CardAccount 
      
      EXEC InsertDebugInfo 0, @MsgText, 0
   END

-- Initialize @MsgText to store any Errors from Updates into CARD_ACCT table.
SET @MsgText = ''

IF (@CardAccount = 'ALL')
   -- Called by MgamServer at startup, zero out the 'MACH_NO' fields for all card accounts.
   UPDATE CARD_ACCT SET MACH_NO = '0' WHERE MACH_NO IS NOT NULL AND MACH_NO <> '0'
ELSE
   -- Called by MgamClient for a specific card account #.
   BEGIN
      -- Check if the row already exists in CARD_ACCT table with CARD_ACCT_NO=@CardAccount
      IF EXISTS (SELECT * FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAccount )
         UPDATE CARD_ACCT SET MACH_NO = '0' WHERE CARD_ACCT_NO = @CardAccount
      ELSE IF EXISTS (SELECT * FROM CARD_ACCT WHERE MACH_NO = @CardAccount )
         -- We are calling this stored proc. with the MACH_NO instead of CARD_ACCOUNT as the input.
         UPDATE CARD_ACCT SET MACH_NO = '0' WHERE MACH_NO = @CardAccount
   END

-- check for Error in Update
IF (@@ERROR <> 0)
   BEGIN
      SET @Current_Error = 840
      SET @MsgText = 'Update failed on CARD_ACCT for CARD_ACCT_NO = ' + @CardAccount
   END

SET @MsgText = @MsgText + '  Current_Error: ' + CAST(@Current_Error AS VarChar)

-- If debugging, save return values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpMGAM_ZeroMachNo : ' + @MsgText
      EXEC InsertDebugInfo 0, @MsgText, 0
   END

-- Return the @Current_Error as a resultset.
SELECT @Current_Error AS ErrorID
GO
