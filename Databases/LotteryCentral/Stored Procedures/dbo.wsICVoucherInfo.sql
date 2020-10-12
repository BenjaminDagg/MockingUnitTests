SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: ws_ICVoucherInfo user stored procedure.

Created: 05-03-2011 by Terry Watkins

Purpose: Returns voucher validation data for IntraConnect.GetVoucher web service.

Arguments: ValidationID

Error Codes: 0 = No error, voucher is okay
             1 = Invalid ValidationID length
             2 = Voucher row not found
             3 = Voucher not flagged as valid
             4 = Voucher amount out of valid range
             5 = Voucher not yet redeemed
             
             
Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 05-03-2011     v2.0.3
  Initial coding.

Terry Watkins 07-26-2011     v2.0.4
  Changed datatype of VoucherPrintDate and ClaimedDate to DateTime.
  Changed datatype of SellingAgent to Int.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[wsICVoucherInfo] @ValidationID VarChar(18)
AS

-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- [Variable Declarations]
DECLARE @Cashable          Bit
DECLARE @ClaimedAgent      Int
DECLARE @ClaimedDate       DateTime
DECLARE @ClaimedUser       VarChar(64)
DECLARE @ErrorCode         Int
DECLARE @GameTitleID       Int
DECLARE @IsValid           Bit
DECLARE @SellingAgent      Int
DECLARE @UniqueVoucherID   AS VarChar(18)
DECLARE @VoucherPrintDate  DateTime
DECLARE @VoucherType       SmallInt
DECLARE @WinningAmount     Money

-- [Variable Initialization]
SET @Cashable         = 'False'
SET @ClaimedAgent     = 0
SET @ClaimedUser      = ''
SET @ErrorCode        = 0
SET @GameTitleID      = -1
SET @IsValid          = 0
SET @SellingAgent     = 0
SET @UniqueVoucherID  = @ValidationID
SET @VoucherType      = 0
SET @WinningAmount    = 0

-- Is the ValidationID 18 characters in size?
IF LEN(LTRIM(RTRIM(@ValidationID))) = 18
   -- Yes, does the voucher exist?
   BEGIN
      -- Make sure there is a record in the VoucherPayout table, if so,
      -- set @Cashable (meaning that the voucher was cashed out).
      IF EXISTS(SELECT * FROM dbo.VoucherPayout WHERE BARCODE = @ValidationID)
         SET @Cashable = 1
      
      -- Now check the VOUCHER table via the uvwVoucherInfo view...
      IF EXISTS(SELECT * FROM dbo.uvwVoucherInfo WHERE Barcode = @ValidationID)
         -- Yes, retrieve voucher info.
         BEGIN
            SELECT
               @VoucherPrintDate = CREATE_DATE,
               @ClaimedDate      = REDEEMED_DATE,
               @ClaimedUser      = ISNULL(CASHIER_NAME, ''),
               @VoucherType      = VOUCHER_TYPE,
               @GameTitleID      = GAME_TITLE_ID,
               @WinningAmount    = VOUCHER_AMOUNT,
               @ClaimedAgent     = 43950,
               @SellingAgent     = CAST(RETAILER_NUMBER AS Int),
               @IsValid          = IS_VALID
            FROM dbo.uvwVoucherInfo
            WHERE BARCODE = @ValidationID
            
            -- Set null values to default values.
            -- IF (@VoucherPrintDate IS NULL) SET @VoucherPrintDate = ''
            -- IF (@ClaimedDate IS NULL) SET @ClaimedDate = ''
            
            IF (@IsValid = 0)
               -- Voucher not flagged as valid, set error code to 3
               SET @ErrorCode = 3
            ELSE IF (@WinningAmount < 0)
               -- Voucher amount out of valid range.
               SET @ErrorCode = 4
            ELSE IF (@Cashable = 0)
               -- Not yet redeemed.
               SET @ErrorCode = 5
         END
      ELSE
         -- Voucher row not found.
         SET @ErrorCode = 2
   END
ELSE
   -- Invalid ValidationID length.
   SET @ErrorCode = 1
   
-- Insert an audit row in the ClaimValidation table
INSERT INTO IntraConnectClaim
   (ErrorCode, ValidationID, VoucherPrintDate, ClaimedDate, ClaimedUser,
    VoucherType, WinningAmount, ClaimedAgent, SellingAgent, Cashable, GameTitleID)
VALUES
   (@ErrorCode, @ValidationID, @VoucherPrintDate, @ClaimedDate, @ClaimedUser,
    @VoucherType, @WinningAmount, @ClaimedAgent, @SellingAgent, @Cashable, @GameTitleID)
   
-- Retrieve Resultset.
SELECT
   @ErrorCode                  AS ErrorCode,
   @VoucherPrintDate           AS VoucherPrintDate,
   @UniqueVoucherID            AS UniqueVoucherID,
   @ClaimedDate                AS ClaimedDate,
   @WinningAmount              AS WinningAmount,
   @ClaimedAgent               AS ClaimedAgent,
   @ClaimedUser                AS ClaimedUser,
   @SellingAgent               AS SellingAgent,
   @VoucherType                AS VoucherType,
   @Cashable                   AS Cashable,
   @GameTitleID                AS GameCode
GO
