CREATE TABLE [dbo].[MO_DailyPulltabSales]
(
[PrimaryDailyPulltabSalesID] [int] NOT NULL IDENTITY(1, 1),
[DailyPulltabSalesID] [int] NOT NULL,
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
[Processed] [bit] NOT NULL CONSTRAINT [DF_MO_DailyPulltabSales_Transferred] DEFAULT ((0)),
[DateProcessed] [datetime] NULL,
[PulltabSalesFilename] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MO_DailyPulltabSales] ADD CONSTRAINT [PK_MO_DailyPulltabSales] PRIMARY KEY CLUSTERED  ([PrimaryDailyPulltabSalesID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MO_DailyPulltabSales_SalesId_LocationId] ON [dbo].[MO_DailyPulltabSales] ([DailyPulltabSalesID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting date', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'AccountingDate'
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
EXEC sp_addextendedproperty N'MS_Description', N'Identity column replicated from retail location', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'DailyPulltabSalesID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time row was processed', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'DateProcessed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game description', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'GameDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location identifier', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'LocationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'MachNo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Plays (L,W,J,F)', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'PlayCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity column', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'PrimaryDailyPulltabSalesID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'True if row was processed, False is row is still wainting to be processed.', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'Processed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of file the rows were processed into', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'PulltabSalesFilename'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Wins (W)', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyPulltabSales', 'COLUMN', N'WinCount'
GO
