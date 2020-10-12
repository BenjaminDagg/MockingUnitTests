CREATE TABLE [dbo].[TRANS_CATEGORY]
(
[TRANS_CATEGORY_ID] [smallint] NOT NULL IDENTITY(1, 1),
[SHORT_NAME] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LONG_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TRANS_CATEGORY] ADD CONSTRAINT [PK_TRANS_CATEGORY] PRIMARY KEY CLUSTERED  ([TRANS_CATEGORY_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction Categories links to TRANS table.', 'SCHEMA', N'dbo', 'TABLE', N'TRANS_CATEGORY', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'A long name for this transaction category', 'SCHEMA', N'dbo', 'TABLE', N'TRANS_CATEGORY', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A short 8 character name for this category', 'SCHEMA', N'dbo', 'TABLE', N'TRANS_CATEGORY', 'COLUMN', N'SHORT_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK, value uniquely identifies a Transaction Category', 'SCHEMA', N'dbo', 'TABLE', N'TRANS_CATEGORY', 'COLUMN', N'TRANS_CATEGORY_ID'
GO
