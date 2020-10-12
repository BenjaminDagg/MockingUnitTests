CREATE TABLE [dbo].[MachineStatus]
(
[MachineStatusID] [int] NOT NULL,
[LongName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MachineStatus] ADD CONSTRAINT [PK_MachineStatus] PRIMARY KEY CLUSTERED  ([MachineStatusID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status lookup table used by the MachineMonitor application', 'SCHEMA', N'dbo', 'TABLE', N'MachineStatus', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status Description', 'SCHEMA', N'dbo', 'TABLE', N'MachineStatus', 'COLUMN', N'LongName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status ID value', 'SCHEMA', N'dbo', 'TABLE', N'MachineStatus', 'COLUMN', N'MachineStatusID'
GO
