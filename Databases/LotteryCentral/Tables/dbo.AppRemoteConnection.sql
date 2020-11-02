CREATE TABLE [dbo].[AppRemoteConnection]
(
[DgeId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ServerName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationConnectionString] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
