CREATE TABLE [dbo].[AccountingAdjustments]
(
[AccountingAdjustmentId] [int] NOT NULL IDENTITY(1, 1),
[AdjustmentTypeId] [int] NOT NULL,
[SiteId] [int] NOT NULL,
[Amount] [money] NOT NULL,
[AdjustmentDate] [datetime] NOT NULL,
[RetailerNumber] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comment] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCommissionAffected] [bit] NOT NULL,
[CreatedByUserId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[ModifiedByUserId] [int] NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
[IsActive] [bit] NOT NULL,
[Transferred] [bit] NOT NULL CONSTRAINT [DF_AccountingAdjustments_Transferred] DEFAULT ((0)),
[DateTransferred] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccountingAdjustments] ADD CONSTRAINT [PK_AccountingAdjustments] PRIMARY KEY CLUSTERED  ([AccountingAdjustmentId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the adjustments.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'AccountingAdjustmentId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the adjustment is applied to.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'AdjustmentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity of the adjustment type.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'AdjustmentTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of the adjustment.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The comment for the adjustment.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user that created the adjustment.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'CreatedByUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the adjustment was created.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'CreatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the adjustment has been transferred.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'DateTransferred'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The flag for the adjustment being active or not.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'IsActive'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The flag for commission being affected by this adjustment.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'IsCommissionAffected'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user that has updated the adjustment last.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'ModifiedByUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the adjustment was last updated.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent retailer number for this adjustment.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'RetailerNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent identity id for the adjustment.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'SiteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The flag for the adjustment being updated.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustments', 'COLUMN', N'Transferred'
GO
