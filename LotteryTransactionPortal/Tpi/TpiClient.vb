Option Explicit On
Option Strict On

Imports Communication.Networking
Imports DataAccess
Imports System
Imports System.Collections
Imports System.Data
Imports System.Diagnostics
Imports System.IO
Imports System.Text
Imports System.Text.RegularExpressions
Imports System.Timers
Imports System.Xml
Imports System.Xml.Schema
Imports Utilities
Imports System.Collections.Generic

Public Class TpiClient
   Implements IDisposable

   ' Constants
   Const DELIMITER As Char = ","c

   ' Events
   Public Event ReadyForTP(ByVal aHashtable As Hashtable)
   Public Event ShutdownMachine(ByVal ErrorId As Integer, ByVal ErrorDescription As String)
   ' Change for MGAM
   Public Event RequestATrans()
   Public Event ReadyToPlay()
   Public Event ComputeChecksum(ByVal SeedValue As Integer)
   Public Event ShowMessage(ByVal MessageID As Integer, ByVal MessageText As String)
   Public Event RebootMachine(ByVal ErrorId As Integer, ByVal ErrorDescription As String)
   Public Event StartupMachine()
   Public Event NotifyProgressiveMachines(ByVal progressiveMachineList As List(Of String))

   ' End change for MGAM

   ' Variables
   Private mMachine As PlayerTerminal
   Private mTraceSwitch As TraceSwitch
   Private mTransaction As New Transaction

   Private mLastMachineResponse As LastMachineMessage

   Private mBarcode As String = ""
   Private mOldChecksum As Byte() = Nothing
   Private mTpiID As Integer = 0
   Private mConnectionString As String
   Private mVoucherPrintingTimer As Timer

   ' Timer for sending checksum requests
   Public mChecksumTimer As System.Timers.Timer

   ' Boolean to test for Jackpot
   Private mIsJackpot As Boolean = False

   ' For Voucher Expiration.
   Private mExpirationDays As String = "1"

   ' For Voucher Expiration in Thunderbird (THB001) casino ONLY.
   Private mExpirationMsg As String = "This game day."

   Private mExpirationMonths As String = ""


   ' To stop duplicate VoucherCreates
   Private mVoucherCreatePending As Boolean = False

   ' The Voucher_ID (PK) in the VOUCHER table. One of the output columns from sp tpInsertVoucher
   Private mVoucherID As Integer = 0

   ' CasinoTransNo output parm. from tpTransVC & tpTransVR
   Private mCasinoTransNo As Integer = 0

   ' JackpotTransNo output parameter from tpTransVC
   Private mJackpotTransNo As Integer = 0

   ' Random # generator for Barcode creation.
   Private mRng As Random

#Region " Properties "

   Public Property Machine() As PlayerTerminal

      Get
         Return mMachine
      End Get

      Set(ByVal Value As PlayerTerminal)
         mMachine = Value
      End Set

   End Property

   Public Property TraceSwitch() As TraceSwitch

      Get
         Return mTraceSwitch
      End Get

      Set(ByVal Value As TraceSwitch)
         mTraceSwitch = Value
      End Set

   End Property

   Public WriteOnly Property ThirdPartyHashTable() As Hashtable

      Set(ByVal Value As Hashtable)
         RaiseEvent ReadyForTP(Value)
      End Set

   End Property

   Public Property ConnectionString() As String

      Get
         Return mConnectionString
      End Get

      Set(ByVal Value As String)
         mConnectionString = Value
      End Set

   End Property

   Public ReadOnly Property Transaction() As Transaction

      Get
         Return mTransaction
      End Get

   End Property

   Public ReadOnly Property MessageDelimiter() As String

      Get
         Return DELIMITER
      End Get

   End Property

