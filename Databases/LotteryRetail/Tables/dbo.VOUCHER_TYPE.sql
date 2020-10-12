CREATE TABLE [dbo].[VOUCHER_TYPE]
(
[VOUCHER_TYPE_ID] [smallint] NOT NULL,
[LONG_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VOUCHER_TYPE] ADD CONSTRAINT [PK_VOUCHER_TYPE] PRIMARY KEY CLUSTERED  ([VOUCHER_TYPE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table of Voucher Types.', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_TYPE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Voucher Type description', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_TYPE', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Int - Voucher Type Identifier', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_TYPE', 'COLUMN', N'VOUCHER_TYPE_ID'
GO
