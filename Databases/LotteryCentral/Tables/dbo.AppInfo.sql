CREATE TABLE [dbo].[AppInfo]
(
[AppInfoId] [int] NOT NULL IDENTITY(1, 1),
[DeviceName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationVersion] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationPath] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeviceOs] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeviceOsVersion] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastAppStartup] [datetime] NOT NULL,
[MemoryTotalPhysical] [bigint] NOT NULL,
[MemoryTotalVirtual] [bigint] NOT NULL,
[MemoryAvailablePhysical] [bigint] NOT NULL,
[MemoryAvailableVirtual] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppInfo] ADD CONSTRAINT [PK_AppInfo] PRIMARY KEY CLUSTERED  ([AppInfoId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores application version information for the Customer Environment report.', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'AppInfoId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Application Name', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'ApplicationName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current application version', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'ApplicationVersion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the computer that the application is running on', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'DeviceName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OS Name that the application is running on', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'DeviceOs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OS Version that the application is running on', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'DeviceOsVersion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time application lasted updated this row', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'LastAppStartup'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Available Physical memory on the computer running the application', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'MemoryAvailablePhysical'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Available Virtual memory on the computer running the application', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'MemoryAvailableVirtual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Physical memory on the computer running the application', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'MemoryTotalPhysical'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Virtual memory on the computer running the application', 'SCHEMA', N'dbo', 'TABLE', N'AppInfo', 'COLUMN', N'MemoryTotalVirtual'
GO
