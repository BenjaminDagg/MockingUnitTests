CREATE TABLE [dbo].[DBInfoCentral]
(
[DBInfoID] [int] NOT NULL IDENTITY(1, 1),
[UpgradeVersion] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpgradeDate] [datetime] NOT NULL CONSTRAINT [DF_DBInfoCentral_UpgradeDate] DEFAULT (getdate()),
[SQLVersion] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQLEdition] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQLServicePack] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DBInfoCentral_SQLServicePack] DEFAULT ((0)),
[ServerName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPUCount] [smallint] NOT NULL CONSTRAINT [DF_DBInfoCentral_CPUCount] DEFAULT ((1)),
[PhysicalMemory] [int] NOT NULL CONSTRAINT [DF_DBInfoCentral_PhysicalMemory] DEFAULT ((0)),
[VirtualMemory] [int] NOT NULL CONSTRAINT [DF_DBInfoCentral_VirtualMemory] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DBInfoCentral] ADD CONSTRAINT [PK_DBInfoCentral] PRIMARY KEY CLUSTERED  ([DBInfoID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores database upgrade version information', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Server CPUs', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'CPUCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'DBInfoID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Server Physical Memory in megabytes', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'PhysicalMemory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the server on which the database was running when upgraded', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'ServerName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SQL Server Edition', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'SQLEdition'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SQL Server Service Pack in use at time of upgrade', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'SQLServicePack'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Version of SQL Server running at the time of the upgrade', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'SQLVersion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the database was upgraded', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'UpgradeDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Database Version', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'UpgradeVersion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Server Virtual Memory in megabytes', 'SCHEMA', N'dbo', 'TABLE', N'DBInfoCentral', 'COLUMN', N'VirtualMemory'
GO
