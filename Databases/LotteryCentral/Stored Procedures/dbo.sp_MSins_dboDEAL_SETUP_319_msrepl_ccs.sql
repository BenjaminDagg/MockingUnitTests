SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboDEAL_SETUP_319_msrepl_ccs]
		@c1 int,
		@c2 char(1),
		@c3 varchar(64),
		@c4 int,
		@c5 int,
		@c6 smallmoney,
		@c7 smallmoney,
		@c8 varchar(32),
		@c9 datetime,
		@c10 money,
		@c11 varchar(10),
		@c12 varchar(3),
		@c13 bit,
		@c14 datetime,
		@c15 bit,
		@c16 varchar(50),
		@c17 smallmoney,
		@c18 smallint,
		@c19 tinyint,
		@c20 datetime
as
begin
if exists (select * 
             from [dbo].[DEAL_SETUP]
            where [DEAL_NO] = @c1)
begin
update [dbo].[DEAL_SETUP] set
		[TYPE_ID] = @c2,
		[DEAL_DESCR] = @c3,
		[NUMB_ROLLS] = @c4,
		[TABS_PER_ROLL] = @c5,
		[TAB_AMT] = @c6,
		[COST_PER_TAB] = @c7,
		[CREATED_BY] = @c8,
		[SETUP_DATE] = @c9,
		[JP_AMOUNT] = @c10,
		[FORM_NUMB] = @c11,
		[GAME_CODE] = @c12,
		[IS_OPEN] = @c13,
		[CLOSE_DATE] = @c14,
		[CLOSE_RECOMMENDED] = @c15,
		[CLOSED_BY] = @c16,
		[DENOMINATION] = @c17,
		[COINS_BET] = @c18,
		[LINES_BET] = @c19,
		[EXPORTED_DATE] = @c20
where [DEAL_NO] = @c1
end
else
begin
	insert into [dbo].[DEAL_SETUP](
		[DEAL_NO],
		[TYPE_ID],
		[DEAL_DESCR],
		[NUMB_ROLLS],
		[TABS_PER_ROLL],
		[TAB_AMT],
		[COST_PER_TAB],
		[CREATED_BY],
		[SETUP_DATE],
		[JP_AMOUNT],
		[FORM_NUMB],
		[GAME_CODE],
		[IS_OPEN],
		[CLOSE_DATE],
		[CLOSE_RECOMMENDED],
		[CLOSED_BY],
		[DENOMINATION],
		[COINS_BET],
		[LINES_BET],
		[EXPORTED_DATE]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6,
    @c7,
    @c8,
    @c9,
    @c10,
    @c11,
    @c12,
    @c13,
    @c14,
    @c15,
    @c16,
    @c17,
    @c18,
    @c19,
    @c20	) 
end
end
GO
