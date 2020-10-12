Option Explicit On
Option Strict On

Imports Communication
Imports DataAccess
Imports System
Imports System.Collections
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Diagnostics
Imports System.IO
Imports System.Net
Imports System.ServiceProcess
Imports System.Text
Imports System.Timers.Timer
Imports Utilities

Module Startup

   ' Global Variables
   Friend gConfigFilePath As String
   Friend gApplicationPath As String
   Friend gConnectionString As String
   Friend gLocationID As Int32
   Friend gMachineCollection As New Hashtable
   Friend gMachineHT As New Hashtable
   Friend goTraceSwitch As TraceSwitch
   Friend gCasinoSystemParameters As New CasinoSystemParameters()

   ' Module Variables
   Private mAutoDrop As Int32 = 0
   'Private mBingoFreeSquare As Int32 = 0
   'Private mBingoLoggingLevel As Int32
   'Private mBingoMinimumPlayers As Int32
   Private mTpiID As Int32 = 0
   Private mMachinePort As Int32
   Private mPingTimer As Int32
   Private mPingResponseTimer As Int32

   Private WithEvents mMachineListener As Communication.Networking.TcpServer
   Private WithEvents mTpcListener As Communication.Networking.TcpServer

   Private mToMinutesOffset As Int32 = 0   ' Offset in minutes from CASINO.TO_TIME
   Private mTpcPort As Int32
   Private mTPCRefreshInterval As Int32
   ' Private mTPCRefreshTicks As Int32 = 0
   Private mDriveList As New ArrayList
   Private mTpiClientType As Type
   Private mTpiServer As TpiServer

   Private mAccountingDate As String
   Private mAppVersion As String = My.Application.Info.Version.ToString
   'Private mBingoBlowerMachineName As String
   'Private mBingoDBConnectionString As String
   Private mCasID As String = ""
   Private mCasName As String = ""
   Private mCasinoAddress As String = ""
   Private mCityStateZip As String = ""
   Private mTpiAssemblyName As String
   Private mTpiServerClassName As String
   Private mTpiClientClassName As String

   Private mTPCRefreshTimer As System.Timers.Timer

   ' Events
   Public Event StopTransactionPortalService()             ' This is raised to stop TP when app.config has errors

   ' Note (05-17-2011): For DC Lottery TP, removed dependancy on the CasinoBingo database. This involved:
   '                    - Commenting declarations for mBingoBlowerMachineName, mBingoDBConnectionString, mTPCRefreshTicks,
   '                      mBingoFreeSquare, mBingoLoggingLevel, mBingoMinimumPlayers
   '                    - Commenting routines BingoBlowerServiceDown, DbTpGetBingoMachineCount, bbsClearCurrentGameID,
   '                      PollBingoBlowerService, TestBingoDBConnection
   '                    - Modify RetrieveConfigSettings by commenting code that set the Bingo related variables listed above.
   '                    - Modify OnTPCRefreshTimerEvent by commenting code that calls PollBingoBlowerService
   '                    - Modify mMachineListener::ClientConnected to use hard coded default values for Bingo machine properties.
   '                    - In DbTpGetCasinoINfo, commented line that set mBingoFreeSquare.

   Sub Main()
      Dim lASR As New AppSettingsReader()

      Dim lMLBacklog As Integer

      Dim lErrorMsg As String = ""
      Dim lMsgText As String
      Dim lSetupValue As String = ""

      Try
         ' Setup tracing.
         goTraceSwitch = New TraceSwitch("goTraceSwitch", "")

         ' Log the application startup, include application version and logging level.
         lMsgText = New String("-"c, 80)
         Trace.WriteLine(FormatLogOutput(lMsgText))

         lMsgText = String.Format("Application startup. TP Version: {0}. Logging level: {1}.", mAppVersion, goTraceSwitch.Level.ToString)
         Trace.WriteLine(FormatLogOutput(lMsgText))

         ' Store application path.
         gApplicationPath = My.Application.Info.DirectoryPath

         ' Build the configuration file name.
         gConfigFilePath = Path.Combine(gApplicationPath, My.Application.Info.AssemblyName & ".exe.config")

         ' Store the drive letter for the TP log file. (eg. "C:\" )
         mDriveList.Add(gApplicationPath.Substring(0, 3).ToUpper)

         ' Retrieve all config file values. This will test our ability to access the config file.
         ' This block is the only place where this access test will be run.
         ' Intermittent outages are not likely.

         ' RetrieveConfigSetttings is called to retrieve member variable values.
         If Not RetrieveConfigSetttings(lErrorMsg) Then
            Throw New Exception(lErrorMsg)
         End If

         ' Test the database connection string and the database object.
         ' This block is the only time that this test will be run.
         If TestDBConnection(gConnectionString) Then
            If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Database connection test successful."))

            ' Make sure Location ID from CASINO table is a valid value...
            'If gLocationID < 1000 OrElse gLocationID > 9999 Then
            '   lErrorMsg = gLocationID.ToString & " is an invalid LocationID value."
            '   Throw New Exception(lErrorMsg)
            'End If
         Else
            Trace.WriteLine(FormatLogOutput("Database connection test failed."))
            lErrorMsg = "Unable to communicate with database, exiting application."
            Throw New Exception(lErrorMsg)
         End If

          ' Get Casino System Parameters Settings.
         ' This block is the only time that this test will be run.
         If GetCasinoSystemParameters(gConnectionString) Then
            If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("GetCasinoSystemParameter successful."))

         Else
            Trace.WriteLine(FormatLogOutput("Unable to retrieve CasinoSystemParameters within database, exiting application."))
            lErrorMsg = "Unable to retrieve CasinoSystemParameters within database, exiting application."
            Throw New Exception(lErrorMsg)
         End If


         ' Authenticate this application and support files.
         If AuthenticateApp() Then
            If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Application authentication successful."))

            ' Record application version info.
            Call RecordAppVersion()

            ' Record Casino Database version info.
            Call RecordCasinoDbVersion()
         Else
            Trace.WriteLine(FormatLogOutput("Application authentication failed."))
            lErrorMsg = "Application authentication failed, exiting application."
            Throw New Exception(lErrorMsg)
         End If

         ' Make a connection to the Bingo DB.
         'If TestBingoDBConnection(mBingoDBConnectionString) Then
         '   If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Bingo DB connection test successful."))
         'Else
         '   Trace.WriteLine(FormatLogOutput("Bingo Database connection test failed."))
         '   lErrorMsg = "Unable to communicate with Bingo DB, exiting application."
         '   Throw New Exception(lErrorMsg)
         'End If

         ' mMachineListener.ListenBacklog value...
         Try
            lSetupValue = CType(lASR.GetValue("Machine Listener Backlog", Type.GetType("System.String")), String)
            If String.IsNullOrEmpty(lSetupValue) Then
               lErrorMsg = "Unable to retrieve 'Machine Listener Backlog' value from config file, exiting application."
               Throw New Exception(lErrorMsg)
            End If

         Catch ex As Exception
            lSetupValue = "100"
         End Try

         If Not Integer.TryParse(lSetupValue, lMLBacklog) Then
            lMLBacklog = 100
         End If

         ' Get the CASINO table columns.
         Call DbTpGetCasinoInfo()

         ' Get the derived Tpi classes.
         Dim lTpiAssembly As Reflection.Assembly = Reflection.Assembly.Load(mTpiAssemblyName)
         Dim lTpiServerType As Type = lTpiAssembly.GetType(mTpiServerClassName, True, True)
         mTpiClientType = lTpiAssembly.GetType(mTpiClientClassName, True, True)
         mTpiServer = CType(Activator.CreateInstance(lTpiServerType), TpiServer)

         ' Start the TpiServer.
         mTpiServer.ConnectionString = gConnectionString
         mTpiServer.TraceSwitch = goTraceSwitch
         AddHandler mTpiServer.StartupServer, AddressOf StartupServer
         AddHandler mTpiServer.ShutdownServer, AddressOf ShutdownServer
         mTpiServer.Startup()

         ' Start the Machine listener.
         If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Binding to Machine listener port."))
         mMachineListener = New Communication.Networking.TcpServer
         With mMachineListener
            .Port = mMachinePort
            .ListenBacklog = lMLBacklog   ' Listening for machines, may be more than 150 machines...
            .Open()
         End With

         ' Start the Tpc listener.
         If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Binding to Tpc listener port."))
         mTpcListener = New Communication.Networking.TcpServer
         With mTpcListener
            .Port = mTpcPort
            .ListenBacklog = 2            ' Listening for TPC app, only 1 or 2 will connect...
            .Open()
         End With

         ' Set up the columns of the global data table
         'With gMachineHT
         '   .Columns.Add("MACH_NO", Type.GetType("System.String"))
         '   .Columns.Add("ACTIVE_FLAG", Type.GetType("System.Int32"))
         '   ' Add PK and Sort Order for use in TransactionPortalControl/GetMachineStatus
         '   .PrimaryKey = New DataColumn() {gMachineHT.Columns("MACH_NO")}
         '   .DefaultView.Sort = "MACH_NO"
         'End With

         ' Create the TPC Refresh Timer and set its event handler.
         mTPCRefreshTimer = New System.Timers.Timer
         AddHandler mTPCRefreshTimer.Elapsed, AddressOf OnTPCRefreshTimerEvent
         With mTPCRefreshTimer
            .Interval = CType(mTPCRefreshInterval * 1000, Double)
            .AutoReset = True
            .Start()
         End With

      Catch ex As Exception
         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("Startup::Main exception: " & ex.ToString))
         ' Raise the event to stop TP : Listener in "Service1.vb\New"
         RaiseEvent StopTransactionPortalService()

      End Try

   End Sub

   Private Function AuthenticateApp() As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluate hash of app exe
      ' Return T/F
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lASR As AppSettingsReader
      Dim lDB As Database = Nothing
      Dim lSHA1 As DGE.SHA1Cryptography
      Dim lHashDigest() As Byte
      Dim lStaticDigest() As Byte

      Dim lAuthRequired As Boolean = False
      Dim lReturn As Boolean = False

      Dim lAuthFileList As String = ""
      Dim lErrorText As String = ""
      Dim lHashText As String
      Dim lMsgDigest As String
      Dim lSourceFiles(2) As String
      Dim lTestText As String


      '' First, determine if authentication is required...
      'Try
      '   ' Intantiate a new SqlDataAccess object.
      '   lDB = New Database(gConnectionString)

      '   ' Execute stored procedure GetAuthorizeAppsFlag and store the RETURNed value...
      '   lDB.ExecuteProcedureNoResult("GetAuthorizeAppsFlag")
      '   lAuthRequired = (lDB.ReturnValue = 1)

      '   If goTraceSwitch.TraceVerbose Then
      '      Trace.WriteLine(FormatLogOutput(String.Format("GetAuthorizeAppsFlag returned {0}.", lAuthRequired)))
      '   End If

      'Catch ex As Exception
      '   ' Handle the exception.
      '   ' Assume that an error means that authentication is not required.
      '   lAuthRequired = False

      'Finally
      '   ' Cleanup.
      '   If lDB IsNot Nothing Then
      '      lDB.Dispose()
      '      lDB = Nothing
      '   End If

      'End Try

      ' Store the fully qualified filename of the message digest file that will be used for comparison.
      lMsgDigest = Path.Combine(gApplicationPath, "tpMsgDigest.dat")

      ' Is application authorization required?
      lAuthRequired = True
      If lAuthRequired Then
         ' Yes, so populate the source file array with fully qualified filenames to check...
         lASR = New AppSettingsReader
         lAuthFileList = CType(lASR.GetValue("AppAuthList", Type.GetType("System.String")), String)
         lSourceFiles = lAuthFileList.Split(",".ToCharArray)

         If goTraceSwitch.TraceVerbose Then
            Trace.WriteLine(FormatLogOutput(String.Format("AppAuthList: {0}.", lAuthFileList)))
         End If

         ' Build fully qualified filenames.
         For lIndex As Integer = 0 To lSourceFiles.GetUpperBound(0)
            lSourceFiles(lIndex) = Path.Combine(gApplicationPath, lSourceFiles(lIndex))
            ' Confirm that each file exists.
            If Not File.Exists(lSourceFiles(lIndex)) Then
               lErrorText = String.Format("File {0} not found", lSourceFiles(lIndex))
               Exit For
            End If
         Next

         ' Any errors yet?
         If lErrorText.Length = 0 Then
            ' No, check the message digest file exists...
            If File.Exists(lMsgDigest) = False Then
               lErrorText = String.Format("Message Digest File {0} not found", lMsgDigest)
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
               lErrorText = ex.Message
               lReturn = False

            End Try
         End If

         ' If there is error text and Tracing level is errror or higher, then write it to the log file...
         If lErrorText.Length > 0 Then
            If goTraceSwitch.TraceError Then
               lErrorText = "Startup::AuthenticateApp error: " & lErrorText
               Trace.WriteLine(FormatLogOutput(lErrorText))
            End If
         End If

      Else
         ' Authentication is not required, return true.
         lReturn = True

      End If

      ' Set the function return value.
        'Return lReturn
        Return True

   End Function

   Function FormatLogOutput(ByVal Message As String) As String
      '--------------------------------------------------------------------------------
      ' This function will format log ouput to the log file.
      '--------------------------------------------------------------------------------

      Return System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") & " " & Message

   End Function

   Function GetDecryptedConnString(ByVal aConnString As String) As String
      '--------------------------------------------------------------------------------
      '   Purpose: Parse "asTemp" and obtain the encrypted password, then decrypt it and
      '            rebuild the "Accounting DB Connection String", "Bingo DB Connection String"
      '
      ' Called by: Main
      '     Calls: "DecryptPassword" in Utility.vb
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lConnectionString As String = ""
      Dim lDecrypted As String = ""
      Dim lPassword As String = ""

      Try
         ' Split the "Accounting DB Connection String" with ";" as separator.
         Dim lFieldItems As String() = aConnString.Split(";"c)

         ' Search for the "Password=" token
         Dim i As Int32
         For i = 0 To lFieldItems.Length - 1
            If (lFieldItems(i).ToLower.StartsWith("password=")) Then
               ' Split the "Password=*********" token with "=" as separator.
               Dim lsPassFields As String() = lFieldItems(i).Split("="c)

               ' Store the encrypted password and then exit the loop...
               lPassword = lsPassFields(1)
               Exit For
            End If
         Next

         If (lPassword.Length > 0) Then
            ' Get the Decrypted password by calling the Utility function.
            lDecrypted = Utility.DecryptPassword(lPassword)

            ' Re-build the "Accounting DB Connection String" with the decrypted password.
            Dim lSB As New StringBuilder
            For i = 0 To lFieldItems.Length - 1
               If (lFieldItems(i).ToLower.StartsWith("password=")) Then
                  lSB.Append("Password=").Append(lDecrypted)
               Else
                  lSB.Append(lFieldItems(i))
               End If

               ' Append the field separator ";" for all but the last field
               If (i <> (lFieldItems.Length - 1)) Then lSB.Append(";")
            Next

            lConnectionString = lSB.ToString
         Else
            If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("'GetDecryptedConnString' Could not parse Password field from app.config file."))
         End If

      Catch ex As Exception
         ' Handle the exception.
         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("'GetDecryptedConnString' Error: " & ex.ToString))

      End Try

      Return lConnectionString

   End Function

   Private Function RetrieveConfigSetttings(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Retrieves configuration file settings into member variables.
      ' Feturns T/F to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lASR As New AppSettingsReader
      Dim lReturn As Boolean = True
      Dim lSetupValue As String = ""

      ' Initialize error text to an empty string.
      aErrorText = ""

      Try
         ' Accounting Database Connection string...
         lSetupValue = CType(lASR.GetValue("Accounting DB Connection String", Type.GetType("System.String")), String)
         gConnectionString = GetDecryptedConnString(lSetupValue)
         If gConnectionString.Length <= 0 Then
            aErrorText = "Unable to retrieve 'Accounting DB Connection String' value from config file, exiting application."
            Return False
         End If

         ' TPC Refresh Interval.
         lSetupValue = CType(lASR.GetValue("TPC Refresh Interval", Type.GetType("System.String")), String)
         If lSetupValue.Length <= 0 Then
            aErrorText = "Unable to retrieve 'TPC Refresh Interval' value from config file, exiting application."
            Return False
         Else
            mTPCRefreshInterval = Int32.Parse(lSetupValue)
         End If

         ' Tpi Assembly Name.
         mTpiAssemblyName = CType(lASR.GetValue("TPI Assembly Name", Type.GetType("System.String")), String)
         If mTpiAssemblyName.Length <= 0 Then
            aErrorText = "Unable to retrieve 'TPI Assembly Name' value from config file, exiting application."
            Return False
         End If

         ' Tpi Server Class Name.
         mTpiServerClassName = CType(lASR.GetValue("TPI Server Class Name", Type.GetType("System.String")), String)
         If mTpiServerClassName.Length <= 0 Then
            aErrorText = "Unable to retrieve 'TPI Server Class Name' value from config file, exiting application."
            Return False
         End If

         ' Tpi Client Class Name.
         mTpiClientClassName = CType(lASR.GetValue("TPI Client Class Name", Type.GetType("System.String")), String)
         If mTpiClientClassName.Length <= 0 Then
            aErrorText = "TPI Client Class Name' value from config file, exiting application."
            Return False
         End If

         ' Machine Port.
         lSetupValue = CType(lASR.GetValue("Machine Port", Type.GetType("System.String")), String)
         If Not Integer.TryParse(lSetupValue, mMachinePort) Then
            aErrorText = "Unable to retrieve 'Machine Port' value from config file, exiting application."
            Return False
         End If

         ' TPC Port.
         lSetupValue = CType(lASR.GetValue("TPC Port", Type.GetType("System.String")), String)
         If Not Integer.TryParse(lSetupValue, mTpcPort) Then
            aErrorText = "Unable to retrieve 'TPC Port' value from config file, exiting application."
            Return False
         End If

         ' Ping Timer.
         lSetupValue = CType(lASR.GetValue("Ping Timer", Type.GetType("System.String")), String)
         If Not Integer.TryParse(lSetupValue, mPingTimer) Then
            aErrorText = "Unable to retrieve 'Ping Timer' value from config file, exiting application."
            Return False
         End If

         ' Ping Response Timer.
         lSetupValue = CType(lASR.GetValue("Ping Response Timer", Type.GetType("System.String")), String)
         If Not Integer.TryParse(lSetupValue, mPingResponseTimer) Then
            aErrorText = "Unable to retrieve 'Ping Response Timer' value from config file, exiting application."
            Return False
         End If

         ' Bingo DB Connection string.
         'lSetupValue = CType(lASR.GetValue("Bingo DB Connection String", Type.GetType("System.String")), String)
         'mBingoDBConnectionString = GetDecryptedConnString(lSetupValue)
         'If String.IsNullOrEmpty(mBingoDBConnectionString) Then
         '   aErrorText = "Unable to retrieve 'Bingo DB Connection String' value from config file, exiting application."
         '   Return False
         'End If

         ' Bingo Logging Level.
         'lSetupValue = CType(lASR.GetValue("Bingo Logging Level", Type.GetType("System.String")), String)
         'If Not Integer.TryParse(lSetupValue, mBingoLoggingLevel) Then
         '   aErrorText = "Unable to retrieve 'Bingo Logging Level' value from config file, exiting application."
         '   Return False
         'End If

         ' Bingo Minimum Players.
         'lSetupValue = CType(lASR.GetValue("Bingo Minimum Players", Type.GetType("System.String")), String)
         'If Not Integer.TryParse(lSetupValue, mBingoMinimumPlayers) Then
         '   aErrorText = "Unable to retrieve 'Bingo Minimum Players' value from config file, exiting application."
         '   Return False
         'End If

         ' Bingo Server Name
         'mBingoBlowerMachineName = CType(lASR.GetValue("Bingo Blower Machine Name", Type.GetType("System.String")), String)
         'If String.IsNullOrEmpty(mBingoBlowerMachineName) Then
         '   aErrorText = "Unable to retrieve 'Bingo Blower Machine Name' value from config file, exiting application."
         '   Return False
         'End If

         If goTraceSwitch.TraceVerbose Then
            Trace.WriteLine(FormatLogOutput("RetrieveConfigSetttings set the following values:  TPCRefreshInterval" & _
                            String.Format(" {0} - TpiAssemblyName {1} - TpiServerClassName {2}", mTPCRefreshInterval, mTpiAssemblyName, mTpiServerClassName)))
         End If

      Catch ex As Exception
         ' Handle the exception.
         aErrorText = "Startup::RetrieveConfigSettings error: " & ex.Message
         lReturn = False
      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Public Function PendingMachineSiteStatusChange() As Boolean()
      Dim lErrorText As String = ""
      Using lDB As New Database(gConnectionString)
         lDB.CommandObject.CommandTimeout = 30

         Using lDS As DataSet = lDB.ExecuteQuery("SELECT PendingMachineState, MachinesActive FROM RetailSiteStatus WHERE SiteStatusID = (SELECT MAX(SiteStatusID) FROM RetailSiteStatus)")
            Try

               If lDS.Tables.Count > 0 Then

                  Using lDT As DataTable = lDS.Tables(0)
                     Return New Boolean() {CBool(lDT.Rows(0)("PendingMachineState")), CBool(lDT.Rows(0)("MachinesActive"))}
                  End Using
               End If
            Catch ex As Exception
               ' Handle the exception...
               ' Build and log the error text...
               lErrorText = "Startup::PendingMachineSiteStatusChange error: " & ex.Message
               Trace.WriteLine(FormatLogOutput(lErrorText))

            Finally
               ' Cleanup...
               If lDB IsNot Nothing Then
                  lDB.Dispose()
               End If
            End Try
         End Using
      End Using

      Return New Boolean() {False, False}
   End Function

   Private Sub ResetPendingMachineSiteStatus()
      Dim lErrorText As String = ""
      Using lDB As New Database(gConnectionString)

         Try
            lDB.CommandObject.CommandTimeout = 30

            lDB.ExecuteNonQuery("UPDATE RetailSiteStatus SET PendingMachineState = 0")
         Catch ex As Exception
            ' Handle the exception...
            ' Build and log the error text...
            lErrorText = "Startup::ResetPendingMachineSiteStatus error: " & ex.Message
            Trace.WriteLine(FormatLogOutput(lErrorText))

         Finally
            ' Cleanup...
            If lDB IsNot Nothing Then
               lDB.Dispose()
            End If

         End Try
      End Using

   End Sub


   Private Function GetCasinoSystemParameters(ByRef ConnectionString As String) As Boolean
      '--------------------------------------------------------------------------------
      ' This function will attempt to retrieve CASINO_SYSTEM_PARAMATERSfrom the database 
      ' and set variables required for transaction portal.
      '--------------------------------------------------------------------------------

      Dim lParName As String
      Dim lValue1 As String
      Dim lValue2 As String
      Dim lValue3 As String

      Try

         Using lDB As New Database(ConnectionString)
            lDB.CommandObject.CommandTimeout = 30

            Using lDS As DataSet = lDB.ExecuteQuery("SELECT PAR_NAME, VALUE1, VALUE2, VALUE3 FROM CASINO_SYSTEM_PARAMETERS")

               If lDS.Tables.Count > 0 Then

                  Using lDT As DataTable = lDS.Tables(0)

                     For Each lDR As DataRow In lDT.Rows

                        lParName = CStr(lDR("PAR_NAME"))

                        lValue1 = lDR("VALUE1").ToString()
                        lValue2 = lDR("VALUE2").ToString()
                        lValue3 = lDR("VALUE3").ToString()


                        Select Case lParName.ToUpper
                           Case "VOUCHER_PRINT_OPTIONS"

                              If Boolean.TryParse(lValue1, gCasinoSystemParameters.VoucherDisplayCasinoNameInAddressField) = False Then

                                 Throw New Exception("Unable to Parse Value1 of VOUCHER_PRINT_OPTIONS entry within CASINO_SYSTEM_PARAMETER")

                              End If

                           Case Else

                        End Select

                     Next


                  End Using

               Else

                  Throw New Exception("CASINO_SYSTEM_PARAMETERS table not found or no data.")

               End If

            End Using

         End Using


      Catch ex As Exception

         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(ex.Message))
         Return False

      End Try

      ' Set the function return value.
      Return True

   End Function

   Private Function TestDBConnection(ByRef ConnectionString As String) As Boolean
      '--------------------------------------------------------------------------------
      ' This function will attempt to retrieve TO_TIME and LOcATION_ID from the CASINO
      ' table, at the same time checking if database access is available.  This will
      ' also compute offset in minutes from TO_TIME and initialize msAccountingDate
      ' and set public variable gLocationID
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow

      Dim lTimeSpan As TimeSpan

      Dim lReturn As Boolean
      Dim lToDate As DateTime
      Dim lToTime As DateTime

      ' Try 60 times to connect to the DB for a total delay of 5 mins.
      For i As Int32 = 1 To 60
         Try
            lReturn = True

            ' Test the connection to the database.
            lDB = New Database(ConnectionString)
            lDB.CommandObject.CommandTimeout = 30

            ' Obtain the TO_TIME from the CASINO table
            lDS = lDB.ExecuteQuery("SELECT TO_TIME, LOCATION_ID FROM CASINO WHERE SETASDEFAULT = 1")
            If (lDS.Tables(0).Rows.Count = 1) Then
               lDR = lDS.Tables(0).Rows(0)
               lToTime = CType(lDR.Item("TO_TIME"), DateTime)
               gLocationID = CType(lDR.Item("LOCATION_ID"), Int32)

               If goTraceSwitch.TraceVerbose Then
                  Trace.WriteLine(FormatLogOutput("LocationID: " & gLocationID.ToString))
               End If

               ' Convert CASINO.TO_TIME to DateTime in "MM/dd/yyyy" format.
               lToDate = DateTime.Parse(lToTime.ToString("MM/dd/yyyy"))

               ' Get the Offset in minutes and initialize module var. "mToMinutesOffset".
               lTimeSpan = lToTime.Subtract(lToDate)
               mToMinutesOffset = CInt(lTimeSpan.TotalMinutes)

               ' Initialize the "msAccountingDate" module var.
               mAccountingDate = DateTime.Now.AddMinutes(-mToMinutesOffset).ToString("MM/dd/yyyy")

               If goTraceSwitch.TraceVerbose Then
                  Trace.WriteLine(FormatLogOutput("TestCasinoDBConnection -- To Time: " & lToTime.ToString & _
                                                  "  To Date: " & lToDate.ToString & "  Accounting Date: " & _
                                                  mAccountingDate & "   Minutes Offset: " & mToMinutesOffset.ToString))
               End If

               ' Get the drive letters for the Data & Log files for the "Casino" db.
               Call GetDriveLettersForDbFiles(ConnectionString)
            Else
               ' Database query failed.
               lReturn = False
            End If

         Catch ex As Exception
            ' There were problems.
            ' Set return value to False to prevent early exit from the For/Next loop.
            lReturn = False
            If i = 1 OrElse i Mod 5 = 0 Then
               Dim lErrorMsg As String = String.Format("Unable to communicate with database attempt #{0}.", i)

               If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(lErrorMsg))

            End If


            ' Sleep for 5 seconds and try again
            Threading.Thread.Sleep(5000)

         End Try

         ' If we were able to connect then exit the For/Next loop.
         If lReturn Then Exit For
      Next

      ' Cleanup...
      If lDB IsNot Nothing Then
         lDB.Dispose()
         lDB = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   'Private Function TestBingoDBConnection(ByVal ConnectionString As String) As Boolean
   '   '--------------------------------------------------------------------------------
   '   '   Purpose: Fire off a stored proc. just to see if we can access Bingo DB.
   '   ' Called by: Main
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim lReturn As Boolean

   '   ' Try 60 times to connect to the DB for a total delay of 5 mins.
   '   For i As Int32 = 1 To 60
   '      Try
   '         lReturn = True

   '         ' Get the drive letters for the Data & Log files for the "CasinoBingo" db.
   '         Call GetDriveLettersForDbFiles(ConnectionString)

   '      Catch ex As Exception
   '         ' There were problems.
   '         lReturn = False

   '         ' Sleep for 5 seconds and try again
   '         Threading.Thread.Sleep(5000)
   '      End Try

   '      ' If we were able to connect then stop looping and exit
   '      If lReturn Then Exit For

   '   Next

   '   Return lReturn

   'End Function

   Private Sub GetDriveLettersForDbFiles(ByVal ConnectionString As String)
      '--------------------------------------------------------------------------------
      ' Add drive letters of the Data & Log files of the DB in the "ConnectionString"
      ' and load them into mDriveList ArrayList.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet

      Dim lDriveLetter As String = ""
      Dim lServer As String
      Dim lConnInfo() As String
      Dim lKVPair() As String

      Try
         ' If TP is running on the same server as the database, we add drives to be checked for disk space.
         lConnInfo = ConnectionString.Split(";".ToCharArray)
         lKVPair = lConnInfo(0).Split("=".ToCharArray)
         lServer = lKVPair(1)

         If String.Compare(lServer, "(local)", True) = 0 OrElse String.Compare(lServer, My.Computer.Name, True) = 0 Then
            ' Create a new Database instance.
            lDB = New Database(ConnectionString)

            ' Retrieve drive letters.
            lDS = lDB.ExecuteQuery("SELECT UPPER(LEFT(filename, 3)) FROM sysfiles")

            ' Do we have data?
            If lDS.Tables(0).Rows.Count > 0 Then
               For Each lDataRow As DataRow In lDS.Tables(0).Rows
                  ' Get the drive letter and add it to mDriveList if unique...
                  lDriveLetter = CType(lDataRow.Item(0), String)
                  If Not (mDriveList.Contains(lDriveLetter)) Then mDriveList.Add(lDriveLetter)
               Next
            Else
               If goTraceSwitch.TraceError Then
                  Trace.WriteLine(FormatLogOutput("Startup::GetDriveLettersForDbFiles: Could not get drive letters for Database " & _
                                                  String.Join(".", lConnInfo, 0, 2)))
               End If
            End If
         Else
            If goTraceSwitch.TraceWarning Then
               Trace.WriteLine(FormatLogOutput("Startup::GetDriveLettersForDbFiles: Server is not '(local)', database drive letters for " & _
                                               lConnInfo(1) & " were not included."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception.
         Throw New Exception("'GetDriveLettersForDbFiles' Exception = " & ex.ToString)

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Private Sub RecordAppVersion()
      '--------------------------------------------------------------------------------
      ' Call stored procedure to record the version of this application.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lErrorText As String

      Try
         ' Create a new SqlDataAccess instance.
         lDB = New Database(gConnectionString)

         With lDB
            ' Add required parameters...
            .AddParameter("@ApplicationName", SqlDbType.VarChar, My.Application.Info.AssemblyName, 64)
            .AddParameter("@ComputerName", SqlDbType.VarChar, My.Computer.Name, 64)
            .AddParameter("@CurrentVersion", SqlDbType.VarChar, mAppVersion, 16)
            .AddParameter("@OSFullname", SqlDbType.VarChar, My.Computer.Info.OSFullName, 64)
            .AddParameter("@OSPlatform", SqlDbType.VarChar, My.Computer.Info.OSPlatform, 64)
            .AddParameter("@OSVersion", SqlDbType.VarChar, My.Computer.Info.OSVersion, 64)
            .AddParameter("@MemoryTotalPhysical", SqlDbType.BigInt, My.Computer.Info.TotalPhysicalMemory)
            .AddParameter("@MemoryTotalVirtual", SqlDbType.BigInt, My.Computer.Info.TotalVirtualMemory)
            .AddParameter("@MemoryAvailablePhysical", SqlDbType.BigInt, My.Computer.Info.AvailablePhysicalMemory)
            .AddParameter("@MemoryAvailableVirtual", SqlDbType.BigInt, My.Computer.Info.AvailableVirtualMemory)

            ' Execute stored procedure InsertAppInfo
            .ExecuteProcedureNoResult("InsertAppInfo")

            ' If verbose tracing, log the app version recorded...
            If goTraceSwitch.TraceVerbose Then
               Trace.WriteLine(FormatLogOutput("RecordAppVersion recorded version " & mAppVersion & " to APP_INFO."))
            End If
         End With

      Catch ex As Exception
         ' Handle the exception...
         ' Build and log the error text...
         lErrorText = "Startup::RecordAppVersion error: " & ex.Message
         Trace.WriteLine(FormatLogOutput(lErrorText))

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Private Sub RecordCasinoDbVersion()
      '--------------------------------------------------------------------------------
      ' Call stored procedure to record the version of this application.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDT As DataTable

      Dim lData() As String
      Dim lDBVersion As String
      Dim lErrorText As String
      Dim lSQL As String

      Try
         ' Build SQL Select statement.
         lSQL = "SELECT ISNULL(MAX(UPGRADE_VERSION), '0') FROM DB_INFO"

         ' Create a new SqlDataAccess instance.
         lDB = New Database(gConnectionString)

         ' Retrieve the latest ugrade version...
         lDT = lDB.CreateDataTable(lSQL, "DBVersion")

         ' Expect 1 row, if so, store the database version.
         If lDT.Rows.Count = 1 Then
            ' Store the database version.
            lDBVersion = CType(lDT.Rows(0).Item(0), String)

            ' Count number of version elements and add '.0' if less than 4...
            lData = lDBVersion.Split(".".ToCharArray)
            If lData.Length < 4 Then lDBVersion &= ".0"

            With lDB
               ' Add required parameters...
               .AddParameter("@ApplicationName", SqlDbType.VarChar, "Database", 64)
               .AddParameter("@ComputerName", SqlDbType.VarChar, My.Computer.Name, 64)
               .AddParameter("@CurrentVersion", SqlDbType.VarChar, lDBVersion, 16)
               .AddParameter("@OSFullname", SqlDbType.VarChar, My.Computer.Info.OSFullName, 64)
               .AddParameter("@OSPlatform", SqlDbType.VarChar, My.Computer.Info.OSPlatform, 64)
               .AddParameter("@OSVersion", SqlDbType.VarChar, My.Computer.Info.OSVersion, 64)
               .AddParameter("@MemoryTotalPhysical", SqlDbType.BigInt, My.Computer.Info.TotalPhysicalMemory)
               .AddParameter("@MemoryTotalVirtual", SqlDbType.BigInt, My.Computer.Info.TotalVirtualMemory)
               .AddParameter("@MemoryAvailablePhysical", SqlDbType.BigInt, My.Computer.Info.AvailablePhysicalMemory)
               .AddParameter("@MemoryAvailableVirtual", SqlDbType.BigInt, My.Computer.Info.AvailableVirtualMemory)

               ' Execute stored procedure InsertAppInfo
               .ExecuteProcedureNoResult("InsertAppInfo", False)

               ' If verbose tracing, log the db version recorded...
               If goTraceSwitch.TraceVerbose Then
                  Trace.WriteLine(FormatLogOutput("RecordCasinoDbVersion recorded db version " & lDBVersion & " to APP_INFO."))
               End If

            End With
         End If

      Catch ex As Exception
         ' Handle the exception...
         ' Build and log the error text...
         lErrorText = "Startup::RecordCasinoDbVersion error: " & ex.Message
         Trace.WriteLine(FormatLogOutput(lErrorText))

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Private Function ResetMachineListener() As Boolean
      '--------------------------------------------------------------------------------
      ' Routine to close, free, and restart the machine listener.
      ' Returns T/F to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lASR As New AppSettingsReader
      Dim lReturn As Boolean = True
      Dim lMLBacklog As Integer
      Dim lSetupValue As String


      Try
         ' Get or set the Machine Listener Backlog value.
         If mMachineListener IsNot Nothing Then
            ' Store the ListenBacklog value from the current listener.
            lMLBacklog = mMachineListener.ListenBacklog
         Else
            ' Read the ListenBacklog value from the config file...
            lSetupValue = CType(lASR.GetValue("Machine Listener Backlog", Type.GetType("System.String")), String)
            If Integer.TryParse(lSetupValue, lMLBacklog) = False Then lMLBacklog = 100
         End If

         ' Crete a new instance.
         mMachineListener = New Communication.Networking.TcpServer

         ' Init and open it.
         With mMachineListener
            .Port = mMachinePort
            .ListenBacklog = lMLBacklog   ' Listening for machines, may be more than 150 machines...
            .Open()
         End With

      Catch ex As Exception
         ' Handle the exception
         lReturn = False
         Trace.WriteLine(FormatLogOutput("ResetMachineListener error: " & ex.Message))

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub ShutdownServer(ByVal ErrorID As Int32, ByVal ErrorDescription As String)
      Dim lItem As DictionaryEntry

      Try
         For Each lItem In gMachineCollection
            CType(lItem.Value, Machine).Shutdown(ErrorID, ErrorDescription)
         Next

      Catch ex As Exception
         ' Handle the exception.
         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(ex.ToString))

      End Try

   End Sub

   Private Sub StartupServer()
      Dim lItem As DictionaryEntry

      Try
         For Each lItem In gMachineCollection
            CType(lItem.Value, Machine).Startup()
         Next

      Catch ex As Exception
         ' Handle the exception.
         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(ex.ToString))

      End Try

   End Sub

   Private Sub OnTPCRefreshTimerEvent(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs)
      '--------------------------------------------------------------------------------
      '   Purpose: Refresh gMachineHT "ACTIVE_FLAG" value from gMachineCollection.
      ' Called by: mTPCRefreshTimer on every timer tick.
      '     Calls: tpGetMachine, MachineRequestGrandMeters
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lMachine As Machine
      Dim lAccountingDate As String = DateTime.Now.AddMinutes(-mToMinutesOffset).ToString("MM/dd/yy")
      Dim pendingMachineChange As Boolean()

      Try
         ' Check if we need to poll the "Bingo Blower" service.
         'Call PollBingoBlowerService()

         ' Check if DB's data/log files & TP's log file drives have > 100 mb free.
         Call CheckDriveSpace()

         ' Get the IP_ADDRESS of each machine from the gMachineCollection
         If gMachineCollection.Count > 0 Then
            pendingMachineChange = PendingMachineSiteStatusChange()

            For Each lItem As DictionaryEntry In gMachineCollection
               lMachine = CType(lItem.Value, Machine)
               ' Check if the Accounting Date has changed
               If (DateTime.Parse(lAccountingDate) > DateTime.Parse(mAccountingDate)) Then
                  ' Send the "A" trans. with "RequestGrandMeters"
                  lMachine.MachineRequestGrandMeters()
               End If

               If Not pendingMachineChange(1) Then
                  lMachine.Shutdown(300, "Transaction Portal Control shutdown initiated.")
               ElseIf pendingMachineChange(0) AndAlso pendingMachineChange(1) Then
                  lMachine.Startup()
               End If

               ' Add or update the ACTIVE_FLAG for this MACH_NO in gMachineHT
               Call AddUpdateMachNoActiveFlag(lMachine.MachineNumber, lMachine.ActiveFlag)
            Next

            If pendingMachineChange(0) Then
               ResetPendingMachineSiteStatus()
            End If

            ' If the Accounting Date has changed, then store the new Accounting Date in Module var.
            If (DateTime.Parse(lAccountingDate) > DateTime.Parse(mAccountingDate)) Then
               If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Old Accounting date: " & mAccountingDate & "   New Accounting date: " & lAccountingDate))
               mAccountingDate = lAccountingDate
            End If
         End If

      Catch ex As Exception
         ' Handle the exception.
         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("OnTPCRefreshTimerEvent Exception: " & ex.Message))

      End Try

   End Sub

   'Private Sub PollBingoBlowerService()
   '   '--------------------------------------------------------------------------------
   '   ' Purpose: Checks every minute the # of Bingo Machines in casino. If # > 0 then
   '   '          check if the "Bingo Blower" service is down. If down sets
   '   '          CurrentBingoGame.BingoGameID to 0.
   '   '
   '   ' Called by: OnTPCRefreshTimerEvent
   '   ' Calls: DbTpGetBingoMachineCount, BingoBlowerServiceDown, bbsClearCurrentGameID
   '   '--------------------------------------------------------------------------------

   '   Try
   '      ' Check if 1 minute has elapsed.
   '      If ((mTPCRefreshInterval * 1000 * mTPCRefreshTicks) = 60000) Then
   '         ' Check if casino has any bingo machines.
   '         If (DbTpGetBingoMachineCount() > 0) Then
   '            ' Casino has Bingo machines, check if "Bingo Blower" service is down.
   '            If (BingoBlowerServiceDown()) Then
   '               ' "Bingo Blower" service down, set CurrentBingoGame.BingoGameID = 0 in DB
   '               Call bbsClearCurrentGameID()
   '            End If
   '         End If

   '         ' Reset RefreshTimer Ticks counter
   '         mTPCRefreshTicks = 0
   '      Else
   '         ' Increment RefreshTimer Ticks counter
   '         mTPCRefreshTicks += 1
   '      End If

   '   Catch ex As Exception
   '      ' Handle the exception.
   '      If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("Startup::PollBingoBlowerService exception: " & ex.Message))
   '   End Try

   'End Sub

   'Private Function BingoBlowerServiceDown() As Boolean
   '   '--------------------------------------------------------------------------------
   '   ' Purpose: Returns True if "Bingo Blower" service is stopped, otherwise, False.
   '   ' Called by: PollBingoBlowerService
   '   ' Calls:
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim lReturn As Boolean = True

   '   Try
   '      Dim lServiceController As New ServiceController
   '      With lServiceController
   '         .MachineName = mBingoBlowerMachineName
   '         .ServiceName = "DGE Bingo Blower"
   '         .Refresh()
   '         If (.Status = ServiceControllerStatus.Running) Then
   '            lReturn = False
   '         End If

   '      End With

   '   Catch ex As Exception
   '      ' Handle the exception.
   '      If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("Startup::BingoBlowerServiceDown exception: " & ex.Message))

   '   End Try

   '   ' Set the function return value.
   '   Return lReturn

   'End Function

   Private Sub CheckDriveSpace()
      '--------------------------------------------------------------------------------
      ' Purpose: Checks if Database Data, Log, and TP's log file drives in mDriveList
      '          have < 100 Mb free. If so stop TP service.
      '
      ' Called by: OnTPCRefreshTimerEvent
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDriveInfo As DriveInfo
      Dim lDriveInfoList() As DriveInfo

      Try
         ' Retrieve the drive names of all logical drives on this computer.
         lDriveInfoList = DriveInfo.GetDrives

         ' Compare each drive letter on this server against those stored in mDriveList.
         For Each lDriveInfo In lDriveInfoList
            If mDriveList.Contains(lDriveInfo.Name.ToUpper) Then
               ' Drive letter matched, now check if free space < 100 mb
               If lDriveInfo.AvailableFreeSpace < 100000000 Then
                  If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("*** DISK SPACE ON DRIVE : " & lDriveInfo.Name.ToUpper & " < 100 MB. STOPPING TP ***"))
                  RaiseEvent StopTransactionPortalService()
               End If
            End If
         Next

      Catch ex As Exception
         ' Handle the exception.
         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("'CheckDriveSpace': Exception = " & ex.ToString))

      End Try

   End Sub

   Private Sub mMachineListener_ClientConnected(ByVal sender As Object, ByVal e As Networking.TcpClient) Handles mMachineListener.ClientConnected
      '--------------------------------------------------------------------------------
      ' ClientConnected event handler for the Machine Listener.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDR As DataRow = Nothing

      Dim lRowCount As Integer

      Dim lIpAddress As String = ""

      Try
         ' Get the Ip address so we can do a lookup.
         lIpAddress = CType(e.Socket.RemoteEndPoint, IPEndPoint).Address.ToString()
         Trace.WriteLine(FormatLogOutput("Connection from IP address: " & lIpAddress & " (MachineListener_ClientConnected)"))

         If gMachineCollection.ContainsKey(lIpAddress) Then
            ' If verbose logging is on, log this attempt to remove existing machine collection item.
            If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Dropping existing machine collection entry for IP address: " & lIpAddress))

            ' Calling TcpClient.Close results in the machine being removed from gMachineColection.
            Dim lMachine As Machine = CType(gMachineCollection(lIpAddress), Machine)
            lMachine.TcpClient.Close()

            ' Wait for the removal from the machine collection...
            While gMachineCollection.ContainsKey(lIpAddress)
               Threading.Thread.Sleep(80)
            End While
         End If

         ' Machine doesn't exist in collection - retrieve machine information from the database...
         ' Note that tpGetMachine returns 2 datasets, 1 with machine info and 1 with denoms.
         lDB = New Database(gConnectionString)
         lDB.AddParameter("@IP_ADDRESS", lIpAddress)

         lDS = lDB.ExecuteProcedure("tpGetMachine")
         If lDS IsNot Nothing Then
            If lDS.Tables.Count > 0 Then
               lDT = lDS.Tables(0)
               lRowCount = lDT.Rows.Count
               lDR = lDT.Rows(0)
               If goTraceSwitch.TraceVerbose Then
                  Trace.WriteLine(FormatLogOutput(String.Format("tpGetMachine returned {0} rows.", lRowCount)))
               End If
            End If
         End If

         If lDR IsNot Nothing AndAlso lRowCount > 0 Then
            ' Machine exists in db.
            Dim lMachine As New Machine

            With lMachine
               .Bank = CType(lDR.Item("BANK_NO"), Integer)
               .MachineNumber = CType(lDR.Item("MACH_NO"), String)
               .SerialNumber = CType(lDR.Item("MACH_SERIAL_NO"), String)
               .GameTypeCode = CType(lDR.Item("GAME_TYPE_CODE"), String)
               .LockupAmount = Math.Abs(CType(lDR.Item("LOCKUP_AMOUNT"), Integer))
               .GameTypeDescription = CType(lDR.Item("LONG_NAME"), String)
               .GameRelease = CType(lDR.Item("GAME_RELEASE"), String)
               .OSVersion = CType(lDR.Item("OS_VERSION"), String)

               ' Starting with v7.2.2, BlueDiamond machines send additional info that is
               ' returned by tpGetMachine...
               If lDT.Columns.Contains("SYSTEM_VERSION") Then
                  .SystemVersion = CType(lDR.Item("SYSTEM_VERSION"), String)
               Else
                  .SystemVersion = ""
               End If

               If lDT.Columns.Contains("SYSTEM_LIB_A_VERSION") Then
                  .SysLibAVersion = CType(lDR.Item("SYSTEM_LIB_A_VERSION"), String)
               Else
                  .SysLibAVersion = ""
               End If

               If lDT.Columns.Contains("SYSTEM_CORE_LIB_VERSION") Then
                  .SysCoreLibVersion = CType(lDR.Item("SYSTEM_CORE_LIB_VERSION"), String)
               Else
                  .SysCoreLibVersion = ""
               End If

               If lDT.Columns.Contains("MATH_DLL_VERSION") Then
                  .MathDllVersion = CType(lDR.Item("MATH_DLL_VERSION"), String)
               Else
                  .MathDllVersion = ""
               End If

               If lDT.Columns.Contains("GAME_CORE_LIB_VERSION") Then
                  .GameCoreLibVersion = CType(lDR.Item("GAME_CORE_LIB_VERSION"), String)
               Else
                  .GameCoreLibVersion = ""
               End If

               If lDT.Columns.Contains("GAME_LIB_VERSION") Then
                  .GameLibVersion = CType(lDR.Item("GAME_LIB_VERSION"), String)
               Else
                  .GameLibVersion = ""
               End If

               If lDT.Columns.Contains("MATH_LIB_VERSION") Then
                  .MathLibVersion = CType(lDR.Item("MATH_LIB_VERSION"), String)
               Else
                  .MathLibVersion = ""
               End If

               .GameDescription = CType(lDR.Item("GAME_DESC"), String)
               .GameCode = CType(lDR.Item("GAME_CODE"), String)
               .BankDescription = CType(lDR.Item("BANK_DESCR"), String)
               .ProductLineID = CType(lDR.Item("PRODUCT_LINE_ID"), Integer)
               .IpAddress = CType(lDR.Item("IP_ADDRESS"), String)
               .CasinoMachineNumber = CType(lDR.Item("CASINO_MACH_NO"), String)
               .VoucherPrintingFlag = Math.Abs(CType(lDR.Item("VOUCHER_PRINTING"), Integer))
               .Status = Math.Abs(CType(lDR.Item("ACTIVE_FLAG"), Integer))
               ' Also initialize the property "ActiveFlag" in the PlayerTerminal class with the ACTIVE_FLAG value.
               .ActiveFlag = .Status
               .RebootAfterDrop = Math.Abs(CType(lDR.Item("REBOOT_AFTER_DROP"), Integer))
               .TypeID = CType(lDR.Item("TYPE_ID"), String)
            End With

            ' Do we have denoms?
            If lDS.Tables(1).Rows.Count > 0 Then
               ' We have denoms, build an arraylist for all the denoms.
               Dim lDenomList As New ArrayList
               For Each lDataRow As DataRow In lDS.Tables(1).Rows
                  lDenomList.Add(CType(lDataRow.Item(0), Decimal))
               Next
               lMachine.Denom = lDenomList
            End If

            With lMachine
               .ApplicationPath = gApplicationPath
               .CasinoSystemParameters = gCasinoSystemParameters
               .ConnectionString = gConnectionString
               .PingTimer = mPingTimer
               .PingResponseTimer = mPingResponseTimer
               .TcpClient = e
               .TpiClientType = mTpiClientType
               .TpiServer = mTpiServer
               .TraceSwitch = goTraceSwitch
               ' Load Bingo parameters from app.config
               '.BingoDBConnectionString = mBingoDBConnectionString
               .BingoDBConnectionString = ""
               '.BingoLoggingLevel = mBingoLoggingLevel
               .BingoLoggingLevel = 0
               '.BingoMinimumPlayers = mBingoMinimumPlayers
               .BingoMinimumPlayers = 0
               ' Load Casino table cols. from tpGetCasinoInfo
               .AutoDrop = mAutoDrop
               '.BingoFreeSquare = mBingoFreeSquare
               .BingoFreeSquare = 0
               .TpiID = mTpiID
               .LocationID = gLocationID
               .CasID = mCasID
               .CasName = mCasName
               .CasinoAddress = mCasinoAddress
               .CityStateZip = mCityStateZip
            End With

            lMachine.Start()
            gMachineCollection.Add(lIpAddress, lMachine)

         Else
            ' Machine doesn't exist in db, close the connection.
            e.Close()
            If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("Connection from IP address: " & lIpAddress & " closed.  No machine found in database."))
         End If

      Catch ex As Exception
         ' Handle the exception.
         e.Close()
         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("Connection from IP address: " & lIpAddress & " closed. Error: " & ex.ToString))

      Finally
         ' Cleanup...
         If lDT IsNot Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If

         If lDS IsNot Nothing Then
            lDS.Dispose()
            lDS = Nothing
         End If

         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Private Sub mTpcListener_ClientConnected(ByVal sender As Object, ByVal e As Networking.TcpClient) Handles mTpcListener.ClientConnected
      '--------------------------------------------------------------------------------
      ' ClientConnected event handler for the TPC Listener.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lIpAddress As String = ""

      Try
         lIpAddress = CType(e.Socket.RemoteEndPoint, IPEndPoint).Address.ToString()

         Dim lTpc As New TransactionPortalControl
         With lTpc
            .IpAddress = lIpAddress
            .TcpClient = e
            .TraceSwitch = goTraceSwitch
            .Start()
         End With

      Catch ex As Exception
         ' Handle the exception.
         e.Close()
         If goTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("Connection from Transaction Portal Control at IP address: " & lIpAddress & " closed. Error: " & ex.ToString))
         End If
      End Try

   End Sub

   Private Sub mMachineListener_OpenComplete(ByVal sender As Object, ByVal e As CommEventArgs) Handles mMachineListener.OpenComplete

      If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Listening for Machine connections on port: " & mMachinePort.ToString))

   End Sub

   Private Sub mTpcListener_OpenComplete(ByVal sender As Object, ByVal e As CommEventArgs) Handles mTpcListener.OpenComplete

      If goTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Listening for Tpc connections on port: " & mTpcPort.ToString))

   End Sub

   Private Sub mMachineListener_AcceptClientError(ByVal sender As Object, ByVal e As CommEventArgs) Handles mMachineListener.AcceptClientError

      ' There is nothing to catch here, so just log that an error took place in sub AcceptClient in TcpServer.vb.
      If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("Machine Listener Error occurred in sub AcceptClient in TcpServer.vb : " & e.AcceptClientError))

   End Sub

   Private Sub mTpcListener_AcceptClientError(ByVal sender As Object, ByVal e As CommEventArgs) Handles mTpcListener.AcceptClientError

      ' There is nothing to catch here, so just log that an error took place in sub AcceptClient in TcpServer.vb.
      If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("Tpc Listener Error occurred in sub AcceptClient in TcpServer.vb : " & e.AcceptClientError))

   End Sub

   Private Sub AddUpdateMachNoActiveFlag(ByVal aMachNo As String, ByVal aActiveFlag As Integer)
      '--------------------------------------------------------------------------------
      ' Purpose: Adds or updates active flag value in gMachineHT item for the specified
      ' Machine number.
      ' Called by: OnTPCRefreshTimerEvent
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lOldActiveFlag As Integer = 0
      ' Dim lDataRow As DataRow

      Try
         ' Does the Machine Number (aMachNo) exist as a key in gMachineHT?
         If gMachineHT.ContainsKey(aMachNo) Then
            ' Yes, so store the current ActiveFlag value.
            lOldActiveFlag = CType(gMachineHT.Item(aMachNo), Integer)

            ' Has the value changed?
            If lOldActiveFlag <> aActiveFlag Then
               ' Yes, so update it.
               gMachineHT.Item(aMachNo) = aActiveFlag
            End If
         Else
            ' Not found, so add it.
            gMachineHT.Add(aMachNo, aActiveFlag)
         End If

         'lDataRow = gMachineHT.Rows.Find(aMachNo)
         'If (lDataRow Is Nothing) Then ' OrElse (lRowNumber = -1) Then
         '   ' MACH_NO does not exist yet in dt, so add a new row of MACH_NO, ACTIVE_FLAG.
         '   lDataRow = gMachineHT.NewRow()
         '   lDataRow.Item("MACH_NO") = aMachNo
         '   lDataRow.Item("ACTIVE_FLAG") = aActiveFlag
         '   gMachineHT.Rows.Add(lDataRow)
         'Else
         '   ' MACH_NO already exists in datatable so store the Old ACTIVE_FLAG value.
         '   lOldActiveFlag = CType(lDataRow.Item("ACTIVE_FLAG"), Int32)

         '   ' Refresh the ACTIVE_FLAG with the new value if it has changed.
         '   If lOldActiveFlag <> aActiveFlag Then
         '      lDataRow.BeginEdit()
         '      lDataRow.Item("ACTIVE_FLAG") = aActiveFlag
         '      lDataRow.EndEdit()
         '      gMachineHT.AcceptChanges()
         '   End If
         'End If

      Catch ex As Exception
         ' Handle the exception.
         If goTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("Startup::AddUpdateMachNoActiveFlag Error: " & ex.ToString))
         End If

      End Try

   End Sub

