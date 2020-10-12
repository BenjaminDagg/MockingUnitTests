CREATE TABLE [dbo].[VoucherPayout]
(
[VoucherPayoutID] [int] NOT NULL IDENTITY(1, 1),
[VoucherID] [int] NOT NULL,
[LocationID] [int] NOT NULL,
[Barcode] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransAmount] [money] NOT NULL,
[PosWorkStation] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AppUserID] [int] NULL CONSTRAINT [DF_VoucherPayout_AppUserId] DEFAULT ((0)),
[PayDateTime] [datetime] NOT NULL CONSTRAINT [DF_VoucherPayout_PayDateTime] DEFAULT (getdate()),
[LocationUpdated] [bit] NOT NULL CONSTRAINT [DF_VoucherPayout_RetailUpdated] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VoucherPayout] ADD CONSTRAINT [PK_VoucherPayout] PRIMARY KEY CLUSTERED  ([VoucherPayoutID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_VoucherPayout_Barcode] ON [dbo].[VoucherPayout] ([Barcode]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_VoucherPayout_IDLoc] ON [dbo].[VoucherPayout] ([VoucherID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores audit information for all redeemed vouchers', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user who created this payout receipt.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'COLUMN', N'AppUserID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Voucher Validation ID', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'COLUMN', N'Barcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Voucher Location ID', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'COLUMN', N'LocationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the Location Voucher row was successfully updated as having been paid.', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'COLUMN', N'LocationUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTime when voucher was redeemed', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'COLUMN', N'PayDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'POS Workstation Name', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'COLUMN', N'PosWorkStation'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction Amount', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'COLUMN', N'TransAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Voucher ID', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'COLUMN', N'VoucherID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'COLUMN', N'VoucherPayoutID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique index on Barcode (Voucher Validation ID)', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'INDEX', N'IX_VoucherPayout_Barcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique index on VoucherID and LocationID', 'SCHEMA', N'dbo', 'TABLE', N'VoucherPayout', 'INDEX', N'IX_VoucherPayout_IDLoc'
GO
