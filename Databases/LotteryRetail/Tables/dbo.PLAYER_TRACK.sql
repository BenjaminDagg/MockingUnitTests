CREATE TABLE [dbo].[PLAYER_TRACK]
(
[PLAYER_ID] [int] NOT NULL IDENTITY(1, 1),
[LNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FNAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE1] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE2] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRIVER_LIC] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEX] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[SSN] [char] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMMENT] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATUS] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXT_ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CREATE_DATE] [datetime] NULL CONSTRAINT [DF_PLAYER_TRACK_CREATE_DATE] DEFAULT (getdate()),
[UPDATE_DATE] [datetime] NULL CONSTRAINT [DF_PLAYER_TRACK_UPDATE_DATE] DEFAULT (getdate()),
[TABS_PURCHASED] [int] NULL CONSTRAINT [DF_PLAYER_TRACK_TABS_PURCHASED] DEFAULT ((0)),
[DOLLARS_PLAYED] [money] NULL CONSTRAINT [DF_PLAYER_TRACK_DOLLARS_PLAYED] DEFAULT ((0)),
[DOLLARS_WON] [money] NULL CONSTRAINT [DF_PLAYER_TRACK_DOLLARS_WON] DEFAULT ((0)),
[PLAYER_POINTS] [numeric] (18, 4) NULL CONSTRAINT [DF_PLAYER_TRACK_PLAYER_POINTS] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PLAYER_TRACK] ADD CONSTRAINT [PK_PLAYER_TRACK] PRIMARY KEY NONCLUSTERED  ([PLAYER_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Currently not used.', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address 1', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'ADDRESS1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address 2', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'ADDRESS2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'CITY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Comment', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'COMMENT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date row was inserted', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'CREATE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of Birth', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount played', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'DOLLARS_PLAYED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount won', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'DOLLARS_WON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Drivers license number', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'DRIVER_LIC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'eMail address', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'EMAIL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'External ID', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'EXT_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Player first name', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'FNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Player last name', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'LNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone Number 1', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'PHONE1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone Number 2', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'PHONE2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'PLAYER_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accumulated player points', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'PLAYER_POINTS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sex', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'SEX'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Social Security Number', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'STATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'STATUS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of tabs purchased', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'TABS_PURCHASED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date row was last updated', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'UPDATE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zip code', 'SCHEMA', N'dbo', 'TABLE', N'PLAYER_TRACK', 'COLUMN', N'ZIP'
GO
