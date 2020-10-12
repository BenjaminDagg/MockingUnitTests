SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Name: tpGetTpiSetting

Created 10-25-2004 by Terry Watkins

Purpose: Retrieves a setting value for a specific TPI and key value.

Called by: Transaction Portal

Parameters: @TpiID     Identifies the Third Party Interface
            @ItemKey   Key used to retrieve a setting value

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 11-01-2004     v4.0.0
  Initial coding.

A. Murthy 08-18-2005         v4.2.0
  Changed select to take place from VOUCHER_TEMPLATE table.

A. Murthy 10-06-2005         v4.2.3
  For ItemKey = "ExpirationDays", the select takes place from TPI_SETTING table .
  For all other ItemKeys, select takes place from VOUCHER_TEMPLATE table.

A. Murthy 07-10-2006         v5.0.1
  Add Select for ItemKey = "ExpirationMsg" from TPI_SETTING table. Note this is for THB001 only.
  
Louis Epstein 07-29-2014     v3.2.4
  Added month expiration value

--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetTpiSetting] @TpiID Int, @ItemKey VarChar(32)
AS

-- Perform the item retrieval.
IF @ItemKey = 'ExpirationDays' OR @ItemKey = 'ExpirationMsg'
   BEGIN
      -- Perform item retrieval from TPI_SETTING table.
      SELECT
         ITEM_VALUE, @@ERROR AS ErrorID FROM TPI_SETTING
         WHERE TPI_ID = @TpiID AND ITEM_KEY = @ItemKey
   END
ELSE IF @ItemKey = 'ExpirationMonths'
BEGIN
IF EXISTS (SELECT * FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'VoucherExpirationMonths')
BEGIN
SELECT VALUE1 AS ITEM_VALUE, @@ERROR AS ErrorID FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'VoucherExpirationMonths'
END
ELSE
BEGIN
SELECT '' AS ITEM_VALUE, 0 AS ErrorID FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'VoucherExpirationMonths'
END
END
ELSE
   BEGIN
      -- Perform item retrieval from VOUCHER_TEMPLATE table.
      SELECT
         ITEM_VALUE, @@ERROR AS ErrorID FROM VOUCHER_TEMPLATE
         WHERE TPI_ID = @TpiID AND ITEM_KEY = @ItemKey
   END
GO
