SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: lmsUpdateLocation user stored procedure.

  Created: 01-05-2011 by Terry Watkins

  Purpose: Called by the Lottery Mgmt System to update the columns:
           PAYOUT_THRESHOLD, RETAIL_REV_SHARE, SWEEP_ACCT, and RETAILER_NUMBER
           for the specified Location.

  Returns: Number of rows updated.
  

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-30-2004     v LR 7.2.4
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[lmsUpdateLocation]
   @LocationID      Integer,
   @LongName        VarChar(128),
   @Address1        VarChar(64),
   @Address2        VarChar(64),
   @City            VarChar(64),
   @State           VarChar(2),
   @PostalCode      VarChar(12),
   @ContactName     VarChar(32),
   @PhoneNumber     VarChar(32),
   @FaxNumber       VarChar(32),
   @ThresholdAmount Money,
   @RetailRevShare  Decimal(4,2),
   @SweepAcct       VarChar(32),
   @RetailerNumber  Char(5)
AS

-- Suppress return of unwanted messages.
SET NOCOUNT ON

-- Variable Declarations
DECLARE @ReturnValue Int

-- Variable Initializations
SET @ReturnValue = 0

-- Perform the update
UPDATE CASINO SET
   CAS_NAME         = @LongName,
   ADDRESS1         = @Address1,
   ADDRESS2         = @Address2,
   CITY             = @City,
   [STATE]          = @State,
   ZIP              = @PostalCode,
   CONTACT_NAME     = @ContactName,
   PHONE            = @PhoneNumber,
   FAX              = @FaxNumber,  
   PAYOUT_THRESHOLD = @ThresholdAmount,
   RETAIL_REV_SHARE = @RetailRevShare,
   SWEEP_ACCT       = @SweepAcct,
   RETAILER_NUMBER  = @RetailerNumber
   
WHERE LOCATION_ID = @LocationID

-- Store number of rows updated.
SELECT @ReturnValue = @@ROWCOUNT

-- Set the return value.
RETURN @ReturnValue
GO
