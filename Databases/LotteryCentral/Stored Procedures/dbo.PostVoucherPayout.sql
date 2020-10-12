SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: PostVoucherPayout

  Created By:  Terry Watkins

 Create Date:  12-07-2010

 Description:  Inserts a row into the VoucherPayout table.

  Return Set:  PK Value of inserted row.
  
Return Value:   0 = Successful row insertion
               -1 = VoucherID/LocationID already exists
               -2 = Barcode (Voucher Validation ID) already exists
                n = TSQL Error Code

Parameters:
   @VoucherID              Voucher Identifier
   @LocationID             Location Identifier
   @Barcode                Voucher Validation ID
   @TransAmount            Voucher Amount being paid
   @PosWorkStation         Name of the POS workstation where payment was made
   @AppUserID              AppUser Identifier of person paying the voucher
   @NewCheckSum            CheckSum value for CHECK_VALUE

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 12-07-2010     v1.0.0
  Inital coding

Aldo Zamora   08-10-2011     v2.0.5
  Added LOCATION_ID = @LocationID to the IF EXISTS check and the VOUCHER update.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[PostVoucherPayout]
   @VoucherID        Int,
   @LocationID       Int,
   @Barcode          VarChar(18),
   @TransAmount      Money,
   @PosWorkStation   VarChar(32),
   @AppUserID        Int,
   @NewCheckSum      VarBinary(8)

AS

-- SET NOCOUNT ON to prevent extra result sets from being returned.
SET NOCOUNT ON

-- Variable Declarations
DECLARE @TimeStamp       DateTime

DECLARE @ReturnValue     Int
DECLARE @VoucherPayoutID Int

-- Variable Initialization
SET @TimeStamp       = GetDate()
SET @ReturnValue     = 0
SET @VoucherPayoutID = 0

-- Duplicate VoucherID/LocationID?
IF EXISTS(SELECT * FROM dbo.VoucherPayout WHERE VoucherID = @VoucherID AND LocationID = @LocationID)
   -- Yes, set return value to -1
   SET @ReturnValue = -1

-- Duplicate Voucher/Location?
ELSE IF EXISTS(SELECT * FROM dbo.VoucherPayout WHERE Barcode = @Barcode AND LocationID = @LocationID)
   -- Yes, set return value to -2
   SET @ReturnValue = -2
ELSE
   BEGIN
      -- Update the VOUCHER table.
      UPDATE dbo.VOUCHER SET
         REDEEMED_STATE = 1,
         REDEEMED_LOC   = @PosWorkStation,
         REDEEMED_DATE  = @TimeStamp,
         CHECK_VALUE    = @NewCheckSum
      WHERE
         VOUCHER_ID  = @VoucherID AND
         LOCATION_ID = @LocationID
      
      -- Insert into VoucherPayout.
      INSERT INTO dbo.VoucherPayout
         (VoucherID, LocationID, Barcode, TransAmount, PosWorkStation, AppUserID)
      VALUES
         (@VoucherID, @LocationID, @Barcode, @TransAmount, @PosWorkStation, @AppUserID)
      
      -- Store error in return value
      SELECT @ReturnValue = @@ERROR
      
      -- Store PK value of inserted row (will print as Ref Nbr on receipt).
      SET @VoucherPayoutID = SCOPE_IDENTITY()
   END

SELECT @VoucherPayoutID AS ReferenceNbr
   
RETURN @ReturnValue
GO
