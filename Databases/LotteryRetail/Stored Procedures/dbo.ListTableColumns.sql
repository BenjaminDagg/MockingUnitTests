SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure Name: ListTableColumns

Created By:     Terry Watkins

Create Date:    09/13/2003

Description:    Returns Column list and info for the specified table

Returns:        Dataset

Parameters:     @TableName VarChar(128)

Change Log:

Changed By    Date       Change Description
------------- ---------- -------------------------------------------------------

--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[ListTableColumns] @TableName VarChar(128)
AS
SELECT
   c.ORDINAL_POSITION   AS ColumnNbr,
   c.COLUMN_NAME        AS ColumnName,
   c.DATA_TYPE          AS DataType,
   c.COLUMN_DEFAULT     AS DefaultValue,
   c.CHARACTER_MAXIMUM_LENGTH AS MaxCharSize,
   e.value              AS ColumnDescription
FROM INFORMATION_SCHEMA.COLUMNS AS c
   LEFT OUTER JOIN ::fn_listextendedproperty (NULL, 'user', 'dbo', 'table', @TableName, 'column', default) AS e
      ON c.COLUMN_NAME COLLATE Latin1_General_CI_AS = e.objname
WHERE TABLE_NAME = @TableName

GO
