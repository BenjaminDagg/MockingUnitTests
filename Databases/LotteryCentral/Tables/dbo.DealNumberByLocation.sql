CREATE TABLE [dbo].[DealNumberByLocation]
(
[DealNumber] [int] NOT NULL,
[LocationId] [int] NOT NULL,
[IsOpen] [bit] NOT NULL,
[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table keeps track of the deal numbers located at each site.', 'SCHEMA', N'dbo', 'TABLE', N'DealNumberByLocation', NULL, NULL
GO
