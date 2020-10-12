SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure Name: SetRetailSiteStatusMachines

Created By:     Louis Epstein

Create Date:    04-22-2014

Description:    Sets status indicating wheither machines should be locked out by the TP

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 04-22-2014     v3.2.1
  Initial Coding.
  -- Edris Changed name from SetMachinesActiveStatus to SetRetailSiteStatusMachines
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SetRetailSiteStatusMachines]
@MachinesActive bit, @Username varchar(64),@StatusCode VARCHAR(1), @StatusComment varchar(30) = NULL
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

IF NOT EXISTS (SELECT * FROM RetailSiteStatus)
BEGIN
INSERT INTO [dbo].[RetailSiteStatus]
           ([LocationID]
           ,[PayoutsActive]
           ,[MachinesActive]
           ,[StatusComment]
           ,[LastModified]
           ,[ModifiedBy]
           ,[PendingMachineState]
           ,[StatusCode]
           )
     VALUES
           ((SELECT LOCATION_ID FROM CASINO WHERE SETASDEFAULT = 1)
           ,1
           ,1
           ,NULL
           ,GETDATE()
           ,'admin'
           ,0
           ,@StatusCode)
END

    UPDATE RetailSiteStatus
    SET MachinesActive = @MachinesActive,
    LastModified = GETDATE(),
    ModifiedBy = @Username,
    StatusComment = @StatusComment,
    StatusCode = @StatusCode,
    PendingMachineState = CASE WHEN @MachinesActive <> (SELECT MachinesActive FROM RetailSiteStatus WHERE SiteStatusID = (SELECT MAX(SiteStatusID) FROM RetailSiteStatus)) THEN 1 ELSE (SELECT MachinesActive FROM RetailSiteStatus WHERE SiteStatusID = (SELECT MAX(SiteStatusID) FROM RetailSiteStatus)) END

END

GO
