CREATE TABLE [dbo].[OperationHours]
(
[OperationHourID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LocationID] [int] NOT NULL,
[WeekDayNumber] [tinyint] NOT NULL,
[OpenTime] [time] NOT NULL CONSTRAINT [DF_OperationHours_OpenTime] DEFAULT ('00:00:00'),
[CloseTime] [time] NOT NULL CONSTRAINT [DF_OperationHours_CloseTime] DEFAULT ('23:59:59.9999999'),
[ActiveStartDate] [date] NOT NULL,
[ActiveEndDate] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OperationHours] ADD CONSTRAINT [PK_OperationHours] PRIMARY KEY CLUSTERED  ([OperationHourID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores a history of the operating hours of the site. Used for tracking downtime.', 'SCHEMA', N'dbo', 'TABLE', N'OperationHours', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date/time at which the operation hours stop taking effect', 'SCHEMA', N'dbo', 'TABLE', N'OperationHours', 'COLUMN', N'ActiveEndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date/time at which the operation hours start to take effect', 'SCHEMA', N'dbo', 'TABLE', N'OperationHours', 'COLUMN', N'ActiveStartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time at which property closing occurs', 'SCHEMA', N'dbo', 'TABLE', N'OperationHours', 'COLUMN', N'CloseTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'OperationHours', 'COLUMN', N'LocationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time at which property opening occurs', 'SCHEMA', N'dbo', 'TABLE', N'OperationHours', 'COLUMN', N'OpenTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'OperationHours', 'COLUMN', N'OperationHourID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number identifier of the day of the week. By default, Monday = 1', 'SCHEMA', N'dbo', 'TABLE', N'OperationHours', 'COLUMN', N'WeekDayNumber'
GO