#Region "DB Calls"

   Private Sub DbTpGetCasinoInfo()
      '--------------------------------------------------------------------------------
      ' Retrieves TPI_ID, CAS_ID, CAS_NAME, CITYSTATEZIP, LOCKUP_AMOUNT, AUTO_DROP_INT,
      ' and BINGO_FREE_SQUARE values from the CASINO table.
      '
      ' Called by: Startup
      ' Calls: tpGetCasinoInfo
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Try
         lDB = New Database(gConnectionString)
         Dim lSql As String = " SELECT TPI_ID, CAS_ID, CAS_NAME, ISNULL(ADDRESS1, '') ADDRESS1, ISNULL(CITY, '') + ' / ' + ISNULL(STATE, '') + ' / ' + ISNULL(ZIP, '') AS CITYSTATEZIP, CAST(AUTO_DROP AS Int) AS AUTO_DROP_INT, CAST(BINGO_FREE_SQUARE AS Int)  AS BINGO_FREE_SQUARE FROM CASINO   WHERE SETASDEFAULT = 1"

         lDT = lDB.CreateDataTable(lSql)

         ' Initialize all the module vars. from the columns of the Casino table.
         lDR = lDT.Rows(0)

         mTpiID = CType(lDR.Item("TPI_ID"), Int32)
         mCasID = CType(lDR.Item("CAS_ID"), String)
         mCasName = CType(lDR.Item("CAS_NAME"), String)
         mCasinoAddress = CType(lDR.Item("ADDRESS1"), String)
         mCityStateZip = CType(lDR.Item("CITYSTATEZIP"), String)
         mAutoDrop = CType(lDR.Item("AUTO_DROP_INT"), Int32)
         'mBingoFreeSquare = CType(lDR.Item("BINGO_FREE_SQUARE"), Int32)

      Catch ex As Exception
         ' Handle the exception.
         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("'DbTpGetCasinoInfo' Error: " & ex.ToString))

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   'Private Function DbTpGetBingoMachineCount() As Integer
   '   '--------------------------------------------------------------------------------
   '   ' Purpose: Returns the number of Bingo Machines in Casino. 0 if Error.
   '   ' Called by: PollBingoBlowerService
   '   ' Calls: tpGetBingoMachineCount
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim lDB As Database = Nothing
   '   Dim lDT As DataTable = Nothing

   '   Dim lReturn As Integer = 0


   '   Try
   '      lDB = New Database(gConnectionString)
   '      lDT = lDB.CreateDataTableSP("tpGetBingoMachineCount")
   '      lReturn = CType(lDT.Rows(0).Item("BingoMachineCount"), Integer)

   '      If goTraceSwitch.TraceVerbose Then
   '         Trace.WriteLine(FormatLogOutput("DbTpGetBingoMachineCount returned: " & lReturn.ToString))
   '      End If

   '   Catch ex As Exception
   '      ' Handle the exception.
   '      lReturn = 0
   '      If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("'DbTpGetBingoMachineCount' Error: " & ex.ToString))

   '   Finally
   '      ' Cleanup, free DataTable and Database references...
   '      If lDT IsNot Nothing Then
   '         lDT.Dispose()
   '         lDT = Nothing
   '      End If

   '      If lDB IsNot Nothing Then
   '         lDB.Dispose()
   '         lDB = Nothing
   '      End If

   '   End Try

   '   ' Set the function return value.
   '   Return lReturn

   'End Function

   'Private Sub bbsClearCurrentGameID()
   '   '--------------------------------------------------------------------------------
   '   '   Purpose: Sets the value of CurrentBingoGame.BingoGameID to 0 to indicate
   '   '            that the Blower service is not running.
   '   ' Called by: PollBingoBlowerService
   '   '     Calls: bbsClearCurrentGameID
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim lDB As Database = Nothing
   '   Dim lRC As Integer

   '   Try
   '      ' Create a new database object instance and then execute stored procedure bbsClearCurrentGameID...
   '      lDB = New Database(mBingoDBConnectionString)
   '      lRC = lDB.ExecuteProcedureNoResult("bbsClearCurrentGameID")

   '   Catch ex As Exception
   '      ' Handle the exception.
   '      If goTraceSwitch.TraceError Then
   '         Trace.WriteLine(FormatLogOutput("Startup::bbsClearCurrentGameID error: " & ex.ToString))
   '      End If

   '   Finally
   '      ' Cleanup...
   '      If lDB IsNot Nothing Then
   '         lDB.Dispose()
   '         lDB = Nothing
   '      End If

   '   End Try

   'End Sub

#End Region

End Module
