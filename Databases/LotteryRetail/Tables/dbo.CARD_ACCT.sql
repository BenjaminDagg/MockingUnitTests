CREATE TABLE [dbo].[CARD_ACCT]
(
[CARD_ACCT_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PLAYER_ID] [int] NULL,
[BALANCE] [money] NULL,
[CREATE_DATE] [datetime] NULL CONSTRAINT [DF_CARD_ACCT_CREATE_DATE] DEFAULT (getdate()),
[SESSION_DATE] [datetime] NULL,
[MODIFIED_DATE] [datetime] NULL CONSTRAINT [DF_CARD_ACCT_MODIFIED_DATE] DEFAULT (getdate()),
[PIN_NUMBER] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ_NUM] [numeric] (18, 0) NULL,
[STATUS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PROMO_AMOUNT] [money] NOT NULL CONSTRAINT [DF_CARD_ACCT_PROMO_AMOUNT] DEFAULT ((0)),
[TPI_ID] [int] NOT NULL CONSTRAINT [DF_CARD_ACCT_TPI_ID] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tu_Card_Acct_Balance] ON [dbo].[CARD_ACCT]
FOR UPDATE AS

DECLARE @BalanceBefore Money
DECLARE @BalanceAfter  Money
DECLARE @MachineNbr    Char(5)

IF UPDATE(BALANCE)
   BEGIN
      SELECT @BalanceBefore = ISNULL(d.BALANCE, 0),
             @BalanceAfter  = ISNULL(i.BALANCE, 0),
             @MachineNbr    = ISNULL(i.MACH_NO, '0')
      FROM CARD_ACCT ca
         JOIN inserted i ON ca.CARD_ACCT_NO = i.CARD_ACCT_NO
         JOIN deleted  d ON ca.CARD_ACCT_NO = d.CARD_ACCT_NO
      
      IF (@BalanceAfter > 0) AND (@BalanceAfter > @BalanceBefore) AND (@MachineNbr = '0')
         BEGIN
            RAISERROR ('Invalid Card Account Balance change.', 16, 1)
            ROLLBACK TRANSACTION
         END
   END


GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tu_Card_Acct_Modified_Date] ON [dbo].[CARD_ACCT]
FOR UPDATE AS
IF NOT UPDATE(MODIFIED_DATE)
   UPDATE CARD_ACCT
   SET MODIFIED_DATE = GetDate()
   WHERE CARD_ACCT_NO IN (SELECT CARD_ACCT_NO FROM deleted)
GO
ALTER TABLE [dbo].[CARD_ACCT] ADD CONSTRAINT [PK_CARD_ACCT] PRIMARY KEY CLUSTERED  ([CARD_ACCT_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Card Account information for EGM access', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current account balance if in Card Play mode.', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'BALANCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Card Account Number', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'CARD_ACCT_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and Time this record was created', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'CREATE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Number that Card is inserted into', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last Date and Time there was activity for this Account', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'MODIFIED_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pin Number', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'PIN_NUMBER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Player ID associates card with player', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'PLAYER_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount played for Promotional play', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'PROMO_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence Number', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'SEQ_NUM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and Time Card was last inserted into a Machine', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'SESSION_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account Status 1=ok, 2=lockup', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'STATUS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Third Party Identifier', 'SCHEMA', N'dbo', 'TABLE', N'CARD_ACCT', 'COLUMN', N'TPI_ID'
GO
