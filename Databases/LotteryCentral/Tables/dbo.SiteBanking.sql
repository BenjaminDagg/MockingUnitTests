CREATE TABLE [dbo].[SiteBanking]
(
[SiteBankingId] [int] NOT NULL IDENTITY(1, 1),
[SiteId] [int] NOT NULL,
[BankAccountNumber] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BankAccountName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BankRoutingNumber] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BankAccountType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinancialContactName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinancialContactNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BankEffectiveDate] [datetime] NULL,
[EFT] [bit] NOT NULL,
[BankBranchNumber] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_SiteBanking_BankBranchNumber] DEFAULT ('000')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SiteBanking] ADD CONSTRAINT [PK_SiteBankingInfo] PRIMARY KEY CLUSTERED  ([SiteBankingId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the Site Agent banking data.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores the Agent''s bank name.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'BankAccountName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'[Encrypted] Stores the Agent''s bank account number.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'BankAccountNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Agent''s back account type.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'BankAccountType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The bank effective date for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'BankEffectiveDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'[Encrypted] Stores the Agent''s bank routing number.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'BankRoutingNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This flag is true if the Site Agent is enabled for Electronic Fund Transfers.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'EFT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The financial contact name for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'FinancialContactName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The financial contact number for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'FinancialContactNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'SiteBankingId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the Site Agent this banking data belongs to.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBanking', 'COLUMN', N'SiteId'
GO
