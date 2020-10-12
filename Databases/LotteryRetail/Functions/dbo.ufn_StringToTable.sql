SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnStringToTable

Created 02-21-2012 by Aldo Zamora

Purpose: 

Returns: 

   Note: 
         

Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   02-21-2012     v3.0.4
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufn_StringToTable] (
   @String VARCHAR(MAX), /* input string */
   @Delimeter CHAR(1),   /* delimiter */
   @TrimSpace BIT)      /* kill whitespace? */
   
RETURNS @Table TABLE ([Val] VARCHAR(4000))

AS 
      BEGIN
         DECLARE @Val VARCHAR(4000)
         WHILE LEN(@String) > 0 
            BEGIN
               SET @Val = LEFT(@String, ISNULL(NULLIF(CHARINDEX(@Delimeter, @String) - 1, -1), LEN(@String)))
               SET @String = SUBSTRING(@String, ISNULL(NULLIF(CHARINDEX(@Delimeter, @String), 0), LEN(@String)) + 1, LEN(@String))
               IF @TrimSpace = 1 
                  SET @Val = LTRIM(RTRIM(@Val))
               INSERT   INTO @Table
                        ([Val])
               VALUES
                        (@Val)
            END
         RETURN
      END
GO
