CREATE TABLE [dbo].[AppRoleRetailGroup]
(
[AppRoleId] [int] NOT NULL,
[RetailGroupId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppRoleRetailGroup] ADD CONSTRAINT [PK_AppRoleRetailGroup] PRIMARY KEY CLUSTERED  ([AppRoleId], [RetailGroupId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the connection between which AppRole is assigned to which RetailGroup', 'SCHEMA', N'dbo', 'TABLE', N'AppRoleRetailGroup', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The AppRole identity id that is assigned the specific AppRetail identity id.', 'SCHEMA', N'dbo', 'TABLE', N'AppRoleRetailGroup', 'COLUMN', N'AppRoleId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The AppRetailGroup identity id assigned to the AppRole identity id.', 'SCHEMA', N'dbo', 'TABLE', N'AppRoleRetailGroup', 'COLUMN', N'RetailGroupId'
GO
