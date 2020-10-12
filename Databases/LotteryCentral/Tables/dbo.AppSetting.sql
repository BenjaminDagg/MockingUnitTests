CREATE TABLE [dbo].[AppSetting]
(
[ItemKey] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemValueText] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_AppSetting_ItemValueText] DEFAULT (''),
[ItemValueInt] [int] NOT NULL CONSTRAINT [DF_AppSetting_ItemValueInt] DEFAULT ((0)),
[ItemValueBit] [bit] NOT NULL CONSTRAINT [DF_AppSetting_ItemValueBit] DEFAULT ((0)),
[ItemValueDecimal] [decimal] (6, 4) NOT NULL CONSTRAINT [DF_AppSetting_ItemValueDecimal] DEFAULT ((0)),
[ItemDescription] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppSetting] ADD CONSTRAINT [PK_AppSetting] PRIMARY KEY CLUSTERED  ([ItemKey]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores applications settings for the LMS application', 'SCHEMA', N'dbo', 'TABLE', N'AppSetting', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Application setting description', 'SCHEMA', N'dbo', 'TABLE', N'AppSetting', 'COLUMN', N'ItemDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Application setting name', 'SCHEMA', N'dbo', 'TABLE', N'AppSetting', 'COLUMN', N'ItemKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Application setting boolean value', 'SCHEMA', N'dbo', 'TABLE', N'AppSetting', 'COLUMN', N'ItemValueBit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Application setting Decimal value', 'SCHEMA', N'dbo', 'TABLE', N'AppSetting', 'COLUMN', N'ItemValueDecimal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Application setting integer value', 'SCHEMA', N'dbo', 'TABLE', N'AppSetting', 'COLUMN', N'ItemValueInt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Application setting text value', 'SCHEMA', N'dbo', 'TABLE', N'AppSetting', 'COLUMN', N'ItemValueText'
GO
