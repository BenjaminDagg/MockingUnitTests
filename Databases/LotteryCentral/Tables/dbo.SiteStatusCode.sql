CREATE TABLE [dbo].[SiteStatusCode]
(
[SiteStatusCodeId] [int] NOT NULL IDENTITY(1, 1),
[StatusCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SiteStatusCode] ADD CONSTRAINT [PK_SiteStatusCode] PRIMARY KEY CLUSTERED  ([SiteStatusCodeId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the Site Agent status types.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatusCode', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The description of the status code.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatusCode', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatusCode', 'COLUMN', N'SiteStatusCodeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site status character for current status.', 'SCHEMA', N'dbo', 'TABLE', N'SiteStatusCode', 'COLUMN', N'StatusCode'
GO
