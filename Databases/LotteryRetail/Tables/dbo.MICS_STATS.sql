CREATE TABLE [dbo].[MICS_STATS]
(
[MICS_STATS_ID] [int] NOT NULL IDENTITY(1, 1),
[DEAL_NO] [int] NOT NULL,
[WIN_AMOUNT] [money] NOT NULL CONSTRAINT [DF_MICS_STATS_WIN_AMOUNT] DEFAULT ((0)),
[WIN_COUNT] [int] NOT NULL CONSTRAINT [DF_MICS_STATS_WIN_COUNT] DEFAULT ((0)),
[PROG_AMOUNT] [money] NOT NULL CONSTRAINT [DF_MICS_STATS_PROG_AMOUNT] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MICS_STATS] ADD CONSTRAINT [PK_MICS_STATS] PRIMARY KEY CLUSTERED  ([MICS_STATS_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_MICS_STATS_DEAL_NO_TIER_AMOUNT] ON [dbo].[MICS_STATS] ([DEAL_NO], [WIN_AMOUNT]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores data by Deal and Win amount for the MICS report.', 'SCHEMA', N'dbo', 'TABLE', N'MICS_STATS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number', 'SCHEMA', N'dbo', 'TABLE', N'MICS_STATS', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'MICS_STATS', 'COLUMN', N'MICS_STATS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Progressive Amount', 'SCHEMA', N'dbo', 'TABLE', N'MICS_STATS', 'COLUMN', N'PROG_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Win Amount (usually represents a tier)', 'SCHEMA', N'dbo', 'TABLE', N'MICS_STATS', 'COLUMN', N'WIN_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of wins', 'SCHEMA', N'dbo', 'TABLE', N'MICS_STATS', 'COLUMN', N'WIN_COUNT'
GO
