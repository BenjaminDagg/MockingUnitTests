SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: tpInsertCasinoEvent user stored procedure.

  Created: 12-21-2006 by Terry Watkins

     Desc: Inserts Data into the CASINO_EVENT_LOG

  Returns: CASINO_EVENT_LOG_ID on success or -1 on error

Parameters: 
   @EventCode       Event code maps to CASINO_EVENT_CODE table
   @EventSource     Procedure or application that is adding the record
   @EventDesc       Descriptive text about the event being recorded
   @IDValue         ID value, usually relates the log entry to an entry in CASINO_TRANS
   @CreatedBy       Person or entity that created the record, default = NULL
   @ErrorNo         Error Number (link to ERROR_LOOKUP), default = 0
   @MachineNumber   Machine Number, default = '0'

Date: 03-09-2007


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 03-09-2007     v5.0.9
  Initial coding.

Terry Watkins 05-12-2010     v7.2.1
  Added arguments @ErrorNo and @MachineNumber and modified insert for new
  CASINO_EVENT_LOG columns ERROR_NO and MACH_NO.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpInsertCasinoEvent]
   @EventCode       Char(2),
   @EventSource     VarChar(64),
   @EventDesc       VarChar(1024),
   @IDValue         Int = NULL,
   @CreatedBy       VarChar(10) = NULL,
   @ErrorNo         Int = 0,
   @MachineNumber   Char(5) = '0'
AS

-- Variable Declarations
DECLARE @SqlError    Int
DECLARE @ReturnValue Int

-- Variable Initialization

-- Perform the Insert.
INSERT INTO CASINO_EVENT_LOG
   (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ID_VALUE, CREATED_BY, ERROR_NO, MACH_NO)
VALUES
   (@EventCode, @EventSource, @EventDesc, @IDValue, @CreatedBy, @ErrorNo, @MachineNumber)

-- Store error and identity value.
SELECT @SqlError = @@ERROR, @ReturnValue = SCOPE_IDENTITY()

-- If an error occurred, set the return value to -1.
IF @SqlError <> 0 SET @ReturnValue = -1

-- Return the CASINO_EVENT_LOG_ID (PK Identity Int) value or -1 if an error occurred.
RETURN @ReturnValue
GO
