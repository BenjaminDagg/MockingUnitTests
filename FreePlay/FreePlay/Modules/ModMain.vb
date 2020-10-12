Imports System.IO

Module ModMain

#Region " Public Application (Global) variables "

   Public gAppPath As String
   Public gConnectionString As String
   Public gComputerName As String
   Public gCrLf As String = Environment.NewLine
   Public gDatabaseName As String

   Public gDefaultCents As Integer
   Public gDefaultExpirationDays As Integer
   Public gSupervisorMaxCents As Integer
   Public gSupervisorMaxExpirationDays As Integer
   Public gElevatedMaxCents As Integer
   Public gElevatedMaxExpirationDays As Integer
   Public gSupervisorGroups As List(Of String)
   Public gElevatedGroups As List(Of String)


#End Region

#Region " Application Initialization "

    Private Function AuthenticateApp() As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluate hash of app exe
      ' Return T/F
      ' Note: 10-12-2011 modified so authorization is always required per Bryan Green,
      '       no longer data-driven by database lookup as of LR Deal Import v2.0.2.
      '       Authentication is bypassed if a debugger is attached (for development).
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSHA1 As DGE.SHA1Cryptography
      Dim lHashDigest() As Byte
      Dim lStaticDigest() As Byte

      Dim lAuthRequired As Boolean = False
      Dim lReturn As Boolean = False

      Dim lErrorText As String = ""
      Dim lHashText As String
      Dim lMsgDigest As String
      Dim lSourceFiles(2) As String
      Dim lTestText As String


      ' Bypass authentication if running in the IDE.
      'lAuthRequired = (Debugger.IsAttached = False)
      lAuthRequired = True

      ' Is application authorization required?
      If lAuthRequired = True Then
         ' Yes
         ' Store the fully qualified filename of the message digest file that will be used for comparison.
         lMsgDigest = Path.Combine(gAppPath, "fpMsgDigest.dat")

         ' Populate the source file array with fully qualified filenames to check...
         lSourceFiles = My.Settings.AppAuthList.Split(",".ToCharArray)

         ' Build fully qualified filenames.
         For lIndex As Integer = 0 To lSourceFiles.GetUpperBound(0)
            lSourceFiles(lIndex) = Path.Combine(gAppPath, lSourceFiles(lIndex))
            ' Confirm that each file exists.
            If Not File.Exists(lSourceFiles(lIndex)) Then
               lErrorText = String.Format("File {0} not found", lSourceFiles(lIndex))
               Exit For
            End If
         Next

         ' Set the fully qualified filename of the message digest file.
         If lErrorText.Length = 0 Then
            If File.Exists(lMsgDigest) = False Then
               lErrorText = String.Format("File {0} not found", lMsgDigest)
            End If
         End If

         ' Any errors encountered yet?
         If lErrorText.Length = 0 Then
            ' No errors, so create a new hash and compare to digest...
            Try
               ' Instantiate a new SHA1 instance.
               lSHA1 = New DGE.SHA1Cryptography

               ' Create the hashed array and convert to a string for comparison...
               lHashDigest = lSHA1.CreateFileHash(lSourceFiles)
               lHashText = System.Text.UTF8Encoding.UTF8.GetString(lHashDigest)

               ' Load static digest array and convert to a string for comparison...
               lStaticDigest = File.ReadAllBytes(lMsgDigest)
               lTestText = System.Text.UTF8Encoding.UTF8.GetString(lStaticDigest)

               ' Perform string compare, setting return value.
               lReturn = (String.Compare(lHashText, lTestText, False) = 0)

            Catch ex As Exception
               ' Handle the error...
               lErrorText = "ModMain::AuthenticateApp error: " & ex.Message
               lReturn = False

            End Try
         End If

         ' If there is error text, show it...
         If String.IsNullOrEmpty(lErrorText) = False Then
            MessageBox.Show(lErrorText, "Application Authentication Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End If

      Else
         ' Authentication is not required, return true.
         lReturn = True
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Sub MainInit()
      '--------------------------------------------------------------------------------
      ' Entry point into this application.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Store the Startup Path of this application.
      gAppPath = Application.StartupPath

      ' Store the computer name.
      gComputerName = My.Computer.Name

      ' Setup application log filename.
      Logging.LogFileName = Path.Combine(gAppPath, "FreePlay.log")

       ' Make sure this application is authenticated.
      If AuthenticateApp() = False Then

        Dim lErrorText As String = String.Format("The {0} application has failed security authentication and will terminate.", My.Settings.ApplicationTitle)
        Logging.Log(lErrorText)
        MessageBox.Show(lErrorText, My.Settings.ApplicationTitle, MessageBoxButtons.OK, MessageBoxIcon.Error)

        Environment.Exit(-1)
      End If

      Try

       ' Assign connection string to a global var...
          gConnectionString = BuildConnection()


          ' Record the application version information.
         Call RecordAppVersion()
         GetGroupDefaultsAndMaximums()
      Catch ex As Exception
       Dim lErrorText As String = "Unable to connect to database. Please correct the setting on the config file and retry. Application will now terminate."
        Logging.Log(lErrorText)
        MessageBox.Show(lErrorText, My.Settings.ApplicationTitle, MessageBoxButtons.OK, MessageBoxIcon.Error)

        Environment.Exit(-1)
      End Try
     

   End Sub

#End Region

#Region " Private SubRoutines"

   Private Sub GetGroupDefaultsAndMaximums()

      Dim lDT As DataTable
      Dim lSQL As String
      Dim lDR As DataRow()

      Try

         gSupervisorGroups = New List(Of String)()
         gElevatedGroups = New List(Of String)()

         lSQL = "SELECT PAR_ID, PAR_NAME, PAR_DESC, VALUE1, VALUE2, VALUE3 FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME IN ('RESTRICTED_CREDITS_SUPERVISOR', 'RESTRICTED_CREDITS_ADMIN', 'RESTRICTED_CREDITS_DEFAULT')"


         ' Create a new SqlDataAccess instance.
         Using lSDA As New SqlDataAccess(gConnectionString, True, 120)
            lDT = lSDA.ExecuteSQL(lSQL).Tables(0)
         End Using

         lDR = lDT.Select("PAR_NAME = 'RESTRICTED_CREDITS_SUPERVISOR'")

         If lDR.Length > 0 Then
            gSupervisorMaxCents = CInt(lDR(0)("VALUE3"))
            gSupervisorMaxExpirationDays = CInt(lDR(0)("VALUE2"))
            gSupervisorGroups = CStr(lDR(0)("VALUE1")).ToLower().Split(",").ToList()
         Else
            Throw New ArgumentException("Invalid or missing application parameters.")
         End If

         lDR = lDT.Select("PAR_NAME = 'RESTRICTED_CREDITS_ADMIN'")

         If lDR.Length > 0 Then
            gElevatedMaxCents = CInt(lDR(0)("VALUE3"))
            gElevatedMaxExpirationDays = CInt(lDR(0)("VALUE2"))
            gElevatedGroups = CStr(lDR(0)("VALUE1")).ToLower().Split(",").ToList()
         Else
            Throw New ArgumentException("Invalid or missing application parameters.")
         End If

         lDR = lDT.Select("PAR_NAME = 'RESTRICTED_CREDITS_DEFAULT'")

         If lDR.Length > 0 Then
            gDefaultCents = CInt(lDR(0)("VALUE1"))
            gDefaultExpirationDays = CInt(lDR(0)("VALUE2"))
         Else
            Throw New ArgumentException("Invalid or missing application parameters.")
         End If


         If (gSupervisorGroups.Count <= 0 OrElse gSupervisorGroups.Count <= 0) Then
            Throw New ArgumentException("Invalid or missing application parameters.")
         End If

      Catch ex As Exception
         ' Handle the exception, build the error text and write it to the EventLog...
         Dim lErrorText As String
         lErrorText = "Startup::GetGroupDefaultsAndMaximums error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show("Failed to retrieve application settings. Check connection setting and/or application settings.", "Application Startup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         ' Close the application.
         Application.Exit()
      End Try
   End Sub

   Private Function RecordAppVersion() As Boolean
      '--------------------------------------------------------------------------------
      ' Call stored procedure to record the version of this application.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable

      Dim lTableCount As Integer

      Dim lErrorText As String
      Dim lSQL As String


      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectionString, True, 120)

         ' Determine if the APP_INFO table exists in the database...
         lSQL = "SELECT COUNT(*) FROM sys.tables WHERE [name] = 'APP_INFO'"
         lDT = lSDA.CreateDataTable(lSQL)
         lTableCount = lDT.Rows(0).Item(0)

         If lTableCount > 0 Then
            ' The table is there so execute stored procedure InsertAppInfo to insert application info into it.
            With lSDA
               ' Add InsertAppInfo stored procedure parameters...
               .AddParameter("@ApplicationName", SqlDbType.VarChar, My.Application.Info.AssemblyName, 64)
               .AddParameter("@ComputerName", SqlDbType.VarChar, My.Computer.Name, 64)
               .AddParameter("@CurrentVersion", SqlDbType.VarChar, My.Application.Info.Version.ToString, 16)
               .AddParameter("@OSFullname", SqlDbType.VarChar, My.Computer.Info.OSFullName, 64)
               .AddParameter("@OSPlatform", SqlDbType.VarChar, My.Computer.Info.OSPlatform, 64)
               .AddParameter("@OSVersion", SqlDbType.VarChar, My.Computer.Info.OSVersion, 64)
               .AddParameter("@MemoryTotalPhysical", SqlDbType.BigInt, My.Computer.Info.TotalPhysicalMemory)
               .AddParameter("@MemoryTotalVirtual", SqlDbType.BigInt, My.Computer.Info.TotalVirtualMemory)
               .AddParameter("@MemoryAvailablePhysical", SqlDbType.BigInt, My.Computer.Info.AvailablePhysicalMemory)
               .AddParameter("@MemoryAvailableVirtual", SqlDbType.BigInt, My.Computer.Info.AvailableVirtualMemory)

               ' Execute InsertAppInfo stored procedure...
               .ExecuteProcedureNoResult("InsertAppInfo")
            End With
         End If

      Catch ex As Exception
         ' Handle the exception, build the error text and write it to the EventLog...
         lErrorText = "Startup::RecordAppVersion error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show("Failed to connect to a SQL Server instance. Check the connection settings and try again.", "Application Startup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         ' Close the application.
         Application.Exit()

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Return String.IsNullOrEmpty(lErrorText)

   End Function

