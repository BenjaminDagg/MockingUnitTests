SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure rpt_GetCasinoName

  Created: 06/01/2005 by Natalya Mogilevsky

  Purpose: Returns CASINO_Name from CASINO table to use in Report

  Arguments: None

Change Log:

Changed By     Date          Database Version
  Change Description
--------------------------------------------------------------------------------
Nat Mogilevsky 06/06/2005    v4.1.4
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE  PROCEDURE [dbo].[rpt_GetCasinoName]
AS

SELECT CAS_NAME FROM CASINO WHERE SETASDEFAULT = 1
GO
