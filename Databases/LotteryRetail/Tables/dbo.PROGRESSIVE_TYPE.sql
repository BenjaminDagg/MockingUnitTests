CREATE TABLE [dbo].[PROGRESSIVE_TYPE]
(
[PROGRESSIVE_TYPE_ID] [int] NOT NULL,
[LONG_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[POOL_COUNT] [smallint] NOT NULL,
[TOTAL_CONTRIBUTION] [decimal] (5, 4) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PROGRESSIVE_TYPE] ADD CONSTRAINT [PK_PROGRESSIVE_MODEL] PRIMARY KEY CLUSTERED  ([PROGRESSIVE_TYPE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table for PROGRESSIVE_POOL entries.', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_TYPE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Progressive Descripton', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_TYPE', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of pools per denomination for this Progressive Model', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_TYPE', 'COLUMN', N'POOL_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Progressive Model Identifier', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_TYPE', 'COLUMN', N'PROGRESSIVE_TYPE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Contribution percentage', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_TYPE', 'COLUMN', N'TOTAL_CONTRIBUTION'
GO
