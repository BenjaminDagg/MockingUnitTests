SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
--------------------------------------------------------------------------------
Procedure Name: cmsGetGameTypeCodeSelection

Created By:     BitOmni Inc

Create Date:    09/02/2016

Description:    Gets avaliable game type codes. Used in Add/Edit Bank Setup dropdown.

Returns: GameTypeCode example: AX1
		 Description  example: AX1 - Some Long Description
		 IsPaper which is true if GameTypeCode has a ProductId specified as paper 
		 in comma deliminted AppConfig entry matching key of 'PaperProductsById' 

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 9-02-2016
  Creation of stored procedure.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsGetGameTypeCodeSelection]

AS

-- Variable Declaration
DECLARE @PaperProductsById VARCHAR(4000)

SET NOCOUNT ON

--Get Paper products from AppConfig. As per Diamond Game this should be TriplePlaykl
SET @PaperProductsById = ISNULL((SELECT ConfigValue FROM [AppConfig] WHERE ConfigKey = 'PaperProductsById'), '')

--Add commas before and after so we can match first and last element. If config value already has this, behavior 
--will not be changed since [,1,2,3,4,] will result in ,,1,2,3,4,, and the extra commas will be ignored
SET @PaperProductsById = ',' + @PaperProductsById + ','

SELECT [GAME_TYPE_CODE] as GameTypeCode,
	   [GAME_TYPE_CODE] + ' - ' + [LONG_NAME] as [Description],
	   [LONG_NAME] as [LongName],
	   CASE
			-- When Product Id is in @PaperProductsById
			WHEN CHARINDEX(',' + CAST(PRODUCT_ID AS VARCHAR) + ',',@PaperProductsById)  > 0  THEN 1 ELSE 0 
	   END AS IsPaper
FROM [GAME_TYPE]
WHERE [PRODUCT_ID] > 0
ORDER BY [GAME_TYPE_CODE]
GO
