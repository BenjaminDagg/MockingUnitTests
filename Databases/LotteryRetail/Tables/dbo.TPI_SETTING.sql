CREATE TABLE [dbo].[TPI_SETTING]
(
[TPI_SETTING_ID] [int] NOT NULL IDENTITY(1, 1),
[TPI_ID] [int] NOT NULL,
[ITEM_KEY] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ITEM_SUBKEY] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEM_VALUE] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TPI_SETTING] ADD CONSTRAINT [PK_TPI_SETTING] PRIMARY KEY CLUSTERED  ([TPI_SETTING_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TPI_SETTING] WITH NOCHECK ADD CONSTRAINT [FK_TPI_SETTING_TPI] FOREIGN KEY ([TPI_ID]) REFERENCES [dbo].[TPI] ([TPI_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores TPI specific settings.', 'SCHEMA', N'dbo', 'TABLE', N'TPI_SETTING', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Key value used to retrieve item value', 'SCHEMA', N'dbo', 'TABLE', N'TPI_SETTING', 'COLUMN', N'ITEM_KEY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SubKey value used to retrieve item value', 'SCHEMA', N'dbo', 'TABLE', N'TPI_SETTING', 'COLUMN', N'ITEM_SUBKEY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Value associated with TPI_ID and ITEM_KEY', 'SCHEMA', N'dbo', 'TABLE', N'TPI_SETTING', 'COLUMN', N'ITEM_VALUE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Third Party Interface Identifier - Link to the TPI table', 'SCHEMA', N'dbo', 'TABLE', N'TPI_SETTING', 'COLUMN', N'TPI_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'TPI_SETTING', 'COLUMN', N'TPI_SETTING_ID'
GO
