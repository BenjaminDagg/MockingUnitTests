CREATE TABLE [dbo].[SSRSSetting]
(
[ItemKey] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemDescription] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemValueText] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemValueInt] [int] NOT NULL,
[ItemValueBit] [bit] NOT NULL,
[ItemValueDecimal] [decimal] (6, 4) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SSRSSetting] ADD CONSTRAINT [PK_SSRSSettings] PRIMARY KEY CLUSTERED  ([ItemKey]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'SSRS setting description', 'SCHEMA', N'dbo', 'TABLE', N'SSRSSetting', 'COLUMN', N'ItemDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SSRS setting name', 'SCHEMA', N'dbo', 'TABLE', N'SSRSSetting', 'COLUMN', N'ItemKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SSRS setting boolean value', 'SCHEMA', N'dbo', 'TABLE', N'SSRSSetting', 'COLUMN', N'ItemValueBit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SSRS setting Decimal valu', 'SCHEMA', N'dbo', 'TABLE', N'SSRSSetting', 'COLUMN', N'ItemValueDecimal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SSRS setting integer value', 'SCHEMA', N'dbo', 'TABLE', N'SSRSSetting', 'COLUMN', N'ItemValueInt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SSRS setting text value', 'SCHEMA', N'dbo', 'TABLE', N'SSRSSetting', 'COLUMN', N'ItemValueText'
GO
