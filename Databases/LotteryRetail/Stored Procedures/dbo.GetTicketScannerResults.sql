SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: GetTicketScannerResults user stored procedure.

  Created: 10-10-2013

  Purpose: Retrieves Ticket information for Ticket Scanner application.


Arguments: @DealNumber   - Deal Number of the ticket
           @TicketNumber - Ticket Number to check

  Returns: 
           
Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
10-10-2013 Louis Epstein     v3.1.5
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetTicketScannerResults]
   @DealNumber   Int,
   @TicketNumber Int
AS

DECLARE @IsActive            Bit
DECLARE @IsValid            Bit
DECLARE @IsOpen            Bit
DECLARE @Barcode            varchar(128)
DECLARE @RollNumber            int
DECLARE @BarcodeTypeID	int
DECLARE @GameTypeCode char(2)
DECLARE @Denomination int
DECLARE @LinesBet int
DECLARE @CoinsBet int
DECLARE @TabsPerRoll int

DECLARE @DealTable           VarChar(32)
DECLARE @ParamString         nVarChar(128)
DECLARE @SelectStatement     nVarChar(1024)

-- Variable Initialization
SET @Barcode = ''
SET @IsActive = NULL
SET @IsValid = 0
SET @RollNumber = 0
SET @BarcodeTypeID = 0
SET @IsOpen = NULL
SET @Denomination = 0
SET @LinesBet = 0
SET @CoinsBet = 0
SET @DealTable   = 'Deal' + CAST(@DealNumber AS VARCHAR)

-- Does the DealTable exist?
IF EXISTS(SELECT * FROM eDeal.dbo.sysobjects WHERE Name = @DealTable)
   BEGIN
      -- Retrieve the IsActive value of the Ticket.
      
	  SELECT @IsOpen = DS.IS_OPEN, @GameTypeCode = GS.GAME_TYPE_CODE FROM DEAL_SETUP DS 
	  JOIN GAME_SETUP GS ON GS.GAME_CODE = DS.GAME_CODE
	  WHERE DS.DEAL_NO = @DealNumber
	  
      IF @IsOpen IS NOT NULL
      BEGIN
		  SET @IsValid = 1
      
		  SET @SelectStatement = N'SELECT @IsActive = IsActive, @Barcode = Barcode FROM eDeal.dbo.' +
			  @DealTable + N' WHERE TicketNumber = ' + CAST(@TicketNumber AS VarChar)
	      
		  SET @ParamString = N'@IsActive Bit OUTPUT, @Barcode varchar(128) OUTPUT'
	      
	      
		  EXEC sp_ExecuteSQL @SelectStatement, @ParamString, @IsActive = @IsActive OUTPUT, @Barcode = @Barcode OUTPUT

		  IF @IsActive = 1 OR @IsOpen = 0
		  BEGIN
			 SET @Barcode = ''
		  END
	         
		  
	      
		  IF @IsActive = 0 AND @IsValid = 1
		  BEGIN
	      
			SELECT 
			@RollNumber = @TicketNumber / TABS_PER_ROLL + SIGN(@TicketNumber % TABS_PER_ROLL), @TabsPerRoll = TABS_PER_ROLL
			FROM DEAL_SETUP
			WHERE DEAL_NO = @DealNumber
			
			SELECT @BarcodeTypeID = BARCODE_TYPE_ID 
			FROM DEAL_SETUP DS
			JOIN GAME_SETUP GS ON GS.GAME_CODE = DS.GAME_CODE
			JOIN GAME_TYPE GT ON GT.GAME_TYPE_CODE = GS.GAME_TYPE_CODE
			WHERE DS.DEAL_NO = @DealNumber
			
			SELECT @Denomination = MIN(DENOM_VALUE) * 100
			FROM DENOM_TO_GAME_TYPE 
			WHERE GAME_TYPE_CODE = @GameTypeCode 
			GROUP BY GAME_TYPE_CODE
			
			SELECT @CoinsBet = MIN(COINS_BET) 
			FROM COINS_BET_TO_GAME_TYPE 
			WHERE GAME_TYPE_CODE = @GameTypeCode 
			GROUP BY GAME_TYPE_CODE
			
			SELECT @LinesBet = MAX(LINES_BET) 
			FROM LINES_BET_TO_GAME_TYPE 
			WHERE GAME_TYPE_CODE = @GameTypeCode 
			GROUP BY GAME_TYPE_CODE
			
		  END
	      
	   END
	 END
	 
	 IF @IsActive IS NULL
		  BEGIN
			SET @IsActive = 0
			SET @Barcode = ''
			SET @IsValid = 0
			SET @IsOpen = 0
		  END

SELECT
	@Barcode AS Barcode,
	@IsValid AS IsValid,
	@IsActive AS IsActive,
	@RollNumber AS RollNumber,
	@BarcodeTypeID AS BarcodeTypeID,
	@IsOpen AS IsOpen,
	@Denomination AS Denomination,
	@CoinsBet AS CoinsBet,
	@LinesBet AS LinesBet,
	@TabsPerRoll AS TabsPerRoll

GO
