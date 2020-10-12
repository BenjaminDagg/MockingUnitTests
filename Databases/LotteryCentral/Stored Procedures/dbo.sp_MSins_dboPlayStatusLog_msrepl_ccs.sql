SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboPlayStatusLog_msrepl_ccs]
		@c1 int,
		@c2 int,
		@c3 char(5),
		@c4 bit,
		@c5 datetime
as
begin
if exists (select * 
             from [dbo].[PlayStatusLog]
            where [PlayStatusLogID] = @c1
              and [LocationID] = @c2)
begin
update [dbo].[PlayStatusLog] set
		[MachineNumber] = @c3,
		[PlayStatus] = @c4,
		[EventDate] = @c5
where [PlayStatusLogID] = @c1
  and [LocationID] = @c2
end
else
begin
	insert into [dbo].[PlayStatusLog](
		[PlayStatusLogID],
		[LocationID],
		[MachineNumber],
		[PlayStatus],
		[EventDate]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5	) 
end
end
GO
