CREATE TABLE [dbo].[DEAL_STATS]
(
[DEAL_NO] [int] NOT NULL,
[PLAY_COUNT] [int] NOT NULL CONSTRAINT [DF_DEAL_STATS_PLAY_COUNT] DEFAULT ((0)),
[WIN_COUNT] [int] NOT NULL CONSTRAINT [DF_DEAL_STATS_WIN_COUNT] DEFAULT ((0)),
[LOSS_COUNT] [int] NOT NULL CONSTRAINT [DF_DEAL_STATS_LOSE_COUNT] DEFAULT ((0)),
[FORFEIT_COUNT] [int] NOT NULL CONSTRAINT [DF_DEAL_STATS_FORFEIT_COUNT] DEFAULT ((0)),
[JACKPOT_COUNT] [int] NOT NULL CONSTRAINT [DF_DEAL_STATS_JACKPOT_COUNT] DEFAULT ((0)),
[AMOUNT_PLAYED] [money] NOT NULL CONSTRAINT [DF_DEAL_STATS_AMOUNT_PLAYED] DEFAULT ((0)),
[TOTAL_WIN_AMOUNT] [money] NOT NULL CONSTRAINT [DF_DEAL_STATS_AMOUNT_PAID] DEFAULT ((0)),
[BASE_AMOUNT_WON] [money] NOT NULL CONSTRAINT [DF_DEAL_STATS_AMOUNT_WON] DEFAULT ((0)),
[PROG_AMOUNT_WON] [money] NOT NULL CONSTRAINT [DF_DEAL_STATS_PROG_AMOUNT_WON] DEFAULT ((0)),
[AMOUNT_FORFEITED] [money] NOT NULL CONSTRAINT [DF_DEAL_STATS_AMOUNT_FORFEITED] DEFAULT ((0)),
[PROG_CONTRIBUTION] [money] NOT NULL CONSTRAINT [DF_DEAL_STATS_PROG_CONTRIBUTION] DEFAULT ((0)),
[FIRST_PLAY] [datetime] NULL,
[LAST_PLAY] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DEAL_STATS] ADD CONSTRAINT [PK_DEAL_STATS] PRIMARY KEY CLUSTERED  ([DEAL_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DEAL_STATS] WITH NOCHECK ADD CONSTRAINT [FK_DEAL_STATS_DEAL_SETUP] FOREIGN KEY ([DEAL_NO]) REFERENCES [dbo].[DEAL_SETUP] ([DEAL_NO])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores summarized Deal statisics', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of forfeited tabs', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'AMOUNT_FORFEITED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount in dollars played for this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'AMOUNT_PLAYED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of all Claimed winning tabs', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'BASE_AMOUNT_WON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number being tracked', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time of first play for this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'FIRST_PLAY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Tabs forfeited (F Transactions)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'FORFEIT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Jackpot Tabs dispensed (J Transactions)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'JACKPOT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time of last play for this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'LAST_PLAY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Losing tabs played (L Transactions)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'LOSS_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Tabs played (L,W,J,F Transactions)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'PLAY_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Progressive Amount Won (does not include base Jackpot amount)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'PROG_AMOUNT_WON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total contributed to Progressive pools by this deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'PROG_CONTRIBUTION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of all winning Tabs (including Forfeits)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'TOTAL_WIN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of winning tabs dispensed (W Transactions)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_STATS', 'COLUMN', N'WIN_COUNT'
GO
