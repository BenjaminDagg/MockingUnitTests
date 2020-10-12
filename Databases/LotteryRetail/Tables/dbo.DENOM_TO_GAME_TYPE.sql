CREATE TABLE [dbo].[DENOM_TO_GAME_TYPE]
(
[DENOM_VALUE] [smallmoney] NOT NULL,
[GAME_TYPE_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DENOM_TO_GAME_TYPE] ADD CONSTRAINT [PK_DENOM_TO_GAME_TYPE] PRIMARY KEY CLUSTERED  ([DENOM_VALUE], [GAME_TYPE_CODE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores the valid Denomination values for Game Types', 'SCHEMA', N'dbo', 'TABLE', N'DENOM_TO_GAME_TYPE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Denomination Value', 'SCHEMA', N'dbo', 'TABLE', N'DENOM_TO_GAME_TYPE', 'COLUMN', N'DENOM_VALUE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Type Code, links to the GAME_TYPE table', 'SCHEMA', N'dbo', 'TABLE', N'DENOM_TO_GAME_TYPE', 'COLUMN', N'GAME_TYPE_CODE'
GO
