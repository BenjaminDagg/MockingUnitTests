CREATE TABLE [dbo].[RetailSiteStatus]
(
[SiteStatusID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LocationID] [int] NOT NULL,
[PayoutsActive] [bit] NOT NULL,
[MachinesActive] [bit] NOT NULL,
[StatusComment] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastModified] [datetime] NOT NULL,
[ModifiedBy] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PendingMachineState] [bit] NOT NULL,
[StatusCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RetailSiteStatus] ADD CONSTRAINT [PK_SiteStatus] PRIMARY KEY CLUSTERED  ([SiteStatusID], [LocationID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
