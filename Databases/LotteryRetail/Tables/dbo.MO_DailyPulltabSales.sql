CREATE TABLE [dbo].[MO_DailyPulltabSales]
(
[DailyPulltabSalesID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LocationID] [int] NOT NULL,
[MachNo] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CasinoMachNo] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountingDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CasinoGameID] [int] NOT NULL,
[GameDescription] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AmountPlayed] [int] NOT NULL,
[PlayCount] [int] NOT NULL,
[AmountWon] [int] NOT NULL,
[WinCount] [int] NOT NULL,
[CommissionsAmount] [int] NOT NULL,
[Transferred] [bit] NOT NULL CONSTRAINT [DF_MO_DailyPulltabSales_Transferred] DEFAULT ((0)),
[DateTransferred] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MO_DailyPulltabSales] ADD CONSTRAINT [PK_MO_DailyPulltabSales_1] PRIMARY KEY CLUSTERED  ([DailyPulltabSalesID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores daily pulltab sales data used in the MO Lottery market.', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting date and time', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'AccountingDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount Played in dollars (L,W,F,J)', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'AmountPlayed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total normal win dollars won (W)', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'AmountWon'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique game identifier', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'CasinoGameID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Casino machine number', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'CasinoMachNo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of retail commissions', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'CommissionsAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity column', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'DailyPulltabSalesID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time row was transferred', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'DateTransferred'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game description', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'GameDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'LocationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'MachNo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Plays (L,W,J,F)', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'PlayCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'True if row was transferred, False is row is still wainting to be transferred', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'Transferred'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Wins (W)', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'WinCount'
GO
