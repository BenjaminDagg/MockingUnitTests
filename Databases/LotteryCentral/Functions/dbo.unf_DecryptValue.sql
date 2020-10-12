SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[unf_DecryptValue] (@encryptedText [nvarchar] (4000))
RETURNS [nvarchar] (4000)
WITH EXECUTE AS CALLER
EXTERNAL NAME [DGCoreCLR].[DGCoreSqlEncryption].[DecryptValue]
GO
