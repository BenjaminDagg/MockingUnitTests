SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpGetCasinoInfo

  Created: 06-08-2007 by Terry Watkins

  Purpose: Replaces tpSDG_GetCasinoInfo, tpGetTpiID, and tpGetCasinoID.
           Also returns new BINGO_FREE_SQUARE column value.

  Called By :	TPIClient.vb\Startup

Arguments: None

Change Log:

Changed By    Date          Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 06-08-2007     6.0.1
  Initial coding.

A.Murthy 08-02-2007          6.0.1
  Moved the "* 100" outside the CAST of LOCKUP_AMT to prevent an overflow
  condition that was experienced when the lockup amount is a large value.

A.Murthy 12-19-2007          6.0.2
  Removed the select of LOCKUP_AMT from CASINO table, as this is now
  a column in the BANK table.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetCasinoInfo]
AS
BEGIN
   SELECT
      TPI_ID,
      CAS_ID,
      CAS_NAME,
      ISNULL(CITY, '') + ' / ' + 
      ISNULL(STATE, '') + ' / ' +
      ISNULL(ZIP, '')                 AS CITYSTATEZIP,
      CAST(AUTO_DROP AS Int)          AS AUTO_DROP_INT,
      CAST(BINGO_FREE_SQUARE AS Int)  AS BINGO_FREE_SQUARE
   FROM CASINO
   WHERE SETASDEFAULT = 1
END


GO
