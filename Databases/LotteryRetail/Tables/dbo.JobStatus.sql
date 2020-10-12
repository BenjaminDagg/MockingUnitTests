CREATE TABLE [dbo].[JobStatus]
(
[JobStatusID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LocationID] [int] NOT NULL,
[ServerName] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Success] [bit] NOT NULL CONSTRAINT [DF_JobStatus_Success] DEFAULT ((0)),
[DateDataCollectedFor] [datetime] NULL,
[ExecutedDate] [datetime] NOT NULL CONSTRAINT [DF_JobStatus_ExecutedDate] DEFAULT (getdate()),
[DatabaseName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobStatus] ADD CONSTRAINT [PK_JobStatus] PRIMARY KEY CLUSTERED  ([JobStatusID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains status and execution history for specific Sql Jobs.', 'SCHEMA', N'dbo', 'TABLE', N'JobStatus', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the database used by task.', 'SCHEMA', N'dbo', 'TABLE', N'JobStatus', 'COLUMN', N'DatabaseName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date used to collect data', 'SCHEMA', N'dbo', 'TABLE', N'JobStatus', 'COLUMN', N'DateDataCollectedFor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date task was executed', 'SCHEMA', N'dbo', 'TABLE', N'JobStatus', 'COLUMN', N'ExecutedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the job or stored procedure being executed', 'SCHEMA', N'dbo', 'TABLE', N'JobStatus', 'COLUMN', N'JobName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indentity Column', 'SCHEMA', N'dbo', 'TABLE', N'JobStatus', 'COLUMN', N'JobStatusID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lottery Property Identifier', 'SCHEMA', N'dbo', 'TABLE', N'JobStatus', 'COLUMN', N'LocationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the server', 'SCHEMA', N'dbo', 'TABLE', N'JobStatus', 'COLUMN', N'ServerName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores True or False if the task executed was successful', 'SCHEMA', N'dbo', 'TABLE', N'JobStatus', 'COLUMN', N'Success'
GO
