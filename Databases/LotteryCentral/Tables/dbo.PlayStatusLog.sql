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
