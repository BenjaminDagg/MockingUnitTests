CREATE TABLE [dbo].[POOL_EVENT_TYPE]
(
[POOL_EVENT_TYPE_ID] [int] NOT NULL,
[LONG_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[POOL_EVENT_TYPE] ADD CONSTRAINT [POOL_EVENT_TYPE_PK] PRIMARY KEY CLUSTERED  ([POOL_EVENT_TYPE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table for POOL_EVENT entries.', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT_TYPE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Event Description', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT_TYPE', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Integer', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT_TYPE', 'COLUMN', N'POOL_EVENT_TYPE_ID'
GO
