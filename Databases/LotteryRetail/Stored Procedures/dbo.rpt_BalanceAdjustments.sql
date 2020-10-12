SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_BalanceAdjustments user stored procedure.

  Created: 12-17-2009 by Terry Watkins

  Purpose: Retrieves a list of Balance Adjustment transactions that occurred
           within the specified date range.

Arguments:
   @DateStart: Starting accounting date
   @DateEnd:   Ending accounting date

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-17-2009     v7.0.0
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_BalanceAdjustments] @DateStart DateTime, @DayCount Integer
AS

-- SET NOCOUNT ON added to prevent return of unwanted data.
SET NOCOUNT ON


-- Variable Declarations
DECLARE @DateEnd  DateTime
DECLARE @DateTemp DateTime

-- Variable Initialization
SET @DateEnd = DATEADD(day, @DayCount, @DateStart)

-- Ensure that @DateStart is not greater than @DateEnd...
IF (@DateEnd < @DateStart)
   BEGIN
      SET @DateTemp  = @DateStart
      SET @DateStart = @DateEnd
      SET @DateEnd   = @DateTemp
   END

-- Create the resultset.
SELECT
   cel.CASINO_EVENT_LOG_ID,
   cel.EVENT_CODE,
   cel.EVENT_SOURCE,
   cel.EVENT_DESC,
   cel.EVENT_DATE_TIME,
   cel.ID_VALUE,
   ct.MACH_NO, 
   ct.GAME_CODE,
   ct.TRANS_AMT,
   ct.BALANCE
FROM CASINO_EVENT_LOG AS cel
   LEFT OUTER JOIN CASINO_TRANS AS ct ON cel.ID_VALUE = ct.TRANS_NO
WHERE     (cel.EVENT_CODE = 'BA') AND (cel.EVENT_DATE_TIME BETWEEN @DateStart AND @DateEnd)
ORDER BY ct.MACH_NO, cel.CASINO_EVENT_LOG_ID
GO
