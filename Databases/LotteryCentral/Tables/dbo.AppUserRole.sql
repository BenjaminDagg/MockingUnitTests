CREATE TABLE [dbo].[AppUserRole]
(
[AppUserID] [int] NOT NULL,
[AppRoleId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserRole] ADD CONSTRAINT [PK_AppUserRole] PRIMARY KEY CLUSTERED  ([AppUserID], [AppRoleId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserRole] ADD CONSTRAINT [FK_AppUserRole_AppRole] FOREIGN KEY ([AppRoleId]) REFERENCES [dbo].[AppRole] ([AppRoleId])
GO
ALTER TABLE [dbo].[AppUserRole] ADD CONSTRAINT [FK_AppUserRole_AppUser] FOREIGN KEY ([AppUserID]) REFERENCES [dbo].[AppUser] ([AppUserId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the connection for AppUsers and their AppRoles.', 'SCHEMA', N'dbo', 'TABLE', N'AppUserRole', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The AppRole identity id assigned to the AppUser identity id.', 'SCHEMA', N'dbo', 'TABLE', N'AppUserRole', 'COLUMN', N'AppRoleId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The AppUser identity id that is assigned the specific AppRole identity id.', 'SCHEMA', N'dbo', 'TABLE', N'AppUserRole', 'COLUMN', N'AppUserID'
GO
