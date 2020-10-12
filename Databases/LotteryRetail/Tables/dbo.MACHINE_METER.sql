CREATE TABLE [dbo].[MACHINE_METER]
(
[MACHINE_METER_ID] [int] NOT NULL IDENTITY(1, 1),
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AMOUNT_PLAYED] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_PLAYED] DEFAULT ((0)),
[AMOUNT_WON] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_WON] DEFAULT ((0)),
[PLAY_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_METER_PLAY_COUNT] DEFAULT ((0)),
[AMOUNT_IN_TOTAL] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_IN_TOTAL] DEFAULT ((0)),
[AMOUNT_IN_1] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_IN_1] DEFAULT ((0)),
[AMOUNT_IN_2] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_IN_2] DEFAULT ((0)),
[AMOUNT_IN_5] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_IN_5] DEFAULT ((0)),
[AMOUNT_IN_10] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_IN_10] DEFAULT ((0)),
[AMOUNT_IN_20] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_IN_20] DEFAULT ((0)),
[AMOUNT_IN_50] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_IN_50] DEFAULT ((0)),
[AMOUNT_IN_100] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_IN_100] DEFAULT ((0)),
[AMOUNT_IN_OTHER] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_AMOUNT_IN_OTHER] DEFAULT ((0)),
[TICKET_IN_TOTAL] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_TICKET_IN_TOTAL] DEFAULT ((0)),
[TICKET_IN_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_METER_TICKET_IN_COUNT] DEFAULT ((0)),
[TICKET_OUT_TOTAL] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_TICKET_OUT_TOTAL] DEFAULT ((0)),
[TICKET_OUT_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_METER_TICKET_OUT_COUNT] DEFAULT ((0)),
[JACKPOT_TICKET_OUT] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_JACKPOT_TICKET_OUT] DEFAULT ((0)),
[JACKPOT_TICKET_COUNT] [int] NOT NULL CONSTRAINT [DF_MACHINE_METER_JACKPOT_TICKET_COUNT] DEFAULT ((0)),
[PROG_CONTRIBUTION] [money] NOT NULL CONSTRAINT [DF_MACHINE_METER_PROG_CONTRIBUTION] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MACHINE_METER] ADD CONSTRAINT [PK_MACHINE_METER] PRIMARY KEY CLUSTERED  ([MACHINE_METER_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MACHINE_METER_MACH_NO] ON [dbo].[MACHINE_METER] ([MACH_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores EGM meter totals data by EGM.', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of $1 bills accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_IN_1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of $10 bills accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_IN_10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of $100 bills accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_IN_100'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of $2 bills accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_IN_2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of $20 bills accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_IN_20'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of $5 bills accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_IN_5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of $50 bills accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_IN_50'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of other bills accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_IN_OTHER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of bill money accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_IN_TOTAL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount played in Dollars', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_PLAYED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount won in dollars', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'AMOUNT_WON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of Jackpot vouchers printed by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'JACKPOT_TICKET_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total dollar amount of Jackpot vouchers printed by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'JACKPOT_TICKET_OUT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DGE Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'MACHINE_METER_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of plays', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'PLAY_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Progressive Contribution made by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'PROG_CONTRIBUTION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of vouchers accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'TICKET_IN_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total dollar amount of vouchers accepted by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'TICKET_IN_TOTAL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of vouchers printed by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'TICKET_OUT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total dollar amount of vouchers printed by machine', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_METER', 'COLUMN', N'TICKET_OUT_TOTAL'
GO
