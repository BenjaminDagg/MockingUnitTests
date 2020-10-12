Option Explicit On
Option Strict On

Imports Communication
Imports DataAccess
Imports System
Imports System.Collections
Imports System.Diagnostics
Imports System.Text
Imports System.Collections.Generic

Public Class Machine
   Inherits PlayerTerminal

   ' Variables
   Private mCrLf As String = Environment.NewLine
   Private mLastMessage As Hashtable
   Private mLastTransType As String
   Private mMessage As Message
   Private mPingFlag As Boolean = False
   Private mPingResponseTimer As Timers.Timer
   Private mPingTimer As Timers.Timer
   Private mProcessRxBuffer As Boolean = False
   Private mRxBuffer As New StringBuilder
   Private mRxCount As Int32
   Private mStatus As Int32
   Private mTpiClient As TpiClient
   Private mTxCount As Int32

   ' Delegates
   Private Delegate Sub HandleMessageDelegate(ByVal MessageHash As Hashtable)

   ' Properties
   Public ReadOnly Property LastTransType() As String
      Get
         Return mLastTransType
      End Get
   End Property

   Public Property RxCount() As Int32
      Get
         Return mRxCount
      End Get
      Set(ByVal Value As Int32)
         mRxCount = Value
      End Set
   End Property

   Public Property Status() As Int32
      Get
         Return mStatus
      End Get
      Set(ByVal Value As Int32)
         mStatus = Value
      End Set
   End Property

   Public Property TxCount() As Int32
      Get
         Return mTxCount
      End Get
      Set(ByVal Value As Int32)
         mTxCount = Value
      End Set
   End Property

   Public Overrides Sub Start()
      '--------------------------------------------------------------------------------
      ' Start Subroutine for this class.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lMachineNumber As String = MyBase.MachineNumber


      Try
         ' Write connected message to the log file.
         Trace.WriteLine(FormatLogOutput("(Machine: " & lMachineNumber & ") Connected. Machine::Start"))

         ' Record the connection...
         Try
            lDB = New Database(gConnectionString)
            With lDB
               ' Add Machine Number and Status Type (1 for connected)...
               .AddParameter("@MachineNumber", lMachineNumber)
               .AddParameter("@StatusType", "1")

               ' Execute the stored procedure
               .ExecuteProcedure("[RecordMachineConnection]")
            End With

         Catch ex As Exception
            ' Log failure if at TraceError level...
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine " & lMachineNumber & ") Failed to record last connection to database: " & ex.Message))
            End If

         Finally
            ' Cleanup
            lDB.Dispose()
            lDB = Nothing

         End Try

         ' Setup the TpiClient.
         mTpiClient = CType(Activator.CreateInstance(MyBase.TpiClientType), TpiClient)
         AddHandler mTpiClient.ShutdownMachine, AddressOf Me.Shutdown
         AddHandler mTpiClient.ReadyForTP, AddressOf TpiClient_ReadyForTP

         ' change for MGAM
         AddHandler mTpiClient.RequestATrans, AddressOf Me.RequestATrans
         AddHandler mTpiClient.ReadyToPlay, AddressOf Me.MachineReadyToPlay
         AddHandler mTpiClient.ComputeChecksum, AddressOf Me.MachineComputeChecksum
         AddHandler mTpiClient.ShowMessage, AddressOf Me.MachineShowMessage
         AddHandler mTpiClient.RebootMachine, AddressOf Me.MachineReboot
         AddHandler mTpiClient.StartupMachine, AddressOf Me.Startup
         AddHandler mTpiClient.NotifyProgressiveMachines, AddressOf Me.NotifyProgressiveMachines

         ' end change for MGAM

         mTpiClient.Machine = Me
         mTpiClient.ConnectionString = MyBase.ConnectionString
         mTpiClient.TraceSwitch = MyBase.TraceSwitch
         'mTpiClient.Startup()

         ' Setup the ping timer.
         mPingTimer = New Timers.Timer
         AddHandler mPingTimer.Elapsed, AddressOf PingTimer_Elapsed

         With mPingTimer
            ' Setup the Ping Timer for the "A" trans.
            .Interval = MyBase.PingTimer * 1000
            .AutoReset = True
            .Start()
         End With

         ' Setup the ping response timer.
         mPingResponseTimer = New Timers.Timer
         AddHandler mPingResponseTimer.Elapsed, AddressOf PingResponseTimer_Elapsed

         mMessage = New Message
         AddHandler mMessage.MessageError, AddressOf Message_MessageError
         AddHandler mMessage.MessageForClient, AddressOf Message_MessageForClient

         ' Setup the event handlers and start reading data from the socket.
         AddHandler MyBase.TcpClient.ReadComplete, AddressOf TcpClient_ReadComplete
         AddHandler MyBase.TcpClient.WriteComplete, AddressOf TcpClient_WriteComplete
         AddHandler MyBase.TcpClient.CloseComplete, AddressOf TcpClient_CloseComplete
         AddHandler MyBase.TcpClient.AsyncReadError, AddressOf TcpClient_AsyncReadError
         AddHandler MyBase.TcpClient.AsyncWriteError, AddressOf TcpClient_AsyncWriteError
         MyBase.TcpClient.Read()

         mTpiClient.Startup()

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(Machine: " & lMachineNumber & ") Error: " & ex.ToString))
         Throw New Exception(ex.ToString)

      End Try

   End Sub

   Private Sub Message_MessageError(ByVal ErrorMessage As String)
      Try
         If MyBase.TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error: " & ErrorMessage))

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error: " & ex.ToString))

      End Try

   End Sub

   Private Sub Message_MessageForClient(ByVal Message As String)
      Try
         ' Send the message.
         TcpClient.Write(Message)

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error: " & ex.ToString))

      End Try

   End Sub

   Private Sub PingTimer_Elapsed(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs)
      '--------------------------------------------------------------------------------
      ' Routine to handle the PingTimer Elapsed event.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      mPingFlag = True
      Try
         With mPingResponseTimer
            ' If the PingResponseTimer was already running from a previous start, stop it first.
            .Stop()
            ' Start the timer
            .Interval = MyBase.PingResponseTimer * 1000
            .AutoReset = False
            .Start()
         End With

         ' Build the status message
         With lSB
            .Append(CType(mTxCount + 1, String))
            .Append(",A,")
            .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
            .Append(",Status").Append(mCrLf)
         End With

         If MyBase.TraceSwitch.TraceVerbose Then _
             Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Machine::PingTimer_Elapsed sending: " & lSB.ToString))

         ' Send a status request
         If TcpClient.Socket.Connected Then
            TcpClient.Write(lSB.ToString)
         Else
            If MyBase.TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Socket is no longer open (PingTimer_Elapsed)."))
         End If

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error: " & ex.ToString))

      End Try

   End Sub

   Private Sub PingResponseTimer_Elapsed(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs)

      Try
         If mPingFlag Then
            ' No response to ping, shutdown the socket.
            TcpClient.Close()
         End If

         ' Release the resources that this timer uses
         mPingResponseTimer.Close()

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error: " & ex.ToString))

      End Try

   End Sub

   Private Sub TpiClient_ReadyForTP(ByVal ResponseHash As Hashtable)

      Try
         mLastMessage = ResponseHash

         If Math.Abs(CType(ResponseHash("ShutDownFlag"), Int32)) = 1 Then
            mStatus = 1
            Me.ActiveFlag = 0
         ElseIf Math.Abs(CType(ResponseHash("ShutDownFlag"), Int32)) = 0 Then
            mStatus = 0
            Me.ActiveFlag = 1
         End If

         SyncLock TcpClient
            TcpClient.Write(mMessage.GenerateMessage(ResponseHash))
         End SyncLock

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::TpiClient_ReadyForTP: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub TcpClient_ReadComplete(ByVal sender As Object, ByVal e As CommEventArgs)

      Try
         mRxBuffer.Append(e.RxData)
         ProcessRxBuffer()

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::TcpClient_ReadComplete: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub TcpClient_WriteComplete(ByVal sender As Object, ByVal e As CommEventArgs)

      Try
         ' Increment the sent count.
         mTxCount += 1

         ' Write to log file what was sent.

         ' For a "A" ,"Z", or ProgressivePools messages, write the "Sent: " message to the Log File only if TraceLevel= TraceVerbose
         ' but only if its not an A Reboot or Z RebootMachine.
         If (e.TxData.Contains(",A,") AndAlso Not e.TxData.Contains("Reboot")) OrElse (e.TxData.Contains(",Z,") AndAlso Not e.TxData.Contains("RebootMachine")) OrElse e.TxData.Contains(",ProgressivePools,") Then
            If MyBase.TraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Sent: " & e.TxData))
         Else
            ' Write "Sent:" message for all other Trans Types only if TraceLevel = TraceWarning.
            If MyBase.TraceSwitch.TraceWarning Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Sent: " & e.TxData))
         End If

         ' Check if a Drop took place, CASINO.AUTO_DROP = 1 and MACH_SETUP.REBOOT_AFTER_DROP = 1.
         If e.TxData.Contains(",D,") AndAlso Me.AutoDrop = 1 AndAlso MyBase.RebootAfterDrop = 1 Then
            Call MachineReboot(306, "Transaction Portal Control reboot initiated.")
         End If

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::TcpClient_WriteComplete: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub CleanUp()
      '--------------------------------------------------------------------------------
      ' Clean up Event Handler
      '--------------------------------------------------------------------------------
      Try
         If mTpiClient IsNot Nothing Then

            RemoveHandler mTpiClient.ShutdownMachine, AddressOf Me.Shutdown
            RemoveHandler mTpiClient.ReadyForTP, AddressOf TpiClient_ReadyForTP

            RemoveHandler mTpiClient.RequestATrans, AddressOf Me.RequestATrans
            RemoveHandler mTpiClient.ReadyToPlay, AddressOf Me.MachineReadyToPlay
            RemoveHandler mTpiClient.ComputeChecksum, AddressOf Me.MachineComputeChecksum
            RemoveHandler mTpiClient.ShowMessage, AddressOf Me.MachineShowMessage
            RemoveHandler mTpiClient.RebootMachine, AddressOf Me.MachineReboot
            RemoveHandler mTpiClient.StartupMachine, AddressOf Me.Startup


            RemoveHandler mPingTimer.Elapsed, AddressOf PingTimer_Elapsed
            RemoveHandler mPingResponseTimer.Elapsed, AddressOf PingResponseTimer_Elapsed
            RemoveHandler mMessage.MessageError, AddressOf Message_MessageError
            RemoveHandler mMessage.MessageForClient, AddressOf Message_MessageForClient

            ' Setup the event handlers and start reading data from the socket.
            RemoveHandler MyBase.TcpClient.ReadComplete, AddressOf TcpClient_ReadComplete
            RemoveHandler MyBase.TcpClient.WriteComplete, AddressOf TcpClient_WriteComplete
            RemoveHandler MyBase.TcpClient.CloseComplete, AddressOf TcpClient_CloseComplete
            RemoveHandler MyBase.TcpClient.AsyncReadError, AddressOf TcpClient_AsyncReadError
            RemoveHandler MyBase.TcpClient.AsyncWriteError, AddressOf TcpClient_AsyncWriteError

         End If
      Catch ex As Exception
         Trace.WriteLine(FormatLogOutput("Machine::Cleanup Unable to remove one or more event handlers on clean up."))
      End Try

   End Sub

   Private Sub TcpClient_CloseComplete(ByVal sender As Object, ByVal e As CommEventArgs)
      '--------------------------------------------------------------------------------
      ' Event handler for CloseComplete.
      '--------------------------------------------------------------------------------
      ' Allocate local vars.
      Dim lDB As Database = Nothing
      Dim lMachineNumber As String = MyBase.MachineNumber


      Try
         ' Log disconnection to the TP log file.
         If MyBase.TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(Machine: " & lMachineNumber & ") Disconnected."))

         ' Remove entry from the global Machine Hashtable.
         gMachineCollection.Remove(MyBase.IpAddress)

         ' Remove the record for this machine number from gMachineHT also.
         Call RemoveFromMachineDT(lMachineNumber)

         CleanUp()

         ' Record disconnect in MACH_SETUP
         Try
            lDB = New Database(gConnectionString)
            With lDB
               ' Add Machine Number and Status Type (0 for disconnected)...
               .AddParameter("@MachineNumber", lMachineNumber)
               .AddParameter("@StatusType", "0")

               ' Execute the stored procedure
               .ExecuteProcedure("[RecordMachineConnection]")
            End With

         Catch ex As Exception
            ' Log failure if at TraceError level...
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine " & lMachineNumber & ") Failed to record last disconnect to database: " & ex.Message))
            End If

         Finally
            ' Cleanup
            lDB.Dispose()
            lDB = Nothing

         End Try

         ' Change for MGAM : Dispose the client when the machine is powered down.
         mTpiClient.Dispose()
         ' End Change for MGAM

         mPingTimer.Dispose()
         mPingResponseTimer.Dispose()

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & lMachineNumber & ") Error in Machine::TcpClient_CloseComplete: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub TcpClient_AsyncReadError(ByVal sender As Object, ByVal e As CommEventArgs)
      Try

         If MyBase.TcpClient.Socket.Connected Then

            ' Log it
            If MyBase.TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error: " & e.RxAsyncError))

            MyBase.TcpClient.Close()

         End If

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::TcpClient_AsyncReadError: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub TcpClient_AsyncWriteError(ByVal sender As Object, ByVal e As CommEventArgs)
      Try

         If MyBase.TcpClient.Socket.Connected Then
            ' Log it
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error (Machine::TcpClient_AsyncWriteError): " & e.TxAsyncError))
            End If

            MyBase.TcpClient.Close()

         End If

      Catch ex As Exception
         ' Log it.
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::TcpClient_AsyncWriteError: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub ProcessRxBuffer()
      '--------------------------------------------------------------------------------
      ' Event handler for CloseComplete.
      '--------------------------------------------------------------------------------
      ' Allocate local vars.

      ' Any other threads processing the buffer?
      If Not mProcessRxBuffer Then
         Try
            ' Set this so that only one thread is processing the buffer.
            mProcessRxBuffer = True

            ' Proceess the buffer while a carriage return / linefeed combo exists.
            While mRxBuffer.ToString.IndexOf(mCrLf) > 0
               mPingFlag = False
               mPingTimer.Interval = MyBase.PingTimer * 1000

               ' Pull out a complete message from the buffer.
               Dim lMessage As String = mRxBuffer.ToString(0, mRxBuffer.ToString.IndexOf(mCrLf))

               ' For a "A", "Z", "ProgressivePools" messages, write the "Received : " message to the Log File only if TraceLevel= TraceVerbosee
               ' but only if its not an A Reboot or Z RebootMachine.
               If (lMessage.Contains(",A,") AndAlso Not lMessage.Contains("Reboot")) OrElse (lMessage.Contains(",Z,") AndAlso Not lMessage.Contains("RebootMachine")) OrElse lMessage.Contains(",ProgressivePools,") Then
                  If MyBase.TraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Received: " & lMessage))
               Else
                  ' Write "Received:" message for all other Trans Types only if TraceLevel = TraceWarning.
                  If MyBase.TraceSwitch.TraceWarning Then Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Received: " & lMessage))
               End If

               ' Remove the part just pulled out.
               mRxBuffer.Remove(0, mRxBuffer.ToString.IndexOf(mCrLf) + mCrLf.Length)

               ' Increment the received count.
               mRxCount += 1

               ' Parse the message.
               Dim lHashTable As Hashtable = mMessage.ParseMessage(lMessage, MyBase.MachineNumber)

               If lHashTable IsNot Nothing Then
                  If mLastMessage IsNot Nothing AndAlso _
                      (CType(lHashTable("MachineSequence"), Int32) = CType(mLastMessage("MachineSequence"), Int32) AndAlso _
                      CType(lHashTable("TransType"), String) = CType(mLastMessage("TransType"), String)) Then

                     ' This is a duplicate message, resend the last response.
                     SyncLock TcpClient
                        TcpClient.Write(mMessage.GenerateMessage(mLastMessage))
                     End SyncLock
                  Else
                     ' Set the last transaction type.
                     mLastTransType = CType(lHashTable.Item("TransType"), String)

                     Dim lHandleMessageDelegate As New HandleMessageDelegate(AddressOf mTpiClient.HandleMessage)
                     lHandleMessageDelegate.BeginInvoke(lHashTable, Nothing, Nothing)
                  End If
               End If
            End While

         Catch ex As Exception
            ' Log the exception.
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::ProcessRxBuffer: " & ex.ToString))
            End If

         End Try

         mProcessRxBuffer = False

      End If

   End Sub

   Private Sub RemoveFromMachineDT(ByVal aMachineNumber As String)
      '--------------------------------------------------------------------------------
      ' Purpose: Removes the row with specified MACH_NO from gMachineHT.
      ' Called by: TcpClient_CloseComplete
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow = Nothing

      Try
         ' Attempt to find the specified machine number datarow in gMachineHT.
         SyncLock (MyBase.TcpClient)
            If gMachineHT.ContainsKey(aMachineNumber) Then
               gMachineHT.Remove(aMachineNumber)
            End If
            'lDR = gMachineHT.Rows.Find(aMachNo)
            'If lDR IsNot Nothing Then
            '   ' MACH_NO row exists in gMachineHT, so delete it.
            '   lDR.Delete()
            'End If
         End SyncLock

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & aMachineNumber & ") Error in Machine::RemoveFromMachineDT: " & ex.Message))
         End If

      End Try

   End Sub

   Friend Sub RequestSetup()
      Dim lSB As New StringBuilder

      Try
         With lSB
            .Append(CType(mTxCount + 1, String))
            .Append(",A,")
            .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
            .Append(",Setup")
            .Append(mCrLf)
         End With

         SyncLock (MyBase.TcpClient)
            MyBase.TcpClient.Write(lSB.ToString)
         End SyncLock

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::RequestSetup: " & ex.Message))
         End If

      End Try


   End Sub

   Public Sub RequestATrans()
      '--------------------------------------------------------------------------------
      '   Purpose: To send the "A" trans status message when MGAM registration is
      '            taking place to prevent the machine from timing out.
      ' Called by: MyBase.HandleRequestATrans in MagamClient.vb
      ' Build the status message
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",Status")
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::RequestATrans: Socket not connected."))
            End If

         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::RequestATrans: " & ex.Message))
         End If

      End Try

   End Sub

   Public Sub MachineReadyToPlay()
      '--------------------------------------------------------------------------------
      '   Purpose: To send a "ReadyToPlay" to the machine. eg. 1,A,2005-09-12 11:14:30,ReadyToPlay
      ' Called by: TpiClient.vb\HandleReadyToPlay, Startup.vb\OnTPCRefreshTimerEvent
      '      Note: change for MGAM
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",ReadyToPlay")
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineReadyToPlay: Socket not connected."))
            End If

         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineReadyToPlay: " & ex.Message))
         End If

      End Try

   End Sub

   Public Sub MachineComputeChecksum(ByVal aSeedValue As Integer)
      '--------------------------------------------------------------------------------
      ' Purpose: To send a "ComputeChecksum" with "seed" to the machine.
      ' eg. 1,A,2005-09-12 13:50:00,ComputeChecksum,123456
      ' Called by: TpiClient.vb\HandleComputeChecksum, TransactionPortalControl.vb\ProcessRxBuffer
      ' note : change for MGAM
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",ComputeChecksum").Append(",")
               .Append(aSeedValue)
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineComputeChecksum: Socket not connected."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineComputeChecksum: " & ex.Message))
         End If

      End Try

   End Sub

   Public Sub MachineShowMessage(ByVal aMessageID As Integer, ByVal aMessage As String)
      '--------------------------------------------------------------------------------
      ' Purpose: To send a "ShowMessage" with "aiMessageID" & "asMessage" to the machine.
      ' eg. 1,A,2005-09-12 13:50:00,ShowMessage,801,MGAM: Management Console issued REBOOT
      ' Called by: TpiClient.vb\HandleShowMessage
      ' note: change for MGAM
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",ShowMessage").Append(",")
               .Append(aMessageID.ToString).Append(",")
               .Append(aMessage)
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineShowMessage: Socket not connected."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineShowMessage: " & ex.Message))
         End If

      End Try

   End Sub

   Public Sub MachineReboot(ByVal ErrorID As Int32, ByVal ErrorDescription As String)
      '--------------------------------------------------------------------------------
      ' Purpose: To send a "Reboot" to the machine.
      ' eg. 1,A,2005-09-12 13:50:00,Reboot
      ' Called by: TpiClient.vb\HandleRebootMachine
      ' note : change for MGAM
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",Reboot,")
               .Append(ErrorID.ToString).Append(",")
               .Append(ErrorDescription)
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineReboot: Socket not connected."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineReboot: " & ex.Message))
         End If
      End Try

   End Sub

   Public Sub MachineRequestGrandMeters()
      '--------------------------------------------------------------------------------
      ' Purpose: To send a "RequestGrandMeters" to the machine.
      '          eg. 1,A,2006-02-26 17:16:00,RequestGrandMeters
      ' Called by: Startup.vb\OnTPCRefreshTimerEvent
      '      Note: change for BMM
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",RequestGrandMeters")
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineRequestGrandMeters: Socket not connected."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineRequestGrandMeters: " & ex.Message))
         End If

      End Try

   End Sub

   Public Sub MachineRequestProgressivePools()
      '--------------------------------------------------------------------------------
      ' Purpose: To send a "RequestProgressiveSetup" to the machine.
      '          eg. 1,A,2006-02-26 17:16:00,RequestProgressivePools
      ' Called by: 
      '      Note: Added for OLG/AGCO
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",RequestProgressivePools")
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineRequestProgressivePools: Socket not connected."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineRequestProgressivePools: " & ex.Message))
         End If

      End Try

   End Sub

   Public Sub MachineDeActivate()
      '--------------------------------------------------------------------------------
      ' Purpose: To send a "DeActivate" to the machine.
      '          eg. 1,A,2005-09-12 11:14:30,DeActivate
      ' Called by: Startup.vb\OnTPCRefreshTimerEvent
      ' Note: change for MGAM
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",DeActivate")
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineDeActivate: Socket not connected."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::MachineDeActivate: " & ex.Message))
         End If

      End Try

   End Sub

   Public Sub EntryTicketOff()
      '--------------------------------------------------------------------------------
      ' Purpose: To send a "EntryTicketOff" to the machine. eg. 1,A,2005-09-12 11:14:30,EntryTicketOff
      ' Called by: TransactionPortalControl.vb\ProcessRxBuffer
      ' note : To turn Promo Tickets OFF.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",EntryTicketOff")
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::EntryTicketOff: Socket not connected."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::EntryTicketOff: " & ex.Message))
         End If

      End Try

   End Sub

   Public Sub EntryTicketOn(ByVal aEntryTicketFactor As Integer, ByVal aEntryTicketAmount As Integer)
      '--------------------------------------------------------------------------------
      ' Purpose: Sends an 'EntryTicketOn' to the machine as part of an 'A' transaction.
      '          eg. 1,A,2005-09-12 11:14:30,EntryTicketOn,100,0
      '
      ' Called by: TransactionPortalControl.vb\ProcessRxBuffer
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder
      Dim ticketAmountStr As String = "0"
      If aEntryTicketAmount > 0 Then
         ticketAmountStr = CDbl(aEntryTicketAmount / 100.0).ToString("######0.00")
      End If
      Try
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",EntryTicketOn,")
               .Append(aEntryTicketFactor)
               .Append(",")
               .Append(ticketAmountStr)
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock
         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::EntryTicketOn: Socket not connected."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::EntryTicketOn: " & ex.Message))
         End If

      End Try

   End Sub

   Friend Sub Shutdown(ByVal ErrorID As Int32, ByVal ErrorDescription As String)
      '--------------------------------------------------------------------------------
      ' Purpose: Sends a Shutdown message to the machine as part of an 'A' transaction.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      Try
         mStatus = 0
         If MyBase.TcpClient.Socket.Connected Then
            With lSB
               .Append(CType(mTxCount + 1, String))
               .Append(",A,")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .Append(",Shutdown,")
               .Append(ErrorID.ToString).Append(",")
               .Append(ErrorDescription)
               .Append(mCrLf)
            End With

            SyncLock (MyBase.TcpClient)
               MyBase.TcpClient.Write(lSB.ToString)
            End SyncLock

         Else
            If MyBase.TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::Shutdown: Socket not connected."))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::Shutdown: " & ex.Message))
         End If

      End Try

   End Sub

   Friend Sub Startup()
      '--------------------------------------------------------------------------------
      ' Send a Startup message to a machine.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lSB As New StringBuilder

      Try
         mStatus = 1

         lDB = New Database(gConnectionString)
         With lDB
            .AddParameter("@MACH_NUM", MyBase.MachineNumber)
            .AddParameter("@Activate_Flag", "1")
            .AddParameter("@SD_RS_FLAG", "1")
            .ExecuteProcedure("Record_Shutdown_Startup_Mach")
         End With

         With lSB
            .Append(CType(mTxCount + 1, String))
            .Append(",A,")
            .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
            .Append(",Startup")
            .Append(mCrLf)
         End With

         SyncLock (MyBase.TcpClient)
            MyBase.TcpClient.Write(lSB.ToString)
         End SyncLock

      Catch ex As Exception
         ' Handle the exception...
         If MyBase.TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Machine: " & MyBase.MachineNumber & ") Error in Machine::Startup: " & ex.Message))
         End If

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Public Sub NotifyProgressiveMachines(ByVal aProgressiveMachineList As List(Of String))
      Dim lMachine As Machine

      For Each lItem As DictionaryEntry In gMachineCollection
         For Each lProgressiveMachine As String In aProgressiveMachineList

            If lProgressiveMachine = lItem.Key.ToString Then
               lMachine = CType(lItem.Value, Machine)
               lMachine.MachineRequestProgressivePools()
            End If
         Next
      Next

   End Sub

End Class
