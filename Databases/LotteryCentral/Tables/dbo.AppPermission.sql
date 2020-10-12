CREATE TABLE [dbo].[AppPermission]
(
[AppPermissionId] [int] NOT NULL,
[PermissionName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PermissionDescription] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PermissionDisplayText] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_AppPermission_PermissionDisplayText] DEFAULT (''),
[IsPlaceholder] [bit] NOT NULL CONSTRAINT [DF_AppPermission_IsPlaceholder] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppPermission] ADD CONSTRAINT [PK_AppPermission] PRIMARY KEY CLUSTERED  ([AppPermissionId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the available permissions each AppRole may be give access to.', 'SCHEMA', N'dbo', 'TABLE', N'AppPermission', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Id, internal use only.', 'SCHEMA', N'dbo', 'TABLE', N'AppPermission', 'COLUMN', N'AppPermissionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The short description of the permission.', 'SCHEMA', N'dbo', 'TABLE', N'AppPermission', 'COLUMN', N'PermissionDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the permission.', 'SCHEMA', N'dbo', 'TABLE', N'AppPermission', 'COLUMN', N'PermissionName'
GO
