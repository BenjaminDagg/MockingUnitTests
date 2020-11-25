SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure Name: cmsInsertBankSetup

Created By:     BitOmni Inc

Create Date:    09/02/2016

Description:    Inserts a row into the BANK_SETUP. Used in AddBank Screen

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 9-02-2016
  Creation of stored procedure.


--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[cmsInsertBankSetup]
	@BankNumber			INT,
	@BankDescription	VARCHAR(128),
	@GameTypeCode		VARCHAR(2),	
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


IF EXISTS(SELECT * FROM [BANK] WHERE [BANK_NO] = @BankNumber)
BEGIN
	SET @ErrorMessage = 'Bank Number ' +  CAST(@BankNumber AS VARCHAR) + ' is already in use.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF NOT EXISTS(SELECT * FROM [GAME_TYPE] WHERE [GAME_TYPE_CODE] = @GameTypeCode)
BEGIN
	SET @ErrorMessage = 'Invalid GameTypeCode ' +  CAST(@GameTypeCode AS VARCHAR) + ' does not exist in database.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END

IF NOT EXISTS(SELECT * FROM [PRODUCT_LINE] WHERE [PRODUCT_LINE_ID] = @ProductLineId)
BEGIN
	SET @ErrorMessage = 'Invalid ProductLineId ' +  CAST(@ProductLineId AS VARCHAR) + ' does not exist in database.'
	RAISERROR (@ErrorMessage, 16, -1)
	RETURN
END


INSERT INTO [dbo].[BANK]
           ([BANK_NO]
           ,[BANK_DESCR]
           ,[GAME_TYPE_CODE]
           ,[PRODUCT_LINE_ID]
           ,[IS_PAPER]
           ,[LOCKUP_AMOUNT]
           ,[DBA_LOCKUP_AMOUNT]
           ,[ENTRY_TICKET_FACTOR]
           ,[ENTRY_TICKET_AMOUNT]           
           ,[IS_ACTIVE])   
SELECT	@BankNumber,
		@BankDescription,
		@GameTypeCode,
		@ProductLineId,
		@IsPaper,
		@LockupAmount,
		@DbaLockupAmount,
		@PromoTicketFactor,
		@PromoTicketAmount,
		@IsActive	

-- Set the Return value.
RETURN @ReturnValue
GO
