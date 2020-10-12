CREATE TABLE [dbo].[GAME_TYPE]
(
[GAME_TYPE_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LONG_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TYPE_ID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GAME_CATEGORY_ID] [int] NOT NULL CONSTRAINT [DF_GAME_TYPE_GAME_CATEGORY_ID] DEFAULT ((0)),
[PRODUCT_ID] [tinyint] NOT NULL,
[PROGRESSIVE_TYPE_ID] [int] NOT NULL CONSTRAINT [DF_GAME_TYPE_PROGRESSIVE_TYPE_ID] DEFAULT ((0)),
[BARCODE_TYPE_ID] [smallint] NOT NULL CONSTRAINT [DF_GAME_TYPE_BARCODE_TYPE_ID] DEFAULT ((0)),
[MAX_COINS_BET] [smallint] NOT NULL,
[MAX_LINES_BET] [tinyint] NOT NULL,
[MULTI_BET_DEALS] [bit] NOT NULL CONSTRAINT [DF_GAME_TYPE_MULTI_BET_DEALS] DEFAULT ((0)),
[SHOW_PAY_CREDITS] [bit] NOT NULL CONSTRAINT [DF_GAME_TYPE_SHOW_PAY_CREDITS] DEFAULT ((1)),
[IS_ACTIVE] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GAME_TYPE] ADD CONSTRAINT [PK_GAME_TYPE] PRIMARY KEY CLUSTERED  ([GAME_TYPE_CODE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GAME_TYPE] WITH NOCHECK ADD CONSTRAINT [FK_GAME_TYPE_PRODUCT] FOREIGN KEY ([PRODUCT_ID]) REFERENCES [dbo].[PRODUCT] ([PRODUCT_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defines the allowable denoms, coins bet, lines bet and other parameters for games belonging to a Game Type.', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Barcode Type identifier', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'BARCODE_TYPE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to GAME_CATEGORY table', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'GAME_CATEGORY_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK - 2 character Game Type Code ie 10', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'GAME_TYPE_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active flag indicates if this record is active or has been inactivated', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'IS_ACTIVE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Type descriptive text', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum number of Coins that can be bet on Forms that derive from this Game Type', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'MAX_COINS_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum number of Lines that can be bet on Forms that derive from this Game Type', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'MAX_LINES_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if Deals of this Game Type support multi-level betting', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'MULTI_BET_DEALS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links this Game Type to the PRODUCT table (0 Millennium, 1 Triple Play)', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'PRODUCT_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to PROGRESSIVE_TYPE table', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'PROGRESSIVE_TYPE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if Machine shows payscale and payouts in credits or dollars', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'SHOW_PAY_CREDITS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates type of Game (P)oker (S)lot or (K)eno', 'SCHEMA', N'dbo', 'TABLE', N'GAME_TYPE', 'COLUMN', N'TYPE_ID'
GO
