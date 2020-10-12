CREATE TABLE [dbo].[INVOICE_HISTORY]
(
[INVOICE_NO] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RANGE_DATE_FROM] [datetime] NOT NULL,
[RANGE_DATE_TO] [datetime] NOT NULL,
[PRINTED_DATE] [datetime] NULL CONSTRAINT [DF_INVOICE_HISTORY_PRINTED_DATE] DEFAULT (getdate()),
[REPRINTED_DATE] [datetime] NULL,
[PRINTED_BY] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REPRINTED_BY] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INVOICE_HISTORY] ADD CONSTRAINT [PK_INVOICE_HISTORY_1] PRIMARY KEY CLUSTERED  ([INVOICE_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores invoice history.', 'SCHEMA', N'dbo', 'TABLE', N'INVOICE_HISTORY', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice Number', 'SCHEMA', N'dbo', 'TABLE', N'INVOICE_HISTORY', 'COLUMN', N'INVOICE_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that first created the invoice', 'SCHEMA', N'dbo', 'TABLE', N'INVOICE_HISTORY', 'COLUMN', N'PRINTED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time invoice was first printed', 'SCHEMA', N'dbo', 'TABLE', N'INVOICE_HISTORY', 'COLUMN', N'PRINTED_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Range start date', 'SCHEMA', N'dbo', 'TABLE', N'INVOICE_HISTORY', 'COLUMN', N'RANGE_DATE_FROM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Range end date', 'SCHEMA', N'dbo', 'TABLE', N'INVOICE_HISTORY', 'COLUMN', N'RANGE_DATE_TO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that last printed the invoice', 'SCHEMA', N'dbo', 'TABLE', N'INVOICE_HISTORY', 'COLUMN', N'REPRINTED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time invoice was last reprinted', 'SCHEMA', N'dbo', 'TABLE', N'INVOICE_HISTORY', 'COLUMN', N'REPRINTED_DATE'
GO
