CREATE TABLE [dbo].[BANK]
(
[BANK_NO] [int] NOT NULL,
[BANK_DESCR] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PROG_FLAG] [bit] NOT NULL CONSTRAINT [DF_BANK_PROG_FLAG] DEFAULT ((0)),
[PROG_AMT] [money] NULL CONSTRAINT [DF_BANK_PROG_AMT] DEFAULT ((0)),
[LAST_JP_AMOUNT] [money] NULL,
[LAST_JP_TIME] [datetime] NULL,
[GAME_TYPE_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRODUCT_LINE_ID] [smallint] NOT NULL CONSTRAINT [DF_BANK_PRODUCT_LINE_ID] DEFAULT ((12)),
[IS_PAPER] [bit] NOT NULL CONSTRAINT [DF_BANK_IS_PAPER] DEFAULT ((1)),
[LOCKUP_AMOUNT] [smallmoney] NOT NULL CONSTRAINT [DF_BANK_LOCKUP_AMOUNT] DEFAULT ((600.01)),
[ENTRY_TICKET_FACTOR] [int] NOT NULL CONSTRAINT [DF_BANK_ENTRY_TICKET_FACTOR] DEFAULT ((100)),
[ENTRY_TICKET_AMOUNT] [smallmoney] NOT NULL CONSTRAINT [DF_BANK_ENTRY_TICKET_AMOUNT] DEFAULT ((0)),
[DBA_LOCKUP_AMOUNT] [money] NOT NULL CONSTRAINT [DF_BANK_DBA_LOCKUP_AMOUNT] DEFAULT ((0)),
[IS_ACTIVE] [bit] NOT NULL CONSTRAINT [DF_BANK_IS_ACTIVE] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BANK] ADD CONSTRAINT [CK_BANK_DBA_LOCKUP_AMOUNT] CHECK (([DBA_LOCKUP_AMOUNT]>=(0) AND [DBA_LOCKUP_AMOUNT]<=(1000000)))
GO
ALTER TABLE [dbo].[BANK] ADD CONSTRAINT [PK_BANK] PRIMARY KEY CLUSTERED  ([BANK_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Bank information for groups of EGMs', 'SCHEMA', N'dbo', 'TABLE', N'BANK', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Description - Setup by DG Technician.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'BANK_DESCR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK - Unique ID number identifying a Bank of Machines.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'BANK_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine balance amount that forces disabling the dba or $0 to turn feature off.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'DBA_LOCKUP_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If printing promo tickets, print if win amount is this amount or more.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'ENTRY_TICKET_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If printing promo tickets, print after this many plays.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'ENTRY_TICKET_FACTOR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links this Bank to a GAME_TYPE record.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'GAME_TYPE_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active flag indicates if the Bank is Active or has been inactivated.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'IS_ACTIVE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if Machines in this Bank dispense paper tabs.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'IS_PAPER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last Jackpot amount - no longer used.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'LAST_JP_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last Jackpot date and time - no longer used.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'LAST_JP_TIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lockup amount that applies to each Machine in the Bank.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'LOCKUP_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to Product Line table.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'PRODUCT_LINE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Progressive Amount - no longer used', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'PROG_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Progressive Flag - no longer used.', 'SCHEMA', N'dbo', 'TABLE', N'BANK', 'COLUMN', N'PROG_FLAG'
GO
