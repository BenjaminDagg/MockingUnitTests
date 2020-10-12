CREATE TABLE [dbo].[SiteChangeType]
(
[SiteChangeTypeId] [int] NOT NULL IDENTITY(1, 1),
[SiteChangeTypeName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SiteChangeType] ADD CONSTRAINT [PK_SiteChangeType] PRIMARY KEY CLUSTERED  ([SiteChangeTypeId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the Site Agent change type for the history table.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent change type description for the history table.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeType', 'COLUMN', N'SiteChangeTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent change type for the history table.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeType', 'COLUMN', N'SiteChangeTypeName'
GO
