CREATE TABLE [dbo].[AppConfig]
(
[ConfigKey] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConfigValue] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConfigType] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppConfig] ADD CONSTRAINT [PK_AppConfig] PRIMARY KEY CLUSTERED  ([ConfigKey]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds specific configurable variables for the website.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'This config key name to find configuration data with.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', 'COLUMN', N'ConfigKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The variable type for the config value.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', 'COLUMN', N'ConfigType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The config value to pass to the app.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', 'COLUMN', N'ConfigValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The short description of the config value.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', 'COLUMN', N'Description'
GO
