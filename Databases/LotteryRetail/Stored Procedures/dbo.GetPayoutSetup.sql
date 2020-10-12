SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: GetPayoutSetup user stored procedure.

  Created: 07/06/2005 by Terry Watkins  

  Purpose: Retrieves Casino Accounting Payout screen setup information.


Arguments: None

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
2005-07-06 Terry Watkins     v4.1.5
  Initial coding.

2005-07-12 Terry Watkins     v4.1.6
  Added retrieval of CashierCanActivate flag.

2005-09-20 Terry Watkins     v4.2.3
  Added retrieval of PAYOUT_TABS, VOUCHER_EXPIRATION_DAYS, CASINO_ID,
  MS_PORT_DATA, MS_DATA_INFO, MS_TIMEOUT.

2006-02-15 Terry Watkins     v5.0.2
  Removed retrieval of CASINO_ID (column also removed from CASINO table).

2007-02-08 Terry Watkins     v5.0.8
  Added retrieval of casino Lockup amount.
  
2010-11-09 Terry Watkins     DCLRetail v1.0.0
  Added retrieval of Location ID and Payout Threshold amount.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetPayoutSetup]
AS

-- Variable Declarations
DECLARE @AllowPartialPayout  Bit
DECLARE @AllowReceiptReprint Bit
DECLARE @CashierCanActivate  Bit
DECLARE @PinRequired         Bit
DECLARE @CardRequired        Bit
DECLARE @PromoOn             Bit
DECLARE @SavePosCardInserts  Bit

DECLARE @MssTimeout          Integer -- Mag Stripe setting - clear form timeout value
DECLARE @LocationID          Integer
DECLARE @PayoutTabs          Integer
DECLARE @RedeemMultiple      Integer
DECLARE @VoucherExpireDays   Integer

DECLARE @LockupAmount        SmallMoney

DECLARE @DollarsPerPoint     Money
DECLARE @PayoutThreshold     Money

DECLARE @MssPortData         VarChar(30) -- Data regarding Port and Baud info
DECLARE @MssDataInfo         VarChar(30) -- Data regarding position and size of Mag Stripe Data and Key info
DECLARE @ParameterKey        VarChar(30)
DECLARE @SecondaryCasinoID   VarChar(6)
DECLARE @Value1              VarChar(30)
DECLARE @Value2              VarChar(30)
DECLARE @Value3              VarChar(30)


-- Variable Initialization
SET @AllowPartialPayout    = 0
SET @AllowReceiptReprint   = 0
SET @CashierCanActivate    = 0
SET @DollarsPerPoint       = 0
SET @MssTimeout            = 20
SET @PayoutTabs            = 1
SET @PromoOn               = 0
SET @RedeemMultiple        = 0
SET @SavePosCardInserts    = 0
SET @SecondaryCasinoID     = '@#$'
SET @VoucherExpireDays     = 0

-- Retrieve Secondary Casino ID (if any).
SELECT
   @SecondaryCasinoID = ISNULL(CAS_ID, '@#$') 
FROM CASINO
WHERE CAS_NAME LIKE '%Secondary%'

-- Get Player Card and Promo On values from the CASINO table.
SELECT
   @CardRequired    = PLAYER_CARD,
   @PromoOn         = PROMOTIONAL_PLAY,
   @PinRequired     = PIN_REQUIRED,
   @LockupAmount    = LOCKUP_AMT,
   @PayoutThreshold = PAYOUT_THRESHOLD,
   @LocationID      = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- If PLAYER_CARD = 0 then @PinPlay must be False
IF (@CardRequired = 0) SET @PinRequired = 0

-- We need multiple values from CASINO_SYSTEM_PARAMETERS, so we will use a cursor...
DECLARE CasinoSystemData CURSOR FAST_FORWARD FOR
   SELECT
      PAR_NAME,
      UPPER(RTRIM(ISNULL(VALUE1, ''))) AS VALUE1,
      UPPER(RTRIM(ISNULL(VALUE2, ''))) AS VALUE2,
      UPPER(RTRIM(ISNULL(VALUE3, ''))) AS VALUE3
   FROM CASINO_SYSTEM_PARAMETERS
   WHERE
      PAR_NAME IN ('ALLOW_PARTIAL_PAYOUT', 'ALLOW_RECEIPT_REPRINT', 'PROMOTIONAL_PLAY',
                   'SAVE_POS_CARD_INSERTS', 'CASHIER_CAN_ACTIVATE_ACCT', 'PAYOUT_TABS',
                   'MAG_STRIPE_SETTINGS', 'VOUCHER_EXPIRATION_DAYS')

