CREATE TABLE [dbo].[CustomerPayoutInfo]
(
[CustomerPayoutInfoId] [int] NOT NULL IDENTITY(1, 1),
[VoucherPayoutReceiptId] [int] NOT NULL,
[CheckId] [int] NOT NULL,
[SSN] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Address] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerPayoutInfo] ADD CONSTRAINT [PK_CustomerPayoutInfo] PRIMARY KEY CLUSTERED  ([CustomerPayoutInfoId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the customer info for the check payouts.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The address of the payout recipient.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'Address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the check for this customer info.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'CheckId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The city of the payout recipient.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'CustomerPayoutInfoId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The first name of the payout recipient.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The last name of the payout recipient.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'[Encrypted] The social security number of the payout recipient.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The state of the payout recipient.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the payout receipt.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'VoucherPayoutReceiptId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The zip code of the payout recipient.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerPayoutInfo', 'COLUMN', N'Zipcode'
GO
