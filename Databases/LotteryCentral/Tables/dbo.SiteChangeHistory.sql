CREATE TABLE [dbo].[SiteChangeHistory]
(
[SiteChangeHistoryId] [int] NOT NULL IDENTITY(1, 1),
[SiteId] [int] NOT NULL,
[SiteChildId] [int] NOT NULL,
[SiteChangeType] [int] NOT NULL,
[ChangeTable] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeColumn] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL,
[IpAddress] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SiteChangeHistory] ADD CONSTRAINT [PK_SiteChangeHistory] PRIMARY KEY CLUSTERED  ([SiteChangeHistoryId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the Site Agent activity.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent child table column that was changed.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'ChangeColumn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent child table that was changed.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'ChangeTable'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent new data value.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'ChangeValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ip address of the user that changed the Site Agent data.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'IpAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user that changed the Site Agent data.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the Site Agent data was changed.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent value that was changed.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'PreviousValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'SiteChangeHistoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent history change type.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'SiteChangeType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent child table this change is for.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'SiteChildId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent identity the change type is for.', 'SCHEMA', N'dbo', 'TABLE', N'SiteChangeHistory', 'COLUMN', N'SiteId'
GO
