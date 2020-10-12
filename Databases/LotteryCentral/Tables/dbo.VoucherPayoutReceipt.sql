CREATE TABLE [dbo].[VoucherPayoutReceipt]
(
[VoucherPayoutReceiptId] [int] NOT NULL IDENTITY(1, 1),
[VoucherPayoutCount] [int] NOT NULL,
[VoucherTotalAmount] [money] NOT NULL,
[VoucherReceiptTotalPayout] [money] NOT NULL,
[AppUserId] [int] NOT NULL,
[CashoutDate] [datetime] NOT NULL,
[IsVoid] [bit] NOT NULL,
[PreviousVoucherPayoutReceiptId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VoucherPayoutReceipt] ADD CONSTRAINT [PK_VoucherPayoutReceipt] PRIMARY KEY CLUSTERED  ([VoucherPayoutReceiptId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores data about voucher receipts and joins vouchers to reciepts data. Multiple Voucher support.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceipt', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user who paid out this receipt.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceipt', 'COLUMN', N'AppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this receipt was created.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceipt', 'COLUMN', N'CashoutDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The flag showing whether or not this receipt is still valid.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceipt', 'COLUMN', N'IsVoid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The previous receipt identity if this was an edited receipt.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceipt', 'COLUMN', N'PreviousVoucherPayoutReceiptId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of vouchers included in the receipt / transaction.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceipt', 'COLUMN', N'VoucherPayoutCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Receipt Number for a given transaction.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceipt', 'COLUMN', N'VoucherPayoutReceiptId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total payout after with holdings.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceipt', 'COLUMN', N'VoucherReceiptTotalPayout'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total amount of the vouchers on this receipt.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayoutReceipt', 'COLUMN', N'VoucherTotalAmount'
GO
