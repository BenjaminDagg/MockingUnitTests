SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure Name: fpInsertPromoVoucherSession

 Created By:    Aldo Zamora

Create Date:    11-15-2011

Description:    Inserts a row into PROMO_VOUCHER_SESSION.

  Called By:    Free Play Application

    Returns:    Integer value (PK of the inserted row) or -1 on error.

 Parameters:    @AuthAccountID1 First authorization username.
                @AuthAccountID2 Second authorization username.
                @VoucherAmount  Dollar amount vouchers were created with.
                @VoucherCount   Number of vouchers created.
                @ExpirationDays Number of days vouchers will expire in.
                @Workstation    Workstation used to create vouchers.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   11-15-2011     v7.2.5
  Initial coding
--------------------------------------------------------------------------------
*/
CREATE Procedure [dbo].[fpInsertPromoVoucherSession]
   @AuthAccountID1 VarChar(10),
   @AuthAccountID2 VarChar(10),
   @VoucherAmount  SmallMoney,   
   @VoucherCount   Int,
   @ExpirationDays Int,
   @Workstation    VarChar(64)

AS

-- Variable Declaration
DECLARE @AcctDate  DateTime
DECLARE @ErrorID   Int
DECLARE @PKID      Int
DECLARE @TimeStamp DateTime

-- Variable Initialization
SET @AcctDate = dbo.ufnGetAcctDate()
SET @TimeStamp = GETDATE()

-- Insert the row.
INSERT INTO PROMO_VOUCHER_SESSION
   (AUTH_ACCOUNTID1, AUTH_ACCOUNTID2, VOUCHER_AMOUNT, VOUCHER_COUNT,
    EXPIRATION_DAYS, WORKSTATION, ACCT_DATE, SESSION_DATE)
VALUES
   (@AuthAccountID1, @AuthAccountID2, @VoucherAmount, @VoucherCount,
    @ExpirationDays, @Workstation, @AcctDate, @TimeStamp)

-- Save the @@ERROR and @@IDENTITY values 
SELECT @ErrorID = @@ERROR, @PKID = @@IDENTITY

IF @@ERROR <> 0 
   BEGIN
      SET @PKID = 0
   END
ELSE
   BEGIN
      SET @PKID = @@IDENTITY
   END

-- Set the return value.
RETURN @PKID
GO
