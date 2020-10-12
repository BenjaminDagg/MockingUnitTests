CREATE TABLE [dbo].[CASINO_USERS]
(
[ACCOUNTID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACCESS_LEVEL] [tinyint] NULL CONSTRAINT [DF_CASINO_USERS_ACCESS_LEVEL] DEFAULT ((0)),
[LEVEL_CODE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FNAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PSSWD] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTIVE] [bit] NULL,
[CREATEDDT] [datetime] NULL CONSTRAINT [DF_CASINO_USERS_CREATEDDT] DEFAULT (getdate()),
[DEACTIVATEDDT] [datetime] NULL,
[USERLOGGED] [bit] NULL,
[CUR_SESSION_ID] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUR_SESSION_STS] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SESSION_STN] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUR_SESSION_DTIME] [datetime] NULL,
[APP_VERSION] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IS_CASINO_TECH] [bit] NULL CONSTRAINT [DF_CASINO_USERS_IS_CASINO_TECH] DEFAULT ((0)),
[IS_DGE_TECH] [bit] NULL CONSTRAINT [DF_CASINO_USERS_IS_DGE_TECH] DEFAULT ((0)),
[PHASH] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHASHDT] [datetime] NOT NULL CONSTRAINT [DF_CASINO_USERS_PHASHDT_1] DEFAULT (getdate()),
[IS_PASSRESET] [bit] NOT NULL CONSTRAINT [DF_CASINO_USERS_PASSRESET] DEFAULT ((1)),
[INVALID_ATTEMPTS] [tinyint] NOT NULL CONSTRAINT [DF_CASINO_USERS_INVALID_ATTEMPTS] DEFAULT ((0)),
[LAST_INVALID_ATTEMPT] [datetime] NULL CONSTRAINT [DF_CASINO_USERS_LAST_INVALID_ATTEMPT] DEFAULT (getdate()),
[IS_ACCOUNT_LOCKED] [bit] NOT NULL CONSTRAINT [DF_CASINO_USERS_IS_ACCOUNT_LOCKED] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASINO_USERS] ADD CONSTRAINT [PK_CASINO_USERS] PRIMARY KEY CLUSTERED  ([ACCOUNTID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASINO_USERS] WITH NOCHECK ADD CONSTRAINT [FK_CASINO_USERS_LEVEL_CODE] FOREIGN KEY ([LEVEL_CODE]) REFERENCES [dbo].[LEVEL_PERMISSIONS] ([LEVEL_CODE])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores user accounts for Accounting, Deal Import, and EGM access', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Access level value 1=DGE Tech 2=Casino Tech 0=neither', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'ACCESS_LEVEL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account ID for login to the Accounting application', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'ACCOUNTID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active Flag', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'ACTIVE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The version of the Accounting system in use when this user logged in to the Accounting application', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'APP_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time this record was first inserted', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'CREATEDDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Session Date and time', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'CUR_SESSION_DTIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cashier Session ID', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'CUR_SESSION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cashier Session Status', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'CUR_SESSION_STS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time this record was deactivated', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'DEACTIVATEDDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First Name', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'FNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Counts the number of Invalid login attempts. ', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'INVALID_ATTEMPTS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defines whether the account is locked.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'IS_ACCOUNT_LOCKED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if this user is a Casino Technician', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'IS_CASINO_TECH'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if this user is a Diamond Game Technician', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'IS_DGE_TECH'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defines whether the current PHASH value was reset by the admin. Password rest.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'IS_PASSRESET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date entry of last invalid logon attempt.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'LAST_INVALID_ATTEMPT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Security Level name', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'LEVEL_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last Name', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'LNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'MD5 hash of password', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'PHASH'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defines the date the password was created or updated.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'PHASHDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Password', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'PSSWD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the Workstation from which the user logged in to the Accounting application', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'SESSION_STN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the user is currently logged in using the Accounting application', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_USERS', 'COLUMN', N'USERLOGGED'
GO
