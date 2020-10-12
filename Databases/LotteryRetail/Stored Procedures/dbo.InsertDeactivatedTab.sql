SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: InsertDeactivatedTab

Created By:     Terry Watkins

Create Date:    06-15-2012

Description:    Inserts a row into the DEACTIVATED_TAB table.

Returns:        0 = Successful row insertion
                n = TSQL Error Code

Parameters:     Each field from the DEACTIVATED_TAB table execpt EVENT_TIME
                which defaults to the current date and time.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 06-15-2012     v3.0.7 LotteryRetail
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[InsertDeactivatedTab]
   @MachineNumber    Char(5),
   @DealNumber       Int,
   @RollNumber       Int,
   @FirstTicket      Int,
   @LastTicket       Int
AS

-- Suppress unwanted return data.
SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

-- Perform the insert.
INSERT INTO DEACTIVATED_TAB 
   (MACH_NO, DEAL_NO, ROLL_NO, FIRST_TICKET, LAST_TICKET)
VALUES
   (@MachineNumber, @DealNumber, @RollNumber, @FirstTicket, @LastTicket)
      
SELECT @ReturnValue = @@ERROR

RETURN @ReturnValue
GO
