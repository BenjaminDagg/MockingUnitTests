CREATE TABLE [dbo].[CentralSite]
(
[CentralSiteId] [int] NOT NULL IDENTITY(1, 1),
[MarketTypeId] [int] NOT NULL,
[CentralSiteName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StreetAddress] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CentralSite] ADD CONSTRAINT [PK_CentralSite] PRIMARY KEY CLUSTERED  ([CentralSiteId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the central site location data.', 'SCHEMA', N'dbo', 'TABLE', N'CentralSite', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'CentralSite', 'COLUMN', N'CentralSiteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The central site name.', 'SCHEMA', N'dbo', 'TABLE', N'CentralSite', 'COLUMN', N'CentralSiteName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The central site city.', 'SCHEMA', N'dbo', 'TABLE', N'CentralSite', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent market id.', 'SCHEMA', N'dbo', 'TABLE', N'CentralSite', 'COLUMN', N'MarketTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The central site state.', 'SCHEMA', N'dbo', 'TABLE', N'CentralSite', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The central site address.', 'SCHEMA', N'dbo', 'TABLE', N'CentralSite', 'COLUMN', N'StreetAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The central site zip code.', 'SCHEMA', N'dbo', 'TABLE', N'CentralSite', 'COLUMN', N'ZipCode'
GO
