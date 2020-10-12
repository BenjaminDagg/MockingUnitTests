CREATE TABLE [dbo].[PRODUCT]
(
[PRODUCT_ID] [tinyint] NOT NULL,
[PRODUCT_DESCRIPTION] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRODUCT] ADD CONSTRAINT [PK_PRODUCT] PRIMARY KEY CLUSTERED  ([PRODUCT_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table for GAME_TYPE.PRODUCT_ID.', 'SCHEMA', N'dbo', 'TABLE', N'PRODUCT', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product Long Name (Dakota, Millennium, etc.)', 'SCHEMA', N'dbo', 'TABLE', N'PRODUCT', 'COLUMN', N'PRODUCT_DESCRIPTION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK tinyint', 'SCHEMA', N'dbo', 'TABLE', N'PRODUCT', 'COLUMN', N'PRODUCT_ID'
GO
