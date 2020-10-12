CREATE TABLE [dbo].[CheckQueue]
(
[CheckQueueId] [int] NOT NULL IDENTITY(1, 1),
[CentralSiteId] [int] NOT NULL,
[NextCheckNumber] [int] NOT NULL,
[LastUpdateDate] [datetime] NULL,
[LastUpdateAppUserId] [int] NULL,
[LastSyncDate] [datetime] NULL,
[LastSyncAppUserId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CheckQueue] ADD CONSTRAINT [PK_CheckQueue] PRIMARY KEY CLUSTERED  ([CheckQueueId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the central site data.', 'SCHEMA', N'dbo', 'TABLE', N'CheckQueue', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the central site this check queue is for.', 'SCHEMA', N'dbo', 'TABLE', N'CheckQueue', 'COLUMN', N'CentralSiteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'CheckQueue', 'COLUMN', N'CheckQueueId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user that synced the check queue last.', 'SCHEMA', N'dbo', 'TABLE', N'CheckQueue', 'COLUMN', N'LastSyncAppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the check queue was synced.', 'SCHEMA', N'dbo', 'TABLE', N'CheckQueue', 'COLUMN', N'LastSyncDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The last user that updated the check queue.', 'SCHEMA', N'dbo', 'TABLE', N'CheckQueue', 'COLUMN', N'LastUpdateAppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the central site check queue was updated.', 'SCHEMA', N'dbo', 'TABLE', N'CheckQueue', 'COLUMN', N'LastUpdateDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The next check number for this central site to be processed.', 'SCHEMA', N'dbo', 'TABLE', N'CheckQueue', 'COLUMN', N'NextCheckNumber'
GO
