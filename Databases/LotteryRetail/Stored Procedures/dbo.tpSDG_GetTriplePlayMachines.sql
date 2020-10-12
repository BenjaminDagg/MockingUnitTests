SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpSDG_GetTriplePlayMachines

  Created: 03/15/2005 by Ashok Murthy

  Purpose: Returns array of MACH_NO from MACH_SETUP for all TriplePlay machines
           (Product_ID=1) and which are still inside the casino (Removed_Flag=0)

  Called by: SdgServer.vb\TxDailyMeter, IowaMachineSetup.vb\GetMachSetupTbl

Arguments: none


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
A. Murthy 03/15/2005         v4.0.1
  Initial coding.

Terry Watkins 05-19-2005     v4.1.1
  Added CASINO_MACH_NO to the resultset.

A. Murthy 10/03/2005         v4.2.3
  Commented out requirement that CASINO_MACH_NO should start with '22'
  and CASINO_MACH_NO should be 5 chars. long.

A. Murthy 01/25/2006         v5.0.1
  Added 3rd column ACTIVE_FLAG to ResultSet for Iowa Lottery.

Terry Watkins 05-19-2005     v6.0.1
  Modified WHERE clause to include Bingo machines.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpSDG_GetTriplePlayMachines]
AS

SELECT DISTINCT ms.MACH_NO, ms.CASINO_MACH_NO, ms.ACTIVE_FLAG
FROM  MACH_SETUP ms 
   JOIN BANK        b ON ms.BANK_NO = b.BANK_NO
   JOIN GAME_TYPE  gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
WHERE
   gt.PRODUCT_ID IN (1, 3) AND
   ms.REMOVED_FLAG = 0     AND
   ISNUMERIC(ms.CASINO_MACH_NO) = 1
GO
