SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboVouchersToARFile_msrepl_ccs]
		@c1 int,
		@c2 int,
		@c3 int,
		@c4 int
as
begin
if exists (select * 
             from [dbo].[VouchersToARFile]
            where [VouchersToARFileID] = @c1
              and [LocationID] = @c2)
begin
update [dbo].[VouchersToARFile] set
		[VoucherID] = @c3,
		[DocumentNumber] = @c4
where [VouchersToARFileID] = @c1
  and [LocationID] = @c2
end
else
begin
	insert into [dbo].[VouchersToARFile](
		[VouchersToARFileID],
		[LocationID],
		[VoucherID],
		[DocumentNumber]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	) 
end
end
GO
