CREATE TABLE [dbo].[PROGRESSIVE_POOL]
(
[PROGRESSIVE_POOL_ID] [int] NOT NULL,
[PROGRESSIVE_TYPE_ID] [int] NOT NULL,
[GAME_TYPE_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_GAME_TYPE_CODE] DEFAULT ('6C'),
[DENOMINATION] [int] NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_DENOMINATION] DEFAULT ((0)),
[COINS_BET] [smallint] NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_COINS_BET] DEFAULT ((0)),
[LINES_BET] [tinyint] NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_LINES_BET] DEFAULT ((0)),
[POOL_1] [money] NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_PRIMARY_POOL] DEFAULT ((0)),
[POOL_2] [money] NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_SECONDARY_POOL] DEFAULT ((0)),
[POOL_3] [money] NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_TERTIARY_POOL] DEFAULT ((0)),
[WinLevel] [tinyint] NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_WIN_LEVEL] DEFAULT ((1)),
[SeedCount] [int] NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_SeedCount] DEFAULT ((0)),
[Rate1] [decimal] (5, 4) NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_Rate1] DEFAULT ((0)),
[Rate2] [decimal] (5, 4) NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_Rate2] DEFAULT ((0)),
[Rate3] [decimal] (5, 4) NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_Rate3] DEFAULT ((0)),
[LocationID] [int] NOT NULL CONSTRAINT [DF_PROGRESSIVE_POOL_LocationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[ti_ProgressivePool_Insert] ON [dbo].[PROGRESSIVE_POOL]
FOR INSERT
AS

-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @ProgressivePoolID Int
DECLARE @TimeStamp         DateTime

-- Variable Initialization
SET @AcctDate          = [dbo].[ufnGetAcctDate]()
SET @TimeStamp         = GetDate()

BEGIN
   -- Storing the progressive Pool ID from the inserted row.
   SELECT @ProgressivePoolID = PROGRESSIVE_POOL_ID FROM inserted
   
   -- Insert the first seed event into the POOL_EVENT table for Pool1.
   INSERT INTO POOL_EVENT
      (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
   SELECT
      CAST(2 AS Int), @ProgressivePoolID, CAST(1 AS Int), @TimeStamp, @AcctDate, POOL_1 FROM inserted
   
   -- Insert the first seed event into the POOL_EVENT table for Pool2
   INSERT INTO POOL_EVENT
      (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
   SELECT
      CAST(2 AS Int), @ProgressivePoolID, CAST(2 AS Int), @TimeStamp, @AcctDate, POOL_2 FROM inserted
   
   -- Insert the first seed event into the POOL_EVENT table for Pool3
   INSERT INTO POOL_EVENT
      (POOL_EVENT_TYPE_ID, PROGRESSIVE_POOL_ID, POOL_NUMBER, POOL_EVENT_DATE_TIME, ACCT_DATE, AMOUNT)
   SELECT
      CAST(2 AS Int), @ProgressivePoolID, CAST(3 AS Int), @TimeStamp, @AcctDate, POOL_3 FROM inserted
END
GO
ALTER TABLE [dbo].[PROGRESSIVE_POOL] ADD CONSTRAINT [PK_PROGRESSIVE_POOL] PRIMARY KEY CLUSTERED  ([PROGRESSIVE_POOL_ID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PROGRESSIVE_POOL] ADD CONSTRAINT [FK_PROGRESSIVE_POOL_PROGRESSIVE_TYPE] FOREIGN KEY ([PROGRESSIVE_TYPE_ID]) REFERENCES [dbo].[PROGRESSIVE_TYPE] ([PROGRESSIVE_TYPE_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores progressive setup information and pool amounts.', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Coins bet', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', 'COLUMN', N'COINS_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Denomination in cents', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', 'COLUMN', N'DENOMINATION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Associated Game Type Code', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', 'COLUMN', N'GAME_TYPE_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Lines bet', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', 'COLUMN', N'LINES_BET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of the Primary pool', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', 'COLUMN', N'POOL_1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of the first backup pool', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', 'COLUMN', N'POOL_2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of the second backup pool', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', 'COLUMN', N'POOL_3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK PROGRESSIVE_POOL identifier', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', 'COLUMN', N'PROGRESSIVE_POOL_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to the PROGRESSIVE_TYPE table', 'SCHEMA', N'dbo', 'TABLE', N'PROGRESSIVE_POOL', 'COLUMN', N'PROGRESSIVE_TYPE_ID'
GO
