CREATE TABLE [dbo].[SiteOwner]
(
[SiteOwnerId] [int] NOT NULL IDENTITY(1, 1),
[SiteId] [int] NOT NULL,
[LastName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MiddleInitial] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StreetAddress] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhoneNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateOfBirth] [datetime] NOT NULL,
[SSN] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Race] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SiteOwner] ADD CONSTRAINT [PK_OwnerInfo] PRIMARY KEY CLUSTERED  ([SiteOwnerId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the Site Agent owner data.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners city.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners date of birth.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'DateOfBirth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners first name.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners gender.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'Gender'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners last name.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners middle initial.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'MiddleInitial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners phone number.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'PhoneNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners race.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'Race'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id of the Site Agent this owner belongs to.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'SiteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'SiteOwnerId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'[Encrypted] The Site owners social security number.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners state.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners street address.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'StreetAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site owners zip code.', 'SCHEMA', N'dbo', 'TABLE', N'SiteOwner', 'COLUMN', N'ZipCode'
GO
