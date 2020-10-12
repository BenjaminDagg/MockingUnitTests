SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboPLAY_STATS_HOURLY_msrepl_ccs]
		@c1 int,
		@c2 int,
		@c3 char(5),
		@c4 varchar(8),
		@c5 datetime,
		@c6 int,
		@c7 varchar(3),
		@c8 smallmoney,
		@c9 smallint,
		@c10 smallint,
		@c11 smallint,
		@c12 int,
		@c13 int,
		@c14 int,
		@c15 smallint,
		@c16 smallint,
		@c17 int,
		@c18 int,
		@c19 money,
		@c20 money,
		@c21 money,
		@c22 money,
		@c23 money,
		@c24 money,
		@c25 money,
		@c26 money,
		@c27 money
as
begin
if exists (select * 
             from [dbo].[PLAY_STATS_HOURLY]
            where [PLAY_STATS_HOURLY_ID] = @c1
              and [LOCATION_ID] = @c2)
begin
update [dbo].[PLAY_STATS_HOURLY] set
		[MACH_NO] = @c3,
		[CASINO_MACH_NO] = @c4,
		[ACCT_DATE] = @c5,
		[DEAL_NO] = @c6,
		[GAME_CODE] = @c7,
		[DENOM] = @c8,
		[COINS_BET] = @c9,
		[LINES_BET] = @c10,
		[HOUR_OF_DAY] = @c11,
		[PLAY_COUNT] = @c12,
		[LOSS_COUNT] = @c13,
		[WIN_COUNT] = @c14,
		[JACKPOT_COUNT] = @c15,
		[FORFEIT_COUNT] = @c16,
		[TICKET_IN_COUNT] = @c17,
		[TICKET_OUT_COUNT] = @c18,
		[AMOUNT_IN] = @c19,
		[AMOUNT_PLAYED] = @c20,
		[AMOUNT_LOST] = @c21,
		[AMOUNT_WON] = @c22,
		[AMOUNT_JACKPOT] = @c23,
		[AMOUNT_FORFEITED] = @c24,
		[AMOUNT_PROG] = @c25,
		[TICKET_IN_AMOUNT] = @c26,
		[TICKET_OUT_AMOUNT] = @c27
where [PLAY_STATS_HOURLY_ID] = @c1
  and [LOCATION_ID] = @c2
end
else
begin
	insert into [dbo].[PLAY_STATS_HOURLY](
		[PLAY_STATS_HOURLY_ID],
		[LOCATION_ID],
		[MACH_NO],
		[CASINO_MACH_NO],
		[ACCT_DATE],
		[DEAL_NO],
		[GAME_CODE],
		[DENOM],
		[COINS_BET],
		[LINES_BET],
		[HOUR_OF_DAY],
		[PLAY_COUNT],
		[LOSS_COUNT],
		[WIN_COUNT],
		[JACKPOT_COUNT],
		[FORFEIT_COUNT],
		[TICKET_IN_COUNT],
		[TICKET_OUT_COUNT],
		[AMOUNT_IN],
		[AMOUNT_PLAYED],
		[AMOUNT_LOST],
		[AMOUNT_WON],
		[AMOUNT_JACKPOT],
		[AMOUNT_FORFEITED],
		[AMOUNT_PROG],
		[TICKET_IN_AMOUNT],
		[TICKET_OUT_AMOUNT]
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
    @c20,
    @c21,
    @c22,
    @c23,
    @c24,
    @c25,
    @c26,
    @c27	) 
end
end
GO
