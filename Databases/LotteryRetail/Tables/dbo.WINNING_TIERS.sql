CREATE TABLE [dbo].[WINNING_TIERS]
(
[WINNING_TIER_ID] [int] NOT NULL IDENTITY(1, 1),
[NUMB_OF_WINNERS] [int] NOT NULL,
[WINNING_AMOUNT] [money] NOT NULL,
[FORM_NUMB] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TIER_LEVEL] [smallint] NULL,
[COINS_WON] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WINNING_TIERS] ADD CONSTRAINT [PK_WINNING_TIERS] PRIMARY KEY CLUSTERED  ([WINNING_TIER_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_WINNING_TIERS] ON [dbo].[WINNING_TIERS] ([FORM_NUMB], [NUMB_OF_WINNERS], [WINNING_AMOUNT]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_WINNING_TIERS_FORM_NUMB_TIER_LEVEL] ON [dbo].[WINNING_TIERS] ([FORM_NUMB], [TIER_LEVEL]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WINNING_TIERS] WITH NOCHECK ADD CONSTRAINT [FK_WINNING_TIERS_CASINO_FORMS] FOREIGN KEY ([FORM_NUMB]) REFERENCES [dbo].[CASINO_FORMS] ([FORM_NUMB])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Form Tier data.', 'SCHEMA', N'dbo', 'TABLE', N'WINNING_TIERS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of coins won for a single win at this Tier Level', 'SCHEMA', N'dbo', 'TABLE', N'WINNING_TIERS', 'COLUMN', N'COINS_WON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Form Number to which this Tier belongs', 'SCHEMA', N'dbo', 'TABLE', N'WINNING_TIERS', 'COLUMN', N'FORM_NUMB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of times this Tier will occur in a Deal', 'SCHEMA', N'dbo', 'TABLE', N'WINNING_TIERS', 'COLUMN', N'NUMB_OF_WINNERS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tier sequence number', 'SCHEMA', N'dbo', 'TABLE', N'WINNING_TIERS', 'COLUMN', N'TIER_LEVEL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar Amount of a single win', 'SCHEMA', N'dbo', 'TABLE', N'WINNING_TIERS', 'COLUMN', N'WINNING_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'WINNING_TIERS', 'COLUMN', N'WINNING_TIER_ID'
GO
