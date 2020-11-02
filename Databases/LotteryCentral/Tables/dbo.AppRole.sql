CREATE TABLE [dbo].[AppRole]
(
[RoleId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NormalizedName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConcurrencyStamp] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppRole] ADD CONSTRAINT [PK_AppRole] PRIMARY KEY CLUSTERED  ([RoleId]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AppRole] ([NormalizedName]) WHERE ([NormalizedName] IS NOT NULL) ON [PRIMARY]
GO
