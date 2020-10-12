CREATE TABLE [dbo].[MO_DailyARData]
(
[PrimaryDailyARDataID] [int] NOT NULL IDENTITY(1, 1),
[DailyARDataID] [int] NOT NULL,
[LocationID] [int] NOT NULL,
[SequenceNumber] [int] NOT NULL,
[DocumentNumber] [int] NOT NULL,
[CasinoGameID] [int] NOT NULL,
[DocumentCode] [int] NOT NULL,
[TransactionAmount] [int] NOT NULL,
[TransactionDate] [int] NULL,
[Processed] [bit] NOT NULL CONSTRAINT [DF_MO_DailyARData_Transferred] DEFAULT ((0)),
[DateProcessed] [datetime] NULL,
[ARFilename] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the file the was included in', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'ARFilename'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique game indetifier', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'CasinoGameID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Replicated retail DB PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'DailyARDataID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time row was processed.', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'DateProcessed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'6007 Amount Played, 6008 Amount Won, 6009 Retail Commissions, 6010 Expired Vouchers', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'DocumentCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Julian Date YYDDD – Accounting Date – Actual Date of Sales', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'DocumentNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location identifier', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'LocationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'PrimaryDailyARDataID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Set to true if the row was processed', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'Processed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number beginning with 1 and incrementing by 1 for each retailer. If records are for previous dates, then the sequence number for them will start at 50000', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'SequenceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of Transaction', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'TransactionAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the file was received by central', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'TransactionDate'
GO
