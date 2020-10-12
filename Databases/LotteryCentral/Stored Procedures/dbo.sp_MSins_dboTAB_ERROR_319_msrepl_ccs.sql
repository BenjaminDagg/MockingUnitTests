SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboTAB_ERROR_319_msrepl_ccs]
		@c1 int,
		@c2 char(5),
		@c3 int,
		@c4 datetime,
		@c5 int,
		@c6 int
as
begin
if exists (select * 
             from [dbo].[TAB_ERROR]
            where [TAB_ERROR_ID] = @c1
              and [LOCATION_ID] = @c5)
begin
update [dbo].[TAB_ERROR] set
		[MACH_NO] = @c2,
		[ERROR_NO] = @c3,
		[EVENT_TIME] = @c4,
		[TICKET_NO] = @c6
where [TAB_ERROR_ID] = @c1
  and [LOCATION_ID] = @c5
end
else
begin
	insert into [dbo].[TAB_ERROR](
		[TAB_ERROR_ID],
		[MACH_NO],
		[ERROR_NO],
		[EVENT_TIME],
		[LOCATION_ID],
		[TICKET_NO]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6	) 
end
end
GO
