CREATE TABLE [dbo].[DEBUG_SETTING]
(
[DEBUG_ENTITY] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEBUG_MODE] [bit] NOT NULL CONSTRAINT [DF_DEBUG_SETTING_DEBUG_MODE] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DEBUG_SETTING] ADD CONSTRAINT [PK_DEBUG_SETTING] PRIMARY KEY CLUSTERED  ([DEBUG_ENTITY]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Controls what database objects write to the DEBUG_INFO table.', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_SETTING', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of db object to which setting applies', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_SETTING', 'COLUMN', N'DEBUG_ENTITY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debug mode 0 = Off or 1 = On', 'SCHEMA', N'dbo', 'TABLE', N'DEBUG_SETTING', 'COLUMN', N'DEBUG_MODE'
GO
