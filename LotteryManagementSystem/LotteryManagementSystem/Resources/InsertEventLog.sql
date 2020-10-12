
DECLARE @PartitionKey INT 
SET @PartitionKey = DATEDIFF(D, '1970-01-01 00:00:00', GETUTCDATE())

DECLARE @UserId INT
SET @UserId = NULL

IF (@UserName IS NOT NULL)
BEGIN
	SELECT @UserId = AppUserId FROM AppUser WHERE UserName = @UserName
END

INSERT EventLog (PartionKey, EventDate, EventTypeId, [Description], Details, EventSource, UserId)
		   VALUES   (@PartitionKey, GETDATE(), @EventTypeId , @EventDescription, @Details, @EventSource , @UserId)
