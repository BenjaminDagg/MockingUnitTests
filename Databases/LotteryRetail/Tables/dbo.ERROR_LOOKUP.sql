CREATE TABLE [dbo].[ERROR_LOOKUP]
(
[ERROR_NO] [int] NOT NULL,
[LOCKUP_MACHINE] [int] NOT NULL,
[DESCRIPTION] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ERROR_TYPE_ID] [int] NOT NULL CONSTRAINT [DF_ERROR_LOOKUP_ERROR_TYPE_ID] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ERROR_LOOKUP] ADD CONSTRAINT [PK_ERROR_LOOKUP] PRIMARY KEY CLUSTERED  ([ERROR_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table of errors occuring during stored procedure execution and returned to EGMs.', 'SCHEMA', N'dbo', 'TABLE', N'ERROR_LOOKUP', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptive text', 'SCHEMA', N'dbo', 'TABLE', N'ERROR_LOOKUP', 'COLUMN', N'DESCRIPTION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Error Number', 'SCHEMA', N'dbo', 'TABLE', N'ERROR_LOOKUP', 'COLUMN', N'ERROR_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to ERROR_TYPE table', 'SCHEMA', N'dbo', 'TABLE', N'ERROR_LOOKUP', 'COLUMN', N'ERROR_TYPE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if machine should be locked', 'SCHEMA', N'dbo', 'TABLE', N'ERROR_LOOKUP', 'COLUMN', N'LOCKUP_MACHINE'
GO
