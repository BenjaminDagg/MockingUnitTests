SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure Name: cmsGetBankSetupByNumber

Created By:     BitOmni Inc

Create Date:    09/1/2016

Description:    Returns Bank Setup data used for Edit Bank Screen

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 9-1-2016
  Creation of stored procedure.


--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsGetBankSetupByNumber]
	@BankNumber			INT
AS

SET NOCOUNT ON



SELECT	 [BANK_NO] as [BankNumber]					   
		,[BANK_DESCR] as BankDescription				   
		,[GAME_TYPE_CODE]			   
		,[PRODUCT_LINE_ID] as ProductLineId			   
		,[IS_PAPER] as IsPaper	   
		,[LOCKUP_AMOUNT] as LockupAmount		
		,[DBA_LOCKUP_AMOUNT] as DbaLockupAmount	
		,[ENTRY_TICKET_FACTOR] as PromoTicketFactor	
		,[ENTRY_TICKET_AMOUNT] as PromoTicketAmount	
		,[IS_ACTIVE] as IsActive					   
FROM [dbo].[BANK]	
WHERE [BANK_NO] = @BankNumber
GO
