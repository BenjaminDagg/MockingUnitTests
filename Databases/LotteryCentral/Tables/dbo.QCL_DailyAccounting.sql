CREATE TABLE [dbo].[QCL_DailyAccounting]
(
[QCLDailyAccountingID] [int] NOT NULL IDENTITY(1, 1),
[RetailQCLDailyAccountingID] [int] NOT NULL,
[LocationId] [int] NOT NULL,
[MachineNumber] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CasinoMachineNumber] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GameDescription] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GameTitleId] [int] NOT NULL,
[FormNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DealNumber] [int] NOT NULL,
[TabTypeId] [int] NOT NULL,
[GameCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GameTypeCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HoldPercent] [decimal] (7, 4) NOT NULL,
[AmountPlayed] [money] NOT NULL,
[AmountWon] [money] NOT NULL,
[AmountJackpot] [money] NOT NULL,
[AmountProg] [money] NOT NULL,
[PlayCount] [int] NOT NULL,
[WinCount] [int] NOT NULL,
[JackpotCount] [int] NOT NULL,
[PurchaseAmount] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CommissionsAmount] [money] NOT NULL,
[AccountingDate] [datetime] NOT NULL,
[Processed] [bit] NOT NULL,
[DateProcessed] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QCL_DailyAccounting] ADD CONSTRAINT [PK_QCL_DailyAccounting] PRIMARY KEY CLUSTERED  ([QCLDailyAccountingID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
