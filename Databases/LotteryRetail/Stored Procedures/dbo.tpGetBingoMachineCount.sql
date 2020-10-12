SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpGetBingoMachineCount

Created 09-25-2007 by Terry Watkins

Description: Returns the number of machines that have not been removed and
             are in an active Bingo Bank.

Parameters: <none>

Change Log:

Changed By    Date            Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 09-25-2007      6.0.1
  Initial coding.

Terry Watkins 11-09-2009      v7.0.0
  Modified WHERE clause to filter for Product ID of the Game Type instead of
  product line of the bank (safer check because new bingo product lines may
  be added).

Terry Watkins 11-12-2010      DCLottery Version 1.0.0
  Removed unused variables.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetBingoMachineCount]
AS
-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
SET NOCOUNT ON

-- Retrieve the count.
SELECT COUNT(*) AS BingoMachineCount
FROM MACH_SETUP ms
   JOIN BANK       b ON b.BANK_NO = ms.BANK_NO
   JOIN GAME_TYPE gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
WHERE
   ms.REMOVED_FLAG = 0 AND
   gt.PRODUCT_ID   = 3

GO
