SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[uvwTransactions]
AS
SELECT
   t.TRANS_ID           AS TransID, 
   tc.TRANS_CATEGORY_ID AS TransCategoryID,
   tc.SHORT_NAME        AS TC_ShortName,
   tc.LONG_NAME         AS TC_LongName,
   t.SHORT_NAME         AS T_ShortName,
   t.LONG_NAME          AS T_LongName, 
   t.REPORT_TEXT        AS T_ReportText
FROM dbo.TRANS_CATEGORY tc
   JOIN dbo.TRANS t ON tc.TRANS_CATEGORY_ID = t.TRANS_CATEGORY_ID

GO
