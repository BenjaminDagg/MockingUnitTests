CREATE TABLE [dbo].[AppPasswordHistory]
(
[AppPasswordHistoryId] [int] NOT NULL IDENTITY(1, 1),
[AppUserId] [int] NOT NULL,
[Password] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_AppPasswordHistory_CreatedDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppPasswordHistory] ADD CONSTRAINT [PK_AppPasswordHistory] PRIMARY KEY CLUSTERED  ([AppPasswordHistoryId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppPasswordHistory_AppUserId] ON [dbo].[AppPasswordHistory] ([AppUserId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppPasswordHistory] WITH NOCHECK ADD CONSTRAINT [FK_AppPasswordHistory_AppUser] FOREIGN KEY ([AppUserId]) REFERENCES [dbo].[AppUser] ([AppUserId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the older passwords for each user.', 'SCHEMA', N'dbo', 'TABLE', N'AppPasswordHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Id, internal use only.', 'SCHEMA', N'dbo', 'TABLE', N'AppPasswordHistory', 'COLUMN', N'AppPasswordHistoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The AppUser identity id for the password entry.', 'SCHEMA', N'dbo', 'TABLE', N'AppPasswordHistory', 'COLUMN', N'AppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the AppUser''s password was created.', 'SCHEMA', N'dbo', 'TABLE', N'AppPasswordHistory', 'COLUMN', N'CreatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'[Encryped] The AppUser''s password.', 'SCHEMA', N'dbo', 'TABLE', N'AppPasswordHistory', 'COLUMN', N'Password'
GO
