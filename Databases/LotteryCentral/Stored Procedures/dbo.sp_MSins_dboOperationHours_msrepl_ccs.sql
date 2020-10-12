SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboOperationHours_msrepl_ccs]
		@c1 int,
		@c2 int,
		@c3 tinyint,
		@c4 time,
		@c5 time,
		@c6 date,
		@c7 date
as
begin
if exists (select * 
             from [dbo].[OperationHours]
            where [OperationHourID] = @c1
              and [LocationID] = @c2)
begin
update [dbo].[OperationHours] set
		[WeekDayNumber] = @c3,
		[OpenTime] = @c4,
		[CloseTime] = @c5,
		[ActiveStartDate] = @c6,
		[ActiveEndDate] = @c7
where [OperationHourID] = @c1
  and [LocationID] = @c2
end
else
begin
	insert into [dbo].[OperationHours](
		[OperationHourID],
		[LocationID],
		[WeekDayNumber],
		[OpenTime],
		[CloseTime],
		[ActiveStartDate],
		[ActiveEndDate]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6,
    @c7	) 
end
end
GO
