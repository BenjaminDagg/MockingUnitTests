CREATE TABLE [dbo].[GRAND_METER]
(
[GRAND_METER_ID] [int] NOT NULL IDENTITY(1, 1),
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CASINO_MACH_NO] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACCT_DATE] [datetime] NOT NULL,
[PLAY_COUNT] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_GAMES_PLAYED] DEFAULT ((0)),
[AMOUNT_IN] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_MONEY_IN] DEFAULT ((0)),
[AMOUNT_PLAYED] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_MONEY_PLAYED] DEFAULT ((0)),
[TOTAL_PRIZES] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_TOTAL_PRIZES] DEFAULT ((0)),
[CREDIT_BALANCE] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_CREDIT_BALANCE] DEFAULT ((0)),
[BILL_COUNT] [bigint] NOT NULL,
[BILL_COUNT_1] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_BILLS1] DEFAULT ((0)),
[BILL_COUNT_2] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_BILLS2] DEFAULT ((0)),
[BILL_COUNT_5] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_BILLS5] DEFAULT ((0)),
[BILL_COUNT_10] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_BILLS10] DEFAULT ((0)),
[BILL_COUNT_20] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_BILLS20] DEFAULT ((0)),
[BILL_COUNT_50] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_BILLS50] DEFAULT ((0)),
[BILL_COUNT_100] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_BILLS100] DEFAULT ((0)),
[BILL_COUNT_OTHER] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_BILLS_OTHER] DEFAULT ((0)),
[TICKET_IN_AMOUNT] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_TICKET_IN] DEFAULT ((0)),
[TICKET_IN_COUNT] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_TICKET_IN_COUNT] DEFAULT ((0)),
[TICKET_OUT_AMOUNT] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_TICKET_OUT] DEFAULT ((0)),
[TICKET_OUT_COUNT] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_TICKET_OUT_COUNT] DEFAULT ((0)),
[HANDPAY_OUT_AMOUNT] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_HANDPAY_OUT] DEFAULT ((0)),
[HANDPAY_COUNT] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_HANDPAY_COUNT] DEFAULT ((0)),
[PROGRESSIVE_CONTRIBUTIONS] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_PROGRESSIVE_CONTRIBUTIONS] DEFAULT ((0)),
[PROGRESSIVE_AWARDS] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_PROGRESSIVE_AWARDS] DEFAULT ((0)),
[JACKPOT_OUT_AMOUNT] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_JACKPOT_OUT] DEFAULT ((0)),
[JACKPOT_COUNT] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_JACKPOT_COUNT] DEFAULT ((0)),
[PROMO_IN_AMOUNT] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_PROMO_IN] DEFAULT ((0)),
[PROMO_IN_COUNT] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_PROMO_IN_COUNT] DEFAULT ((0)),
[CABINET_DOOR_OPEN] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_CABINET_DOOR_OPEN] DEFAULT ((0)),
[BILL_DOOR_OPEN] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_BILL_DOOR_OPEN] DEFAULT ((0)),
[POWER_CYCLE] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_POWER_CYCLE] DEFAULT ((0)),
[CABINET_BASE_DOOR_OPEN] [int] NOT NULL,
[LOGIC_DOOR_OPEN] [int] NOT NULL,
[PROGRESSIVE_COUNT] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_PROGRESSIVE_COUNT] DEFAULT ((0)),
[CANCELLED_CREDIT_OUT] [money] NOT NULL CONSTRAINT [DF_GRAND_METER_CANCELLED_CREDIT_OUT] DEFAULT ((0)),
[CANCELLED_CREDIT_COUNT] [bigint] NOT NULL CONSTRAINT [DF_GRAND_METER_CANCELLED_CREDIT_COUNT] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GRAND_METER] ADD CONSTRAINT [PK_GRAND_METER] PRIMARY KEY CLUSTERED  ([GRAND_METER_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores machine meter data by EGM and Accounting Date.', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Date', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'ACCT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of money inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'AMOUNT_IN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of money wagered on the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'AMOUNT_PLAYED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 1 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_COUNT_1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of10 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_COUNT_10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 100 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_COUNT_100'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 2 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_COUNT_2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 20 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_COUNT_20'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 5 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_COUNT_5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 50 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_COUNT_50'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of NON 1,2,5,10,20,100 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_COUNT_OTHER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of bill door opens', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'BILL_DOOR_OPEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of cabinet base door opens', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'CABINET_BASE_DOOR_OPEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of cabinet door opens', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'CABINET_DOOR_OPEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Count of Cancelled Credits', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'CANCELLED_CREDIT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of Cancelled Credits', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'CANCELLED_CREDIT_OUT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Casino Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'CASINO_MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of money available for play on the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'CREDIT_BALANCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'GRAND_METER_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of HandPay Vouchers dispensed from the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'HANDPAY_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of HandPay Vouchers printed and dispensed from the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'HANDPAY_OUT_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Jackpots hit on the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'JACKPOT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of Jackpots hit on the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'JACKPOT_OUT_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of logic door opens', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'LOGIC_DOOR_OPEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DGE Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Plays (L,W,J,F)', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'PLAY_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of power cycles', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'POWER_CYCLE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of Progressives won on the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'PROGRESSIVE_AWARDS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of Progressives on the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'PROGRESSIVE_CONTRIBUTIONS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Count of Progressives awarded', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'PROGRESSIVE_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of Promotional Coupons', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'PROMO_IN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Promotional Coupons inserted in machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'PROMO_IN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of Vouchers accepted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'TICKET_IN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Vouchers inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'TICKET_IN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of Vouchers printed and dispenses from the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'TICKET_OUT_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Vouchers dispensed from the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'TICKET_OUT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of money won from the Machine', 'SCHEMA', N'dbo', 'TABLE', N'GRAND_METER', 'COLUMN', N'TOTAL_PRIZES'
GO
