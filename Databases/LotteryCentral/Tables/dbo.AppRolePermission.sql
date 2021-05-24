CREATE TABLE [dbo].[AppRolePermission]
(
[AppRoleId] [int] NOT NULL,
[AppPermissionId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppRolePermission] ADD CONSTRAINT [PK_AppRolePermission] PRIMARY KEY CLUSTERED  ([AppRoleId], [AppPermissionId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppRolePermission] ADD CONSTRAINT [FK_AppRolePermission_AppPermission] FOREIGN KEY ([AppPermissionId]) REFERENCES [dbo].[AppPermission] ([AppPermissionId])
GO
ALTER TABLE [dbo].[AppRolePermission] ADD CONSTRAINT [FK_AppRolePermission_AppRole] FOREIGN KEY ([AppRoleId]) REFERENCES [dbo].[AppRole] ([AppRoleId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the connections between which AppRoles are assigned to which AppPermissions', 'SCHEMA', N'dbo', 'TABLE', N'AppRolePermission', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The AppPermission identity id assigned to the AppRole identity id.', 'SCHEMA', N'dbo', 'TABLE', N'AppRolePermission', 'COLUMN', N'AppPermissionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The AppRole identity id that is assigned the specific AppPermission identity id.', 'SCHEMA', N'dbo', 'TABLE', N'AppRolePermission', 'COLUMN', N'AppRoleId'
GO
