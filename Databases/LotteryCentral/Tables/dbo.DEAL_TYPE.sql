CREATE TABLE [dbo].[DEAL_TYPE]
(
[TYPE_ID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEAL_TYPE_NAME] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE_DESCR] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IS_ACTIVE] [bit] NOT NULL CONSTRAINT [DF_DEAL_TYPE_IS_ACTIVE] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DEAL_TYPE] ADD CONSTRAINT [PK_DEAL_TYPE] PRIMARY KEY CLUSTERED  ([TYPE_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table of Deal Types', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_TYPE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deal Type Name (Poker or Slot)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_TYPE', 'COLUMN', N'DEAL_TYPE_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active flag indicates if this record is active or has been inactivated', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_TYPE', 'COLUMN', N'IS_ACTIVE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description - currently unused', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_TYPE', 'COLUMN', N'TYPE_DESCR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK - Deal Type (P=Poker, S=Slot, K=Keno)', 'SCHEMA', N'dbo', 'TABLE', N'DEAL_TYPE', 'COLUMN', N'TYPE_ID'
GO
