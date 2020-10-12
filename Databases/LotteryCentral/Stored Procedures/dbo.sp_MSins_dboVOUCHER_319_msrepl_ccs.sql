SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_MSins_dboVOUCHER_319_msrepl_ccs]
		@c1 int,
		@c2 int,
		@c3 smallint,
		@c4 varchar(18),
		@c5 money,
		@c6 datetime,
		@c7 varchar(16),
		@c8 varchar(32),
		@c9 bit,
		@c10 datetime,
		@c11 varbinary(8),
		@c12 int,
		@c13 int,
		@c14 int,
		@c15 bit,
		@c16 money,
		@c17 bit,
		@c18 datetime,
		@c19 int,
		@c20 int
as
begin
if exists (select * 
             from [dbo].[VOUCHER]
            where [VOUCHER_ID] = @c1
              and [LOCATION_ID] = @c2)
begin
update [dbo].[VOUCHER] set
		[VOUCHER_TYPE] = @c3,
		[BARCODE] = @c4,
		[VOUCHER_AMOUNT] = @c5,
		[CREATE_DATE] = @c6,
		[CREATED_LOC] = @c7,
		[REDEEMED_LOC] = @c8,
		[REDEEMED_STATE] = @c9,
		[REDEEMED_DATE] = @c10,
		[CHECK_VALUE] = @c11,
		[CT_TRANS_NO_VC] = @c12,
		[CT_TRANS_NO_VR] = @c13,
		[CT_TRANS_NO_JP] = @c14,
		[IS_VALID] = @c15,
		[SESSION_PLAY_AMOUNT] = @c16,
		[UCV_TRANSFERRED] = @c17,
		[UCV_TRANSFER_DATE] = @c18,
		[GAME_TITLE_ID] = @c19,
		[PROMO_VOUCHER_SESSION_ID] = @c20
where [VOUCHER_ID] = @c1
  and [LOCATION_ID] = @c2
end
else
begin
	insert into [dbo].[VOUCHER](
		[VOUCHER_ID],
		[LOCATION_ID],
		[VOUCHER_TYPE],
		[BARCODE],
		[VOUCHER_AMOUNT],
		[CREATE_DATE],
		[CREATED_LOC],
		[REDEEMED_LOC],
		[REDEEMED_STATE],
		[REDEEMED_DATE],
		[CHECK_VALUE],
		[CT_TRANS_NO_VC],
		[CT_TRANS_NO_VR],
		[CT_TRANS_NO_JP],
		[IS_VALID],
		[SESSION_PLAY_AMOUNT],
		[UCV_TRANSFERRED],
		[UCV_TRANSFER_DATE],
		[GAME_TITLE_ID],
		[PROMO_VOUCHER_SESSION_ID]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6,
    @c7,
    @c8,
    @c9,
    @c10,
    @c11,
    @c12,
    @c13,
    @c14,
    @c15,
    @c16,
    @c17,
    @c18,
    @c19,
    @c20	) 
end
end
GO
