CREATE TABLE [dbo].[AccountingAdjustmentHistory]
(
[AccountingAdjustmentChangeId] [int] NOT NULL IDENTITY(1, 1),
[AccountingAdjustmentId] [int] NOT NULL,
[ChangeColumn] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PreviousValue] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeValue] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDate] [datetime] NOT NULL,
[ChangedByAppUserId] [int] NOT NULL,
[IpAddress] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccountingAdjustmentHistory] ADD CONSTRAINT [PK_AccountingAdjustmentHistory] PRIMARY KEY CLUSTERED  ([AccountingAdjustmentChangeId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the history of adjustment activity.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentHistory', 'COLUMN', N'AccountingAdjustmentChangeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identity of the adjustment that was changed/created.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentHistory', 'COLUMN', N'AccountingAdjustmentId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The column of the adjustment that was changed.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentHistory', 'COLUMN', N'ChangeColumn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time of the adjustment change.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentHistory', 'COLUMN', N'ChangeDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user that changed the adjustment.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentHistory', 'COLUMN', N'ChangedByAppUserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The new data value of the adjustment change.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentHistory', 'COLUMN', N'ChangeValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ip address of the user that changed the adjustemnt.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentHistory', 'COLUMN', N'IpAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The previous value of the adjustment change.', 'SCHEMA', N'dbo', 'TABLE', N'AccountingAdjustmentHistory', 'COLUMN', N'PreviousValue'
GO
