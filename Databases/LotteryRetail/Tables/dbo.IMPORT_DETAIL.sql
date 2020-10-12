CREATE TABLE [dbo].[IMPORT_DETAIL]
(
[IMPORT_DETAIL_ID] [int] NOT NULL IDENTITY(1, 1),
[IMPORT_HISTORY_ID] [int] NOT NULL,
[TABLE_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DETAIL_TEXT] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INSERT_COUNT] [int] NOT NULL CONSTRAINT [DF_IMPORT_DETAIL_INSERT_COUNT] DEFAULT ((0)),
[UPDATE_COUNT] [int] NOT NULL CONSTRAINT [DF_IMPORT_DETAIL_UPDATE_COUNT] DEFAULT ((0)),
[IGNORED_COUNT] [int] NOT NULL CONSTRAINT [DF_IMPORT_DETAIL_IGNORED_COUNT] DEFAULT ((0)),
[ERROR_COUNT] [int] NOT NULL CONSTRAINT [DF_IMPORT_DETAIL_ERROR_COUNT] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IMPORT_DETAIL] ADD CONSTRAINT [PK_IMPORT_DETAIL] PRIMARY KEY CLUSTERED  ([IMPORT_DETAIL_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IMPORT_DETAIL] WITH NOCHECK ADD CONSTRAINT [FK_IMPORT_DETAIL_IMPORT_HISTORY] FOREIGN KEY ([IMPORT_HISTORY_ID]) REFERENCES [dbo].[IMPORT_HISTORY] ([IMPORT_HISTORY_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Deal Import detail history information, linked to IMPORT_HISTORY table.', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_DETAIL', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text message column', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_DETAIL', 'COLUMN', N'DETAIL_TEXT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of errors encountered while attempting to insert or update', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_DETAIL', 'COLUMN', N'ERROR_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of rows ignored (already exist)', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_DETAIL', 'COLUMN', N'IGNORED_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_DETAIL', 'COLUMN', N'IMPORT_DETAIL_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to the IMPORT_HISTORY table', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_DETAIL', 'COLUMN', N'IMPORT_HISTORY_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of rows inserted', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_DETAIL', 'COLUMN', N'INSERT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the table being updated', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_DETAIL', 'COLUMN', N'TABLE_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of rows updated', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_DETAIL', 'COLUMN', N'UPDATE_COUNT'
GO