#End Region

   Public Overridable Sub Startup()
      '--------------------------------------------------------------------------------
      ' Purpose: Set module variables, mTpiID & mExpirationDays with values from the
      ' CASINO & TPI_SETTING tables.
      '
      '   Calls: DbTpGetTpiSetting
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lHT As New Hashtable

      ' Initialize the TpiID
      mTpiID = mMachine.TpiID

      ' Get ExpirationDays from TPI_SETTING only for DGE-TITO (TPI_ID=0)
      If (mTpiID = 0) Then
         ' obtain the ErrorID & ExpirationDays from the TPI_SETTING table.
         lHT = DbTpGetTpiSetting(mTpiID.ToString, "ExpirationDays")

         ' Check for Error in tpGetTpiSetting call. If error then use default value of 1
         If (CType(lHT("ErrorID"), Integer) = 0) Then
            ' no Error load module var. mExpirationDays with "ItemValue"
            mExpirationDays = CType(lHT("ItemValue"), String)
         End If

         ' Get the ErrorID & ExpirationMsg from the TPI_SETTING table.
         ' Note: used for Thunderbird (THB001) casino ONLY.
         lHT = DbTpGetTpiSetting(mTpiID.ToString, "ExpirationMsg")

         ' Check for Error in tpGetTpiSetting call. If error then use default value of "This game day."
         If (CType(lHT("ErrorID"), Integer) = 0) Then
            ' No Error load module var. mExpirationMsg with "ItemValue"
            mExpirationMsg = CType(lHT("ItemValue"), String)
         End If

         lHT = DbTpGetTpiSetting(mTpiID.ToString, "ExpirationMonths")

         If (CType(lHT("ErrorID"), Integer) = 0) Then
            mExpirationMonths = CType(lHT("ItemValue"), String)
         End If

      End If

      ' Raise the Event that tells the Machine that we are ready to play
      ' only if MACH_SETUP.ACTIVE_FLAG <> 2 (Iowa Lottery "De-Activated" state)
      If mMachine.ActiveFlag <> 2 Then
         Call HandleReadyToPlay()

         ' Create the Timer that sends Checksum requests.
         Call CreateChecksumTimer()

         ' Seed the Random # generator for Barcodes.
         mRng = New Random(Convert.ToInt32(Date.Now.Ticks And Integer.MaxValue))

         ' Init the voucher printed error 
         mVoucherPrintingTimer = New System.Timers.Timer
         mVoucherPrintingTimer.Interval = Machine.TpiServer.VoucherPrintFlagTimeout
         AddHandler mVoucherPrintingTimer.Elapsed, AddressOf OnVoucherPrintingReset

         ' If the machine starts up with voucher printing flag kick off timer (if feature enabled)
         If Machine.VoucherPrintingFlag = 1 And Machine.TpiServer.IsVoucherPrintFlagEnabled Then
            mVoucherPrintingTimer.Start()
         End If

         ' Populate the LastMachineMessage.vb class.
         mLastMachineResponse = PopulateLastMachineMessage()

      Else
         If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("DE-ACTIVATED, Not Ready To Play"))
      End If

   End Sub

   Private Sub OnVoucherPrintingReset(ByVal source As Object, ByVal e As ElapsedEventArgs)
      '--------------------------------------------------------------------------------
      ' Purpose:     When this timer elapses, resets the stuck voucher printing flag
      '--------------------------------------------------------------------------------

      Try
         ' Write to logs
         WriteError("VoucherPrintingFlag Reseting due to timeout.")
         tpInsertCasinoEvent("VE", "VoucherPrintingReset", String.Format("VoucherPrintingFlag Reset after {0} ms timeout.", Machine.TpiServer.VoucherPrintFlagTimeout), Machine.MachineNumber)
      Catch ex As Exception
         WriteError("tpInsertCasinoEvent Reset failed.")
      End Try

      Try
         ' Reset the flag
         ResetVoucherPrintingFlag()

         WriteError("VoucherPrintingFlag Reset successfully.")
      Catch ex As Exception

         WriteError("VoucherPrintingFlag Reset failed.")
      End Try

   End Sub

   Public Sub WriteError(ByVal message As String)
      '--------------------------------------------------------------------------------
      ' Helper function to reduce duplicate code. Writes Error log files
      '--------------------------------------------------------------------------------

      If TraceSwitch.TraceError Then
         Trace.WriteLine(FormatLogOutput(message))
      End If
   End Sub

   Private Sub CreateChecksumTimer()
      '--------------------------------------------------------------------------------
      '   Purpose: Creates a timer that fires hourly.
      ' Called by: Startup
      '     Calls: OnChecksumTimerEvent every timer tick
      '--------------------------------------------------------------------------------

      ' Create a new Timer with a 1 hour Interval.
      If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("CreateChecksumTimer: CREATED"))
      mChecksumTimer = New System.Timers.Timer(3600 * 1000)
      AddHandler mChecksumTimer.Elapsed, AddressOf OnChecksumTimerEvent

      mChecksumTimer.AutoReset = True
      mChecksumTimer.Enabled = True

      ' Added by Edris UGS 3.0.6
      mChecksumTimer.Stop()


   End Sub

   Private Sub OnChecksumTimerEvent(ByVal source As Object, ByVal e As ElapsedEventArgs)
      '--------------------------------------------------------------------------------
      '   Purpose: Raises the "ComputeChecksum" event to be handled by Machine.vb\MachineComputeChecksum
      ' Called by: CreateChecksumTimer
      '--------------------------------------------------------------------------------

      ' If mTraceSwitch.TraceVerbose Then Trace.WriteLine(MyBase.FormatLogOutput(" OnChecksumTimerEvent"))
      ' Send an A trans "ComputeChecksum" with seed of 0 when Machine class starts and on each hour.

      RaiseEvent ComputeChecksum(0)

   End Sub

   Public Overridable Sub Shutdown()

   End Sub

   Public Function FormatLogOutput(ByVal MessageText As String) As String
      '--------------------------------------------------------------------------------
      ' Returns incoming text with datetime and machine number prepended.
      '--------------------------------------------------------------------------------

      Return String.Format("{0:yyyy-MM-dd HH:mm:ss.fff} (Machine: {1}) {2}", _
                           DateTime.Now, mMachine.MachineNumber, MessageText)

   End Function

   Sub BuildResponseHeader(ByRef aResponse As Hashtable, ByVal MessageHT As Hashtable)
      '--------------------------------------------------------------------------------
      ' Purpose: Adds MachineSequence/TransType/TimeStamp/OnlineStatus fields to the
      '          response Hashtable sent back to the Machine.
      '
      ' Called by: HandleTransaction, SendErrorResponseToMachine, HandleCashOut,
      '            DoVoucherCreate/Error, HandleVoucherRedeem/ed,
      '            HandleVoucherNotRedeemed, HandleVoucherPrinted
      '--------------------------------------------------------------------------------

      With aResponse
         .Add("MachineSequence", CType(MessageHT("MachineSequence"), String))
         .Add("TransType", CType(MessageHT("TransType"), String))
         .Add("TimeStamp", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
      End With

      ' Remove comments below if and when "OnlineStatus" is implemented.
      '   aResponse.Add("OnlineStatus", CType(MessageHT("OnlineStatus"), String))
      '   ' Set the Machine's "ActiveFlag" from the incoming OnlineStatus
      '   mMachine.ActiveFlag = CType(MessageHT("OnlineStatus"), Integer)

   End Sub

   Public Sub HandleShutdownMachine(ByVal aErrorID As Integer, ByVal aErrorDescription As String)
      '--------------------------------------------------------------------------------
      '   Purpose: Raises event "ShutdownMachine"
      ' Called by: MgamClient
      '     Calls: Machine.vb\Shutdown
      '      NOTE: change for MGAM
      '--------------------------------------------------------------------------------

      ' Tell the TP we are ready to shutdown this machine
      RaiseEvent ShutdownMachine(aErrorID, aErrorDescription)

   End Sub

   Public Sub HandleRebootMachine(ByVal aErrorID As Integer, ByVal aErrorDescription As String)
      '--------------------------------------------------------------------------------
      '   Purpose: Raises event "RebootMachine"
      ' Called by: MgamClient.vb\RebootSign_MessageLogoff_PlayerLock
      '     Calls: Machine.vb\MachineReboot
      '      NOTE: Change for MGAM
      '--------------------------------------------------------------------------------

      ' Tell the TP we are ready to Reboot this machine
      RaiseEvent RebootMachine(aErrorID, aErrorDescription)

   End Sub

   Public Sub HandleStartupMachine()
      '--------------------------------------------------------------------------------
      '   Purpose: Raises event "StartupMachine"
      ' Called by: MgamClient.vb\RebootSign_MessageLogoff_PlayerLock
      '     Calls: Machine.vb\Startup
      '      NOTE: Change for MGAM
      '--------------------------------------------------------------------------------

      ' Tell the TP we are ready to Startup this machine
      RaiseEvent StartupMachine()

   End Sub

   Public Sub HandleRequestATrans()
      '--------------------------------------------------------------------------------
      '   Purpose: Raises event "RequestATrans"
      ' Called by: MgamClient
      '     Calls: Machine.vb\RequestSetup
      '      NOTE: Change for MGAM
      '--------------------------------------------------------------------------------

      ' Tell the TP we are ready to do a Status
      RaiseEvent RequestATrans()

   End Sub

   Public Sub HandleReadyToPlay()
      '--------------------------------------------------------------------------------
      '   Purpose: Raises event "ReadyToPlay"
      ' Called by: MgamClient after all the Registration steps are completed.
      '     Calls: Machine.vb\MachineReadyToPlay 
      ' NOTE : change for MGAM
      '--------------------------------------------------------------------------------

      ' Tell the TP we are ready to do a ReadyToPlay eg. 1,A,2005-09-12 11:14:30,ReadyToPlay
      RaiseEvent ReadyToPlay()

   End Sub

   Public Sub HandleComputeChecksum(ByVal aSeedValue As Integer)
      '--------------------------------------------------------------------------------
      '   Purpose: Raises event "ComputeChecksum"
      ' Called by: MgamClient after receipt of COMPUTE_CHECKSUM command (CommandID=500).
      '     Calls: Machine.vb\MachineComputeChecksum 
      '      NOTE: Change for MGAM
      '--------------------------------------------------------------------------------

      ' Tell the TP we are ready to do a ComputeChecksum eg. 1,A,2005-09-12 11:14:30,ComputeChecksum,aSeedValue
      RaiseEvent ComputeChecksum(aSeedValue)

   End Sub

   Public Sub HandleShowMessage(ByVal aMessageID As Integer, ByVal aMessage As String)
      '--------------------------------------------------------------------------------
      '   Purpose: Raises event "ShowMessage"
      '	called by :	MgamClient.vb\RebootSign_MessageLogoff_PlayerLock
      '     Calls: Machine.vb\MachineShowMessage 
      ' NOTE : change for MGAM
      '--------------------------------------------------------------------------------

      ' Tell the TP we are ready to show a message with MACHINE_MESSAGE_ID = aiMessageID in MACHINE_MESSAGE table
      ' eg. 1,A,2005-09-12 11:14:30,ShowMessage,801,MGAM: Management Console Issued REBOOT
      RaiseEvent ShowMessage(aMessageID, aMessage)

   End Sub

   Public Overridable Sub HandleMessage(ByVal MessageHash As Hashtable)
      '--------------------------------------------------------------------------------
      ' Routine to handle incoming machine messages.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lResponseHash As New Hashtable

      Dim lVoucherIsPrinting As Boolean

      Dim lVerData() As String

      Dim lBuffer As String
      Dim lCommand As String
      Dim lGameRelease As String
      Dim lOSVersion As String
      Dim lTransType As String

      Try
         ' Check if we have an empty hash table, if so return.
         If MessageHash Is Nothing Then
            Exit Sub
         End If

         ' Obtain the TransType (eg. W, F, L, J, T ... )
         lTransType = CType(MessageHash("TransType"), String)

         ' Obtain the current value of the Voucher_Printing_Flag, as this may have been reset by the TPC.
         lVoucherIsPrinting = (mMachine.VoucherPrintingFlag = 1)

         Select Case lTransType.ToUpper
            Case "A"
               ' Store the Command text.
               lCommand = CType(MessageHash("Command"), String).ToUpper

               Select Case lCommand
                  ' Check if this is "A" trans. with "ComputeChecksum". For IowaLottery this is initiated by OnTPCRefreshTimerEvent.
                  Case "COMPUTECHECKSUM"
                     ' Get the CRC checksum value and store it in the TPI_SETTING table.
                     Call DbTpGetStoreChecksum(mTpiID.ToString, CType(MessageHash("GameConfigData"), Int64))

                  Case "READYTOPLAY"
                     ' Check if the game release from the machine is the same as the game release from the database.

                     ' If verbose logging is on, record receipt of 'A' transaction to the log.
                     If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("TpiClient::HandleMessage: Received A Trans message with command = ReadyToPlay"))

                     ' Store the GameConfigData (which should be the version information).
                     lBuffer = CType(MessageHash("GameConfigData"), String)

                     ' If verbose logging is on, record the version information to the log.
                     If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("TpiClient::HandleMessage: GameConfigData: " & lBuffer))

                     ' Is the version information '+' delimited?
                     If lBuffer.Contains("+") Then
                        ' Yes, Blue Diamond machines will be sending 9 items of + delimited version information.
                        lVerData = lBuffer.Split("+".ToCharArray)
                        ' Are there 9 version elements?
                        If lVerData.Length = 9 Then
                           ' Yes, call routine to update the version info in the database.
                           Call DbTpUpdateMachineVersions(lBuffer)
                        Else
                           ' Wrong number of items.
                           Trace.WriteLine(FormatLogOutput("TpiClient::HandleMessage error: Incorrect number of EGM version elements in 'A' transaction ReadyToPlay GameConfigData: " & lBuffer))
                        End If
                     Else
                        ' Version info is NOT + delimited.
                        If lBuffer.Contains(" - ") Then
                           ' Look for space - space that separates the os info from the game release info...
                           ' Dakota machines send a string like 'Rel 104 - 16.10' showing OS version and game version.
                           ' Early BlueCube code sends only game version info, later code sends both.
                           lVerData = lBuffer.Split("-".ToCharArray)
                           lOSVersion = lVerData(0).Trim()
                           lGameRelease = lVerData(1).Trim()
                        Else
                           lOSVersion = ""
                           lGameRelease = lBuffer
                        End If

                        ' Make sure we have data.
                        If String.IsNullOrEmpty(lGameRelease) = False Then
                           ' Avoid data truncation error, set size to MACH_SETUP.GAME_RELEASE column size if necessary.
                           If lGameRelease.Length > 16 Then lGameRelease = lGameRelease.Substring(0, 16)
                           If lOSVersion.Length > 16 Then lOSVersion = lOSVersion.Substring(0, 16)

                           ' Do we need to update the MACH_SETUP.GAME_RELEASE value?
                           If lGameRelease <> mMachine.GameRelease OrElse lOSVersion <> mMachine.OSVersion Then
                              ' Yes, so call routine to do it.
                              Call DbTpUpdateMachineGameRelease(lGameRelease, lOSVersion)
                           End If
                        End If
                     End If

               End Select

               Exit Sub

            Case "CASHOUT"
               If lVoucherIsPrinting Then
                  ' Send Error 137 if we are waiting for VoucherPrinted/HandPay
                  lResponseHash = SendErrorResponseToMachine(MessageHash, 137)
               Else
                  lResponseHash = HandleCashOut(MessageHash)
               End If

            Case "VOUCHERCREATE"
               If lVoucherIsPrinting Then
                  ' Send Error 137 if we are waiting for VoucherPrinted/HandPay
                  lResponseHash = SendErrorResponseToMachine(MessageHash, 137)
               Else
                  lResponseHash = HandleVoucherCreate(MessageHash)
               End If

            Case "VOUCHERREDEEM"
               If lVoucherIsPrinting Then
                  ' Send Error 137 if we are waiting for VoucherPrinted/HandPay
                  lResponseHash = SendErrorResponseToMachine(MessageHash, 137)
               Else
                  lResponseHash = HandleVoucherRedeem(MessageHash)
               End If

            Case "VOUCHERREDEEMED"
               If lVoucherIsPrinting Then
                  ' Send Error 137 if we are waiting for VoucherPrinted/HandPay
                  lResponseHash = SendErrorResponseToMachine(MessageHash, 137)
               Else
                  lResponseHash = HandleVoucherRedeemed(MessageHash)
               End If

            Case "VOUCHERNOTREDEEMED"
               If lVoucherIsPrinting Then
                  ' Send Error 137 if we are waiting for VoucherPrinted/HandPay
                  lResponseHash = SendErrorResponseToMachine(MessageHash, 137)
               Else
                  lResponseHash = HandleVoucherNotRedeemed(MessageHash)
               End If

            Case "VOUCHERPRINTED"
               If lVoucherIsPrinting Then
                  ' Reset MACH_SETUP.VOUCHER_PRINTING_FLAG to 0, to indicate that Voucher finished printing.
                  ResetVoucherPrintingFlag()
                  mVoucherCreatePending = False
               End If
               lResponseHash = HandleVoucherPrinted(MessageHash)

            Case "VOUCHERPRINTFAILED"
               If lVoucherIsPrinting Then
                  ' Reset MACH_SETUP.VOUCHER_PRINTING_FLAG to 0, to indicate that Voucher finished printing.
                  ResetVoucherPrintingFlag()
                  mVoucherCreatePending = False
               End If
               lResponseHash = HandleVoucherPrintFailed(MessageHash)

            Case "HANDPAY"
               If lVoucherIsPrinting Then
                  ' Reset MACH_SETUP.VOUCHER_PRINTING_FLAG to 0, indicates no longer waiting for Voucher to finish printing.
                  ResetVoucherPrintingFlag()
               End If
               ' For a DGE_TITO HANDPAY update the VOUCHER.VOUCHER_TYPE col. to 2
               HandleHandPay(MessageHash)
               ' Execute the stored procedure with the appropriate parmameters for this TransType
               lResponseHash = HandleTransaction(MessageHash)

               ' Modified Case from: "BINGO", "ETAB", "F", "J", "L", "M", "PROGC3PLAY", "T", "TRANSFERDONE", "W"
            Case "BINGO", "ETAB", "F", "PROGC3PLAY", "T", "TRANSFERDONE"
               ' For all Play & Money trans.
               If lVoucherIsPrinting Then
                  ' Send Error 137 if we are waiting for VoucherPrinted/HandPay
                  lResponseHash = SendErrorResponseToMachine(MessageHash, 137)
               Else
                  ' Execute the stored procedure with the appropriate parmameters for this TransType
                  lResponseHash = HandleTransaction(MessageHash)
               End If

            Case "M", "W", "J", "L"
               ' For all play and money trans.
               If lVoucherIsPrinting Then
                  ' Send Error 137 if we are waiting for VoucherPrinted/HandPay
                  lResponseHash = SendErrorResponseToMachine(MessageHash, 137)
               Else

                  ' Is the machine message valid?
                  If CheckForDuplicateMessage(MessageHash) Then
                     ' Resend the last TPResponse.
                     lResponseHash = ResendTPResponse()
                  End If

                  If lResponseHash.Count <= 0 Then
                     ' Execute the stored procedure with the appropriate parmameters for this TransType
                     lResponseHash = HandleTransaction(MessageHash)

                     ' Attempt to insert/update TPResponse in database.
                     mLastMachineResponse = SaveLastMachineMessage(lResponseHash)
                  End If
               End If

            Case "BINGOPATTERNS", "PROGRESSIVESETUP"
               If lVoucherIsPrinting Then
                  ' Send Error 137 if we are waiting for VoucherPrinted/HandPay
                  lResponseHash = SendErrorResponseToMachine(MessageHash, 137)
               Else
                  ' Execute the stored procedure with the appropriate parmameters for this TransType
                  lResponseHash = HandleTransaction(MessageHash)
               End If

            Case "KEEPALIVE"
               ' This is a special message that the machine sends but that the TP will ignore.
               ' If the logging level is verbose, write a log entry...
               If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("Received KeepAlive"))
               ' Execute the stored procedure with the appropriate parmameters for this TransType
               lResponseHash = HandleTransaction(MessageHash)


            Case Else
               ' Execute the stored procedure with the appropriate parmameters for this TransType
               lResponseHash = HandleTransaction(MessageHash)

         End Select

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("TpiClient::HandleMessage error: " & ex.ToString))
         lResponseHash = SendErrorResponseToMachine(MessageHash, 237)

      End Try

      ' Tell the TP we are ready to send data to it.
      RaiseEvent ReadyForTP(lResponseHash)

   End Sub

   Public Function HandleTransaction(ByVal MessageHT As Hashtable) As Hashtable
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As New Hashtable
      Dim lSB As StringBuilder

      Dim lDB As Database = Nothing
      Dim lDBBingo As Database = Nothing
      Dim lDS As DataSet
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lParameters As ArrayList

      Dim lErrorID As Integer

      Dim lErrorDesc As String
      Dim lParameterName As String
      Dim lTransType As String
      Dim lTransTypeUC As String
      Dim lValueText As String


      Try
         ' Get the "TransType"
         lTransType = CType(MessageHT("TransType"), String)
         lTransTypeUC = lTransType.ToUpper

         ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
         Call BuildResponseHeader(lReturn, MessageHT)

         ' Get the list of parameters for this request.
         lParameters = mTransaction.GetRequest(lTransType)

         If lTransTypeUC = "BINGO" Then
            ' First check if we have the Minimum # of bingo players per app.config.
            ' Connect to the Casino database.
            lDB = New Database(mConnectionString)

            ' Add the "@MiniumCount" parm. which is the Minimum # of bingo players
            lDB.AddParameter("@MiniumCount", mMachine.BingoMinimumPlayers.ToString)

            ' Execute the stored procedure.
            lDS = lDB.ExecuteProcedure("tpGetActiveMachineCount")

            ' Check if the "ErrorID" is NON-Zero
            lDR = lDS.Tables(0).Rows(0)
            If (CInt(lDR.Item("ErrorID")) <> 0) Then
               ' Fill the Return HashTable with the Error values
               With lReturn
                  .Add("ErrorID", CStr(lDR.Item("ErrorID")))
                  .Add("ErrorDescription", CStr(lDR.Item("ErrorDescription")))
                  .Add("ShutDownFlag", CStr(lDR.Item("ShutDownFlag")))
                  .Add("MasterDealNumber", "")
                  .Add("GameNumber", "")
                  .Add("PatternID", "")
                  .Add("BallDrawData", "")
                  .Add("Barcode", "")
               End With
            Else
               ' We have the minimnum # of players. Process the "Bingo" trans.
               ' Connect to the CasinoBingo database.
               lDBBingo = New Database(mMachine.BingoDBConnectionString)

               ' Add the "MachineNumber" parameter.
               lDBBingo.AddParameter("@MachineNumber", CType(MessageHT("MachineNumber"), String))

               ' Add other parameters
               For Each lParameterName In lParameters
                  ' Following parameter values come from Machine class.
                  If lParameterName.Equals("GameTypeCode") Then
                     lDBBingo.AddParameter("@GameTypeCode", mMachine.GameTypeCode)
                  ElseIf lParameterName.Equals("FreeSquare") Then
                     lDBBingo.AddParameter("@FreeSquare", CType(mMachine.BingoFreeSquare, String))
                  ElseIf lParameterName.Equals("CVLoggingLevel") Then
                     lDBBingo.AddParameter("@CVLoggingLevel", CType(mMachine.BingoLoggingLevel, String))
                  Else
                     ' Following parameter values come from the Message.
                     lDBBingo.AddParameter("@" & lParameterName, CType(MessageHT(lParameterName), String))
                  End If
               Next

               ' Execute "tpTransBingo"
               lDS = lDBBingo.ExecuteProcedure(mTransaction.GetStoredProcedure(lTransType))

               ' Get the list of parameters for this response.
               lParameters = mTransaction.GetResponse(lTransType)

               ' Add the parameters to the response hash. 
               For Each lParameterName In lParameters
                  lReturn.Add(lParameterName, CType(lDS.Tables(0).Rows(0).Item(lParameterName), String))
               Next

               ' Lookup up the "ErrorDescription" and "ShutDownFlag" because
               ' it is not returned by "tpTransBingo"
               If (CInt(lReturn("ErrorID")) = 0) Then
                  ' no Errors set ErrorDescription ="", ShutDownFlag to 0
                  lReturn.Add("ErrorDescription", "")
                  lReturn.Add("ShutDownFlag", "0")
               Else
                  ' Connect to the "Casino" db to get ErrorDescription and ShutDownFlag
                  ' corresponding to this "Bingo" ErrorID
                  lDB = New Database(mConnectionString)
                  lDB.AddParameter("@Error_No", lReturn("ErrorID").ToString())
                  lDS = lDB.ExecuteProcedure("tpGetErrorDescription")

                  lDR = lDS.Tables(0).Rows(0)
                  lReturn.Add("ErrorDescription", CType(lDR.Item("ErrorDescription"), String))
                  lReturn.Add("ShutDownFlag", CType(lDR.Item("ShutDownFlag"), String))
               End If
            End If

         ElseIf lTransTypeUC = "BINGOPATTERNS" Then
            ' Connect to the CasinoBingo database.
            lDBBingo = New Database(mMachine.BingoDBConnectionString)

            For Each lParameterName In lParameters
               ' Following parameter values come from Machine class.
               If lParameterName.Equals("GameTypeCode") Then
                  lDBBingo.AddParameter("@GameTypeCode", mMachine.GameTypeCode)
               Else
                  ' Following parameter values come from the Message.
                  lDBBingo.AddParameter("@" & lParameterName, CType(MessageHT(lParameterName), String))
               End If
            Next

            ' Execute "tpTransBingoPatterns"
            lDS = lDBBingo.ExecuteProcedure(mTransaction.GetStoredProcedure(lTransType))
            ' Get the list of parameters for this response.
            lParameters = mTransaction.GetResponse(lTransType)

            ' Add the parameters to the response hash. 
            For Each lParameterName In lParameters
               lReturn.Add(lParameterName, CType(lDS.Tables(0).Rows(0).Item(lParameterName), String))
            Next

            ' Lookup up the "ErrorDescription" and "ShutDownFlag" because
            ' it is not returned by "tpTransBingoPatterns"
            If (CInt(lReturn("ErrorID")) = 0) Then
               ' no Errors set ErrorDescription ="", ShutDownFlag to 0
               lReturn.Add("ErrorDescription", "")
               lReturn.Add("ShutDownFlag", "0")
            Else
               ' Connect to the "Casino" db to get ErrorDescription and ShutDownFlag
               ' corresponding to this "Bingo" ErrorID
               lDB = New Database(mConnectionString)
               lDB.AddParameter("@Error_No", lReturn("ErrorID").ToString())
               lDS = lDB.ExecuteProcedure("tpGetErrorDescription")

               lDR = lDS.Tables(0).Rows(0)
               lReturn.Add("ErrorDescription", CType(lDR.Item("ErrorDescription"), String))
               lReturn.Add("ShutDownFlag", CType(lDR.Item("ShutDownFlag"), String))
            End If

         ElseIf lTransTypeUC = "PROGRESSIVESETUP" Then
            ' Process "ProgressiveSetup" transaction request.
            ' Connect to the Casino database.
            lDB = New Database(mConnectionString)

            ' Add the "MachineNumber" parameter.
            lDB.AddParameter("@MachineNumber", CType(MessageHT("MachineNumber"), String))

            ' Execute the stored procedure.
            lDS = lDB.ExecuteProcedure(mTransaction.GetStoredProcedure(lTransType))
            lDR = lDS.Tables(0).Rows(0)
            lErrorID = CType(lDR("ErrorID"), Integer)
            lErrorDesc = CType(lDR.Item("ErrorDescription"), String)


            ' Get the "ErrorID", "ErrorDescription", "ShutDownFlag"
            lReturn.Add("ErrorID", lErrorID.ToString)
            lReturn.Add("ErrorDescription", lErrorDesc)
            lReturn.Add("ShutDownFlag", CType(lDR.Item("ShutDownFlag"), String))

            ' Add the above "GameConfigData" to the output hash-table
            lReturn.Add("GameConfigData", CType(lDR.Item(3), String))

         ElseIf lTransTypeUC = "PLAYSTATUS" Then
            ' Process "ProgressiveSetup" transaction request.
            ' Connect to the Casino database.
            lDB = New Database(mConnectionString)

            ' Add the "MachineNumber" parameter.
            lDB.AddParameter("@MachineNumber", CType(MessageHT("MachineNumber"), String))
            lDB.AddParameter("@PlayStatus", CType(MessageHT("PlayStatus"), String))
            lDB.AddParameter("@TimeStamp", CType(MessageHT("TimeStamp"), String))

            ' Execute the stored procedure.
            lDS = lDB.ExecuteProcedure(mTransaction.GetStoredProcedure(lTransType))
            lDR = lDS.Tables(0).Rows(0)

            ' Get the "ErrorID", "ErrorDescription", "ShutDownFlag"
            lReturn.Add("ErrorID", CType(lDR.Item("ErrorID"), String))
            lReturn.Add("ErrorDescription", CType(lDR.Item("ErrorDescription"), String))
            lReturn.Add("ShutDownFlag", CType(lDR.Item("ShutDownFlag"), String))

         ElseIf lTransTypeUC = "ENTRYTICKETPRINTED" Then
            ' Process "ProgressiveSetup" transaction request.
            ' Connect to the Casino database.
            lDB = New Database(mConnectionString)

            ' Add the "MachineNumber" parameter.
            lDB.AddParameter("@MachineNumber", CType(MessageHT("MachineNumber"), String))
            lDB.AddParameter("@PromoEntryType", CType(MessageHT("PromoEntryType"), String))
            lDB.AddParameter("@TimeStamp", CType(MessageHT("TimeStamp"), String))

            ' Execute the stored procedure.
            lDS = lDB.ExecuteProcedure(mTransaction.GetStoredProcedure(lTransType))
            lDR = lDS.Tables(0).Rows(0)

            ' Get the "ErrorID", "ErrorDescription", "ShutDownFlag"
            lReturn.Add("ErrorID", CType(lDR.Item("ErrorID"), String))
            lReturn.Add("ErrorDescription", CType(lDR.Item("ErrorDescription"), String))
            lReturn.Add("ShutDownFlag", CType(lDR.Item("ShutDownFlag"), String))

         ElseIf lTransTypeUC = "KEEPALIVE" Then
            ' Machine sent a keepalive, we will return a no-error response.
            With lReturn
               .Add("ErrorID", "0")
               .Add("ErrorDescription", "")
               .Add("ShutDownFlag", "0")
            End With

         ElseIf lTransTypeUC = "EGMFLARE" OrElse lTransTypeUC = "DEALSTATS" Then
            ' Process "EGMFlare" or "DealsStats" transaction request.
            ' Connect to the Casino database.
            lDB = New Database(mConnectionString)

            ' Add the "MachineNumber" parameter.
            lDB.AddParameter("@MachineNumber", CType(MessageHT("MachineNumber"), String))

            ' Execute the stored procedure.
            lDS = lDB.ExecuteProcedure(mTransaction.GetStoredProcedure(lTransType))
            lDR = lDS.Tables(0).Rows(0)
            lErrorID = CType(lDR("ErrorID"), Integer)
            lErrorDesc = CType(lDR.Item("ErrorDescription"), String)


            ' Get the "ErrorID", "ErrorDescription", "ShutDownFlag"
            lReturn.Add("ErrorID", lErrorID.ToString)
            lReturn.Add("ErrorDescription", lErrorDesc)
            lReturn.Add("ShutDownFlag", CType(lDR.Item("ShutDownFlag"), String))

            ' Add the above "GameConfigData" to the output hash-table
            lReturn.Add("GameConfigData", CType(lDR.Item(3), String))

         ElseIf lTransTypeUC = "R" Then
            ' Process "R" trans.

            ' Connect to the Casino database.
            lDB = New Database(mConnectionString)

            ' Add the "MachineNumber" parameter.
            lDB.AddParameter("@MachineNumber", CType(MessageHT("MachineNumber"), String))

            ' Add the "TpVersion" parm. which is the version of this executing TP. (eg. 6.0.2.0)
            ' lDB.AddParameter("@TpVersion", System.Reflection.Assembly.GetExecutingAssembly.GetName.Version.ToString)
            lDB.AddParameter("@TpVersion", My.Application.Info.Version.ToString)


            ' Execute the stored procedure.
            lDS = lDB.ExecuteProcedure(mTransaction.GetStoredProcedure(lTransType))

            ' Check for payscale tier overflow...
            lDT = lDS.Tables(2)
            lValueText = CType(lDT.Rows(0).Item(0), String).ToUpper
            If lValueText.Contains("PAYSCALE TIER OVERFLOW") Then
               lReturn.Add("ErrorID", "139")
               lReturn.Add("ErrorDescription", "Payscale Tier Overflow.")
               lReturn.Add("ShutDownFlag", "1")
               lReturn.Add("GameConfigData", "")
            Else
               ' Get the "ErrorID", "ErrorDescription", "ShutDownFlag"
               lReturn.Add("ErrorID", "0")
               lReturn.Add("ErrorDescription", "")
               lReturn.Add("ShutDownFlag", "0")

               ' 6 selects take place so load results of each.
               lSB = New StringBuilder

               For Each lDT In lDS.Tables
                  ' Append the results of each select to the StringBuilder
                  lSB.Append(CType(lDT.Rows(0).Item(0), String))
               Next

               ' Remove the trailing delimiter.
               lSB.Remove(lSB.Length - 1, 1)

               ' Add the above "GameConfigData" to the output hash-table
               lReturn.Add("GameConfigData", lSB.ToString)
            End If

         ElseIf lTransTypeUC = "X" Then
            ' Connect to the Casino database.
            lDB = New Database(mConnectionString)

            ' Add the "MachineNumber" parameter which is required by all stored procedures.
            lDB.AddParameter("@MachineNumber", CType(MessageHT("MachineNumber"), String))

            Dim errorText As String = CType(MessageHT("error"), String)
            Dim ticketNumber As String = ""
            If errorText.Contains("+") Then
               Dim tempSplit As String() = errorText.Split("+".ToCharArray())
               MessageHT("error") = CType(tempSplit(0), Integer)
               ticketNumber = tempSplit(1)
            End If

            MessageHT.Add("TicketNumber", ticketNumber)

            ' Add the parameters to the parameter collection. 
            For Each lParameterName In lParameters
               lDB.AddParameter("@" & lParameterName, CType(MessageHT(lParameterName), String))
            Next

            ' Execute the stored procedure.
            lDS = lDB.ExecuteProcedure(mTransaction.GetStoredProcedure(lTransType))

            ' Get the list of parameters for this response.
            lParameters = mTransaction.GetResponse(lTransType)

            ' Add the parameters to the response hash. 
            For Each lParameterName In lParameters
               lReturn.Add(lParameterName, CType(lDS.Tables(0).Rows(0).Item(lParameterName), String))
            Next

         Else
            ' Process Standard Messages. ("W","L","M" etc.)
            ' Connect to the Casino database.
            lDB = New Database(mConnectionString)

            ' Add the "MachineNumber" parameter which is required by all stored procedures.
            lDB.AddParameter("@MachineNumber", CType(MessageHT("MachineNumber"), String))

            ' Add the parameters to the parameter collection. 
            For Each lParameterName In lParameters
               lDB.AddParameter("@" & lParameterName, CType(MessageHT(lParameterName), String))
            Next

            ' Execute the stored procedure.
            lDS = lDB.ExecuteProcedure(mTransaction.GetStoredProcedure(lTransType))

            ' Get the list of parameters for this response.
            lParameters = mTransaction.GetResponse(lTransType)

            If lTransType = "Progressive" Then
               Dim machineList As List(Of String) = GetProgressiveMachines(CType(MessageHT("MachineNumber"), String))
               RaiseEvent NotifyProgressiveMachines(machineList)
            End If

            ' Add the parameters to the response hash. 
            For Each lParameterName In lParameters
               lReturn.Add(lParameterName, CType(lDS.Tables(0).Rows(0).Item(lParameterName), String))
            Next

         End If

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" Error: " & ex.ToString))
         lReturn = SendErrorResponseToMachine(MessageHT, 237)

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

         If lDBBingo IsNot Nothing Then
            lDBBingo.Dispose()
            lDBBingo = Nothing
         End If

      End Try

      ' Return the ReturnHashtable.
      Return lReturn

   End Function

   Private Function SendErrorResponseToMachine(ByRef MessageHT As Hashtable, ByVal aErrorID As Integer) As Hashtable
      '--------------------------------------------------------------------------------
      '   Purpose: Returns a hashtable that contains the output message for
      '            Unknown Error.
      '
      ' Called by: HandleMessage, HandleTransaction
      '     Calls: DbGetTpErrorDescription
      '
      ' Unknown error in Catch block of HandleMessage = 237 or 
      ' Waiting for Voucher to print. Please call Attendant. = 137
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lResponseHash As Hashtable
      Dim lTransType As String

      ' Get error description.
      lResponseHash = DbTpGetErrorDescription(aErrorID)

      ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
      Call BuildResponseHeader(lResponseHash, MessageHT)

      ' Store the transaction type.
      lTransType = CType(MessageHT("TransType"), String).ToUpper


      Select Case lTransType
         Case "A"
            ' For an Exception from an "A" trans add the "Command" & "GameConfigData" fields also
            lResponseHash.Add("Command", "")
            lResponseHash.Add("GameConfigData", "")

         Case "BINGO"
            ' For an Exception from an "Bingo" trans add the "MasterDealNumber, GameNumber, PatternID,
            ' BallDrawData, Barcode fields also.
            lResponseHash.Add("MasterDealNumber", "")
            lResponseHash.Add("GameNumber", "")
            lResponseHash.Add("PatternID", "")
            lResponseHash.Add("BallDrawData", "")
            lResponseHash.Add("Barcode", "")

         Case "BINGOPATTERNS"
            ' For an Exception from an "BingoPatterns" trans add the "PatternCount" & "GameConfigData" fields also
            lResponseHash.Add("PatternCount", "")
            lResponseHash.Add("GameConfigData", "")

         Case "CARDINSERTED"
            ' For an Exception from an "CardInserted" transadd the "VariableCount" & "GameConfigData" fields also
            lResponseHash.Add("VariableCount", "")
            lResponseHash.Add("GameConfigData", "")

         Case "ETAB"
            ' For an Exception from an "ETAB" trans add the "DealNumber" & "Barcode" fields also
            lResponseHash.Add("DealNumber", "")
            lResponseHash.Add("Barcode", "")

         Case "H"
            ' For an Exception from an "H" trans add RollNumber and IsMicroTab fields.
            lResponseHash.Add("RollNumber", "")
            lResponseHash.Add("IsMicroTab", "")

         Case "I"
            ' For an Exception from an "I" trans add the "Balance","AccessLevel","PromoBalance" fields also
            lResponseHash.Add("Balance", "")
            lResponseHash.Add("AccessLevel", "")
            lResponseHash.Add("PromoBalance", "")

         Case "J"
            ' For an Exception from an "J" trans add the "Balance" field also
            lResponseHash.Add("Balance", "")
            ' Also force ShutDownFlag = 1 to prevent bad Machine Balance. Dom (1/25/2008)
            lResponseHash("ShutDownFlag") = "1"

         Case "PROGRESSIVE"
            ' For an Exception from an "Progressive" trans add the "ProgressiveAmount" field also
            lResponseHash.Add("ProgressiveAmount", "")

         Case "R"
            ' For an Exception from an "R" trans add the "GameConfigData" field also
            lResponseHash.Add("GameConfigData", "")

         Case "SYSBAL"
            ' For an Exception from an "SysBal" trans add the "Balance", "PromoBalance" fields also
            lResponseHash.Add("Balance", "")
            lResponseHash.Add("PromoBalance", "")

         Case "T"
            ' For an Exception from an "T" trans add the "DealNumber" & "Barcode" fields also
            lResponseHash.Add("DealNumber", "")
            lResponseHash.Add("Barcode", "")

         Case "VOUCHERCREATE"
            ' For an Exception from an "VoucherCreate" trans add the "VoucherText" field also
            lResponseHash.Add("VoucherText", "")

         Case "VOUCHERREDEEM"
            ' For an Exception from an "VoucherRedeem" trans add the "VoucherValue","CreditType" fields also
            lResponseHash.Add("VoucherValue", "")
            lResponseHash.Add("CreditType", "")

      End Select

      Return lResponseHash

   End Function

