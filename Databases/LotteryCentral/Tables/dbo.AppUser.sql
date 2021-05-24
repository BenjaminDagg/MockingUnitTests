CREATE TABLE [dbo].[AppUser]
(
[AppUserId] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_AppUser_Email] DEFAULT (''),
[FirstName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MiddleInitial] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_AppUser_MiddleInitial] DEFAULT (''),
[Password] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsLocked] [bit] NOT NULL,
[IsActive] [bit] NOT NULL,
[IsPasswordChangeRequired] [bit] NOT NULL,
[FailedPasswordAttemptCount] [int] NOT NULL,
[LastPasswordChangeDate] [datetime] NOT NULL,
[LastActivityDate] [datetime] NULL,
[LastFailedPasswordAttemptDate] [datetime] NULL,
[LastLoginDate] [datetime] NULL,
[LastLoginIpAddress] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUser] ADD CONSTRAINT [PK_AppUser] PRIMARY KEY CLUSTERED  ([AppUserId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the users information for the app.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Id, used to assign AppUser to AppRoles', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'AppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The email address for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The current number of failed password attempts for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'FailedPasswordAttemptCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The first name for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The currently active flag for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'IsActive'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The lock out flag for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'IsLocked'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The needs passwords changed flag for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'IsPasswordChangeRequired'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time of the last activity for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'LastActivityDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time of the last failed password attempt for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'LastFailedPasswordAttemptDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time of the last login date for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'LastLoginDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The last login ip address of the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'LastLoginIpAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The last name for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the latest password was updated for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'LastPasswordChangeDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The middle initial for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'MiddleInitial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The current password for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'Password'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The login username for the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppUser', 'COLUMN', N'UserName'
GO
