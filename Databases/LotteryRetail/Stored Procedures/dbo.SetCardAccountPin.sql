SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: SetCardAccountPin user stored procedure.

  Created: 07/07/2005 by Terry Watkins  

  Purpose: Assigns Pin number to Card Account and optionally stores player info
           and associates it with the Card Account.

Arguments: @CardAcctNumber - Card Account Number
           @PinNumber      - Pin to associate with the Card Account
           @FirstName      - Customer first name to associate with the Card Account
           @LastName       - Customer last name to associate with the Card Account
           @DOB            - Customers date of birth

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
2005-07-07 Terry Watkins     v4.1.5
  Initial coding.

2005-07-13 Terry Watkins     v4.1.6
  Changed datatype of PinNumber from Integer to VarChar(6)
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SetCardAccountPin]
   @CardAcctNumber VarChar(20),
   @PinNumber      VarChar(6),
   @FirstName      VarChar(20) = NULL,
   @LastName       VarChar(30) = NULL,
   @DOB            DateTime    = NULL
AS

-- Variable Declarations
DECLARE @RecordCount Int
DECLARE @ErrorID     Int
DECLARE @PlayerID    Int
DECLARE @PTData      VarChar(128)

-- Variable Initialization
SET @ErrorID  = 0


SET @PTData = ISNULL(@FirstName, '') + ISNULL(@LastName, '')
IF NOT @DOB IS NULL SET @PTData = @PTData + CAST(@DOB AS VarChar)

-- Determine if the CardAccount already exists.
SELECT @RecordCount = COUNT(*) FROM CARD_ACCT WHERE CARD_ACCT_NO = @CardAcctNumber

IF (@RecordCount = 0)
   BEGIN
      -- Account not found, insert it.
      INSERT INTO CARD_ACCT
         (CARD_ACCT_NO, BALANCE, PIN_NUMBER, STATUS, MACH_NO)
      VALUES
         (@CardAcctNumber, 0, @PinNumber, 1, '0')
      
      -- Store error code
      SET @ErrorID = @@ERROR
   END
ELSE
   -- Account found, update the Pin.
   BEGIN
      UPDATE CARD_ACCT SET
         PIN_NUMBER = @PinNumber,
         @PlayerID  = ISNULL(PLAYER_ID, 0)
      WHERE CARD_ACCT_NO = @CardAcctNumber
      
      -- Store error code
      SET @ErrorID = @@ERROR
   END

-- If no errors and we have Player tracking data, save it...
IF (@ErrorID = 0 AND LEN(@PTData) > 0)
   BEGIN
      -- Do we already have a PLAYER_TRACK row?
      IF (@PlayerID > 0)
         BEGIN
            -- Yes, so update the existing PLAYER_TRACK row.
            UPDATE PLAYER_TRACK
            SET FNAME = @FirstName, LNAME = @LastName, DOB = @DOB
            WHERE PLAYER_ID = @PlayerID
            
            SET @ErrorID = @@ERROR
         END
      ELSE
         BEGIN
            -- No, so insert a PLAYER_TRACK row.
            INSERT INTO PLAYER_TRACK
               (FNAME, LNAME, DOB)
            VALUES
               (@FirstName, @LastName, @DOB)
            
            -- Store the error code and PLAYER_TRACK PK.
            SELECT @ErrorID = @@ERROR, @PlayerID = @@IDENTITY
         END
      
      -- Update CARD_ACCT.PLAYER_ID
      IF (@ErrorID = 0)
         BEGIN
            UPDATE CARD_ACCT
            SET PLAYER_ID = @PlayerID
            WHERE CARD_ACCT_NO = @CardAcctNumber
            
            -- Store error code
            SET @ErrorID = @@ERROR
         END
   END

-- Return the error code.
RETURN @ErrorID
GO
