SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure ChangePlayStatus

Created 11-01-2013 by Louis Epstein

Desc: Handles logging of PlayStatus messages from machines.

Parameters:
   @MachineNumber       Machine number
   @PlayStatus


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 11-01-2013     v3.1.6
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[ChangePlayStatus]
	@MachineNumber varchar(6),
	@PlayStatus bit,
	@LogChangedStatusOnly bit = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    DECLARE @LocationID int, @CurrentStatus bit, @TimeStamp datetime, @OperationHoursID int, @MachineCount int
    
    SET @TimeStamp = GETDATE()
    
    SELECT @CurrentStatus = PLAY_STATUS FROM MACH_SETUP WHERE MACH_NO = @MachineNumber
    
    SELECT @OperationHoursID = OperationHourID FROM OperationHours WHERE WeekDayNumber = DATEPART(DW, @TimeStamp) AND @TimeStamp BETWEEN ActiveStartDate AND ISNULL(ActiveEndDate, @TimeStamp)
    
    UPDATE dbo.MACH_SETUP 
		SET	PLAY_STATUS         = @PlayStatus
			,PLAY_STATUS_CHANGED = @TimeStamp
	WHERE MACH_NO = @MachineNumber
	
	IF @CurrentStatus <> @PlayStatus OR @LogChangedStatusOnly = 0
	BEGIN
		
		SELECT @LocationID = LOCATION_ID FROM CASINO WHERE SETASDEFAULT = 1
	    
		INSERT INTO PlayStatusLog VALUES (@LocationID, @MachineNumber, @PlayStatus, @TimeStamp)
		
    END
    
END
GO
