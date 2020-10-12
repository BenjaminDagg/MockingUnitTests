SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*
--------------------------------------------------------------------------------
Procedure Name: InsertAppEventLog

Created By:     Edris Khestoo

Create Date:    6-22-2012

Description:    Inserts a row into APP_EVENT_LOG table for Auditing Purposes.

Returns:        

Parameters:     AccountID, Workstation Name, EventID, Description

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Edris Khestoo 06-22-2012     v3.0.6
  Initial Coding.
  
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[InsertAppEventLog] 
      @AccountID        VarChar(10),
      @WorkStation      VarChar(16),
      @EventSource      VARCHAR(32),
      @LoginEventID     INT = 0,
      @Description      VARCHAR(128)
      
AS

SET NOCOUNT ON

DECLARE @ReturnValue   INTEGER
SET @ReturnValue = 0 


INSERT INTO [dbo].[APP_EVENT_LOG]
           ([ACCOUNTID],           
            [EVENT_SOURCE],
            [WORK_STATION],
            [APP_EVENT_TYPE],
            [DESCRIPTION])
     VALUES
           (@AccountID,
            @EventSource,
            @WorkStation,
            @LoginEventID,
            @Description)

IF (@@Error = 0)
   SET @ReturnValue = 1 

GO
