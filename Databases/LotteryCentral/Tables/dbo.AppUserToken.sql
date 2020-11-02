CREATE TABLE [dbo].[AppUserToken]
(
[UserId] [int] NOT NULL,
[LoginProvider] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserToken] ADD CONSTRAINT [PK_AppUserToken] PRIMARY KEY CLUSTERED  ([UserId], [LoginProvider], [Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserToken] ADD CONSTRAINT [FK_AppUserToken_AppUser_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AppUser] ([UserId]) ON DELETE CASCADE
GO
