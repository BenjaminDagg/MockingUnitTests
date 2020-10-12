SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboJACKPOT_msrepl_ccs]
		@c1 int,
		@c2 datetime,
		@c3 varchar(20),
		@c4 char(5),
		@c5 varchar(8),
		@c6 int,
		@c7 int,
		@c8 smallmoney,
		@c9 smallint,
		@c10 money,
		@c11 money,
		@c12 int
as
begin
if exists (select * 
             from [dbo].[JACKPOT]
            where [TRANS_NO] = @c1
              and [LOCATION_ID] = @c12)
begin
update [dbo].[JACKPOT] set
		[DTIMESTAMP] = @c2,
		[CARD_ACCT_NO] = @c3,
		[MACH_NO] = @c4,
		[CASINO_MACH_NO] = @c5,
		[DEAL_NO] = @c6,
		[TICKET_NO] = @c7,
		[PLAY_COST] = @c8,
		[TRANS_ID] = @c9,
		[TRANS_AMT] = @c10,
		[PROG_AMT] = @c11
where [TRANS_NO] = @c1
  and [LOCATION_ID] = @c12
end
else
begin
	insert into [dbo].[JACKPOT](
		[TRANS_NO],
		[DTIMESTAMP],
		[CARD_ACCT_NO],
		[MACH_NO],
		[CASINO_MACH_NO],
		[DEAL_NO],
		[TICKET_NO],
		[PLAY_COST],
		[TRANS_ID],
		[TRANS_AMT],
		[PROG_AMT],
		[LOCATION_ID]
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
    @c12	) 
end
end
GO
