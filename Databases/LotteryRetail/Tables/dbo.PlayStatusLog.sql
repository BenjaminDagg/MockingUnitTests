CREATE TABLE [dbo].[PlayStatusLog]
(
[PlayStatusLogID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LocationID] [int] NOT NULL,
[MachineNumber] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PlayStatus] [bit] NOT NULL,
[EventDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PlayStatusLog] ADD CONSTRAINT [PK_PlayStatusLog] PRIMARY KEY CLUSTERED  ([PlayStatusLogID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PlayStatusLog] ON [dbo].[PlayStatusLog] ([EventDate]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores changes in the playstatus of machines, used to track downtime.', 'SCHEMA', N'dbo', 'TABLE', N'PlayStatusLog', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date/time at which the status change occurred', 'SCHEMA', N'dbo', 'TABLE', N'PlayStatusLog', 'COLUMN', N'EventDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'PlayStatusLog', 'COLUMN', N'LocationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine number on which the play status change occurred', 'SCHEMA', N'dbo', 'TABLE', N'PlayStatusLog', 'COLUMN', N'MachineNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status of the machine at the time of the event', 'SCHEMA', N'dbo', 'TABLE', N'PlayStatusLog', 'COLUMN', N'PlayStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'PlayStatusLog', 'COLUMN', N'PlayStatusLogID'
GO
