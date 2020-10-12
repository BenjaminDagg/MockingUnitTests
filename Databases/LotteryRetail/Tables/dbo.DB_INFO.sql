CREATE TABLE [dbo].[DB_INFO]
(
[DB_INFO_ID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UPGRADE_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UPGRADE_DATE] [datetime] NOT NULL CONSTRAINT [DF_DB_INFO_UPGRADE_DATE] DEFAULT (getdate()),
[SQL_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQL_EDITION] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQL_SERVICE_PACK] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DB_INFO_SQL_SERVICE_PACK] DEFAULT ((0)),
[SERVER_NAME] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPU_COUNT] [smallint] NOT NULL CONSTRAINT [DF_DB_INFO_CPU_COUNT] DEFAULT ((1)),
[PHYSICAL_MEMORY] [int] NOT NULL CONSTRAINT [DF_DB_INFO_PHYSICAL_MEMORY] DEFAULT ((0)),
[VIRTUAL_MEMORY] [int] NOT NULL CONSTRAINT [DF_DB_INFO_VIRTUAL_MEMORY] DEFAULT ((0)),
[LocationID] [int] NOT NULL CONSTRAINT [DF_DB_INFO_LocationID] DEFAULT ((1)),
[DatabaseName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DB_INFO] ADD CONSTRAINT [PK_DB_INFO] PRIMARY KEY CLUSTERED  ([DB_INFO_ID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores database upgrade version information', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Server CPUs', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'CPU_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'DB_INFO_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Server Physical Memory in megabytes', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'PHYSICAL_MEMORY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the server on which the database was running when upgraded', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'SERVER_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SQL Server Edition', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'SQL_EDITION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SQL Server Service Pack in use at time of upgrade', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'SQL_SERVICE_PACK'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Version of SQL Server running at the time of the upgrade', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'SQL_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the database was upgraded', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'UPGRADE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Database Version', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'UPGRADE_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Server Virtual Memory in megabytes', 'SCHEMA', N'dbo', 'TABLE', N'DB_INFO', 'COLUMN', N'VIRTUAL_MEMORY'
GO
