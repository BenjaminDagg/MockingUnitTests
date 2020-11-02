CREATE TABLE [dbo].[AppRoleClaim]
(
[RoleClaimId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NOT NULL,
[ClaimType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppRoleClaim] ADD CONSTRAINT [PK_AppRoleClaim] PRIMARY KEY CLUSTERED  ([RoleClaimId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppRoleClaim_RoleId] ON [dbo].[AppRoleClaim] ([RoleId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppRoleClaim] ADD CONSTRAINT [FK_AppRoleClaim_AppRole_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AppRole] ([RoleId]) ON DELETE CASCADE
GO
