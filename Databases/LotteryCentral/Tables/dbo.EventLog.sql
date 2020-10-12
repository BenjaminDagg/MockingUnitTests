CREATE TABLE [dbo].[EventLog]
(
[EventLogId] [int] NOT NULL IDENTITY(1, 1),
[PartionKey] [int] NOT NULL CONSTRAINT [DF_EventLog_PartionKey] DEFAULT (CONVERT([int],CONVERT([float],getdate(),(0)),(0))),
[EventDate] [datetime] NOT NULL,
[EventTypeId] [int] NOT NULL,
[Description] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Details] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventSource] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserId] [int] NULL,
[LocationID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventLog] ADD CONSTRAINT [PK_EventLog] PRIMARY KEY CLUSTERED  ([EventLogId], [PartionKey]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
