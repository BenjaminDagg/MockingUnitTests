CREATE TABLE [dbo].[OperationHours]
(
[OperationHourID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LocationID] [int] NOT NULL,
[WeekDayNumber] [tinyint] NOT NULL,
[OpenTime] [time] NOT NULL,
[CloseTime] [time] NOT NULL,
[ActiveStartDate] [date] NOT NULL,
[ActiveEndDate] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OperationHours] ADD CONSTRAINT [PK_OperationHours] PRIMARY KEY CLUSTERED  ([OperationHourID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
