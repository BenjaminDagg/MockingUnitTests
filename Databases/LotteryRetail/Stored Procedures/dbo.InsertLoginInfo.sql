SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure Name: InsertLoginInfo

Created By:     Edris Khestoo

Create Date:    6-21-2012

Description:    Inserts a row into LOGIN_INFO table for Auditing Purposes.

Returns:        

Parameters:     AccountID, Workstation Name, EventID, Description

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Edris Khestoo 06-21-2012     v3.0.6
  Initial Coding.
  
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[InsertLoginInfo] 
      @AccountID        VarChar(10),
      @WorkStation      VarChar(16),
      @LoginEventID     INT = 0,
      @Description      VARCHAR(128)
      
AS

SET NOCOUNT ON

DECLARE @ReturnValue   INTEGER
SET @ReturnValue = 0 

INSERT INTO [dbo].[LOGIN_INFO]
           ([ACCOUNTID],
            [WORK_STATION],
            [LOGIN_EVENT_ID],
            [COMMENTS])
     VALUES
           (@AccountID,
            @WorkStation,
            @LoginEventID,
            @Description)

IF (@@Error = 0)
   SET @ReturnValue = 1 
GO
