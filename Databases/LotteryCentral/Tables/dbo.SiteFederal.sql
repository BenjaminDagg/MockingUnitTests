CREATE TABLE [dbo].[SiteFederal]
(
[SiteFederalId] [int] NOT NULL IDENTITY(1, 1),
[SiteId] [int] NOT NULL,
[UsesSSNForFID] [bit] NOT NULL,
[FederalIDNumber] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IRSNumber] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CorporationName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SiteFederal] ADD CONSTRAINT [PK_SiteFederal] PRIMARY KEY CLUSTERED  ([SiteFederalId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the Site Agent federal data.', 'SCHEMA', N'dbo', 'TABLE', N'SiteFederal', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agents corporation name.', 'SCHEMA', N'dbo', 'TABLE', N'SiteFederal', 'COLUMN', N'CorporationName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'[Encrypted] Stores the Agent''s Federal ID Number', 'SCHEMA', N'dbo', 'TABLE', N'SiteFederal', 'COLUMN', N'FederalIDNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'[Encrypted] Stores the Agent''s IRS Number', 'SCHEMA', N'dbo', 'TABLE', N'SiteFederal', 'COLUMN', N'IRSNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'SiteFederal', 'COLUMN', N'SiteFederalId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the Site Agent this owner federal data belongs to.', 'SCHEMA', N'dbo', 'TABLE', N'SiteFederal', 'COLUMN', N'SiteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is set to true if the Site used the owners social security number for the federal id.', 'SCHEMA', N'dbo', 'TABLE', N'SiteFederal', 'COLUMN', N'UsesSSNForFID'
GO
