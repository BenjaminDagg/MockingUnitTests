CREATE TABLE [dbo].[PAYSCALE_TIER_KENO]
(
[PAYSCALE_NAME] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TIER_LEVEL] [smallint] NOT NULL,
[PICK_COUNT] [smallint] NOT NULL,
[HIT_COUNT] [smallint] NOT NULL,
[AWARD_FACTOR] [decimal] (6, 1) NOT NULL CONSTRAINT [DF_PAYSCALE_TIER_KENO_WIN_FACTOR] DEFAULT ((0)),
[TIER_WIN_TYPE] [tinyint] NOT NULL CONSTRAINT [DF_PAYSCALE_TIER_KENO_TIER_WIN_TYPE] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAYSCALE_TIER_KENO] ADD CONSTRAINT [PK_PAYSCALE_TIER_KENO] PRIMARY KEY CLUSTERED  ([PAYSCALE_NAME], [TIER_LEVEL]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Keno Payscale Tier data used to validate EGM win amounts.', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER_KENO', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Factor to multiply by bet amount to calculate the amount won', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER_KENO', 'COLUMN', N'AWARD_FACTOR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of spots matched', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER_KENO', 'COLUMN', N'HIT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links this Payscale Tier to a PAYSCALE table record', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER_KENO', 'COLUMN', N'PAYSCALE_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of spots picked', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER_KENO', 'COLUMN', N'PICK_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tier Level', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER_KENO', 'COLUMN', N'TIER_LEVEL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to TIER_WIN_TYPE table, indicates what type of win this Tier represents (Normal, Bonus, Scatter, Jackpot, etc.)', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER_KENO', 'COLUMN', N'TIER_WIN_TYPE'
GO
