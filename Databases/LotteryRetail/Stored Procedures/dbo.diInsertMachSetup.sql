SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: diInsertMachSetup

Created By:     Chris Coddington

Create Date:    09/09/2003

Description:    Inserts a row into the MACH_SETUP table.

Returns:        0 = Successful row insertion
                1 = Record exists and update flag = 1 (record updated)
                2 = Record exists and update flag = 0 (update ignored)
                n = TSQL Error Code

Parameters:     Each field from the MACH_SETUP table.

Change Log:

Changed By    Date           DB Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 01-31-2006     v5.0.1
   Changed @TypeID datatype from VarChar(10) to Char(1)
   Added @UpdateFlag (Bit default 1) which determines if row is updated if it
   already exists.
--------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[diInsertMachSetup]
   @MachNo        Char(5),
   @TypeID        Char(1),
   @ModelDesc     VarChar(64),
   @BankNo        Int,
   @GameCode      VarChar(10),
   @RemovedFlag   Bit,
   @IPAddress     VarChar(24),
   @UpdateFlag    Bit = 1

AS

-- Variable Declaration
DECLARE @ReturnValue    Int

-- Variable Initialization
SET @ReturnValue = 0

SET NOCOUNT ON

-- Test to see if the record already exists.
IF EXISTS (SELECT * FROM MACH_SETUP WHERE MACH_NO = @MachNo)
   BEGIN
      -- Record already exists.
      IF (@UpdateFlag = 1)
         -- Update flag is set, so update the record.
         BEGIN
            UPDATE MACH_SETUP SET
               TYPE_ID      = @TypeID,
               MODEL_DESC   = @ModelDesc,
               BANK_NO      = @BankNo,
               GAME_CODE    = @GameCode,
               REMOVED_FLAG = @RemovedFlag,
               IP_ADDRESS   = @IPAddress
            WHERE MACH_NO = @MachNo
            
            SET @ReturnValue = @@ERROR
            IF @ReturnValue = 0 SET @ReturnValue = 1
         END
      ELSE
         -- Update flag is not set, so return 2 (update skipped).
         BEGIN
            SET @ReturnValue = 2
         END
   END
ELSE
   BEGIN
      -- Record doesn't exist, so insert it.
      INSERT INTO MACH_SETUP
         (MACH_NO, MODEL_DESC, TYPE_ID, GAME_CODE, BANK_NO, IP_ADDRESS, REMOVED_FLAG, CASINO_MACH_NO)
      VALUES
         (@MachNo, @ModelDesc, @TypeID, @GameCode, @BankNo, @IPAddress, @RemovedFlag, @MachNo)
      
      SET @ReturnValue = @@ERROR
   END

RETURN @ReturnValue
GO
