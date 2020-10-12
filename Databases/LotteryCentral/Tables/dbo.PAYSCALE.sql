CREATE TABLE [dbo].[PAYSCALE]
(
[PAYSCALE_NAME] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LONG_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GAME_TYPE_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IS_ACTIVE] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAYSCALE] ADD CONSTRAINT [PK_PAYSCALE] PRIMARY KEY CLUSTERED  ([PAYSCALE_NAME]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Payscale header info linked to GAME_TYPE.', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links this Payscale to a GAME_TYPE record', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE', 'COLUMN', N'GAME_TYPE_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active Flag indicates if this record is active or has been deactivated', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE', 'COLUMN', N'IS_ACTIVE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payscale descriptive text', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payscale Identifier', 'SCHEMA', N'dbo', 'TABLE', N'PAYSCALE', 'COLUMN', N'PAYSCALE_NAME'
GO
