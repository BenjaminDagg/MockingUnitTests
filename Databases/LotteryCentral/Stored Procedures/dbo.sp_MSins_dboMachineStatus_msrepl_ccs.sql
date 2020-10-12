SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboMachineStatus_msrepl_ccs]
		@c1 int,
		@c2 varchar(64)
as
begin
if exists (select * 
             from [dbo].[MachineStatus]
            where [MachineStatusID] = @c1)
begin
update [dbo].[MachineStatus] set
		[LongName] = @c2
where [MachineStatusID] = @c1
end
else
begin
	insert into [dbo].[MachineStatus](
		[MachineStatusID],
		[LongName]
	) values (
    @c1,
    @c2	) 
end
end
GO