-- Open the DealTabsTotal cursor.
OPEN CasinoSystemData
-- Get the first row of data.
FETCH FROM CasinoSystemData INTO @ParameterKey, @Value1, @Value2, @Value3
WHILE (@@FETCH_STATUS = 0)
   BEGIN
      -- Successfully FETCHed a record. Set the appropriate value...
      IF (@ParameterKey = 'ALLOW_PARTIAL_PAYOUT')      AND (@Value1 IN ('TRUE','YES','1'))
         SET @AllowPartialPayout = 1
      IF (@ParameterKey = 'ALLOW_RECEIPT_REPRINT')     AND (@Value1 IN ('TRUE','YES','1'))
         SET @AllowReceiptReprint = 1
      IF (@ParameterKey = 'CASHIER_CAN_ACTIVATE_ACCT') AND (@Value1 IN ('TRUE','YES','1'))
         SET @CashierCanActivate = 1
      IF (@ParameterKey = 'SAVE_POS_CARD_INSERTS')     AND (@Value1 IN ('TRUE','YES','1'))
         SET @SavePosCardInserts = 1
      IF (@ParameterKey = 'PROMOTIONAL_PLAY')
         BEGIN
            IF ISNUMERIC(@Value1) = 1 SET @DollarsPerPoint = CAST(@Value1 AS Money)
            IF ISNUMERIC(@Value2) = 1 SET @RedeemMultiple  = CAST(@Value2 AS Integer)
         END
      IF (@ParameterKey = 'PAYOUT_TABS') AND (ISNUMERIC(@Value1) = 1)
         SET @PayoutTabs = CAST(@Value1 AS Integer)
      IF (@ParameterKey = 'VOUCHER_EXPIRATION_DAYS') AND (ISNUMERIC(@Value1) = 1)
         SET @VoucherExpireDays = CAST(@Value1 AS Integer)

      IF (@ParameterKey = 'MAG_STRIPE_SETTINGS')
         BEGIN
            SET @MssPortData = @Value1
            SET @MssDataInfo = @Value2
            IF ISNUMERIC(@Value3) = 1 SET @MssTimeout  = @Value3
         END

      -- Get the next row of the resultset.
      FETCH NEXT FROM CasinoSystemData INTO @ParameterKey, @Value1, @Value2, @Value3
   END

-- Close and Deallocate the DealTabsTotal Cursor...
CLOSE CasinoSystemData
DEALLOCATE CasinoSystemData


-- Return data:
SELECT
   @SecondaryCasinoID   AS SECONDARY_CASINO_ID,
   @LockupAmount        AS LOCKUP_AMT,
   @PinRequired         AS PIN_REQUIRED,
   @AllowPartialPayout  AS ALLOW_PARTIAL_PAYOUT,
   @AllowReceiptReprint AS ALLOW_RECEIPT_REPRINT,
   @SavePosCardInserts  AS SAVE_POS_CARD_INSERTS,
   @PromoOn             AS PROMOTIONAL_PLAY,
   @DollarsPerPoint     AS DOLLARS_PER_POINT,
   @RedeemMultiple      AS REDEEM_MULTIPLE,
   @CashierCanActivate  AS CASHIER_CAN_ACTIVATE_ACCT,
   @PayoutTabs          AS PAYOUT_TABS,
   @VoucherExpireDays   AS VOUCHER_EXPIRATION_DAYS,
   @MssPortData         AS MS_PORT_DATA,
   @MssDataInfo         AS MS_DATA_INFO,
   @MssTimeout          AS MS_TIMEOUT,
   @PayoutThreshold     AS PAYOUT_THRESHOLD,
   @LocationID          AS LOCATION_ID
   
GO
