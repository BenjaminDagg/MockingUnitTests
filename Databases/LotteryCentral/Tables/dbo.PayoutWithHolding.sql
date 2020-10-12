CREATE TABLE [dbo].[PayoutWithHolding]
(
[PayoutWithHoldingId] [int] NOT NULL IDENTITY(1, 1),
[VoucherPayoutReceiptId] [int] NOT NULL,
[PayoutWithHoldingType] [int] NOT NULL,
[WithHoldingAmount] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayoutWithHolding] ADD CONSTRAINT [PK_PayoutWithHolding] PRIMARY KEY CLUSTERED  ([PayoutWithHoldingId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the with holding data from payouts.', 'SCHEMA', N'dbo', 'TABLE', N'PayoutWithHolding', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'PayoutWithHolding', 'COLUMN', N'PayoutWithHoldingId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the with holding type.', 'SCHEMA', N'dbo', 'TABLE', N'PayoutWithHolding', 'COLUMN', N'PayoutWithHoldingType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the receipt this with holding is for.', 'SCHEMA', N'dbo', 'TABLE', N'PayoutWithHolding', 'COLUMN', N'VoucherPayoutReceiptId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of with holding.', 'SCHEMA', N'dbo', 'TABLE', N'PayoutWithHolding', 'COLUMN', N'WithHoldingAmount'
GO
