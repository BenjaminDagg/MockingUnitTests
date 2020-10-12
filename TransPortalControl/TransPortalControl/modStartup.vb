Option Explicit On
Option Strict On

Imports System
Imports System.IO
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text

Friend Module modStartup

   Friend gPort As Integer
   Friend gTpiID As Integer = 0

   Friend gAppPath As String
   Friend gAppVersion As String
   Friend gConnectionString As String = ""
   Friend gCrLf As String = Environment.NewLine
   Friend gLogFile As String = ""
   Friend gServer As String = ""
   Friend gTracing As Boolean = False

   Sub Main()
      '--------------------------------------------------------------------------------
      ' Main subroutine
      ' Entry point for this application.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""
      Dim lTextValue As String
      Dim lIntValue As Integer

      Dim tempstr As String = AppDomain.CurrentDomain.SetupInformation.ConfigurationFile

      Try
         ' Store the application version and folder...
         gAppVersion = My.Application.Info.Version.ToString
         gAppPath = My.Application.Info.DirectoryPath

         Dim currentLogPath As String = My.Settings.LogFile
         Dim logPath As String


         logPath = gAppPath + "\TransactionPortalControl.log"

            If (String.IsNullOrWhiteSpace(currentLogPath) OrElse File.Exists(currentLogPath) = False) Then
                My.Settings.LogFile = logPath
                My.Settings.Save()
            End If

         ' LogFile
         gLogFile = My.Settings.LogFile
         If String.IsNullOrEmpty(gLogFile) Then
            lErrorText = "The LogFilename setting was not found."
         ElseIf AppendLogEntry(String.Format("Application Startup -- Version: {0}", gAppVersion)) = False Then
            lErrorText = "Unable to save to log file " + gLogFile
         End If

         If String.IsNullOrWhiteSpace(lErrorText) Then

            ' Accounting Database connection string.
            lTextValue = My.Settings.DbConnection
            If String.IsNullOrEmpty(lTextValue) Then
               lErrorText = "The database connection setting was not found."
            Else
               ' Store the database connection string.
               gConnectionString = GetDecryptedConnString(lTextValue)

               ' Can the application connect to the database?
               If (TestDBConnection(gConnectionString)) Then
                  ' Yes, Does the application exe pass authentication?
                  If System.Diagnostics.Debugger.IsAttached = True OrElse AuthenticateApp() Then
                     ' Authentication succeeded, record application version info to Casino.APP_INFO
                     Call RecordAppVersion()
                  Else
                     lErrorText = "The Transaction Portal Control application has failed security authentication and will terminate." & _
                                  gCrLf & gCrLf & "Application Version: " & My.Application.Info.Version.ToString
                     Throw New Exception(lErrorText)
                  End If
               Else
                  ' Could not connect to the database...
                  lErrorText = "Unable to communicate with database." & gCrLf & _
                  "Check the Database Connection setting in the configuration file."
               End If
            End If
         End If

         If lErrorText.Length = 0 Then
            ' Poll Interval
            lIntValue = My.Settings.PollingInterval
            If Not IsInRange(lIntValue, 5, 120) Then
               lErrorText = "The Poll Interval value is out of range (5 to 120 seconds)."
            Else
               ' Port value
               gPort = My.Settings.Port
               If Not IsInRange(gPort, 4500, 5000) Then
                  lErrorText = "The Port setting value is out of range (4500 to 5000)."
               Else
                  ' Server value
                  gServer = My.Settings.Server
                  If String.IsNullOrEmpty(gServer) Then
                     lErrorText = "Invalid or missing Server value, expected IP Address of Server."
                  Else
                     ' Tracing value
                     gTracing = My.Settings.Tracing
                  End If
               End If
            End If
         End If

         If lErrorText.Length > 0 Then
            ' Finish error text.
            lErrorText = "An error occured at application startup." & _
                         gCrLf & gCrLf & lErrorText & gCrLf & gCrLf & _
                         "The application will terminate."
            ' Log error.
            AppendLogEntry(lErrorText)

            ' Throw new exception to stop the app.
            Throw New Exception(lErrorText)
         End If

         ' Log application startup.
         FormatLogOutput("Application Startup")

         ' Fire up the MDI parent form...
         Application.Run(New mdiParentForm)

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show(ex.Message, "Transaction Portal Control", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Function AuthenticateApp() As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluate hash of app exe
      ' Return T/F
      ' Starting with version 7.2.5, authentication is required and no longer considers
      ' the value contained in the CASINO.AUTHENTICATE_APPS column.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      ' Dim lSDA As SqlDataAccess = Nothing
      Dim lSHA1 As DGE.SHA1Cryptography
      Dim lHashDigest() As Byte
      Dim lStaticDigest() As Byte

      ' Dim lAuthRequired As Boolean = False
      Dim lReturn As Boolean = False

      Dim lErrorText As String = ""
      Dim lHashText As String
      Dim lMsgDigest As String
      Dim lSourceFiles(2) As String
      Dim lTestText As String


      ' First, determine if authentication is required...
      'Try
      '   ' Intantiate a new SqlDataAccess object.
      '   lSDA = New SqlDataAccess(gConnectionString, False, 60)

      '   ' Execute stored procedure GetAuthorizeAppsFlag and store the RETURNed value...
      '   lSDA.ExecuteProcedureNoResult("GetAuthorizeAppsFlag")
      '   lAuthRequired = (lSDA.ReturnValue = 1)

      'Catch ex As Exception
      '   ' Handle the exception.
      '   ' Assume that an error means that authentication is not required.
      '   lAuthRequired = False

      'Finally
      '   ' Cleanup.
      '   If lSDA IsNot Nothing Then
      '      lSDA.Dispose()
      '      lSDA = Nothing
      '   End If

      'End Try

      ' Store the fully qualified filename of the message digest file that will be used for comparison.
      lMsgDigest = Path.Combine(gAppPath, "tpcMsgDigest.dat")

      ' Is application authorization required?
      ' If lAuthRequired Then

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
            lErrorText = "modStartup::AuthenticateApp error: " & ex.Message
            lReturn = False

         End Try
      End If

      ' If there is error text, show it...
      If String.IsNullOrEmpty(lErrorText) = False Then
         MessageBox.Show(lErrorText, "Application Authentication Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      'Else
      '   ' Authentication is not required, return true.
      '   lReturn = True
      'End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function TestDBConnection(ByRef ConnectionString As String) As Boolean
      '--------------------------------------------------------------------------------
      ' This function will extract the CASINO.TPI_ID column value & initialize gTpiID.
      ' This will also check to see if we have database access.
      ' Returns T/F to indicate success or failure to connect to the database.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True
      Dim lSqlConn As SqlConnection = Nothing
      Dim lSqlCmd As SqlCommand

      Try
         ' Test the connection to the database.
         lSqlConn = New SqlConnection(ConnectionString)
         lSqlCmd = New SqlCommand("SELECT TPI_ID FROM CASINO WHERE SETASDEFAULT = 1", lSqlConn)
         lSqlCmd.Connection.Open()
         gTpiID = CInt(lSqlCmd.ExecuteScalar)

      Catch ex As Exception
         ' Handle the exception.
         lReturn = False

      Finally
         ' Clean up...
         If Not lSqlConn Is Nothing Then
            lSqlConn.Close()
            lSqlConn = Nothing
         End If
      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Friend Function AppendLogEntry(ByVal aLogText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' This function will format log ouput to the log file regardless of the trace
      ' value setting.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lLogText As String

      Try
         ' Do NOT write to log file if "Tracing" is Off.
         lLogText = String.Format("{0:yyyy-MM-dd HH:mm:ss.fff} TPC sent: {1}{2}", Now(), aLogText, gCrLf)
         File.AppendAllText(gLogFile, lLogText)

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show("modStartup::AppendLogEntry error: " & ex.Message, "Append Log Entry Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         Return False
      End Try

      Return True
   End Function

   Friend Sub FormatLogOutput(ByVal aLogText As String)
      '--------------------------------------------------------------------------------
      ' This function will format log ouput to the log file if tracing is on.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lLogText As String

      Try
         ' Do NOT write to log file if "Tracing" is Off.
         If gTracing Then
            lLogText = String.Format("{0:yyyy-MM-dd HH:mm:ss.fff} TPC sent: {1}{2}", Now(), aLogText, gCrLf)
            File.AppendAllText(gLogFile, lLogText)
         End If

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show("modStartup::FormatLogOutput error: " & ex.Message, "FormatLogOutput Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Friend Function IsInRange(ByVal aValue As Integer, ByVal aRangeLow As Integer, ByVal aRangeHigh As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Returns T/F to indicate if value is within the specified range.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Return aValue >= aRangeLow AndAlso aValue <= aRangeHigh


   End Function

   Function GetDecryptedConnString(ByVal aEncConnString As String) As String
      '--------------------------------------------------------------------------------
      ' GetDecryptedConnString Function
      ' Takes incoming connection string, decrypts password, and rebuilds the
      ' connection string using cleartext PWD
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As StringBuilder
      Dim lIndex As Integer

      Dim lFields() As String
      Dim lPassFields() As String

      Dim lConnectionString As String = ""
      Dim lClearTextPWD As String = ""
      Dim lEncryptedPWD As String = ""

      Try
         ' Split the Connection String on ";" separator.
         lFields = aEncConnString.Split(";"c)

         ' Find the Password section.
         For lIndex = 0 To lFields.Length - 1
            If (lFields(lIndex).ToLower.StartsWith("password=")) Then
               ' Split the Password from value.
               lPassFields = lFields(lIndex).Split("="c)

               ' Get encrypted password
               lEncryptedPWD = lPassFields(1)
               Exit For
            End If
         Next

         If (lEncryptedPWD.Length > 0) Then
            ' Get the Decrypted password by calling the Utility function.
            lClearTextPWD = Utility.DecryptPassword(lEncryptedPWD)

            ' Rebuild the Connection String...
            lSB = New StringBuilder
            For lIndex = 0 To lFields.Length - 1
               If (lFields(lIndex).ToLower.StartsWith("password=")) Then
                  lSB.Append("Password=").Append(lClearTextPWD)
               Else
                  lSB.Append(lFields(lIndex))
               End If

               ' Append the field separator ";" for all but the last field
               If (lIndex <> (lFields.Length - 1)) Then lSB.Append(";")
            Next

            ' Get the string value to be returned from the StringBuilder.
            lConnectionString = lSB.ToString
         Else
            MessageBox.Show("modStartup::GetDecryptedConnString find Password field in the application configuration file.")
         End If

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show("modStartup::GetDecryptedConnString error: " & ex.ToString)

      End Try

      Return lConnectionString

   End Function

   Private Sub RecordAppVersion()
      '--------------------------------------------------------------------------------
      ' Call stored procedure to record the version of this application.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lErrorText As String

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectionString, False, 90)

         With lSDA
            .AddParameter("@ApplicationName", SqlDbType.VarChar, My.Application.Info.AssemblyName, 64)
            .AddParameter("@ComputerName", SqlDbType.VarChar, My.Computer.Name, 64)
            .AddParameter("@CurrentVersion", SqlDbType.VarChar, gAppVersion, 16)
            .AddParameter("@OSFullname", SqlDbType.VarChar, My.Computer.Info.OSFullName, 64)
            .AddParameter("@OSPlatform", SqlDbType.VarChar, My.Computer.Info.OSPlatform, 64)
            .AddParameter("@OSVersion", SqlDbType.VarChar, My.Computer.Info.OSVersion, 64)
            .AddParameter("@MemoryTotalPhysical", SqlDbType.BigInt, My.Computer.Info.TotalPhysicalMemory)
            .AddParameter("@MemoryTotalVirtual", SqlDbType.BigInt, My.Computer.Info.TotalVirtualMemory)
            .AddParameter("@MemoryAvailablePhysical", SqlDbType.BigInt, My.Computer.Info.AvailablePhysicalMemory)
            .AddParameter("@MemoryAvailableVirtual", SqlDbType.BigInt, My.Computer.Info.AvailableVirtualMemory)

            .ExecuteProcedureNoResult("InsertAppInfo")
         End With

      Catch ex As Exception
         ' Handle the exception, build the error text.
         lErrorText = "Startup::RecordAppVersion error: " & ex.Message
         ' Log, and then show the error...
         Call AppendLogEntry(lErrorText)
         MessageBox.Show(lErrorText, "Retrieval Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub


End Module