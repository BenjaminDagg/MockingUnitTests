SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: PromoScheduleAdd

Created By:     Terry Watkins

Create Date:    08-28-2008

Description:    Inserts a row into the PROMO_SCHEDULE table.

Returns:        0 = Successful row insertion
                n = TSQL Error Code

Parameters:     @ScheduleComments   User comments for the schedule entry
                @PromoStartTime     Date and Time the promotion starts
                @PromoEndTime       Date and Time the promotion ends

Change Log:

Changed By    Date           DB Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 08-28-2008     v6.0.2
   Initial coding.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[PromoScheduleAdd]
   @ScheduleComments   VarChar(128),
   @PromoStartTime     DateTime,
   @PromoEndTime       DateTime

AS

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

-- Attempt to insert the row.
INSERT INTO PROMO_SCHEDULE
   (Comments, PromoStart, PromoEnd, PromoStarted, PromoEnded)
VALUES
   (@ScheduleComments, @PromoStartTime, @PromoEndTime, 0, 0)

SET @ReturnValue = @@ERROR

-- Set the routine return value.
RETURN @ReturnValue
GO
