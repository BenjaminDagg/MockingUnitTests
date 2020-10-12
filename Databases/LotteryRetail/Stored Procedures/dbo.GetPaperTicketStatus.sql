SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: GetPaperTicketStatus user stored procedure.

  Created: 03-08-2011 by Terry Watkins  

  Purpose: Retrieves Ticket Status information.


Arguments: @DealNumber   - Deal Number of the ticket
           @TicketNumber - Ticket Number to check

  Returns: 0 = Ticket found and is Active
           1 = Ticket found but is Inactive
           2 = eDeal Deal table not found.
           
Change Log:

Date       By                Database Version
  Change Description
--------------------------------------------------------------------------------
03-08-2011 Terry Watkins     v7.2.5
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetPaperTicketStatus]
   @DealNumber   Int,
   @TicketNumber Int
AS

-- Variable Declarations
DECLARE @ReturnValue         Int

DECLARE @IsActive            Bit

DECLARE @DealTable           VarChar(32)
DECLARE @ParamString         nVarChar(128)
DECLARE @SelectStatement     nVarChar(1024)

-- Variable Initialization
SET @ReturnValue = 0
SET @DealTable   = 'Deal' + CAST(@DealNumber AS VARCHAR)

-- Does the DealTable exist?
IF EXISTS(SELECT * FROM eDeal.dbo.sysobjects WHERE Name = @DealTable)
   BEGIN
      -- Retrieve the IsActive value of the Ticket.
      SET @SelectStatement = N'SELECT @IsActive = IsActive FROM eDeal.dbo.' +
          @DealTable + N' WHERE TicketNumber = ' + CAST(@TicketNumber AS VarChar)
      
      SET @ParamString = N'@IsActive Bit OUTPUT'
      
      EXEC sp_ExecuteSQL @SelectStatement, @ParamString, @IsActive = @IsActive OUTPUT
      -- If the Ticket is not Active, reset the return value to 1
      IF @IsActive = 0
         SET @ReturnValue = 1
   END
ELSE
   -- Deal table in eDeal database was not found.
   SET @ReturnValue = 2

RETURN @ReturnValue

GO
