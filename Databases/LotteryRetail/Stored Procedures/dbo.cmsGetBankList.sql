SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
--------------------------------------------------------------------------------
Procedure Name: cmsGetBankList

Created By:     BitOmni Inc

Create Date:    09/1/2016

Description:    Gets all banks matching bank number. Used in Bank Setup List view

Returns:  Simple select statment that returns information about a bank.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 9-1-2016
  Creation of stored procedure.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsGetBankList]

AS

SET NOCOUNT ON

SELECT b.[BANK_NO] as BankNumber
      ,b.[BANK_DESCR]  as [Description]     
      ,b.[GAME_TYPE_CODE] as GameTypeCode
      ,b.[LOCKUP_AMOUNT] as LockupAmount
      ,b.[DBA_LOCKUP_AMOUNT] as DbaLockupAmount
      ,b.[ENTRY_TICKET_FACTOR] as PromoTicketFactor
      ,b.[ENTRY_TICKET_AMOUNT] as PromoTicketAmount
      ,p.[PRODUCT_DESCRIPTION] as Product
      ,pt.[PRODUCT_LINE_ID] as ProductLineId
      ,CAST(pt.[PRODUCT_LINE_ID] AS VARCHAR) + ' - ' + pt.[LONG_NAME] as ProductLine
  FROM [dbo].[BANK] b
  JOIN [dbo].[GAME_TYPE] gt on gt.[GAME_TYPE_CODE] = b.[GAME_TYPE_CODE]
  JOIN [dbo].[PRODUCT] p on p.[PRODUCT_ID] = gt.[PRODUCT_ID]
  JOIN [dbo].[PRODUCT_LINE] pt on pt.[PRODUCT_LINE_ID] = b.[PRODUCT_LINE_ID]
GO
