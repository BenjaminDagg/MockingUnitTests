CREATE TABLE [dbo].[GAME_CATEGORY]
(
[GAME_CATEGORY_ID] [int] NOT NULL,
[LONG_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LIMIT_RTRANS_TIERS] [bit] NOT NULL CONSTRAINT [DF_GAME_CATEGORY_LIMIT_RTRANS_TIERS] DEFAULT ((1)),
[SORT_ORDER] [int] NOT NULL CONSTRAINT [DF_GAME_CATEGORY_SORT_ORDER] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GAME_CATEGORY] ADD CONSTRAINT [PK_GAME_CATEGORY] PRIMARY KEY CLUSTERED  ([GAME_CATEGORY_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table of Game Categories linked to GAME_TYPE table.', 'SCHEMA', N'dbo', 'TABLE', N'GAME_CATEGORY', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Int', 'SCHEMA', N'dbo', 'TABLE', N'GAME_CATEGORY', 'COLUMN', N'GAME_CATEGORY_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the number of Payscale Tiers returned in the R trans should be limited', 'SCHEMA', N'dbo', 'TABLE', N'GAME_CATEGORY', 'COLUMN', N'LIMIT_RTRANS_TIERS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Category description', 'SCHEMA', N'dbo', 'TABLE', N'GAME_CATEGORY', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sort order for presention', 'SCHEMA', N'dbo', 'TABLE', N'GAME_CATEGORY', 'COLUMN', N'SORT_ORDER'
GO
