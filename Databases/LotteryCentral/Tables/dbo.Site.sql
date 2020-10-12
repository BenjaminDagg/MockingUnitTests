CREATE TABLE [dbo].[Site]
(
[SiteId] [int] NOT NULL IDENTITY(1, 1),
[RetailerNumber] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AbbreviatedName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StreetAddress] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhoneNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FaxNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MailingName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MailingStreetAddress] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MailingCity] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MailingState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MailingZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationDate] [datetime] NOT NULL,
[ApplicationNumber] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApprovalDate] [datetime] NOT NULL,
[InstallDate] [datetime] NULL,
[FirstSalesDate] [datetime] NULL,
[TerritoryNumber] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CountyCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTimeSunday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CloseTimeSunday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTimeMonday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CloseTimeMonday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTimeTuesday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CloseTimeTuesday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTimeWednesday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CloseTimeWednesday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTimeThursday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CloseTimeThursday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTimeFriday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CloseTimeFriday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTimeSaturday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CloseTimeSaturday] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SiteApplicationComplete] [bit] NOT NULL CONSTRAINT [DF_Site_SiteApplicationComplete] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Site] ADD CONSTRAINT [PK_SiteInfo] PRIMARY KEY CLUSTERED  ([SiteId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the Site Agent general data.', 'SCHEMA', N'dbo', 'TABLE', N'Site', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent abbreviated name.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'AbbreviatedName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent application date.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'ApplicationDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent application number.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'ApplicationNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent approval date.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'ApprovalDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent business code.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'BusinessCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent city.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent close time for Friday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'CloseTimeFriday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent close time for Monday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'CloseTimeMonday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent close time for Saturday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'CloseTimeSaturday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent close time for Sunday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'CloseTimeSunday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent close time for Thursday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'CloseTimeThursday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent close time for Tuesday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'CloseTimeTuesday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent close time for Wednesday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'CloseTimeWednesday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent county code.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'CountyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent fax number.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'FaxNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent first sales date.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'FirstSalesDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent full name.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'FullName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent install date.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'InstallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent mailing city if shipping address is different from mailing address.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'MailingCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent mailing name if shipping address is different from mailing address.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'MailingName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent mailing state if shipping address is different from mailing address.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'MailingState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent mailing street address if shipping address is different from mailing address.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'MailingStreetAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent mailing zip code if shipping address is different from mailing address.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'MailingZipCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent phone number.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'PhoneNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent retailer number.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'RetailerNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The flag showing if the Site data is completely filled out.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'SiteApplicationComplete'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'SiteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent start time for Friday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'StartTimeFriday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent start time for Monday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'StartTimeMonday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent start time for Saturday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'StartTimeSaturday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent start time for Sunday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'StartTimeSunday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent start time for Thursday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'StartTimeThursday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent start time for Tuesday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'StartTimeTuesday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent start time for Wednesday.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'StartTimeWednesday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent state.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent street address.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'StreetAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent territory number.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'TerritoryNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Site Agent zip code.', 'SCHEMA', N'dbo', 'TABLE', N'Site', 'COLUMN', N'ZipCode'
GO
