CREATE TABLE [dbo].[AppUserRole]
(
[UserId] [int] NOT NULL,
[RoleId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserRole] ADD CONSTRAINT [PK_AppUserRole] PRIMARY KEY CLUSTERED  ([UserId], [RoleId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppUserRole_RoleId] ON [dbo].[AppUserRole] ([RoleId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserRole] ADD CONSTRAINT [FK_AppUserRole_AppRole_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AppRole] ([RoleId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AppUserRole] ADD CONSTRAINT [FK_AppUserRole_AppUser_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AppUser] ([UserId]) ON DELETE CASCADE
GO
