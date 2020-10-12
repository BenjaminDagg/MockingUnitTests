Option Explicit On 
Option Strict On

Imports Communication
Imports DataAccess
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections
Imports System.Diagnostics
Imports System.Text
Imports System.Text.RegularExpressions

Public Class TransactionPortalControl

   ' [Variables]
   Private mProcessRxBuffer As Boolean = False
   Private mCrLf As String = Environment.NewLine
   Private mRxBuffer As New StringBuilder
   Private mTcpClient As Networking.TcpClient
   Private mTraceSwitch As TraceSwitch
   Private mIpAddress As String

   ' [Properties]

   Public Property IpAddress() As String
      Get
         Return mIpAddress
      End Get
      Set(ByVal Value As String)
         mIpAddress = Value
      End Set
   End Property

   Public Property TcpClient() As Networking.TCPClient
      Get
         Return mTcpClient
      End Get
      Set(ByVal Value As Networking.TCPClient)
         mTcpClient = Value
      End Set
   End Property

   Public Property TraceSwitch() As Diagnostics.TraceSwitch
      Get
         Return mTraceSwitch
      End Get
      Set(ByVal Value As Diagnostics.TraceSwitch)
         mTraceSwitch = Value
      End Set
   End Property

   Public Sub Start()

      If mTraceSwitch.TraceError Then
         Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") Connected."))
      End If

      ' Setup the event handlers and start reading data from the socket.
      AddHandler mTcpClient.ReadComplete, AddressOf TcpClient_ReadComplete
      AddHandler mTcpClient.WriteComplete, AddressOf TcpClient_WriteComplete
      AddHandler mTcpClient.CloseComplete, AddressOf TcpClient_CloseComplete
      AddHandler mTcpClient.AsyncReadError, AddressOf TcpClient_AsyncReadError
      AddHandler mTcpClient.AsyncWriteError, AddressOf TcpClient_AsyncWriteError
      mTcpClient.Read()

   End Sub

   '
   ' Functions
   '
   Private Function BuildHeader(ByVal Sequence As Int32, _
                                Optional ByVal ErrorID As Int32 = 0, _
                                Optional ByRef ErrorDescription As String = "", _
                                Optional ByVal ShutdownFlag As Int32 = 0) As String
      '--------------------------------------------------------------------------------
      ' Builds and returns generic message header text.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As New StringBuilder

      Try
         With lReturn
            .Append(Sequence)
            .Append(",Z,")
            .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
            .Append(",").Append(ErrorID)
            .Append(",").Append(ErrorDescription)
            .Append(",").Append(ShutdownFlag)
         End With

      Catch ex As Exception
         ' Log the exception.
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") BuildHeader Exception: " & ex.ToString))
         End If

      End Try

      Return lReturn.ToString

   End Function

   Private Sub TcpClient_ReadComplete(ByVal sender As Object, ByVal e As CommEventArgs)

      Try
         mRxBuffer.Append(e.RxData)
         ProcessRxBuffer()

      Catch ex As Exception
         ' Log the exception.
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") ReadComplete Exception: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub TcpClient_WriteComplete(ByVal sender As Object, ByVal e As CommEventArgs)

      Try
         ' Log it
         If mTraceSwitch.TraceVerbose Then
            Trace.Write(FormatLogOutput("(Tpc: " & mIpAddress & ") Sent: " & e.TxData))
         End If

      Catch ex As Exception
         ' Log the exception.
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") WriteComplete Exception: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub TcpClient_CloseComplete(ByVal sender As Object, ByVal e As CommEventArgs)

      Try
         ' Log it
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") Disconnected."))
         End If

      Catch ex As Exception
         ' Log the exception.
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") CloseComplete Exception: " & ex.ToString))
         End If
      End Try

   End Sub

   Private Sub TcpClient_AsyncReadError(ByVal sender As Object, ByVal e As CommEventArgs)

      Try
         ' Log it
         If mTraceSwitch.TraceError Then
            Dim lRxAE As String = e.RxAsyncError.ToLower
            If Not lRxAE.Contains("connection was forcibly closed by the remote host") Then
               Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") AsyncRead Error: tx error: " & e.TxAsyncError & " rx error: " & lRxAE))
            End If
         End If

         mTcpClient.Close()

      Catch ex As Exception
         ' Log the exception.
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") AsyncRead Exception: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub TcpClient_AsyncWriteError(ByVal sender As Object, ByVal e As CommEventArgs)

      Try
         ' Log it
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") AsyncWrite Error: " & e.TxAsyncError))
         End If

         mTcpClient.Close()

      Catch ex As Exception
         ' Log the exception.
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") AsyncWrite Error: " & ex.ToString))
         End If

      End Try

   End Sub

   Private Sub ProcessRxBuffer()

      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lMachine As Machine

      Dim lItemDE As DictionaryEntry

      Dim lTX As String = ""
      Dim lIPAddress As String
      Dim lMessageText As String
      Dim lTransType As String

      Dim lFieldData As String()

      Dim lMachineSequence As Integer
      Dim lSeedValue As Integer

      Dim lTimeStamp As DateTime

      ' Any other threads processing the buffer?
      If Not mProcessRxBuffer Then
         Try
            ' Set this so that only one thread is processing the buffer.
            mProcessRxBuffer = True

            ' Process the buffer if the buffer contains a carriage return / linefeed combo.
            While mRxBuffer.ToString.IndexOf(mCrLf) > 0
               ' Pull out a complete message from the buffer.
               lMessageText = mRxBuffer.ToString(0, mRxBuffer.ToString.IndexOf(mCrLf))
               If TraceSwitch.TraceVerbose Then
                  Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") Received: " & lMessageText))
               End If

               ' Remove the part just pulled out.
               mRxBuffer.Remove(0, mRxBuffer.ToString.IndexOf(mCrLf) + mCrLf.Length)

               ' Parse the message.
               lFieldData = lMessageText.Split(","c)

               ' Test that the message header exists (Machine_Sequence, Trans_Type, Time_Stamp)
               If lFieldData.GetUpperBound(0) > 1 Then
                  ' Test that the data in the header is in the appropriate format.
                  If Regex.IsMatch(lFieldData(0), "^\d+$") Then
                     lMachineSequence = CType(lFieldData(0), Integer)
                     If Regex.IsMatch(lFieldData(1), "^[Z]{1}$") Then
                        lTransType = lFieldData(1)
                        If Regex.IsMatch(lFieldData(2), "^\d{4}[-]\d\d-\d\d \d\d:\d\d:\d\d$") Then
                           lTimeStamp = CType(lFieldData(2), DateTime)
                           If lFieldData.Length = 4 Then
                              Select Case lFieldData(3)
                                 Case "GetAllMachines"
                                    Dim lSB As New StringBuilder

                                    lSB.Append(gMachineCollection.Count)

                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          With lSB
                                             .Append(","c)
                                             .Append(lMachine.CasinoMachineNumber).Append(","c)
                                             .Append(lMachine.IpAddress).Append(","c)
                                             .Append(lMachine.TxCount.ToString).Append(","c)
                                             .Append(lMachine.RxCount.ToString).Append(","c)
                                             .Append(GetMachineStatus(lMachine.MachineNumber)).Append(","c)
                                             .Append(lMachine.LastTransType).Append(","c)
                                             .Append(lMachine.GameCode).Append(","c)
                                             .Append(lMachine.MachineNumber).Append(","c)
                                             .Append(lMachine.VoucherPrintingFlag)
                                          End With
                                       Next
                                    End If

                                    lTX = Me.BuildHeader(CType(lFieldData(0), Integer)) & ","c & lFieldData(3) & ","c & lSB.ToString & mCrLf

                                 Case "ResetCounters"
                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          lMachine.RxCount = 0
                                          lMachine.TxCount = 0
                                       Next
                                    End If

                                 Case "StartupMachine"
                                    If Startup.PendingMachineSiteStatusChange()(1) Then
                                       If gMachineCollection.Count > 0 Then
                                          For Each lItemDE In gMachineCollection
                                             lMachine = CType(lItemDE.Value, Machine)
                                             lMachine.Startup()
                                             lMachine.ActiveFlag = 1
                                          Next
                                       End If
                                    End If

                                 Case "ShutdownMachine"
                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          lMachine.Shutdown(300, "Transaction Portal Control shutdown initiated.")
                                          lMachine.ActiveFlag = 0
                                       Next
                                    End If

                                 Case "RequestSetup"
                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          lMachine.RequestSetup()
                                       Next
                                    End If

                                 Case "RebootMachine"
                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          lMachine.MachineReboot(306, "Transaction Portal Control reboot initiated.")
                                       Next
                                    End If

                                 Case "ComputeChecksum"
                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          ' Initialize random-number generator.
                                          Randomize()
                                          lSeedValue = CInt(Int((9999 * Rnd()) + 1)) ' Generate random Seed between 1 and 9999.
                                          lMachine.MachineComputeChecksum(lSeedValue)
                                       Next
                                    End If

                                 Case "DeActivateMachine"
                                    ' Note: Used by Dom for Testing only !!! 
                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          ' Change ACTIVE_FLAG = 2 in MACH_SETUP for the machine with this IP
                                          Call DbTpSetMachineActiveFlag("2", lMachine.IpAddress)
                                       Next
                                    End If

                                 Case "ReadyToPlayMachine"
                                    ' Note: Used by Dom for Testing only!!!
                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          ' Change ACTIVE_FLAG = 1 in MACH_SETUP for the machine with this IP
                                          Call DbTpSetMachineActiveFlag("1", lMachine.IpAddress)
                                       Next
                                    End If

                                 Case "ResumeMachineHaltedForTicketPrinting"
                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          ' Change VOUCHER_PRINTING_FLAG = 0 in MACH_SETUP for this Mach_No
                                          DbTpGetSetVoucherPrintingFlag(lMachine.MachineNumber, "S", 0)
                                          lMachine.VoucherPrintingFlag = 0
                                       Next
                                    End If

                                 Case "EntryTicketOff"
                                    If TraceSwitch.TraceVerbose Then
                                       Trace.WriteLine(FormatLogOutput(String.Format("Sending EntryTicketOff to all {0} connected machines.", gMachineCollection.Count)))
                                    End If

                                    If gMachineCollection.Count > 0 Then
                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          ' Send the "A" trans. with "EntryTicketOff"
                                          lMachine.EntryTicketOff()
                                       Next
                                    End If

                                 Case "EntryTicketOn"
                                    ' Get the Hashtable of BANK_NO, ENTRY_TICKET_FACTOR
                                    Dim lBankNoEntryTicketFactor As Hashtable
                                    Dim lBPI As BankPromoInfo
                                    Dim lETF As Integer
                                    Dim lETA As Integer

                                    If TraceSwitch.TraceVerbose Then
                                       Trace.WriteLine(FormatLogOutput(String.Format("Sending EntryTicketOn to all {0} connected machines.", gMachineCollection.Count)))
                                    End If

                                    If gMachineCollection.Count > 0 Then
                                       ' Get the Hashtable of BANK_NO, ENTRY_TICKET_FACTOR
                                       lBankNoEntryTicketFactor = DbTpPrintPromoInfo()

                                       For Each lItemDE In gMachineCollection
                                          lMachine = CType(lItemDE.Value, Machine)
                                          ' Get the ENTRY_TICKET_FACTOR and ENTRY_TICKET_AMOUNT from the BANK that this machine is in.
                                          lBPI = CType(lBankNoEntryTicketFactor(lMachine.Bank.ToString), BankPromoInfo)
                                          lETF = lBPI.EntryTicketFactor
                                          lETA = lBPI.EntryTicketAmount

                                          ' Send the "A" trans. with 'EntryTicketOn' and entry ticket bank info.
                                          lMachine.EntryTicketOn(lETF, lETA)
                                       Next
                                    End If
                              End Select

                           ElseIf lFieldData.Length > 4 Then

                              lIPAddress = lFieldData(4)
                              lMachine = CType(gMachineCollection(lIPAddress), Machine)

                              Select Case lFieldData(3)
                                 Case "ResetCounters"
                                    lMachine.RxCount = 0
                                    lMachine.TxCount = 0

                                 Case "StartupMachine"
                                    If Startup.PendingMachineSiteStatusChange()(1) Then
                                       lMachine.Startup()
                                       lMachine.ActiveFlag = 1
                                    End If

                                 Case "ShutdownMachine"
                                    lMachine.Shutdown(300, "Transaction Portal Control initiated.")
                                    lMachine.ActiveFlag = 0

                                 Case "RequestSetup"
                                    lMachine.RequestSetup()

                                 Case "ShowMessage"
                                    ' Check if IP is avaiable as the 7th field
                                    If lFieldData.Length > 6 Then
                                       lIPAddress = lFieldData(6)
                                       lMachine = CType(gMachineCollection(lIPAddress), Machine)
                                       ' Invoke "ShowMessage" "A" trans. with 801 and MessageText
                                       lMachine.MachineShowMessage(CType(lFieldData(4), Integer), lFieldData(5))
                                    Else
                                       ' Send the message to ALL machines
                                       If gMachineCollection.Count > 0 Then
                                          For Each lItemDE In gMachineCollection
                                             lMachine = CType(lItemDE.Value, Machine)
                                             ' Invoke "ShowMessage" "A" trans. with 801 and MessageText
                                             lMachine.MachineShowMessage(CType(lFieldData(4), Integer), lFieldData(5))
                                          Next
                                       End If

                                    End If

                                 Case "RebootMachine"
                                    lMachine.MachineReboot(306, "Transaction Portal Control reboot initiated.")

                                 Case "ComputeChecksum"
                                    ' Initialize random-number generator.
                                    Randomize()
                                    lSeedValue = CInt(Int((9999 * Rnd()) + 1)) ' Generate random Seed between 1 and 9999.
                                    lMachine.MachineComputeChecksum(lSeedValue)

                                 Case "DeActivateMachine"
                                    ' Note: Used by Dom for Testing only !!! 
                                    ' Change ACTIVE_FLAG = 2 in MACH_SETUP for the machine with this IP
                                    Call DbTpSetMachineActiveFlag("2", lMachine.IpAddress)

                                 Case "ReadyToPlayMachine"
                                    ' Note: Used by Dom for Testing only !!!
                                    ' Change ACTIVE_FLAG = 1 in MACH_SETUP for the machine with this IP
                                    Call DbTpSetMachineActiveFlag("1", lMachine.IpAddress)

                                 Case "ResumeMachineHaltedForTicketPrinting"
                                    ' Change VOUCHER_PRINTING_FLAG = 0 in MACH_SETUP for this MACH_NO
                                    DbTpGetSetVoucherPrintingFlag(lMachine.MachineNumber, "S", 0)
                                    lMachine.VoucherPrintingFlag = 0

                              End Select

                           End If

                           If lTX.Length = 0 Then
                              lTX = Me.BuildHeader(CType(lFieldData(0), Integer)) & ","c & lFieldData(3) & mCrLf
                           End If

                           mTcpClient.Write(lTX)
                        End If
                     End If
                  End If
               End If
            End While

         Catch ex As Exception
            ' Log the exception.
            If TraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") ProcessRxBuffer Error: " & ex.ToString))
            End If

         End Try

         mProcessRxBuffer = False

      End If

   End Sub

   Private Function GetMachineStatus(ByVal aMachineNumber As String) As String
      '--------------------------------------------------------------------------------
      '   Purpose: Retrieves the ACTIVE_FLAG flag from the gMachineHT.
      ' Called by:  ProcessRxBuffer
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      'Dim lDataRow As DataRow = Nothing
      'Dim lRowNbr As Integer = -1
      Dim lReturn As String = ""

      Try
         ' Does Machine Number exist as a key value in gMachineHT?
         If gMachineHT.ContainsKey(aMachineNumber) Then
            ' The Machine Number exists as a key value in gMachineHT, so store the ACTIVE_FLAG value.
            lReturn = CType(gMachineHT.Item(aMachineNumber), Integer).ToString
         Else
            ' Does nto exist, return 0
            lReturn = "0"
         End If

         'lDataRow = gMachineHT.Rows.Find(aMachineNumber)
         'If lDataRow IsNot Nothing Then
         '   ' MACH_NO exists in gMachineHT DataTable, so store the ACTIVE_FLAG value.
         '   lReturn = CType(lDataRow.Item("ACTIVE_FLAG"), String)
         'Else
         '   lReturn = "0"
         'End If

      Catch ex As Exception
         ' Log the exception and set the return value to zero.
         If TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & aMachineNumber & ") GetMachineStatus Error: " & ex.ToString))
         End If

         lReturn = "0"

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Public Sub DbTpSetMachineActiveFlag(ByVal aActiveFlag As String, ByVal aIpAddress As String)
      '--------------------------------------------------------------------------------
      '    Purpose: Executes tpActivateDeActivateMachine and sets ACTIVE_FLAG = 1 or 2
      '       Note: Used by Dom for Testing only !!!
      ' Called by : ProcessRxBuffer
      '      Calls: tpActivateDeActivateMachine
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing

      Try
         lDB = New Database(gConnectionString)
         With lDB
            .AddParameter("@ActiveFlag", aActiveFlag)
            .AddParameter("@IpAddress", aIpAddress)
            .ExecuteProcedure("tpActivateDeActivateMachine")
         End With

      Catch ex As Exception
         ' Log the exception.
         If TraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("(Tpc: " & mIpAddress & ") DbTpSetMachineActiveFlag Error: " & ex.ToString))
         End If

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Private Function DbTpGetSetVoucherPrintingFlag(ByVal asMachNo As String, ByVal asGetOrSet As String, ByVal aiFlag As Integer) As Integer
      '--------------------------------------------------------------------------------
      '   Purpose: Select/Update of MACH_SETUP.VOUCHER_PRINTING_FLAG. -1 on Error.
      ' Called by: ProcessRxBuffer.
      '     Calls: tpGetSetVoucherPrintingFlag
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet

      Dim lVoucherPrintingFlag As Integer = 0

      ' Get/Set the VOUCHER_PRINTING_FLAG for this machine.
      Try
         lDB = New Database(gConnectionString)
         With lDB
            ' Add Parameters
            .AddParameter("@MachNo", asMachNo)
            .AddParameter("@GetOrSet", asGetOrSet)
            .AddParameter("@FlagValue", aiFlag.ToString)
         End With

         ' Execute "tpGetSetVoucherPrintingFlag" & select/update MACH_SETUP tbl for "VOUCHER_PRINTING_FLAG"
         lDS = lDB.ExecuteProcedure("tpGetSetVoucherPrintingFlag")

         ' Get the "VOUCHER_PRINTING_FLAG"
         lVoucherPrintingFlag = CType(lDS.Tables(0).Rows(0).Item(0), Integer)

         ' If we had an error in select/update, write to log file and re-set to 0 so game play can continue.
         If (lVoucherPrintingFlag = -1) Then
            If mTraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput("Tpc: DbTpGetSetVoucherPrintingFlag Error: Select/Update in tpGetGetSetVoucherPrintingFlag failed."))
            End If
            lVoucherPrintingFlag = 0
         End If

      Catch ex As Exception
         ' Log the exception.
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("Tpc: DbTpGetSetVoucherPrintingFlag Exception: " & ex.ToString))
         End If

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lVoucherPrintingFlag

   End Function

   Private Function DbTpPrintPromoInfo() As Hashtable
      '--------------------------------------------------------------------------------
      ' Purpose: Returns a Hashtable of BANK.Bank_No, BANK.Entry_Ticket_Factor.
      ' Called by: ProcessRxBuffer.
      '
      '	tpPrintPromoInfo performs the following select:
      '     SELECT BANK_NO, ENTRY_TICKET_FACTOR FROM BANK ORDER BY BANK_NO		
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lHTReturn As New Hashtable

      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDT As DataTable

      Dim lKey As String

      Dim lHasETA As Boolean

      Dim lBankNumber As Integer
      Dim lEntryTicketAmount As Integer
      Dim lEntryTicketFactor As Integer
      Dim lIndex As Integer = 0


      Try
         lDB = New Database(gConnectionString)
         lDS = lDB.ExecuteProcedure("tpPrintPromoInfo")
         lDT = lDS.Tables(0)

         ' Set a flag indicating if entry ticket amount is contained in the result set.
         ' The ENTRY_TICKET_AMOUNT column was added to BANK table in database version 6.0.2.
         lHasETA = lDT.Columns.Contains("ENTRY_TICKET_AMOUNT")

         ' Step thru the rows of the DataSet
         For Each lDR As DataRow In lDT.Rows
            ' Add the BANK_NO, ENTRY_TICKET_FACTOR, and ENTRY_TICKET_AMOUNT values from the BANK table to the output Hashtable.
            ' Note that tpPrintPromoInfo converts the entry ticket amount to cents and returns it as an integer.
            lBankNumber = CType(lDR.Item("BANK_NO"), Integer)
            lKey = lBankNumber.ToString
            lEntryTicketFactor = CType(lDR.Item("ENTRY_TICKET_FACTOR"), Integer)

            ' Does tpPrintPromoInfo returns ENTRY_TICKET_AMOUNT column data?
            If lHasETA Then
               ' Yes, so use the value.
               lEntryTicketAmount = CType(lDR.Item("ENTRY_TICKET_AMOUNT"), Integer)
            Else
               ' No, so set the EntryTicketAmount value to zero.
               lEntryTicketAmount = 0
            End If

            ' Create a new BankPromoInfo instance and add it to the Hashtable that will be returned...
            Dim lBPI As New BankPromoInfo(lBankNumber, lEntryTicketFactor, lEntryTicketAmount)
            lHTReturn.Add(lKey, lBPI)
         Next

      Catch ex As Exception
         ' Log the exception.
         If mTraceSwitch.TraceError Then
            Trace.WriteLine(FormatLogOutput("Tpc: DbTpPrintPromoInfo Exception: " & ex.ToString))
         End If

         ' Set the output hashtable to nothing to indicate error.
         lHTReturn = Nothing

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If
      End Try

      ' Set function return value.
      Return lHTReturn

   End Function

End Class
