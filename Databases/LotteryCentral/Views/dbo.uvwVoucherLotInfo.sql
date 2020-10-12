SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[uvwVoucherLotInfo]
AS
SELECT
   vl.VOUCHER_LOT_ID AS VoucherLotID,
   vl.LOCATION_ID    AS LocationID,
   vl.LOT_NUMBER     AS LotNumber,
   vl.DATE_RECEIVED  AS DateReceived,
   cas.CAS_NAME      AS Location,
   cas.CAS_ID         AS DgeID,
   cas.Address1      AS LocAddress1
FROM dbo.VOUCHER_LOT vl
   LEFT OUTER JOIN dbo.CASINO cas ON vl.LOCATION_ID = cas.LOCATION_ID


GO