#End Region

#Region " Private Functions"

   Private Function BuildConnection() As String
      '--------------------------------------------------------------------------------
      ' Builds the ConnectionString values using config file entries.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAPE As New AppPasswordEncryption

      Dim lDBPassword As String
      Dim lErrorText As String = ""
      Dim lReturn As String = ""

      ' Build the database connection string...
      Try
         lDBPassword = lAPE.DecryptPassword(My.Settings.DBKey)
         lReturn = String.Format(My.Settings.DBConnect, lDBPassword)

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = "ModMain::BuildConnection error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Build Connection Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Clean up.
         lAPE = Nothing

      End Try

      ' Set the Function Return value.
      Return lReturn

   End Function

   Friend Function GetCOMPorts() As String()
      '--------------------------------------------------------------------------------
      ' Returns a sorted string array of COM Ports.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn() As String = Nothing
      Dim lErrorText As String = ""

      Try
         lReturn = IO.Ports.SerialPort.GetPortNames()
         Array.Sort(lReturn)

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = "ModMain::GetCOMPorts error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "COM Port Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' Set the Function Return value.
      Return lReturn

   End Function

   Friend Function IsValidCOMPort(ByVal aCOMPort As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Check to see if the COMport in the config file is a valid COMport.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = False
      Dim lCOMPorts() As String = Nothing
      Dim lErrorText As String

      Try
         ' Is the COMPort in my.settings a valid COMPort
         lCOMPorts = GetCOMPorts()
         lReturn = (Array.IndexOf(lCOMPorts, aCOMPort) > -1)

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = "ModMain::IsValidCOMPort error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "COM Port Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try

      ' Set the Function Return value.
      Return lReturn

   End Function

#End Region

End Module
