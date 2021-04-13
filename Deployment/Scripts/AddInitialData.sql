IF NOT EXISTS (SELECT * FROM MACH_SETUP WHERE MACH_NO = '0    ')
BEGIN
INSERT INTO [MACH_SETUP]
           ([MACH_NO]
           ,[LOCATION_ID]
           ,[MODEL_DESC]
           ,[TYPE_ID]
           ,[GAME_CODE]
           ,[BANK_NO]
           ,[CASINO_MACH_NO]
           ,[IP_ADDRESS]
           ,[PLAY_STATUS]
           ,[PLAY_STATUS_CHANGED]
           ,[ACTIVE_FLAG]
           ,[REMOVED_FLAG]
           ,[BALANCE]
           ,[PROMO_BALANCE]
           ,[LAST_ACTIVITY]
           ,[LAST_CONNECT]
           ,[LAST_DISCONNECT]
           ,[MACH_SERIAL_NO]
           ,[VOUCHER_PRINTING]
           ,[METER_TRANS_NO]
           ,[SD_RS_FLAG]
           ,[GAME_RELEASE]
           ,[GAME_CORE_LIB_VERSION]
           ,[GAME_LIB_VERSION]
           ,[MATH_DLL_VERSION]
           ,[MATH_LIB_VERSION]
           ,[OS_VERSION]
           ,[SYSTEM_VERSION]
           ,[SYSTEM_LIB_A_VERSION]
           ,[SYSTEM_CORE_LIB_VERSION]
           ,[InstallDate]
           ,[RemoveDate]
           ,[MultiGameEnabled]
           ,[TransactionPortalIpAddress]
           ,[TransactionPortalControlPort])
     VALUES
           (
'0    ',	'1000',	'INTERNAL',	'P',	NULL,	NULL,	'0',	NULL,	'0',	NULL,	'0',	'0',	'0.00',	'0.00',	NULL,	NULL,	NULL,	NULL,	'0',	'0',	'0',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'Apr  7 2021  2:47PM',	NULL,	'0',	NULL,	NULL
           )
END


IF NOT EXISTS (SELECT * FROM DEAL_SETUP WHERE DEAL_NO = '0')
BEGIN
INSERT INTO [DEAL_SETUP]
           ([DEAL_NO]
           ,[TYPE_ID]
           ,[DEAL_DESCR]
           ,[NUMB_ROLLS]
           ,[TABS_PER_ROLL]
           ,[TAB_AMT]
           ,[COST_PER_TAB]
           ,[CREATED_BY]
           ,[SETUP_DATE]
           ,[JP_AMOUNT]
           ,[FORM_NUMB]
           ,[GAME_CODE]
           ,[IS_OPEN]
           ,[CLOSE_DATE]
           ,[CLOSE_RECOMMENDED]
           ,[CLOSED_BY]
           ,[DENOMINATION]
           ,[COINS_BET]
           ,[LINES_BET]
           ,[EXPORTED_DATE])
     VALUES
           (
           '0',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'Apr  7 2021  2:53PM',	NULL,	NULL,	NULL,	'1',	NULL,	'0',	NULL,	'0.00',	'1',	'1',	NULL
           )
END

IF NOT EXISTS (SELECT * FROM CARD_ACCT WHERE CARD_ACCT_NO = 'DGE00177777OpKey')
BEGIN
INSERT INTO [LotteryRetail].[dbo].[CARD_ACCT]
           ([CARD_ACCT_NO]
           ,[PLAYER_ID]
           ,[BALANCE]
           ,[CREATE_DATE]
           ,[SESSION_DATE]
           ,[MODIFIED_DATE]
           ,[PIN_NUMBER]
           ,[SEQ_NUM]
           ,[STATUS]
           ,[MACH_NO]
           ,[PROMO_AMOUNT]
           ,[TPI_ID])
     VALUES
           (
           'DGE00177777OpKey',	NULL,	'0.00',	'Jul 29 2008  2:01PM',	NULL,	'Dec  2 2008  3:08PM',	NULL,	NULL,	'1',	'0    ',	'0.00',	'0'
           )
