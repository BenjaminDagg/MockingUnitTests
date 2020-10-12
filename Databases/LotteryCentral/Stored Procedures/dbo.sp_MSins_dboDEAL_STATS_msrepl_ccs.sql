SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboDEAL_STATS_msrepl_ccs]
		@c1 int,
		@c2 int,
		@c3 int,
		@c4 int,
		@c5 int,
		@c6 int,
		@c7 money,
		@c8 money,
		@c9 money,
		@c10 money,
		@c11 money,
		@c12 money,
		@c13 datetime,
		@c14 datetime
as
begin
if exists (select * 
             from [dbo].[DEAL_STATS]
            where [DEAL_NO] = @c1)
begin
update [dbo].[DEAL_STATS] set
		[PLAY_COUNT] = @c2,
		[WIN_COUNT] = @c3,
		[LOSS_COUNT] = @c4,
		[FORFEIT_COUNT] = @c5,
		[JACKPOT_COUNT] = @c6,
		[AMOUNT_PLAYED] = @c7,
		[TOTAL_WIN_AMOUNT] = @c8,
		[BASE_AMOUNT_WON] = @c9,
		[PROG_AMOUNT_WON] = @c10,
		[AMOUNT_FORFEITED] = @c11,
		[PROG_CONTRIBUTION] = @c12,
		[FIRST_PLAY] = @c13,
		[LAST_PLAY] = @c14
where [DEAL_NO] = @c1
end
else
begin
	insert into [dbo].[DEAL_STATS](
		[DEAL_NO],
		[PLAY_COUNT],
		[WIN_COUNT],
		[LOSS_COUNT],
		[FORFEIT_COUNT],
		[JACKPOT_COUNT],
		[AMOUNT_PLAYED],
		[TOTAL_WIN_AMOUNT],
		[BASE_AMOUNT_WON],
		[PROG_AMOUNT_WON],
		[AMOUNT_FORFEITED],
		[PROG_CONTRIBUTION],
		[FIRST_PLAY],
		[LAST_PLAY]
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
    @c14	) 
end
end
GO
