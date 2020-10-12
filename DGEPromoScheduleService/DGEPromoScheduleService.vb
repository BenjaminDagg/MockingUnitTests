Imports System.IO
Imports System.Threading

Public Class DGEPromoScheduleService

   Private mEventLog As New EventLog("Application")

   ' [Private variables]
   Private mPollingTimer As System.Timers.Timer
   Private WithEvents mNetworkClient As New NetworkClient

   Private mWorkerThread As Thread

   Private mAppPath As String
   Private mConnectCasino As String
   Private mCrLf As String = Environment.NewLine
   Private mServiceName As String
   Private mTPMessage As String

   Private mLogWhenNothingToDo As Boolean

   Private mPollingInterval As Double

   Private mCount As Long = 0


   Protected Overrides Sub OnStart(ByVal args() As String)
      '--------------------------------------------------------------------------------
      ' OnStart routine - called when service starts
      '--------------------------------------------------------------------------------

      Try
         ' Store the folder name containing this application.
         mAppPath = My.Application.Info.DirectoryPath

         ' Read log setting.
         mLogWhenNothingToDo = My.Settings.LogWhenNothingToDo

         ' Call function to initialize this service.
         If InitializeThisService() Then
            If AuthenticateApp() Then
               ' Authentication succeeded.
               ' Start the routine to check schedule info on a new thread...
               mWorkerThread = New Thread(AddressOf CheckPromoScheduling)
               With mWorkerThread
                  .Name = "PromoScheduleThread"
                  .Priority = ThreadPriority.Normal
                  .Start()
               End With

               ' Write application version information to Casino.APP_INFO table.
               Call RecordAppVersion()
            Else
               ' Application did not pass application authentication...
               Throw New Exception("Did not pass application authentication.")
            End If
         Else
            ' Errors were encountered, stop the service.
            Throw New Exception("Application Initialization failed.")
         End If

      Catch ex As Exception
         ' Handle the exception...
         mEventLog.WriteEntry("OnStart error: " & ex.Message)
         Me.Stop()

      End Try

   End Sub

   Protected Overrides Sub OnStop()
      '--------------------------------------------------------------------------------
      ' OnStop routine - called when this service application is about to stop.
      '--------------------------------------------------------------------------------

      Try
         'If mWorkerThread.ThreadState = ThreadState.Running Then
         '   Me.SrvController.WaitForStatus(ServiceProcess.ServiceControllerStatus.Stopped)
         'End If
         mEventLog.WriteEntry("DGEPromoScheduleService stopping.", EventLogEntryType.Information, 9999)
         mEventLog.Dispose()
         mEventLog = Nothing

      Catch ex As Exception
         ' Handle the exception...
         Debug.WriteLine("OnStop error: " & ex.Message)

      End Try

   End Sub

   Protected Overrides Sub OnPause()
      '--------------------------------------------------------------------------------
      ' OnPause routine - called when this service application is paused.
      '--------------------------------------------------------------------------------

      Try
         mEventLog.WriteEntry("DGEPromoScheduleService pausing.", EventLogEntryType.Information, 2000)

      Catch ex As Exception
         ' Handle the exception...
         Debug.WriteLine("OnPause error: " & ex.Message)
         ' Me.Stop()

      End Try

   End Sub

   Protected Overrides Sub OnContinue()
      '--------------------------------------------------------------------------------
      ' OnContinue routine - called when this service application is restarted after
      ' having been paused.
      '--------------------------------------------------------------------------------

      Try
         mEventLog.WriteEntry("DGEPromoScheduleService continuing.", EventLogEntryType.Information, 2001)

      Catch ex As Exception
         ' Handle the exception...
         Debug.WriteLine("OnContinue error: " & ex.Message)
         '          Me.Stop()

      End Try

   End Sub

   Protected Overrides Sub OnShutdown()
      '--------------------------------------------------------------------------------
      ' OnShutdown routine - called when this service application is about to stop
      ' because the system is shutting down.
      '--------------------------------------------------------------------------------

      Try
         mEventLog.WriteEntry("DGEPromoScheduleService stopping.", EventLogEntryType.Information, 9998)

      Catch ex As Exception
         ' Handle the exception...
         Debug.WriteLine("OnShutdown error: " & ex.Message)

      End Try

   End Sub

   Protected Overrides Sub OnCustomCommand(ByVal command As Integer)
      '--------------------------------------------------------------------------------
      ' OnCustomCommand routine - called when this service application receives a
      ' cutom command integer value.
      '--------------------------------------------------------------------------------

      Try
         mEventLog.WriteEntry(String.Format("DGEPromoScheduleService received a custom command value of {0}.", command), _
                              EventLogEntryType.Information, 9998)

      Catch ex As Exception
         ' Handle the exception...
         Debug.WriteLine("OnCustomCommand error: " & ex.Message)

      End Try

   End Sub

   Private Function AuthenticateApp() As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluate hash of app exe
      ' Return T/F
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
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


      ' First, determine if authentication is required...
      Try
         ' Intantiate a new SqlDataAccess object.
         lSDA = New SqlDataAccess(mConnectCasino, False, 60)

         ' Execute stored procedure GetAuthorizeAppsFlag and store the RETURNed value...
         lSDA.ExecuteProcedureNoResult("GetAuthorizeAppsFlag")
         lAuthRequired = (lSDA.ReturnValue = 1)

      Catch ex As Exception
         ' Handle the exception.
         ' Assume that an error means that authentication is not required.
         lAuthRequired = False

      Finally
         ' Cleanup.
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Store the fully qualified filename of the message digest file that will be used for comparison.
      lMsgDigest = Path.Combine(mAppPath, "ptspMsgDigest.dat")

      ' Is application authorization required?
      If lAuthRequired Then
         ' Yes, so populate the source file array with fully qualified filenames to check...
         lSourceFiles = My.Settings.AppAuthList.Split(",".ToCharArray)

         ' Build fully qualified filenames.
         For lIndex As Integer = 0 To lSourceFiles.GetUpperBound(0)
            lSourceFiles(lIndex) = Path.Combine(mAppPath, lSourceFiles(lIndex))
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
               lErrorText = "Module Startup::AuthenticateApp error: " & ex.Message
               lReturn = False

            End Try
         End If

         ' If there is error text, log it...
         If String.IsNullOrEmpty(lErrorText) = False Then
            mEventLog.WriteEntry(lErrorText)
         End If
      Else
         ' Authentication is not required, return true.
         lReturn = True
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function InitializeThisService() As Boolean
      '--------------------------------------------------------------------------------
      ' Routine to initialize this service.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lAPE As New AppPasswordEncryption()

      Dim lPollingFreqMinutes As Decimal
      Dim lConnString As String
      Dim lErrorText As String = ""
      Dim lPassword As String
      Dim lUID As String
      Dim lValue As String

      Try
         ' Store the service name and set it as the eventlog source...
         mServiceName = Me.ServiceName
         mEventLog.Source = mServiceName

         ' Write a log entry
         mEventLog.WriteEntry(mServiceName & " initializing.", EventLogEntryType.Information)

         ' Retrieve application settings...
         With My.Settings
            ' Build casino connection string...
            lUID = .ConnectUID
            lPassword = lAPE.DecryptPassword(.ConnectKey)
            lValue = .CasinoConnect
            mConnectCasino = String.Format(lValue, lUID, lPassword)

            ' Retrieve polling interval and multipy by 60000 (to convert minutes to milliseconds)
            lPollingFreqMinutes = .PollingFrequency
            mPollingInterval = lPollingFreqMinutes * 60000

            ' Add the polling frequency to the log text.
            mEventLog.WriteEntry(String.Format("Polling Frequency is every {0} minutes.", lPollingFreqMinutes), EventLogEntryType.Information)
         End With

         Try
            ' Test the eTab database connection...
            lConnString = mConnectCasino
            If IsValidConnection(lConnString) Then
               mEventLog.WriteEntry("Casino database connection successful.", EventLogEntryType.Information)
            Else
               lErrorText = "Cannot connect to the Casino database."
               mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)
            End If

         Catch ex As Exception
            ' Handle the error.
            lErrorText = "Error verifying Casino database connection: " & ex.Message
            mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)

         End Try

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = "Error initializing app settings - " & ex.Message
         mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)

      End Try

      If lErrorText.Length = 0 Then
         Try
            ' Init and start the polling timer...
            mPollingTimer = New System.Timers.Timer(mPollingInterval)
            AddHandler mPollingTimer.Elapsed, AddressOf Me.TimerElapsed
            With mPollingTimer
               .AutoReset = True
               .Enabled = True
            End With

            ' Add timer status to the log text.
            mEventLog.WriteEntry("Polling timer successfully initialized.", EventLogEntryType.Information)

         Catch ex As Exception
            ' Handle the exception.
            lErrorText = "Error creating a polling timer: " & ex.Message
            mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)

         End Try
      End If

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, reset the return value...
         lReturn = False
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function IsValidConnection(ByVal TestConnString As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Tests the connection to the Accounting database.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing
      Dim lReturn As Boolean

      ' Assume the connection will succeed.
      lReturn = True

      ' Connect and retrieve the database version...
      Try
         lSDA = New SqlDataAccess(TestConnString, False)
         lDT = lSDA.CreateDataTable("SELECT @@Version")

      Catch ex As Exception
         ' Error connecting, reset return value.
         lReturn = False

      Finally
         ' Cleanup...
         If lDT IsNot Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If

         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

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
         lSDA = New SqlDataAccess(mConnectCasino, False, 90)

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

      Catch ex As Exception
         ' Handle the exception, build the error text and write it to the EventLog...
         lErrorText = "Startup::RecordAppVersion error: " & ex.Message
         EventLog.WriteEntry(lErrorText, EventLogEntryType.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Sub TimerElapsed(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs)
      '--------------------------------------------------------------------------------
      ' Elapsed event handler for the polling timer object.
      '--------------------------------------------------------------------------------

      ' Is the worker thread is already running?
      If mWorkerThread IsNot Nothing AndAlso mWorkerThread.ThreadState = ThreadState.Running Then
         ' Yes, so exit this routine.
         Exit Sub
      Else
         ' Execute the CheckPromoScheduling routine on a separate thread.
         mWorkerThread = New Thread(AddressOf CheckPromoScheduling)
         With mWorkerThread
            .Name = "PromoScheduleThread"
            .Priority = ThreadPriority.Normal
            .Start()
         End With
      End If

   End Sub

   Private Sub CheckPromoScheduling()
      '--------------------------------------------------------------------------------
      ' Routine that checks the database to see if promo printing should be toggled
      ' on or off.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable

      Dim lStopWatch As Stopwatch

      Dim lErrorText As String
      Dim lColumnName As String
      Dim lMessageText As String
      Dim lSQL As String
      Dim lTPServer As String
      Dim lTPServerList As String
      Dim lTransText As String

      Dim lTPList() As String
      Dim lTPServerData() As String

      Dim lPromoScheduleID As Integer
      Dim lTPPort As Integer

      Dim lToggleOn As Boolean
      Dim lToggleOff As Boolean

      ' Increment the number of times this routine has been called (and prevent overflow)...
      mCount += 1
      If mCount = Long.MaxValue Then mCount = 1

      Try
         ' Instantiate a new data access object.
         lSDA = New SqlDataAccess(mConnectCasino, True)

         ' Execute sp to retrieve the promo scheduling info...
         lDT = lSDA.CreateDataTableSP("GetPromoTicketStatus", "PromoScheduleInfo")

         ' We expect 1 row back from sp GetPromoTicketStatus.
         If lDT.Rows.Count < 1 Then
            ' No rows returned.
            mEventLog.WriteEntry("GetPromoTicketStatus returned zero rows.", EventLogEntryType.Information)
         Else
            ' Store data returned from sp into local vars...
            With lDT.Rows(0)
               lPromoScheduleID = .Item("PromoScheduleID")
               lToggleOn = .Item("ToggleOn")
               lToggleOff = .Item("ToggleOff")
            End With

            ' If PromoScheduleID > 0 then we need to build and send a message...
            If lPromoScheduleID > 0 Then
               ' Set the transaction text...
               If lToggleOn Then
                  lTransText = "EntryTicketOn"
               Else
                  lTransText = "EntryTicketOff"
               End If

               ' Build the entire message that will be sent to the TP.
               lMessageText = String.Format("{0},Z,{1:yyyy-MM-dd HH:mm:ss},{2}{3}", mCount, DateTime.Now, lTransText, mCrLf)

               ' Log message about to be sent.
               mEventLog.WriteEntry(String.Format("About to send {0} transaction to TP.", lTransText), EventLogEntryType.Information)

               ' Store the TP Server or Servers.
               lTPServerList = My.Settings.TPServerList

               Try
                  ' Try and log the TP Server list.
                  mEventLog.WriteEntry("TPServerList: " & lTPServerList)
               Catch ex As Exception
                  ' Ignore any error.
               End Try

               lTPList = lTPServerList.Split(",".ToCharArray)
               Try
                  ' Try to log the number of entries in the TP Server list.
                  mEventLog.WriteEntry("TPServerList count: " & lTPList.Length.ToString)
               Catch ex As Exception
                  ' Ignore any error.
               End Try

               ' Send a message to each TP...
               For Each lTPServer In lTPList
                  ' Connect to the TP (or TPs), send the message, then disconnect...
                  lTPServerData = lTPServer.Split(":".ToCharArray)
                  lTPServer = lTPServerData(0)

                  If Integer.TryParse(lTPServerData(1), lTPPort) Then
                     mNetworkClient.Connect(lTPServer, lTPPort)

                     ' Wait until connected or for 10 seconds, whichever occurs first...
                     lStopWatch = Stopwatch.StartNew
                     Do Until mNetworkClient.SocketConnected Or lStopWatch.ElapsedMilliseconds > 10000
                     Loop
                     lStopWatch.Stop()

                     ' Are we connected to the TP?
                     If mNetworkClient.SocketConnected Then
                        ' Yes, so send the message.

                        ' Set tp message (message text received from the TP) to an empty string.
                        mTPMessage = ""

                        ' Send the message.
                        mNetworkClient.Send(lMessageText)
                        mEventLog.WriteEntry("Sent: " & lTransText, EventLogEntryType.Information)

                        ' Wait for a reply...
                        lStopWatch = Stopwatch.StartNew
                        Do Until mTPMessage.Length > 0 Or lStopWatch.ElapsedMilliseconds > 10000
                           Thread.Sleep(200)
                        Loop
                        lStopWatch.Stop()

                        If mTPMessage.Length > 0 Then
                           mEventLog.WriteEntry("Received from TP: " & mTPMessage)
                        Else
                           mEventLog.WriteEntry("No text received from TP.")
                        End If

                        ' Now disconnect from the TP.
                        mNetworkClient.Disconnect()
                     Else
                        mEventLog.WriteEntry("Failed to connect to TP.", EventLogEntryType.Error)
                     End If
                  Else
                     ' Log port conversion error.
                     mEventLog.WriteEntry("Failed to convert Port setting to an integer value.")
                  End If
               Next

               ' Message was sent, build an update statement.
               If lToggleOn Then
                  lColumnName = "PromoStarted"
               Else
                  lColumnName = "PromoEnded"
               End If
               lSQL = String.Format("UPDATE PROMO_SCHEDULE SET {0} = 1 WHERE PromoScheduleID = {1}", lColumnName, lPromoScheduleID)

               ' Perform the update.
               lSDA.ExecuteSQLNoReturn(lSQL)
               mEventLog.WriteEntry("Table updated: " & lSQL, EventLogEntryType.Information)

               ' Now, update column CASINO.PRINT_PROMO_TICKETS...
               lSDA.AddParameter("@PrintPromoValue", SqlDbType.Bit, lToggleOn)
               lSDA.ExecuteProcedureNoResult("tpcSetPrintPromo")
               mEventLog.WriteEntry(String.Format("CASINO.PRINT_PROMO_TICKETS turned {0}.", lTransText.Substring(11)), EventLogEntryType.Information)
            Else
               ' Nothing to do, does config indicate we should log the event?
               If mLogWhenNothingToDo Then
                  ' Yes, so record the event.
                  mEventLog.WriteEntry("CheckPromoScheduling - nothing to do.", EventLogEntryType.Information)
               End If
            End If
         End If

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = mServiceName & "::CheckPromoScheduling error: " & ex.Message
         mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)

      Finally
         ' Cleanup.
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
      End Try

   End Sub

   Private Sub mNetworkClient_Connected() Handles mNetworkClient.Connected
      '--------------------------------------------------------------------------------
      ' Connected event handler for the NetworkClient
      '--------------------------------------------------------------------------------

      mEventLog.WriteEntry("Network Client connected.", EventLogEntryType.Information)
      mNetworkClient.Receive()

   End Sub

   Private Sub mNetworkClient_DataReceived(ByVal aData As String) Handles mNetworkClient.DataReceived
      '--------------------------------------------------------------------------------
      ' DataReceived event handler for the NetworkClient
      '--------------------------------------------------------------------------------

      ' Store last received message in mTPMessage.
      mTPMessage = aData
      mEventLog.WriteEntry("Network Client DataReceived: " & aData, EventLogEntryType.Information)

   End Sub

   Private Sub mNetworkClient_Disconnected() Handles mNetworkClient.Disconnected
      '--------------------------------------------------------------------------------
      ' Disconnected event handler for the NetworkClient
      '--------------------------------------------------------------------------------

      mEventLog.WriteEntry("Network Client Disconnected.", EventLogEntryType.Information)

   End Sub

   Private Sub mNetworkClient_NetClientError(ByVal aErrorText As String) Handles mNetworkClient.NetClientError
      '--------------------------------------------------------------------------------
      ' NetClientError event handler for the NetworkClient
      '--------------------------------------------------------------------------------

      mEventLog.WriteEntry("Network Client error: " & aErrorText, EventLogEntryType.Error)

   End Sub

   Private Sub mNetworkClient_Sent(ByVal aMessageText As String) Handles mNetworkClient.Sent
      '--------------------------------------------------------------------------------
      ' Sent event handler for the NetworkClient
      '--------------------------------------------------------------------------------

      mEventLog.WriteEntry("Network Client Sent: " & aMessageText, EventLogEntryType.Information)

   End Sub

End Class
