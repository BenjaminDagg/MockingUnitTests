SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboVOUCHER_LOT_msrepl_ccs]
		@c1 int,
		@c2 int,
		@c3 char(14),
		@c4 datetime
as
begin
if exists (select * 
             from [dbo].[VOUCHER_LOT]
            where [VOUCHER_LOT_ID] = @c1
              and [LOCATION_ID] = @c2)
begin
update [dbo].[VOUCHER_LOT] set
		[LOT_NUMBER] = @c3,
		[DATE_RECEIVED] = @c4
where [VOUCHER_LOT_ID] = @c1
  and [LOCATION_ID] = @c2
end
else
begin
	insert into [dbo].[VOUCHER_LOT](
		[VOUCHER_LOT_ID],
		[LOCATION_ID],
		[LOT_NUMBER],
		[DATE_RECEIVED]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	) 
end
end
GO
