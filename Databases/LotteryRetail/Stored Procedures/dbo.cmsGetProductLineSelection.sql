SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
--------------------------------------------------------------------------------
Procedure Name: cmsGetProductLineSelection

Created By:     BitOmni Inc

Create Date:    09/2/2016

Description:    Gets avaliable product line ids and description. Used in Add/Edit Bank Setup.

Returns: ProductLineId	example: 12
		 Description	example: 12 - Some Long Description		 

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 9-2-2016
  Creation of stored procedure.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsGetProductLineSelection]

AS

-- Variable Declaration
DECLARE @AvailableProductLines VARCHAR(4000)

SET NOCOUNT ON

--Get Paper products from AppConfig. As per Diamond Game this should be TriplePlaykl
SET @AvailableProductLines = ISNULL((SELECT ConfigValue FROM [AppConfig] WHERE ConfigKey = 'ValidProductLinesById'), '')

--Add commas before and after so we can match first and last element. If config value already has this, behavior 
--will not be changed since [,1,2,3,4,] will result in ,,1,2,3,4,, and the extra commas will be ignored
SET @AvailableProductLines = ',' + @AvailableProductLines + ','

SELECT [PRODUCT_LINE_ID] as ProductLineId,
	   CAST([PRODUCT_LINE_ID] AS VARCHAR) + ' - ' + [LONG_NAME] as [Description]
FROM [PRODUCT_LINE]
WHERE [IS_ACTIVE] = 1
-- When ProductLineId is in @AvailableProductLines
AND CHARINDEX(',' + CAST(PRODUCT_LINE_ID AS VARCHAR) + ',', @AvailableProductLines) > 0
ORDER BY [PRODUCT_LINE_ID]
GO
