SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_Jackpot user stored procedure.

  Created: 01/01/2011 by Aldo Zamora

  Purpose: Returns data for the Jackpot report

Arguments:
   @StartDate:    Starting DateTime for the resultset
   @EndDate:      Ending DateTime for the resultset
   
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora 01-11-2011
   Initial Coding
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[rpt_Jackpot]
   @StartDate DATETIME,
   @EndDate   DATETIME
   
AS

SELECT
   jp.LOCATION_ID AS LocationID,
   cas.CAS_NAME AS Location,
   jp.MACH_NO AS MachineNumber,
   jp.CASINO_MACH_NO AS CasinoMachineNumber,
   ms.MODEL_DESC AS MachineDescription,
   jp.DEAL_NO AS DealNumber,
   jp.TICKET_NO AS TicketNumber,
   jp.PLAY_COST AS PlayCost,
   jp.TRANS_ID AS TransID,
   jp.TRANS_AMT AS TransAmount,
   jp.DTIMESTAMP AS TransDate
FROM
   JACKPOT jp
   JOIN dbo.CASINO cas ON jp.LOCATION_ID = cas.LOCATION_ID
   JOIN MACH_SETUP  ms ON jp.MACH_NO = ms.MACH_NO AND jp.LOCATION_ID = ms.LOCATION_ID
WHERE
   jp.DTIMESTAMP BETWEEN @StartDate AND @EndDate

GO
GRANT EXECUTE ON  [dbo].[rpt_Jackpot] TO [SSRS]
GO
