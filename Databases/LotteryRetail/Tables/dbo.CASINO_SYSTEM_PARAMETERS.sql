CREATE TABLE [dbo].[CASINO_SYSTEM_PARAMETERS]
(
[PAR_ID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PAR_NAME] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PAR_DESC] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VALUE1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CASINO_SYSTEM_PARAMETERS_VALUE1] DEFAULT (''),
[VALUE2] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CASINO_SYSTEM_PARAMETERS_VALUE2] DEFAULT (''),
[VALUE3] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CASINO_SYSTEM_PARAMETERS_VALUE3] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CASINO_SYSTEM_PARAMETERS] ADD CONSTRAINT [PK_CASINO_SYSTEM_PARAMETERS] PRIMARY KEY CLUSTERED  ([PAR_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores system setting values', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_SYSTEM_PARAMETERS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parameter Description', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_SYSTEM_PARAMETERS', 'COLUMN', N'PAR_DESC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Parameter Code', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_SYSTEM_PARAMETERS', 'COLUMN', N'PAR_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parameter Name', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_SYSTEM_PARAMETERS', 'COLUMN', N'PAR_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parameter Value 1', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_SYSTEM_PARAMETERS', 'COLUMN', N'VALUE1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parameter Value 2', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_SYSTEM_PARAMETERS', 'COLUMN', N'VALUE2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parameter Value 3', 'SCHEMA', N'dbo', 'TABLE', N'CASINO_SYSTEM_PARAMETERS', 'COLUMN', N'VALUE3'
GO
