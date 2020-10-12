CREATE TABLE [dbo].[CASINO]
(
[CAS_ID] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CAS_NAME] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS1] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS2] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONTACT_NAME] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FAX] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SETASDEFAULT] [bit] NOT NULL,
[LOCKUP_AMT] [smallmoney] NOT NULL CONSTRAINT [DF_CASINO_LOCKUP_AMT] DEFAULT ((12000)),
[FROM_TIME] [datetime] NULL,
[TO_TIME] [datetime] NULL,
[CLAIM_TIMEOUT] [smallint] NOT NULL CONSTRAINT [DF_CASINO_CLAIM_TIMEOUT] DEFAULT ((0)),
[DAUB_TIMEOUT] [smallint] NOT NULL CONSTRAINT [DF_CASINO_DAUB_TIMEOUT] DEFAULT ((90)),
[CARD_TYPE] [tinyint] NOT NULL CONSTRAINT [DF_CASINO_CARD_TYPE] DEFAULT ((1)),
[PLAYER_CARD] [bit] NOT NULL CONSTRAINT [DF_CASINO_PLAYER_CARD] DEFAULT ((0)),
[REPRINT_TICKET] [bit] NULL CONSTRAINT [DF_CASINO_REPRINT_TICKET] DEFAULT ((1)),
[RECEIPT_PRINTER] [bit] NOT NULL CONSTRAINT [DF_CASINO_RECEIPT_PRINTER] DEFAULT ((0)),
[DISPLAY_PROGRESSIVE] [bit] NOT NULL CONSTRAINT [DF_CASINO_DISPLAY_PROGRESSIVE] DEFAULT ((0)),
[PT_AWARD_TYPE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPI_ID] [int] NOT NULL CONSTRAINT [DF_CASINO_TPI_ID] DEFAULT ((0)),
[TPI_PROPERTY_ID] [int] NOT NULL CONSTRAINT [DF_CASINO_TPI_PROPERTY_ID] DEFAULT ((0)),
[PROMOTIONAL_PLAY] [bit] NOT NULL CONSTRAINT [DF_CASINO_PROMOTIONAL_PLAY] DEFAULT ((0)),
[PIN_REQUIRED] [bit] NOT NULL CONSTRAINT [DF_CASINO_PIN_PLAY] DEFAULT ((0)),
[RS_AND_PPP] [bit] NOT NULL CONSTRAINT [DF_CASINO_RS_AND_PPP] DEFAULT ((0)),
[PPP_AMOUNT] [smallmoney] NOT NULL CONSTRAINT [DF_CASINO_PPP_AMOUNT] DEFAULT ((0)),
[JACKPOT_LOCKUP] [bit] NOT NULL CONSTRAINT [DF_CASINO_JACKPOT_LOCKUP] DEFAULT ((1)),
[CASHOUT_TIMEOUT] [int] NOT NULL CONSTRAINT [DF_CASINO_CASHOUT_TIMEOUT] DEFAULT ((0)),
[AMUSEMENT_TAX_PCT] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_CASINO_AMUSEMENT_TAX_PCT] DEFAULT ((0)),
[AUTO_DROP] [bit] NOT NULL CONSTRAINT [DF_CASINO_AUTO_DROP] DEFAULT ((1)),
[SUMMARIZE_PLAY] [bit] NOT NULL CONSTRAINT [DF_CASINO_SUMMARIZE_PLAY] DEFAULT ((1)),
[PRINT_PROMO_TICKETS] [bit] NOT NULL CONSTRAINT [DF_CASINO_PROMO_TICKETS] DEFAULT ((0)),
[BINGO_FREE_SQUARE] [bit] NOT NULL CONSTRAINT [DF_CASINO_BINGO_FREE_SQUARE] DEFAULT ((0)),
[PRINT_REDEMPTION_TICKETS] [bit] NOT NULL CONSTRAINT [DF_CASINO_PRINT_REDEEM_TICKETS] DEFAULT ((0)),
[PRINT_RAFFLE_TICKETS] [bit] NOT NULL CONSTRAINT [DF_CASINO_PRINT_RAFFLE_TICKETS] DEFAULT ((0)),
[AUTHENTICATE_APPS] [bit] NOT NULL CONSTRAINT [DF_CASINO_AUTHENTICATE_APPS] DEFAULT ((1)),
[PROG_REQUEST_SECONDS] [smallint] NOT NULL CONSTRAINT [DF_CASINO_PROG_REQUEST_SECONDS] DEFAULT ((5)),
[MAX_BAL_ADJUSTMENT] [money] NOT NULL CONSTRAINT [DF_CASINO_MAX_BAL_ADJUSTMENT] DEFAULT ((1000)),
[MIN_DI_VERSION] [int] NOT NULL CONSTRAINT [DF_CASINO_MIN_DI_VERSION] DEFAULT ((3040)),
[LOCATION_ID] [int] NOT NULL CONSTRAINT [DF_CASINO_PROPERTY_ID] DEFAULT ((1000)),
[PAYOUT_THRESHOLD] [money] NOT NULL CONSTRAINT [DF_CASINO_PAYOUT_THRESHOLD] DEFAULT ((10000.00)),
[RETAIL_REV_SHARE] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_CASINO_RETAIL_REV_SHARE] DEFAULT ((20.00)),
[SWEEP_ACCT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CASINO_BANK_ACCT_NBR] DEFAULT (''),
[RETAILER_NUMBER] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CASINO_RETAILER_NUMBER] DEFAULT ('00000'),
[API_KEY] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CASINO_API_KEY] DEFAULT (newid())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASINO] ADD CONSTRAINT [CK_CASINO_CLAIM_TIMEOUT] CHECK (([CLAIM_TIMEOUT]>=(0) AND [CLAIM_TIMEOUT]<=(999)))
GO
ALTER TABLE [dbo].[CASINO] ADD CONSTRAINT [CK_CASINO_DAUB_TIMEOUT] CHECK (([DAUB_TIMEOUT]>=(0) AND [DAUB_TIMEOUT]<=(999)))
GO
ALTER TABLE [dbo].[CASINO] ADD CONSTRAINT [CK_CASINO_PAYOUT_THRESHOLD] CHECK (([PAYOUT_THRESHOLD]>=(0.01)))
GO
ALTER TABLE [dbo].[CASINO] ADD CONSTRAINT [CK_CASINO_PROG_REQ_SECONDS] CHECK (([PROG_REQUEST_SECONDS]>=(5) AND [PROG_REQUEST_SECONDS]<=(30)))
GO
ALTER TABLE [dbo].[CASINO] ADD CONSTRAINT [PK_CASINO] PRIMARY KEY CLUSTERED  ([CAS_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CASINO_LOCATION_ID] ON [dbo].[CASINO] ([LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CASINO_RETAILER_NUMBER] ON [dbo].[CASINO] ([RETAILER_NUMBER]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores retail location specific information', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address 1', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'ADDRESS1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address 2', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'ADDRESS2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amusement Tax Percentage', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'AMUSEMENT_TAX_PCT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if applications require authentication - not used - auth now forced', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'AUTHENTICATE_APPS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if Cash Door open event triggers a Drop event', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'AUTO_DROP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if Bingo cards have a free center square', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'BINGO_FREE_SQUARE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Card Type 0 = Smartcard 1 = MagStripe', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'CARD_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Casino Identifier', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'CAS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Name', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'CAS_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Timeout in minutes before machine automatically cashes out. If 0 then machine never automatically cashes out.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'CASHOUT_TIMEOUT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'CITY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numeric 0 = OFF, 3 - 999  The amount of time (in seconds) to claim before forfeit', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'CLAIM_TIMEOUT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact Person', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'CONTACT_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numeric 0 = OFF, 3 - 999  The amount of time (in seconds) to daub before forfeit', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'DAUB_TIMEOUT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flags if Progressive amounts are displayed at Machines', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'DISPLAY_PROGRESSIVE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fax Number', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'FAX'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Offset', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'FROM_TIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if machine locks up after a Jackpot', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'JACKPOT_LOCKUP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lottery Property Identifier', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Threshold amount requiring authorization of payout at POS (at or above)', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'LOCKUP_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum balance adjustment amount in Dollars', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'MAX_BAL_ADJUSTMENT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum Deal Import version for this database version', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'MIN_DI_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The win amount at which local payouts are not allowed.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PAYOUT_THRESHOLD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Telephone Number', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PHONE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if a PIN number is required to play or cashout', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PIN_REQUIRED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Player Card flag, if set a Card must be used to play', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PLAYER_CARD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Casino wide Pay per Play (revenue per tab) amount', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PPP_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if machines are to print promotional tickets', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PRINT_PROMO_TICKETS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if machines are to print Raffle tickets', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PRINT_RAFFLE_TICKETS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if machines are to print Prize Redeption tickets', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PRINT_REDEMPTION_TICKETS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Progressive Pool Polling freqency in seconds', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PROG_REQUEST_SECONDS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flags if Promotional Play is in effect', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PROMOTIONAL_PLAY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Player Tracking award type ''M''oney or ''P''oints - not used.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'PT_AWARD_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flags if Receipt Printers are in use', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'RECEIPT_PRINTER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flags if Reprint Ticket button shows on game machine maintenance screen', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'REPRINT_TICKET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Retail Location Revenue Share percentage value', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'RETAIL_REV_SHARE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location identifier', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'RETAILER_NUMBER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if there is a Pay per Play fee in addition to Revenue Share fees', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'RS_AND_PPP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flags if this is the Active Location - only 1 row should have this flag set', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'SETASDEFAULT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State or Province', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'STATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if play transactions are summarized in MACHINE_PLAY_STATS', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'SUMMARIZE_PLAY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank account number lottery will sweep for payments', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'SWEEP_ACCT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Offset', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'TO_TIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Third Party Interface Identifier, link to TPI table', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'TPI_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Third Party Property Identifier', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'TPI_PROPERTY_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Postal Code', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'COLUMN', N'ZIP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Constrains the payout threshold', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'CONSTRAINT', N'CK_CASINO_PAYOUT_THRESHOLD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prevent non-unique LocationID values.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO', 'INDEX', N'IX_CASINO_LOCATION_ID'
GO
