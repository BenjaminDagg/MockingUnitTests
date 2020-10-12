CREATE TABLE [dbo].[CheckChangeHistory]
(
[CheckChangeHistoryId] [int] NOT NULL IDENTITY(1, 1),
[ChangeType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CheckId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDetails] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChangeDate] [datetime] NOT NULL,
[ChangedByAppUserId] [int] NOT NULL,
[IpAddress] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CheckChangeHistory] ADD CONSTRAINT [PK_CheckChangeHistory] PRIMARY KEY CLUSTERED  ([CheckChangeHistoryId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the check activity.', 'SCHEMA', N'dbo', 'TABLE', N'CheckChangeHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the check was created/changed.', 'SCHEMA', N'dbo', 'TABLE', N'CheckChangeHistory', 'COLUMN', N'ChangeDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user that changed/created the check.', 'SCHEMA', N'dbo', 'TABLE', N'CheckChangeHistory', 'COLUMN', N'ChangedByAppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The details of the check change activity.', 'SCHEMA', N'dbo', 'TABLE', N'CheckChangeHistory', 'COLUMN', N'ChangeDetails'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The change type for the check history activity.', 'SCHEMA', N'dbo', 'TABLE', N'CheckChangeHistory', 'COLUMN', N'ChangeType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'CheckChangeHistory', 'COLUMN', N'CheckChangeHistoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id for the check that was changed/created.', 'SCHEMA', N'dbo', 'TABLE', N'CheckChangeHistory', 'COLUMN', N'CheckId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ip address of the user that created/changed the check.', 'SCHEMA', N'dbo', 'TABLE', N'CheckChangeHistory', 'COLUMN', N'IpAddress'
GO
