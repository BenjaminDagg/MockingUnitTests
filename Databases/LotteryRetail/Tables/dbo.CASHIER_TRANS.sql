CREATE TABLE [dbo].[CASHIER_TRANS]
(
[CASHIER_TRANS_ID] [int] NOT NULL IDENTITY(1, 1),
[TRANS_TYPE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TRANS_AMT] [money] NOT NULL,
[TRANS_NO] [int] NULL,
[SESSION_ID] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CREATED_BY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CREATE_DATE] [datetime] NOT NULL CONSTRAINT [DF_CASHIER_TRANS_CREATED_DATE] DEFAULT (getdate()),
[CASHIER_STN] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PAYMENT_TYPE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VOUCHER_ID] [int] NOT NULL CONSTRAINT [DF_CASHIER_TRANS_VOUCHER_ID] DEFAULT ((0)),
[AUTH_USER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCATION_ID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASHIER_TRANS] ADD CONSTRAINT [PK_CASHIER_TRANS] PRIMARY KEY NONCLUSTERED  ([CASHIER_TRANS_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CREATE_DATE] ON [dbo].[CASHIER_TRANS] ([CREATE_DATE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PAYMENT_TYPE] ON [dbo].[CASHIER_TRANS] ([PAYMENT_TYPE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SESSION_ID] ON [dbo].[CASHIER_TRANS] ([SESSION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TRANS_TYPE] ON [dbo].[CASHIER_TRANS] ([TRANS_TYPE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CASHIER_TRANS_VOUCHER_ID] ON [dbo].[CASHIER_TRANS] ([VOUCHER_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cashier audit table', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that authorized the payout', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'AUTH_USER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Workstation where transaction occurred', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'CASHIER_STN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'CASHIER_TRANS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time this row was inserted', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'CREATE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that performed the transaction', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'CREATED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payment Type (A=Automatic, M=Manual)', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'PAYMENT_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cashier Session ID', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'SESSION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction amount in dollars', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'TRANS_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to transaction record in CASINO_TRANS table', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'TRANS_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'2 Character Cashier Transaction Type (currently all are 1 character)', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'TRANS_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies Voucher that was paid', 'SCHEMA', N'dbo', 'TABLE', N'CASHIER_TRANS', 'COLUMN', N'VOUCHER_ID'
GO
