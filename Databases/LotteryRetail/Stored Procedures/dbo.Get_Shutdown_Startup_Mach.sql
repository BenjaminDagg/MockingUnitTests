SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/****** Object:  Stored Procedure dbo.Get_Shutdown_Startup_Mach    Script Date: 5/2/02 2:18 PM ******/

CREATE  PROC [dbo].[Get_Shutdown_Startup_Mach] 
--WITH ENCRYPTION
AS

/* Original Author - Norm Symonds 5/2/02
*
* Called by Scraper
*
* Returns to the scraper a machine that needs to be shutdown or started up, based on the 
* SD_RS_FLAG column on the MACH_SETUP table and lets the scraper know the machine number 
* and whether the machine should shutdown or started up, depending on the ACTIVE_FLAG on
* the MACH_SETUP table
*
* ------------------------------------------------------------------------------------------------------------------
*   R E V I S I O N S
* ------------------------------------------------------------------------------------------------------------------
* Revised by  Norm Symonds - 10/23/02 - Use the s.p Record_Shutdown_Startup_Mach to switch the 
*                                       SD_RS_Flag field on a machine - needed to support 2 Scrapers
* ------------------------------------------------------------------------------------------------------------------
*/

DECLARE @NumberOfMachines  Int,
        @Mach_Num          Char(5),
        @Activate_Flag     Int,
        @Event_Type        Char(2),
        @Event_Text        VarChar(1024),
        @Event_Source      VarChar(64)
 
SELECT @NumberOfMachines = COUNT(*) FROM MACH_SETUP WHERE SD_RS_FLAG = 1
IF @NumberOfMachines = 0 
    BEGIN -- No machines need to be shut down or restarted
        SET @Mach_Num = ' '
        SET @Activate_Flag = 0
    END
ELSE 
    BEGIN -- Machines need to be shut down or restarted, return first one in the list
        SELECT TOP 1 @Mach_Num = MACH_NO, @Activate_Flag = CONVERT(INTEGER,ACTIVE_FLAG)
        FROM MACH_SETUP WHERE SD_RS_FLAG = 1
/* Revised by  Norm Symonds - 10/23/02 - Use the s.p Record_Shutdown_Startup_Mach to switch the 
 *                                       SD_RS_Flag field on a machine
        -- UPDATE MACH_SETUP set SD_RS_FLAG = 0 WHERE MACH_NO = @Mach_Num
        -- Log Casino EVENT Log w/'AM' (Activate Machine) or 'DM' (Deactivate Machine) code
         SET @Event_Source = 'Acctg. App. - called Proc. Get_Shutdown_Startup_Mach ' ;
         IF @Activate_Flag = 1 
             BEGIN
                 SET @Event_Type = 'AM'
                 SET @Event_Text =  'Mach Nbr: ' + @MACH_NUM + ' has been Activated by the Accounting Application' 
             END
         ELSE
             BEGIN
                 SET @Event_Type = 'DM'
                 SET @Event_Text =  'Mach Nbr: ' + @MACH_NUM + ' has been Shut Down by the Accounting Application' 
             END

         INSERT INTO CASINO_EVENT_LOG
             (EVENT_CODE, EVENT_SOURCE, EVENT_DESC)
         VALUES
             (@Event_Type, @Event_Source, @Event_Text)
*/
    END

SELECT @NumberOfMachines as numberOfMachines, @Mach_Num as machNum, @Activate_Flag as activeFlag

GO
