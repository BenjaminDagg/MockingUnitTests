SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_System_Event user stored procedure.

  Created: 07/03/2002 by Terry Watkins

  Purpose: Returns System Event Log data for reporting

Arguments: @StartDate:  Starting DateTime for the resultset
           @EndDate:    Ending DateTime for the resultset


Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
DGETAW        07/03/2002 Original coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_System_Event] @StartDate DateTime, @EndDate DateTime
AS
SELECT
   cel.CASINO_EVENT_LOG_ID AS EventID, cec.EVENT_CODE + ' - ' + cec.EVENT_DESC AS EventCode,
   cel.EVENT_SOURCE AS EventSource, cel.EVENT_DESC AS EventDesc, cel.EVENT_DATE_TIME AS EventDateTime,
   cel.ID_Value AS IDValue, cel.CREATED_BY AS CreatedBy
FROM CASINO_EVENT_LOG cel
   JOIN CASINO_EVENT_CODE cec ON cel.EVENT_CODE = cec.EVENT_CODE
WHERE cel.EVENT_DATE_TIME BETWEEN @StartDate AND @EndDate AND cel.EVENT_CODE <> 'RR'
ORDER BY cel.EVENT_CODE, cel.CASINO_EVENT_LOG_ID
GO
