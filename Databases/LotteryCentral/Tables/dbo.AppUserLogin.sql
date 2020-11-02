CREATE TABLE [dbo].[AppUserLogin]
(
[LoginProvider] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProviderKey] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProviderDisplayName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserLogin] ADD CONSTRAINT [PK_AppUserLogin] PRIMARY KEY CLUSTERED  ([LoginProvider], [ProviderKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppUserLogin_UserId] ON [dbo].[AppUserLogin] ([UserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserLogin] ADD CONSTRAINT [FK_AppUserLogin_AppUser_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AppUser] ([UserId]) ON DELETE CASCADE
GO
