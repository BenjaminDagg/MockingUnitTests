CREATE TABLE [dbo].[EventLog]
(
[EventLogId] [int] NOT NULL IDENTITY(1, 1),
[PartionKey] [int] NOT NULL CONSTRAINT [DF_EventLog_PartionKey] DEFAULT (CONVERT([int],replace(CONVERT([char](10),getdate(),(101)),'/',''),(0))),
[EventDate] [datetime] NOT NULL CONSTRAINT [DF_EventLog_EventDate] DEFAULT (getdate()),
[EventTypeId] [int] NOT NULL,
[EventSource] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventSourceVersion] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_EventLog_EventSourceVersion] DEFAULT (''),
[DeviceName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Message] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Details] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserId] [int] NULL,
[CentralUserId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventLog] ADD CONSTRAINT [PK_EventLog] PRIMARY KEY CLUSTERED  ([EventLogId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventLog] ADD CONSTRAINT [FK_EventLog_EventType] FOREIGN KEY ([EventTypeId]) REFERENCES [dbo].[EventType] ([EventTypeId])
GO
