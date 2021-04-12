if exists(  select name, is_published, is_subscribed, is_merge_published, is_distributor
  from sys.databases
  where is_published = 1 or is_subscribed = 1 or
  is_merge_published = 1 or is_distributor = 1)
BEGIN
SET NOEXEC ON;
END



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('tempdb..#LongPrint') IS NOT NULL
    DROP PROCEDURE #LongPrint
GO

CREATE PROCEDURE #LongPrint
      @String NVARCHAR(MAX)

AS


DECLARE
               @CurrentEnd BIGINT, 
               @offset tinyint 

print('')
set @string = replace(  replace(@string, char(13) + char(10), char(10))   , char(13), char(10)) 

WHILE LEN(@String) > 1
BEGIN


    IF CHARINDEX(CHAR(10), @String) between 1 AND 4000 
    BEGIN

           SET @CurrentEnd =  CHARINDEX(char(10), @String) -1 
           set @offset = 2
    END
    ELSE
    BEGIN
           SET @CurrentEnd = 4000
            set @offset = 1
    END   


    PRINT SUBSTRING(@String, 1, @CurrentEnd) 

    set @string = SUBSTRING(@String, @CurrentEnd+@offset, 1073741822)   

END 
print('')

GO

EXEC sp_configure 'show advanced options', 1  
GO   
RECONFIGURE;  
GO  
EXEC sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE;  
GO  
sp_configure 'Ole Automation Procedures', 1  
GO   
RECONFIGURE;
GO  

--========================================================================================================================================
--==============================		RETAIL DATABASE		==============================================================================
--==============================		RETAIL DATABASE		==============================================================================
--========================================================================================================================================

USE LotteryRetail

--========================================================================================================================================
--==============================		RETAIL DATABASE		==============================================================================
--==============================		RETAIL DATABASE		==============================================================================
--========================================================================================================================================




--Declare user defined variables
SET NOEXEC OFF;
DECLARE @RetailReplicationUserPassword nvarchar(max), @RetailDatabaseName nvarchar(max), @CentralServerName nvarchar(max), @CentralDatabaseName nvarchar(max), @CentralWebServerName nvarchar(max), 
		@CentralReplicationUserPassword nvarchar(max), @LocationID int, @RetailReplicationUser nvarchar(max), @CentralReplicationUser nvarchar(max), @CentralSQLUser nvarchar(max), @CentralSQLUserPassword nvarchar(max), @expectedCentralVersion nvarchar(max), @versionSuffix nvarchar(max)

--===========================================================================================================================================================
--===========================================================================================================================================================
--===========================================================================================================================================================
--===========================================================================================================================================================
																			--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- Set retail and central accounts for replication							--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- Can be SQL or Windows users												--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @RetailReplicationUser = '#{RetailReplicationUser}#'												--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @RetailReplicationUserPassword = '#{RetailReplicationUserPassword}#'										--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @CentralReplicationUser = '#{CentralReplicationUser}#'											--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @CentralReplicationUserPassword = '#{CentralReplicationUserPassword}#'									--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
																			--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- This is the user for the linked server.									--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- It must be an SQL user and not a windows account							--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @CentralSQLUser = '#{CentralLinkedServerUser}#'													--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @CentralSQLUserPassword = '#{CentralLinkedServerPassword}#'											--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
																			--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @CentralServerName = '#{CentralServerName}#'											--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @CentralDatabaseName = 'LotteryCentral'									--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @CentralWebServerName = ''												--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @expectedCentralVersion = '5.3.0'										--<<<<<<<<		MANDATORY SETTINGS			<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SET @versionSuffix = '_441'													--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
																			--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--===========================================================================================================================================================
--===========================================================================================================================================================
--===========================================================================================================================================================
--===========================================================================================================================================================


--Declare variables related to server settings and replication
DECLARE @publicationName nvarchar(max), @tableExample nvarchar(max), @tableSPInsert nvarchar(max), @sqlAgentUser nvarchar(max),
 @writeToFile1 nvarchar(max), @writeToFile2 nvarchar(max), @writeToFile3 nvarchar(max), @replicationFolder nvarchar(max), @command varchar(8000), @centralVersion nvarchar(max), 
 @tempParams nvarchar(max), @DataFileRestoreFolder nvarchar(max), @LogFileRestoreFolder nvarchar(max), @errorMessage nvarchar(max), @continueBit int, 
 @sqlQ nvarchar(max), @centralServerNameWithBrackets nvarchar(max), @RetailServerName nvarchar(max), @retailServerNameWithBrackets nvarchar(max), @toolsPath as nvarchar(max)

--Declare variables related to pre/post script file creation
DECLARE @objFileSystem int,@objTextStream int,@objErrorObject int,@strErrorMessage Varchar(1000),@hr int, @fileAndPathPre varchar(2000), @fileAndPathPost varchar(2000), @fileAndPath varchar(2000), @Path VARCHAR(2000),@Filename VARCHAR(2000)
, @currentSPTable nvarchar(max), @currentSPInsert nvarchar(max), @currentSPUpdate nvarchar(max),@centralServerNoBrackets nvarchar(max),@centralDatabaseNameNoBrackets nvarchar(max)
,@regeditkey nvarchar(max), @serviceProfilePath varchar(4000), @instanceName nvarchar(max), @pubDescription nvarchar(max), @syncView nvarchar(max)
,@filterName nvarchar(max), @articleName nvarchar(max), @filterClause nvarchar(max), @Source varchar(255), @Description Varchar(255), @Helpfile Varchar(255), @HelpID int


