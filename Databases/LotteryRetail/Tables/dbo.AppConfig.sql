CREATE TABLE [dbo].[AppConfig]
(
[ConfigKey] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Protected] [bit] NOT NULL CONSTRAINT [DF_AppConfig_Protected] DEFAULT ((0)),
[ConfigValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Category] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppConfig] ADD CONSTRAINT [PK_AppConfig] PRIMARY KEY CLUSTERED  ([ConfigKey]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds specific configurable variables for the website.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'A category can be a feature or application that the config item belongs to. This is used to sort and group.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', 'COLUMN', N'Category'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This config key name to find configuration data with.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', 'COLUMN', N'ConfigKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The config value to pass to the app.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', 'COLUMN', N'ConfigValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The short description of the config value.', 'SCHEMA', N'dbo', 'TABLE', N'AppConfig', 'COLUMN', N'Description'
GO
