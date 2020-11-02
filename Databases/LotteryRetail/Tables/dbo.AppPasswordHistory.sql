CREATE TABLE [dbo].[AppPasswordHistory]
(
[PasswordHistoryId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[PasswordHash] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppPasswordHistory] ADD CONSTRAINT [PK_AppPasswordHistory] PRIMARY KEY CLUSTERED  ([PasswordHistoryId]) ON [PRIMARY]
GO
