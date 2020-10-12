CREATE TABLE [dbo].[AppNav]
(
[AppNavId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Url] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParentId] [int] NULL,
[AppPermissionId] [int] NULL,
[OrdinalPosition] [int] NOT NULL,
[HideIfNoChildern] [bit] NOT NULL CONSTRAINT [DF_AppNav_HideIfNoChildern] DEFAULT ((0)),
[Attributes] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppNav] ADD CONSTRAINT [PK_AppNav] PRIMARY KEY CLUSTERED  ([AppNavId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the dynamic links available in the website.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The short description of the app area to link to.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'ApplicationName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity id, used to assign navigation children if needed.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'AppNavId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The AppPermissionId needed to access area.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'AppPermissionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Html attributes for area link.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'Attributes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The short description of the area link.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name that is displayed on the app for that area link.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'DisplayName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal flag to hide if parent and has no children areas.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'HideIfNoChildern'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The internal name of area link for the app.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The position of the area link in reference to the area list.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'OrdinalPosition'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The parent identity id of the area link, if area is a sub class or an area.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'ParentId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The reference link to the area once clicked in the app.', 'SCHEMA', N'dbo', 'TABLE', N'AppNav', 'COLUMN', N'Url'
GO
