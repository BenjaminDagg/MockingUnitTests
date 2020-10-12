CREATE TABLE [dbo].[MACHINE_MESSAGE]
(
[MACHINE_MESSAGE_ID] [int] NOT NULL,
[DGE_MESSAGE] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPI_MESSAGE] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MESSAGE_PARAMETERS] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CREATE_DATE] [datetime] NOT NULL CONSTRAINT [DF_MACHINE_MESSAGE_CREATE_DATE] DEFAULT (getdate()),
[UPDATE_DATE] [datetime] NOT NULL CONSTRAINT [DF_MACHINE_MESSAGE_UPDATE_DATE] DEFAULT (getdate()),
[IS_ACTIVE] [bit] NOT NULL CONSTRAINT [DF_MACHINE_MESSAGE_IS_ACTIVE] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tu_Machine_Message_Update_Date] ON [dbo].[MACHINE_MESSAGE]
FOR UPDATE
AS
IF NOT UPDATE(UPDATE_DATE) 
   UPDATE MACHINE_MESSAGE
   SET UPDATE_DATE = GetDate()
   WHERE MACHINE_MESSAGE_ID IN (SELECT MACHINE_MESSAGE_ID FROM deleted)
GO
ALTER TABLE [dbo].[MACHINE_MESSAGE] ADD CONSTRAINT [PK_MACHINE_MESSAGE] PRIMARY KEY CLUSTERED  ([MACHINE_MESSAGE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores EGM user messages.', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_MESSAGE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date/Time record created', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_MESSAGE', 'COLUMN', N'CREATE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default Message', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_MESSAGE', 'COLUMN', N'DGE_MESSAGE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if this record has been deactivated.', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_MESSAGE', 'COLUMN', N'IS_ACTIVE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK - User assigned Message identifier, maps to a Game event', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_MESSAGE', 'COLUMN', N'MACHINE_MESSAGE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Message parameters - comma separated key/value pairs', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_MESSAGE', 'COLUMN', N'MESSAGE_PARAMETERS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Third Party Message', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_MESSAGE', 'COLUMN', N'TPI_MESSAGE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date/Time record last updated', 'SCHEMA', N'dbo', 'TABLE', N'MACHINE_MESSAGE', 'COLUMN', N'UPDATE_DATE'
GO
