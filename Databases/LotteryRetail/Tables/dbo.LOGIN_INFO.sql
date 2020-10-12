CREATE TABLE [dbo].[LOGIN_INFO]
(
[LOGIN_INFO_ID] [int] NOT NULL IDENTITY(1, 1),
[ACCOUNTID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LOGIN_TIME] [datetime] NOT NULL CONSTRAINT [DF_LOGIN_INFO_LOGIN_TIME] DEFAULT (getdate()),
[WORK_STATION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LOGIN_EVENT_ID] [smallint] NOT NULL CONSTRAINT [DF_LOGIN_INFO_Success] DEFAULT ((0)),
[COMMENTS] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LOGIN_INFO] ADD CONSTRAINT [PK_LOGIN_INFO] PRIMARY KEY CLUSTERED  ([LOGIN_INFO_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Login audit table.', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_INFO', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Login Account ID (User ID)', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_INFO', 'COLUMN', N'ACCOUNTID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Comments such as why login failed', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_INFO', 'COLUMN', N'COMMENTS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to LOGIN_EVENT table to describe the login attempt result', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_INFO', 'COLUMN', N'LOGIN_EVENT_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_INFO', 'COLUMN', N'LOGIN_INFO_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and Time of login attempt', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_INFO', 'COLUMN', N'LOGIN_TIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Work station from which login was attempted', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_INFO', 'COLUMN', N'WORK_STATION'
GO
