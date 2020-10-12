CREATE TABLE [dbo].[DEACTIVATED_TAB]
(
[DEACTIVATED_TAB_ID] [int] NOT NULL IDENTITY(1, 1),
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EVENT_TIME] [datetime] NOT NULL CONSTRAINT [DF_DEACTIVATED_TAB_EVENT_TIME] DEFAULT (getdate()),
[DEAL_NO] [int] NOT NULL,
[ROLL_NO] [int] NOT NULL,
[FIRST_TICKET] [int] NOT NULL,
[LAST_TICKET] [int] NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores information on tabs that were deactiviated by the Void Tabs functionality within Transaction Portal.', 'SCHEMA', N'dbo', 'TABLE', N'DEACTIVATED_TAB', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'DEACTIVATED_TAB', 'COLUMN', N'DEACTIVATED_TAB_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number', 'SCHEMA', N'dbo', 'TABLE', N'DEACTIVATED_TAB', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time tabs were deactivated', 'SCHEMA', N'dbo', 'TABLE', N'DEACTIVATED_TAB', 'COLUMN', N'EVENT_TIME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First ticket number deactivated', 'SCHEMA', N'dbo', 'TABLE', N'DEACTIVATED_TAB', 'COLUMN', N'FIRST_TICKET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last ticket number deactivated', 'SCHEMA', N'dbo', 'TABLE', N'DEACTIVATED_TAB', 'COLUMN', N'LAST_TICKET'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'DEACTIVATED_TAB', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Roll Number', 'SCHEMA', N'dbo', 'TABLE', N'DEACTIVATED_TAB', 'COLUMN', N'ROLL_NO'
GO
