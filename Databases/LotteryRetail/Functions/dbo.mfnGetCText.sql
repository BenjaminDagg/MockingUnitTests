SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[mfnGetCText] (@EncryptedText [nvarchar] (4000))
RETURNS [nvarchar] (4000)
WITH EXECUTE AS CALLER
EXTERNAL NAME [DGECasinoClrExtensions].[DGECasinoClrExtensions.DGETextSupport].[mfnGetCText]
GO
EXEC sp_addextendedproperty N'AutoDeployed', N'yes', 'SCHEMA', N'dbo', 'FUNCTION', N'mfnGetCText', NULL, NULL
GO
EXEC sp_addextendedproperty N'SqlAssemblyFile', N'DGETextSupport.vb', 'SCHEMA', N'dbo', 'FUNCTION', N'mfnGetCText', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=8
EXEC sp_addextendedproperty N'SqlAssemblyFileLine', @xp, 'SCHEMA', N'dbo', 'FUNCTION', N'mfnGetCText', NULL, NULL
GO
