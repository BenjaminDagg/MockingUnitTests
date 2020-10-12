CREATE TABLE [dbo].[IMPORT_HISTORY]
(
[IMPORT_HISTORY_ID] [int] NOT NULL IDENTITY(1, 1),
[EXPORT_HISTORY_ID] [int] NOT NULL,
[IMPORTED_BY] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EXPORTED_BY] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IMPORT_DATE] [datetime] NOT NULL,
[EXPORT_DATE] [datetime] NOT NULL CONSTRAINT [DF_IMPORT_HISTORY_CREATED_DATE] DEFAULT (getdate()),
[CASINO_UPDATE] [bit] NOT NULL,
[GAME_UPDATE] [bit] NOT NULL,
[BANK_UPDATE] [bit] NOT NULL,
[FORM_UPDATE] [bit] NOT NULL,
[IS_GENERIC] [bit] NOT NULL CONSTRAINT [DF_IMPORT_HISTORY_IS_GENERIC] DEFAULT ((0)),
[SUCCESSFUL] [bit] NOT NULL CONSTRAINT [DF_IMPORT_HISTORY_SUCCESSFUL] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IMPORT_HISTORY] ADD CONSTRAINT [PK_IMPORT_HISTORY] PRIMARY KEY CLUSTERED  ([IMPORT_HISTORY_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Deal Import history information.', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if Bank data is to be imported', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'BANK_UPDATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if Casino data is to be imported', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'CASINO_UPDATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time Export was performed', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'EXPORT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to the ExportHistoryID row in the DealGen.ExportHistory table', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'EXPORT_HISTORY_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of person that performed the Export', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'EXPORTED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if Form data is to be imported', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'FORM_UPDATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if Game data is to be imported', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'GAME_UPDATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time Import performed', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'IMPORT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'IMPORT_HISTORY_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of person performing the Import', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'IMPORTED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if Deal is Casino specific or not - not used', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'IS_GENERIC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if the Import process terminated successfully', 'SCHEMA', N'dbo', 'TABLE', N'IMPORT_HISTORY', 'COLUMN', N'SUCCESSFUL'
GO
