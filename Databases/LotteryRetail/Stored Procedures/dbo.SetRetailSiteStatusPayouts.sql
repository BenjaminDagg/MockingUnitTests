SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: [SetRetailSiteStatusPayouts]

Created By:     Louis Epstein

Create Date:    04-22-2014

Description:    Sets status indicating wheither payouts are allowed in LRAS

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 04-22-2014     v3.2.1
  Initial Coding.
  -- Edris changed name from SetPayoutsActiveStatus to [SetRetailSiteStatusPayouts]
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SetRetailSiteStatusPayouts]
@PayoutsActive bit, @Username varchar(64), @StatusCode VARCHAR(1), @StatusComment varchar(30) = NULL
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
           ,[StatusCode]
           ,[PendingMachineState])
     VALUES
           ((SELECT LOCATION_ID FROM CASINO WHERE SETASDEFAULT = 1)
           ,1
           ,1
           ,NULL
           ,GETDATE()           
           ,'admin'
           ,@StatusCode
           ,0)
END

    UPDATE RetailSiteStatus
    SET 
    PayoutsActive = @PayoutsActive,
    LastModified = GETDATE(),
    ModifiedBy = @Username,
    StatusCode = @StatusCode,
    StatusComment = @StatusComment
    
    
END
GO
