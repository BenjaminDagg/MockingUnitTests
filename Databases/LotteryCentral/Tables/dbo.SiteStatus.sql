CREATE TABLE [dbo].[SiteStatus]
(
[SiteStatusId] [int] NOT NULL IDENTITY(1, 1),
[SiteId] [int] NOT NULL,
[StatusCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatusComment] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusChangeDate] [datetime] NOT NULL,
[LastModifiedByAppUserId] [int] NOT NULL,
[TerminationDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SiteStatus] ADD CONSTRAINT [PK_SiteTimeActionInfo] PRIMARY KEY CLUSTERED  ([SiteStatusId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the Site Agent status data.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatus', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the Site Status was last updated.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatus', 'COLUMN', N'LastModifiedByAppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the Site this Site Status belongs to.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatus', 'COLUMN', N'SiteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatus', 'COLUMN', N'SiteStatusId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date the status was last changed.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatus', 'COLUMN', N'StatusChangeDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The current status code for the Site.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatus', 'COLUMN', N'StatusCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The comment for the latest status change.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatus', 'COLUMN', N'StatusComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the Site was set to Terminated.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatus', 'COLUMN', N'TerminationDate'
GO
