SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboJobStatus_msrepl_ccs]
		@c1 int,
		@c2 int,
		@c3 nvarchar(32),
		@c4 varchar(64),
		@c5 bit,
		@c6 datetime,
		@c7 datetime,
		@c8 varchar(64)
as
begin
if exists (select * 
             from [dbo].[JobStatus]
            where [JobStatusID] = @c1
              and [LocationID] = @c2)
begin
update [dbo].[JobStatus] set
		[ServerName] = @c3,
		[JobName] = @c4,
		[Success] = @c5,
		[DateDataCollectedFor] = @c6,
		[ExecutedDate] = @c7,
		[DatabaseName] = @c8
where [JobStatusID] = @c1
  and [LocationID] = @c2
end
else
begin
	insert into [dbo].[JobStatus](
		[JobStatusID],
		[LocationID],
		[ServerName],
		[JobName],
		[Success],
		[DateDataCollectedFor],
		[ExecutedDate],
		[DatabaseName]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6,
    @c7,
    @c8	) 
end
end
GO
