SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSdel_dbosysdiagrams_msrepl_ccs]
		@pkc1 int
as
begin  
	delete [dbo].[sysdiagrams]
where [diagram_id] = @pkc1
end  
GO