--Declare table for grabbing replication article information. Mostly needed to get the name of the auto-generated sync view name
DECLARE @ViewArticleTable TABLE ([1] nvarchar(max),ArticleName nvarchar(max),[3] nvarchar(max),[4] nvarchar(max),[5] nvarchar(max),[6] nvarchar(max),[7] nvarchar(max),[8] nvarchar(max),[9] nvarchar(max),[10] nvarchar(max),[11] nvarchar(max),[12] nvarchar(max),[13] nvarchar(max),[14] nvarchar(max),[15] nvarchar(max),[16] nvarchar(max),[17] nvarchar(max),[18] nvarchar(max),[19] nvarchar(max),[20] nvarchar(max),[21] nvarchar(max),[SyncView] nvarchar(max),[23] nvarchar(max),[24] nvarchar(max),[25] nvarchar(max),[26] nvarchar(max),[27] nvarchar(max),[28] nvarchar(max),[29] nvarchar(max),[30] nvarchar(max))

--Declare tables that store replication table info
DECLARE @ReplicationTables TABLE (TableName nvarchar(max), ReplicatedArticleName nvarchar(max), LocationIDColumnName nvarchar(max), FilterClause nvarchar(max), DeleteByIDColumnName nvarchar(max), DeleteByMaxDateTransfer bit)
DECLARE @ReplicationTablesFinal TABLE (TableName nvarchar(max), ReplicatedArticleName nvarchar(max), LocationIDColumnName nvarchar(max), FilterClause nvarchar(max), DeleteByIDColumnName nvarchar(max), DeleteByMaxDateTransfer bit, IdentityManageOption nvarchar(max))


--Define suffix for replication stored procedures. This allows multiple table structures to continue replicating during a market upgrade


-- Define replicated table properties, so that replication can be dynamically setup
INSERT @ReplicationTables VALUES ('CASINO', '', 'LOCATION_ID', '', 'LOCATION_ID', 0 )
INSERT @ReplicationTables VALUES ('DB_INFO', '', 'LocationID', '', 'LocationID', 0 )
INSERT @ReplicationTables VALUES ('DEAL_SETUP', '', 'LOCATION_ID', 'DEAL_NO <> 0', 'DEAL_NO', 0 )
INSERT @ReplicationTables VALUES ('DEAL_STATS', '', 'LOCATION_ID', '', 'DEAL_NO', 0 )
INSERT @ReplicationTables VALUES ('JACKPOT', '', 'LOCATION_ID', '', 'DTIMESTAMP', 0 )
INSERT @ReplicationTables VALUES ('JobStatus', '', 'LocationID', '', 'ExecutedDate', 1 )
INSERT @ReplicationTables VALUES ('MACH_SETUP', '', 'LOCATION_ID', '[MACH_NO] <> 0', 'LOCATION_ID', 0 )
INSERT @ReplicationTables VALUES ('MACHINE_STATS', '', 'LOCATION_ID', '', 'ACCT_DATE', 1 )
INSERT @ReplicationTables VALUES ('OperationHours', '', 'LocationID', '', 'LocationID', 0 )
INSERT @ReplicationTables VALUES ('PLAY_STATS_HOURLY', 'PLAY_STATS_HOURLY', 'LOCATION_ID', '', 'ACCT_DATE', 1 )
INSERT @ReplicationTables VALUES ('PlayStatusLog', '', 'LocationID', '', 'EventDate', 1 )
INSERT @ReplicationTables VALUES ('PROGRESSIVE_POOL', '', 'LocationID', '', 'LocationID', 0 )
INSERT @ReplicationTables VALUES ('RetailSiteStatus', '', 'LocationID', '', 'LocationID', 0 )
INSERT @ReplicationTables VALUES ('TAB_ERROR', '', 'LOCATION_ID', '', 'EVENT_TIME', 1 )
INSERT @ReplicationTables VALUES ('VOUCHER', '', 'LOCATION_ID', '', 'LOCATION_ID', 0 )
INSERT @ReplicationTables VALUES ('VOUCHER_LOT', '', 'LOCATION_ID', '', 'LOCATION_ID', 0 )
INSERT @ReplicationTables VALUES ('VouchersToARFile', '', 'LocationID', '', 'LocationID', 0 )

RAISERROR('Generating replication properties...', 0, 1) WITH NOWAIT;

--Generate the final properties relating to replication filters and identity management options
--If a LocationID column exists, the filter will add a clause to filter out and extraneous location IDs that do not match the CASINO LocationID
--Detects if an identity column exists (using a sys table) in order to set the IdentityManagementOption for replication (manual if it exists, none if it does not)
INSERT @ReplicationTablesFinal
SELECT rt.TableName
,CASE WHEN LEN(ISNULL(rt.ReplicatedArticleName, '')) > 0 THEN rt.ReplicatedArticleName ELSE rt.TableName END
,LocationIDColumnName

,CASE 
	WHEN LEN(ISNULL(rt.FilterClause, '')) > 0 THEN rt.FilterClause 
	ELSE '' 
 END + 

 CASE 
	WHEN LEN(ISNULL(rt.FilterClause, '')) > 0 AND (rt.DeleteByIDColumnName LIKE '%location%' OR DeleteByMaxDateTransfer = 1) THEN ' AND ' 
	ELSE '' 
 END + 

 CASE 
	WHEN rt.DeleteByIDColumnName LIKE '%location%' THEN rt.DeleteByIDColumnName + ' IN (SELECT LOCATION_ID FROM CASINO)' 
	ELSE '' 
 END +

  CASE 
	WHEN DeleteByMaxDateTransfer = 1 THEN 'CONVERT(date, ' + rt.DeleteByIDColumnName + ', 102) >= CONVERT(date, (SELECT VALUE1 FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = ''' + rt.TableName + '_MDT''), 102) AND ' + rt.LocationIDColumnName + ' IN (SELECT LOCATION_ID FROM CASINO)'
	ELSE '' 
 END

