CREATE TABLE [dbo].[APP_EVENT_TYPE]
(
[APP_EVENT_TYPE] [smallint] NOT NULL,
[EVENT_DESC] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_EVENT_TYPE] ADD CONSTRAINT [PK_APP_EVENT_TYPE] PRIMARY KEY CLUSTERED  ([APP_EVENT_TYPE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores application event descriptions related to the APP_EVENT_LOG table.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_TYPE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Event Identifier column of the table.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_TYPE', 'COLUMN', N'APP_EVENT_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Event Description.', 'SCHEMA', N'dbo', 'TABLE', N'APP_EVENT_TYPE', 'COLUMN', N'EVENT_DESC'
GO
