CREATE TABLE [dbo].[MD_AccountingVarianceBalance]
(
[AccountingVarianceBalanceID] [int] NOT NULL IDENTITY(1, 1),
[Amount] [money] NOT NULL,
[AccountingDate] [datetime] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_MD_AccountingVarianceBalance_CreatedDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MD_AccountingVarianceBalance] ADD CONSTRAINT [PK_MD_AccountingVarianceBalance] PRIMARY KEY CLUSTERED  ([AccountingVarianceBalanceID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
