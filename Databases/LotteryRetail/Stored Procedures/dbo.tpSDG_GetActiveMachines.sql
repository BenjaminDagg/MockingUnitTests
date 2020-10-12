SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpSDG_GetActiveMachines

  Created: 12/07/2004 by Ashok Murthy

  Purpose: Returns array of MACH_NO from MACHINE_STATS for a given AccountingDate

Arguments: @AcctDate: Accounting Date to report on.


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Ashok Murthy 12/07/2004      v4.0.0
  Initial coding.

Terry Watkins 01-04-2005     v4.0.1
  Modified to filter out Millennium machines.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpSDG_GetActiveMachines] @AcctDate DateTime
AS

-- Variable Declarations

SELECT DISTINCT mst.MACH_NO   
FROM MACHINE_STATS mst
   JOIN MACH_SETUP ms ON mst.MACH_NO = ms.MACH_NO
   JOIN BANK        b ON ms.BANK_NO = b.BANK_NO
   JOIN GAME_TYPE  gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
WHERE
   mst.ACCT_DATE = @AcctDate AND
   gt.PRODUCT_ID > 0
GO
