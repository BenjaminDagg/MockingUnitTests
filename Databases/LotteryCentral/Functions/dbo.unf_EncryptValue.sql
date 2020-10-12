SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[unf_EncryptValue] (@clearTextValue [nvarchar] (4000))
RETURNS [nvarchar] (4000)
WITH EXECUTE AS CALLER
EXTERNAL NAME [DGCoreCLR].[DGCoreSqlEncryption].[EncryptValue]
GO
