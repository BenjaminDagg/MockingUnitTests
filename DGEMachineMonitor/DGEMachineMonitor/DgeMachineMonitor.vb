Imports System.IO
Imports System.Net.Mail
Imports System.Threading

Public Class DgeMachineMonitor

   ' [Private variable declarations]
   Private mEventLog As EventLog

   Private mPollTimer As System.Timers.Timer

   Private mWorkerThread As Thread

   Private mCrLf As String = Environment.NewLine
   Private mDbConnect As String
   Private mServiceName As String ' = "DGE Machine Monitor"

   Private mPollInterval As Double

   Protected Overrides Sub OnStart(ByVal args() As String)
      '--------------------------------------------------------------------------------
      ' OnStart routine - called when service starts
      '--------------------------------------------------------------------------------

      ' Turn off automatic logging of Start, Stop, Pause, and Continue events.
      Me.AutoLog = False

      ' Store the service name.  Note: The Service Name is set by showing Properties
      ' for the DgeMachineMonitor.vb Designer and setting the ServiceName property.
      mServiceName = Me.ServiceName

      ' Set the service name and set it as the eventlog source...
      mEventLog = New EventLog("Application")
      mEventLog.Source = mServiceName

      ' Log Start event...
      mEventLog.WriteEntry(mServiceName & " starting.", EventLogEntryType.Information, 1000)

      ' Authenticate this app...
      If System.Diagnostics.Debugger.IsAttached = True OrElse AuthenticateApp() = True Then
         ' Either in debug mode or authentication was successful, log it.
         mEventLog.WriteEntry("Application authentication was successful.", EventLogEntryType.Information, 1000)

         ' Call function to initialize this service.
         If InitializeThisService() Then
            ' Write application version information to APP_INFO table.
            Call RecordAppVersion()

            ' Start the routine to check machine status info on a new thread...
            mWorkerThread = New Thread(AddressOf MonitorEGMs)
            With mWorkerThread
               .Name = "MonitorEGMsThread"
               .Priority = ThreadPriority.Normal
               .Start()
            End With
         Else
            ' Errors encountered in initialization routine, stop the service.
            Throw New Exception("Application Initialization failed.")
         End If
      Else
         ' Authentication failed, log and throw it to stop the service...
         mEventLog.WriteEntry("Application authorization failed.", EventLogEntryType.Error)
         Throw New Exception("Application failed authenticationi.")
      End If

   End Sub

   Protected Overrides Sub OnPause()
      '--------------------------------------------------------------------------------
      ' OnPause routine - called when this service application is paused.
      '--------------------------------------------------------------------------------

      Try
         ' Log Pause event, then call base routine...
         mEventLog.WriteEntry(mServiceName & " pausing.", EventLogEntryType.Information, 1002)
         MyBase.OnPause()

      Catch ex As Exception
         ' Handle the exception...
         Debug.WriteLine("OnPause error: " & ex.Message)

      End Try

   End Sub

   Protected Overrides Sub OnContinue()
      '--------------------------------------------------------------------------------
      ' OnContinue routine - called when this service application is restarted after
      ' having been paused.
      '--------------------------------------------------------------------------------

      Try
         ' Log Continue event, then call base routine...
         mEventLog.WriteEntry(mServiceName & " continuing.", EventLogEntryType.Information, 1003)
         MyBase.OnContinue()

      Catch ex As Exception
         ' Handle the exception...
         Debug.WriteLine("OnContinue error: " & ex.Message)

      End Try

   End Sub

   Protected Overrides Sub OnShutdown()
      '--------------------------------------------------------------------------------
      ' OnShutdown routine - called when this service application is about to stop
      ' because the system is shutting down.
      '--------------------------------------------------------------------------------

      Try
         mEventLog.WriteEntry(mServiceName & " stopping for system shutdown.", EventLogEntryType.Information, 9998)

      Catch ex As Exception
         ' Handle the exception...
         Debug.WriteLine("OnShutdown error: " & ex.Message)

      End Try

   End Sub

   Protected Overrides Sub OnStop()
      '--------------------------------------------------------------------------------
      ' OnStop routine - called when this service application is about to stop.
      '--------------------------------------------------------------------------------

      Try
         ' Log stopping event...
         mEventLog.WriteEntry(mServiceName & " stopping.", EventLogEntryType.Information, 1001)
         mEventLog.Dispose()
         mEventLog = Nothing

      Catch ex As Exception
         ' Handle the exception...
         Debug.WriteLine("OnStop error: " & ex.Message)

      End Try

   End Sub

   Private Function AuthenticateApp() As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluate hash of app exe
      ' Return T/F
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSHA1 As DGE.SHA1Cryptography
      Dim lHashDigest() As Byte
      Dim lStaticDigest() As Byte

      ' Dim lAuthRequired As Boolean = False
      Dim lReturn As Boolean = False

      Dim lAppPath As String = My.Application.Info.DirectoryPath
      Dim lErrorText As String = ""
      Dim lHashText As String
      Dim lMsgDigest As String
      Dim lSourceFiles(2) As String
      Dim lTestText As String


      ' Store the fully qualified filename of the message digest file that will be used for comparison.
      lMsgDigest = Path.Combine(lAppPath, "mmMsgDigest.dat")

      '' Is application authorization required?
      'If lAuthRequired Then
      ' Yes, so populate the source file array with fully qualified filenames to check...
      lSourceFiles = My.Settings.AppAuthList.Split(",".ToCharArray)

      ' Build fully qualified filenames.
      For lIndex As Integer = 0 To lSourceFiles.GetUpperBound(0)
         lSourceFiles(lIndex) = Path.Combine(lAppPath, lSourceFiles(lIndex))
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
            lErrorText = "DgeMachineMonitor::AuthenticateApp error: " & ex.Message
            lReturn = False

         End Try
      End If

      ' If there is error text, show it...
      If String.IsNullOrEmpty(lErrorText) = False Then
         mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)
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
      Dim lLogText As String = ""
      Dim lPassword As String
      Dim lUID As String
      Dim lValue As String

      Try
         ' Write a log entry
         lLogText = String.Format("{0} initializing.{1}", mServiceName, mCrLf)

         ' Retrieve application settings...
         With My.Settings
            ' Build casino connection string...
            lUID = .ConnectUID
            lPassword = lAPE.DecryptPassword(.ConnectKey)
            lValue = .DbConnect
            mDbConnect = String.Format(lValue, lUID, lPassword)

            ' Retrieve polling interval and multipy by 60000 (to convert minutes to milliseconds)
            lPollingFreqMinutes = .PollMinutes
            mPollInterval = lPollingFreqMinutes * 60000

            ' Add the polling frequency to the log text.
            lLogText &= String.Format("Polling Frequency set to {0} minute(s).{1}", lPollingFreqMinutes, mCrLf)
         End With

         Try
            ' Test the eTab database connection...
            lConnString = mDbConnect
            If IsValidConnection(lConnString) Then
               lLogText &= String.Format("Database connection successful.{0}", mCrLf)
            Else
               lErrorText = "Cannot connect to the database."
            End If

         Catch ex As Exception
            ' Handle the error.
            lErrorText = "Error verifying database connection: " & ex.Message

         End Try

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = "Error initializing app settings - " & ex.Message

      End Try

      If lErrorText.Length = 0 Then
         Try
            ' Init and start the polling timer...
            mPollTimer = New System.Timers.Timer()
            AddHandler mPollTimer.Elapsed, AddressOf Me.TimerElapsed
            With mPollTimer
               .Interval = mPollInterval
               .AutoReset = True
               .Enabled = True
               .Start()
            End With

            ' Add timer status to the log text.
            lLogText &= String.Format("Polling timer successfully initialized.{0}", mCrLf)

         Catch ex As Exception
            ' Handle the exception.
            lErrorText = "Error creating a polling timer: " & ex.Message

         End Try
      End If

      ' Any error text?
      If lErrorText.Length = 0 Then
         ' Log initialization results.
         mEventLog.WriteEntry(lLogText, EventLogEntryType.Information, 1000)
      Else
         ' An error occurred, reset the return value.
         lReturn = False

         ' Log the error.
         mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)
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
      Dim lDT As DataTable

      Dim lTableCount As Integer

      Dim lErrorText As String
      Dim lSQL As String


      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(mDbConnect, True, 120)

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
         mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)

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

      ' mEventLog.WriteEntry("TimerElapsed has been called.", EventLogEntryType.Information, 2000)

      ' Is the worker thread is already running?
      If mWorkerThread IsNot Nothing AndAlso mWorkerThread.ThreadState = ThreadState.Running Then
         ' Yes, so exit this routine.
         ' mEventLog.WriteEntry("Exiting TimerElapsed.", EventLogEntryType.Information, 2000)
         Exit Sub
      Else
         ' Execute the MonitorEGMs routine on a separate thread.
         ' mEventLog.WriteEntry("TimerElapsed starting new thread.", EventLogEntryType.Information, 2000)
         mWorkerThread = New Thread(AddressOf MonitorEGMs)
         With mWorkerThread
            .Name = "MonitorEGMsThread"
            .Priority = ThreadPriority.Normal
            .Start()
         End With
      End If

   End Sub

   Private Sub MonitorEGMs()
      '--------------------------------------------------------------------------------
      ' This routine does the work of monitoring the EGMs and sending notifications
      ' when appropriate.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lTimeSpan As TimeSpan

      Dim lIncludeInNotification As Boolean
      Dim lVoucherPrinting As Boolean

      Dim lNotifyCount As Integer = 0
      Dim lLocationID As Integer
      Dim lNotifyAfterMinutes As Integer = My.Settings.NotifyAfterMinutes

      Dim lActiveFlag As Short
      Dim lStatusType As Short

      Dim lCurrentTime As DateTime = DateTime.Now
      Dim lLastConnectDT As DateTime
      Dim lLastDisconnectDT As DateTime
      Dim lPSChangedDT As DateTime

      Dim lCMNumber As String
      Dim lErrorText As String
      Dim lGameCode As String
      Dim lLastConnected As String
      Dim lLastDisconnected As String
      Dim lLocationName As String
      Dim lMachineNbr As String
      Dim lModelDesc As String
      Dim lMsgTemplate As String
      Dim lNotificationText As String = ""
      Dim lPlayStatusChanged As String
      Dim lStatusText As String

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(mDbConnect, False, 90)

         ' Add parameter to exclude Online machines.
         lSDA.AddParameter("@IncludeOnlineMachines", SqlDbType.Bit, False)

         ' Retrieve machine status info.
         lDT = lSDA.CreateDataTableSP("mmMachineStatus", "MachineStatus")

         ' Build the notification message template.
         lMsgTemplate = "Location: {0} - {1}<br>Machine: {2}<br>Game: {3} - {4}<br>Status: <b>{5}</b><br>Location Machine Number: {6}<br>Active Flag: {7}<br>Voucher Printing: {8}<br>Last Connected: {9}<br>Last Disconnected: {10}<br>PlayStatus Changed: {11}<br><br>"

         ' Process any returned rows...
         For Each lDR In lDT.Rows
            ' Default notification inclusion to False.
            lIncludeInNotification = False

            ' Store the Status Type.
            With lDR
               lStatusType = .Item("STATUS_TYPE")
               If IsDBNull(.Item("LAST_CONNECT")) = False Then
                  lLastConnectDT = .Item("LAST_CONNECT")
               Else
                  lLastConnectDT = DateTime.MinValue
               End If

               If IsDBNull(.Item("LAST_DISCONNECT")) = False Then
                  lLastDisconnectDT = .Item("LAST_DISCONNECT")
               Else
                  lLastDisconnectDT = DateTime.MinValue
               End If

               If IsDBNull(.Item("PLAY_STATUS_CHANGED")) = False Then
                  lPSChangedDT = .Item("PLAY_STATUS_CHANGED")
               Else
                  lPSChangedDT = DateTime.MinValue
               End If
            End With

            ' Evaluate based on Status Type.
            Select Case lStatusType
               Case 1
                  ' Disconnected from Server. Store last disconnect and get disconnected timespan...
                  lTimeSpan = lCurrentTime.Subtract(lLastDisconnectDT)

                  ' Set notification flag if the number of minutes disconnected > the NotifyAfterMinutes value.
                  lIncludeInNotification = (lTimeSpan.TotalMinutes >= lNotifyAfterMinutes)

               Case 2
                  ' Connected but not playable. 
                  If IsDBNull(lDR.Item("PLAY_STATUS_CHANGED")) Then
                     ' Column value is null, include in notification.
                     lIncludeInNotification = True
                  Else
                     ' Get unplayable timespan...
                     lTimeSpan = lCurrentTime.Subtract(lPSChangedDT)

                     ' Set notification flag if the number of minutes non-playable > the NotifyAfterMinutes value.
                     lIncludeInNotification = (lTimeSpan.TotalMinutes >= lNotifyAfterMinutes)
                  End If

                  'Case 3
                  ' Never Connected to Server, ignore for now.

            End Select

            ' Include in notification message?
            If lIncludeInNotification Then
               ' Increment notification count.
               lNotifyCount += 1

               ' Store column values in local variables...
               With lDR
                  lLocationID = .Item("LOCATION_ID")
                  lLocationName = .Item("LOCATION_NAME")
                  lCMNumber = .Item("CASINO_MACH_NO")
                  lGameCode = .Item("GAME_CODE")
                  lMachineNbr = .Item("MACH_NO")
                  lModelDesc = .Item("MODEL_DESC")
                  lStatusText = .Item("STATUS_TEXT")
                  lActiveFlag = .Item("ACTIVE_FLAG")
                  lVoucherPrinting = .Item("VOUCHER_PRINTING")

                  ' Set Last Connected text.
                  If Not IsDBNull(.Item("LAST_CONNECT")) Then
                     lLastConnected = String.Format("{0:yyyy-MM-dd hh:mm:ss}", lLastConnectDT)
                     ' lLastConnected = .Item("LAST_CONNECT").ToString("yyyy-MM-dd hh:mm:ss")
                  Else
                     lLastConnected = "<null>"
                  End If

                  ' Set Last Disconnected text.
                  If Not IsDBNull(.Item("LAST_DISCONNECT")) Then
                     lLastDisconnected = String.Format("{0:yyyy-MM-dd hh:mm:ss}", lLastDisconnectDT)
                  Else
                     lLastDisconnected = "<null>"
                  End If

                  ' Set Last Play Status Changed text.
                  If Not IsDBNull(.Item("PLAY_STATUS_CHANGED")) Then
                     lPlayStatusChanged = String.Format("{0:yyyy-MM-dd hh:mm:ss}", lPSChangedDT)
                  Else
                     lPlayStatusChanged = "<null>"
                  End If

               End With

               ' Build the notification text...
               lNotificationText &= String.Format(lMsgTemplate, lLocationID, lLocationName, lMachineNbr, _
                                                  lGameCode, lModelDesc, lStatusText, lCMNumber, _
                                                  lActiveFlag, lVoucherPrinting, lLastConnected, _
                                                  lLastDisconnected, lPlayStatusChanged)
            End If
         Next

         ' Columns returned from sp mmMachineStatus (* denotes inclusion in notification text):

         ' *LOCATION_ID, *LOCATION_NAME, *MACH_NO, *CASINO_MACH_NO, *MODEL_DESC, *GAME_CODE,
         ' *ACTIVE_FLAG, PLAY_STATUS, *PLAY_STATUS_CHANGED, *LAST_CONNECT, *LAST_DISCONNECT,
         ' IP_ADDRESS, BALANCE, MACH_SERIAL_NO, *VOUCHER_PRINTING, REMOVED_FLAG, STATUS_TYPE, *STATUS_TEXT

         ' Is notification required?
         If lNotifyCount > 0 Then
            ' Yes, so add html formatting and then attempt to email it...
            lNotificationText = String.Format("<p style='font-family:courier;font-size:8pt'>{0}</p>", lNotificationText)
            Call SendNotification(lNotificationText)

            ' Log number of machines included in the notification...
            If lNotifyCount = 1 Then
               lStatusText = "Notification sent for 1 EGM."
            Else
               lStatusText = String.Format("Notification sent for {0} EGM(s).", lNotifyCount)
            End If
            mEventLog.WriteEntry(lStatusText, EventLogEntryType.Information)
         Else
            ' If config setting for loging 'Nothing To Do' is true, write the entry.
            If My.Settings.LogNTD = True Then mEventLog.WriteEntry("Notification not required.", EventLogEntryType.Information)
         End If

      Catch ex As Exception
         ' Build the error text and write it to the system application event log...
         lErrorText = "MonitorEGMs error: " & ex.Message
         mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Sub SendNotification(ByRef eMailMessage As String)
      '--------------------------------------------------------------------------------
      ' This routine does the work of sending email notifications.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSmtpServer As SmtpClient
      Dim lMailMessage As MailMessage

      Dim lAPE As AppPasswordEncryption

      Dim lUseSMTPCredentials As Boolean

      Dim lErrorText As String
      Dim lSendToList As String
      Dim lSendToName As String
      Dim lSmtpPWD As String

      Try
         ' Create a new MailMessage object.
         lMailMessage = New MailMessage()

         ' Set From property indicating who is sending the Email message.
         lMailMessage.From = New MailAddress(My.Settings.eMailFrom)

         ' Add each Email receipient name to the To mailaddress collection...
         lSendToList = My.Settings.eMailList
         For Each lSendToName In lSendToList.Split(";".ToCharArray)
            lMailMessage.To.Add(New MailAddress(lSendToName))
         Next

         ' Set MailMessage properties...
         With lMailMessage
            .Priority = MailPriority.High
            .Subject = "DGE Machine Monitor Information"
            .IsBodyHtml = True
            .Body = eMailMessage
         End With

         ' Instantiate a new SmtpClient object.
         lSmtpServer = New SmtpClient(My.Settings.SMTPServerName)

         ' Store config setting indicating if SMTP Credentials (UID and PWD) are required.
         lUseSMTPCredentials = My.Settings.UseSMTPCredentials

         ' Is a UserID and Password required in order to send eMail?
         If lUseSMTPCredentials Then
            ' Yes, so decrypt the SMTPPassword value from the config file.
            lAPE = New AppPasswordEncryption()
            lSmtpPWD = lAPE.DecryptPassword(My.Settings.SMTPPassword)

            ' Supply credentials.
            lSmtpServer.Credentials = New System.Net.NetworkCredential(My.Settings.SMTPUserName, lSmtpPWD)
         Else
            ' No, so use default credentials.
            lSmtpServer.UseDefaultCredentials = True
         End If

         ' Send the eMail message.
         lSmtpServer.Send(lMailMessage)

      Catch ex As Exception
         ' Handle the exception.
         ' Build the error text and write it to the system application event log...
         lErrorText = mServiceName & "::SendNotification error: " & ex.ToString
         mEventLog.WriteEntry(lErrorText, EventLogEntryType.Error)

      End Try

   End Sub

End Class
