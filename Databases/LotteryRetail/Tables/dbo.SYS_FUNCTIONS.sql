CREATE TABLE [dbo].[SYS_FUNCTIONS]
(
[FUNC_ID] [smallint] NOT NULL,
[FUNC_NAME] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FUNC_DESCR] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYS_FUNCTIONS] ADD CONSTRAINT [PK_SYS_FUNCTIONS] PRIMARY KEY CLUSTERED  ([FUNC_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table of Accounting application menu items.', 'SCHEMA', N'dbo', 'TABLE', N'SYS_FUNCTIONS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Function Description', 'SCHEMA', N'dbo', 'TABLE', N'SYS_FUNCTIONS', 'COLUMN', N'FUNC_DESCR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Function ID', 'SCHEMA', N'dbo', 'TABLE', N'SYS_FUNCTIONS', 'COLUMN', N'FUNC_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Function Name (Accounting application menu item names)', 'SCHEMA', N'dbo', 'TABLE', N'SYS_FUNCTIONS', 'COLUMN', N'FUNC_NAME'
GO
