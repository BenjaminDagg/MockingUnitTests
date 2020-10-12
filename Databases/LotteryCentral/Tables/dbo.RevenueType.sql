CREATE TABLE [dbo].[RevenueType]
(
[RevenueTypeID] [smallint] NOT NULL IDENTITY(1, 1),
[FlexNumber] [smallint] NOT NULL,
[RevenueTypeDescription] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RevenueType] ADD CONSTRAINT [CK_FlexNumber] CHECK (([FlexNumber]>=(0) AND [FlexNumber]<=(9999)))
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table stores a number tied to a revenue type', 'SCHEMA', N'dbo', 'TABLE', N'RevenueType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number used to identify report column titles', 'SCHEMA', N'dbo', 'TABLE', N'RevenueType', 'COLUMN', N'FlexNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Revenue Type Description', 'SCHEMA', N'dbo', 'TABLE', N'RevenueType', 'COLUMN', N'RevenueTypeDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Indentity Int', 'SCHEMA', N'dbo', 'TABLE', N'RevenueType', 'COLUMN', N'RevenueTypeID'
GO