END

IF NOT EXISTS (SELECT * FROM CARD_ACCT WHERE CARD_ACCT_NO = 'INTERNAL        ')
BEGIN
INSERT INTO [LotteryRetail].[dbo].[CARD_ACCT]
           ([CARD_ACCT_NO]
           ,[PLAYER_ID]
           ,[BALANCE]
           ,[CREATE_DATE]
           ,[SESSION_DATE]
           ,[MODIFIED_DATE]
           ,[PIN_NUMBER]
           ,[SEQ_NUM]
           ,[STATUS]
           ,[MACH_NO]
           ,[PROMO_AMOUNT]
           ,[TPI_ID])
     VALUES
           (
           
'INTERNAL        ',	NULL,	NULL,	'Jan  6 2011 10:34AM',	NULL,	'Jan  6 2011 10:34AM',	NULL,	NULL,	'1',	'0    ',	'0.00',	'0'
           )
END

IF NOT EXISTS (SELECT * FROM CARD_ACCT WHERE CARD_ACCT_NO = 'INVALID         ')
BEGIN
INSERT INTO [LotteryRetail].[dbo].[CARD_ACCT]
           ([CARD_ACCT_NO]
           ,[PLAYER_ID]
           ,[BALANCE]
           ,[CREATE_DATE]
           ,[SESSION_DATE]
           ,[MODIFIED_DATE]
           ,[PIN_NUMBER]
           ,[SEQ_NUM]
           ,[STATUS]
           ,[MACH_NO]
           ,[PROMO_AMOUNT]
           ,[TPI_ID])
     VALUES
           (
'INVALID         ',	NULL,	NULL,	'Jan  6 2011 10:34AM',	NULL,	'Jan  6 2011 10:34AM',	NULL,	NULL,	'1',	'0    ',	'0.00',	'0'
)
END

IF NOT EXISTS (SELECT * FROM CASINO_USERS)
BEGIN
INSERT INTO [dbo].[CASINO_USERS] ([ACCOUNTID], [ACCESS_LEVEL], [LEVEL_CODE], [FNAME], [LNAME], [PSSWD], [ACTIVE], [CREATEDDT], [DEACTIVATEDDT], [USERLOGGED], [CUR_SESSION_ID], [CUR_SESSION_STS], [SESSION_STN], [CUR_SESSION_DTIME], [APP_VERSION], [IS_CASINO_TECH], [IS_DGE_TECH], [PHASH], [PHASHDT], [IS_PASSRESET], [INVALID_ATTEMPTS], [LAST_INVALID_ATTEMPT], [IS_ACCOUNT_LOCKED]) VALUES ('77777OpKey', 0, 'Diamond_Tech', 'Diamond', 'Tech', N'1234', 1, '2009-09-09 09:09:09.000', NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 'a776b2bf370eadebae6ee8191fa8a55d', '2018-05-18 10:06:37.070', 0, 0, NULL, 0)
INSERT INTO [dbo].[CASINO_USERS] ([ACCOUNTID], [ACCESS_LEVEL], [LEVEL_CODE], [FNAME], [LNAME], [PSSWD], [ACTIVE], [CREATEDDT], [DEACTIVATEDDT], [USERLOGGED], [CUR_SESSION_ID], [CUR_SESSION_STS], [SESSION_STN], [CUR_SESSION_DTIME], [APP_VERSION], [IS_CASINO_TECH], [IS_DGE_TECH], [PHASH], [PHASHDT], [IS_PASSRESET], [INVALID_ATTEMPTS], [LAST_INVALID_ATTEMPT], [IS_ACCOUNT_LOCKED]) VALUES ('admin', 1, 'ADMIN', 'Admin', 'Admin', NULL, 1, '2018-08-14 00:04:43.217', NULL, 0, NULL, NULL, 'DESK40', NULL, '3.4.9.0 10/13/2019', 0, 1, 'a776b2bf370eadebae6ee8191fa8a55d', '2019-10-13 04:53:54.000', 0, 0, '2019-10-13 05:47:03.097', 0)
END





