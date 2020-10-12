CREATE TABLE [dbo].[MD_DailyAccounting]
(
[MDDailyAccountingID] [int] NOT NULL IDENTITY(1, 1),
[RetailMDDailyAccountingID] [int] NOT NULL,
[LocationID] [int] NOT NULL,
[RetailerNumber] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DGMachineNumber] [int] NOT NULL,
[AmountPlayed] [money] NOT NULL,
[AmountWon] [money] NOT NULL,
[VouchersIssuedAmount] [money] NOT NULL,
[VouchersIssuedCount] [int] NOT NULL,
[VoucherLiabilitiesAmount] [money] NOT NULL,
[VoucherLiabilitiesCount] [int] NOT NULL,
[VouchersRedeemedAmount] [money] NOT NULL,
[VouchersRedeemedCount] [int] NOT NULL,
[ExpiredVouchersAmount] [money] NOT NULL,
[ExpiredVouchersCount] [int] NOT NULL,
[SalesCommissions] [money] NOT NULL,
[CashingCommissions] [money] NOT NULL,
[Bonus] [money] NOT NULL,
[ITLMLeaseFee] [money] NOT NULL,
[MLGCAShare] [money] NOT NULL,
[AccountingDate] [datetime] NOT NULL,
[SolomonFileName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processed] [bit] NOT NULL CONSTRAINT [DF_MD_DailyAccounting_Processed] DEFAULT ((0)),
[DateProcessed] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MD_DailyAccounting] ADD CONSTRAINT [PK_MD_DailyAccounting] PRIMARY KEY CLUSTERED  ([MDDailyAccountingID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
