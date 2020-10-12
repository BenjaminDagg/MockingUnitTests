SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: GetLastMachineMessage user stored procedure.

  Created: 01-24-2012 by Aldo Zamora 

  Purpose: Retrieves the last sequence number recorder for a given machine.
           
Arguments: @MachineNumber

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
01-24-2012 Aldo Zamora       v7.3.1
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetLastMachineMessage] @MachineNumber VarChar(5)

AS

SELECT
   ISNULL(MachineSequenceNumber, 0) AS MachineSequenceNumber
   ,ISNULL(TransType, '') AS TransType
   ,ISNULL(TPResponse, '') AS TPResponse
FROM
   LastMachineMessage
WHERE
   MachineNumber = @MachineNumber
GO
