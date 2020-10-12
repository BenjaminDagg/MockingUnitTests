CREATE TABLE [dbo].[LEVEL_PERMISSIONS]
(
[LEVEL_CODE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SECURITY_LEVEL] [smallint] NOT NULL,
[LEVEL_DESCR] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LEVEL_PERMISSIONS] ADD CONSTRAINT [CK_LEVEL_PERMISSIONS] CHECK (([SECURITY_LEVEL]>=(0) AND [SECURITY_LEVEL]<=(100)))
GO
ALTER TABLE [dbo].[LEVEL_PERMISSIONS] ADD CONSTRAINT [PK_LEVEL_PERMISSIONS] PRIMARY KEY CLUSTERED  ([LEVEL_CODE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table for Accounting application groups.', 'SCHEMA', N'dbo', 'TABLE', N'LEVEL_PERMISSIONS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defines the group to which the security level belongs', 'SCHEMA', N'dbo', 'TABLE', N'LEVEL_PERMISSIONS', 'COLUMN', N'LEVEL_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptive text', 'SCHEMA', N'dbo', 'TABLE', N'LEVEL_PERMISSIONS', 'COLUMN', N'LEVEL_DESCR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A security level value between 0 and 100', 'SCHEMA', N'dbo', 'TABLE', N'LEVEL_PERMISSIONS', 'COLUMN', N'SECURITY_LEVEL'
GO
