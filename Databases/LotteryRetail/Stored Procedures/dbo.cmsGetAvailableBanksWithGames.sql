SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*
--------------------------------------------------------------------------------
Procedure Name: cmsGetAvailableBanksWithGames

Created By:     BitOmni Inc

Create Date:    11/04/2016

Description:    Gets all banks with games. Used in dropdown for bank 
and game selection in machine setup

Returns:

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 8-16-2016
  Creation of stored procedure.
  
BitOmni Inc 10-04-2016
  Update stored procedure to retreive Game Title Id. This is to fix the 
  where CMS sends EnableGameTitle message to TP with a value of zero.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[cmsGetAvailableBanksWithGames]

AS

SET NOCOUNT ON

SELECT CAST(b.BANK_NO AS VARCHAR) AS BankNumber ,
 CAST(b.BANK_NO AS VARCHAR) + ': ' + b.[GAME_TYPE_CODE] + ' - ' + [BANK_DESCR] AS BankDescription,
 A.GameCode,
 A.GameDescription,
 A.GameTitleId
 
FROM BANK b
LEFT OUTER JOIN 
(
	SELECT gs.GAME_CODE AS GameCode,
	gs.GAME_CODE + ' - ' + GAME_DESC AS GameDescription,
	gs.GAME_TYPE_CODE,
	gs.GAME_TITLE_ID AS GameTitleId
	FROM [GAME_SETUP] gs 
	JOIN GAME_TYPE gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
	WHERE gt.IS_ACTIVE = 1
) AS A ON A.[GAME_TYPE_CODE] = B.GAME_TYPE_CODE
WHERE b.[IS_ACTIVE] = 1 
ORDER BY BANK_NO
GO
