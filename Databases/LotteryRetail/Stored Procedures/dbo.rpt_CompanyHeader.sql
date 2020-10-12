SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_CompanyHeader user stored procedure.

  Created: 01-25-2007 by Andy Chen

  Purpose: Return Company name, address, phone and fax number

Arguments: NONE

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Andy Chen     01-25-2007     v6.0.0
  Inital coding.
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[rpt_CompanyHeader]
AS

-- Variable Declaration

DECLARE @CompanyName    VarChar(30)
DECLARE @Address        VarChar(30)
DECLARE @CityState      VarChar(30)
DECLARE @Phone          VarChar(30)
DECLARE @Fax		VarChar(30)
DECLARE @BillTo		VarChar(48)

-- Suppress return of message data.
SET NOCOUNT ON

SELECT
   @CompanyName = VALUE1, 
   @Address     = VALUE2, 
   @CityState   = VALUE3
FROM CASINO_SYSTEM_PARAMETERS 
WHERE PAR_NAME = 'DGE_ADDRESS'

SELECT
   @Phone = VALUE1, 
   @Fax   = VALUE2 
FROM CASINO_SYSTEM_PARAMETERS 
WHERE PAR_NAME = 'DGE_Phones'

SELECT
   @BillTo = CAS_NAME 
FROM CASINO 
WHERE SETASDEFAULT = 1

-- Return the report data.
SELECT
   @CompanyName AS CompanyName,
   @Address     AS Address,
   @CityState   AS CityState,
   @Phone       AS Phone,
   @Fax         AS Fax,
   @BillTo      AS BillTo
GO
