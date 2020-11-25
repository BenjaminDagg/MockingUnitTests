SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
--------------------------------------------------------------------------------
Procedure Name: cmsUpdateBankSetup

Created By:     BitOmni Inc

Create Date:    09/03/2016

Description:    Updates a row into the BANK_SETUP. Used in EditBank Screen

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 9-03-2016
  Creation of stored procedure.


--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsUpdateBankSetup]
	@BankNumber			INT,
	@BankDescription	VARCHAR(128),
	@ProductLineId		INT,	
	@IsPaper			BIT,
	@LockupAmount		MONEY,
	@DbaLockupAmount	MONEY,
	@PromoTicketFactor	INT,
	@PromoTicketAmount	SMALLMONEY,		
	@IsActive			BIT			= 1
	
	
	
AS

-- Variable Declaration
DECLARE @ReturnValue		Int = 0
DECLARE @ErrorMessage VARCHAR(4000) = NULL

SET NOCOUNT ON


IF NOT EXISTS(SELECT * FROM [BANK] WHERE [BANK_NO] = @BankNumber)
BEGIN
	SET @ErrorMessage = 'Bank Number ' +  CAST(@BankNumber AS VARCHAR) + ' not found.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF NOT EXISTS(SELECT * FROM [PRODUCT_LINE] WHERE [PRODUCT_LINE_ID] = @ProductLineId)
BEGIN
	SET @ErrorMessage = 'Product line ' +  CAST(@ProductLineId AS VARCHAR) + ' not found.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END


UPDATE [dbo].[BANK]
	SET  [BANK_DESCR]			=	@BankDescription
		,[PRODUCT_LINE_ID]      =   @ProductLineId		
        ,[IS_PAPER]				=	@IsPaper			
        ,[LOCKUP_AMOUNT]		=	@LockupAmount		
        ,[DBA_LOCKUP_AMOUNT]	=	@DbaLockupAmount	
        ,[ENTRY_TICKET_FACTOR]	=	@PromoTicketFactor	
        ,[ENTRY_TICKET_AMOUNT]  =	@PromoTicketAmount	   
        ,[IS_ACTIVE]			=	@IsActive			
WHERE [BANK_NO] = @BankNumber   

-- Set the Return value.
RETURN @ReturnValue
GO
