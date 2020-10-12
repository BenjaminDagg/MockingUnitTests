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
EXEC sp_addextendedproperty N'MS_Description', N'Table stores data that ties expired vouchers to an AR file.', 'SCHEMA', N'dbo', 'TABLE', N'VouchersToARFile', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Julian date tied with the MO_DailyARData table', 'SCHEMA', N'dbo', 'TABLE', N'VouchersToARFile', 'COLUMN', N'DocumentNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location unique indentifier', 'SCHEMA', N'dbo', 'TABLE', N'VouchersToARFile', 'COLUMN', N'LocationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique indentifier from the Voucher table', 'SCHEMA', N'dbo', 'TABLE', N'VouchersToARFile', 'COLUMN', N'VoucherID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity column', 'SCHEMA', N'dbo', 'TABLE', N'VouchersToARFile', 'COLUMN', N'VouchersToARFileID'
GO
