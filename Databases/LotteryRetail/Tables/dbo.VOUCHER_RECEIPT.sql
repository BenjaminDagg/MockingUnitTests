CREATE TABLE [dbo].[VOUCHER_RECEIPT]
(
[VOUCHER_RECEIPT_NO] [int] NOT NULL IDENTITY(1, 1),
[VOUCHER_COUNT] [int] NOT NULL,
[RECEIPT_TOTAL_AMOUNT] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VOUCHER_RECEIPT] ADD CONSTRAINT [PK_VOUCHER_RECEIPT] PRIMARY KEY CLUSTERED  ([VOUCHER_RECEIPT_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores data about voucher receipts and joins vouchers to reciepts data. Multiple Voucher support.', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_RECEIPT', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total payout value of the vouchers. Sum of Voucher amounts included in the receipt.', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_RECEIPT', 'COLUMN', N'RECEIPT_TOTAL_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of vouchers included in the receipt / transaction.', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_RECEIPT', 'COLUMN', N'VOUCHER_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Receipt Number for a given transaction.', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_RECEIPT', 'COLUMN', N'VOUCHER_RECEIPT_NO'
GO
