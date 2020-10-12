CREATE TABLE [dbo].[ReelAnimationType]
(
[ReelAnimationTypeId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReelAnimationType] ADD CONSTRAINT [PK_GameAnimationType] PRIMARY KEY CLUSTERED  ([ReelAnimationTypeId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
