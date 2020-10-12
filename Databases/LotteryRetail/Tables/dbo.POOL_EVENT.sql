CREATE TABLE [dbo].[POOL_EVENT]
(
[POOL_EVENT_ID] [int] NOT NULL IDENTITY(1, 1),
[POOL_EVENT_TYPE_ID] [int] NOT NULL,
[PROGRESSIVE_POOL_ID] [int] NOT NULL,
[POOL_NUMBER] [tinyint] NOT NULL,
[POOL_EVENT_DATE_TIME] [datetime] NOT NULL CONSTRAINT [DF_POOL_EVENT_POOL_EVENT_DATE_TIME] DEFAULT (getdate()),
[ACCT_DATE] [datetime] NOT NULL,
[AMOUNT] [money] NOT NULL,
[LocationID] [int] NOT NULL CONSTRAINT [DF_POOL_EVENT_LocationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[POOL_EVENT] ADD CONSTRAINT [POOL_EVENT_PK] PRIMARY KEY CLUSTERED  ([POOL_EVENT_ID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores events for the Progressive Pool Event audit report.', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Date', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT', 'COLUMN', N'ACCT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Event dollar amount', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT', 'COLUMN', N'AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Event date and time', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT', 'COLUMN', N'POOL_EVENT_DATE_TIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT', 'COLUMN', N'POOL_EVENT_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to the POOL_EVENT_TYPE table', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT', 'COLUMN', N'POOL_EVENT_TYPE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pool Number', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT', 'COLUMN', N'POOL_NUMBER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to the PROGRESSIVE_POOL table', 'SCHEMA', N'dbo', 'TABLE', N'POOL_EVENT', 'COLUMN', N'PROGRESSIVE_POOL_ID'
GO
