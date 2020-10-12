CREATE TABLE [dbo].[MACHINE_PLAY_STATS]
(
[MACHINE_PLAY_STATS_ID] [int] NOT NULL IDENTITY(1, 1),
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CASINO_MACH_NO] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEAL_NO] [int] NOT NULL,
[GAME_CODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LOCATION_ID] [int] NOT NULL,
[DENOM] [smallmoney] NOT NULL,
[COINS_BET] [smallint] NOT NULL,
[LINES_BET] [tinyint] NOT NULL,
[PLAY_COUNT] [int] NOT NULL,
[AMOUNT_PLAYED] [money] NOT NULL,
[AMOUNT_WON] [money] NOT NULL,
[ACCT_MONTH] [int] NOT NULL,
[ACCT_YEAR] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MACHINE_PLAY_STATS] ADD CONSTRAINT [PK_MACHINE_PLAY_STATS] PRIMARY KEY CLUSTERED  ([MACHINE_PLAY_STATS_ID], [LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MACHINE_PLAY_STATS_MACH_NO_CASINO_MACH_NO_DEAL_NO_GAME_CODE_DENOM_COINS_BET_LINES_BET_ACCT_MONTH_ACCT_YEAR] ON [dbo].[MACHINE_PLAY_STATS] ([MACH_NO], [CASINO_MACH_NO], [DEAL_NO], [GAME_CODE], [DENOM], [COINS_BET], [LINES_BET], [ACCT_MONTH], [ACCT_YEAR]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores summarized play statistics by EGM by month and year.', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Month number', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'ACCT_MONTH'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Year number', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'ACCT_YEAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount played', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'AMOUNT_PLAYED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount won', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'AMOUNT_WON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Casino Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'CASINO_MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Coins Bet (per line and multiplied if Pressed Up).', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'COINS_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Denomination played', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'DENOM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Code', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'GAME_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Lines Bet', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'LINES_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DGE Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'MACHINE_PLAY_STATS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of plays for this summary record', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_PLAY_STATS', 'COLUMN', N'PLAY_COUNT'
GO
