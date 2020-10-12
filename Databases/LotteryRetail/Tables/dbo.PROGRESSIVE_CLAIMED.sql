CREATE TABLE [dbo].[PROGRESSIVE_CLAIMED]
(
[PROGRESSIVE_CLAIMED_ID] [int] NOT NULL IDENTITY(1, 1),
[POOL_EVENT_ID] [int] NOT NULL,
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CASINO_MACH_NO] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CLAIMED_DATE] [datetime] NOT NULL CONSTRAINT [DF_PROGRESSIVE_CLAIMED_CREATE_DATE] DEFAULT (getdate()),
[ACCT_DATE] [datetime] NOT NULL,
[PROGRESSIVE_POOL_ID] [int] NOT NULL,
[AMOUNT_CLAIMED] [money] NOT NULL,
[BANK_NO] [int] NOT NULL,
[GAME_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DENOMINATION] [smallmoney] NOT NULL,
[COINS_BET] [smallint] NOT NULL,
[LINES_BET] [smallint] NOT NULL,
[LocationID] [int] NOT NULL CONSTRAINT [DF_PROGRESSIVE_CLAIMED_LocationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PROGRESSIVE_CLAIMED] ADD CONSTRAINT [PK_PROGRESSIVE_CLAIMED] PRIMARY KEY CLUSTERED  ([PROGRESSIVE_CLAIMED_ID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores audit information for all progressive wins claimed.', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Date', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'ACCT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Claimed amount in Dollars', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'AMOUNT_CLAIMED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Number of the machine when claimed', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'BANK_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Casino assigned machine number', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'CASINO_MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and Time row was added', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'CLAIMED_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of coins bet when claimed', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'COINS_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Denomination of the play when claimed', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'DENOMINATION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game code of the machine when claimed', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'GAME_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of lines bet when claimed', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'LINES_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Identifier', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to the POOL_EVENT table.', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'POOL_EVENT_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'PROGRESSIVE_CLAIMED_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to Progressive Pool table', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_CLAIMED', 'COLUMN', N'PROGRESSIVE_POOL_ID'
GO
