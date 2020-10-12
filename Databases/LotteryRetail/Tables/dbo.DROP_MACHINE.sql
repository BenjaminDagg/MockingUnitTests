CREATE TABLE [dbo].[DROP_MACHINE]
(
[DROP_MACHINE_ID] [int] NOT NULL IDENTITY(1, 1),
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CARD_ACCT_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCATION_ID] [int] NOT NULL,
[DROP_AMOUNT] [int] NOT NULL CONSTRAINT [DF_DropMachine_DropAmount] DEFAULT ((0)),
[ONE_DOLLAR_AMT] [int] NOT NULL CONSTRAINT [DF_DropMachine_OneDollarBillAmt] DEFAULT ((0)),
[TWO_DOLLAR_AMT] [int] NOT NULL CONSTRAINT [DF_DropMachine_TwoDollarBillAmt] DEFAULT ((0)),
[FIVE_DOLLAR_AMT] [int] NOT NULL CONSTRAINT [DF_DropMachine_FiveDollarBillAmt] DEFAULT ((0)),
[TEN_DOLLAR_AMT] [int] NOT NULL CONSTRAINT [DF_DropMachine_TenDollarBillAmt] DEFAULT ((0)),
[TWENTY_DOLLAR_AMT] [int] NOT NULL CONSTRAINT [DF_DropMachine_TwentyDollarBillAmt] DEFAULT ((0)),
[FIFTY_DOLLAR_AMT] [int] NOT NULL CONSTRAINT [DF_DropMachine_FiftyDollarBillAmt] DEFAULT ((0)),
[HUNDRED_DOLLAR_AMT] [int] NOT NULL CONSTRAINT [DF_DropMachine_HundredDollarBillAmt] DEFAULT ((0)),
[TICKET_IN_COUNT] [int] NOT NULL CONSTRAINT [DF_DROP_MACHINE_TICKET_IN_COUNT] DEFAULT ((0)),
[TICKET_IN_AMOUNT] [int] NOT NULL CONSTRAINT [DF_DROP_MACHINE_TICKET_IN_AMOUNT] DEFAULT ((0)),
[PROMO_IN_COUNT] [int] NOT NULL CONSTRAINT [DF_DROP_MACHINE_PROMO_IN_COUNT] DEFAULT ((0)),
[PROMO_IN_AMOUNT] [int] NOT NULL CONSTRAINT [DF_DROP_MACHINE_PROMO_IN_AMOUNT] DEFAULT ((0)),
[TABS_SOLD] [int] NOT NULL CONSTRAINT [DF_DropMachine_TabsSold] DEFAULT ((0)),
[WINNING_TABS] [int] NOT NULL CONSTRAINT [DF_DropMachine_WinningTabs] DEFAULT ((0)),
[LOSING_TABS] [int] NOT NULL CONSTRAINT [DF_DropMachine_LosingTabs] DEFAULT ((0)),
[AMOUNT_WON] [int] NOT NULL CONSTRAINT [DF_DropMachine_AmountWon] DEFAULT ((0)),
[DTIMESTAMP] [datetime] NULL CONSTRAINT [DF_DropMachine_DTIMESTAMP] DEFAULT (getdate()),
[LAST_DROP] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DROP_MACHINE] ADD CONSTRAINT [PK_DROP_MACHINE] PRIMARY KEY CLUSTERED  ([DROP_MACHINE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DropMachine] ON [dbo].[DROP_MACHINE] ([MACH_NO], [DTIMESTAMP]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores EGM Drop data.', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount won', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'AMOUNT_WON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Card Account Number', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'CARD_ACCT_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount dropped in cents', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'DROP_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'DROP_MACHINE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time of the drop', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'DTIMESTAMP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fifty Dollar bill count', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'FIFTY_DOLLAR_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Five Dollar bill count', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'FIVE_DOLLAR_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'One Hundred Dollar bill count', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'HUNDRED_DOLLAR_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last drop date and time reported by the machine', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'LAST_DROP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of losing tabs sold', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'LOSING_TABS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DGE Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'One Dollar bill count', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'ONE_DOLLAR_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in cents of Promotional coupons that the Machine accepted.', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'PROMO_IN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Promotional coupons that the Machine accepted.', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'PROMO_IN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total tabs sold', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'TABS_SOLD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ten Dollar bill count', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'TEN_DOLLAR_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in cents of Vouchers that the Machine accepted.', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'TICKET_IN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Vouchers that the Machine accepted.', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'TICKET_IN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Twenty Dollar bill count', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'TWENTY_DOLLAR_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Two Dollar bill count', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'TWO_DOLLAR_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of winning tabs sold', 'SCHEMA', N'dbo', 'TABLE', N'DROP_MACHINE', 'COLUMN', N'WINNING_TABS'
GO
