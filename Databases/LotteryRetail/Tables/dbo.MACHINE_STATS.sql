CREATE TABLE [dbo].[MACHINE_STATS]
(
[MACHINE_STATS_ID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CASINO_MACH_NO] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACCT_DATE] [datetime] NOT NULL,
[DEAL_NO] [int] NOT NULL,
[GAME_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LOCATION_ID] [int] NOT NULL,
[PLAY_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_PLAY_COUNT] DEFAULT ((0)),
[LOSS_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_LOSS_COUNT] DEFAULT ((0)),
[WIN_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_WIN_COUNT] DEFAULT ((0)),
[JACKPOT_COUNT] [smallint] NOT NULL CONSTRAINT [DF_MACHINE_STATS_JACKPOT_COUNT] DEFAULT ((0)),
[FORFEIT_COUNT] [smallint] NOT NULL CONSTRAINT [DF_MACHINE_STATS_FORFEIT_COUNT] DEFAULT ((0)),
[TICKET_IN_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_TICKET_IN_COUNT] DEFAULT ((0)),
[TICKET_OUT_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_TICKET_OUT_COUNT] DEFAULT ((0)),
[AMOUNT_IN] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_AMOUNT_IN] DEFAULT ((0)),
[AMOUNT_PLAYED] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_AMOUNT_PLAYED] DEFAULT ((0)),
[AMOUNT_LOST] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_AMOUNT_WON1] DEFAULT ((0)),
[AMOUNT_WON] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_AMOUNT_WON] DEFAULT ((0)),
[AMOUNT_JACKPOT] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_AMOUNT_JACKPOT] DEFAULT ((0)),
[AMOUNT_FORFEITED] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_AMOUNT_FORFEITED] DEFAULT ((0)),
[AMOUNT_PROG] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_AMOUNT_PROG] DEFAULT ((0)),
[TICKET_IN_AMOUNT] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_TICKET_IN_COUNT1] DEFAULT ((0)),
[TICKET_OUT_AMOUNT] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_TICKET_OUT_COUNT1] DEFAULT ((0)),
[PROG_CONTRIBUTION] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_PROG_CONTRIBUTION] DEFAULT ((0)),
[BILL_COUNT_1] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_BILL_COUNT_1] DEFAULT ((0)),
[BILL_COUNT_2] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_BILL_COUNT_11] DEFAULT ((0)),
[BILL_COUNT_5] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_BILL_COUNT_21] DEFAULT ((0)),
[BILL_COUNT_10] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_BILL_COUNT_51] DEFAULT ((0)),
[BILL_COUNT_20] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_BILL_COUNT_101] DEFAULT ((0)),
[BILL_COUNT_50] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_BILL_COUNT_201] DEFAULT ((0)),
[BILL_COUNT_100] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_BILL_COUNT_501] DEFAULT ((0)),
[BILL_COUNT_OTHER] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_BILL_COUNT_1001] DEFAULT ((0)),
[PROMO_IN_AMOUNT] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_PROMO_IN] DEFAULT ((0)),
[PROMO_IN_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_PROMO_IN_COUNT] DEFAULT ((0)),
[EFT_IN_AMOUNT] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_EFT_IN_AMOUNT] DEFAULT ((0)),
[EFT_IN_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_EFT_IN_COUNT] DEFAULT ((0)),
[EFT_OUT_AMOUNT] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_EFT_OUT_AMOUNT] DEFAULT ((0)),
[EFT_OUT_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_EFT_OUT_COUNT] DEFAULT ((0)),
[EFT_PROMO_IN_AMOUNT] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_EFT_PROMO_IN_AMOUNT] DEFAULT ((0)),
[EFT_PROMO_IN_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_EFT_PROMO_IN_COUNT] DEFAULT ((0)),
[EFT_PROMO_OUT_AMOUNT] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_EFT_PROMO_OUT_AMOUNT] DEFAULT ((0)),
[EFT_PROMO_OUT_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_STATS_EFT_PROMO_OUT_COUNT] DEFAULT ((0)),
[MAIN_DOOR_OPEN_COUNT] [smallint] NOT NULL CONSTRAINT [DF_MACHINE_STATS_MAIN_DOOR_OPEN_COUNT] DEFAULT ((0)),
[CASH_DOOR_OPEN_COUNT] [smallint] NOT NULL CONSTRAINT [DF_MACHINE_STATS_CASH_DOOR_OPEN_COUNT] DEFAULT ((0)),
[LOGIC_DOOR_OPEN_COUNT] [smallint] NOT NULL CONSTRAINT [DF_MACHINE_STATS_LOGIC_DOOR_OPEN_COUNT] DEFAULT ((0)),
[BASE_DOOR_OPEN_COUNT] [smallint] NOT NULL CONSTRAINT [DF_MACHINE_STATS_BASE_DOOR_OPEN_COUNT] DEFAULT ((0)),
[AMOUNT_PLAYED_PROMO] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_AMOUNT_PLAYED_PROMO] DEFAULT ((0)),
[AMOUNT_WON_PROMO] [money] NOT NULL CONSTRAINT [DF_MACHINE_STATS_AMOUNT_WON_PROMO] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MACHINE_STATS] ADD CONSTRAINT [PK_MACHINE_STATS] PRIMARY KEY CLUSTERED  ([MACHINE_STATS_ID], [LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MACHINE_STATS] ADD CONSTRAINT [IX_MACHINE_STATS] UNIQUE NONCLUSTERED  ([MACH_NO], [CASINO_MACH_NO], [ACCT_DATE], [DEAL_NO], [GAME_CODE], [LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores summarized play and monetary data by EGM and Accounting Date.', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Date', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'ACCT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total dollars Forfeited (F)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'AMOUNT_FORFEITED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total dollars deposited (M)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'AMOUNT_IN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Jackpot dollars won (J)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'AMOUNT_JACKPOT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total loss dollars (L)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'AMOUNT_LOST'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount Played in dollars (L,W,F,J)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'AMOUNT_PLAYED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount Played in dollars (L,W,F,J) when playing with promotional creadits', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'AMOUNT_PLAYED_PROMO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Progressive dollars won', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'AMOUNT_PROG'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total normal win dollars won (W)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'AMOUNT_WON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total normal win dollars won (W) when playing with promotional credits.', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'AMOUNT_WON_PROMO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Base Door Open events', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'BASE_DOOR_OPEN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 1 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'BILL_COUNT_1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 10 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'BILL_COUNT_10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 100 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'BILL_COUNT_100'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 2 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'BILL_COUNT_2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 20 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'BILL_COUNT_20'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 5 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'BILL_COUNT_5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of 50 Dollar bills inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'BILL_COUNT_50'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of bills inserted into the Machine that are not 1, 5, 10, 20, 50, or 100 dollar bills', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'BILL_COUNT_OTHER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Cash Door Open events', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'CASH_DOOR_OPEN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Casino Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'CASINO_MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Electronic Funds Transfer Host to Machine amount', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'EFT_IN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Electronic Funds Transfer Host to Machine count', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'EFT_IN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Electronic Funds Transfer Machine to Host amount', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'EFT_OUT_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Electronic Funds Transfer Machine to Host Count', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'EFT_OUT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Electronic Funds Transfer Host to Machine Promo Amount', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'EFT_PROMO_IN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Electronic Funds Transfer Host to Machine Promo Count', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'EFT_PROMO_IN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Electronic Funds Transfer Machine to Host Promo Amount', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'EFT_PROMO_OUT_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Electronic Funds Transfer Machine to Host Promo Count', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'EFT_PROMO_OUT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Forfeit Plays (F)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'FORFEIT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Code', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'GAME_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Jackpot Plays (J)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'JACKPOT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location ID', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Logic Door Open events', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'LOGIC_DOOR_OPEN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Loss Plays (L)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'LOSS_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'MACHINE_STATS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Main Door Open events', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'MAIN_DOOR_OPEN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Plays (L,W,J,F)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'PLAY_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Progressive contribution amount', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'PROG_CONTRIBUTION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total promotional dollars deposited', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'PROMO_IN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of promotional vouchers (eCoupons) inserted', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'PROMO_IN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of Vouchers accepted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'TICKET_IN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Vouchers inserted into the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'TICKET_IN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount in dollars of Vouchers printed and dispenses from the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'TICKET_OUT_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Vouchers dispensed from the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'TICKET_OUT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Wins (W)', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_STATS', 'COLUMN', N'WIN_COUNT'
GO
