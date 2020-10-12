SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: Get_PS_Interface_Header user stored procedure.

  Created: 01/12/2004 by Terry Watkins  

  Purpose: Retrieves Liability data for the header record of the Cherokee
           Peoplesoft Interface file.

Arguments: @AcctDate - The Accounting Date for the required data.

Change Log:

Date       By        Change Description
---------- --------- -----------------------------------------------------------
2004-01-12 Terry W.  Initial Coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Get_PS_Interface_Header] @AcctDate DateTime
AS

-- Variable Declarations
DECLARE @StartDT  DATETIME
DECLARE @EndDT    DATETIME
DECLARE @ToDate   DATETIME
DECLARE @ToTime   DATETIME
DECLARE @Offset   Integer

-- Retrieve TO_TIME from the Casino table for the default Casino.
SELECT @ToTime = TO_TIME  FROM CASINO WHERE SETASDEFAULT = 1;

-- Get the offset in minutes
SET @ToDate = CONVERT(DATETIME, CONVERT(CHAR(10), @ToTime, 101))
SET @Offset = DATEDIFF(Minute, @ToDate, @ToTime)

-- Set the starting date and time
SET @StartDT = DATEADD(Minute, @Offset, @AcctDate)

-- Set the ending date and time
SET @EndDT = DATEADD(Day, 1, @StartDT)

-- Retrieve the sum of the Z transactions between the start and end datetimes...
SELECT ISNULL(SUM(TRANS_AMT), 0) AS Liability
FROM CASINO_TRANS
WHERE TRANS_ID IN (13, 25) AND DTIMESTAMP BETWEEN @StartDT AND @EndDT

GO
