CREATE TABLE [dbo].[GAME_SETUP]
(
[GAME_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GAME_DESC] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE_ID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GAME_TYPE_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GAME_TITLE_ID] [int] NOT NULL CONSTRAINT [DF_GAME_SETUP_GAME_TITLE_ID] DEFAULT ((-1)),
[CASINO_GAME_ID] [int] NOT NULL CONSTRAINT [DF_GAME_SETUP_CASINO_GAME_ID] DEFAULT ((-1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GAME_SETUP] ADD CONSTRAINT [PK_GAME_SETUP] PRIMARY KEY NONCLUSTERED  ([GAME_CODE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lists Game Codes, descriptions and Game Title IDs linked to the GAME_TYPE table.', 'SCHEMA', N'dbo', 'TABLE', N'GAME_SETUP', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique game identifier', 'SCHEMA', N'dbo', 'TABLE', N'GAME_SETUP', 'COLUMN', N'CASINO_GAME_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Code - 3 character', 'SCHEMA', N'dbo', 'TABLE', N'GAME_SETUP', 'COLUMN', N'GAME_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Description', 'SCHEMA', N'dbo', 'TABLE', N'GAME_SETUP', 'COLUMN', N'GAME_DESC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifier sent to Machine in tpTransR to validate asset and compact flash', 'SCHEMA', N'dbo', 'TABLE', N'GAME_SETUP', 'COLUMN', N'GAME_TITLE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies the Game Type that this Game inherits from', 'SCHEMA', N'dbo', 'TABLE', N'GAME_SETUP', 'COLUMN', N'GAME_TYPE_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Type (S=Slot, P=Poker, K=Keno)', 'SCHEMA', N'dbo', 'TABLE', N'GAME_SETUP', 'COLUMN', N'TYPE_ID'
GO
