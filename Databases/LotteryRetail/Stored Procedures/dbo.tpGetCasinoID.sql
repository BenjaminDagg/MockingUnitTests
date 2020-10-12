SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpGetCasinoID

  Created: 01-10-2005 by Ashok Murthy

  Purpose: Returns CAS_ID from CASINO table to create the new Barcode

  Called By :	TPIClient.vb\HandleMessage

Arguments: None

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Ashok Murthy 01/10/2005      v4.0.1
  Initial coding.

Terry Watkins 05-23-2006     v5.0.3
  Changed to return CAS_ID instead of CASINO_ID from the CASINO table.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetCasinoID]
AS

SELECT CAS_ID FROM CASINO WHERE SETASDEFAULT = 1
GO
