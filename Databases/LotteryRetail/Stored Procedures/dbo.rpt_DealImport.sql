SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_DealImport user stored procedure.

Created: 11/06/2003 by Terry Watkins

Purpose: Returns data for the Deal Import Report.

Arguments: @ImportHistoryID: IMPORT_HISTORY_ID or 0 for all records.

Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------
Terry         11/06/2003 Original coding
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[rpt_DealImport] @ImportHistoryID Int

AS

SELECT
   ih.IMPORT_HISTORY_ID,
   ih.EXPORT_HISTORY_ID,
   ih.IMPORTED_BY,
   ih.EXPORTED_BY,
   ih.IMPORT_DATE,
   ih.EXPORT_DATE,
   ih.CASINO_UPDATE,
   ih.GAME_UPDATE,
   ih.BANK_UPDATE,
   ih.FORM_UPDATE,
   ih.IS_GENERIC,
   ih.SUCCESSFUL,
   ihd.IMPORT_DETAIL_ID,
   ihd.TABLE_NAME,
   ihd.DETAIL_TEXT,
   ihd.INSERT_COUNT,
   ihd.UPDATE_COUNT,
   ihd.IGNORED_COUNT,
   ihd.ERROR_COUNT
FROM IMPORT_HISTORY ih
   LEFT OUTER JOIN IMPORT_DETAIL ihd ON ih.IMPORT_HISTORY_ID = ihd.IMPORT_HISTORY_ID
WHERE @ImportHistoryID = 0 OR ih.IMPORT_HISTORY_ID = @ImportHistoryID
ORDER BY ih.IMPORT_DATE, ihd.IMPORT_DETAIL_ID
GO
