SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
--------------------------------------------------------------------------------
Procedure Name: cmsGetDefaultPapersettings

Created By:     G Lanzing

Create Date:    09/9/2019

Description:    Returns default Paper settings for centrolink appliction

Returns:        Columns for DEFALUT_PAPER_SETTINGS param

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
G Lanzing  9-9-2019
  Creation of stored procedure.


--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[cmsGetDefaultPaperSettings]
AS

SET NOCOUNT ON

SELECT	 [Value1] AS [Value1]					   
		,[Value2] AS [Value2]				   
FROM [dbo].[CASINO_SYSTEM_PARAMETERS]	
WHERE [PAR_NAME] = 'DEFAULT_PAPER_SETTINGS'
GO
