CREATE TABLE [dbo].[AppUserClaim]
(
[UserClaimId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[ClaimType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserClaim] ADD CONSTRAINT [PK_AppUserClaim] PRIMARY KEY CLUSTERED  ([UserClaimId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppUserClaim_UserId] ON [dbo].[AppUserClaim] ([UserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserClaim] ADD CONSTRAINT [FK_AppUserClaim_AppUser_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AppUser] ([UserId]) ON DELETE CASCADE
GO
