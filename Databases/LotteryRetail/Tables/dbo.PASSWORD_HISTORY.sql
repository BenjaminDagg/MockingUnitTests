CREATE TABLE [dbo].[PASSWORD_HISTORY]
(
[PASS_HISTORY_ID] [int] NOT NULL IDENTITY(1, 1),
[ACCOUNTID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PHASH] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DATE_CHANGED] [datetime] NOT NULL CONSTRAINT [DF_PASSWORD_HISTORY_DATE_CHANGED] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PASSWORD_HISTORY] ADD CONSTRAINT [PK_PASSWORD_HISTORY] PRIMARY KEY CLUSTERED  ([PASS_HISTORY_ID], [ACCOUNTID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores password history for LRAS users. ', 'SCHEMA', N'dbo', 'TABLE', N'PASSWORD_HISTORY', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores user accounts for Accounting, Deal Import, and EGM access.', 'SCHEMA', N'dbo', 'TABLE', N'PASSWORD_HISTORY', 'COLUMN', N'ACCOUNTID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the PHASH value was last modified. Used to get the Top N results.', 'SCHEMA', N'dbo', 'TABLE', N'PASSWORD_HISTORY', 'COLUMN', N'DATE_CHANGED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity of the password history row.', 'SCHEMA', N'dbo', 'TABLE', N'PASSWORD_HISTORY', 'COLUMN', N'PASS_HISTORY_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Password of user encrypted to MD5 Hash.', 'SCHEMA', N'dbo', 'TABLE', N'PASSWORD_HISTORY', 'COLUMN', N'PHASH'
GO
