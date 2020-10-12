CREATE TABLE [dbo].[AccountingAdjustmentType]
(
[AccountingAdjustmentTypeId] [int] NOT NULL IDENTITY(1, 1),
[AdjustmentDescription] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccountingAdjustmentType] ADD CONSTRAINT [PK_AccountingAdjustmentType] PRIMARY KEY CLUSTERED  ([AccountingAdjustmentTypeId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the adjustment types.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentType', 'COLUMN', N'AccountingAdjustmentTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The adjustment type description.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentType', 'COLUMN', N'AdjustmentDescription'
GO
