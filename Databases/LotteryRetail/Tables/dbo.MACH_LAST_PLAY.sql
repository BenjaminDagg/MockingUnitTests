CREATE TABLE [dbo].[MACH_LAST_PLAY]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MACH_NO] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEAL_NO] [int] NOT NULL,
[ROLL_NO] [smallint] NOT NULL,
[TICKET_NO] [int] NOT NULL,
[BARCODE_SCAN] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COINS_BET] [smallint] NOT NULL,
[LINES_BET] [tinyint] NOT NULL,
[ERROR_NO] [int] NOT NULL CONSTRAINT [DF_MACH_LAST_PLAY_ERROR_NO] DEFAULT ((0)),
[SEQUENCE_NO] [int] NOT NULL CONSTRAINT [DF_MACH_LAST_PLAY_SEQUENCE_NO] DEFAULT ((0)),
[BALANCE] [int] NOT NULL CONSTRAINT [DF_MACH_LAST_PLAY_BALANCE] DEFAULT ((0)),
[DTIMESTAMP] [datetime] NOT NULL CONSTRAINT [DF_MACH_LAST_PLAY_DTIMESTAMP] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MACH_LAST_PLAY] ADD CONSTRAINT [PK_MACH_LAST_PLAY] PRIMARY KEY CLUSTERED  ([ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MACH_LAST_PLAY_MACH_NO] ON [dbo].[MACH_LAST_PLAY] ([MACH_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores last transaction between EGM and TP by EGM.', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Balance', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'BALANCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Barcode', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'BARCODE_SCAN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of coins bet', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'COINS_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and Time', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'DTIMESTAMP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Error Number', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'ERROR_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of lines bet', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'LINES_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Roll Number', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'ROLL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence Number', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'SEQUENCE_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ticket Number', 'SCHEMA', N'dbo', 'TABLE', N'MACH_LAST_PLAY', 'COLUMN', N'TICKET_NO'
GO
