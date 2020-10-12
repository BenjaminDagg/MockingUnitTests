CREATE TABLE [dbo].[AccountingAdjustments]
(
[AccountingAdjustmentId] [int] NOT NULL IDENTITY(1, 1),
[CentralAccountingAdjustmentID] [int] NOT NULL,
[AdjustmentTypeId] [int] NOT NULL,
[SiteId] [int] NOT NULL,
[Amount] [money] NOT NULL,
[AdjustmentDate] [datetime] NOT NULL,
[Comment] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCommissionAffected] [bit] NOT NULL,
[CreatedByUserId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[ModifiedByUserId] [int] NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccountingAdjustments] ADD CONSTRAINT [PK_AccountingAdjustments] PRIMARY KEY CLUSTERED  ([AccountingAdjustmentId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
