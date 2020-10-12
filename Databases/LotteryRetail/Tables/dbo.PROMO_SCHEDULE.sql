CREATE TABLE [dbo].[PROMO_SCHEDULE]
(
[PromoScheduleID] [int] NOT NULL IDENTITY(1, 1),
[Comments] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PromoStart] [datetime] NOT NULL,
[PromoEnd] [datetime] NOT NULL,
[PromoStarted] [bit] NOT NULL CONSTRAINT [DF_PROMO_SCHEDULE_PromoStarted] DEFAULT ((0)),
[PromoEnded] [bit] NOT NULL CONSTRAINT [DF_PROMO_SCHEDULE_PromoEnded] DEFAULT ((0)),
[TOTAL_PROMO_AMOUNT_TICKETS] [int] NOT NULL CONSTRAINT [DF__PROMO_SCH__Promo__3A3865BB] DEFAULT ((0)),
[TOTAL_PROMO_FACTOR_TICKETS] [int] NOT NULL CONSTRAINT [DF__PROMO_SCH__Promo__3B2C89F4] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PROMO_SCHEDULE] ADD CONSTRAINT [PK_PROMO_SCHEDULE] PRIMARY KEY CLUSTERED  ([PromoScheduleID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Promotional Scheduling data used to start and stop printing of promo coupons from EGMs.', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_SCHEDULE', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'User scheduling comments', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_SCHEDULE', 'COLUMN', N'Comments'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the promo should end', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_SCHEDULE', 'COLUMN', N'PromoEnd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if promo was ended', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_SCHEDULE', 'COLUMN', N'PromoEnded'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Indentity Int', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_SCHEDULE', 'COLUMN', N'PromoScheduleID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the promo should begin', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_SCHEDULE', 'COLUMN', N'PromoStart'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if promo was started', 'SCHEMA', N'dbo', 'TABLE', N'PROMO_SCHEDULE', 'COLUMN', N'PromoStarted'
GO
