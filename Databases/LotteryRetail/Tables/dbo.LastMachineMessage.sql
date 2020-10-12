CREATE TABLE [dbo].[LastMachineMessage]
(
[MachineNumber] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MachineSequenceNumber] [int] NOT NULL,
[TransType] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TPResponse] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LastMachineMessage] ADD CONSTRAINT [PK_LastMachineMessage] PRIMARY KEY CLUSTERED  ([MachineNumber]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores the last message recieved from Transcation Portal to prevent it from being processed. Stored on database for persistence.', 'SCHEMA', N'dbo', 'TABLE', N'LastMachineMessage', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'DGE Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'LastMachineMessage', 'COLUMN', N'MachineNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores the last sequence number', 'SCHEMA', N'dbo', 'TABLE', N'LastMachineMessage', 'COLUMN', N'MachineSequenceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores the last TP response as XML.', 'SCHEMA', N'dbo', 'TABLE', N'LastMachineMessage', 'COLUMN', N'TPResponse'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Transaction Type of the message. ', 'SCHEMA', N'dbo', 'TABLE', N'LastMachineMessage', 'COLUMN', N'TransType'
GO
