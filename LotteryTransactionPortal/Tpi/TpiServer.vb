Option Explicit On 
Option Strict On

Imports DataAccess
Imports System
Imports System.Configuration

Public Class TpiServer

   ' Events
   Public Event ShutdownServer(ByVal ErrorId As Integer, ByVal ErrorDescription As String)
   Public Event StartupServer()

   ' Property Variables for TraceSwitch, ConnectionString
   Private mTraceSwitch As TraceSwitch
   Private mConnectionString As String
   Private mVoucherPrintFlagTimeout As Integer = 0
   Private mIsVoucherPrintFlagEnabled As Boolean = False

   Public Property TraceSwitch() As TraceSwitch

      Get
         Return mTraceSwitch
      End Get

      Set(ByVal Value As TraceSwitch)
         mTraceSwitch = Value
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

   Public Property VoucherPrintFlagTimeout() As Integer
      Get
         Return mVoucherPrintFlagTimeout
      End Get
      Set(ByVal value As Integer)
         mVoucherPrintFlagTimeout = value
      End Set
   End Property

   Public Property IsVoucherPrintFlagEnabled() As Boolean
      Get
         Return mIsVoucherPrintFlagEnabled
      End Get
      Set(ByVal value As Boolean)
         mIsVoucherPrintFlagEnabled = value
      End Set
   End Property


   Public Overridable Sub Startup()
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------
      Dim lASR As New AppSettingsReader
      Dim lErrorText As String = ""
      Dim lVoucherPrintFlagEnableInteger As Integer = 0

      ' Truncate the TPI_SETTING setting table for DGE
      If DbTpTruncateTpiSetting() Then
         If mTraceSwitch.TraceVerbose Then Trace.WriteLine(FormatLogOutput("TpiServer Startup: TPI_SETTING table truncated successfully"))
      End If

      ' Set and parse the VoucherPrintFlagTimeout
      If (Integer.TryParse(CStr(lASR.GetValue("VoucherPrintFlagTimeout", Type.GetType("System.String"))), mVoucherPrintFlagTimeout) = False) Then
         lErrorText = "Unable to parse 'VoucherPrintFlagTimeout' from config file, exiting application."
         Throw New Exception(lErrorText)
      Else
         mVoucherPrintFlagTimeout = mVoucherPrintFlagTimeout * 1000
      End If


      ' Set and parse the VoucherPrintFlagTimeout
      If (Integer.TryParse(CStr(lASR.GetValue("VoucherPrintFlagTimeoutEnabled", Type.GetType("System.String"))), lVoucherPrintFlagEnableInteger) = False) Then
         lErrorText = "Unable to parse 'VoucherPrintFlagTimeoutEnabled' from config file, exiting application."
         Throw New Exception(lErrorText)
      Else

         If lVoucherPrintFlagEnableInteger = 1 Then
            mIsVoucherPrintFlagEnabled = True
         Else
            mIsVoucherPrintFlagEnabled = False
         End If

      End If


   End Sub

   Public Overridable Sub Shutdown()

   End Sub

   Public Function FormatLogOutput(ByVal Message As String) As String

      Return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") & " " & Message

   End Function

#Region "Database Calls"

   Private Function DbTpTruncateTpiSetting() As Boolean
      '--------------------------------------------------------------------------------
      ' Returns True or False based upon success of Truncating TPI_SETTING table.
      ' Called by: Startup
      '     Calls: tpTruncateTpiSetting
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = False
      Dim lDB As Database = Nothing
      Dim lDS As DataSet

      Try
         lDB = New Database(ConnectionString)
         lDS = lDB.ExecuteProcedure("tpTruncateTpiSetting")
         lReturn = True

      Catch ex As Exception
         ' Handle the exception...
         If mTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("(TpiServer::DbTpTruncateTpiSetting error: " & ex.ToString))
         lReturn = False

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

#End Region

End Class