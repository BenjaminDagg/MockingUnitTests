CREATE TABLE [dbo].[PayoutWithHoldingType]
(
[PayoutWithHoldingTypeId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayoutWithHoldingType] ADD CONSTRAINT [PK_PayoutWithHoldingType] PRIMARY KEY CLUSTERED  ([PayoutWithHoldingTypeId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table holds the with holding data types.', 'SCHEMA', N'dbo', 'TABLE', N'PayoutWithHoldingType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The description of the payout with holding type.', 'SCHEMA', N'dbo', 'TABLE', N'PayoutWithHoldingType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key, for internal use.', 'SCHEMA', N'dbo', 'TABLE', N'PayoutWithHoldingType', 'COLUMN', N'PayoutWithHoldingTypeId'
GO
