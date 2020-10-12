SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_ActiveDeals user stored procedure.

  Created: 12-21-2006 by Terry Watkins

  Purpose: Retrieves a list of Deals that have had activity within the specified
           number of days.

Arguments:
   @DayRange: Number of days within which there must have been activity. The
              default value used if not specified is 30 days.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-21-2006     v5.0.8
  Initial coding

Terry Watkins 08-21-2009     v7.0.0
  Removed JOIN to DEAL_SEQUENCE table so Bingo and EZTab 2.0 deals will be
  listed.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_ActiveDeals] @DayRange SmallInt = 30
AS

-- Variable Declarations

-- Variable Initialization

-- Ensure that the day range is not less than 1.
IF (@DayRange < 1) SET @DayRange = 1

-- SET NOCOUNT ON added to prevent return of unwanted data.
SET NOCOUNT ON

/*
--------------------------------------------------------------------------------
Create the resultset.
Note that this filters for Deals that are Open, can play in an active Bank,
and have had activity within the specified number of days.
--------------------------------------------------------------------------------
*/
SELECT
   ds.DEAL_NO,
   ds.DEAL_DESCR,
   ds.FORM_NUMB,
   cf.GAME_TYPE_CODE,
   ds.TABS_PER_ROLL * ds.NUMB_ROLLS AS TABS_PER_DEAL,
   dst.PLAY_COUNT,
   dst.LAST_PLAY
FROM DEAL_SETUP ds
   JOIN DEAL_STATS dst ON dst.DEAL_NO = ds.DEAL_NO
   JOIN CASINO_FORMS cf ON cf.FORM_NUMB = ds.FORM_NUMB
   JOIN BANK b ON cf.GAME_TYPE_CODE = b.GAME_TYPE_CODE
WHERE
   (ds.IS_OPEN = 1)  AND
   (b.IS_ACTIVE = 1) AND
   (DATEDIFF(day,  dst.LAST_PLAY, GetDate()) <= @DayRange)
ORDER BY ds.DEAL_NO
GO
