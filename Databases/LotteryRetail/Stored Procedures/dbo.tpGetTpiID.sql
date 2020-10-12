SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpGetTpiID

  Created: 04/28/2005 by Ashok Murthy

  Purpose: Returns TPI_ID from CASINO table to determine which Third Party (SDG, MGAM ...)
           we are talking to.

  Called By :	TPIClient.vb\Startup

Arguments: None

Change Log:

Changed By    Date          Database Version
  Change Description
--------------------------------------------------------------------------------
Ashok Murthy 04/28/2005     4.0.1
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE  PROCEDURE [dbo].[tpGetTpiID]
AS

SELECT TPI_ID FROM CASINO WHERE SETASDEFAULT = 1
GO
