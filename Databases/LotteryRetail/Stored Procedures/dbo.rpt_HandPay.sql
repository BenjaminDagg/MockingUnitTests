SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_HandPay user stored procedure.

  Created: 04-02-2007 by Terry Watkins

  Purpose: Retrieves a list of Hand Pay transactions that occurred within the
           specified date range.

Arguments:
   @DateStart: Starting accounting date
   @DateEnd:   Ending accounting date

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 04-02-2007     v5.0.8
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_HandPay] @DateStart DateTime, @DateEnd DateTime
AS

-- SET NOCOUNT ON added to prevent return of unwanted data.
SET NOCOUNT ON


-- Variable Declarations
DECLARE @DateTemp DateTime

-- Variable Initialization

-- Ensure that @DateStart is not greater than @DateEnd...
IF (@DateEnd < @DateStart)
   BEGIN
      SET @DateTemp  = @DateStart
      SET @DateStart = @DateEnd
      SET @DateEnd   = @DateTemp
   END

-- Create the resultset.
SELECT
   ct.MACH_NO,
   ms.CASINO_MACH_NO,
   ct.TRANS_NO,
   ct.DTIMESTAMP,
   ct.TRANS_AMT,
   ct.CARD_ACCT_NO   
FROM CASINO_TRANS ct
   LEFT OUTER JOIN MACH_SETUP ms ON ct.MACH_NO = ms.MACH_NO
WHERE (ct.TRANS_ID = 27) AND (ct.ACCT_DATE BETWEEN @DateStart AND @DateEnd)
ORDER BY ct.TRANS_NO
GO
