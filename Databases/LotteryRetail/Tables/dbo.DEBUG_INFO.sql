CREATE TABLE [dbo].[DEBUG_INFO]
(
[DEBUG_INFO_ID] [int] NOT NULL IDENTITY(1, 1),
[TRANS_ID] [smallint] NULL,
[TRANS_TYPE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEBUG_TEXT] [varchar] (3072) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INT_VALUE] [int] NOT NULL CONSTRAINT [DF_DEBUG_INFO_INT_VALUE] DEFAULT ((0)),
[CREATED_BY] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DEBUG_INFO_USER_NAME] DEFAULT (user_name()),
[CREATE_DATE] [datetime] NOT NULL CONSTRAINT [DF_DEBUG_INFO_CREATE_DATE] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DEBUG_INFO] ADD CONSTRAINT [PK_DEBUG_INFO] PRIMARY KEY CLUSTERED  ([DEBUG_INFO_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DEBUG_INFO_CREATE_DATE] ON [dbo].[DEBUG_INFO] ([CREATE_DATE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used during developement to store debug information.', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_INFO', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time row was inserted', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_INFO', 'COLUMN', N'CREATE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that created the row', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_INFO', 'COLUMN', N'CREATED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_INFO', 'COLUMN', N'DEBUG_INFO_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text message', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_INFO', 'COLUMN', N'DEBUG_TEXT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usually the machine number converted to an integer', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_INFO', 'COLUMN', N'INT_VALUE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to TRANS table, identifies the type of transaction', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_INFO', 'COLUMN', N'TRANS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction type code', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_INFO', 'COLUMN', N'TRANS_TYPE'
GO
