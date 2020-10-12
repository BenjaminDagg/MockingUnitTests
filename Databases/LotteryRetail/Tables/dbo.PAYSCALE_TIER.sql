CREATE TABLE [dbo].[PAYSCALE_TIER]
(
[PAYSCALE_NAME] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TIER_LEVEL] [smallint] NOT NULL,
[COINS_WON] [int] NOT NULL,
[ICONS] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ICON_MASK] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TIER_WIN_TYPE] [tinyint] NOT NULL,
[USE_MULTIPLIER] [bit] NOT NULL,
[SCATTER_COUNT] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAYSCALE_TIER] ADD CONSTRAINT [PK_PayScaleTier] PRIMARY KEY CLUSTERED  ([PAYSCALE_NAME], [TIER_LEVEL]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Payscale Tier data used to validate EGM win amounts.', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Coins won for this Payscale and Tier Level', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER', 'COLUMN', N'COINS_WON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'String of Icon Mask numbers', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER', 'COLUMN', N'ICON_MASK'
GO
EXEC sp_addextendedproperty N'MS_Description', N'String of Icon numbers', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER', 'COLUMN', N'ICONS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links this Payscale Tier to a PAYSCALE table record', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER', 'COLUMN', N'PAYSCALE_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'For win types of Scatter, indicates how many icons are required to be scattered in the display on the machine', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER', 'COLUMN', N'SCATTER_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tier Level', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER', 'COLUMN', N'TIER_LEVEL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to TIER_WIN_TYPE table, indicates what type of win this Tier represents (Normal, Bonus, Scatter, etc.)', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER', 'COLUMN', N'TIER_WIN_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if the Multiplier specified on the Form is to be used or if the absolute value of the COINS_WON should be used', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE_TIER', 'COLUMN', N'USE_MULTIPLIER'
GO
