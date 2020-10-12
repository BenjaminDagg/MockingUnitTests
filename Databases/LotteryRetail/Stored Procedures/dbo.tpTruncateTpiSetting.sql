SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

/*
--------------------------------------------------------------------------------
User Stored Procedure tpTruncateTpiSetting

  Created: 08/19/2005 by Ashok Murthy

  Purpose: Truncates the TPI_SETTING table. Then it obtains the "ExpirationDays" from
           CASINO_SYSTEM_PARAMETERS and inserts a new row in the TPI_SETTING table.

  Called By :	TPIServer.vb\DbTpTruncateTpiSetting

Arguments: None

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Ashok Murthy 08/19/2005      v4.2.0
  Initial coding.

Ashok Murthy 09/13/2005      v4.2.1
  Insert new row in TPI_SETTING table after truncation.

Ashok Murthy 01/09/2006      v5.0.1
  Truncate TPI_SETTING for all TPI_IDs except TPI_ID=3 (Iowa Lottery).
  Select new PARAM37 from CASINO_SYSTEM_PARAMETERS table for THB001 Casino voucher printing.
--------------------------------------------------------------------------------
*/
CREATE  PROCEDURE [dbo].[tpTruncateTpiSetting]
AS


SET NOCOUNT ON

-- Variable Declarations
DECLARE @ExpirationDays     VarChar(32)
DECLARE @ExpirationMsg      VarChar(32)
DECLARE @TpiID              int

-- Variable Initialization
SET @ExpirationDays = ''
SET @ExpirationMsg  = ''
SELECT @TpiID = TPI_ID FROM CASINO WHERE SETASDEFAULT = 1

-- Truncate or Delete rows in the TPI_SETTING table.
IF (@TpiID <> 3)
   -- Non Iowa Lottery Database, Truncate the TPI_SETTING table.
   TRUNCATE TABLE TPI_SETTING
ELSE
   BEGIN
      -- For IowaLottery, remove all rows from TPI_SETTING except those for Iowa.
      DELETE FROM TPI_SETTING WHERE TPI_ID <> 3
   END

-- Obtain the "VOUCHER_EXPIRATION_DAYS" from CASINO_SYSTEM_PARAMETERS table.
-- Force a default value of 5 days if this parm. is not present.
IF EXISTS (SELECT * FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'VOUCHER_EXPIRATION_DAYS')
   SELECT @ExpirationDays = ISNULL(RTRIM(VALUE1),'5')
   FROM CASINO_SYSTEM_PARAMETERS
   WHERE PAR_NAME = 'VOUCHER_EXPIRATION_DAYS'
ELSE
   SET @ExpirationDays = '5'

-- Now add a row with TPI_ID=0, ITEM_KEY='ExpirationDays' in the TPI_SETTING table.
INSERT INTO TPI_SETTING
   (TPI_ID, ITEM_KEY, ITEM_VALUE)
VALUES
   (0, 'ExpirationDays', @ExpirationDays)


-- Obtain the "VOUCHER_EXPIRATION_MSG" from CASINO_SYSTEM_PARAMETERS table.
-- Force a default value of " This Game Day" if this parm. is not present.
IF EXISTS (SELECT * FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'VOUCHER_EXPIRATION_MSG')
   SELECT @ExpirationMsg = ISNULL(RTRIM(VALUE1),'This Game Day')
   FROM CASINO_SYSTEM_PARAMETERS
   WHERE PAR_NAME = 'VOUCHER_EXPIRATION_MSG'
ELSE
   SET @ExpirationMsg = 'This Game Day'

-- Now add a row with TPI_ID=0, ITEM_KEY='ExpirationMsg' in the TPI_SETTING table.
INSERT INTO TPI_SETTING
   (TPI_ID, ITEM_KEY, ITEM_VALUE)
VALUES
   (0, 'ExpirationMsg', @ExpirationMsg)
GO
