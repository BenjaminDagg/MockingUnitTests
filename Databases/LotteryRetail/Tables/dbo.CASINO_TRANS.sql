CREATE TABLE [dbo].[CASINO_TRANS]
(
[TRANS_NO] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CAS_ID] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEAL_NO] [int] NOT NULL,
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ROLL_NO] [smallint] NOT NULL,
[TICKET_NO] [int] NOT NULL,
[DENOM] [smallmoney] NULL CONSTRAINT [DF_CASINO_TRANS_DENOM] DEFAULT ((0)),
[TRANS_AMT] [money] NULL,
[BARCODE_SCAN] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANS_ID] [smallint] NOT NULL CONSTRAINT [DF_CASINO_TRANS_TRANS_ID] DEFAULT ((0)),
[DTIMESTAMP] [datetime] NOT NULL,
[ACCT_DATE] [smalldatetime] NULL,
[MODIFIED_BY] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CARD_ACCT_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BALANCE] [money] NULL,
[GAME_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COINS_BET] [smallint] NULL,
[LINES_BET] [tinyint] NULL,
[TIER_LEVEL] [smallint] NULL,
[PRODUCT_ID] [tinyint] NULL CONSTRAINT [DF_CASINO_TRANS_PRODUCT_ID] DEFAULT ((0)),
[PRESSED_COUNT] [smallint] NOT NULL CONSTRAINT [DF_CASINO_TRANS_PRESSED_COUNT] DEFAULT ((0)),
[LOCATION_ID] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_55684F05_39AB_428F_AF9E_6E6510B21EE8_2095346529] DEFAULT (newid()),
[MACH_TIMESTAMP] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[ti_CASINO_TRANS_SET_ACCT_DATE] ON [dbo].[CASINO_TRANS] FOR INSERT AS
/*
--------------------------------------------------------------------------------
Set the accounting date ACCT_DATE value if not specifically being inserted.
--------------------------------------------------------------------------------
*/
DECLARE @AcctDate    AS SmallDateTime
DECLARE @AcctDateIns AS SmallDateTime

DECLARE @ToTime      AS Datetime
DECLARE @ToDate      AS Datetime

DECLARE @Offset      AS Integer
DECLARE @TransNo     AS Integer

-- Retrieve the Accounting Date value about to be inserted into the table.
SELECT @AcctDateIns = ACCT_DATE FROM Inserted

-- Is it NULL?
IF @AcctDateIns IS NULL
   -- Yes, so calculate and then insert the accounting date.
   BEGIN
      -- Retrieve the accounting offset from the CASINO table.
      SELECT @ToTime = TO_TIME FROM CASINO WHERE SETASDEFAULT = 1
      SET @TransNo = ISNULL(@@IDENTITY, 0)

      -- Get Current Accounting Date based on Offset
      SET @ToDate = CONVERT(DATETIME, CONVERT(CHAR(10), @ToTime, 101))
      SET @Offset = DATEDIFF(Minute, @ToDate, @ToTime)
      SET @AcctDate = CONVERT(CHAR(10), DATEADD(Minute, -@Offset, GetDate()), 101)

      UPDATE CASINO_TRANS SET ACCT_DATE = @AcctDate WHERE TRANS_NO = @TransNo      

   END
GO
ALTER TABLE [dbo].[CASINO_TRANS] ADD CONSTRAINT [PK_CASINO_TRANS] PRIMARY KEY CLUSTERED  ([TRANS_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ind_acct_date] ON [dbo].[CASINO_TRANS] ([ACCT_DATE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ind_card_acct_no] ON [dbo].[CASINO_TRANS] ([CARD_ACCT_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ind_dtimestamp] ON [dbo].[CASINO_TRANS] ([DTIMESTAMP]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CASINO_TRANS_DTIMESTAMP] ON [dbo].[CASINO_TRANS] ([DTIMESTAMP]) INCLUDE ([BALANCE], [CARD_ACCT_NO], [COINS_BET], [DEAL_NO], [DENOM], [LINES_BET], [MACH_NO], [MACH_TIMESTAMP], [PRESSED_COUNT], [TICKET_NO], [TRANS_AMT], [TRANS_ID], [TRANS_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ind_DT_MN_TI] ON [dbo].[CASINO_TRANS] ([DTIMESTAMP], [MACH_NO], [TRANS_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CASINO_TRANS_MACH_NO_DTIMESTAMP] ON [dbo].[CASINO_TRANS] ([MACH_NO], [DTIMESTAMP]) INCLUDE ([BALANCE], [CARD_ACCT_NO], [COINS_BET], [DEAL_NO], [DENOM], [LINES_BET], [MACH_TIMESTAMP], [PRESSED_COUNT], [TICKET_NO], [TRANS_AMT], [TRANS_ID], [TRANS_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASINO_TRANS] WITH NOCHECK ADD CONSTRAINT [FK_CASINO_TRANS_CARD_ACCT] FOREIGN KEY ([CARD_ACCT_NO]) REFERENCES [dbo].[CARD_ACCT] ([CARD_ACCT_NO])
GO
ALTER TABLE [dbo].[CASINO_TRANS] WITH NOCHECK ADD CONSTRAINT [FK_CASINO_TRANS_CASINO] FOREIGN KEY ([CAS_ID]) REFERENCES [dbo].[CASINO] ([CAS_ID])
GO
ALTER TABLE [dbo].[CASINO_TRANS] WITH NOCHECK ADD CONSTRAINT [FK_CASINO_TRANS_DEAL_SETUP] FOREIGN KEY ([DEAL_NO]) REFERENCES [dbo].[DEAL_SETUP] ([DEAL_NO])
GO
EXEC sp_addextendedproperty N'MS_Description', N'EGM and POS transactions audit table', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting Date', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'ACCT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Balance', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'BALANCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ticket Barcode', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'BARCODE_SCAN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Card Account Number', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'CARD_ACCT_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DGE Casino identifier', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'CAS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Coins Bet', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'COINS_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Denomination', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'DENOM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and Time of transaction', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'DTIMESTAMP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Code being played', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'GAME_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Lines Bet', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'LINES_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Records the timestamp of the transaction according to the machine.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'MACH_TIMESTAMP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Records who modified the record', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'MODIFIED_BY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of times player Pressed up their bet for PIU Poker.', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'PRESSED_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product ID (0=Millennium, 1=TriplePlay)', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'PRODUCT_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Roll Number', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'ROLL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ticket Number', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'TICKET_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tier Level of winning play or zero', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'TIER_LEVEL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction Amount', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'TRANS_AMT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction Identifier - link to TRANS table', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'TRANS_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_TRANS', 'COLUMN', N'TRANS_NO'
GO
