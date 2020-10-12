CREATE TABLE [dbo].[TAB_ERROR]
(
[TAB_ERROR_ID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ERROR_NO] [int] NOT NULL CONSTRAINT [DF_TAB_ERROR_ERROR_NO] DEFAULT ((0)),
[EVENT_TIME] [datetime] NOT NULL CONSTRAINT [DF_TAB_ERROR_EVENT_TIME] DEFAULT (getdate()),
[LOCATION_ID] [int] NOT NULL CONSTRAINT [DF_TAB_ERROR_LOCATION_ID] DEFAULT ((1)),
[TICKET_NO] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TAB_ERROR] ADD CONSTRAINT [PK_TAB_ERROR] PRIMARY KEY CLUSTERED  ([TAB_ERROR_ID], [LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores tab error occurrances.', 'SCHEMA', N'dbo', 'TABLE', N'TAB_ERROR', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to ERROR_LOOKUP table', 'SCHEMA', N'dbo', 'TABLE', N'TAB_ERROR', 'COLUMN', N'ERROR_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time tab error occurred', 'SCHEMA', N'dbo', 'TABLE', N'TAB_ERROR', 'COLUMN', N'EVENT_TIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location identifier', 'SCHEMA', N'dbo', 'TABLE', N'TAB_ERROR', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine identifier', 'SCHEMA', N'dbo', 'TABLE', N'TAB_ERROR', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'TAB_ERROR', 'COLUMN', N'TAB_ERROR_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ticket number', 'SCHEMA', N'dbo', 'TABLE', N'TAB_ERROR', 'COLUMN', N'TICKET_NO'
GO
