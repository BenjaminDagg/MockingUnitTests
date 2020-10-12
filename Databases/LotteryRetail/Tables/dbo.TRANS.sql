CREATE TABLE [dbo].[TRANS]
(
[TRANS_ID] [smallint] NOT NULL,
[TRANS_CATEGORY_ID] [smallint] NOT NULL,
[SHORT_NAME] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LONG_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[REPORT_TEXT] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TRANS] ADD CONSTRAINT [PK_TRANS] PRIMARY KEY CLUSTERED  ([TRANS_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table of transaction values. Links to CASINO_TRANS.TRANS_ID.', 'SCHEMA', N'dbo', 'TABLE', N'TRANS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Long Name', 'SCHEMA', N'dbo', 'TABLE', N'TRANS', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction description that appears on reports', 'SCHEMA', N'dbo', 'TABLE', N'TRANS', 'COLUMN', N'REPORT_TEXT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Short Name, text used to communicate between tp and machines', 'SCHEMA', N'dbo', 'TABLE', N'TRANS', 'COLUMN', N'SHORT_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Associates this Transaction Type with a Transaction Category', 'SCHEMA', N'dbo', 'TABLE', N'TRANS', 'COLUMN', N'TRANS_CATEGORY_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Uniquely identifies the Transaction Type', 'SCHEMA', N'dbo', 'TABLE', N'TRANS', 'COLUMN', N'TRANS_ID'
GO
