USE [Master]

IF SUSER_ID('mas') IS NULL
CREATE LOGIN [mas] WITH PASSWORD = '#{UserMasPassword}#',
CHECK_POLICY = OFF

IF SUSER_ID('sqljobs') IS NULL
CREATE LOGIN [sqljobs] WITH PASSWORD = '#{UserSqljobsPassword}#',
CHECK_POLICY = OFF

IF SUSER_ID('reports') IS NULL
CREATE LOGIN [reports] WITH PASSWORD = '#{UserReportsPassword}#',
CHECK_POLICY = OFF

IF SUSER_ID('tp') IS NULL
CREATE LOGIN [tp] WITH PASSWORD = '#{UserTpPassword}#',
CHECK_POLICY = OFF


EXEC master..sp_addsrvrolemember @loginame = N'mas', @rolename = N'bulkadmin'
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', REG_DWORD, 3