#Region " Voucher Functionality "

   Private Function HandleVoucherCreate(ByRef MessageHash As Hashtable) As Hashtable
      '--------------------------------------------------------------------------------
      '   Purpose: to check if the request for VoucherCreate meets all the checks for
      '            TpiID, Barcode, VoucherPreValidate, Voucher insert etc.
      '
      ' Called by: HandleMessage
      '
      '     Calls: GetNewBarcode, DbTpTransVPV, DbTpInsertVoucher,
      '            DoVoucherCreate, DoVoucherCreateError
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lJackpotFlag As Integer

      Dim lTPIValue As String

      Dim lResponseHash As New Hashtable
      Dim lHT As New Hashtable

      ' Make sure we are not getting back-to-back VoucherCreates
      If Not mVoucherCreatePending Then
         ' Check if we have a good TPI_ID
         If mTpiID <> -1 Then
            ' Get the new Barcode from the TICKS value of the Date obtained by adding/subtracting
            ' a random year value between 1-2000 from the current DateTime.
            mBarcode = GetNewBarcode()
            If mBarcode.Length = 18 Then
               ' Get the OldChecksum from Barcode, Amount, RedeemedStatus("0")
               mOldChecksum = GetChecksum(mBarcode, CType(MessageHash("TransAmount"), String), "0")
               If mOldChecksum IsNot Nothing Then
                  ' PreValidate the Voucher
                  If DbTpTransVPV(MessageHash) Then
                     ' Check DbErrorId in MessagHash which holds error from tpTransVPV
                     If CType(MessageHash("DbErrorId"), Int32) = 0 Then
                        ' Check ErrorID in output Hashtable which holds error from tpInsertBarcode
                        lHT = DbTpInsertVoucher(MessageHash)
                        If CType(lHT("ErrorID"), Int32) = 0 Then
                           ' Set the Voucher_ID to be used in HandleVoucherPrinted, DoVoucherCreate
                           mVoucherID = CType(lHT("VoucherID"), Integer)

                           ' Check if we have a valid CasName & CityStateZip in Machine properties
                           If ((mMachine.CasName.Length > 0) And (mMachine.CityStateZip.Length > 0)) Then
                              ' Check if we are processing Jackpot or Cashout voucher.
                              lJackpotFlag = CType(MessageHash("JackpotFlag"), Integer)

                              ' Set the jackpot flag value.
                              mIsJackpot = (lJackpotFlag = 1)

                              ' Convert TPI ID value to a string
                              lTPIValue = mMachine.TpiID.ToString

                              ' Obtain the ErrorID & TicketTemplate from the TPI_SETTING table.
                              lHT = New Hashtable

                              If mIsJackpot Then
                                 ' For Jackpot vouchers get "Jackpot_Receipt_Template 
                                 lHT = DbTpGetTpiSetting(lTPIValue, "Jackpot_Receipt_Template")
                              Else
                                 ' For ordinary vouchers get "Cashout_Ticket_Template"
                                 lHT = DbTpGetTpiSetting(lTPIValue, "Cashout_Ticket_Template")
                              End If

                              ' Check for Error in tpGetTpiSetting call
                              If (CType(lHT("ErrorID"), Integer) = 0) Then
                                 ' ALL tests passed. Invoke VoucherCreate with TicketTemplate in "ItemValue"
                                 lResponseHash = DoVoucherCreate(CType(lHT("ItemValue"), String), MessageHash, mMachine.CasName, mMachine.CasinoAddress, mMachine.CityStateZip)
                              Else
                                 ' tpTpiGetSetting: Error Return. ErrorID = 708
                                 lResponseHash = DoVoucherCreateError(MessageHash, 708)
                              End If '(CType(lHT("ErrorID"), Integer) = 0)
                           Else
                              ' tpGetCasinoInfo failed to return good data. ErrorID = 733
                              lResponseHash = DoVoucherCreateError(MessageHash, 733)
                           End If '((mMachine.CasName.Length > 0) And (mMachine.CityStateZip.Length > 0))
                        Else
                           ' DbTpInsertVoucher returned Nonzero Error code. Voucher insertion failed. ErrorID = 701/702
                           lResponseHash = DoVoucherCreateError(MessageHash, CType(lHT("ErrorID"), Integer))
                           ' set the VoucherID to 0 to indicate failed Voucher insert
                           mVoucherID = 0
                        End If 'CType(lHT("ErrorID"), Int32) = 0
                     Else
                        ' DbTpTransVPV returned Nonzero Error code. Voucher Pre-Validation failed. ErrorID = 731
                        lResponseHash = DoVoucherCreateError(MessageHash, 731)
                     End If 'CType(MessageHash("DbErrorId"), Int32) = 0
                  Else
                     ' DbTpTransVPV returned False. Voucher Pre-Validation failed. ErrorID = 707
                     lResponseHash = DoVoucherCreateError(MessageHash, 707)
                  End If 'DbTpTransVPV(MessageHash)
               Else
                  ' GetChecksum did not return a valid checksum. ErrorID = 734
                  lResponseHash = DoVoucherCreateError(MessageHash, 734)
               End If ' Not mOldChecksum Is Nothing
            Else
               ' GetNewBarcode did not return 18 chars. ErrorID = 730
               lResponseHash = DoVoucherCreateError(MessageHash, 730)
            End If 'mBarcode.Length = 18
         Else
            ' CASINO.TPI_ID is bad,  ErrorID = 726
            lResponseHash = DoVoucherCreateError(MessageHash, 726)
         End If 'mTpiID <> -1
      Else
         ' Back-to-back VoucherCreate received set ErrorID = 710
         lResponseHash = DoVoucherCreateError(MessageHash, 710)
      End If 'Not mVoucherCreatePending

      Return lResponseHash

   End Function

   Private Function HandleCashOut(ByRef MessageHT As Hashtable) As Hashtable
      '--------------------------------------------------------------------------------
      '   Purpose: Handles request for Iowa CashOut.
      '            Makes entries in "RECEIPT" table & fixes balance in MACH_SETUP.
      ' Called by: HandleMessage
      '     Calls: tpTransCashout
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow

      Dim lErrorID As Integer = 0

      Dim lHashtable As New Hashtable

      Dim lErrorDescription As String = ""
      Dim lShutDownFlag As String = "0"
      Dim lValueText As String = ""

      ' Invoke stored procedure "tpTransCashOut"
      Try
         ' Test the connection to the database.
         lDB = New Database(mConnectionString)

         ' Add input parameters...
         lDB.AddParameter("@MachineNumber", mMachine.MachineNumber)
         lDB.AddParameter("@TransAmt", CType(MessageHT("TransAmount"), String))
         lDB.AddParameter("@MachineBalance", CType(MessageHT("MachineBalance"), String))

         ' Check for NULL (empty string) in DealNumber field
         lValueText = CType(MessageHT("DealNumber"), String)
         If lValueText.Length > 0 Then
            lDB.AddParameter("@DealNumber", lValueText)
         End If

         lDB.AddParameter("@ReceiptNumber", CType(MessageHT("ReceiptNumber"), String))

         ' Check for NULL (empty string) in ValidationNumber field
         lValueText = CType(MessageHT("ValidationNumber"), String)
         If lValueText.Length > 0 Then
            lDB.AddParameter("@ValidationNumber", lValueText)
         End If

         lDB.AddParameter("@ReceiptDate", CType(MessageHT("ReceiptDate"), String))

         ' Execute procedure "tpTransCashOut" for Lottery cashout.
         lDS = lDB.ExecuteProcedure("tpTransCashOut")

         ' Set a reference to the first returned row.
         lDR = lDS.Tables(0).Rows(0)

         lErrorID = CType(lDR.Item("ErrorID"), Integer)
         lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
         lShutDownFlag = CType(lDR.Item("ShutDownFlag"), String)

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" Error: Unable to complete 'tpTransCashOut' transaction. Reason: " & ex.ToString))

         ' 732 : "tpTransCashOut DB Error"
         Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(732)
         lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
         lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
         lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If
      End Try

      Try
         ' Create the output Hashtable
         ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
         Call BuildResponseHeader(lHashtable, MessageHT)

         lHashtable.Add("ErrorID", lErrorID.ToString)
         lHashtable.Add("ErrorDescription", lErrorDescription)
         lHashtable.Add("ShutDownFlag", lShutDownFlag)

         ' Return the Hashtable
         Return lHashtable

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" Error: unable to complete 'HandleCashOut' Reason : " & ex.ToString))
         ' Indicate error
         Return Nothing

      End Try

   End Function

   Private Function GetNewBarcode() As String
      '--------------------------------------------------------------------------------
      ' Uses the current MilliSecond as seed to generated a random # between 1-2000.
      ' It then add/subtracts this to the current year. Then converts that date into Ticks.
      ' It then calls IsDuplicateBarcode to check for duplicates.
      '
      ' Called by: HandleVoucherCreate
      '     Calls: IsDuplicateBarcode
      '
      ' Added code to add last 3 digits of machine number to Barcode value to prevent
      ' duplicate barcodes generated at the same time.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lCurrentDateTime As DateTime
      Dim lNewDateTime As DateTime

      Dim lIndex As Short
      Dim lMachAddVal As Integer
      Dim lRandomValue As Integer
      Dim lTicks As Long

      Dim lValidationID As String
      Dim lReturn As String = ""


      Try
         lMachAddVal = Integer.Parse(mMachine.MachineNumber) Mod 1000

         ' Try 10 times to get a voucher without duplicates.
         For lIndex = 1 To 10
            lCurrentDateTime = DateTime.Now

            ' Generate a random value in the range 1-2000.
            lRandomValue = mRng.Next(1, 2001)

            If (lRandomValue > 1000) Then
               ' Add all years over a 1000 to the current year to obtain the NewTime.
               lNewDateTime = lCurrentDateTime.AddYears(lRandomValue - 1000)
            Else
               ' Subtract this from the current year to obtain the NewTime.
               lNewDateTime = lCurrentDateTime.AddYears(-lRandomValue)
            End If

            ' Convert the NewTime to TICKS and add the machine add value.
            lTicks = lNewDateTime.Ticks + lMachAddVal

            Dim lLocationIDLength As Integer = mMachine.LocationID.ToString().Length

            If (lLocationIDLength = 4) Then
               ' generate Ontario Validation ID
               lValidationID = mMachine.LocationID.ToString & lTicks.ToString.Substring(4, 14)

            ElseIf (lLocationIDLength = 6) Then

               lValidationID = mMachine.LocationID.ToString & Right(lTicks.ToString(), 12)

            Else
               Throw New Exception("Invalid LocationID value. Must be either 4 digits or 6 digits in length")
            End If


            If mTraceSwitch.TraceVerbose Then
               Trace.WriteLine(FormatLogOutput("GetNewBarcode created: " & lValidationID))
            End If

            ' Now check to see if this barcode ALREADY exists in the database.
            If Not IsDuplicateBarcode(lValidationID) Then
               ' Unique barcode found, set the return value.
               lReturn = lValidationID

               ' Exit the search for duplicates loop.
               Exit For
            Else
               ' Set New barcode to empty string to indicate failure.
               lReturn = ""
            End If

            ' If still in the loop, a Duplicate Barcode was found.
            ' Create a new sequence of random values by creating a new instance of Random with a new seed value.
            mRng = New Random(Convert.ToInt32(Date.Now.Ticks And Integer.MaxValue))
         Next

      Catch ex As Exception
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("GetNewBarcode Error: " & ex.ToString))
         ' Set New barcode to empty string to indicate failure.
         lReturn = ""
      End Try

      ' Return the new Barcode as string
      Return lReturn

   End Function

   Private Function GetChecksum(ByVal aBarcode As String, ByVal aAmount As String, ByVal aRedeemedState As String) As Byte()
      '--------------------------------------------------------------------------------
      '   Purpose: To find new checksum by adding all the digits in the concatenated Barcode, Amount & RedeemedState.
      '            Then feed the Checksum to Encrypt routine, and return the encrypted value as an Array of bytes.
      ' Called by: HandleVoucherCreate
      '     Calls: Encryption.Encrypt
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lEncrypt As New Encryption
      Dim lSB As New StringBuilder

      Dim lEncryptedBytes As Byte() = Nothing

      Dim lTempValue As String

      Dim lIt As Integer
      Dim lCheckSum As Integer = 0

      Try
         ' Concatenate the Incoming Barcode, Amount, RedeemedState
         lSB.Append(aBarcode).Append(aAmount).Append(aRedeemedState)
         lTempValue = lSB.ToString

         ' Walk the above concatenated string and add each digit with the previous result
         For lIt = 0 To lTempValue.Length - 1
            lCheckSum += Integer.Parse(lTempValue.Chars(lIt))
         Next

         ' If the Length of the Checksum is less than 3 digits, then pad with a leading "0"
         lTempValue = lCheckSum.ToString("000")

         ' Get the Encrypted value
         lEncryptedBytes = lEncrypt.Encrypt(lTempValue)

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("GetChecksum Error: " & ex.ToString))

         ' Set Encrypted result to null byte array to indicate failure.
         lEncryptedBytes = Nothing

      End Try

      Return lEncryptedBytes

   End Function

   Private Function DoVoucherCreate(ByVal aTicketTemplate As String, _
                                    ByRef MessageHash As Hashtable, _
                                    ByVal aCasinoName As String, _
                                    ByVal aCasinoAddress As String, _
                                    ByVal aCityStateZip As String) As Hashtable
      '--------------------------------------------------------------------------------
      '   Purpose: Builds the output Hashtable for VoucherCreate for "Cashout/Jackpot".
      ' Called by: HandleVoucherCreate after all the tests have passed.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lHashTable As New Hashtable

      Dim lSB As New StringBuilder

      Dim lCents As Integer
      Dim lDollars As Integer
      Dim lErrorID As Integer = 0

      Dim lVoucherDecimalValue As Decimal

      Dim lBarCodeWithDashes As String
      Dim lDelimiter As String = "|"
      Dim lErrorDescription As String = ""
      Dim lFormattedText As String
      Dim lMoneyText As String
      Dim lShutDownFlag As String = "0"
      Dim lVoucherText As String = ""
      Dim lVoucherValue As String = CType(MessageHash("TransAmount"), String)

      Dim lFields As String()

      ' Log function invocation if appropriate...
      If mTraceSwitch.TraceVerbose Then
         Trace.WriteLine(FormatLogOutput("DoVoucherCreate processing Barcode= " & mBarcode))
      End If

      Try
         ' Build the formatted bar code with Dashes eg. 5-002-002-01-00016-728-8
         lBarCodeWithDashes = mBarcode
         lBarCodeWithDashes = lBarCodeWithDashes.Insert(1, "-")
         lBarCodeWithDashes = lBarCodeWithDashes.Insert(5, "-")
         lBarCodeWithDashes = lBarCodeWithDashes.Insert(9, "-")
         lBarCodeWithDashes = lBarCodeWithDashes.Insert(12, "-")
         lBarCodeWithDashes = lBarCodeWithDashes.Insert(18, "-")
         lBarCodeWithDashes = lBarCodeWithDashes.Insert(22, "-")

         lDollars = CType(MessageHash("TransAmount"), Integer) \ 100
         lCents = CType(MessageHash("TransAmount"), Integer) Mod 100

         If lDollars = 0 Then
            lMoneyText = " NO"
         Else
            lMoneyText = " " & Utility.NumericToText(lDollars).Trim
         End If
         lMoneyText &= " Dollars And " & Utility.NumericToText(lCents).Trim & " Cents"

         ' Split the "|" delimited input "aTicketTemplate" into an array.
         lFields = aTicketTemplate.Split("|"c)

         lVoucherDecimalValue = CType(lVoucherValue, Decimal) / 100
         ' Convert input string into money format eg. $1234.56
         ' lFormattedText = FormatCurrency(lVoucherDecimalValue, 2, TriState.False, TriState.False, TriState.True)
         lFormattedText = lVoucherDecimalValue.ToString("c")

         ' Generate the VoucherText for the "Jackpot"
         If mIsJackpot Then
            ' Build the VoucherText : ^P|4|
            lSB.Append(lFields(0)).Append(lDelimiter).Append(lFields(1)).Append(lDelimiter)
            ' 1|00-0000-0000-8920-2741|

            lSB.Append(lFields(2)).Append(lDelimiter).Append(lBarCodeWithDashes).Append(lDelimiter)
            ' YOUR ESTABLISHMENT|YOUR LOCATION|
            'lSB.Append(lsFields(4)).Append(lsDelimiter).Append(lsFields(5)).Append(lsDelimiter)
            lSB.Append(aCasinoName).Append(lDelimiter)

            ' Add location
            If mMachine.CasinoSystemParameters.VoucherDisplayCasinoNameInAddressField = False Then
               lSB.Append(aCasinoName).Append(lDelimiter)
            Else
               lSB.Append(aCasinoAddress).Append(lDelimiter)
            End If

            Dim originalZip As String
            Dim convertedZip As String

            'split up city/state/zip
            Dim cityStateZipNoSpaces As String = aCityStateZip.Replace(" ", "")
            Dim parts As String() = cityStateZipNoSpaces.Split(New Char() {"/"c})

            'now get last part as zip code
            If parts.Length = 3 Then
               originalZip = parts(2)
               'check to see if last 4 digits are 0000
               If originalZip.Length = 9 Then
                  'check last 4 digits
                  Dim zipFirstFive As String = Left(originalZip, 5)
                  Dim zipLastFour As String = Right(originalZip, 4)

                  If zipLastFour = "0000" Then
                     convertedZip = zipFirstFive
                  Else
                     convertedZip = zipFirstFive + "-" + zipLastFour
                  End If

                  'now replace zip part in aCityStateZip with new zip code
                  aCityStateZip = aCityStateZip.Replace(originalZip, convertedZip)

               End If

            End If

            ' CITY / STATE / ZIP||
            'lSB.Append(lsFields(6)).Append(lsDelimiter).Append(lsDelimiter)
            lSB.Append(aCityStateZip).Append(lDelimiter).Append(lDelimiter)
            ' $50.00|
            lSB.Append(lFormattedText).Append(lDelimiter)
            ' TWENTY FIVE DOLLARS AND NO CENTS| |
            'loSB.Append(VoucherAmountToCurrency(lVoucherValue)).Append(lsDelimiter).Append(" ").Append(lsDelimiter)
            lSB.Append(lMoneyText).Append(lDelimiter).Append(" ").Append(lDelimiter)
            ' 11/08/2004|00:03:35|
            lSB.Append(DateTime.Now.ToString("MM/dd/yyyy")).Append(lDelimiter).Append(DateTime.Now.ToString("HH:mm:ss")).Append(lDelimiter)
            ' TICKET # 0018||
            lSB.Append("TICKET # ").Append(mVoucherID.ToString).Append(lDelimiter).Append(lDelimiter)
            '00-0000-0000-8920-2741||
            lSB.Append(lBarCodeWithDashes).Append(lDelimiter).Append(lDelimiter)
            ' 30 days|
            If mMachine.CasID.Equals("THB001") Then
               ' special processing for Thunderbird casino only.
               lSB.Append(" ").Append(mExpirationMsg).Append(lDelimiter)
            Else
               If Not String.IsNullOrEmpty(mExpirationMonths) Then
                  lSB.Append(mExpirationMonths).Append(" Day(s)").Append(lDelimiter)
               Else
                  lSB.Append(mExpirationDays).Append(" Day(s)").Append(lDelimiter)
               End If
            End If
            ' MACHINE# 0|
            lSB.Append("MACHINE# ").Append(mMachine.CasinoMachineNumber).Append(lDelimiter)
            'lSB.Append("MACHINE# ").Append(mMachine.MachineNumber).Append(lsDelimiter)
            ' 000000000089202741|^
            lSB.Append(mBarcode).Append(lDelimiter).Append("^")

            ' Remove any commas in VoucherString for the TP
            lVoucherText = lSB.ToString.Replace(",", "")

            If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput(" 'DoVoucherCreate' ACCEPTED JACKPOT VoucherText: " & lVoucherText))

         Else
            ' Generate the VoucherText for the "Cashout"

            ' build the VoucherText : ^P|0|
            lSB.Append(lFields(0)).Append(lDelimiter).Append(lFields(1)).Append(lDelimiter)
            ' 1|00-0000-0000-8920-2741|
            lSB.Append(lFields(2)).Append(lDelimiter).Append(lBarCodeWithDashes).Append(lDelimiter)
            ' YOUR ESTABLISHMENT|YOUR LOCATION|
            'lSB.Append(lsFields(4)).Append(lsDelimiter).Append(lsFields(5)).Append(lsDelimiter)
            lSB.Append(aCasinoName).Append(lDelimiter)

            ' Add location
            If mMachine.CasinoSystemParameters.VoucherDisplayCasinoNameInAddressField = False Then
               lSB.Append(aCasinoName).Append(lDelimiter)
            Else
               lSB.Append(aCasinoAddress).Append(lDelimiter)
            End If

            ' CITY / STATE / ZIP|||
            'lSB.Append(lsFields(6)).Append(lsDelimiter).Append(lsDelimiter).Append(lsDelimiter)
            lSB.Append(aCityStateZip).Append(lDelimiter).Append(lDelimiter).Append(lDelimiter)
            '00-0000-0000-8920-2741|
            lSB.Append(lBarCodeWithDashes).Append(lDelimiter)
            ' 11/08/2004|00:03:35|
            lSB.Append(DateTime.Now.ToString("MM/dd/yyyy")).Append(lDelimiter).Append(DateTime.Now.ToString("HH:mm:ss")).Append(lDelimiter)
            ' TICKET # 0018|
            lSB.Append("TICKET # ").Append(mVoucherID.ToString).Append(lDelimiter)
            ' TWENTY FIVE DOLLARS AND NO CENTS| |
            'loSB.Append(VoucherAmountToCurrency(lVoucherValue)).Append(lsDelimiter).Append(" ").Append(lsDelimiter)
            lSB.Append(lMoneyText).Append(lDelimiter).Append(" ").Append(lDelimiter)
            ' $50.00||
            lSB.Append(lFormattedText).Append(lDelimiter).Append(lDelimiter)
            ' 30 days|
            If mMachine.CasID.Equals("THB001") Then
               ' special processing for Thunderbird casino only.
               lSB.Append(" ").Append(mExpirationMsg).Append(lDelimiter)
            Else
               If Not String.IsNullOrEmpty(mExpirationMonths) Then
                  lSB.Append(mExpirationMonths).Append(" Day(s)").Append(lDelimiter)
               Else
                  lSB.Append(mExpirationDays).Append(" Day(s)").Append(lDelimiter)
               End If
            End If
            ' MACHINE# 0|
            lSB.Append("MACHINE# ").Append(mMachine.CasinoMachineNumber).Append(lDelimiter)
            'lSB.Append("MACHINE# ").Append(mMachine.MachineNumber).Append(lsDelimiter)
            ' 000000000089202741|^
            lSB.Append(mBarcode).Append(lDelimiter).Append("^")

            ' Remove any commas in VoucherString for the TP
            lVoucherText = lSB.ToString.Replace(",", "")

            If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput(" 'DoVoucherCreate' ACCEPTED CASHOUT VoucherText: " & lVoucherText))
         End If

         ' Set the boolean switch to indicate this voucher is pending print
         mVoucherCreatePending = True

         ' Set MACH_SETUP.VOUCHER_PRINTING_FLAG = 1 to indicate that we are waiting to print.
         SetVoucherPrintingFlag()
         mMachine.VoucherPrintingFlag = 1

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" Error: Unable to complete 'DoVoucherCreate' Reason: " & ex.ToString))
         Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(709)
         lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
         lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
         lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)
         lVoucherText = ""
         mVoucherCreatePending = False

      End Try

      ' Create the Hashtable that we send back
      ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
      Call BuildResponseHeader(lHashTable, MessageHash)

      With lHashTable
         .Add("ErrorID", lErrorID.ToString)
         .Add("ErrorDescription", lErrorDescription)
         .Add("ShutDownFlag", lShutDownFlag)
         .Add("VoucherText", lVoucherText)
      End With

      ' send the Hashtable back
      Return lHashTable

   End Function

   Private Function DoVoucherCreateError(ByRef MessageHT As Hashtable, ByVal aErrorID As Integer) As Hashtable
      '--------------------------------------------------------------------------------
      '   Purpose: Returns a hashtable that contains the VoucherCreate output message for Errors.
      ' Called by: HandleVoucherCreate
      '     Calls: DbGetTpErrorDescription
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturnHT As Hashtable = DbTpGetErrorDescription(aErrorID)

      ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
      Call BuildResponseHeader(lReturnHT, MessageHT)

      lReturnHT.Add("VoucherText", "ERROR")

      Return lReturnHT

   End Function

   Private Function HandleVoucherRedeem(ByRef MessageHT As Hashtable) As Hashtable
      '--------------------------------------------------------------------------------
      '   Purpose: To redeem the voucher.
      '     Calls: tpTransVPV, tpRedeemBarcode
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow

      Dim lErrorID As Integer = 0

      Dim lVoucherType As Short = 0
      Dim lErrorDescription As String = ""
      Dim lOldChecksum As Byte() = Nothing
      Dim lShutdownFlag As String = "0"
      Dim lSessionPlayAmount As String = "0"
      Dim lVoucherValue As String = "0"


      Dim lResponseHash As New Hashtable

      Try
         lDB = New Database(mConnectionString)
         With lDB
            .AddParameter("@MachineNumber", mMachine.MachineNumber)
            .AddParameter("@MachineBalance", CType(MessageHT("MachineBalance"), String))
            .AddParameter("@TransType", "VR")
            .AddParameter("@TransAmt", "0")
            .AddParameter("@TimeStamp", CType(MessageHT("TimeStamp"), String))
         End With

         ' Execute procedure "tpTransVPV" for voucher pre-validation
         lDS = lDB.ExecuteProcedure("tpTransVPV")

         ' Get the "ErrorID", "ErrorDescription", "ShutDownFlag"
         lDR = lDS.Tables(0).Rows(0)
         lErrorID = CType(lDR.Item("ErrorID"), Integer)
         lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
         lShutdownFlag = CType(lDR.Item("ShutDownFlag"), String)

         ' Check to see if "tpTransVPV" returns lErrorID <> 0 
         If lErrorID <> 0 Then mVoucherID = 0

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeem' Error: Unable to complete 'tpTransVPV' transaction. Reason: " & ex.ToString))
         Dim lErrorHashTable As New Hashtable
         ' tpTransVPV DB Error in HandleVoucherRedeem, build output hash table and exit
         lErrorHashTable = DbTpGetErrorDescription(711)
         lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
         lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
         lShutdownFlag = CType(lErrorHashTable("ShutDownFlag"), String)

         mVoucherID = 0
      End Try

      If lErrorID = 0 Then
         ' tpTransVPV succeeded, now execute tpRedeemBarCode to obtain the VoucherID and VoucherValue...
         Try
            lDB = New Database(mConnectionString)
            With lDB
               .AddParameter("@BarCode", CType(MessageHT("Barcode"), String))
               .AddParameter("@TimeStamp", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .AddParameter("@MachineNumber", mMachine.MachineNumber)
            End With

            lDS = lDB.ExecuteProcedure("tpRedeemBarCode")
            ' tpRedeemBarCode returns:
            '    "ErrorID", "ErrorDescription", "ShutDownFlag",
            '    "VoucherValue", "VoucherID", "SessionPlayAmount"
            lDR = lDS.Tables(0).Rows(0)
            lErrorID = CType(lDR.Item("ErrorID"), Integer)
            lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
            lShutdownFlag = CType(lDR.Item("ShutDownFlag"), String)
            lVoucherValue = CType(lDR.Item("VoucherValue"), String)
            lSessionPlayAmount = CType(lDR.Item("SessionPlayAmount"), String)
            mVoucherID = CType(lDR.Item("VoucherID"), Integer)
            lVoucherType = CType(lDR.Item("VoucherType"), Short)

            If lVoucherType = 0 Then
               lVoucherType = 1
            End If

            ' Check to see if "tpRedeemBarCode" returns lErrorID <> 0 
            If lErrorID <> 0 Then
               lVoucherValue = "0"
               lSessionPlayAmount = "0"
               mVoucherID = 0
            End If

         Catch ex As Exception
            ' Handle the exception...
            If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeem' Error: Unable to complete 'tpRedeemBarCode' transaction. Reason: " & ex.ToString))

            Dim lErrorHashTable As New Hashtable
            lErrorHashTable = DbTpGetErrorDescription(704)
            lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
            lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
            lShutdownFlag = CType(lErrorHashTable("ShutDownFlag"), String)

            lVoucherValue = "0"
            mVoucherID = 0

         End Try
      End If

      If lErrorID = 0 Then
         ' tpRedeemBarCode succeeded, now execute tpValidateChecksum..
         Try
            ' Get the OldChecksum from the Barcode, VoucherValue and Redeemed_State
            lOldChecksum = GetChecksum(CType(MessageHT("Barcode"), String), lVoucherValue, "0")

            If lOldChecksum IsNot Nothing Then
               ' Valid checksum obtained, invoke tpValidateChecksum
               If mTraceSwitch.TraceVerbose Then
                  Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeem' VoucherID= " & mVoucherID.ToString))
               End If

               lDB = New Database(mConnectionString)
               With lDB
                  .AddParameter("@VoucherID", mVoucherID.ToString)
                  .AddParameter("@OldChecksum", System.Data.SqlDbType.Binary, CType(lOldChecksum, Object), 8)
                  .AddParameter("@MachineNumber", mMachine.MachineNumber)
               End With

               lDS = lDB.ExecuteProcedure("tpValidateChecksum")
               ' Get the "ErrorID", "ErrorDescription", "ShutDownFlag", "VoucherValue", "VoucherID"
               lDR = lDS.Tables(0).Rows(0)
               lErrorID = CType(lDR.Item("ErrorID"), Integer)
               lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
               lShutdownFlag = CType(lDR.Item("ShutDownFlag"), String)

               ' Check to see if "tpValidateChecksum" returns lErrorID <> 0 
               If lErrorID <> 0 Then
                  lVoucherValue = "0"
                  mVoucherID = 0
               End If
            Else
               ' Null checksum, show error 734
               If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeem' Error: GetCheckSum did not return a valid checksum."))
               Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(734)
               lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
               lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
               lShutdownFlag = CType(lErrorHashTable("ShutDownFlag"), String)
               lVoucherValue = "0"
               mVoucherID = 0
            End If

         Catch ex As Exception
            ' Handle the exception...
            If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeem' Error: Unable to complete 'tpValidateChecksum' transaction. Reason: " & ex.ToString))

            Dim lErrorHashTable As New Hashtable
            lErrorHashTable = DbTpGetErrorDescription(737)
            lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
            lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
            lShutdownFlag = CType(lErrorHashTable("ShutDownFlag"), String)

            lVoucherValue = "0"
            mVoucherID = 0

         End Try
      End If

      ' Make sure the Database instance if released...
      If lDB IsNot Nothing Then
         lDB.Dispose()
         lDB = Nothing
      End If

      Try
         ' Build the output hash table...
         ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
         Call BuildResponseHeader(lResponseHash, MessageHT)

         With lResponseHash
            .Add("ErrorID", lErrorID.ToString)
            .Add("ErrorDescription", lErrorDescription)
            .Add("ShutDownFlag", lShutdownFlag)
            .Add("VoucherValue", lVoucherValue)
            .Add("CreditType", lVoucherType.ToString)
            .Add("SessionPlayAmount", lSessionPlayAmount)
         End With

         Return lResponseHash

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeem' Error: unable to complete 'HandleVoucherRedeem' Reason : " & ex.ToString))
         ' Set lResponseHash to null to indicate error.
         lResponseHash = Nothing
         Return lResponseHash

      End Try

   End Function

   Private Function HandleVoucherRedeemed(ByRef MessageHT As Hashtable) As Hashtable
      '--------------------------------------------------------------------------------
      'TODO: Wireup HandleVoucherRedeemed
      '
      '   Purpose: Sent by machine
      ' Called by: HandleMessage
      '     Calls: tpTransVR, tpUpdateVoucherTable, tpUpdateVoucherTransNo
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow
      Dim lDT As DataTable

      Dim lErrorID As Integer = 0

      Dim lReturnHT As New Hashtable
      Dim lErrorDescription As String = ""
      Dim lNewChecksum As Byte() = Nothing
      Dim lShutDownFlag As String = "0"
      Dim lSPName As String = "tpTransVR"
      Dim lVoucherType As Short

      ' Invoke stored procedure "tpTransVR"
      Try
         ' Test the connection to the database.
         lDB = New Database(mConnectionString)

         With lDB
            ' Add input parameter for tpGetVoucherInfo.
            .AddParameter("@Barcode", CType(MessageHT("Barcode"), String))

            ' Execute the stored procedure.
            lDT = .CreateDataTableSP("tpGetVoucherInfo", "VoucherInfo")

            ' Set a reference to the returned row.
            lDR = lDT.Rows(0)

            ' Store VoucherID and VoucherType..
            mVoucherID = CType(lDR.Item("VoucherID"), Integer)
            lVoucherType = CType(lDR.Item("VoucherType"), Short)
            .ClearParameters()
         End With

         If mVoucherID = -1 Then
            ' Voucher not found, set error 703...
            mVoucherID = 0
            lErrorID = 703
            Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(lErrorID)
            lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
            lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)

            ' Log the problem.
            If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" HandleVoucherRedeemed error: Voucher not found."))

         Else
            ' If a Restricted Promo Voucher, change the stored procedure name to
            ' tpTransVRRPV (parameters are the same for both stored procedures)
            If lVoucherType = 4 Then lSPName = "tpTransVRRPV"

            ' Add input parameters for tpTransVR or tpTransVRRPV...
            lDB = New Database(mConnectionString)
            With lDB
               .AddParameter("@MachineNumber", mMachine.MachineNumber)
               .AddParameter("@TransAmt", CType(MessageHT("VoucherValue"), String))
               .AddParameter("@MachineBalance", CType(MessageHT("MachineBalance"), String))
               .AddParameter("@CardAccount", CType(MessageHT("CardAccount"), String))
               .AddParameter("@TimeStamp", CType(MessageHT("TimeStamp"), String))

               ' Execute tpTransVR or tpTransVRRPV to update either the Cashable or Promo
               ' balance in MACH_SETUP and to update MACHINE_STATS & MACHINE_METER tables.
               lDT = .CreateDataTableSP(lSPName)
            End With

            ' Set a reference to the returned row.
            lDR = lDT.Rows(0)

            ' Extract row information.
            lErrorID = CType(lDR.Item("ErrorID"), Integer)
            lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
            lShutDownFlag = CType(lDR.Item("ShutDownFlag"), String)
            mCasinoTransNo = CType(lDR.Item("CasinoTransNo"), Integer)
         End If

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeemed' Error: Unable to complete 'tpTransVR' transaction. Reason: " & ex.ToString))
         Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(713)
         lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
         lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
         lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)
      End Try

      ' tpTransVR successful so execute stored procedure "tpUpdateVoucherTable" to
      ' set REDEEMED_STATE = True, REDEEMED_LOC = mMachineNumber, CHECK_VALUE = NewChecksum
      If lErrorID = 0 Then
         Try
            ' Build the NewChecksum ( Barcode + VoucherValue + Status )
            lNewChecksum = GetChecksum(CType(MessageHT("Barcode"), String), CType(MessageHT("VoucherValue"), String), "1")

            ' Check if we got a valid Checksum back
            If lNewChecksum IsNot Nothing Then
               ' Valid checksum obtained invoke tpUpdateVoucherTable
               lDB = New Database(mConnectionString)
               With lDB
                  .AddParameter("@BarCode", CType(MessageHT("Barcode"), String))
                  .AddParameter("@TimeStamp", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
                  .AddParameter("@MachineNumber", mMachine.MachineNumber)
                  .AddParameter("@Flag", "VR")
                  .AddParameter("@Checksum", System.Data.SqlDbType.Binary, CType(lNewChecksum, Object), 8)
               End With

               ' Execute procedure "tpUpdateVoucherTable" for VOUCHERREDEEMED
               lDS = lDB.ExecuteProcedure("tpUpdateVoucherTable")
               lDR = lDS.Tables(0).Rows(0)

               lErrorID = CType(lDR.Item("ErrorID"), Integer)
               lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
               lShutDownFlag = CType(lDR.Item("ShutDownFlag"), String)
            Else
               ' Null checksum obtained show error 734.
               If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeemed' Error: GetCheckSum did not return a valid checksum."))
               Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(734)
               lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
               lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
               lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)
            End If

         Catch ex As Exception
            ' Handle the exception...
            If mTraceSwitch.TraceError Then
               Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeemed' Error: Unable to complete 'tpUpdateVoucherTable' transaction. Reason: " & ex.ToString))
            End If

            Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(724)
            lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
            lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
            lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)
         End Try

      End If

      ' Now execute stored procedure tpUpdateVoucherTransNo to link CASINO_TRANS and VOUCHER tables...
      If lErrorID = 0 Then
         Try
            lDB = New Database(mConnectionString)
            With lDB
               .AddParameter("@VoucherID", mVoucherID.ToString)
               .AddParameter("@CTTransNo", mCasinoTransNo.ToString)
               .AddParameter("@TransType", "R")
            End With

            ' Execute procedure "tpUpdateVoucherTransNo" for VOUCHERCREATE
            lDS = lDB.ExecuteProcedure("tpUpdateVoucherTransNo")

         Catch ex As Exception
            ' Handle the exception...
            If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'HandleVoucherRedeemed' Error: Unable to complete 'tpUpdateVoucherTransNo' transaction. Reason: " & ex.ToString))

            Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(728)
            lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
            lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
            lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)
         End Try

      End If

      Try
         ' Create the output Hashtable
         ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
         Call BuildResponseHeader(lReturnHT, MessageHT)
         With lReturnHT
            .Add("ErrorID", lErrorID.ToString)
            .Add("ErrorDescription", lErrorDescription)
            .Add("ShutDownFlag", lShutDownFlag)
         End With

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" Error: unable to complete 'HandleVoucherRedeemed' Reason : " & ex.ToString))
         ' Set loHashtable to null to indicate error.
         lReturnHT = Nothing

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturnHT

   End Function

   Private Function HandleVoucherNotRedeemed(ByRef MessageHT As Hashtable) As Hashtable
      '--------------------------------------------------------------------------------
      '   Purpose: sent by machine for the "VOUCHERNOTREDEEMED".
      ' Called by: displayHashTable
      '     Calls: tpUpdateVoucherTable
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow

      Dim lReturnHT As New Hashtable

      Dim lErrorID As Integer

      Dim lBarcode As String = CType(MessageHT("Barcode"), String)
      Dim lErrorDescription As String
      Dim lShutDownFlag As String

      ' Check for a bad bar code (greater than 18 chars or not all numeric )
      If (lBarcode.Length <> 18) Or (Not Regex.IsMatch(lBarcode, "^\d+$")) Then
         ' Create the output Hashtable
         ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
         Call BuildResponseHeader(lReturnHT, MessageHT)

         Dim lErrorHashTable As New Hashtable
         ' VoucherNotRedeemed: Bad Barcode Input.
         lErrorHashTable = DbTpGetErrorDescription(714)
         lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
         lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
         lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)

         With lReturnHT
            .Add("ErrorID", lErrorID.ToString)
            .Add("ErrorDescription", lErrorDescription)
            .Add("ShutDownFlag", lShutDownFlag)
         End With

         ' return the Hashtable and exit.
         Return lReturnHT
      End If

      ' Now invoke "tpUpdateVoucherTable" to set REDEEMED_STATE = False & REDEEMED_LOC = ""
      Try
         lDB = New Database(mConnectionString)
         With lDB
            .AddParameter("@BarCode", lBarcode)
            .AddParameter("@TimeStamp", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
            .AddParameter("@MachineNumber", mMachine.MachineNumber)
            .AddParameter("@Flag", "VNR")
         End With

         ' Execute procedure "tpUpdateVoucherTable" for VOUCHERNOTREDEEMED
         lDS = lDB.ExecuteProcedure("tpUpdateVoucherTable")
         lDR = lDS.Tables(0).Rows(0)

         lErrorID = CType(lDR.Item("ErrorID"), Integer)
         lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
         lShutDownFlag = CType(lDR.Item("ShutDownFlag"), String)

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'HandleVoucherNotRedeemed' Error: Unable to complete 'tpUpdateVoucherTable' transaction. Reason: " & ex.ToString))

         Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(724)
         lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
         lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
         lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

      Try
         ' Create the output Hashtable
         lReturnHT = New Hashtable
         ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
         Call BuildResponseHeader(lReturnHT, MessageHT)

         With lReturnHT
            .Add("ErrorID", lErrorID.ToString)
            .Add("ErrorDescription", lErrorDescription)
            .Add("ShutDownFlag", lShutDownFlag)
         End With

      Catch ex As Exception
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" Error: unable to complete 'HandleVoucherNotRedeemed' Reason : " & ex.ToString))
         ' Set lHashtable to null to indicate error.
         lReturnHT = Nothing

      End Try

      ' Set the function return value.
      Return lReturnHT

   End Function

   Private Function HandleVoucherPrinted(ByRef MessageHT As Hashtable) As Hashtable
      '--------------------------------------------------------------------------------
      '   Purpose: to Delete the Temporarily stored BarCode stream in "TICKET_REPRINT" tbl.
      ' Called by: HandleMessage
      '     Calls: tpTransVC, tpTicketDelete, tpUdateVoucherTable, tpUpdateVoucherTransNo
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow

      Dim lReturnHT As New Hashtable

      Dim lErrorID As Integer = 0

      Dim lErrorDescription As String = ""
      Dim lShutDownFlag As String = "0"

      ' Reset the VoucherPendingPrint flag to False
      mVoucherCreatePending = False

      Try
         lDB = New Database(mConnectionString)

         ' Load input parameter for tpTransVC
         With lDB
            .AddParameter("@MachineNumber", mMachine.MachineNumber)
            .AddParameter("@TransAmt", CType(MessageHT("TransAmount"), String))
            .AddParameter("@MachineBalance", CType(MessageHT("MachineBalance"), String))
            .AddParameter("@CardAccount", CType(MessageHT("CardAccount"), String))
            If mIsJackpot Then
               .AddParameter("@IsJackpot", "1")
            Else
               .AddParameter("@IsJackpot", "0")
            End If
            .AddParameter("@TimeStamp", CType(MessageHT("TimeStamp"), String))
         End With

         ' Execute procedure "tpTransVC" for ACCEPTED
         lDS = lDB.ExecuteProcedure("tpTransVC")
         lDR = lDS.Tables(0).Rows(0)
         lErrorID = CType(lDR.Item("ErrorID"), Integer)
         lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
         lShutDownFlag = CType(lDR.Item("ShutDownFlag"), String)
         mCasinoTransNo = CType(lDR.Item("CasinoTransNo"), Integer)
         mJackpotTransNo = CType(lDR.Item("JackpotTransNo"), Integer)

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" HandleVoucherPrinted Error: unable to complete 'tpTransVC': " & ex.ToString))
         Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(715)
         lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
         lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
         lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)

      End Try

      ' Now execute tpUpdateVoucherTable to set VOUCHER_TYPE = 0 (Ordinary Voucher), =1 (Jackpot Voucher)
      If lErrorID = 0 Then
         Try
            lDB = New Database(mConnectionString)
            ' Add input parameters...
            With lDB
               ' remove the dashes in the incoming Barcode before storing it.
               .AddParameter("@BarCode", CType(MessageHT("Barcode"), String).Replace("-", ""))
               .AddParameter("@TimeStamp", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
               .AddParameter("@MachineNumber", mMachine.MachineNumber)
               If mIsJackpot = True Then
                  .AddParameter("@Flag", "JP")
               Else
                  .AddParameter("@Flag", "VP")
               End If
            End With

            ' Execute procedure "tpUpdateVoucherTable" for VOUCHERPRINTED
            lDS = lDB.ExecuteProcedure("tpUpdateVoucherTable")
            lDR = lDS.Tables(0).Rows(0)
            ' Get the "ErrorID", "ErrorDescription", "ShutDownFlag"
            lErrorID = CType(lDR.Item("ErrorID"), Integer)
            lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
            lShutDownFlag = CType(lDR.Item("ShutDownFlag"), String)

         Catch ex As Exception
            ' Handle the exception...
            If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" HandleVoucherPrinted Error: unable to complete tpUpdateVoucherTable: " & ex.ToString))
            Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(724)
            lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
            lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
            lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)
         End Try

      End If

      ' Now invoke tpUpdateVoucherTransNo to link CASINO_TRANS with VOUCHER tbl.
      If lErrorID = 0 Then
         Try
            lDB = New Database(mConnectionString)
            ' load input parameter
            With lDB
               .AddParameter("@VoucherID", mVoucherID.ToString)
               .AddParameter("@CTTransNo", mCasinoTransNo.ToString)
               ' Change JPTransNo parm. from default of 0 only if it is a Jackpot.
               If (mIsJackpot = True) Then .AddParameter("@JPTransNo", mJackpotTransNo.ToString)
               .AddParameter("@TransType", "C")
            End With

            ' Execute procedure "tpUpdateVoucherTransNo" for VOUCHERPRINTED
            lDS = lDB.ExecuteProcedure("tpUpdateVoucherTransNo")

         Catch ex As Exception
            ' Handle the exception...
            If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" HandleVoucherPrinted Error: unable to complete tpUpdateVoucherTransNo: " & ex.ToString))
            Dim lErrorHashTable As Hashtable = DbTpGetErrorDescription(727)
            lErrorID = CType(lErrorHashTable("ErrorID"), Integer)
            lErrorDescription = CType(lErrorHashTable("ErrorDescription"), String)
            lShutDownFlag = CType(lErrorHashTable("ShutDownFlag"), String)
         End Try
      End If

      Try
         ' Create the output Hashtable
         ' Add MachineSequence/TransType/TimeStamp/OnlineStatus fields for Response hashtable.
         Call BuildResponseHeader(lReturnHT, MessageHT)

         With lReturnHT
            .Add("ErrorID", lErrorID.ToString)
            .Add("ErrorDescription", lErrorDescription)
            .Add("ShutDownFlag", lShutDownFlag)
         End With

      Catch ex As Exception
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" HandleVoucherPrinted Error: " & ex.ToString))
         ' Set lHashTable to null to indicate error.
         lReturnHT = Nothing

      End Try

      ' Free DB...
      If lDB IsNot Nothing Then
         lDB.Dispose()
         lDB = Nothing
      End If

      ' Set the function return value.
      Return lReturnHT

   End Function

   Private Function HandleVoucherPrintFailed(ByRef MessageHT As Hashtable) As Hashtable
      '--------------------------------------------------------------------------------
      ' Machine sent VoucherPrintFailed message.
      ' This function deletes the voucher record and records the print failure in the
      ' CASINO_TRANS and CASINO_EVENT_LOG tables.
      ' Called by HandleMessage
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDR As DataRow = Nothing

      Dim lReturnHT As New Hashtable

      Dim lErrorID As Integer

      Dim lBarcode As String
      Dim lErrorDescription As String = ""
      Dim lResultText As String
      Dim lShutDownFlag As String = "0"

      Try
         ' Is this a DGE backoffice setting?
         If mMachine.TpiID = 0 Then
            ' Yes, so we will try to drop the VOUCHER table row created by the last VoucherCreate message.
            If mVoucherID = 0 Then
               Try
                  ' mVoucherID may = 0 if machine disconnects, then reconnects
                  lBarcode = CType(MessageHT("Barcode"), String).Replace("-", "")

                  If mTraceSwitch.TraceVerbose Then
                     Trace.WriteLine(FormatLogOutput("Retrieving VOUCHER_ID row for barcode " & lBarcode))
                  End If

                  ' Instantiate a new Database object.
                  lDB = New Database(mConnectionString)
                  lDB.AddParameter("@Barcode", lBarcode)
                  lDT = lDB.CreateDataTableSP("tpGetVoucherID")
                  lDR = lDT.Rows(0)
                  mVoucherID = CType(lDR.Item(0), Integer)

               Catch ex As Exception
                  ' Handle the exception.
                  If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("HandleVoucherPrintFailed error retrieving VoucherID: " & ex.Message))
               End Try

            End If

            ' Do we have a voucher id to drop?
            If mVoucherID > 0 Then
               ' Yes, so do it.
               If mTraceSwitch.TraceVerbose Then
                  Trace.WriteLine(FormatLogOutput("Dropping VOUCHER row " & mVoucherID.ToString))
               End If

               ' Instantiate a new Database object.
               lDB = New Database(mConnectionString)

               ' Load input parameter for tpTransVPF (VoucherPrintFailed stored procedure)...
               lDB.AddParameter("@VoucherID", mVoucherID.ToString)

               ' Execute stored procedure tpDropVoucher to delete the voucher table row created by VoucherCreate message handler.
               lDT = lDB.CreateDataTableSP("tpDropVoucher")

               ' Store returned data...
               lDR = lDT.Rows(0)
               lErrorID = CType(lDR.Item("ReturnCode"), Integer)

               ' If the ReturnCode was not zero, log the result text from the stored procedure.
               If lErrorID <> 0 Then
                  If mTraceSwitch.TraceError Then
                     lResultText = CType(lDR.Item("ResultText"), String)
                     Trace.WriteLine(FormatLogOutput(String.Format("HandleVoucherPrintFailed::tpDropVoucher({0}) error: {1}", mVoucherID, lResultText)))
                  End If
               End If
            End If
         End If


         ' Now call tpTransVPF to record the print failure in the CASINO_TRANS and CASINO_EVENT_LOG tables...
         ' Instantiate a new Database object.
         lDB = New Database(mConnectionString)

         ' Load input parameter for tpTransVPF (VoucherPrintFailed stored procedure)...
         With lDB
            .AddParameter("@MachineNumber", mMachine.MachineNumber)
            .AddParameter("@MachineBalance", CType(MessageHT("MachineBalance"), String))
            .AddParameter("@CardAccount", CType(MessageHT("CardAccount"), String))
            .AddParameter("@ErrorCode", CType(MessageHT("ErrorCode"), String))
            .AddParameter("@TimeStamp", CType(MessageHT("TimeStamp"), String))

            ' Execute stored procedure tpTransVPF for VoucherPrintFailed.
            lDT = .CreateDataTableSP("tpTransVPF")
         End With

         ' Store returned data...
         lDR = lDT.Rows(0)
         lErrorID = CType(lDR.Item("ErrorID"), Integer)
         lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
         lShutDownFlag = CType(lDR.Item("ShutDownFlag"), String)

         ' Create the output Hashtable
         ' Add MachineSequence, TransType, and TimeStamp fields for Response hashtable.
         Call BuildResponseHeader(lReturnHT, MessageHT)

         ' Add values returned from tpTransVPF...
         With lReturnHT
            .Add("ErrorID", lErrorID.ToString)
            .Add("ErrorDescription", lErrorDescription)
            .Add("ShutDownFlag", lShutDownFlag)
         End With

      Catch ex As Exception
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("HandleVoucherPrintFailed error: " & ex.ToString))
         ' Set lHashTable to null to indicate error.
         lReturnHT = Nothing

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

         If lDT IsNot Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If

         If lDR IsNot Nothing Then lDR = Nothing
      End Try

      ' Set the function return value.
      Return lReturnHT

   End Function

   Private Sub HandleHandPay(ByRef MessageHT As Hashtable)
      '--------------------------------------------------------------------------------
      '   Purpose: sent by machine for the "HANDPAY". NO response to be sent to TP
      ' Called by: HandleMessage
      '     Calls: tpUpdateVoucherTable
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow

      Dim lErrorID As Integer

      Dim lBarcode As String
      Dim lErrorDescription As String
      Dim lHandPayType As String = "HP"
      Dim lShutDownFlag As String

      ' Reset the VoucherPendingPrint flag to False.
      mVoucherCreatePending = False

      ' Invoke "tpUpdateVoucherTable" to set VOUCHER_TYPE = "2" (HandPay), = 3 (Jackpot HandPay) in the VOUCHER table.
      Try
         ' Remove the dashes that the Machine provides in the BarCode
         lBarcode = CType(MessageHT("Barcode"), String).Replace("-", "")

         ' Change type from HP to JHP if it is a jackpot hand pay.
         If mIsJackpot Then lHandPayType = "JHP"

         ' Test the connection to the database.
         lDB = New Database(mConnectionString)
         ' Add input parameters...
         With lDB
            .AddParameter("@BarCode", lBarcode)
            .AddParameter("@TimeStamp", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
            .AddParameter("@MachineNumber", mMachine.MachineNumber)
            .AddParameter("@Flag", lHandPayType)
         End With

         ' Execute procedure "tpUpdateVoucherTable" for HANDPAY
         lDS = lDB.ExecuteProcedure("tpUpdateVoucherTable")
         lDR = lDS.Tables(0).Rows(0)

         ' Get the "ErrorID", "ErrorDescription", "ShutDownFlag"
         lErrorID = CType(lDR.Item("ErrorID"), Integer)
         lErrorDescription = CType(lDR.Item("ErrorDescription"), String)
         lShutDownFlag = CType(lDR.Item("ShutDownFlag"), String)

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'HandleHandPay' Error: unable to complete 'tpUpdateVoucherTable' Reason : " & ex.ToString))

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Public Sub SetVoucherPrintingFlag()
      '--------------------------------------------------------------------------------
      ' Sets the VoucherFlag, if VoucherFlagTimeout feature is enabled then start the counter
      '--------------------------------------------------------------------------------

      If Machine.TpiServer.IsVoucherPrintFlagEnabled Then
         mVoucherPrintingTimer.Stop()
      End If

      ' Reset MACH_SETUP.VOUCHER_PRINTING_FLAG to 0, indicates no longer waiting for Voucher to finish printing.
      DbTpGetSetVoucherPrintingFlag("S", 1)
      Machine.VoucherPrintingFlag = 1

      If Machine.TpiServer.IsVoucherPrintFlagEnabled Then
         mVoucherPrintingTimer.Start()
      End If

   End Sub

   Public Sub ResetVoucherPrintingFlag()
      '--------------------------------------------------------------------------------
      ' Resets the voucher printing flag, and stops timeout timer (if feature enabled)
      '--------------------------------------------------------------------------------

      ' Reset MACH_SETUP.VOUCHER_PRINTING_FLAG to 0, indicates no longer waiting for Voucher to finish printing.
      DbTpGetSetVoucherPrintingFlag("S", 0)
      Machine.VoucherPrintingFlag = 0

      If Machine.TpiServer.IsVoucherPrintFlagEnabled Then
         mVoucherPrintingTimer.Stop()
      End If

   End Sub

#End Region

#Region " Database Calls "

   Public Sub tpInsertCasinoEvent(ByVal aEventCode As String, ByVal aEventSource As String, ByVal aEventDesc As String, ByVal aMachineNumber As String)
      '--------------------------------------------------------------------------------
      ' Call the database to insert a row to CasinoEvent Table      
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturnValue As Integer = 0

      Try
         Using lDB As New Database(ConnectionString)

            ' Set paramaters
            lDB.AddParameter("@MachineNumber", Machine.MachineNumber)
            lDB.AddParameter("@EventCode", aEventCode)
            lDB.AddParameter("@EventSource", aEventSource)
            lDB.AddParameter("@EventDesc", aEventDesc)

            ' Call the sotred procedure and get return code
            lDB.ExecuteProcedureNoResult("tpInsertCasinoEvent")
            lReturnValue = lDB.ReturnValue

         End Using

      Catch ex As Exception
         ' Handle the exception.
         lReturnValue = -1
         If TraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("UgsClient::tpInsertCasinoEvent database call Error: " & ex.ToString))

      End Try

   End Sub

   Private Function IsDuplicateBarcode(ByVal aBarcode As String) As Boolean
      '--------------------------------------------------------------------------------
      '   Purpose: Returns True or False to indicate if the specified barcode exists
      '   in the VOUCHER table.
      ' Called by: GetNewBarcode, DbTpInsertVoucher
      '     Calls: tpBarcodeAlreadyExists
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      ' Dim lDS As DataSet
      Dim lDT As DataTable

      Dim lReturn As Boolean = True
      Dim lCount As Integer = 0

      Try
         lDB = New Database(ConnectionString)
         ' Add parameter.
         lDB.AddParameter("@BarCode", aBarcode)

         ' Execute tpBarcodeAlreadyExists & query VOUCHER tbl for "aBarcode"
         ' lDS = lDB.ExecuteProcedure("tpBarcodeAlreadyExists")
         lDT = lDB.CreateDataTableSP("tpBarcodeAlreadyExists")

         ' Get the count of BarCode in the 
         ' lCount = CType(lDS.Tables(0).Rows(0).Item(0), Integer)
         lCount = CType(lDT.Rows(0).Item(0), Integer)

         If lCount = 0 Then
            ' Barcode does NOT exist, so return False.
            lReturn = False
         Else
            ' Barcode already exists, try generating another one.
            lReturn = True
            If mTraceSwitch.TraceVerbose Then
               Trace.WriteLine(FormatLogOutput(String.Format("Voucher ValidationID {0} exists and cannot be reused.", aBarcode)))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("IsDuplicateBarcode::tpBarcodeAlreadyExists error: " & ex.ToString))
         ' Force it to try again
         lReturn = True

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Public Function DbTpGetErrorDescription(ByVal ErrorNumber As Integer) As Hashtable
      '--------------------------------------------------------------------------------
      ' Attempts to return error information from the ERROR_LOOKUP table by calling
      ' stored procedure tpGetErrorDescription.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As New Hashtable
      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow

      Try
         lDB = New Database(ConnectionString)
         lDB.AddParameter("@Error_No", ErrorNumber.ToString)
         lDS = lDB.ExecuteProcedure("tpGetErrorDescription")
         lDR = lDS.Tables(0).Rows(0)

         lReturn.Add("ErrorDescription", CType(lDR.Item("ErrorDescription"), String))
         lReturn.Add("ShutDownFlag", CType(lDR.Item("ShutDownFlag"), String))
         lReturn.Add("ErrorID", CType(lDR.Item("ErrorID"), String))

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("DbTpGetErrorDescription Error: " & ex.ToString))
         lReturn = New Hashtable
         lReturn.Add("ErrorDescription", "Unknown Error - Unable to retrieve error description.")
         lReturn.Add("ShutDownFlag", "0")
         lReturn.Add("ErrorID", ErrorNumber)

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If
      End Try

      ' Set the function return value...
      Return lReturn

   End Function

   Private Function DbTpGetTpiSetting(ByVal aTpiID As String, ByVal aItemKey As String) As Hashtable
      '--------------------------------------------------------------------------------
      ' Calls stored procedure tpGetTpiSetting.
      ' Called by HandleMessage
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As New Hashtable
      Dim lDB As Database = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDR As DataRow

      Try
         ' Instantiate a new Database object.
         lDB = New Database(ConnectionString)
         ' Add sp parameters for tpGetTpiSetting...
         lDB.AddParameter("@TpiID", aTpiID)
         lDB.AddParameter("@ItemKey", aItemKey)

         ' Execute the stored procedure.
         lDT = lDB.CreateDataTableSP("tpGetTpiSetting")

         ' Was a row of data returned in the DataTable?
         If lDT.Rows.Count > 0 Then
            ' Yes, so set a reference to the row and store the column values...
            lDR = lDT.Rows(0)
            lReturn.Add("ItemValue", CType(lDR.Item(0), String))
            lReturn.Add("ErrorID", CType(lDR.Item(1), String))
         Else
            ' No row returned, so set ErrorID to
            ' 743 (Voucher Template not found.) or
            ' 744 (Expiration information not found.)
            If aItemKey.Contains("Expiration") Then
               lReturn.Add("ItemValue", "")
               lReturn.Add("ErrorID", "744")
            Else
               lReturn.Add("ItemValue", "")
               lReturn.Add("ErrorID", "743")
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("DbTpGetTpiSetting error: " & ex.Message))
         ' Set ErrorID to 708 (tpTpiGetSetting: Error Return.)
         lReturn.Add("ItemValue", "")
         lReturn.Add("ErrorID", "708")

      Finally
         ' Cleanup...
         If lDT IsNot Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If

         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DbTpInsertVoucher(ByRef MessageHash As Hashtable) As Hashtable
      '--------------------------------------------------------------------------------
      '   Purpose: Inserts a new VOUCHER table row.
      ' Called by: HandleVoucherCreate()
      '     Calls: GetNewBarcode, GetChecksum, and sp tpInsertVoucher
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As New Hashtable

      Dim lLogText As String

      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow

      Try
         ' Instantiate a new Database object.
         lDB = New Database(ConnectionString)

         ' Check ONE LAST TIME for a Duplicate Barcode, before trying to insert it.
         If IsDuplicateBarcode(mBarcode) Then
            ' Try generating a new Barcode
            mBarcode = GetNewBarcode()
            If mBarcode.Length <> 18 Then
               ' Could not obtain a new Barcode, set error code and exit.
               If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput(" DbTpInsertVoucher error: Could not create a new Barcode, exiting"))
               lReturn.Add("ErrorID", "730")
               Return lReturn
            Else
               ' Got a good new Barcode. Try to generate a fresh Checksum value for it.
               mOldChecksum = GetChecksum(mBarcode, CType(MessageHash("TransAmount"), String), "0")
               If mOldChecksum Is Nothing Then
                  ' Could not obtain a Checksum, set error code and exit.
                  If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput(" DbTpInsertVoucher error: Could not create a new Checksum, exiting"))
                  lReturn.Add("ErrorID", "734")
                  Return lReturn
               End If
            End If
         End If

         ' Setup and call tpInsertVoucher...
         With lDB
            .AddParameter("@BarCode", mBarcode)
            .AddParameter("@TimeStamp", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
            .AddParameter("@TransAmt", CType(MessageHash("TransAmount"), String))
            .AddParameter("@MachineNumber", mMachine.MachineNumber)
            .AddParameter("@VoucherType", "0")
            .AddParameter("@Checksum", System.Data.SqlDbType.Binary, CType(mOldChecksum, Object), 8)
            If MessageHash.ContainsKey("SessionPlayAmount") Then
               .AddParameter("@SessionPlayAmt", CType(MessageHash("SessionPlayAmount"), String))
               If mTraceSwitch.TraceVerbose Then
                  lLogText = "Added parameter @SessionPlayAmt with a value of " & CType(MessageHash("SessionPlayAmount"), String)
                  Trace.WriteLine(FormatLogOutput(lLogText))
               End If
            Else
               If mTraceSwitch.TraceVerbose Then
                  lLogText = "Message did not contain a SessionPlayAmount value."
                  Trace.WriteLine(FormatLogOutput(lLogText))
               End If
            End If
         End With

         ' Execute the stored procedure and store returned resultset in lDS.
         lDS = lDB.ExecuteProcedure("tpInsertVoucher")
         ' Store first (only) row in lDR.
         lDR = lDS.Tables(0).Rows(0)

         ' Add row values to Hashtable that will be returned by this function...
         lReturn.Add("ErrorID", CType(lDR.Item("ErrorID"), String))
         lReturn.Add("ErrorDescription", CType(lDR.Item("ErrorDescription"), String))
         lReturn.Add("ShutDownFlag", CType(lDR.Item("ShutDownFlag"), String))
         lReturn.Add("VoucherID", CType(lDR.Item("VoucherID"), String))

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'DbTpInsertBarcode' Error: Unable to complete 'tpInsertBarcode' transaction. Reason: " & ex.ToString))
         lReturn.Add("ErrorID", "702")
         lReturn.Add("ErrorDescription", "DB Exception in tpInsertBarCode")
         lReturn.Add("ShutDownFlag", "0")
         lReturn.Add("VoucherID", "0")

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DbTpTransVPV(ByRef MessageHash As Hashtable) As Boolean
      '--------------------------------------------------------------------------------
      '   Purpose: to do Voucher pre-validation.
      ' Called by: HandleMessage
      '     Calls: tpTransVPV   
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = False
      Dim lDB As Database = Nothing
      Dim lDS As DataSet
      Dim lDR As DataRow

      Try
         lDB = New Database(ConnectionString)
         With lDB
            .AddParameter("@MachineNumber", mMachine.MachineNumber)
            .AddParameter("@MachineBalance", CType(MessageHash("MachineBalance"), String))

            If CType(MessageHash("TransType"), String).ToUpper = "VOUCHERCREATE" Then
               .AddParameter("@TransType", "VC")
               .AddParameter("@TransAmt", CType(MessageHash("TransAmount"), String))
            Else
               .AddParameter("@TransType", "VR")
               .AddParameter("@TransAmt", "0")
            End If
            .AddParameter("@TimeStamp", CType(MessageHash("TimeStamp"), String))
         End With

         lDS = lDB.ExecuteProcedure("tpTransVPV")

         If lDS.Tables.Count > 0 Then
            If lDS.Tables(0).Rows.Count > 0 Then
               lDR = lDS.Tables(0).Rows(0)
               If lDS.Tables(0).Columns.Contains("ErrorId") Then
                  lReturn = True
                  MessageHash.Add("DbErrorId", CType(lDR.Item("ErrorId"), String))
                  MessageHash.Add("DbErrorDescription", CType(lDR.Item("ErrorDescription"), String))
                  MessageHash.Add("DbShutDownFlag", CType(lDR.Item("ShutDownFlag"), String))
               End If
            End If
         End If

         If lReturn = False Then
            If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput(" 'DbTpTransVPV' Error: Unable to complete 'tpTransVPV' transaction."))
         End If

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'DbTpTransVPV' Error: Unable to complete 'tpTransVPV' transaction. Reason: " & ex.ToString))

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub DbTpGetStoreChecksum(ByVal aTpiID As String, ByVal aCheckSum As Int64)
      '--------------------------------------------------------------------------------
      '   Purpose: Stores the CheckSum sent by the OnTPCRefreshTimerEvent in an "A"
      '            transaction into the TPI_SETTING table.
      '
      ' Uses CheckSum:CasinoMachNo as ITEM_KEY and TPI_ID = 3 (Iowa Lottery)
      '
      ' Called by: HandleMessage
      '     Calls: tpGetStoreCheckSum
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDS As DataSet

      Try
         ' Create a new database instance.
         lDB = New Database(ConnectionString)

         ' Add parameters for the tpGetStoreCheckSum stored procedure...
         With lDB
            .AddParameter("@TpiID", aTpiID)
            .AddParameter("@ItemKey", "CheckSum" & ":" & mMachine.CasinoMachineNumber)
            .AddParameter("@CheckSum", aCheckSum.ToString)
         End With

         ' Execute the tpGetStoreCheckSum stored procedure...
         lDS = lDB.ExecuteProcedure("tpGetStoreCheckSum")

         ' Log value returned.
         If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput(" 'DbTpGetStoreChecksum' Checksum returned = " & CType(lDS.Tables(0).Rows(0).Item(0), String)))

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(" 'DbTpGetStoreChecksum' Error: 'tpGetStoreCheckSum' failed exception = " & ex.ToString))

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Private Function DbTpGetSetVoucherPrintingFlag(ByVal aGetSet As String, ByVal aFlagValue As Integer) As Integer
      '--------------------------------------------------------------------------------
      ' Returns 0 or 1 based on successful Select/Update of MACH_SETUP.VOUCHER_PRINTING_FLAG.
      ' Returns -1 on Error.
      '
      ' Called by: Startup, HandleMessage, DoVoucherCreate.
      '     Calls: tpGetSetVoucherPrintingFlag
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDT As DataTable

      Dim lVoucherPrintingFlag As Integer = 0

      ' Get the VOUCHER_PRINTING_FLAG for this machine.
      Try
         lDB = New Database(mConnectionString)
         ' Add Parameters
         lDB.AddParameter("@MachNo", mMachine.MachineNumber)
         lDB.AddParameter("@GetOrSet", aGetSet)
         lDB.AddParameter("@FlagValue", aFlagValue.ToString)

         ' Execute proc. "tpGetSetVoucherPrintingFlag" & select/update MACH_SETUP tbl for "VOUCHER_PRINTING_FLAG"
         lDT = lDB.CreateDataTableSP("tpGetSetVoucherPrintingFlag")

         ' Get the "VOUCHER_PRINTING_FLAG"
         lVoucherPrintingFlag = CType(lDT.Rows(0).Item(0), Integer)

         ' If we had an error in select/update write to log file and reset to 0 so game play can continue.
         If (lVoucherPrintingFlag = -1) Then
            If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("DbTpGetSetVoucherPrintingFlag error: Select/Update in tpGetGetSetVoucherPrintingFlag failed."))
            lVoucherPrintingFlag = 0
         End If

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("DbTpGetSetVoucherPrintingFlag exception: " & ex.ToString))

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

   Private Sub DbTpUpdateMachineGameRelease(ByVal aGameRelease As String, ByVal aOSVersion As String)
      '--------------------------------------------------------------------------------
      ' Routine to update the game and os versions in the machine setup table.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lMachineNumber As String = mMachine.MachineNumber

      Try
         ' Create a new Database instance.
         lDB = New Database(mConnectionString)

         With lDB
            ' Add Parameters
            .AddParameter("@MachineNumber", lMachineNumber)
            .AddParameter("@GameRelease", aGameRelease)
            .AddParameter("@OSVersion", aOSVersion)

            ' Execute stored procedure tp
            .ExecuteProcedure("tpUpdateMachineGameRelease")

            ' Reset machine game release and os version values...
            mMachine.GameRelease = aGameRelease
            mMachine.OSVersion = aOSVersion

            ' Log the update.
            If mTraceSwitch.TraceWarning Then _
               Trace.WriteLine(FormatLogOutput(String.Format("Machine {0} Version updated. GameRelease is {1}, OSVersion is {2}.", lMachineNumber, aGameRelease, aOSVersion)))
         End With

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then _
            Trace.WriteLine(FormatLogOutput("DbTpUpdateMachineGameRelease error: " & ex.ToString))

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Private Sub DbTpUpdateMachineVersions(ByVal aVersionData As String)
      '--------------------------------------------------------------------------------
      ' Routine to update the machine versions in the machine setup table.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing

      Dim lPerformUpdate As Boolean = False

      Dim lFieldCount As Integer
      Dim lIndex As Integer

      Dim lVersionField() As String

      Dim lArgumentName As String = ""
      Dim lFieldData As String
      Dim lMachineNumber As String = mMachine.MachineNumber

      Try
         ' Create a new Database instance.
         lDB = New Database(mConnectionString)

         ' Add the MachineNumber parameter.
         lDB.AddParameter("@MachineNumber", lMachineNumber)

         ' Parse version information into an array...
         lVersionField = aVersionData.Split("+".ToCharArray)
         lFieldCount = lVersionField.Length

         For lIndex = 0 To lFieldCount - 1
            ' Store field data of current element and contrain to 16 characters max...
            lFieldData = lVersionField(lIndex).Trim()
            If lFieldData.Length > 16 Then lFieldData = lFieldData.Substring(0, 16)

            Select Case lIndex
               Case 0
                  lArgumentName = "@OSVersion"
                  If mMachine.OSVersion <> lFieldData Then
                     mMachine.OSVersion = lFieldData
                     lPerformUpdate = True
                  End If

               Case 1
                  lArgumentName = "@GameRelease"
                  If mMachine.GameRelease <> lFieldData Then
                     mMachine.GameRelease = lFieldData
                     lPerformUpdate = True
                  End If

               Case 2
                  lArgumentName = "@SystemVersion"
                  If mMachine.SystemVersion <> lFieldData Then
                     mMachine.SystemVersion = lFieldData
                     lPerformUpdate = True
                  End If

               Case 3
                  lArgumentName = "@SystemLibAVersion"
                  If mMachine.SysLibAVersion <> lFieldData Then
                     mMachine.SysLibAVersion = lFieldData
                     lPerformUpdate = True
                  End If

               Case 4
                  lArgumentName = "@SystemCoreLibVersion"
                  If mMachine.SysCoreLibVersion <> lFieldData Then
                     mMachine.SysCoreLibVersion = lFieldData
                     lPerformUpdate = True
                  End If

               Case 5
                  lArgumentName = "@MathDllVersion"
                  If mMachine.MathDllVersion <> lFieldData Then
                     mMachine.MathDllVersion = lFieldData
                     lPerformUpdate = True
                  End If

               Case 6
                  lArgumentName = "@GameCoreLibVersion"
                  If mMachine.GameCoreLibVersion <> lFieldData Then
                     mMachine.GameCoreLibVersion = lFieldData
                     lPerformUpdate = True
                  End If

               Case 7
                  lArgumentName = "@GameLibVersion"
                  If mMachine.GameLibVersion <> lFieldData Then
                     mMachine.GameLibVersion = lFieldData
                     lPerformUpdate = True
                  End If

               Case 8
                  lArgumentName = "@MathLibVersion"
                  If mMachine.MathLibVersion <> lFieldData Then
                     mMachine.MathLibVersion = lFieldData
                     lPerformUpdate = True
                  End If

               Case Else
                  ' We only want to add 9 version parameters.
                  Exit For
            End Select

            ' Add Parameters
            lDB.AddParameter(lArgumentName, lFieldData)
         Next

         ' Execute stored procedure tp
         If lPerformUpdate Then
            lDB.ExecuteProcedure("tpUpdateMachineGameRelease")
            ' Log the update.
            If mTraceSwitch.TraceWarning Then
               Trace.WriteLine(FormatLogOutput(String.Format("Machine {0} Version updated. Version Data: {1}.", lMachineNumber, aVersionData)))
            End If
         End If

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then _
            Trace.WriteLine(FormatLogOutput("DbTpUpdateMachineVersions error: " & ex.ToString))

      Finally
         ' Cleanup...
         If lDB IsNot Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

   End Sub

   Private Function PopulateLastMachineMessage() As LastMachineMessage
      '--------------------------------------------------------------------------------
      ' Function populates the LastMachineMessage.vb class.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As Database = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDR As DataRow
      Dim lMachineNumber As String = mMachine.MachineNumber
      Dim lLastMessage As LastMachineMessage = New LastMachineMessage()
      Dim lSequenceNumber As Integer
      Dim lTransType As String
      Dim lTPResponse As String

      Try
         ' Instantiate a new Database object.
         lDB = New Database(ConnectionString)

         ' Add the MachineNumber parameter.
         lDB.AddParameter("@MachineNumber", lMachineNumber)

         ' Execute the stored procedure.
         lDT = lDB.CreateDataTableSP("GetLastMachineMessage")

         ' Was a row of data returned in the DataTable?
         If lDT.Rows.Count > 0 Then

            lDR = lDT.Rows(0)

            lSequenceNumber = CType(lDR.Item("MachineSequenceNumber"), Integer)
            lTransType = CType(lDR.Item("TransType"), String)
            lTPResponse = CType(lDR.Item("TPResponse"), String)

            lLastMessage = New LastMachineMessage(lSequenceNumber, lTransType, lTPResponse)
         Else
            ' No row returned, setting variables to empty strings.
            lLastMessage = New LastMachineMessage(0, String.Empty, String.Empty)

         End If

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then _
            Trace.WriteLine(FormatLogOutput("PopulateLastMachineMessage error: " & ex.ToString))

         ' On error return emtpy last machine message
         Return New LastMachineMessage()
      End Try

      Return lLastMessage

   End Function

   Private Function SaveLastMachineMessage(ByVal aResponseHash As Hashtable) As LastMachineMessage
      '--------------------------------------------------------------------------------
      ' Routin inserts/updates the last TP response.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSuccess As Boolean = False
      Dim lReturnValue As LastMachineMessage = New LastMachineMessage()


      Dim lDB As Database = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDR As DataRow

      Dim lErrorText As String
      Dim lMachineNumber As String
      Dim lSequenceNumber As Integer
      Dim lTPResponse As String = ""
      Dim lTransType As String

      Dim xmlOutput As String
      Dim xmlResponseItem As String

      lMachineNumber = mMachine.MachineNumber
      lSequenceNumber = CType(aResponseHash("MachineSequence"), Integer)
      lTransType = CType(aResponseHash("TransType"), String)

      xmlOutput = String.Format("<?xml version=""1.0"" standalone=""yes""?>{0}<Responses>{0}", Environment.NewLine)
      xmlResponseItem = "<ResponseItem><key>{0}</key><value>{1}</value></ResponseItem>" + Environment.NewLine

      Try
         ' Build TPResponse string to be stored in the database.
         For Each key As String In aResponseHash.Keys
            xmlOutput += String.Format(xmlResponseItem, key, CType(aResponseHash(key), String))
         Next

         lTPResponse = xmlOutput + "</Responses>"

         ' Instantiate a new Database object.
         lDB = New Database(ConnectionString)

         ' Add the MachineNumber parameter.
         lDB.AddParameter("@MachineNumber", lMachineNumber)
         lDB.AddParameter("@SequenceNumber", lSequenceNumber.ToString)
         lDB.AddParameter("@TransType", lTransType)
         lDB.AddParameter("@TPResponse", lTPResponse)

         ' Execute the stored procedure.
         lDT = lDB.CreateDataTableSP("SaveLastMachineMessage")

         ' Was a row of data returned in the DataTable?
         If lDT.Rows.Count > 0 Then
            lDR = lDT.Rows(0)
            lSuccess = (CType(lDR.Item("ReturnValue"), Integer) = 0)
         End If

         lReturnValue = New LastMachineMessage(lSequenceNumber, lTransType, lTPResponse)

         ' Log if insert/update failed.
         If lSuccess = False Then
            lErrorText = String.Format(" Failed to save/update last machine message. Machine:{0} TPResponse:'{1}'", lMachineNumber, lTPResponse)
            If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(lErrorText))
         End If

         If lReturnValue Is Nothing Then
            lErrorText = String.Format(" Failed to save/update last machine message object. Machine:{0} TPResponse:'{1}'", lMachineNumber, lTPResponse)
            If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput(lErrorText))
         End If

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then _
            Trace.WriteLine(FormatLogOutput("SaveLastMachineMessage error: " & ex.ToString))


         ' On error return emtpy last machine message
         Return New LastMachineMessage()
      End Try

      Return lReturnValue

   End Function

   Private Function ResendTPResponse() As Hashtable
      '--------------------------------------------------------------------------------
      ' Function resends the last TPResponse store in the database.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturnHash As New Hashtable
      Dim lTPResponse As String
      Dim lKey As String
      Dim lValue As String
      Dim lDR As DataRow
      Dim lDT As DataTable

      lTPResponse = mLastMachineResponse.TPResponse

      ' Build a new hashtable.
      Using lDS As New DataSet
         lDS.ReadXml(New StringReader(lTPResponse), XmlReadMode.InferSchema)

         If lDS.Tables.Count > 0 Then

            lDT = lDS.Tables("ResponseItem")

            For Each lDR In lDT.Rows
               lKey = lDR.Item("Key").ToString
               lValue = lDR.Item("Value").ToString

               lReturnHash.Add(lKey, lValue)

            Next
         End If
      End Using

      Return lReturnHash
   End Function

   Private Function CheckForDuplicateMessage(ByVal MessageHT As Hashtable) As Boolean
      '--------------------------------------------------------------------------------
      ' Function verifies the last message received was not a duplicate message.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = False
      Dim lSequenceNumber As Integer
      Dim lTransType As String


      Try
         lSequenceNumber = CType(MessageHT("MachineSequence"), Integer)
         lTransType = CType(MessageHT("TransType"), String)

         If (mLastMachineResponse Is Nothing) Then
            Throw New Exception("mLastMachineResponse cannot be Null.")
         End If

         ' Make sure current machine message is a not a duplicate.
         If lSequenceNumber = mLastMachineResponse.SequenceNumber AndAlso lTransType = mLastMachineResponse.TransType Then
            lReturn = True
         End If
      Catch ex As Exception

         If mTraceSwitch.TraceError Then _
             Trace.WriteLine(FormatLogOutput("CheckForDuplicateMessage error: " & ex.ToString))

         Return False
      End Try


      Return lReturn

   End Function

   Private Function GetProgressiveMachines(ByVal aMachineNumber As String) As List(Of String)
      '--------------------------------------------------------------------------------
      ' Function populates the LastMachineMessage.vb class.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lMachineNumber As String = mMachine.MachineNumber
      Dim lSQL As String
      Dim machineList As New List(Of String)

      Try
         lSQL = String.Format("SELECT IP_ADDRESS FROM dbo.uvwMachineSetup WHERE GT_PROGRESSIVE_TYPE_ID = (SELECT GT_PROGRESSIVE_TYPE_ID FROM dbo.uvwMachineSetup WHERE MACH_NO = '{0}')", aMachineNumber)

         ' Instantiate a new Database object.
         Using lDB As New Database(ConnectionString)
            Using machineDT As DataTable = lDB.CreateDataTable(lSQL)

               For Each dr As DataRow In machineDT.Rows
                  machineList.Add(CStr(dr("IP_ADDRESS")))
               Next

            End Using
         End Using

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("GetProgressiveMachinesList error: " & ex.ToString))
      End Try

      Return machineList

   End Function

#End Region

#Region " Clean Up "

   Public Overridable Sub TPICleanup()
      '--------------------------------------------------------------------------------
      ' Remove event handlers, close connections etc
      '--------------------------------------------------------------------------------

      Try
         RemoveHandler mChecksumTimer.Elapsed, AddressOf OnChecksumTimerEvent
      Catch
      End Try

   End Sub

   ' Implement IDisposable.
   Public Overloads Sub Dispose() Implements IDisposable.Dispose
      '--------------------------------------------------------------------------------
      ' 
      '--------------------------------------------------------------------------------
      TPICleanup()
      Dispose(True)
      GC.SuppressFinalize(Me)

   End Sub

   Protected Overridable Overloads Sub Dispose(ByVal disposing As Boolean)
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------

      If disposing Then
         ' Free other state (managed objects).
      End If
      ' Free your own state (unmanaged objects).
      ' Set large fields to null.

   End Sub

   Protected Overrides Sub Finalize()
      ' Simply call Dispose(False).
      Dispose(False)
   End Sub

#End Region

End Class
