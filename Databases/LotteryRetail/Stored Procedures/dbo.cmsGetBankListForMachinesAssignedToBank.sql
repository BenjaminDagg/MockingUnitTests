SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*
--------------------------------------------------------------------------------
Procedure Name: cmsGetBankListForMachinesAssignedToBank

Created By:     BitOmni Inc

Create Date:    09/13/2016

Description:    Gets all banks in specified format for use in MachinesAssignedToBank 


Returns:  Simple select statment that returns information about a bank.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 9-13-2016
  Creation of stored procedure.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[cmsGetBankListForMachinesAssignedToBank]

AS

SET NOCOUNT ON

SELECT	b.[BANK_NO] AS BankNumber,
		CAST(b.[BANK_NO] AS VARCHAR) + ' - ' + ISNULL(b.BANK_DESCR, '')	AS [Description],
		gt.[GAME_TYPE_CODE] + ' - ' + gt.LONG_NAME AS GameTypeCode,
		CASE gt.[PROGRESSIVE_TYPE_ID] WHEN 0 THEN 'No' ELSE 'Yes' END AS Progressive,
		gt.[MAX_COINS_BET]	AS MaxCoins,
		gt.[MAX_LINES_BET]  AS MaxLines,
		p.[PRODUCT_DESCRIPTION] AS Product,
		CAST(b.[PRODUCT_LINE_ID] AS VARCHAR) + ' - ' + pl.[LONG_NAME] AS ProductLine   
  FROM [dbo].[BANK] b
  JOIN [dbo].[GAME_TYPE] gt ON gt.[GAME_TYPE_CODE] = b.[GAME_TYPE_CODE]
  JOIN [dbo].[PRODUCT] p ON p.[PRODUCT_ID] = gt.[PRODUCT_ID]
  JOIN [dbo].[PRODUCT_LINE] pl ON pl.[PRODUCT_LINE_ID] = b.[PRODUCT_LINE_ID]
GO
