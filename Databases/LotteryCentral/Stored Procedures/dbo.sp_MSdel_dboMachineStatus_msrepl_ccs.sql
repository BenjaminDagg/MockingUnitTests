SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSdel_dboMachineStatus_msrepl_ccs]
		@pkc1 int
as
begin  
	delete [dbo].[MachineStatus]
where [MachineStatusID] = @pkc1
end  
GO
