CREATE TABLE [dbo].[JobStatus]
(
[JobStatusID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LocationID] [int] NOT NULL,
[ServerName] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Success] [bit] NOT NULL,
[DateDataCollectedFor] [datetime] NULL,
[ExecutedDate] [datetime] NOT NULL,
[DatabaseName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobStatus] ADD CONSTRAINT [PK_JobStatus] PRIMARY KEY CLUSTERED  ([JobStatusID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
