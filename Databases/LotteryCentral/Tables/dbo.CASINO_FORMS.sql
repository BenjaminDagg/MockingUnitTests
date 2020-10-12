CREATE TABLE [dbo].[CASINO_FORMS]
(
[FORM_NUMB] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEAL_TYPE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COST_PER_TAB] [smallmoney] NULL,
[NUMB_ROLLS] [int] NOT NULL,
[TABS_PER_ROLL] [int] NOT NULL,
[TABS_PER_DEAL] [int] NULL,
[WINS_PER_DEAL] [int] NULL,
[TOTAL_AMT_IN] [money] NULL,
[TOTAL_AMT_OUT] [money] NULL,
[FORM_DESC] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAB_AMT] [smallmoney] NULL,
[IS_REV_SHARE] [bit] NOT NULL CONSTRAINT [DF_CASINO_FORMS_IS_REV_SHARE] DEFAULT ((0)),
[DGE_REV_PERCENT] [tinyint] NULL,
[JP_AMOUNT] [money] NULL,
[JACKPOT_COUNT] [int] NOT NULL CONSTRAINT [DF_CASINO_FORMS_JACKPOT_COUNT] DEFAULT ((0)),
[GAME_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DENOMINATION] [smallmoney] NOT NULL,
[COINS_BET] [smallint] NOT NULL CONSTRAINT [DF_CASINO_FORMS_COINS_BET] DEFAULT ((1)),
[LINES_BET] [tinyint] NOT NULL CONSTRAINT [DF_CASINO_FORMS_LINES_BET] DEFAULT ((1)),
[GAME_TYPE_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAYSCALE_MULTIPLIER] [tinyint] NULL,
[HOLD_PERCENT] [decimal] (7, 4) NULL,
[MASTER_DEAL_ID] [int] NOT NULL CONSTRAINT [DF_CASINO_FORMS_MASTER_DEAL_ID] DEFAULT ((0)),
[BINGO_MASTER_ID] [int] NOT NULL CONSTRAINT [DF_CASINO_FORMS_BINGO_MASTER_ID] DEFAULT ((0)),
[IS_PAPER] [bit] NOT NULL CONSTRAINT [DF_CASINO_FORMS_IS_PAPER] DEFAULT ((1)),
[TAB_TYPE_ID] [int] NOT NULL CONSTRAINT [DF_CASINO_FORMS_TAB_TYPE_ID] DEFAULT ((-1)),
[MASTER_HASH] [binary] (20) NULL,
[MASTER_CHECKSUM] [binary] (20) NULL,
[IS_ACTIVE] [bit] NOT NULL CONSTRAINT [DF_CASINO_FORMS_IsActive] DEFAULT ((1)),
[ReelAnimationTypeID] [int] NOT NULL CONSTRAINT [DF_CASINO_FORMS_ReelAnimationTypeID] DEFAULT ((2))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASINO_FORMS] ADD CONSTRAINT [PK_CASINO_FORMS] PRIMARY KEY CLUSTERED  ([FORM_NUMB]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Form data including Denom, CoinsBet, LinesBet, Rolls per Deal, Tabs per Roll, etc. that is common to Deals belonging to that Form.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to BINGO_MASTER table or 0 if no association exists', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'BINGO_MASTER_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Coins Bet', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'COINS_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DGE Revenue  per tab for Pay per Play forms', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'COST_PER_TAB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Type (P)oker (S)lot (K)eno', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'DEAL_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Denomination', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'DENOMINATION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Specifies DGE Revenue Percent when IsRevenueShare = 1', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'DGE_REV_PERCENT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptioin of the form', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'FORM_DESC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK - Form Number', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'FORM_NUMB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Code (Millennium Only)', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'GAME_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent GameTypecode of the Form', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'GAME_TYPE_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hold Percent', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'HOLD_PERCENT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active flag', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'IS_ACTIVE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Paper vs Electronic flag', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'IS_PAPER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if Diamond Game is sharing revenue or is paid per play (0 = Pay per Play, 1= Revenue Share)', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'IS_REV_SHARE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Jackpots per Deal', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'JACKPOT_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Jackpot amount', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'JP_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Lines Bet', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'LINES_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SHA-1 checksum of the master deal', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'MASTER_CHECKSUM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to MASTER_DEAL table or 0 if no association exists', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'MASTER_DEAL_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SHA-1 hash from the Master Deal of the Form', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'MASTER_HASH'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Rolls per Deal', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'NUMB_ROLLS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payscale Multiplier - used to validate win amounts', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'PAYSCALE_MULTIPLIER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies the type reel animation used.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'ReelAnimationTypeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The cost to the player to purchase a single tab', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'TAB_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies the type and size of paper tabs', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'TAB_TYPE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Tabs per Deal', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'TABS_PER_DEAL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Tabs per Roll', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'TABS_PER_ROLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total dollars required to play all tabs in a deal based upon this form', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'TOTAL_AMT_IN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total dollars that will be payed out when all tabs in a deal based upon this form have been played', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'TOTAL_AMT_OUT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Wins per Deal', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_FORMS', 'COLUMN', N'WINS_PER_DEAL'
GO
