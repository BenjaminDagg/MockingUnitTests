CREATE TABLE [dbo].[ERROR_TYPE]
(
[ERROR_TYPE_ID] [int] NOT NULL,
[LONG_NAME] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ERROR_TYPE] ADD CONSTRAINT [PK_ERROR_TYPE] PRIMARY KEY CLUSTERED  ([ERROR_TYPE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table of error types linked to the ERROR_LOOKUP table.', 'SCHEMA', N'dbo', 'TABLE', N'ERROR_TYPE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Error Type identifier', 'SCHEMA', N'dbo', 'TABLE', N'ERROR_TYPE', 'COLUMN', N'ERROR_TYPE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptive text', 'SCHEMA', N'dbo', 'TABLE', N'ERROR_TYPE', 'COLUMN', N'LONG_NAME'
GO
