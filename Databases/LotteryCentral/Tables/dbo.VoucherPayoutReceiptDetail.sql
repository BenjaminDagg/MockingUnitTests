CREATE TABLE [dbo].[VoucherPayoutReceiptDetail]
(
[VoucherPayoutReceiptDetailId] [int] NOT NULL IDENTITY(1, 1),
[VoucherPayoutReceiptId] [int] NOT NULL,
[VoucherPayoutId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VoucherPayoutReceiptDetail] ADD CONSTRAINT [PK_VOUCHER_RECEIPT_DETAILS_1] PRIMARY KEY CLUSTERED  ([VoucherPayoutReceiptDetailId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_DESCRIPTION', N'Stores data to join Voucher table and Voucher_Reciept Table.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceiptDetail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity of the payout.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceiptDetail', 'COLUMN', N'VoucherPayoutId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceiptDetail', 'COLUMN', N'VoucherPayoutReceiptDetailId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reciept Number the voucher belongs to.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceiptDetail', 'COLUMN', N'VoucherPayoutReceiptId'
GO
