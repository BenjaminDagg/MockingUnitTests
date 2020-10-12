CREATE TABLE [dbo].[MO_DailyARData]
(
[DailyARDataID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LocationID] [int] NOT NULL,
[SequenceNumber] [int] NOT NULL,
[DocumentNumber] [int] NOT NULL,
[CasinoGameID] [int] NOT NULL,
[DocumentCode] [int] NOT NULL,
[TransactionAmount] [int] NOT NULL,
[Transferred] [bit] NOT NULL CONSTRAINT [DF_MO_DailyARData_Transferred] DEFAULT ((0)),
[DateTransferred] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MO_DailyARData] ADD CONSTRAINT [PK_MO_DailyARData_1] PRIMARY KEY CLUSTERED  ([DailyARDataID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores daily AR data used in the MO Lottery market.', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for a specific game title', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'CasinoGameID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity column', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'DailyARDataID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date row was transferred', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'DateTransferred'
GO
EXEC sp_addextendedproperty N'MS_Description', N'6007 PulltabSales, 6008 Pulltab Cashes, 6009 Pulltab Commissions, 6010 Expired Vouchers', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'DocumentCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Julian Date YYDDD', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'DocumentNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lottery Property Identifier', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'LocationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence Number beginning with 1 and incrementing by 1. If records are for previous dates then the sequence number for them will start at 50000', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'SequenceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of the transaction', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'TransactionAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'True if row was transferred to central, False is row is still wainting to be transferred', 'SCHEMA', N'dbo', 'TABLE', N'MO_DailyARData', 'COLUMN', N'Transferred'
GO
