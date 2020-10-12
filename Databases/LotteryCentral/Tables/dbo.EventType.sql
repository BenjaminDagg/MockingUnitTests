CREATE TABLE [dbo].[EventType]
(
[EventTypeId] [int] NOT NULL,
[EventName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventType] ADD CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED  ([EventTypeId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
