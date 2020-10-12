CREATE TABLE [dbo].[GL_INFO]
(
[GL_INFO_ID] [int] NOT NULL IDENTITY(1, 1),
[LOCATION_ID] [int] NOT NULL,
[ACCT_DATE] [datetime] NOT NULL,
[NET_REVENUE] [money] NOT NULL,
[AGENT_COMMISSIONS_EXPENSE] [money] NOT NULL,
[AMOUNT_DUE_FROM_AGENTS] [money] NOT NULL,
[CONTRACTOR_FEES] [money] NOT NULL,
[UNCLAIMED_VOUCHER_AMOUNT] [money] NOT NULL,
[EXPIRED_VOUCHER_AMOUNT] [money] NOT NULL,
[TRANSFERRED] [bit] NOT NULL CONSTRAINT [DF_GL_INFO_TRANSFERRED] DEFAULT ((0)),
[DATE_TRANSFERRED] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GL_INFO] ADD CONSTRAINT [PK_GL_INFO] PRIMARY KEY CLUSTERED  ([GL_INFO_ID], [LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores daily general ledger information that is transferred to the Central system.', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Date', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'ACCT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agent Commisions (NetRevenue * RetailRevenuePercent)', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'AGENT_COMMISSIONS_EXPENSE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount due from agents (NetRevenue - AgentCommissionsExpense)', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'AMOUNT_DUE_FROM_AGENTS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contractor fees (@NetRevenue * 0.4)', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'CONTRACTOR_FEES'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transfer date', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'DATE_TRANSFERRED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Expired vouchers', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'EXPIRED_VOUCHER_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'GL_INFO_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location net revenue (AmountPlayed - AmountWon = NetRevenue)', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'NET_REVENUE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transfer flag', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'TRANSFERRED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unclaimed vouchers', 'SCHEMA', N'dbo', 'TABLE', N'GL_INFO', 'COLUMN', N'UNCLAIMED_VOUCHER_AMOUNT'
GO
