CREATE TABLE [dbo].[LOGIN_EVENT]
(
[LOGIN_EVENT_ID] [smallint] NOT NULL,
[EVENT_DESC] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LOGIN_EVENT] ADD CONSTRAINT [PK_LOGIN_EVENT] PRIMARY KEY CLUSTERED  ([LOGIN_EVENT_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table for Login event types. Links to LOGIN_INFO table.', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_EVENT', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Login event description', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_EVENT', 'COLUMN', N'EVENT_DESC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Login event identifier', 'SCHEMA', N'dbo', 'TABLE', N'LOGIN_EVENT', 'COLUMN', N'LOGIN_EVENT_ID'
GO
