CREATE TABLE [dbo].[APP_INFO]
(
[APP_INFO_ID] [int] NOT NULL IDENTITY(1, 1),
[APPLICATION_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COMPUTER_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CURRENT_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LAST_APP_STARTUP] [datetime] NOT NULL,
[OS_FULLNAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OS_PLATFORM] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OS_VERSION] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MEMORY_TOTAL_PHYSICAL] [bigint] NOT NULL,
[MEMORY_TOTAL_VIRTUAL] [bigint] NOT NULL,
[MEMORY_AVAILABLE_PHYSICAL] [bigint] NOT NULL,
[MEMORY_AVAILABLE_VIRTUAL] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_INFO] ADD CONSTRAINT [PK_APP_INFO] PRIMARY KEY CLUSTERED  ([APP_INFO_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_APPNAME_COMPUTERNAME] ON [dbo].[APP_INFO] ([APPLICATION_NAME], [COMPUTER_NAME]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores application version information for the Customer Environment report.', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'APP_INFO_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Application Name', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'APPLICATION_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the computer that the application is running on', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'COMPUTER_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current application version', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'CURRENT_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time application lasted updated this row', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'LAST_APP_STARTUP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Available Physical memory on the computer running the application', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'MEMORY_AVAILABLE_PHYSICAL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Available Virtual memory on the computer running the application', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'MEMORY_AVAILABLE_VIRTUAL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Physical memory on the computer running the application', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'MEMORY_TOTAL_PHYSICAL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Virtual memory on the computer running the application', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'MEMORY_TOTAL_VIRTUAL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OS Name that the application is running on', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'OS_FULLNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OS Platform that the application is running on', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'OS_PLATFORM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OS Version that the application is running on', 'SCHEMA', N'dbo', 'TABLE', N'APP_INFO', 'COLUMN', N'OS_VERSION'
GO
