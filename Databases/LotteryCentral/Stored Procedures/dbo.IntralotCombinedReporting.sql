SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
Procedure: IntralotCombinedReporting user stored procedure.

Created: 08-04-2011 by Aldo Zamora

Purpose: Returns data for the Intralot combined reporting file

Arguments:
   @AccountingDate: DateTime for the resultset

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   08-04-2011     v2.0.5
  Initial coding.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[IntralotCombinedReporting] @AccountingDate DATETIME

AS

SELECT DISTINCT
   cas.RETAILER_NUMBER AS AgentID,
   CONVERT(VARCHAR, @AccountingDate, 101) AS AccountingDate,
   REPLACE(CONVERT(VARCHAR, AccountingDate, 101), '/', '') + '00' + REPLACE(CONVERT(VARCHAR, AccountingDate, 101), '/', '') + '23' AS [Description],
   ISNULL(gl.NetRevenue, 0) AS TotalNetToProperty,
   ISNULL(gl.UnClaimedVoucherAmount, 0) AS UnClaimedVouchers,
   'AgentCommissions' =
   CASE
   WHEN ISNULL(gl.AgentCommissionsExpense, 0 ) > 0 THEN '-' + CAST(ISNULL(gl.AgentCommissionsExpense, 0 ) AS VARCHAR)
   WHEN ISNULL(gl.AgentCommissionsExpense, 0 ) < 0 THEN REPLACE(CAST(ISNULL(gl.AgentCommissionsExpense, 0 ) AS VARCHAR), '-', '')
   ELSE ISNULL(gl.AgentCommissionsExpense, 0 )
   END,
   ISNULL(gl.NetRevenue - AgentCommissionsExpense, 0) AS NetToLottery

FROM GLInfo gl
   JOIN CASINO cas ON gl.LocationID = cas.LOCATION_ID

WHERE IsProcessed = 0
GO
