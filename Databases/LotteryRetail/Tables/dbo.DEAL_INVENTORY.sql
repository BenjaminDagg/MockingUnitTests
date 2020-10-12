CREATE TABLE [dbo].[DEAL_INVENTORY]
(
[DEAL_NO] [int] NOT NULL,
[ROLL_NO] [int] NOT NULL,
[MACH_NO] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PLAY_COUNT] [int] NOT NULL CONSTRAINT [DF_DEAL_INVENTORY_PLAY_COUNT] DEFAULT ((1)),
[FIRST_PLAY] [datetime] NOT NULL CONSTRAINT [DF_DEAL_INVENTORY_FIRST_PLAY] DEFAULT (getdate()),
[LAST_PLAY] [datetime] NOT NULL CONSTRAINT [DF_DEAL_INVENTORY_LAST_PLAY] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DEAL_INVENTORY] ADD CONSTRAINT [PK_DEAL_INVENTORY] PRIMARY KEY CLUSTERED  ([DEAL_NO], [ROLL_NO], [MACH_NO]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores play counts by Deal, Roll, and EGM', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_INVENTORY', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Number', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_INVENTORY', 'COLUMN', N'DEAL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time of first play for this Deal and Roll', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_INVENTORY', 'COLUMN', N'FIRST_PLAY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time of last play for this Deal and Roll', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_INVENTORY', 'COLUMN', N'LAST_PLAY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Number', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_INVENTORY', 'COLUMN', N'MACH_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Tabs dispensed for this Deal and Roll', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_INVENTORY', 'COLUMN', N'PLAY_COUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Roll Number', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_INVENTORY', 'COLUMN', N'ROLL_NO'
GO
