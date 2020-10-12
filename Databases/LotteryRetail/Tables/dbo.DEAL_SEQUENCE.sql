CREATE TABLE [dbo].[DEAL_SEQUENCE]
(
[DEAL_SEQUENCE_ID] [int] NOT NULL IDENTITY(1, 1),
[FORM_NUMB] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEAL_NO] [int] NOT NULL,
[DENOMINATION] [int] NOT NULL,
[COINS_BET] [smallint] NOT NULL,
[LINES_BET] [tinyint] NOT NULL,
[DATE_ADDED] [datetime] NOT NULL,
[CURRENT_DEAL_FLAG] [bit] NOT NULL,
[NEXT_TICKET] [int] NOT NULL,
[LAST_TICKET] [int] NOT NULL,
[NEXT_DEAL] [int] NOT NULL,
[UPDATE_DATE] [datetime] NOT NULL CONSTRAINT [DF_DEAL_SEQUENCE_UPDATE_DATE] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tu_Deal_Sequence_Update_Date] ON [dbo].[DEAL_SEQUENCE]
FOR UPDATE
AS
IF NOT UPDATE(UPDATE_DATE) 
   UPDATE DEAL_SEQUENCE
   SET UPDATE_DATE = GetDate()
   WHERE DEAL_SEQUENCE_ID IN (SELECT DEAL_SEQUENCE_ID FROM deleted)




GO
ALTER TABLE [dbo].[DEAL_SEQUENCE] ADD CONSTRAINT [PK_DEALSEQUENCE] PRIMARY KEY CLUSTERED  ([DEAL_SEQUENCE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Designed for non-paper Deal sequencing, in a paper market, tracks number of plays per Deal in the NEXT_TICKET column.', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Coins Bet for the Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'COINS_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if this Deal is currently in play', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'CURRENT_DEAL_FLAG'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the sequence record was added', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'DATE_ADDED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'DEAL_SEQUENCE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Denomination of the Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'DENOMINATION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Form Number', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'FORM_NUMB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Highest ticket number in this Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'LAST_TICKET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Lines Bet for the Deal', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'LINES_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pointer to the DEAL_SEQUENCE_ID of the next Deal to be put in play', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'NEXT_DEAL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next ticket number to dispense or number of paper tickets dispensed', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'NEXT_TICKET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time this record was last updated', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_SEQUENCE', 'COLUMN', N'UPDATE_DATE'
GO
