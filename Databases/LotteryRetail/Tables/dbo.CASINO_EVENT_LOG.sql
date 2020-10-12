CREATE TABLE [dbo].[CASINO_EVENT_LOG]
(
[CASINO_EVENT_LOG_ID] [int] NOT NULL IDENTITY(1, 1),
[EVENT_CODE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EVENT_SOURCE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_DESC] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_DATE_TIME] [datetime] NOT NULL CONSTRAINT [DF_CASINO_EVENT_LOG_EVENT_DATE_TIME] DEFAULT (getdate()),
[ID_VALUE] [int] NULL,
[CREATED_BY] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ERROR_NO] [int] NOT NULL CONSTRAINT [DF_CASINO_EVENT_LOG_ERROR_NO] DEFAULT ((0)),
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CASINO_EVENT_LOG_MACH_NO] DEFAULT ('0')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASINO_EVENT_LOG] ADD CONSTRAINT [PK_CASINO_EVENT_LOG_ID] PRIMARY KEY NONCLUSTERED  ([CASINO_EVENT_LOG_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CASINO_EVENT_CODE] ON [dbo].[CASINO_EVENT_LOG] ([EVENT_CODE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CASINO_EVENT_DATE_TIME] ON [dbo].[CASINO_EVENT_LOG] ([EVENT_DATE_TIME]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASINO_EVENT_LOG] ADD CONSTRAINT [FK_CASINO_EVENT_LOG_CASINO_EVENT_CODE] FOREIGN KEY ([EVENT_CODE]) REFERENCES [dbo].[CASINO_EVENT_CODE] ([EVENT_CODE])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores events for the System Event audit report', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Indentity Int', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', 'COLUMN', N'CASINO_EVENT_LOG_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CASINO_USERS.ACCOUNTID that authorized payout override (PO transactions only)', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', 'COLUMN', N'CREATED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Error Number link to ERROR_LOOKUP', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', 'COLUMN', N'ERROR_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Event Code, link to CASINO_EVENT_CODE table, describes the event type', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', 'COLUMN', N'EVENT_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time this row was inserted', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', 'COLUMN', N'EVENT_DATE_TIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Detailed event information', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', 'COLUMN', N'EVENT_DESC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The application or stored procedure that generated the event', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', 'COLUMN', N'EVENT_SOURCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PO transactions only, links to CASINO_TRANS.TRANS_NO', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', 'COLUMN', N'ID_VALUE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Number related to the event', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_EVENT_LOG', 'COLUMN', N'MACH_NO'
GO
