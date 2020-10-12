CREATE TABLE [dbo].[ARCHIVE_STATS]
(
[ARCHIVE_STATS_ID] [int] NOT NULL IDENTITY(1, 1),
[TABLE_NAME] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ARCHIVE_DATE] [datetime] NOT NULL CONSTRAINT [DF_ARCHIVE_STATS_ARCHIVE_DATE] DEFAULT (getdate()),
[ID_START] [int] NOT NULL CONSTRAINT [DF_ARCHIVE_STATS_ID_START] DEFAULT ((0)),
[ID_END] [int] NOT NULL CONSTRAINT [DF_ARCHIVE_STATS_ID_END] DEFAULT ((0)),
[ROW_COUNT] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARCHIVE_STATS] ADD CONSTRAINT [PK_ARCHIVE_STATS] PRIMARY KEY CLUSTERED  ([ARCHIVE_STATS_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Data Archival information', 'SCHEMA', N'dbo', 'TABLE', N'ARCHIVE_STATS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date data was archived from this table', 'SCHEMA', N'dbo', 'TABLE', N'ARCHIVE_STATS', 'COLUMN', N'ARCHIVE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'ARCHIVE_STATS', 'COLUMN', N'ARCHIVE_STATS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ending Row identifier value', 'SCHEMA', N'dbo', 'TABLE', N'ARCHIVE_STATS', 'COLUMN', N'ID_END'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Beginning Row identifier value', 'SCHEMA', N'dbo', 'TABLE', N'ARCHIVE_STATS', 'COLUMN', N'ID_START'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of rows retrieved', 'SCHEMA', N'dbo', 'TABLE', N'ARCHIVE_STATS', 'COLUMN', N'ROW_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table Name', 'SCHEMA', N'dbo', 'TABLE', N'ARCHIVE_STATS', 'COLUMN', N'TABLE_NAME'
GO
