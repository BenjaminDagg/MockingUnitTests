CREATE TABLE [dbo].[TPI]
(
[TPI_ID] [int] NOT NULL,
[SHORT_NAME] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LONG_NAME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TPI] ADD CONSTRAINT [PK_TPI] PRIMARY KEY CLUSTERED  ([TPI_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table of Third Party Interface values. Links to CASINO.TPI.', 'SCHEMA', N'dbo', 'TABLE', N'TPI', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Long Name ie Diamond Game Enterprises', 'SCHEMA', N'dbo', 'TABLE', N'TPI', 'COLUMN', N'LONG_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Short Name ie DGE, SDG, etc.', 'SCHEMA', N'dbo', 'TABLE', N'TPI', 'COLUMN', N'SHORT_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Third Party Interface Identifier', 'SCHEMA', N'dbo', 'TABLE', N'TPI', 'COLUMN', N'TPI_ID'
GO
