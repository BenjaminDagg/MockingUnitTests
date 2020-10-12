SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[mfnGetVoucherCheckValue] (@BarcodeText [nvarchar] (4000), @VoucherAmount [bigint], @RedeemedState [bit])
RETURNS [varbinary] (8000)
WITH EXECUTE AS CALLER
EXTERNAL NAME [DGECasinoClrExtensions].[DGECasinoClrExtensions.VoucherSupport].[mfnGetVoucherCheckValue]
GO
EXEC sp_addextendedproperty N'AutoDeployed', N'yes', 'SCHEMA', N'dbo', 'FUNCTION', N'mfnGetVoucherCheckValue', NULL, NULL
GO
EXEC sp_addextendedproperty N'SqlAssemblyFile', N'VoucherSupport.vb', 'SCHEMA', N'dbo', 'FUNCTION', N'mfnGetVoucherCheckValue', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=13
EXEC sp_addextendedproperty N'SqlAssemblyFileLine', @xp, 'SCHEMA', N'dbo', 'FUNCTION', N'mfnGetVoucherCheckValue', NULL, NULL
GO
