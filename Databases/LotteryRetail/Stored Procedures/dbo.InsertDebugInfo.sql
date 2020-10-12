SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: InsertDebugInfo user stored procedure.

  Created: 03/30/2004 by Terry Watkins  

  Purpose: Inserts a DEBUG_INFO record into the DEGUB_INFO.

Arguments: @DebugText - The DEBUG_TEXT column value.
           @IntValue  - Any integer value.

Change Log:

Date       By     Change Description
---------- ------ --------------------------------------------------------------
2003-01-23 DGETAW Initial Coding.
--------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[InsertDebugInfo] @TransID SmallInt, @DebugText VarChar(2048), @IntValue Int
AS

-- Variable Declarations
DECLARE @TransType  VarChar(8)

-- Retrieve the TransType based upon the TransID value.
SELECT @TransType = ISNULL(SHORT_NAME, '') FROM TRANS WHERE TRANS_ID = @TransID

-- Insert a new DEBUG_INFO row...
INSERT INTO DEBUG_INFO
   (TRANS_TYPE, TRANS_ID, DEBUG_TEXT, INT_VALUE, CREATED_BY, CREATE_DATE)
VALUES
   (@TransType, @TransID, @DebugText, @IntValue, CURRENT_USER, GetDate())

GO
