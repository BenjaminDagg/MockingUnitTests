CREATE TABLE [dbo].[JACKPOT]
(
[TRANS_NO] [int] NOT NULL,
[DTIMESTAMP] [datetime] NOT NULL,
[CARD_ACCT_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CASINO_MACH_NO] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEAL_NO] [int] NOT NULL,
[TICKET_NO] [int] NOT NULL,
[PLAY_COST] [smallmoney] NOT NULL,
[TRANS_ID] [smallint] NOT NULL,
[TRANS_AMT] [money] NOT NULL,
[PROG_AMT] [money] NOT NULL CONSTRAINT [DF_JACKPOT_PROG_AMT] DEFAULT ((0)),
[LOCATION_ID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JACKPOT] ADD CONSTRAINT [PK_JACKPOT] PRIMARY KEY CLUSTERED  ([TRANS_NO], [LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JACKPOT_DTIMESTAMP] ON [dbo].[JACKPOT] ([DTIMESTAMP]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Jackpot audit table.', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Card Account Number in use when event occurred', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'CARD_ACCT_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Casino Machine Number in use on Machine when event occurred', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'CASINO_MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number being played', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time that the Jackpot or Win that exceeded Lockup amount occurred', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'DTIMESTAMP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location identifier', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DGE Machine Number at which event occurred', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of money wagered', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'PLAY_COST'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Progressive Amount in dollars', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'PROG_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ticket Number', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'TICKET_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction amount in dollars', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'TRANS_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to TRANS table, identifies if row is for a Jackpot or a normal Win', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'TRANS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to CASINO_TRANS table', 'SCHEMA', N'dbo', 'TABLE', N'JACKPOT', 'COLUMN', N'TRANS_NO'
GO
