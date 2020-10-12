CREATE TABLE [dbo].[EventCode]
(
[EventCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventDescription] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventCode] ADD CONSTRAINT [PK_EventCode] PRIMARY KEY NONCLUSTERED  ([EventCode]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table for EventLog entries', 'SCHEMA', N'dbo', 'TABLE', N'EventCode', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique 2 character code, all Casino events (EventLog table entries) must have a lookup code value', 'SCHEMA', N'dbo', 'TABLE', N'EventCode', 'COLUMN', N'EventCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of the Event', 'SCHEMA', N'dbo', 'TABLE', N'EventCode', 'COLUMN', N'EventDescription'
GO
