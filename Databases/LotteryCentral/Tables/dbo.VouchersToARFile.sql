CREATE TABLE [dbo].[VouchersToARFile]
(
[VouchersToARFileID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LocationID] [int] NOT NULL,
[VoucherID] [int] NOT NULL,
[DocumentNumber] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VouchersToARFile] ADD CONSTRAINT [PK_VouchersToARFile] PRIMARY KEY CLUSTERED  ([VouchersToARFileID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
