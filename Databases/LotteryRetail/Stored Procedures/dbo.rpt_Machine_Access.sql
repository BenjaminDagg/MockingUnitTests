SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Machine_Access user stored procedure.

  Created: 06-21-2006 by Terry Watkins

  Purpose: Returns data for the Machine Access report

Arguments:
   @AcctDateStart: Starting Accounting Date for the resultset
   @AcctDateEnd:   Ending Accounting Date for the resultset

Change Log:

Changed By    Date           Database Version
  Change Description         v5.0.4
--------------------------------------------------------------------------------
Terry Watkins 06-21-2006
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_Machine_Access] @AcctDateStart DateTime, @AcctDateEnd DateTime
AS

SELECT
   MACH_NO                    AS MachNbr,
   CASINO_MACH_NO             AS CasinoMachNbr,
   ACCT_DATE                  AS AcctDate,
   SUM(MAIN_DOOR_OPEN_COUNT)  AS MainDoorOpens,
   SUM(CASH_DOOR_OPEN_COUNT)  AS CashDoorOpens,
   SUM(LOGIC_DOOR_OPEN_COUNT) AS LogicDoorOpens,
   SUM(BASE_DOOR_OPEN_COUNT)  AS BaseDoorOpens
FROM MACHINE_STATS
WHERE
   ACCT_DATE BETWEEN @AcctDateStart AND @AcctDateEnd
GROUP BY
   MACH_NO, CASINO_MACH_NO, ACCT_DATE
ORDER BY
   ACCT_DATE, MACH_NO
GO
