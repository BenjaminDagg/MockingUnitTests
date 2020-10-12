SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnGetFDOPW

Created 08-07-2008 by Aldo Zamora

Purpose: Returns the first day of the previous week for a reporting period

Returns: DateTime - first day of previous week


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   08-06-2008     v6.0.2
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnGetFDOPW] (@SelectDate DateTime) RETURNS DateTime
AS

BEGIN
   -- Variable Declariations
   DECLARE @ReturnValue     DateTime
   DECLARE @Value           VarChar(4)
   DECLARE @Offset          Int
   
   -- Does the WRSBYGAME_DOW row exist in CASINO_SYSTEM_PARAMETERS?
   IF EXISTS(SELECT * FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'WRSBYGAME_FDOW')
      -- Yes, so retrieve casino's business FDOW, 1=Sunday, 2= Monday.
      BEGIN
         SELECT @Value = VALUE1
         FROM CASINO_SYSTEM_PARAMETERS
         WHERE PAR_NAME = 'WRSBYGAME_FDOW'
      END
   ELSE
      -- Row not found, default to Monday.
      BEGIN
         SET @Value = 2
      END
   
   -- Calculate offset date
   SET @Offset = DatePart(dw, @SelectDate) + 6
      -- If FDOW is Monday decrement the offset
      IF (@Value <> '1')
         SET @Offset = @Offset - 1
   
   -- Set return value to first day of week
   SET @ReturnValue = DATEADD(day,  -@Offset,  @SelectDate)
   
   -- Return value
   RETURN @ReturnValue
END
GO
