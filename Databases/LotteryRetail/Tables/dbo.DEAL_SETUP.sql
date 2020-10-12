CREATE TABLE [dbo].[DEAL_SETUP]
(
[DEAL_NO] [int] NOT NULL,
[TYPE_ID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEAL_DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUMB_ROLLS] [int] NULL,
[TABS_PER_ROLL] [int] NULL,
[TAB_AMT] [smallmoney] NULL,
[COST_PER_TAB] [smallmoney] NULL,
[CREATED_BY] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SETUP_DATE] [datetime] NULL CONSTRAINT [DF_DEAL_SETUP_SETUP_DATE] DEFAULT (getdate()),
[JP_AMOUNT] [money] NULL,
[FORM_NUMB] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GAME_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IS_OPEN] [bit] NOT NULL CONSTRAINT [DF_DEAL_SETUP_IS_OPEN] DEFAULT ((1)),
[CLOSE_DATE] [datetime] NULL,
[CLOSE_RECOMMENDED] [bit] NOT NULL CONSTRAINT [DF_DEAL_SETUP_CLOSE_RECOMMENDED] DEFAULT ((0)),
[CLOSED_BY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DENOMINATION] [smallmoney] NULL,
[COINS_BET] [smallint] NOT NULL CONSTRAINT [DF_DEAL_SETUP_COINS_BET] DEFAULT ((1)),
[LINES_BET] [tinyint] NOT NULL CONSTRAINT [DF_DEAL_SETUP_LINES_BET] DEFAULT ((1)),
[EXPORTED_DATE] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tu_DEAL_SETUP_SET_CLOSE_DATE] ON [dbo].[DEAL_SETUP] 
FOR UPDATE
AS
DECLARE @DealNbr         Integer
DECLARE @bIsOpenDeleted  Bit
DECLARE @bIsOpenInserted Bit


IF NOT UPDATE(CLOSE_DATE)
   BEGIN
      SELECT @DealNbr = DEAL_NO, @bIsOpenInserted = IS_OPEN FROM inserted
      IF @bIsOpenInserted = 0
         BEGIN
            SELECT @bIsOpenDeleted = IS_OPEN FROM deleted
            IF @bIsOpenDeleted = 1
               BEGIN
                  UPDATE DEAL_SETUP SET CLOSE_DATE = GetDate() WHERE DEAL_NO = @DealNbr
               END
         END
   END
GO
ALTER TABLE [dbo].[DEAL_SETUP] ADD CONSTRAINT [PK_DEAL_SETUP] PRIMARY KEY CLUSTERED  ([DEAL_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DEAL_SETUP] WITH NOCHECK ADD CONSTRAINT [FK_DEAL_SETUP_DEAL_TYPE] FOREIGN KEY ([TYPE_ID]) REFERENCES [dbo].[DEAL_TYPE] ([TYPE_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores information about Deals that have been imported.', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date this Deal was Closed', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'CLOSE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if the system has determined if this Deal should be closed', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'CLOSE_RECOMMENDED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that closed this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'CLOSED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Coins Bet for this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'COINS_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost per Tab (DGE Revenue per Tab) for Play per Pay', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'COST_PER_TAB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that created this record', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'CREATED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Description', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'DEAL_DESCR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Deal Number', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Denomination of this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'DENOMINATION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time deal was exported', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'EXPORTED_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Form Number used to generate this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'FORM_NUMB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Code used to generate this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'GAME_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if this Deal is Open to be played or Closed', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'IS_OPEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Jackpot Amount', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'JP_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Lines Bet for this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'LINES_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Rolls per Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'NUMB_ROLLS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time this record was inserted', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'SETUP_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tab amount (Cost to the Player of a single Tab)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'TAB_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Tabs per Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'TABS_PER_ROLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Type (P)oker (S)lot or (K)eno', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SETUP', 'COLUMN', N'TYPE_ID'
GO
