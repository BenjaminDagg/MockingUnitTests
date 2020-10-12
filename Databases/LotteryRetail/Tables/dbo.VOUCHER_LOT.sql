CREATE TABLE [dbo].[VOUCHER_LOT]
(
[VOUCHER_LOT_ID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LOCATION_ID] [int] NOT NULL,
[LOT_NUMBER] [char] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DATE_RECEIVED] [datetime] NOT NULL CONSTRAINT [DF_VOUCHER_LOT_RECEIVED_DATE] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VOUCHER_LOT] ADD CONSTRAINT [PK_VOUCHER_LOT_1] PRIMARY KEY CLUSTERED  ([VOUCHER_LOT_ID], [LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores scanned Voucher Lot data.', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_LOT', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time of voucher lot number entry', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_LOT', 'COLUMN', N'DATE_RECEIVED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location identifier', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_LOT', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Voucher Lot Number', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_LOT', 'COLUMN', N'LOT_NUMBER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Int value', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER_LOT', 'COLUMN', N'VOUCHER_LOT_ID'
GO
