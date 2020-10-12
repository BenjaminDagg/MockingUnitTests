SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: SaveLastMachineMessage user stored procedure.

  Created: 01-24-2012 by Aldo Zamora 

  Purpose: Inserts/Updates machine message.
           
Arguments: @MachineNumber, @SequenceNumber, @TransType, @TPResponse

Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
01-24-2012 Aldo Zamora       v7.3.1
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SaveLastMachineMessage] 
   @MachineNumber VARCHAR(5),
   @SequenceNumber INT,
   @TransType VARCHAR(8),
   @TPResponse VARCHAR(1024)
   
AS

SET NOCOUNT ON

-- Variable Declaration
DECLARE @ReturnValue INT

-- Variable Initialization
SET @ReturnValue = 0

IF EXISTS(SELECT * FROM dbo.LastMachineMessage WHERE MachineNumber = @MachineNumber)
   BEGIN
      UPDATE dbo.LastMachineMessage
      SET
	     MachineSequenceNumber = @SequenceNumber,
	     TransType = @TransType,
		 TPResponse = @TPResponse
      WHERE MachineNumber = @MachineNumber

	  -- Store SQL error code.
      SET @ReturnValue = @@ERROR
   END
ELSE
   BEGIN
      INSERT INTO dbo.LastMachineMessage
   	     (MachineNumber, MachineSequenceNumber, TransType, TPResponse)
   	  VALUES
   	     (@MachineNumber, @SequenceNumber, @TransType, @TPResponse)
		       
	  -- Store SQL error code.
      SET @ReturnValue = @@ERROR
   END 

-- Set the function return value.
SELECT @ReturnValue As ReturnValue
GO
