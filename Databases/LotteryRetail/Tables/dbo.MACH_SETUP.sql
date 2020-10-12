CREATE TABLE [dbo].[MACH_SETUP]
(
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LOCATION_ID] [int] NOT NULL,
[MODEL_DESC] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE_ID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GAME_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_NO] [int] NULL,
[CASINO_MACH_NO] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IP_ADDRESS] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAY_STATUS] [bit] NOT NULL CONSTRAINT [DF_MACH_SETUP_PLAY_STATUS] DEFAULT ((0)),
[PLAY_STATUS_CHANGED] [datetime] NULL,
[ACTIVE_FLAG] [tinyint] NOT NULL CONSTRAINT [DF_MACH_SETUP_ACTIVE_FLAG_1] DEFAULT ((1)),
[REMOVED_FLAG] [bit] NOT NULL CONSTRAINT [DF_MACH_SETUP_REMOVED_FLAG_1] DEFAULT ((0)),
[BALANCE] [money] NOT NULL CONSTRAINT [DF_MACH_SETUP_BALANCE] DEFAULT ((0)),
[PROMO_BALANCE] [money] NOT NULL CONSTRAINT [DF_MACH_SETUP_PROMO_BALANCE] DEFAULT ((0)),
[LAST_ACTIVITY] [datetime] NULL,
[LAST_CONNECT] [datetime] NULL,
[LAST_DISCONNECT] [datetime] NULL,
[MACH_SERIAL_NO] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VOUCHER_PRINTING] [bit] NOT NULL CONSTRAINT [DF_MACH_SETUP_VOUCHER_PRINTING] DEFAULT ((0)),
[METER_TRANS_NO] [int] NOT NULL CONSTRAINT [DF_MACH_SETUP_METER_TRANS_NO] DEFAULT ((0)),
[SD_RS_FLAG] [bit] NOT NULL CONSTRAINT [DF_MACH_SETUP_SD_RS_FLAG_1] DEFAULT ((0)),
[GAME_RELEASE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MACH_SETUP_GAME_RELEASE] DEFAULT (''),
[GAME_CORE_LIB_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MACH_SETUP_GAME_CORE_LIB_VERSION] DEFAULT (''),
[GAME_LIB_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MACH_SETUP_GAME_LIB_VERSION] DEFAULT (''),
[MATH_DLL_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MACH_SETUP_MATH_DLL_VERSION] DEFAULT (''),
[MATH_LIB_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MACH_SETUP_MATH_LIB_VERSION] DEFAULT (''),
[OS_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MACH_SETUP_OS_VERSION] DEFAULT (''),
[SYSTEM_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MACH_SETUP_SYSTEM_VERSION] DEFAULT (''),
[SYSTEM_LIB_A_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MACH_SETUP_SYSTEM_LIB_A_VERSION] DEFAULT (''),
[SYSTEM_CORE_LIB_VERSION] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MACH_SETUP_SYSTEM_CORE_LIB_VERSION] DEFAULT (''),
[InstallDate] [datetime] NULL CONSTRAINT [DF_MACH_SETUP_InstallDate] DEFAULT (getdate()),
[RemoveDate] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Update Trigger tu_Mach_Setup
Created 11-07-2013 by Louis Epstein

11-07-2013 Louis Epstein
  Update RemovedDate when machine is removed
--------------------------------------------------------------------------------
*/
CREATE TRIGGER [dbo].[tu_Mach_Setup] ON [dbo].[MACH_SETUP] 
FOR UPDATE
AS

UPDATE MACH_SETUP
SET RemoveDate = GETDATE()
WHERE MACH_NO IN (
	SELECT I.MACH_NO
	FROM inserted I
	JOIN deleted D ON I.MACH_NO = D.MACH_NO
	WHERE I.REMOVED_FLAG = 1 AND D.REMOVED_FLAG = 0
)
GO
ALTER TABLE [dbo].[MACH_SETUP] ADD CONSTRAINT [CK_MACH_SETUP_MACH_NO] CHECK ((isnumeric([MACH_NO])=(1) AND ([MACH_NO]='0' OR len(ltrim(rtrim([MACH_NO])))=(5))))
GO
ALTER TABLE [dbo].[MACH_SETUP] ADD CONSTRAINT [PK_MACH_SETUP] PRIMARY KEY CLUSTERED  ([MACH_NO], [LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MACH_SETUP_CASINO_MACH_NO] ON [dbo].[MACH_SETUP] ([CASINO_MACH_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores EGM setup data.', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the Machine is active', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'ACTIVE_FLAG'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Balance on the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'BALANCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Number to which the Machine is assigned', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'BANK_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Casino Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'CASINO_MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies the Game being played', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'GAME_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Core library version used to build the game.dll (should match the system core library version)', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'GAME_CORE_LIB_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The game library version used to build the game.dll', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'GAME_LIB_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Game Release version', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'GAME_RELEASE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date at which the machine was installed', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'InstallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IP Address of the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'IP_ADDRESS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last Date and Time the Machine had activity', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'LAST_ACTIVITY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last time the EGM Connected to the TP', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'LAST_CONNECT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last time the EGM Disconnected from the TP', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'LAST_DISCONNECT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DGE Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Serial Number of the Machine', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'MACH_SERIAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Version of the math.dll', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'MATH_DLL_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The math library (common/template code) version used to build the math.dll and contains common math functionality used by all math dlls', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'MATH_LIB_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Highest CASINO_TRANS.TRANS_NO used when last Meter info successfully sent', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'METER_TRANS_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Description', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'MODEL_DESC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OS Version of the EGM', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'OS_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = not playable, 1 = playable, set by PlayStatus message from EGM when playable state changes', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'PLAY_STATUS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time of last play status change', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'PLAY_STATUS_CHANGED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Promotional Balance', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'PROMO_BALANCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the Machine is removed', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'REMOVED_FLAG'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date at which the machine was removed', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'RemoveDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shutdown / Restart flag', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'SD_RS_FLAG'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Version of the core library used to build the system.exe (should match the game core library version)', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'SYSTEM_CORE_LIB_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'System library A version of the library provided by Blue Cube', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'SYSTEM_LIB_A_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Overall system version (system.exe)', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'SYSTEM_VERSION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'(P)oker, (S)lot, or (K)eno', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'TYPE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if voucher is currently being printed', 'SCHEMA', N'dbo', 'TABLE', N'MACH_SETUP', 'COLUMN', N'VOUCHER_PRINTING'
GO
