CREATE TABLE [dbo].[CASINO_EVENT_CODE]
(
[EVENT_CODE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EVENT_DESC] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASINO_EVENT_CODE] ADD CONSTRAINT [PK_CASINO_EVENT_CODE] PRIMARY KEY NONCLUSTERED  ([EVENT_CODE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table for CASINO_EVENT_LOG entries', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_CODE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique 2 character code, all Casino events (CASINO_EVENT_LOG table entries) must have a lookup code value', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_CODE', 'COLUMN', N'EVENT_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of the Event', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_CODE', 'COLUMN', N'EVENT_DESC'
GO
