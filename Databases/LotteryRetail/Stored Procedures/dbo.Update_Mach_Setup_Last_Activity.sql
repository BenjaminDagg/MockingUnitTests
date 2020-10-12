SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: Update_Mach_Setup_Last_Activity user stored procedure.

  Created: 01/29/03 by Norm Symonds 

  Purpose: Populates the LAST_ACTIVITY column in the MACH_SETUP table with the
           date and time of the last transaction for each machine.

Change Log:

Date       By     Change Description
---------- ------ --------------------------------------------------------------
2003-01-21 DGENLS Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[Update_Mach_Setup_Last_Activity]
AS

DECLARE @MachNo       Char(5)
DECLARE @LastActivity DateTime

DECLARE Mach_Activity_Scan CURSOR FAST_FORWARD
FOR
SELECT MACH_NO, MAX(DTIMESTAMP) FROM CASINO_TRANS
GROUP BY MACH_NO
ORDER BY MACH_NO

-- Open the cursor.
OPEN Mach_Activity_Scan

-- Get the first row of data.
FETCH FROM Mach_Activity_Scan INTO @MachNo, @LastActivity

WHILE (@@FETCH_STATUS = 0)
   -- Successfully FETCHed a record, update the LAST_ACTIVITY column...
   BEGIN
      UPDATE MACH_SETUP 
      SET LAST_ACTIVITY = @LastActivity
      WHERE MACH_NO = @MachNo

      PRINT 'Updating LAST_ACTIVITY for Machine Number ' + @MachNo

      -- Get the next row of the resultset.
      FETCH NEXT FROM Mach_Activity_Scan INTO @MachNo, @LastActivity
   END

-- Close and Deallocate Cursor
CLOSE Mach_Activity_Scan
DEALLOCATE Mach_Activity_Scan
GO
