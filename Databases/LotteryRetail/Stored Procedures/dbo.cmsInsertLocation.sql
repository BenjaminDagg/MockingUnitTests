SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

/*
--------------------------------------------------------------------------------
Procedure Name: cmsInsertLocation

Created By:     BitOmni Inc

Create Date:    08/03/2020

Description:    Inserts a row into the Casino table. Assumes validation successful in CentroLink
				Default values such as accounting start time etc are market specific in stored procedure. 

Returns:        

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
BitOmni Inc 08-03-2020
  Creation of stored procedure.


--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[cmsInsertLocation]
	@LocationId					INT,
	@RetailerNumber				VARCHAR(8),
	@DgeId						VARCHAR(6),
	@LocationName				VARCHAR(48),
	@Address1					VARCHAR(64),
	@Address2					VARCHAR(64),
	@City						VARCHAR(32),
	@State						VARCHAR(2),
	@Zip						VARCHAR(12),
	@Phone						VARCHAR(20),
	@Fax						VARCHAR(20),
	@TpiId						INT,
	@CashoutTimeout				INT,
	@SweepAccount				VARCHAR(16),
	@MaxBalanceAdjustment		MONEY,
	@PayoutAuthorizationAmount  MONEY,
	@SetAsDefault				BIT,
	@JackpotLockup				BIT,
	@PrintPromoTickets			BIT,
	@AllowTicketReprint			BIT,
	@SummerarizePlay			BIT,
	@AutoDrop					BIT

AS

-- Variable Declaration
DECLARE @ReturnValue		Int = 0
DECLARE @ErrorMessage VARCHAR(4000) = NULL

SET NOCOUNT ON


IF EXISTS(SELECT * FROM [dbo].[CASINO] WHERE 
	LOWER(RETAILER_NUMBER) = LOWER(@RetailerNumber) OR 
	LOWER(CAS_ID) = LOWER(@DgeId) OR
	LOCATION_ID = @LocationId)
BEGIN
	SET @ErrorMessage = 'Record already exists with same LocationId, RetailerNumber or DGE ID.'
	RAISERROR (@ErrorMessage, 16, -1)	
END


INSERT INTO [dbo].[CASINO]
           ([CAS_ID]
           ,[CAS_NAME]
           ,[ADDRESS1]
           ,[ADDRESS2]
           ,[CONTACT_NAME]
           ,[CITY]
           ,[STATE]
           ,[ZIP]
           ,[PHONE]
           ,[FAX]
           ,[SETASDEFAULT]
           ,[LOCKUP_AMT]
           ,[FROM_TIME]
           ,[TO_TIME]
           ,[CLAIM_TIMEOUT]
           ,[DAUB_TIMEOUT]
           ,[CARD_TYPE]
           ,[PLAYER_CARD]
           ,[REPRINT_TICKET]
           ,[RECEIPT_PRINTER]
           ,[DISPLAY_PROGRESSIVE]
           ,[PT_AWARD_TYPE]
           ,[TPI_ID]
           ,[TPI_PROPERTY_ID]
           ,[PROMOTIONAL_PLAY]
           ,[PIN_REQUIRED]
           ,[RS_AND_PPP]
           ,[PPP_AMOUNT]
           ,[JACKPOT_LOCKUP]
           ,[CASHOUT_TIMEOUT]
           ,[AMUSEMENT_TAX_PCT]
           ,[AUTO_DROP]
           ,[SUMMARIZE_PLAY]
           ,[PRINT_PROMO_TICKETS]
           ,[BINGO_FREE_SQUARE]
           ,[PRINT_REDEMPTION_TICKETS]
           ,[PRINT_RAFFLE_TICKETS]
           ,[AUTHENTICATE_APPS]
           ,[PROG_REQUEST_SECONDS]
           ,[MAX_BAL_ADJUSTMENT]
           ,[MIN_DI_VERSION]
           ,[LOCATION_ID]
           ,[PAYOUT_THRESHOLD]
           ,[RETAIL_REV_SHARE]
           ,[SWEEP_ACCT]
           ,[RETAILER_NUMBER])
     VALUES
           (@DgeId
           ,@LocationName
           ,@Address1
           ,@Address2
           ,NULL
           ,@City
           ,@State
           ,@Zip
           ,@Phone
           ,@Fax
           ,@SetAsDefault
           ,12000.00  --LOCKUP_AMT
           ,'1900-01-01 02:00:00.000'	--FROM_TIME
           ,'1900-01-01 02:00:00.000'	--TO_TIME
           ,0							--CLAIM_TIMEOUT
           ,0							-- DAUB_TIMEOUT
           ,1							-- CARD_TYPE
           ,0							-- PLAYER_CARD
           ,@AllowTicketReprint
           ,0							-- RECEIPT_PRINTER
           ,0							-- DISPLAY_PROGRESSIVE
           ,NULL						--PT_AWARD_TYPE
           ,@TpiId 
           ,0							--TPI_PROPERTY_ID
           ,0							--Promo Play
           ,0							--PIN_REQUIRED
           ,0							--RS_AND_PPP
           ,0							--PPP_AMOUNT
           ,0							--JACKPOT_LOCKUP
           ,@CashoutTimeout 
           ,0.00						--AMUSEMENT_TAX_PCT
           ,@AutoDrop
           ,@SummerarizePlay
           ,@PrintPromoTickets
           ,0							--BINGO_FREE_SQUARE
           ,0							--PRINT_REDEMPTION_TICKETS
           ,0							--PRINT_RAFFLE_TICKETS
           ,1							--AUTHENTICATE_APPS
           ,5							--PROG_REQUEST_SECONDS
           ,@MaxBalanceAdjustment
           ,3040						--MIN_DI_VERSION
           ,@LocationId
           ,@PayoutAuthorizationAmount
           ,20.00						--RETAIL_REV_SHARE
           ,@SweepAccount				--SWEEP_ACCT
           ,@RetailerNumber)


-- Set the Return value.
SELECT * FROM CASINO
WHERE LOCATION_ID = @LocationId




GO
