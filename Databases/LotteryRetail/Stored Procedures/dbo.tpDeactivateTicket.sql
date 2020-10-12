SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpDeactivateTicket

Created 03-31-2005 by Terry Watkins

Description: Sets the IsActive flag to 0 for the specified Deal/Ticket

Return values: ErrorCode

Called by: tpTransL, tpTransW, tpTransJ, tpTransF

Parameters:
   @DealNumber    Deal Number which is used to determine the table to update
   @TicketNumber  The Ticket Number to deactivate

Change Log:

Changed By    Date          DB Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 01-10-2005    4.0.2
  Initial coding.

Terry Watkins 01-18-2006    5.0.1
  Modified to handle Class III slim Deals.
  Updates eDeal or eTab based upon the GameClass argument value.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[tpDeactivateTicket]
   @DealNumber          Int,
   @TicketNumber        Int,
   @GameClass           SmallInt = 2
AS

-- Variable Declarations
DECLARE @DbName     VarChar(8)
DECLARE @SQLText    VarChar(128)
DECLARE @ErrorID    Int


-- Build the SQL Update statement text.
IF @GameClass = 3
   SET @DbName = 'eTab'
ELSE
   SET @DbName = 'eDeal'

SET @SQLText = 'UPDATE ' + @DbName + '.dbo.Deal' + CAST(@DealNumber AS VarChar) +
               ' SET IsActive = 0 WHERE TicketNumber = ' + CAST(@TicketNumber AS VarChar)

-- Execute the update.
EXEC (@SQLText)

-- Capture error
SET @ErrorID = @@ERROR

-- Return error number (0 if successful)
RETURN @ErrorID
GO
