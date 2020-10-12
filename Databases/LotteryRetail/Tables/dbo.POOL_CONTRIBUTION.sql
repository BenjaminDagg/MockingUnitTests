CREATE TABLE [dbo].[POOL_CONTRIBUTION]
(
[POOL_CONBTRIBUTION_ID] [int] NOT NULL IDENTITY(1, 1),
[PROGRESSIVE_POOL_ID] [int] NOT NULL,
[POOL_NUMBER] [tinyint] NOT NULL,
[ACCT_DATE] [datetime] NOT NULL,
[AMOUNT] [money] NOT NULL,
[LocationID] [int] NOT NULL CONSTRAINT [DF_POOL_CONTRIBUTION_LocationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[POOL_CONTRIBUTION] ADD CONSTRAINT [POOL_CONTRIBUTION_PK] PRIMARY KEY CLUSTERED  ([POOL_CONBTRIBUTION_ID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Progressive pool contribution audit table.', 'SCHEMA', N'dbo', 'TABLE', N'POOL_CONTRIBUTION', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Date', 'SCHEMA', N'dbo', 'TABLE', N'POOL_CONTRIBUTION', 'COLUMN', N'ACCT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount', 'SCHEMA', N'dbo', 'TABLE', N'POOL_CONTRIBUTION', 'COLUMN', N'AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'POOL_CONTRIBUTION', 'COLUMN', N'POOL_CONBTRIBUTION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pool Number', 'SCHEMA', N'dbo', 'TABLE', N'POOL_CONTRIBUTION', 'COLUMN', N'POOL_NUMBER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to the Progressive Pool table', 'SCHEMA', N'dbo', 'TABLE', N'POOL_CONTRIBUTION', 'COLUMN', N'PROGRESSIVE_POOL_ID'
GO
