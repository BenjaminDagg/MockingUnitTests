SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: GetPromoTicketStatus user stored procedure.

  Created: 10-13-2008 by Terry Watkins  

  Purpose: Retrieves Promo Ticket schedule information.


Arguments: None

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
2008-10-13 Terry Watkins     v6.0.2
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetPromoTicketStatus]
AS

-- Variable Declarations
DECLARE @ServerDT        DateTime
DECLARE @PromoScheduleID Int
DECLARE @ToggleOff       Bit
DECLARE @ToggleOn        Bit

-- Variable Initialization\
SET @PromoScheduleID = 0
SET @ServerDT        = GetDate()
SET @ToggleOn        = 0
SET @ToggleOff       = 0

-- Is there a schedule row to be started?
IF EXISTS(SELECT * FROM PROMO_SCHEDULE WHERE PromoStarted = 0 AND PromoEnded = 0 AND @ServerDT BETWEEN PromoStart AND PromoEnd)
   BEGIN
      -- Yes, get the PK of the row to be updated.
      SELECT
         @PromoScheduleID = PromoScheduleID,
         @ToggleOn        = 1
      FROM PROMO_SCHEDULE
      WHERE
         PromoStarted = 0 AND
         PromoEnded   = 0 AND
         @ServerDT BETWEEN PromoStart AND PromoEnd
   END
ELSE
   -- Is there a schedule row to be ended?
   IF EXISTS(SELECT * FROM PROMO_SCHEDULE WHERE PromoStarted = 1 AND PromoEnded = 0 AND @ServerDT >= PromoEnd)
      BEGIN
         SELECT
            @PromoScheduleID = PromoScheduleID,
            @ToggleOff       = 1
         FROM PROMO_SCHEDULE
         WHERE
            PromoStarted = 1 AND
            PromoEnded   = 0 AND
            @ServerDT >= PromoEnd
      END

-- Return data:
SELECT
   @ServerDT        AS ServerDateTime,
   @PromoScheduleID AS PromoScheduleID,
   @ToggleOn        AS ToggleOn,
   @ToggleOff       AS ToggleOff
GO
