Option Explicit On 
Option Strict On

Imports System.IO
Imports System.ServiceProcess

Public Class mdiParentForm
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
   Friend WithEvents mnuMain As System.Windows.Forms.MainMenu
   Friend WithEvents mnuFile As System.Windows.Forms.MenuItem
   Friend WithEvents mnuTools As System.Windows.Forms.MenuItem
   Friend WithEvents mnuViewLog As System.Windows.Forms.MenuItem
   Friend WithEvents mnuFileExit As System.Windows.Forms.MenuItem
   Friend WithEvents mnuHelp As System.Windows.Forms.MenuItem
   Friend WithEvents mnuOptions As System.Windows.Forms.MenuItem
   Friend WithEvents mnuWindow As System.Windows.Forms.MenuItem
   Friend WithEvents AppNotifyIcon As System.Windows.Forms.NotifyIcon
   Friend WithEvents mnuMachineManager As System.Windows.Forms.MenuItem
   Friend WithEvents mnuLogFileLocation As System.Windows.Forms.MenuItem
   Friend WithEvents mnuClearLog As System.Windows.Forms.MenuItem
   Friend WithEvents mnuHelpAbout As System.Windows.Forms.MenuItem
   Friend WithEvents mnuTPConfig As System.Windows.Forms.MenuItem
   Friend WithEvents mnuSchedulePromoTickets As System.Windows.Forms.MenuItem
   Friend WithEvents mnuTPStatus As System.Windows.Forms.MenuItem
   Friend WithEvents mnuSDGDailyMeterReport As System.Windows.Forms.MenuItem
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.components = New System.ComponentModel.Container()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(mdiParentForm))
      Me.mnuMain = New System.Windows.Forms.MainMenu(Me.components)
      Me.mnuFile = New System.Windows.Forms.MenuItem()
      Me.mnuFileExit = New System.Windows.Forms.MenuItem()
      Me.mnuTools = New System.Windows.Forms.MenuItem()
      Me.mnuViewLog = New System.Windows.Forms.MenuItem()
      Me.mnuMachineManager = New System.Windows.Forms.MenuItem()
      Me.mnuSDGDailyMeterReport = New System.Windows.Forms.MenuItem()
      Me.mnuSchedulePromoTickets = New System.Windows.Forms.MenuItem()
      Me.mnuTPStatus = New System.Windows.Forms.MenuItem()
      Me.mnuOptions = New System.Windows.Forms.MenuItem()
      Me.mnuLogFileLocation = New System.Windows.Forms.MenuItem()
      Me.mnuClearLog = New System.Windows.Forms.MenuItem()
      Me.mnuTPConfig = New System.Windows.Forms.MenuItem()
      Me.mnuWindow = New System.Windows.Forms.MenuItem()
      Me.mnuHelp = New System.Windows.Forms.MenuItem()
      Me.mnuHelpAbout = New System.Windows.Forms.MenuItem()
      Me.AppNotifyIcon = New System.Windows.Forms.NotifyIcon(Me.components)
      Me.SuspendLayout()
      '
      'mnuMain
      '
      Me.mnuMain.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuFile, Me.mnuTools, Me.mnuOptions, Me.mnuWindow, Me.mnuHelp})
      '
      'mnuFile
      '
      Me.mnuFile.Index = 0
      Me.mnuFile.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuFileExit})
      Me.mnuFile.Text = "&File"
      '
      'mnuFileExit
      '
      Me.mnuFileExit.Index = 0
      Me.mnuFileExit.Text = "&Exit"
      '
      'mnuTools
      '
      Me.mnuTools.Index = 1
      Me.mnuTools.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuViewLog, Me.mnuMachineManager, Me.mnuSDGDailyMeterReport, Me.mnuSchedulePromoTickets, Me.mnuTPStatus})
      Me.mnuTools.Text = "&Tools"
      '
      'mnuViewLog
      '
      Me.mnuViewLog.Index = 0
      Me.mnuViewLog.Text = "Log Viewer"
      '
      'mnuMachineManager
      '
      Me.mnuMachineManager.Index = 1
      Me.mnuMachineManager.Text = "Machine Manager"
      '
      'mnuSDGDailyMeterReport
      '
      Me.mnuSDGDailyMeterReport.Index = 2
      Me.mnuSDGDailyMeterReport.Text = "SDG Daily Meter Report"
      '
      'mnuSchedulePromoTickets
      '
      Me.mnuSchedulePromoTickets.Index = 3
      Me.mnuSchedulePromoTickets.Text = "Schedule Promo Entry Tickets"
      Me.mnuSchedulePromoTickets.Visible = False
      '
      'mnuTPStatus
      '
      Me.mnuTPStatus.Index = 4
      Me.mnuTPStatus.Text = "Transaction Portal Service Status"
      '
      'mnuOptions
      '
      Me.mnuOptions.Index = 2
      Me.mnuOptions.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuLogFileLocation, Me.mnuClearLog, Me.mnuTPConfig})
      Me.mnuOptions.MergeType = System.Windows.Forms.MenuMerge.MergeItems
      Me.mnuOptions.Text = "&Options"
      '
      'mnuLogFileLocation
      '
      Me.mnuLogFileLocation.Index = 0
      Me.mnuLogFileLocation.Text = "Settings"
      '
      'mnuClearLog
      '
      Me.mnuClearLog.Index = 1
      Me.mnuClearLog.Text = "Clear Log"
      Me.mnuClearLog.Visible = False
      '
      'mnuTPConfig
      '
      Me.mnuTPConfig.Index = 2
      Me.mnuTPConfig.Text = "TP Configuration"
      Me.mnuTPConfig.Visible = False
      '
      'mnuWindow
      '
      Me.mnuWindow.Index = 3
      Me.mnuWindow.MdiList = True
      Me.mnuWindow.Text = "&Window"
      Me.mnuWindow.Visible = False
      '
      'mnuHelp
      '
      Me.mnuHelp.Index = 4
      Me.mnuHelp.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuHelpAbout})
      Me.mnuHelp.Text = "&Help"
      '
      'mnuHelpAbout
      '
      Me.mnuHelpAbout.Index = 0
      Me.mnuHelpAbout.Text = "About"
      '
      'AppNotifyIcon
      '
      Me.AppNotifyIcon.BalloonTipText = "This is balloon tip text here."
      Me.AppNotifyIcon.BalloonTipTitle = "This here is balloon tip Title"
      Me.AppNotifyIcon.Icon = CType(resources.GetObject("AppNotifyIcon.Icon"), System.Drawing.Icon)
      Me.AppNotifyIcon.Text = "Transaction Portal Control"
      Me.AppNotifyIcon.Visible = True
      '
      'mdiParentForm
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(995, 575)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.IsMdiContainer = True
      Me.Menu = Me.mnuMain
      Me.Name = "mdiParentForm"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Transaction Portal Control"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private mStartupSize As Drawing.Size
   Private mStartupLocation As Drawing.Point

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Include the applicatin version in the caption.
      Me.Text = Me.Text & " v" & My.Application.Info.Version.ToString

      mnuSchedulePromoTickets.Visible = (My.Settings.ApplicationType = 2 Or My.Settings.ApplicationType = 3)
      mnuClearLog.Visible = (My.Settings.ApplicationType = 3)
      mnuTPConfig.Visible = (My.Settings.ApplicationType = 3)

      ' Disable the "SDG Daily Meter Report" menu item if TPI_ID <> 1
      If (gTpiID <> 1) Then
         mnuSDGDailyMeterReport.Enabled = False
         mnuSDGDailyMeterReport.Visible = False
      End If

      ' Store original startup size and location...
      mStartupSize = Me.Size
      mStartupLocation = Me.Location

      If gTpiID = 1 Then
         Debug.WriteLine("1")
      End If
   End Sub

   Private Sub mnuViewLog_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuViewLog.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the View Log File menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lLogViewer As New LogViewer

      With lLogViewer
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuFileExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuFileExit.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the File Exit menu item.
      '--------------------------------------------------------------------------------

      ' User wants to close this application.
      Me.Close()

   End Sub

   Private Sub mnuMachineManager_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuMachineManager.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Machine Manager menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lMachineManager As New MachineManager

      With lMachineManager
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuLogFileLocation_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuLogFileLocation.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Log File Location menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSettings As New AppSettings(0)

      With lSettings
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuClearLog_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuClearLog.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Log File Location menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lConfirmText As String
      Dim lErrorText As String

      ' Does the log file exist?
      If File.Exists(gLogFile) Then
         ' Yes, so we can continue.
         ' Build user confirmation message...
         lConfirmText = "Clearing the log ({0}) will delete it.{1}{1}Are you sure that you want to delete the log file?"
         lConfirmText = String.Format(lConfirmText, gLogFile, gCrLf)

         ' Allow user to confirm this action...
         If MessageBox.Show(lConfirmText, "Please Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = Windows.Forms.DialogResult.Yes Then
            ' User confirmed, attempt to drop the file if it exists...
            Try
               File.Delete(gLogFile)
               MessageBox.Show("Log File Cleared.", "Log File Status", MessageBoxButtons.OK, MessageBoxIcon.Information)

            Catch ex As Exception
               ' Handle the exception...
               lErrorText = Me.Name & "::mnuClearLog_Click error: " & ex.Message
               MessageBox.Show(lErrorText, "Clear Log Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

            End Try

         End If
      Else
         ' Log file does not exist. Inform the user.
         lErrorText = String.Format("Log file{1}{0}{1}was not found and therefore cannot be cleared.", gLogFile, gCrLf)
         MessageBox.Show(lErrorText, "Clear Log Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub mnuPollingInterval_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
      '--------------------------------------------------------------------------------
      ' The ability to change the polling frequency appears to have been removed.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSettings As New AppSettings(1)

      With lSettings
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuServerLocation_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
      '--------------------------------------------------------------------------------
      ' The ability to change the Server Location (IP Address) appears
      ' to have been removed.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSettings As New AppSettings(1)

      With lSettings
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuHelpAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuHelpAbout.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Help About menu item.
      ' Show the application Help About form
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAbout As New frmAbout

      With lAbout
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub AppNotifyIcon_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles AppNotifyIcon.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the NotifyIcon control.
      '--------------------------------------------------------------------------------

      ' Are we minimized?
      If Me.WindowState = FormWindowState.Minimized Then
         Me.WindowState = FormWindowState.Normal

         Me.Location = mStartupLocation
         Me.Size = mStartupSize
         Me.Show()
      End If

      Me.TopMost = True
      Me.TopMost = False

   End Sub

   'Private Sub mdiParentForm_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Resize

   '   If Me.WindowState = FormWindowState.Minimized Then Me.Visible = False

   'End Sub

   Protected Overrides Sub Finalize()
      MyBase.Finalize()
   End Sub

   Private Sub mnuTPConfig_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuTPConfig.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the TP Configuration menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lTpConfig As New TPConfig

      ' Show the tp configuration form as an mdi child to this form.
      With lTpConfig
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuSDGDailyMeterReport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuSDGDailyMeterReport.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for 'SDG Daily Meter Report' menu item.
      '--------------------------------------------------------------------------------

      ' Show "SDG Daily Meter" form.
      Dim lSDGReportForm As New SDGDailyMeterReportForm
      With lSDGReportForm
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuSchedulePromoTickets_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuSchedulePromoTickets.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Schedule Promo Entry Tickets menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Show the Schedule viewer
      Dim lPTSViewer As New PromoTicketScheduleView
      With lPTSViewer
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuTPStatus_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuTPStatus.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Transaction Portal Service Status menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSC As System.ServiceProcess.ServiceController
      Dim lStatusText As String = ""

      Try
         lSC = New ServiceController("Transaction Portal", My.Settings.TPServerName)
         lStatusText = lSC.DisplayName & " status: " & lSC.Status.ToString
         lSC.Close()

      Catch ex As Exception
         lStatusText = "Error retrieving TP Status: " & ex.Message
      End Try

      MessageBox.Show(lStatusText, "TP Status", MessageBoxButtons.OK)

   End Sub

   Private Sub mnuTools_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuTools.Click

   End Sub
End Class
