CREATE TABLE [dbo].[APP_EVENT_LOG]
(
[APP_EVENT_ID] [int] NOT NULL IDENTITY(1, 1),
[ACCOUNTID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EVENT_TIME] [datetime] NOT NULL CONSTRAINT [DF_APP_EVENT_LOG_EVENT_TIME] DEFAULT (getdate()),
[EVENT_SOURCE] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WORK_STATION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[APP_EVENT_TYPE] [smallint] NOT NULL,
[DESCRIPTION] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_EVENT_LOG] ADD CONSTRAINT [PK_APP_EVENT_LOG] PRIMARY KEY CLUSTERED  ([APP_EVENT_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores application security changes and reporting events.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_LOG', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account ID of the user who caused the event.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_LOG', 'COLUMN', N'ACCOUNTID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_LOG', 'COLUMN', N'APP_EVENT_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of the event from APP_EVENT_TYPE table.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_LOG', 'COLUMN', N'APP_EVENT_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of the event that occured.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_LOG', 'COLUMN', N'DESCRIPTION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The application name that the event occured in.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_LOG', 'COLUMN', N'EVENT_SOURCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time of the event.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_LOG', 'COLUMN', N'EVENT_TIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the workstation.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_LOG', 'COLUMN', N'WORK_STATION'
GO
