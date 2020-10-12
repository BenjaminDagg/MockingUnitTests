Option Explicit On 
Option Strict On

Imports System.ServiceProcess
Imports DataAccess

Public Class TransactionPortalService
   Inherits System.ServiceProcess.ServiceBase

#Region " Component Designer generated code "

   Public Sub New()
      MyBase.New()

      ' This call is required by the Component Designer.
      InitializeComponent()

      ' Add any initialization after the InitializeComponent() call

      ' Add the event handler for the "StopBingoBlowerService" event.
      AddHandler Startup.StopTransactionPortalService, AddressOf Me.Stop

   End Sub

   'UserService overrides dispose to clean up the component list.
   Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
      If disposing Then
         If Not (components Is Nothing) Then
            components.Dispose()
         End If
      End If
      MyBase.Dispose(disposing)
   End Sub

   ' The main entry point for the process
   <MTAThread()> _
   Shared Sub Main()
      If Debugger.IsAttached = False Then

         Dim ServicesToRun() As System.ServiceProcess.ServiceBase

         ' More than one NT Service may run within the same process. To add
         ' another service to this process, change the following line to
         ' create a second service object. For example,
         '
         '   ServicesToRun = New System.ServiceProcess.ServiceBase () {New Service1, New MySecondUserService}
         '
         ServicesToRun = New System.ServiceProcess.ServiceBase() {New TransactionPortalService}

         System.ServiceProcess.ServiceBase.Run(ServicesToRun)
      Else
         ' Change by Edris (remove/comment out in production)
         ' Allows you to run service as application with debugger
         Startup.Main()

         System.Threading.Thread.Sleep(System.Threading.Timeout.Infinite)

      End If
   End Sub

   'Required by the Component Designer
   Private components As System.ComponentModel.IContainer

   ' NOTE: The following procedure is required by the Component Designer
   ' It can be modified using the Component Designer.  
   ' Do not modify it using the code editor.
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      '
      'TransactionPortalService
      '
      Me.ServiceName = "Transaction Portal"

   End Sub

#End Region

   Protected Overrides Sub OnStart(ByVal args() As String)
      '--------------------------------------------------------------------------------
      ' Add service startup code here.
      '--------------------------------------------------------------------------------

      ' Call initialization routine.
      Call Startup.Main()

   End Sub

   Protected Overrides Sub OnStop()
      '--------------------------------------------------------------------------------
      ' Add code here to perform any tear-down necessary to stop your service.
      '--------------------------------------------------------------------------------

      Dim lMachineNumber As String = ""
      Dim lMachine As Machine



      If gMachineCollection IsNot Nothing Then
         Trace.WriteLine(FormatLogOutput("Recording connection status for connection machines: " & gMachineCollection.Count))

         For Each lItem As DictionaryEntry In gMachineCollection
            Try

               lMachine = CType(lItem.Value, Machine)
               lMachineNumber = lMachine.MachineNumber

               Using lDB As New Database(gConnectionString)
                  With lDB
                     ' Add Machine Number and Status Type (1 for connected)...
                     .AddParameter("@MachineNumber", lMachineNumber)
                     .AddParameter("@StatusType", "0")

                     ' Execute the stored procedure
                     .ExecuteProcedure("[RecordMachineConnection]")
                  End With
               End Using



            Catch ex As Exception
               Trace.WriteLine(FormatLogOutput("TP Cleanup: (Machine " & lMachineNumber & ") Failed to record last connection to database: " & ex.Message))
            End Try


         Next

      End If


      If (Not goTraceSwitch Is Nothing) Then
         If goTraceSwitch.TraceError Then Trace.WriteLine(FormatLogOutput("Transaction Portal STOPPED. Version: " & My.Application.Info.Version.ToString))
      End If

   End Sub

End Class
