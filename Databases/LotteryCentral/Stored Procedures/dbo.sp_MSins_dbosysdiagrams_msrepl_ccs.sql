SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dbosysdiagrams_msrepl_ccs]
		@c1 nvarchar(128),
		@c2 int,
		@c3 int,
		@c4 int,
		@c5 varbinary(max)
as
begin
if exists (select * 
             from [dbo].[sysdiagrams]
            where [diagram_id] = @c3)
begin
update [dbo].[sysdiagrams] set
		[name] = @c1,
		[principal_id] = @c2,
		[version] = @c4,
		[definition] = @c5
where [diagram_id] = @c3
end
else
begin
	insert into [dbo].[sysdiagrams](
		[name],
		[principal_id],
		[diagram_id],
		[version],
		[definition]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5	) 
end
end
GO
