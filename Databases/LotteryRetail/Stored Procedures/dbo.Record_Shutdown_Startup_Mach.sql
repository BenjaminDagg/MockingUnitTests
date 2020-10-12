SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: Record_Shutdown_Startup_Mach user stored procedure.

Created: 05/16/2002 by Norm Symonds

Purpose: Called by Scraper to set the ACTIVE_FLAG on the MACH_SETUP table
         depending on whether the Machine is being shut down or started up.

Arguments:      @MACH_NUM: Machine Number
           @Activate_Flag:
              @SD_RS_FLAG: 0 - from Scraper
                           1 - from Acct System
                           2 - Failed from Acct System
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Norm Symonds  10-23-2002
  Use the Record_Shutdown_Startup_Mach to switch the SD_RS_Flag field on a machine
  Add argument saying which (Scraper Control or Accounting System)

A. Murthy     01-16-2006     v5.0.1
  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set to
  0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

Terry Watkins 05-12-2010     v7.2.1
  Added machine number to CASINO_EVENT_LOG insert.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Record_Shutdown_Startup_Mach] 
   @MACH_NUM        Char(5),
   @Activate_Flag   Integer,
   @SD_RS_FLAG      Integer
AS

DECLARE @Event_Type     Char(2)
DECLARE @Event_Text     VarChar(1024)
DECLARE @Event_Source   VarChar(64)

IF EXISTS(SELECT * FROM MACH_SETUP WHERE MACH_NO = @MACH_NUM)
   BEGIN 
      IF (@SD_RS_FLAG = 1)
         BEGIN
            -- The Accounting System prompted the call and the Shutdown or Restart was successful
            SET @Event_Source = 'Acctg. App. - called Proc. Get_Shutdown_Startup_Mach '
            
            -- Log Casino EVENT Log w/'AM' (Activate Machine) or 'DM' (Deactivate Machine) code
            UPDATE MACH_SETUP SET SD_RS_FLAG = 0 WHERE MACH_NO = @Mach_Num
            IF (@Activate_Flag = 1)
               BEGIN
                  UPDATE MACH_SETUP set ACTIVE_FLAG = 1 WHERE MACH_NO = @Mach_Num
                  SET @Event_Type = 'AM'
                  SET @Event_Text =  'Mach Nbr: ' + @MACH_NUM + ' has been Activated by the Accounting Application' 
               END
            ELSE IF (@Activate_Flag = 0)
               BEGIN
                  UPDATE MACH_SETUP set ACTIVE_FLAG = 0 WHERE MACH_NO = @Mach_Num
                  SET @Event_Type = 'DM'
                  SET @Event_Text =  'Mach Nbr: ' + @MACH_NUM + ' has been Shut Down by the Accounting Application' 
               END
         END
      ELSE IF (@SD_RS_FLAG = 2)
         BEGIN
            -- The Accounting System prompted the call and the Shutdown or Restart was NOT successful
            SET @Event_Source = 'Acctg. App. - called Proc. Get_Shutdown_Startup_Mach '  ;
            -- Log Casino EVENT Log w/'AM' (Activate Machine) or 'DM' (Deactivate Machine) code
            UPDATE MACH_SETUP set SD_RS_FLAG = 0 WHERE MACH_NO = @Mach_Num
            IF (@Activate_Flag = 1)
               BEGIN
                  UPDATE MACH_SETUP SET ACTIVE_FLAG = 0 WHERE MACH_NO = @Mach_Num
                  SET @Event_Type = 'AM'
                  SET @Event_Text =  'Mach Nbr: ' + @MACH_NUM + ' Activation FAILED from the Accounting Application' 
               END
            ELSE IF (@Activate_Flag = 0)
               BEGIN
                  UPDATE MACH_SETUP SET ACTIVE_FLAG = 1 WHERE MACH_NO = @Mach_Num
                  SET @Event_Type = 'DM'
                  SET @Event_Text =  'Mach Nbr: ' + @MACH_NUM + ' Shut Down FAILED from the Accounting Application' 
               END
            END
      ELSE
         -- The Scraper Control prompted the call
         BEGIN
            -- Machine found - mark as shut down or started up
            SET @Event_Source = 'Scraper - called Proc. Record_Shutdown_Startup_Mach '
            
            -- Log Casino EVENT Log w/'AM' (Activate Machine) or 'DM' (Deactivate Machine) code
            IF (@Activate_Flag = 1)
               BEGIN
                  UPDATE MACH_SETUP SET ACTIVE_FLAG = 1 WHERE MACH_NO = @Mach_Num
                  SET @Event_Type = 'AM'
                  SET @Event_Text =  'Mach Nbr: ' + @MACH_NUM + ' has been Activated by the Scraper Control' 
               END
            ELSE IF (@Activate_Flag = 0)
               BEGIN
                  UPDATE MACH_SETUP SET ACTIVE_FLAG = 0 WHERE MACH_NO = @Mach_Num
                  SET @Event_Type = 'DM'
                  SET @Event_Text =  'Mach Nbr: ' + @MACH_NUM + ' has been Shut Down by the Scraper Control' 
               END
         END
      
      -- Log the event.
      INSERT INTO CASINO_EVENT_LOG
         (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, MACH_NO)
      VALUES
         (@Event_Type, @Event_Source, @Event_Text, @Mach_Num)
   END
GO