,DeleteByIDColumnName
,DeleteByMaxDateTransfer
,ISNULL(Identities.ManageOption, 'none')
FROM @ReplicationTables rt
LEFT OUTER JOIN (
		SELECT DISTINCT OBJECT_NAME(OBJECT_ID) AS TableName
		,'manual' AS ManageOption
		FROM     SYS.IDENTITY_COLUMNS
	) Identities ON Identities.TableName = rt.TableName


SELECT * FROM @ReplicationTablesFinal


RAISERROR('Inserting replication parameters...', 0, 1) WITH NOWAIT; --SEE DYNAMIC SQL RESULTS


SET @sqlQ = 'DECLARE @MaxParam int, @CurrentParam nvarchar(max)

SELECT @MaxParam = ISNULL(MAX(CAST(REPLACE(PAR_ID, ''PARAMREPL'', '''') AS int)), 0) + 1
  FROM CASINO_SYSTEM_PARAMETERS
  WHERE PAR_ID LIKE ''PARAMREPL%''

IF NOT EXISTS (SELECT * FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = '''

SELECT @sqlQ = COALESCE(@sqlQ, '') + TableName + '_MDT'')
BEGIN
	SELECT @CurrentParam = ''PARAMREPL'' + RIGHT(''00''+ CONVERT(VARCHAR, @MaxParam), 2)
	INSERT INTO CASINO_SYSTEM_PARAMETERS ([PAR_ID] ,[PAR_NAME] ,[PAR_DESC] ,[VALUE1] ,[VALUE2] ,[VALUE3]) VALUES (@CurrentParam, ''' + TableName + '_MDT'', ''V1 = Last date that was transferred via replication for the ' + TableName + ' table'', ''1901-01-01 01:00:00'', NULL, NULL)
	SET @MaxParam = @MaxParam + 1
END

IF NOT EXISTS (SELECT * FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = '''
FROM @ReplicationTablesFinal
WHERE DeleteByMaxDateTransfer = 1

SET @sqlQ = LEFT(@sqlQ, LEN(@sqlQ) - 72)

EXEC #LongPrint @sqlQ
EXEC(@sqlQ)


SET @continueBit = 1

--Generate/trim variables, add brackets for certain functions that require them
SELECT @CentralServerName = REPLACE(REPLACE(@CentralServerName, '[', ''), ']', '')
SELECT @RetailServerName = @@SERVERNAME
SELECT @RetailDatabaseName = DB_NAME()
SET @centralServerNameWithBrackets = '[' + @CentralServerName + ']'
SET @retailServerNameWithBrackets = '[' + @RetailServerName + ']'
SELECT @centralServerNoBrackets = REPLACE(REPLACE(@CentralServerName, '[' , ''), ']' , '')
SELECT @centralDatabaseNameNoBrackets = REPLACE(REPLACE(@CentralDatabaseName, '[' , ''), ']' , '')

UPDATE CASINO_SYSTEM_PARAMETERS SET VALUE1 = @centralServerNameWithBrackets + '.[' + @centralDatabaseNameNoBrackets + '].[dbo]' WHERE [PAR_NAME] = 'CENTRAL_SERVER_LINK'
UPDATE CASINO_SYSTEM_PARAMETERS SET VALUE1 = @CentralWebServerName WHERE [PAR_NAME] = 'CENTRAL_WEB_SERVER'

--Generate the publication name
SELECT @publicationName = REPLACE(@RetailServerName, '-', '') + 'RetailPublication'

--Generate the publication description
SET @pubDescription = 'Transactional publication of database ''' + @RetailDatabaseName + ''' from Publisher ''' + @RetailServerName + '''.'


RAISERROR('Creating linked server...', 0, 1) WITH NOWAIT;

--Create the linked server object
if exists (select srvname from master.dbo.sysservers where srvname = @CentralServerName and srvid != 0)
	EXEC sp_dropserver @CentralServerName, 'droplogins'; 

EXEC master.dbo.sp_addlinkedserver @server = @CentralServerName, @srvproduct=N'SQL Server'
EXEC master.dbo.sp_serveroption @server= @CentralServerName, @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server= @CentralServerName, @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server = @CentralServerName, @optname=N'rpc', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server= @CentralServerName, @optname=N'rpc out', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server= @CentralServerName, @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server= @CentralServerName, @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server= @CentralServerName, @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server= @CentralServerName, @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server= @CentralServerName, @optname=N'remote proc transaction promotion', @optvalue = 'false'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = @CentralServerName, @locallogin = NULL , @useself = N'False', @rmtuser = @CentralSQLUser, @rmtpassword = @CentralSQLUserPassword


RAISERROR('Testing server connectivity...', 0, 1) WITH NOWAIT; --SEE DYNAMIC SQL RESULTS


--Use try/catch statements to determine that communication and linked servers are all functioning
--Also check if the central database version is correct
BEGIN TRY
	SET @tempParams = '@centralVersion nvarchar(max) OUTPUT'
	SET @sqlQ = 'SELECT @centralVersion = UpgradeVersion FROM '+@centralServerNameWithBrackets+'.'+@CentralDatabaseName+'.dbo.DBInfoCentral WHERE DBInfoID = (SELECT MAX(DBInfoID) FROM '+@centralServerNameWithBrackets+'.'+@CentralDatabaseName+'.dbo.DBInfoCentral)'
	
	EXEC #LongPrint @sqlQ
	EXEC sp_executesql @sqlQ, @tempParams, @centralVersion = @centralVersion OUTPUT

	IF @centralVersion <> @expectedCentralVersion
	SET @continueBit = -2

END TRY
BEGIN CATCH
	SET @continueBit = 0
	SELECT @errorMessage = ERROR_MESSAGE()
END CATCH

--Use try/catch statements to determine that communication and linked servers are all functioning
BEGIN TRY
	SET @sqlQ = 
	'EXEC(''EXEC sp_testlinkedserver [' + @@SERVERNAME + ']'') AT ' + @centralServerNameWithBrackets
	EXEC #LongPrint @sqlQ
	EXEC(@sqlQ)

	SET @sqlQ = 
	'EXEC(''DECLARE @TempVar nvarchar(max)
SELECT @TempVar = CAS_ID FROM [' + @@SERVERNAME + '].' + @RetailDatabaseName + '.dbo.CASINO'') AT ' + @centralServerNameWithBrackets
	EXEC #LongPrint @sqlQ
	EXEC(@sqlQ)

END TRY
BEGIN CATCH
	SET @continueBit = -1
	SELECT @errorMessage = ERROR_MESSAGE()
END CATCH

IF @continueBit = -1
BEGIN
BEGIN TRY
	SET @continueBit = 1

	SET @sqlQ = 
	'EXEC(''EXEC sp_testlinkedserver [' + @@SERVERNAME + ']'') AS USER =''mas'' AT ' + @centralServerNameWithBrackets
	EXEC #LongPrint @sqlQ
	EXEC(@sqlQ)

	SET @sqlQ = 
	'EXEC(''DECLARE @TempVar nvarchar(max)
SELECT @TempVar = CAS_ID FROM [' + @@SERVERNAME + '].' + @RetailDatabaseName + '.dbo.CASINO'') AS USER =''mas'' AT ' + @centralServerNameWithBrackets
	EXEC #LongPrint @sqlQ
	EXEC(@sqlQ)

END TRY
BEGIN CATCH
	SET @continueBit = -1
	SELECT @errorMessage = ERROR_MESSAGE()
END CATCH
END


--Throw descriptive errors if communication is unsuccessful, then stop execution of the script
IF @continueBit = 0
BEGIN
	SET @errorMessage = 'Central server connection unsuccessful. Check linked server settings and/or networking on RETAIL server. 
Error message: ' + @errorMessage
	RAISERROR(@errorMessage,18,1) 
	SET NOEXEC ON;
END
	
IF @continueBit = -1
BEGIN
	SET @errorMessage = 'Central server connection to retail server was unsuccessful. Check linked server settings and/or networking on CENTRAL server. 
Error message: ' + @errorMessage
	RAISERROR(@errorMessage,18,1) 
	SET NOEXEC ON;
END
	
IF @continueBit = -2
BEGIN
	RAISERROR('Central server version did not match the expected version. Please update central server.',18,1) 
	SET NOEXEC ON;
END



--If all connection tests were successful, continue adding replication
IF @continueBit = 1
BEGIN
	BEGIN TRY

	RAISERROR('Creating distributor service/database...', 0, 1) WITH NOWAIT; --SEE DYNAMIC SQL RESULTS

	--Create Distribution at subscriber if distribution is not already enabled
	IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'distribution')
	BEGIN
		SET @sqlQ =
'USE master

DECLARE @DataFileRestoreFolder nvarchar(max), @LogFileRestoreFolder nvarchar(max), @replicationFolder nvarchar(max)
SELECT @DataFileRestoreFolder = 
SUBSTRING(physical_name, 1, LEN(physical_name) - CHARINDEX(''\'',REVERSE(physical_name))) 
FROM sys.master_files
WHERE database_id = DB_ID(''' + @RetailDatabaseName + ''') AND FILE_ID = 1

SELECT @LogFileRestoreFolder = 
SUBSTRING(physical_name, 1, LEN(physical_name) - CHARINDEX(''\'',REVERSE(physical_name))) 
FROM sys.master_files
WHERE database_id = DB_ID(''' + @RetailDatabaseName + ''') AND FILE_ID = 2

SET @replicationFolder = @DataFileRestoreFolder + ''\..\ReplData''

EXEC sp_adddistributor @distributor = N''' + @RetailServerName + ''', @password = N'



		--Password must be specified if SQL Authentication is being used
		IF CHARINDEX('\', @RetailReplicationUser) > 0
		BEGIN
			SET @sqlQ = @sqlQ + ''''''
		END
		ELSE
		BEGIN
			SET @sqlQ = @sqlQ + '''' + @RetailReplicationUserPassword + ''''
		END


		SET @sqlQ = @sqlQ + '
EXEC sp_adddistributiondb @database = N''distribution''
, @data_folder = @DataFileRestoreFolder
, @log_folder = @LogFileRestoreFolder
, @log_file_size = 2, @min_distretention = 0, @max_distretention = 72, @history_retention = 48, @security_mode = 1

EXEC sp_adddistpublisher @publisher = N''' + @RetailServerName + ''', @distribution_db = N''distribution'', '


		--Credentials must be specified if SQL Authentication is being used
		IF CHARINDEX('\', @RetailReplicationUser) > 0
		BEGIN
			SET @sqlQ = @sqlQ + '@security_mode = 1'
		END
		ELSE
		BEGIN
			SET @sqlQ = @sqlQ + '@security_mode = 0, @login = N''' + @RetailReplicationUser + ''', @password = N''' + @RetailReplicationUserPassword + ''''
		END

		SET @sqlQ = @sqlQ + ', @working_directory = @replicationFolder
, @trusted = N''false'', @thirdparty_flag = 0, @publisher_type = N''MSSQLSERVER'''

		EXEC #LongPrint @sqlQ
		EXEC(@sqlQ)
	END


	END TRY
	BEGIN CATCH
		SET @continueBit = -3
		SELECT @errorMessage = ERROR_MESSAGE()
	END CATCH

END


IF @continueBit = -3
BEGIN
SET @errorMessage = 'Failed to create distribution. 
Error message: ' + @errorMessage
	RAISERROR(@errorMessage,18,1) 
	SET NOEXEC ON;
END



--If all connection tests and distribution creation are successful, continue adding replication
IF @continueBit = 1
BEGIN



	--Use the registry value to find the service profile folder path
	SET @regeditkey = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-20'
	EXEC master..xp_regread 'HKEY_LOCAL_MACHINE', @regeditkey, 'ProfileImagePath', @serviceProfilePath OUTPUT



	SET @Path = @serviceProfilePath + '\AppData\Local'
	SET @Filename = 'PreSnapshot.sql'
	SELECT @Path




	RAISERROR('Generating presnapshot deletion script...', 0, 1) WITH NOWAIT; --SEE DYNAMIC SQL RESULTS

	--Create deletion script (PreSnapshot) based on properties specified in the replication article table
	SET @writeToFile1 = 'DECLARE @MaxReplDate date
DECLARE @LocationIDs TABLE (LocationID int)

INSERT @LocationIDs
SELECT LOCATION_ID FROM ' + @retailServerNameWithBrackets + '.' + @RetailDatabaseName + '.dbo.CASINO

SELECT @MaxReplDate = CONVERT(date, (SELECT VALUE1 FROM ' + @retailServerNameWithBrackets + '.' + @RetailDatabaseName + '.dbo.CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = ''MaxDateTransferred''), 102)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES T JOIN INFORMATION_SCHEMA.COLUMNS C ON C.TABLE_NAME = T.TABLE_NAME WHERE T.TABLE_NAME = '''


	SELECT @writeToFile1 = COALESCE(@writeToFile1, '') + ReplicatedArticleName + ''' AND C.COLUMN_NAME = ''' + DeleteByIDColumnName + ''')
DELETE FROM ' + ReplicatedArticleName + ' WHERE ' + DeleteByIDColumnName + ' IN (SELECT LocationID FROM @LocationIDs)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES T JOIN INFORMATION_SCHEMA.COLUMNS C ON C.TABLE_NAME = T.TABLE_NAME WHERE T.TABLE_NAME = '''
FROM @ReplicationTablesFinal
WHERE DeleteByIDColumnName LIKE '%location%' AND DeleteByMaxDateTransfer = 0


	SET @writeToFile1 = LEFT(@writeToFile1, LEN(@writeToFile1) - 140)



	SET @writeToFile2 = 'IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES T JOIN INFORMATION_SCHEMA.COLUMNS C ON C.TABLE_NAME = T.TABLE_NAME WHERE T.TABLE_NAME = '''

	SELECT @writeToFile2 = COALESCE(@writeToFile2, '') + ReplicatedArticleName + ''' AND C.COLUMN_NAME = ''' + DeleteByIDColumnName + ''')
DELETE FROM ' + ReplicatedArticleName + ' WHERE ' + DeleteByIDColumnName + ' IN (SELECT DISTINCT ' + DeleteByIDColumnName + ' FROM ' + @retailServerNameWithBrackets + '.' + @RetailDatabaseName + '.dbo.' + TableName + ')
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES T JOIN INFORMATION_SCHEMA.COLUMNS C ON C.TABLE_NAME = T.TABLE_NAME WHERE T.TABLE_NAME = '''
	FROM @ReplicationTablesFinal
	WHERE DeleteByIDColumnName NOT LIKE '%location%'  AND DeleteByMaxDateTransfer = 0

	SET @writeToFile2 = LEFT(@writeToFile2, LEN(@writeToFile2) - 140)

	IF EXISTS (SELECT * FROM @ReplicationTablesFinal WHERE DeleteByMaxDateTransfer = 1)
	BEGIN

	SET @writeToFile3 = 'SELECT @MaxReplDate = CONVERT(date, (SELECT VALUE1 FROM ' 

	SELECT @writeToFile3 = COALESCE(@writeToFile3, '') + @retailServerNameWithBrackets + '.' + @RetailDatabaseName + '.dbo.CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = ''' + TableName + '_MDT''), 102)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES T JOIN INFORMATION_SCHEMA.COLUMNS C ON C.TABLE_NAME = T.TABLE_NAME WHERE T.TABLE_NAME = ''' + ReplicatedArticleName + ''' AND C.COLUMN_NAME = ''' + DeleteByIDColumnName + ''')
DELETE FROM ' + ReplicatedArticleName + ' WHERE ' + LocationIDColumnName + ' IN (SELECT LocationID FROM @LocationIDs) AND CONVERT(date, ' + DeleteByIDColumnName + ', 102) >= @MaxReplDate

SELECT @MaxReplDate = CONVERT(date, (SELECT VALUE1 FROM '
	FROM @ReplicationTablesFinal
	WHERE DeleteByMaxDateTransfer = 1

	SET @writeToFile3 = LEFT(@writeToFile3, LEN(@writeToFile3) - 58)

	END

	SET @writeToFile1 = @writeToFile1 + '
' + @writeToFile2 + '
' + @writeToFile3 

	EXEC #LongPrint @writeToFile1

	RAISERROR('Saving presnapshot deletion script to file...', 0, 1) WITH NOWAIT;

	--Write/save PreSnapshot script to a file
	SELECT @strErrorMessage='opening the File System Object'
	EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT

	SELECT @FileAndPath = @path+'\'+@filename
	SELECT @fileAndPathPre = @FileAndPath
	IF @HR=0 SELECT @objErrorObject=@objFileSystem , @strErrorMessage='Creating file "'+@FileAndPath+'"'
	IF @HR=0 EXECUTE @hr = sp_OAMethod   @objFileSystem   , 'CreateTextFile'
		, @objTextStream OUT, @FileAndPath,2,True

	IF @HR=0 SELECT @objErrorObject=@objTextStream, 
		@strErrorMessage='writing to the file "'+@FileAndPath+'"'
	IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Write', Null, @writeToFile1

	IF @HR=0 SELECT @objErrorObject=@objTextStream, @strErrorMessage='closing the file "'+@FileAndPath+'"'
	IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Close'

	IF @HR<>0
		BEGIN
		EXECUTE sp_OAGetErrorInfo  @objErrorObject, 
			@source OUTPUT,@Description OUTPUT,@Helpfile OUTPUT,@HelpID OUTPUT
		SELECT @strErrorMessage='Error while creating file: '
				+coalesce(@strErrorMessage,'')
				+', '+coalesce(@Description,'')
		RAISERROR (@strErrorMessage,16,1)
		END
	EXECUTE  sp_OADestroy @objTextStream
	EXECUTE sp_OADestroy @objTextStream


	RAISERROR('Generating postsnapshot MaxTimestamp script...', 0, 1) WITH NOWAIT; --SEE DYNAMIC SQL RESULTS

	--Generate a script that will update/record the max timestamp that has been replicated to central for the specified tables
	SET @writeToFile1 = 'DECLARE @LocationIDs TABLE (LocationID int)

INSERT @LocationIDs
SELECT LOCATION_ID FROM ' + @retailServerNameWithBrackets + '.' + @RetailDatabaseName + '.dbo.CASINO

UPDATE '

	SELECT @writeToFile1 = COALESCE(@writeToFile1, '') + @retailServerNameWithBrackets + '.[' + @RetailDatabaseName + '].[dbo].[CASINO_SYSTEM_PARAMETERS]
   SET [VALUE1] = ISNULL(CONVERT(nvarchar(max), (SELECT MAX(' + DeleteByIDColumnName + ') FROM ' + ReplicatedArticleName + ' WHERE ' + LocationIDColumnName + ' IN (SELECT LocationID FROM @LocationIDs)), 20), ''1900-01-01 01:00:00'')
 WHERE PAR_NAME = ''' + TableName + '_MDT''

UPDATE '
	FROM @ReplicationTablesFinal
	WHERE DeleteByMaxDateTransfer = 1

	SET @writeToFile1 = LEFT(@writeToFile1, LEN(@writeToFile1) - 10)

	EXEC #LongPrint @writeToFile1

	SET @Filename = 'PostSnapshot.sql'



	RAISERROR('Saving postsnapshot MaxTimestamp script to file...', 0, 1) WITH NOWAIT;

	--Write/save PostSnapshot script to a file
	SELECT @strErrorMessage='opening the File System Object'
	EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT

	SELECT @FileAndPath = @path+'\'+@filename
	SELECT @fileAndPathPost = @FileAndPath
	IF @HR=0 SELECT @objErrorObject=@objFileSystem , @strErrorMessage='Creating file "'+@FileAndPath+'"'
	IF @HR=0 EXECUTE @hr = sp_OAMethod   @objFileSystem   , 'CreateTextFile'
		, @objTextStream OUT, @FileAndPath,2,True

	IF @HR=0 SELECT @objErrorObject=@objTextStream, 
		@strErrorMessage='writing to the file "'+@FileAndPath+'"'
	IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Write', Null, @writeToFile1

	IF @HR=0 SELECT @objErrorObject=@objTextStream, @strErrorMessage='closing the file "'+@FileAndPath+'"'
	IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Close'

	IF @HR<>0
		BEGIN
		EXECUTE sp_OAGetErrorInfo  @objErrorObject, 
			@source OUTPUT,@Description OUTPUT,@Helpfile OUTPUT,@HelpID OUTPUT
		SELECT @strErrorMessage='Error while creating file: '
				+coalesce(@strErrorMessage,'')
				+', '+coalesce(@Description,'')
		RAISERROR (@strErrorMessage,16,1)
		END
	EXECUTE  sp_OADestroy @objTextStream
	EXECUTE sp_OADestroy @objTextStream



	--If Windows Authentication is being used, set the necessary permissions
	IF CHARINDEX('\', @RetailReplicationUser) > 0
	BEGIN

		RAISERROR('Setting permissions for replication user...', 0, 1) WITH NOWAIT;

		SET @sqlQ = 'USE [master]
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N''' + @RetailReplicationUser + ''')
CREATE LOGIN [' + @RetailReplicationUser + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master]

USE [distribution]
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N''' + @RetailReplicationUser + ''') DROP USER [' + @RetailReplicationUser + ']

USE [' + @RetailDatabaseName + ']
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N''' + @RetailReplicationUser + ''') DROP USER [' + @RetailReplicationUser + ']'
		
		EXEC #LongPrint @sqlQ
		EXEC(@sqlQ)


		SET @sqlQ = 'USE [distribution]
CREATE USER [' + @RetailReplicationUser + '] FOR LOGIN [' + @RetailReplicationUser + ']
EXEC sp_addrolemember N''db_owner'', N''' + @RetailReplicationUser + ''''
EXEC(@sqlQ)


		SET @sqlQ = 'USE [' + @RetailDatabaseName + ']
CREATE USER [' + @RetailReplicationUser + '] FOR LOGIN [' + @RetailReplicationUser + ']
EXEC sp_addrolemember N''db_owner'', N''' + @RetailReplicationUser + ''''

		EXEC #LongPrint @sqlQ
		EXEC(@sqlQ)

	END


	RAISERROR('Enabling replication on database...', 0, 1) WITH NOWAIT;

	--Set replication option for the database
	EXEC sp_replicationdboption @dbname = @RetailDatabaseName, @optname = N'publish', @value = N'true'


	--Create the jobs for replication log readers. Queries are slightly different depending on the type of authentication
	IF CHARINDEX('\', @RetailReplicationUser) > 0
	BEGIN
		RAISERROR('Creating replication jobs (Windows user)...', 0, 1) WITH NOWAIT; 

		SET @sqlQ = 'EXEC [' + @retailDatabaseName + '].sys.sp_addlogreader_agent @job_login = ''' + @RetailReplicationUser + ''', @job_password = ''' + @RetailReplicationUserPassword + ''', @publisher_security_mode = 1, @job_name = null'

		EXEC #LongPrint @sqlQ
		EXEC(@sqlQ)

		SET @sqlQ =  'EXEC [' + @retailDatabaseName + '].sys.sp_addqreader_agent @job_login = ''' + @RetailReplicationUser + ''', @job_password = ''' + @RetailReplicationUserPassword + ''', @frompublisher = 1'

		EXEC #LongPrint @sqlQ
		EXEC(@sqlQ)

		EXEC sp_addpublication @publication = @publicationName, @description = @pubDescription, @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @pre_snapshot_script = @fileAndPathPre, @post_snapshot_script = @fileAndPathPost, @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
		EXEC sp_addpublication_snapshot @publication = @publicationName, @frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = @RetailReplicationUser, @job_password = @RetailReplicationUserPassword, @publisher_security_mode = 1
	END
	ELSE
	BEGIN
		RAISERROR('Creating replication jobs (SQL user)...', 0, 1) WITH NOWAIT; --SEE DYNAMIC SQL RESULTS

		SET @sqlQ = 'EXEC [' + @RetailDatabaseName + '].sys.sp_addlogreader_agent @job_login = null, @job_password = null, @publisher_security_mode = 1'

		EXEC #LongPrint @sqlQ
		EXEC(@sqlQ)

		SET @sqlQ =  'EXEC [' + @RetailDatabaseName + '].sys.sp_addqreader_agent @job_login = null, @job_password = null, @frompublisher = 1'

		EXEC #LongPrint @sqlQ
		EXEC(@sqlQ)

		EXEC sp_addpublication @publication = @publicationName, @description = @pubDescription, @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @pre_snapshot_script = @fileAndPathPre, @post_snapshot_script = @fileAndPathPost, @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
		EXEC sp_addpublication_snapshot @publication = @publicationName, @frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = null, @job_password = null, @publisher_security_mode = 0, @publisher_login = @RetailReplicationUser, @publisher_password = @RetailReplicationUserPassword
	END

	RAISERROR('Setting replication permissions...', 0, 1) WITH NOWAIT;

	--Add the necessary permissions for various users
	IF  EXISTS (SELECT * FROM sys.server_principals r INNER JOIN sys.server_role_members m ON r.principal_id = m.role_principal_id INNER JOIN sys.server_principals p ON p.principal_id = m.member_principal_id WHERE r.type = 'R' and r.name = N'sysadmin' AND p.name = 'NT AUTHORITY\SYSTEM')
	EXEC sp_grant_publication_access @publication = @publicationName, @login = N'NT AUTHORITY\SYSTEM'

	IF  EXISTS (SELECT * FROM sys.server_principals r INNER JOIN sys.server_role_members m ON r.principal_id = m.role_principal_id INNER JOIN sys.server_principals p ON p.principal_id = m.member_principal_id WHERE r.type = 'R' and r.name = N'sysadmin' AND p.name = 'NT AUTHORITY\NETWORK SERVICE')
	EXEC sp_grant_publication_access @publication = @publicationName, @login = N'NT AUTHORITY\NETWORK SERVICE'

	EXEC sp_grant_publication_access @publication = @publicationName, @login = @RetailReplicationUser
	EXEC sp_grant_publication_access @publication = @publicationName, @login = N'NT SERVICE\SQLSERVERAGENT'
	EXEC sp_grant_publication_access @publication = @publicationName, @login = N'NT SERVICE\MSSQLSERVER'
	EXEC sp_grant_publication_access @publication = @publicationName, @login = N'distributor_admin'


	RAISERROR('Generating replication articles...', 0, 1) WITH NOWAIT; --SEE DYNAMIC SQL RESULTS
 
	--Generate queries to create replication articles based on the replication article table
	SET @sqlQ = 'EXEC sp_addarticle @publication = N'''

	SELECT @sqlQ = COALESCE(@sqlQ, '') + @publicationName + ''', @article = N''' + TableName + ''', @source_owner = N''dbo'', @source_object = N''' + TableName + ''', @type = N''logbased'', @description = N'''', @creation_script = N'''', @pre_creation_cmd = N''none'', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N''' + IdentityManageOption + ''', @destination_table = N''' + ReplicatedArticleName + ''', @destination_owner = N''dbo'', @status = 24, @vertical_partition = N''false'', @ins_cmd = N''CALL [dbo].[sp_MSins_dbo' + TableName + @versionSuffix + ']'', @del_cmd = N''CALL [dbo].[sp_MSdel_dbo' + TableName + @versionSuffix + ']'', @upd_cmd = N''SCALL [dbo].[sp_MSupd_dbo' + TableName + @versionSuffix + ']''
EXEC sp_addarticle @publication = N'''
	FROM @ReplicationTablesFinal

	SET @sqlQ = LEFT(@sqlQ, LEN(@sqlQ) - 36)

	--Create the replication articles
	EXEC #LongPrint @sqlQ
	EXEC (@sqlQ)


	--Grab information about the articles that were just created. Basically, the newly created view is needed to define replication filters
	INSERT @ViewArticleTable EXEC sp_helparticle @publication = @publicationName

	RAISERROR('Generating replication filters...', 0, 1) WITH NOWAIT; --SEE DYNAMIC SQL RESULTS

	--Generate queries to create replication filters based on the replication article table
	SET @sqlQ = 'EXEC sp_articlefilter @publication = N'''
	SELECT @sqlQ = COALESCE(@sqlQ, '') + @publicationName + ''', @article = N''' + rt.TableName + ''', @filter_name = N''FLTR_' + rt.TableName + '_1__69'', @filter_clause = N''' + REPLACE(rt.FilterClause, '''', '''''') + ''', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articleview @publication = N''' + @publicationName + ''', @article = N''' + rt.TableName + ''', @view_name = N''' + vt.SyncView + ''', @filter_clause = N''' + REPLACE(rt.FilterClause, '''', '''''') + ''', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlefilter @publication = N'''
	FROM @ReplicationTablesFinal rt
	JOIN @ViewArticleTable vt ON vt.ArticleName = rt.TableName
	WHERE LEN(ISNULL(rt.FilterClause, '')) > 0

	SET @sqlQ = LEFT(@sqlQ, LEN(@sqlQ) - 39)

	--Create the replication filters
	EXEC #LongPrint @sqlQ
	EXEC (@sqlQ)

	RAISERROR('Creating subscription...', 0, 1) WITH NOWAIT;

	--Create a subscription
	EXEC sp_addsubscription @publication = @publicationName, @subscriber = @centralServerNoBrackets, @destination_db = @centralDatabaseNameNoBrackets, @subscription_type = N'Push', @sync_type = N'automatic', @article = N'all', @update_mode = N'read only', @subscriber_type = 0

	--Create a subscription agent. Query is slightly different depending on type of authentication
	IF CHARINDEX('\', @RetailReplicationUser) > 0
	BEGIN
		EXEC sp_addpushsubscription_agent @publication = @publicationName, @subscriber = @CentralServerName, @subscriber_db = @CentralDatabaseName, @job_login = @CentralReplicationUser, @job_password = @CentralReplicationUserPassword, @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @enabled_for_syncmgr = N'False', @dts_package_location = N'Distributor'
	END
	ELSE
	BEGIN
		EXEC sp_addpushsubscription_agent @publication = @publicationName, @subscriber = @centralServerNoBrackets, @subscriber_db = @centralDatabaseNameNoBrackets, @job_login = null, @job_password = null, @subscriber_security_mode = 0, @subscriber_login = @CentralReplicationUser, @subscriber_password = @CentralReplicationUserPassword, @frequency_type = 64, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @dts_package_location = N'Distributor'
	END

	RAISERROR('Changing ownership of replication jobs...', 0, 1) WITH NOWAIT; --SEE DYNAMIC SQL RESULTS

	--Change the job ownership for replication jobs
	SET @sqlQ = 'USE [msdb]

EXEC msdb.dbo.sp_update_job @job_id=N'''

	SELECT @sqlQ = COALESCE(@sqlQ, '') + CAST(j.job_id AS nvarchar(max)) + ''', @owner_login_name=N''' + @RetailReplicationUser + '''
EXEC msdb.dbo.sp_update_job @job_id=N'''
	FROM    msdb.dbo.sysjobs j
	JOIN msdb.dbo.syscategories c ON j.category_id = c.category_id
	WHERE c.name LIKE 'REPL%'

	SET @sqlQ = LEFT(@sqlQ, LEN(@sqlQ) - 40)

	EXEC #LongPrint @sqlQ
	EXEC (@sqlQ)
	


	RAISERROR('Marking replication for reinitialization...', 0, 1) WITH NOWAIT;

	--Mark replication for reinitialization with a new snapshot
	EXEC sp_reinitsubscription 
		@subscriber = @CentralServerName,
		@destination_db = @CentralDatabaseName,
		@publication = @publicationName,
		@invalidate_snapshot = 1


	RAISERROR('Starting snapshot agent...', 0, 1) WITH NOWAIT;

	--Generate the snapshot
	EXEC sp_startpublication_snapshot @publication = @publicationName





	END
GO

 
EXEC sp_configure 'xp_cmdshell', 0
GO
RECONFIGURE;  
GO  
sp_configure 'Ole Automation Procedures', 0  
GO   
RECONFIGURE;
GO  
EXEC sp_configure 'show advanced options', 0  
GO   
RECONFIGURE;  
GO 

IF OBJECT_ID('tempdb..#LongPrint') IS NOT NULL
    DROP PROCEDURE #LongPrint
GO