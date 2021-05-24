CREATE TABLE [dbo].[AppRole]
(
[AppRoleId] [int] NOT NULL,
[RoleName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RoleLevel] [int] NOT NULL,
[RoleDescription] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppRole] ADD CONSTRAINT [PK_AppRole] PRIMARY KEY CLUSTERED  ([AppRoleId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the roles that each AppUser may be assigned to.', 'SCHEMA', N'dbo', 'TABLE', N'AppRole', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity id for the app role.', 'SCHEMA', N'dbo', 'TABLE', N'AppRole', 'COLUMN', N'AppRoleId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The short description of the app role.', 'SCHEMA', N'dbo', 'TABLE', N'AppRole', 'COLUMN', N'RoleDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The level of the app role.', 'SCHEMA', N'dbo', 'TABLE', N'AppRole', 'COLUMN', N'RoleLevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the app role.', 'SCHEMA', N'dbo', 'TABLE', N'AppRole', 'COLUMN', N'RoleName'
GO
