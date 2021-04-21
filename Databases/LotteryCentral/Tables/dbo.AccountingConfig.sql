CREATE TABLE [dbo].[AccountingConfig]
(
[ConfigKey] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConfigValue] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConfigType] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccountingConfig] ADD CONSTRAINT [PK_AccountingConfig] PRIMARY KEY CLUSTERED  ([ConfigKey]) ON [PRIMARY]
GO
