CREATE TABLE [dbo].[VOUCHER_TEMPLATE]
(
[VOUCHER_TEMPLATE_ID] [int] NOT NULL IDENTITY(1, 1),
[TPI_ID] [int] NOT NULL,
[ITEM_KEY] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ITEM_VALUE] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VOUCHER_TEMPLATE] ADD CONSTRAINT [PK_VOUCHER_TEMPLATE] PRIMARY KEY CLUSTERED  ([VOUCHER_TEMPLATE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores voucher templates used by the TP to send data to EGMs for voucher printing.', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_TEMPLATE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Key value used to retrieve item value', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_TEMPLATE', 'COLUMN', N'ITEM_KEY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Value associated with TPI_ID and ITEM_KEY', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_TEMPLATE', 'COLUMN', N'ITEM_VALUE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Third Party Interface Identifier - Link to the TPI table', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_TEMPLATE', 'COLUMN', N'TPI_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_TEMPLATE', 'COLUMN', N'VOUCHER_TEMPLATE_ID'
GO
