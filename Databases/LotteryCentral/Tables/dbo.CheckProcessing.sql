CREATE TABLE [dbo].[CheckProcessing]
(
[CheckId] [int] NOT NULL IDENTITY(1, 1),
[CentralSiteId] [int] NOT NULL,
[CheckNumber] [int] NULL,
[CheckAmount] [money] NOT NULL,
[VoucherPayoutReceiptId] [int] NOT NULL,
[DatePrinted] [datetime] NOT NULL,
[PrintedByAppUserId] [int] NOT NULL CONSTRAINT [DF_CheckProcessing_PrintedByAppUserId] DEFAULT ((-1)),
[IsVoid] [bit] NOT NULL,
[PreviousCheckNumber] [int] NULL,
[DateVoided] [datetime] NULL,
[VoidedByAppUserId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CheckProcessing] ADD CONSTRAINT [PK_CheckProcessing] PRIMARY KEY CLUSTERED  ([CheckId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the check data.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the central site the check was processed at.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'CentralSiteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The check amount of the check processed.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'CheckAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'CheckId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The check number of the check processed.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'CheckNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the check was processed.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'DatePrinted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the check was voided.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'DateVoided'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The flag showing if the check is void or not.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'IsVoid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The previous check number that was voided if this check is an edit/reprint.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'PreviousCheckNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user that processed the check.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'PrintedByAppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user that voided the check.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'VoidedByAppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The payout receipt identity id of the check processed.', 'SCHEMA', N'dbo', 'TABLE', N'CheckProcessing', 'COLUMN', N'VoucherPayoutReceiptId'
GO
