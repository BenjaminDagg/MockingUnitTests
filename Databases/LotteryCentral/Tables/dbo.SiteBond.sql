CREATE TABLE [dbo].[SiteBond]
(
[SiteBondId] [int] NOT NULL IDENTITY(1, 1),
[SiteId] [int] NOT NULL,
[BondType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BondAmount] [int] NOT NULL,
[BondRenewal] [bit] NOT NULL,
[BondEffectiveDate] [datetime] NOT NULL,
[BondReleaseDate] [datetime] NOT NULL,
[BondNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BondCompanyName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsBonded] [bit] NOT NULL CONSTRAINT [DF_SiteBond_IsBonded] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SiteBond] ADD CONSTRAINT [PK_SiteBond] PRIMARY KEY CLUSTERED  ([SiteBondId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the Site Agent bond data.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The bond amount for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'BondAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The bond company name for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'BondCompanyName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The bond effective date for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'BondEffectiveDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The bond number for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'BondNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The bond release date for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'BondReleaseDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The flag for bond renewal for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'BondRenewal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The bond type for the Site Agent.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'BondType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The flag for whether the Site Agent is bonded or not.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'IsBonded'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'SiteBondId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the Site Agent this owner bond data belongs to.', 'SCHEMA', N'dbo', 'TABLE', N'SiteBond', 'COLUMN', N'SiteId'
GO
