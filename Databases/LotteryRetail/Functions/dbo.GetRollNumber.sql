SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Defined Function GetRollNumber

Created 07-25-2006 by Terry Watkins

Purpose: Returns a Roll Number (for paper deals) based upon a Ticket number and
         the number of Tabs per Subset

Returns: Roll Number


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-25-2006     v5.0.5
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[GetRollNumber] (@TicketNumber Int, @TabsPerSubset Int) RETURNS Integer
AS

BEGIN
   -- Variable Declarations
   DECLARE @ReturnValue Int
   
   -- Check for valid parameter values...
   IF (@TicketNumber < 1)
      SET @ReturnValue = -1
   ELSE IF (@TabsPerSubset < 1)
      SET @ReturnValue = -1
   ELSE
      SET @ReturnValue = (@TicketNumber / @TabsPerSubset) + SIGN(@TicketNumber % @TabsPerSubset)
      
   -- Set the function return value.
   RETURN @ReturnValue
END

GO
