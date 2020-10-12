SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: RecordMachineConnection user stored procedure.

  Created: 05-06-2011 by Terry Watkins

  Purpose: Records last Date and time that a machine connected or disconnected
           from the Transaction Portal service.

Called By: Transaction Portal Machine Class

Arguments: @MachineNumber  Machine Number
           @StatusType     0 = Disconnected, 1 = Connected

    Notes: If the @StatusType flag indicates that the machine disconnected,
           update the LAST_DISCONNECT with current date and time and set
           PLAY_STATUS to False.

           If the @StatusType flag indicates a new connection, update the
           LAST_CONNECT with the current date and time. Note that it will be up
           to the machine to send a PlayStatus message indicating that the
           machine is in a playable state.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 05-06-2011     v2.0.1
  Added machine number to CASINO_EVENT_LOG insert.

Terry Watkins 05-06-2011     v3.0.6
  Added update of PLAY_STATUS_CHANGED on disconnect.
  
Louis Epstein 11-01-2013     v3.1.6
  Added PlayStatus logging functionality
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[RecordMachineConnection]
   @Machinenumber VarChar(5),
   @StatusType    TinyInt
AS

-- If @StatusType = 0, record the disconnect.
IF (@StatusType = 0)
	EXEC ChangePlayStatus @Machinenumber, 0

   UPDATE dbo.MACH_SETUP SET
      LAST_DISCONNECT     = GETDATE()
   WHERE MACH_NO = @Machinenumber

-- If @StatusType = 1, record the connection.
IF (@StatusType = 1)
   UPDATE dbo.MACH_SETUP
   SET LAST_CONNECT = GETDATE()
   WHERE MACH_NO = @Machinenumber

GO
