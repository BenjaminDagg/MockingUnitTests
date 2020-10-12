CREATE TABLE [dbo].[PRODUCT_LINE]
(
[PRODUCT_LINE_ID] [smallint] NOT NULL,
[LONG_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GAME_CLASS] [smallint] NOT NULL CONSTRAINT [DF_PRODUCT_LINE_GAME_CLASS] DEFAULT ((0)),
[IS_ACTIVE] [bit] NOT NULL CONSTRAINT [DF_PRODUCT_LINE_IS_ACTIVE] DEFAULT ((1)),
[EGM_DEAL_GC_MATCH] [bit] NOT NULL CONSTRAINT [DF_PRODUCT_LINE_EGM_DEAL_GC_MATCH] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRODUCT_LINE] ADD CONSTRAINT [PK_PRODUCT_LINE] PRIMARY KEY CLUSTERED  ([PRODUCT_LINE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table and links to the BANK table.', 'SCHEMA', N'dbo', 'TABLE', N'PRODUCT_LINE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if machine can only load paper rolls from deals of the same game code.', 'SCHEMA', N'dbo', 'TABLE', N'PRODUCT_LINE', 'COLUMN', N'EGM_DEAL_GC_MATCH'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator of Gaming Class (Class II, Class III)', 'SCHEMA', N'dbo', 'TABLE', N'PRODUCT_LINE', 'COLUMN', N'GAME_CLASS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if this record is Active or Deactivated', 'SCHEMA', N'dbo', 'TABLE', N'PRODUCT_LINE', 'COLUMN', N'IS_ACTIVE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptive text', 'SCHEMA', N'dbo', 'TABLE', N'PRODUCT_LINE', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Product Line Identifier', 'SCHEMA', N'dbo', 'TABLE', N'PRODUCT_LINE', 'COLUMN', N'PRODUCT_LINE_ID'
GO
