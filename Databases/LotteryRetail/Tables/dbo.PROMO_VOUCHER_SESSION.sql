CREATE TABLE [dbo].[PROMO_VOUCHER_SESSION]
(
[PROMO_VOUCHER_SESSION_ID] [int] NOT NULL IDENTITY(1, 1),
[AUTH_ACCOUNTID1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AUTH_ACCOUNTID2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VOUCHER_AMOUNT] [smallmoney] NOT NULL,
[VOUCHER_COUNT] [int] NOT NULL,
[VOUCHERS_PRINTED] [int] NOT NULL CONSTRAINT [DF_PROMO_VOUCHER_SESSION_VOUCHERS_PRINTED] DEFAULT ((0)),
[EXPIRATION_DAYS] [int] NOT NULL,
[WORKSTATION] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACCT_DATE] [datetime] NOT NULL,
[SESSION_DATE] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PROMO_VOUCHER_SESSION] ADD CONSTRAINT [PK_PROMO_VOUCHER_SESSION] PRIMARY KEY CLUSTERED  ([PROMO_VOUCHER_SESSION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores session information for the FreePlay application.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting date the vouchers were created.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'ACCT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AccountID used to authorize the session.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'AUTH_ACCOUNTID1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AccountID used to authorize the session.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'AUTH_ACCOUNTID2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of the days the FreePlay vouchers will expire in.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'EXPIRATION_DAYS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to the PROMO_VOUCHER_SESSION table', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'PROMO_VOUCHER_SESSION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the vouchers were created.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'SESSION_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The dollar amount each voucher is worth', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'VOUCHER_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of vouchers created in the session.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'VOUCHER_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of vouchers that were actually printed.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'VOUCHERS_PRINTED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Workstation used to create the FreePlay vouchers.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_VOUCHER_SESSION', 'COLUMN', N'WORKSTATION'
GO
