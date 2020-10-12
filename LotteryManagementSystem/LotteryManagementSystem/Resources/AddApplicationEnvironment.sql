



--DECLARE @ApplicationName 			VARCHAR(128)
--DECLARE @ApplicationVersion			VARCHAR(32)
--DECLARE @ApplicationType			VARCHAR(32)
--DECLARE @ApplicationPath			VARCHAR(255)
--DECLARE @ApplicationAssemblyPath	VARCHAR(255)
--DECLARE @ProcessUserIdentity		VARCHAR(255)
--DECLARE @DeviceName					VARCHAR(255)
--DECLARE @DeviceOs					VARCHAR(255)
--DECLARE @IsOperatingSystem64Bit		bit
--DECLARE @ProcessorCount				smallint
--DECLARE @TotalPhyiscalMemory		bigint
--DECLARE @TotalVirtualMemory			bigint
--DECLARE @AvaliablePhysicalMemory	bigint
--DECLARE @AvaliableVirtualMemory		bigint


--SET @ApplicationName = 'LotteryManagementSystem'	
--SET @DeviceName				= 'LAP63'
		
--SET @DeviceOs				= 'd'

--SET @ApplicationVersion	= 1		
--SET @ApplicationType	= 'Web'		
--SET @ApplicationPath = 'd'	
--SET @ApplicationAssemblyPath = 'd'	
--SET @ProcessUserIdentity	= 'd'


--SET @IsOperatingSystem64Bit = 1
--SET @ProcessorCount				= 1
--SET @TotalPhyiscalMemory		= 1
--SET @TotalVirtualMemory			= 1
--SET @AvaliablePhysicalMemory	= 1
--SET @AvaliableVirtualMemory		= 1




DECLARE @LastModifiedDate			datetime
  
  
-- Variable Initialization
SET @LastModifiedDate = GetDate()

-- Does a row already exist for the application and computer names?
IF EXISTS(SELECT * FROM AppEnvironment WHERE ApplicationName = @ApplicationName AND DeviceName = @DeviceName)

   -- Yes, so update it.
   BEGIN

SELECT @ApplicationName, @DeviceOs 

         
      UPDATE AppEnvironment SET
         ApplicationVersion        = @ApplicationVersion,
         LastModifiedDate          = @LastModifiedDate,
         DeviceOs	               = @DeviceOs,
         IsOperatingSystem64Bit	   = @IsOperatingSystem64Bit,      
         TotalPhyiscalMemory       = @TotalPhyiscalMemory,
         TotalVirtualMemory        = @TotalVirtualMemory,
         AvaliablePhysicalMemory   = @AvaliablePhysicalMemory,
         AvaliableVirtualMemory    = @AvaliableVirtualMemory,         
         ApplicationAssemblyPath = @ApplicationPath,
         ProcessorCount = @ProcessorCount,
         ProcessUserIdentity = @ProcessUserIdentity
         
      WHERE
         ApplicationName = @ApplicationName AND
         DeviceName    = @DeviceName
   END
ELSE
   -- No, so insert it.
   BEGIN
      -- Insert a new APP_INFO row...
      INSERT INTO [dbo].[AppEnvironment]
           ([ApplicationName]
           ,[ApplicationVersion]
           ,[ApplicationType]
           ,[ApplicationPath]
           ,[ApplicationAssemblyPath]
           ,[ProcessUserIdentity]
           ,[DeviceName]
           ,[DeviceOs]
           ,[IsOperatingSystem64Bit]
           ,[ProcessorCount]
           ,[TotalPhyiscalMemory]
           ,[TotalVirtualMemory]
           ,[AvaliablePhysicalMemory]
           ,[AvaliableVirtualMemory]
           ,[LastModifiedDate])
     VALUES
           (
           	@ApplicationName
           ,@ApplicationVersion
           ,@ApplicationType
           ,@ApplicationPath
           ,@ApplicationAssemblyPath
           ,@ProcessUserIdentity
           ,@DeviceName
           ,@DeviceOs
           ,@IsOperatingSystem64Bit
           ,@ProcessorCount
           ,@TotalPhyiscalMemory
           ,@TotalVirtualMemory
           ,@AvaliablePhysicalMemory
           ,@AvaliableVirtualMemory
           ,@LastModifiedDate
           )
   END


