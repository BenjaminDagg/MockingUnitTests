CREATE TABLE [dbo].[AppEnvironment]
(
[AppEnvironmentId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationVersion] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationType] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationPath] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationAssemblyPath] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProcessUserIdentity] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeviceName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeviceOs] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsOperatingSystem64Bit] [bit] NOT NULL,
[ProcessorCount] [smallint] NOT NULL,
[TotalPhyiscalMemory] [bigint] NOT NULL,
[TotalVirtualMemory] [bigint] NOT NULL,
[AvaliablePhysicalMemory] [bigint] NOT NULL,
[AvaliableVirtualMemory] [bigint] NOT NULL,
[LastModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppEnvironment] ADD CONSTRAINT [PK_AppEnvironment_1] PRIMARY KEY CLUSTERED  ([AppEnvironmentId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the last user environment information.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Idenity Id, for interal use only.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'AppEnvironmentId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The app assembly path that was logged into by the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'ApplicationAssemblyPath'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The app name that was logged into by the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'ApplicationName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The app path that was logged into by the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'ApplicationPath'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The app type that was logged into by the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'ApplicationType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The app version that was logged into by the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'ApplicationVersion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The available physical memory for the device that the AppUser logged in with.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'AvaliablePhysicalMemory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The available virtual memory for the device that the AppUser logged in with.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'AvaliableVirtualMemory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The device name that was logged in with by the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'DeviceName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The device operating system that was logged in with by the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'DeviceOs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The 64-bit flag for the operating system that was logged in with by the AppUser.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'IsOperatingSystem64Bit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the AppUser last logged into the app.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'LastModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The number of processors for the device that the AppUser logged in with.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'ProcessorCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The app process username that was used by the app.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'ProcessUserIdentity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total physcial memory for the device that the AppUser logged in with.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'TotalPhyiscalMemory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total virtual memory for the device that the AppUser logged in with.', 'SCHEMA', N'dbo', 'TABLE', N'AppEnvironment', 'COLUMN', N'TotalVirtualMemory'
GO
