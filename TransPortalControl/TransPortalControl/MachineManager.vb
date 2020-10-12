Option Strict On

Imports System.Data
Imports System.Data.SqlClient
Imports System.ServiceProcess
Imports System.Text
Imports System.Text.RegularExpressions
Imports System.Timers

Public Class MachineManager
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
   Friend WithEvents MainMenu1 As System.Windows.Forms.MainMenu
   Friend WithEvents mnuCloseMachineManager As System.Windows.Forms.MenuItem
   Friend WithEvents tbarMain As System.Windows.Forms.ToolBar
   Friend WithEvents btnResetCounters As System.Windows.Forms.ToolBarButton
   Friend WithEvents btnShutdownMachine As System.Windows.Forms.ToolBarButton
   Friend WithEvents btnStartupMachine As System.Windows.Forms.ToolBarButton
   Friend WithEvents btnUpdate As System.Windows.Forms.ToolBarButton
   Friend WithEvents Sep01 As System.Windows.Forms.ToolBarButton
   Friend WithEvents Sep02 As System.Windows.Forms.ToolBarButton
   Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
   Friend WithEvents lvwMachineList As System.Windows.Forms.ListView
   Friend WithEvents colCasinoMachineNumber As System.Windows.Forms.ColumnHeader
   Friend WithEvents colIPAddress As System.Windows.Forms.ColumnHeader
   Friend WithEvents colMsgSentCount As System.Windows.Forms.ColumnHeader
   Friend WithEvents colMsgReceivedCount As System.Windows.Forms.ColumnHeader
   Friend WithEvents colStatus As System.Windows.Forms.ColumnHeader
   Friend WithEvents colTransType As System.Windows.Forms.ColumnHeader
   Friend WithEvents colGameCode As System.Windows.Forms.ColumnHeader
   Friend WithEvents btnRequestSetup As System.Windows.Forms.ToolBarButton
   Friend WithEvents colDgeMachineNumber As System.Windows.Forms.ColumnHeader
   Friend WithEvents Sep03 As System.Windows.Forms.ToolBarButton
   Friend WithEvents btnShowMessage As System.Windows.Forms.ToolBarButton
   Friend WithEvents Sep04 As System.Windows.Forms.ToolBarButton
   Friend WithEvents btnReboot As System.Windows.Forms.ToolBarButton
   Friend WithEvents Sep05 As System.Windows.Forms.ToolBarButton
   Friend WithEvents btnComputeChecksum As System.Windows.Forms.ToolBarButton
   Friend WithEvents Sep06 As System.Windows.Forms.ToolBarButton
   Friend WithEvents Sep07 As System.Windows.Forms.ToolBarButton
   Friend WithEvents ReadyToPlay As System.Windows.Forms.ToolBarButton
   Friend WithEvents btnDeActivate As System.Windows.Forms.ToolBarButton
   Friend WithEvents ContextMenu1 As System.Windows.Forms.ContextMenu
   Friend WithEvents mnuCMStartup As System.Windows.Forms.MenuItem
   Friend WithEvents mnuCMShutdown As System.Windows.Forms.MenuItem
   Friend WithEvents mnuCMRequestSetup As System.Windows.Forms.MenuItem
   Friend WithEvents mnuCMResumeMachine As System.Windows.Forms.MenuItem
   Friend WithEvents colVoucherPrinting As System.Windows.Forms.ColumnHeader
   Friend WithEvents mnuPollInterval As System.Windows.Forms.MenuItem
   Friend WithEvents mnuOptions As System.Windows.Forms.MenuItem
   Friend WithEvents mnuServer As System.Windows.Forms.MenuItem
   Friend WithEvents mnuTracing As System.Windows.Forms.MenuItem
   Friend WithEvents Seperator1 As System.Windows.Forms.ToolBarButton
   Friend WithEvents Seperator2 As System.Windows.Forms.ToolBarButton
   Friend WithEvents Separator3 As System.Windows.Forms.ToolBarButton
   Friend WithEvents Separator4 As System.Windows.Forms.ToolBarButton
   Friend WithEvents Separator5 As System.Windows.Forms.ToolBarButton
   Friend WithEvents Separator6 As System.Windows.Forms.ToolBarButton
   Friend WithEvents Separator7 As System.Windows.Forms.ToolBarButton
   Friend WithEvents lblUserInfo As System.Windows.Forms.Label
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
   Friend WithEvents mnuPromoTicketToggle As System.Windows.Forms.MenuItem
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MachineManager))
        Me.MainMenu1 = New System.Windows.Forms.MainMenu(Me.components)
        Me.mnuOptions = New System.Windows.Forms.MenuItem()
        Me.mnuPollInterval = New System.Windows.Forms.MenuItem()
        Me.mnuServer = New System.Windows.Forms.MenuItem()
        Me.mnuTracing = New System.Windows.Forms.MenuItem()
        Me.mnuPromoTicketToggle = New System.Windows.Forms.MenuItem()
        Me.mnuCloseMachineManager = New System.Windows.Forms.MenuItem()
        Me.tbarMain = New System.Windows.Forms.ToolBar()
        Me.btnResetCounters = New System.Windows.Forms.ToolBarButton()
        Me.btnUpdate = New System.Windows.Forms.ToolBarButton()
        Me.Seperator1 = New System.Windows.Forms.ToolBarButton()
        Me.btnStartupMachine = New System.Windows.Forms.ToolBarButton()
        Me.btnShutdownMachine = New System.Windows.Forms.ToolBarButton()
        Me.Seperator2 = New System.Windows.Forms.ToolBarButton()
        Me.btnRequestSetup = New System.Windows.Forms.ToolBarButton()
        Me.Separator3 = New System.Windows.Forms.ToolBarButton()
        Me.btnShowMessage = New System.Windows.Forms.ToolBarButton()
        Me.Separator4 = New System.Windows.Forms.ToolBarButton()
        Me.btnReboot = New System.Windows.Forms.ToolBarButton()
        Me.Separator5 = New System.Windows.Forms.ToolBarButton()
        Me.btnComputeChecksum = New System.Windows.Forms.ToolBarButton()
        Me.Separator6 = New System.Windows.Forms.ToolBarButton()
        Me.btnDeActivate = New System.Windows.Forms.ToolBarButton()
        Me.Separator7 = New System.Windows.Forms.ToolBarButton()
        Me.ReadyToPlay = New System.Windows.Forms.ToolBarButton()
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.lvwMachineList = New System.Windows.Forms.ListView()
        Me.colCasinoMachineNumber = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.colIPAddress = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.colMsgSentCount = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.colMsgReceivedCount = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.colStatus = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.colTransType = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.colGameCode = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.colDgeMachineNumber = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.colVoucherPrinting = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.ContextMenu1 = New System.Windows.Forms.ContextMenu()
        Me.mnuCMStartup = New System.Windows.Forms.MenuItem()
        Me.mnuCMShutdown = New System.Windows.Forms.MenuItem()
        Me.mnuCMRequestSetup = New System.Windows.Forms.MenuItem()
        Me.mnuCMResumeMachine = New System.Windows.Forms.MenuItem()
        Me.lblUserInfo = New System.Windows.Forms.Label()
        Me.lblGridHeader = New System.Windows.Forms.Label()
        Me.SuspendLayout()
        '
        'MainMenu1
        '
        Me.MainMenu1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuOptions})
        '
        'mnuOptions
        '
        Me.mnuOptions.Index = 0
        Me.mnuOptions.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuPollInterval, Me.mnuServer, Me.mnuTracing, Me.mnuPromoTicketToggle, Me.mnuCloseMachineManager})
        Me.mnuOptions.MergeType = System.Windows.Forms.MenuMerge.MergeItems
        Me.mnuOptions.Text = "&Options"
        '
        'mnuPollInterval
        '
        Me.mnuPollInterval.Index = 0
        Me.mnuPollInterval.Text = "Poll Interval"
        '
        'mnuServer
        '
        Me.mnuServer.Index = 1
        Me.mnuServer.Text = "Server"
        '
        'mnuTracing
        '
        Me.mnuTracing.Index = 2
        Me.mnuTracing.Text = "Tracing"
        '
        'mnuPromoTicketToggle
        '
        Me.mnuPromoTicketToggle.Index = 3
        Me.mnuPromoTicketToggle.Text = "Turn Promo Ticket OnOff"
        '
        'mnuCloseMachineManager
        '
        Me.mnuCloseMachineManager.Index = 4
        Me.mnuCloseMachineManager.Text = "Close Machine Manager"
        '
        'tbarMain
        '
        Me.tbarMain.Buttons.AddRange(New System.Windows.Forms.ToolBarButton() {Me.btnResetCounters, Me.btnUpdate, Me.Seperator1, Me.btnStartupMachine, Me.btnShutdownMachine, Me.Seperator2, Me.btnRequestSetup, Me.Separator3, Me.btnShowMessage, Me.Separator4, Me.btnReboot, Me.Separator5, Me.btnComputeChecksum, Me.Separator6, Me.btnDeActivate, Me.Separator7, Me.ReadyToPlay})
        Me.tbarMain.DropDownArrows = True
        Me.tbarMain.ImageList = Me.ImageList1
        Me.tbarMain.Location = New System.Drawing.Point(0, 0)
        Me.tbarMain.Name = "tbarMain"
        Me.tbarMain.ShowToolTips = True
        Me.tbarMain.Size = New System.Drawing.Size(908, 28)
        Me.tbarMain.TabIndex = 1
        Me.tbarMain.TabStop = True
        '
        'btnResetCounters
        '
        Me.btnResetCounters.ImageIndex = 3
        Me.btnResetCounters.Name = "btnResetCounters"
        Me.btnResetCounters.ToolTipText = "Reset Counters"
        '
        'btnUpdate
        '
        Me.btnUpdate.ImageIndex = 2
        Me.btnUpdate.Name = "btnUpdate"
        Me.btnUpdate.ToolTipText = "Update"
        '
        'Seperator1
        '
        Me.Seperator1.Name = "Seperator1"
        Me.Seperator1.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
        '
        'btnStartupMachine
        '
        Me.btnStartupMachine.ImageIndex = 4
        Me.btnStartupMachine.Name = "btnStartupMachine"
        Me.btnStartupMachine.ToolTipText = "Start Machine"
        '
        'btnShutdownMachine
        '
        Me.btnShutdownMachine.ImageIndex = 5
        Me.btnShutdownMachine.Name = "btnShutdownMachine"
        Me.btnShutdownMachine.ToolTipText = "Shutdown Machine"
        '
        'Seperator2
        '
        Me.Seperator2.Name = "Seperator2"
        Me.Seperator2.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
        '
        'btnRequestSetup
        '
        Me.btnRequestSetup.ImageIndex = 6
        Me.btnRequestSetup.Name = "btnRequestSetup"
        Me.btnRequestSetup.ToolTipText = "Request Setup"
        '
        'Separator3
        '
        Me.Separator3.Name = "Separator3"
        Me.Separator3.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
        '
        'btnShowMessage
        '
        Me.btnShowMessage.ImageIndex = 7
        Me.btnShowMessage.Name = "btnShowMessage"
        Me.btnShowMessage.ToolTipText = "Send Message to Machine(s)"
        '
        'Separator4
        '
        Me.Separator4.Name = "Separator4"
        Me.Separator4.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
        '
        'btnReboot
        '
        Me.btnReboot.ImageIndex = 8
        Me.btnReboot.Name = "btnReboot"
        Me.btnReboot.ToolTipText = "Reboot machine(s) CAUTION !!"
        '
        'Separator5
        '
        Me.Separator5.Name = "Separator5"
        Me.Separator5.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
        '
        'btnComputeChecksum
        '
        Me.btnComputeChecksum.ImageIndex = 9
        Me.btnComputeChecksum.Name = "btnComputeChecksum"
        Me.btnComputeChecksum.ToolTipText = "Compute Checksum for machine(s)."
        '
        'Separator6
        '
        Me.Separator6.Name = "Separator6"
        Me.Separator6.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
        '
        'btnDeActivate
        '
        Me.btnDeActivate.ImageIndex = 10
        Me.btnDeActivate.Name = "btnDeActivate"
        Me.btnDeActivate.ToolTipText = "DeActivate Machine  (only for Testing!!!)"
        '
        'Separator7
        '
        Me.Separator7.Name = "Separator7"
        Me.Separator7.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
        '
        'ReadyToPlay
        '
        Me.ReadyToPlay.ImageIndex = 11
        Me.ReadyToPlay.Name = "ReadyToPlay"
        Me.ReadyToPlay.ToolTipText = "Send ReadyToPlay (only for Testing!!!)"
        '
        'ImageList1
        '
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.Transparent
        Me.ImageList1.Images.SetKeyName(0, "")
        Me.ImageList1.Images.SetKeyName(1, "")
        Me.ImageList1.Images.SetKeyName(2, "")
        Me.ImageList1.Images.SetKeyName(3, "")
        Me.ImageList1.Images.SetKeyName(4, "")
        Me.ImageList1.Images.SetKeyName(5, "")
        Me.ImageList1.Images.SetKeyName(6, "")
        Me.ImageList1.Images.SetKeyName(7, "")
        Me.ImageList1.Images.SetKeyName(8, "")
        Me.ImageList1.Images.SetKeyName(9, "")
        Me.ImageList1.Images.SetKeyName(10, "")
        Me.ImageList1.Images.SetKeyName(11, "")
        '
        'lvwMachineList
        '
        Me.lvwMachineList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwMachineList.CausesValidation = False
        Me.lvwMachineList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colCasinoMachineNumber, Me.colIPAddress, Me.colMsgSentCount, Me.colMsgReceivedCount, Me.colStatus, Me.colTransType, Me.colGameCode, Me.colDgeMachineNumber, Me.colVoucherPrinting})
        Me.lvwMachineList.ContextMenu = Me.ContextMenu1
        Me.lvwMachineList.FullRowSelect = True
        Me.lvwMachineList.GridLines = True
        Me.lvwMachineList.HideSelection = False
        Me.lvwMachineList.Location = New System.Drawing.Point(6, 50)
        Me.lvwMachineList.Name = "lvwMachineList"
        Me.lvwMachineList.Size = New System.Drawing.Size(896, 402)
        Me.lvwMachineList.TabIndex = 1
        Me.lvwMachineList.UseCompatibleStateImageBehavior = False
        Me.lvwMachineList.View = System.Windows.Forms.View.Details
        '
        'colCasinoMachineNumber
        '
        Me.colCasinoMachineNumber.Text = "Casino Machine #"
        Me.colCasinoMachineNumber.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.colCasinoMachineNumber.Width = 104
        '
        'colIPAddress
        '
        Me.colIPAddress.Text = "IP Address"
        Me.colIPAddress.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.colIPAddress.Width = 96
        '
        'colMsgSentCount
        '
        Me.colMsgSentCount.Text = "Messages Sent"
        Me.colMsgSentCount.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.colMsgSentCount.Width = 90
        '
        'colMsgReceivedCount
        '
        Me.colMsgReceivedCount.Text = "Messages Received"
        Me.colMsgReceivedCount.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.colMsgReceivedCount.Width = 112
        '
        'colStatus
        '
        Me.colStatus.Text = "Status"
        Me.colStatus.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.colStatus.Width = 120
        '
        'colTransType
        '
        Me.colTransType.Text = "TransType"
        Me.colTransType.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.colTransType.Width = 120
        '
        'colGameCode
        '
        Me.colGameCode.Text = "Game Code"
        Me.colGameCode.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.colGameCode.Width = 72
        '
        'colDgeMachineNumber
        '
        Me.colDgeMachineNumber.Text = "DGE Identifier"
        Me.colDgeMachineNumber.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.colDgeMachineNumber.Width = 82
        '
        'colVoucherPrinting
        '
        Me.colVoucherPrinting.Text = "Voucher Printing"
        Me.colVoucherPrinting.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.colVoucherPrinting.Width = 94
        '
        'ContextMenu1
        '
        Me.ContextMenu1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuCMStartup, Me.mnuCMShutdown, Me.mnuCMRequestSetup, Me.mnuCMResumeMachine})
        '
        'mnuCMStartup
        '
        Me.mnuCMStartup.Index = 0
        Me.mnuCMStartup.Text = "Startup"
        '
        'mnuCMShutdown
        '
        Me.mnuCMShutdown.Index = 1
        Me.mnuCMShutdown.Text = "Shutdown"
        '
        'mnuCMRequestSetup
        '
        Me.mnuCMRequestSetup.Index = 2
        Me.mnuCMRequestSetup.Text = "Request Setup"
        '
        'mnuCMResumeMachine
        '
        Me.mnuCMResumeMachine.Index = 3
        Me.mnuCMResumeMachine.Text = "Resume Machine Halted for Ticket Printing"
        '
        'lblUserInfo
        '
        Me.lblUserInfo.CausesValidation = False
        Me.lblUserInfo.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.lblUserInfo.Location = New System.Drawing.Point(0, 453)
        Me.lblUserInfo.Name = "lblUserInfo"
        Me.lblUserInfo.Size = New System.Drawing.Size(908, 23)
        Me.lblUserInfo.TabIndex = 2
        Me.lblUserInfo.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lblGridHeader
        '
        Me.lblGridHeader.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblGridHeader.BackColor = System.Drawing.SystemColors.ActiveCaption
        Me.lblGridHeader.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
        Me.lblGridHeader.Location = New System.Drawing.Point(6, 32)
        Me.lblGridHeader.Name = "lblGridHeader"
        Me.lblGridHeader.Size = New System.Drawing.Size(896, 19)
        Me.lblGridHeader.TabIndex = 3
        Me.lblGridHeader.Text = "Machine Count: 0"
        Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'MachineManager
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(908, 476)
        Me.Controls.Add(Me.lblGridHeader)
        Me.Controls.Add(Me.lblUserInfo)
        Me.Controls.Add(Me.lvwMachineList)
        Me.Controls.Add(Me.tbarMain)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Menu = Me.MainMenu1
        Me.Name = "MachineManager"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Machine Manager - Disconnected"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

   ' Form Private Variables
   Private WithEvents mNetworkClient As New NetworkClient
   Private WithEvents mTimer As New Timer()

   Private mSort As SortOrder

   Private mPollInterval As Integer
   Private mSerial As Integer

   Private mSortColumn As Integer = 0
   Private mPrintEntryTicket As Integer = 0

   ' Constants
   Private mCommaChar As Char = ","c

   ' Delegates
   Private Delegate Sub SocketDataReceivedHandler(ByVal GridData As String)
   Private Delegate Sub StringArgSub(ByRef msg As String)

   ' Menu Events
   Private Sub mnuPollInterval_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuPollInterval.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Poll Interval menu Item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSettings As New AppSettings(1)

      With lSettings
         .MdiParent = Me.MdiParent
         .Show()
      End With

   End Sub

   Private Sub mnuCloseMachineManager_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuCloseMachineManager.Click

      ' Close Window
      Me.Close()

   End Sub

   Private Sub mnuServer_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuServer.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Server Location menu Item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSettings As New AppSettings(1)

      With lSettings
         .MdiParent = Me.MdiParent
         .Show()
      End With

   End Sub

   Private Sub mnuTracing_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuTracing.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Tracing menu Item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSettings As New AppSettings(1)

      With lSettings
         .MdiParent = Me.MdiParent
         .Show()
      End With

   End Sub
   '
   ' Toolbar Events
   '
   Private Sub tbarMain_ButtonClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ToolBarButtonClickEventArgs) Handles tbarMain.ButtonClick
      '--------------------------------------------------------------------------------
      ' ButtonClick event handler for the ToolBar control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDlgResult As DialogResult

      Dim lSocketConnected As Boolean

      Dim lMessage As String = ""
      Dim lIPAddress As String
      Dim lRoutineDelegate As StringArgSub = Nothing
      Dim lListCount As Integer = lvwMachineList.Items.Count

      ' Is the network client socket connected?
      If mNetworkClient IsNot Nothing Then
         lSocketConnected = mNetworkClient.SocketConnected
      Else
         lSocketConnected = False
      End If

      If lSocketConnected Then
         If e.Button Is tbarMain.Buttons(0) Then
            ' Reset Counters button was clicked.
            If lListCount > 0 Then
               lRoutineDelegate = New StringArgSub(AddressOf Me.ResetCounters)
               lMessage = "reset counters for"
            Else
               MessageBox.Show("No Machines for requested operation.", "Reset Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
               Exit Sub
            End If

         ElseIf e.Button Is tbarMain.Buttons(1) Then
            ' Update button was clicked.
            Me.GetAllMachines()
            Exit Sub

         ElseIf e.Button Is tbarMain.Buttons(3) Then
            ' Startup button was clicked.
            lRoutineDelegate = New StringArgSub(AddressOf Me.StartupMachine)
            lMessage = "startup"

         ElseIf e.Button Is tbarMain.Buttons(4) Then
            ' Shutdown button was clicked.
            lRoutineDelegate = New StringArgSub(AddressOf Me.ShutdownMachine)
            lMessage = "shutdown"

         ElseIf e.Button Is tbarMain.Buttons(6) Then
            ' Request Setup button was clicked.
            lRoutineDelegate = New StringArgSub(AddressOf Me.RequestSetup)
            lMessage = "request a setup for"

         ElseIf e.Button Is tbarMain.Buttons(8) Then
            ' SendMessage button was clicked.
            If lListCount > 0 Then
               lRoutineDelegate = New StringArgSub(AddressOf Me.ShowMessage)
               lMessage = "show this message on"
            Else
               MessageBox.Show("No Machines for requested operation.", "Send Message Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
               Exit Sub
            End If

         ElseIf e.Button Is tbarMain.Buttons(10) Then
            ' Reboot button was clicked.
            lRoutineDelegate = New StringArgSub(AddressOf Me.RebootMachine)
            lMessage = "REBOOT"

         ElseIf e.Button Is tbarMain.Buttons(12) Then
            ' ComputeChecksum button was clicked.
            lRoutineDelegate = New StringArgSub(AddressOf Me.ComputeChecksum)
            lMessage = "Compute Checksum for"

         ElseIf e.Button Is tbarMain.Buttons(14) Then
            ' DeActivate button was clicked. Note : Used by Dom for Testing only !!!
            lRoutineDelegate = New StringArgSub(AddressOf Me.DeActivateMachine)
            lMessage = "Deactivate Iowa Lottery Machine"

         ElseIf e.Button Is tbarMain.Buttons(16) Then
            ' ReadyToPlay button was clicked. Note : Used by Dom for Testing only !!!
            lRoutineDelegate = New StringArgSub(AddressOf Me.ReadyToPlayMachine)
            lMessage = "Send ReadToPlay for"
         End If

         ' Retrieve the ip address if necessary and set the lMessage that will be displayed
         ' in the MessageBox.
            If mSelectedMachines.Count = 0 Then
                lIPAddress = ""
                lMessage = "Are you sure you want to " & lMessage & " all machines?"
            Else
                ' replace the following line of code. to display the Casino Machine number 
                ' ip = moItem.SubItems(7).Text
                Dim machCounter As Integer = 0
                For Each machine As String In mSelectedMachines

                    
                    If (machCounter Mod 5 = 0) Then

                        lIPAddress += Environment.NewLine + machine

                    Else
                        lIPAddress += ", " + machine
                    End If
                    
                    machCounter += 1

                Next
                lMessage = "Are you sure you want to  " & lMessage & " the following machine(s)? " & lIPAddress
            End If

         ' Confirm request.
         lDlgResult = MessageBox.Show(lMessage, "Please Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2)

         Try
            ' Execute Function
            If lDlgResult = Windows.Forms.DialogResult.Yes Then lRoutineDelegate.Invoke(lIPAddress)

            ' Toggle startup and shutdown toolbar buttons...
            If lMessage.ToLower.IndexOf("startup") > -1 Then
               tbarMain.Buttons(3).Enabled = False
               tbarMain.Buttons(4).Enabled = True
            ElseIf lMessage.ToLower.IndexOf("shutdown") > -1 Then
               tbarMain.Buttons(3).Enabled = True
               tbarMain.Buttons(4).Enabled = False
            End If

            If lMessage = "startup" Then
               MessageBox.Show("Machine Started Successfully.")
            End If

         Catch ex As Exception
            ' Handle the exception.
            MessageBox.Show(ex.ToString, "Error Found", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End Try
      Else
         MessageBox.Show("TPC does not have a connection to the TP.", "Connection Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
      End If

   End Sub
#If DEBUG Then
   Private Sub MachineManager_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.DoubleClick

      Dim lData As String

      ' lData = "6,Z,2008-12-03 17:43:01,0,,0,GetAllMachines,1,00109,192.168.67.109,3,3,1,X,6B1,00109,0"
      lData = "1,Z,2008-12-04 07:46:10,0,,0,GetAllMachines,0"
      Call ProcessSocketData(lData)

   End Sub
#End If

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Close the connection to the TP.
      If mNetworkClient IsNot Nothing Then mNetworkClient.Disconnect()

   End Sub

   ' Form Events
   Private Sub Me_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSW As Stopwatch
      Dim lTS As TimeSpan
      Dim lErrorText As String = ""

      mnuPromoTicketToggle.Visible = (My.Settings.ApplicationType = 2 Or My.Settings.ApplicationType = 3)

      Try
         ' Retrieve Configuration settings...
         mPollInterval = My.Settings.PollingInterval

         ' Connect to the TP.
         mNetworkClient.Connect(gServer, gPort)

         lblUserInfo.Text = String.Format("Server {0}:{1}  Refresh Interval {2} seconds.", gServer, gPort, mPollInterval)

         ' Convert polling interval seconds to milliseconds.
         mPollInterval *= 1000

         With tbarMain
            .Buttons(8).Enabled = True
            .Buttons(9).Enabled = True
            .Buttons(10).Enabled = True
            '.Buttons(11).Enabled = True
            '.Buttons(12).Enabled = True

            .Buttons(8).Visible = True        ' Show Message
            .Buttons(9).Visible = True        ' Separator
            .Buttons(10).Visible = True       ' Reboot

            ' The following buttons should be disabled for now.
            ' They are only used by Dom for testing.
            .Buttons(11).Visible = False      ' Separator
            .Buttons(12).Visible = False      ' ComputeChecksum
            .Buttons(13).Visible = False      ' Separator
            .Buttons(14).Visible = False      ' DeActivate
            .Buttons(15).Visible = False      ' Separator
            .Buttons(16).Visible = False      ' ReadyToPlay
         End With

         ' Disable "Resume Machine Halted For Ticket Printing" context menu.
         mnuCMResumeMachine.Enabled = False

         ' Set the Menu text of "Options -> Turn Promo Ticket OnOff"
         Call DbTpcGetPrintPromo()

         Select Case mPrintEntryTicket
            Case -1
               ' retrieval failed, disable the menu item.
               mnuPromoTicketToggle.Enabled = False

            Case 0
               mnuPromoTicketToggle.Text = "Turn Promo Ticket ON"

            Case 1
               mnuPromoTicketToggle.Text = "Turn Promo Ticket OFF"

         End Select

         ' Show an hourglass cursor.
         MdiParent.Cursor = Cursors.WaitCursor

         ' Start a new stopwatch instance...
         lSW = New Stopwatch
         lSW.Reset()
         lSW.Start()

         ' Do/Loop until connected or timeout...
         Do
            Application.DoEvents()
            If mNetworkClient.SocketConnected Then Exit Do

            lTS = lSW.Elapsed
            If lTS.Seconds > 4 Then Exit Do
         Loop
         lSW.Stop()

         ' Revert to default cursor.
         MdiParent.Cursor = Cursors.Default

         ' If connection failed, inform the user.
         If mNetworkClient.SocketConnected Then
            ' Connection established to TP, so show in window caption.
            Me.Text = "Machine Manager - Connected"

            Call GetAllMachines()
            Call StartTimer()
         Else
            ' No connection, inform the user.
            lErrorText = String.Format("Could not connect to the Transportal Service ({0}:{1}).", gServer, gPort)
            MessageBox.Show(lErrorText, "Connection Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
         End If

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::Me_Load error: " & ex.Message
         MessageBox.Show(lErrorText, "Machine Manager Load Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)

      End Try

   End Sub

   Private Sub Me_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Window is closing, so stop the timer.
      If mTimer IsNot Nothing Then mTimer.Stop()

   End Sub

   ' Network Client Events
   Private Sub mNetworkClient_Connected() Handles mNetworkClient.Connected

      mNetworkClient.Receive()
      
   End Sub

   Private Sub mNetworkClient_Disconnected() Handles mNetworkClient.Disconnected

      Me.Text = "Machine Manager - Disconnected"
      Call StopTimer()

   End Sub

   Private Sub mNetworkClient_NetClientError(ByVal ErrorText As String) Handles mNetworkClient.NetClientError
      '--------------------------------------------------------------------------------
      ' NetClientError event handler for the Network Client object.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String

      lErrorText = "NetworkClient error: " & ErrorText
      FormatLogOutput(ErrorText)

      ' ShowTimedMessage(lErrorText, "Network Client Error", mPollInterval - 500)
      ' MessageBox.Show(lErrorText, "Network Client Error", MessageBoxButtons.OK, MessageBoxIcon.Error)

   End Sub

   Private Sub mNetworkClient_DataReceived(ByVal aData As String) Handles mNetworkClient.DataReceived
      '--------------------------------------------------------------------------------
      ' DataReceived event handler for mNetworkClient.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Me.Invoke(New SocketDataReceivedHandler(AddressOf ProcessSocketData), aData)

   End Sub

   Private Sub PopulateMachineList(ByVal aFields() As String)
      '--------------------------------------------------------------------------------
      ' Routine to update the ListView control with machine data.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lItem As ListViewItem

      Dim lDT As DataTable
      Dim lDR As DataRow
      Dim lDRows() As DataRow

      Dim lCasinoMachNo As String
      Dim lErrorText As String = ""
      Dim lFilter As String
      Dim lMachineNbr As String
      Dim lMachineList As String = ""
      Dim lMachineStatus As String
      Dim lTopMostText As String = ""
      Dim lVoucherPrinting As String
      Dim lVPText As String

      Dim lElementCount As Integer
      Dim lMachineCount As Integer
      Dim lMachineIndex As Integer
      Dim lOpCode As Integer

      Dim lActiveFlag As Short

      ' If there are items in the ListView control, store topmost item text, then clear the control...
      If lvwMachineList.Items.Count > 0 Then
         lTopMostText = lvwMachineList.TopItem.Text
         lvwMachineList.Items.Clear()
      End If

      ' Store the element count...
      If aFields Is Nothing Then
         lElementCount = 0
      Else
         lElementCount = aFields.Length
      End If

      ' Store the number of machines sent from the TP.
      lMachineCount = CType(aFields(7), Integer)

      ' If no machines, bail out here.
      If lMachineCount < 1 Then
         ' Show the zero as the machine count and exit...
         lblGridHeader.Text = "Machine Count: 0"
         Exit Sub
      End If

      ' Check for the correct number of field elements in the data...
      If (lElementCount - 8) Mod 9 <> 0 Then
         ' Build error text.
         lErrorText = Me.Name & "::PopulateListView error: Invalid number of data fields.  " & String.Format("Expected {0} Received {1}.", 8 + (lMachineCount * 9), lElementCount)

         ' Log it.
         FormatLogOutput(lErrorText)

         ' Show it.
         ShowTimedMessage(lErrorText, "Data Received Status", mPollInterval - 500)

         ' Bail.
         Exit Sub
      End If

      ' Create an array to contain machine data.  Size it for 9 fields per machine.
      Dim lMachineData(9 * lMachineCount) As String

      Try
         lOpCode = 0 ' ArrayCopy
         Array.Copy(aFields, 8, lMachineData, 0, 9 * lMachineCount)

         Dim j As Integer = 0
         If lMachineCount > 0 Then
            lOpCode = 1   ' Populating the ListView Control.

            Dim lListViewItemArray(lMachineCount - 1) As ListViewItem

            For lMachineIndex = 0 To (lMachineCount - 1)
               lOpCode = 2
               ' The lItem represents the CasinoMachNo (1st column)
               lCasinoMachNo = lMachineData(lMachineIndex * 9)
               lItem = New ListViewItem(lMachineData(lMachineIndex * 9))

               ' Write out the values of CasinoMachNo, IPAddress, MessagesSent .. etc to the Log file.
               'Dim lLogFileSB As New StringBuilder
               'For k As Integer = 0 To 8
               '   lLogFileSB.Append(lMachineData(lMachineIndex * 9 + k))
               '   If k <> 8 Then lLogFileSB.Append(", ")
               'Next
               ' FormatLogOutput("'GetAllMachines' loop machine data = " & lLogFileSB.ToString)

               lOpCode = 3

               ' Add the sub-items of the CasinoMachNo
               lItem.SubItems.Add(lMachineData(lMachineIndex * 9 + 1))     ' IP Address           SubItem(1)
               lItem.SubItems.Add(lMachineData(lMachineIndex * 9 + 2))     ' Messages Sent        SubItem(2)
               lItem.SubItems.Add(lMachineData(lMachineIndex * 9 + 3))     ' Messages Received    SubItem(3)

               ' Store machine status.
               lOpCode = 4
               lMachineStatus = lMachineData(lMachineIndex * 9 + 4)

               ' Store voucher printing flag.
               lOpCode = 5
               lVoucherPrinting = lMachineData(lMachineIndex * 9 + 8)

               ' Update the grid Status column.
               lOpCode = 6
               If Not String.IsNullOrEmpty(lVoucherPrinting) AndAlso lVoucherPrinting = "1" Then ' VoucherPrinting flag
                  lItem.SubItems.Add("Halted for Ticket Printing")
                  lItem.ForeColor = System.Drawing.Color.Blue
               ElseIf lMachineStatus = "1" Then ' Status
                  lItem.SubItems.Add("Online")
               ElseIf lMachineStatus = "0" Then
                  lItem.SubItems.Add("Offline")
                  lItem.ForeColor = System.Drawing.Color.Red
               Else
                  lItem.SubItems.Add("Unknown")
               End If

               lOpCode = 7

               lItem.SubItems.Add(lMachineData(lMachineIndex * 9 + 5))     ' TransType            SubItem(5)
               lItem.SubItems.Add(lMachineData(lMachineIndex * 9 + 6))     ' GameCode             SubItem(6)

               ' MachineNumber
               lMachineNbr = lMachineData(lMachineIndex * 9 + 7)
               lItem.SubItems.Add(lMachineNbr)
               'lItem.SubItems.Add(lMachineData(lMachineIndex * 9 + 7))     ' MachineNumber       SubItem(7)
               lMachineList &= String.Format("'{0}',", lMachineNbr)

               lOpCode = 8
               If lMachineData(lMachineIndex * 9 + 8) = "0" Then            ' VoucherPrintingFlag SubItem(8)
                  lVPText = "No"
               Else
                  lVPText = "Yes"
               End If
               lItem.SubItems.Add(lVPText)


               lOpCode = 9
               lListViewItemArray(lMachineIndex) = lItem

               'Debug.WriteLine(lItem.SubItems(8))
            Next

            lOpCode = 10
            lvwMachineList.BeginUpdate()
            lOpCode = 11
            lvwMachineList.Items.AddRange(lListViewItemArray)
            lOpCode = 12
            lvwMachineList.EndUpdate()

            lOpCode = 13
            ' Get Status from MACH_SETUP table.
            lDT = GetMachineStatus(lMachineList)

            ' Did the retrieval succeed?
            If lDT IsNot Nothing Then
               ' Yes, are there data rows?
               If lDT.Rows.Count > 0 Then
                  ' Yes, so walk the ListView Items and update where necessary...
                  For Each lItem In lvwMachineList.Items
                     ' Select the row in lDT matching the Casino Machine Nbr in the ListView.
                     lDRows = lDT.Select(String.Format("CASINO_MACH_NO = '{0}'", lItem.Text))

                     ' Did we find exactly 1 row?
                     If lDRows.Length = 1 Then
                        ' Yes, so store the ActiveFlag value.
                        lActiveFlag = CType(lDRows(0).Item("ACTIVE_FLAG"), Short)

                        ' Compare to the ListView and update if necessary...
                        If lItem.SubItems(4).Text = "Online" And lActiveFlag = 0 Then
                           lItem.SubItems(4).Text = "Offline"
                           lItem.SubItems(4).ForeColor = System.Drawing.Color.Red
                        ElseIf lItem.SubItems(4).Text = "Offline" And lActiveFlag = 1 Then
                           lItem.SubItems(4).Text = "Online"
                           lItem.SubItems(4).ForeColor = System.Drawing.Color.Black
                        End If
                     End If
                  Next
               End If
            End If

            lOpCode = 14
            ' Try to reposition the grid to where it was before being refreshed.
            If Not String.IsNullOrEmpty(lTopMostText) Then
               For Each lItem In lvwMachineList.Items
                  If lItem.Text = lTopMostText Then
                     lvwMachineList.TopItem = lItem
                     Exit For
                  End If
               Next
            End If

            lOpCode = 15   ' Reselecting
            ' Attempt to select what was previously selected...
                If mSelectedMachines.Count > 0 Then
                    For Each lItem In lvwMachineList.Items
                        For Each machine As String In mSelectedMachines
                            If machine = lItem.Text Then
                                lItem.Selected = True
                                j = 1
                                Exit For
                            End If
                        Next
                        
                    Next
                End If
                'If j = 0 Then mListViewItem = Nothing

         Else
            ' No machines, so no selected item.
                mSelectedMachines.Clear()
         End If

         ' Show the number of listed machines.
         lblGridHeader.Text = String.Format("Machine Count: {0}", lvwMachineList.Items.Count)

         'Catch ex As Exception When lOpCode = 0
         '   lErrorText = Me.Name & "::ProcessSocketData GetAllMachines ArrayCopy error: " & _
         '                ex.Message & gCrLf & gCrLf & "Data: " & aData

         'Catch ex As Exception When lOpCode = 1
         '   lErrorText = Me.Name & "::ProcessSocketData GetAllMachines Grid population error: " & _
         '                ex.Message & gCrLf & gCrLf & "Data: " & aData

         'Catch ex As Exception When lOpCode = 2
         '   lErrorText = Me.Name & "::ProcessSocketData GetAllMachines Repositioning error: " & ex.Message

         'Catch ex As Exception When lOpCode = 3
         '   lErrorText = Me.Name & "::ProcessSocketData GetAllMachines Reselecting error: " & ex.Message

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::PopulateListView GetAllMachines error OpCode = " & lOpCode.ToString & _
                      ";MachineIndex = " & lMachineIndex.ToString & _
                      gCrLf & gCrLf & "Error: " & ex.Message & gCrLf & gCrLf & "Data: " & String.Join("+", aFields)

         FormatLogOutput(lErrorText)

         ' MessageBox.Show(lErrorText, "Data Received Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         ShowTimedMessage(lErrorText, "Data Received Status", mPollInterval - 500)

      End Try

   End Sub

   Private Sub ProcessSocketData(ByVal aData As String)
      '--------------------------------------------------------------------------------
      ' Routine to update the ListView control with machine data.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFields() As String = Nothing

      Dim lErrorCode As Integer
      Dim lMessageSequence As Integer
      Dim lShutdownFlag As Integer

      Dim lErrorDescription As String
      Dim lErrorText As String = ""
      Dim lTransType As String = ""


      Try
         ' Split data on commas into fields.
         lFields = aData.Split(mCommaChar)

         If lFields.GetUpperBound(0) > 4 Then
            If Regex.IsMatch(lFields(0), "^\d+$") Then
               lMessageSequence = CType(lFields(0), Integer)
               If Regex.IsMatch(lFields(1), "^\w+$") Then
                  lTransType = lFields(1)
                  If Regex.IsMatch(lFields(2), "^\d{4}[-]\d\d-\d\d \d\d:\d\d:\d\d$") Then
                     If Regex.IsMatch(lFields(3), "^\d+$") Then
                        lErrorCode = CType(lFields(3), Integer)

                        If lErrorCode <> 0 Then
                           lErrorDescription = lFields(4)
                           lShutdownFlag = CType(lFields(5), Integer)
                        End If

                     Else
                        ' ErrorCode is not in the proper format.

                     End If
                  Else
                     ' TimeStamp is not in the proper format.

                  End If
               Else
                  ' TransType is not in the proper format.

               End If
            Else
               ' Message Sequence is not in the proper format.
            End If
         End If

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::ProcessSocketData Parsing Message error: " & ex.Message
         Call ShowTimedMessage(lErrorText, "ProcessSocketData Status", mPollInterval - 500)
         Exit Sub

      End Try

      If lErrorCode = 0 And lTransType = "Z" Then
         Select Case lFields(6)
            Case "ComputeChecksum"
               'Nothing Required

            Case "DeActivateMachine"
               'Nothing Required. Note : Used by Dom for Testing only !!!

            Case "EntryTicketOff"
               'Nothing Required.

            Case "EntryTicketOn"
               'Nothing Required.

            Case "GetAllMachines"
               ' Call routine to populate the ListView control.
               Call PopulateMachineList(lFields)

            Case "ReadyToPlayMachine"
               'Nothing Required. Note : Used by Dom for Testing only !!!

            Case "RebootMachine"
               'Nothing Required

            Case "RequestSetup"
               'Nothing Required

            Case "ResetCounters"
               'Nothing Required

            Case "RestartTPService"
               ' Request to restart the TP.
               Call RestartTransactionPortal()

            Case "ResumeMachineHaltedForTicketPrinting"
               'Nothing Required.

            Case "ShutdownMachine"
               'Nothing Required

            Case "StartupMachine"
               'Nothing Required

            Case "ShowMessage"
               'Nothing Required

            Case Else
               Call ShowTimedMessage("Invalid Message Received", "ProcessSocketData Status", mPollInterval - 500)
               ' MessageBox.Show("Invalid Message Received", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
               MessageBox.Show(aData)
         End Select

         If lErrorText.Length > 0 Then
            FormatLogOutput(lErrorText)
            Call ShowTimedMessage(lErrorText, "ProcessSocketData Error", mPollInterval - 500)
            ' MessageBox.Show(lErrorText, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End If
      Else
         Call ShowTimedMessage("Invalid Message Received", "ProcessSocketData Error", mPollInterval - 500)
         ' MessageBox.Show("Invalid Message Received", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
         FormatLogOutput("Invalid Message Received = " & aData)
      End If

   End Sub

   ' Functions

   Private Function BuildHeader() As String
      '--------------------------------------------------------------------------------
      ' BuildHeader function
      ' Returns a string header for prefixing messages sent to the TP.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder

      mSerial += 1

      With lSB
         .Append(mSerial.ToString).Append(mCommaChar)
         .Append("Z").Append(mCommaChar)
         .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
      End With

      ' Set the function return value.
      Return lSB.ToString

   End Function

   Private Function GetMachineStatus(ByVal aMachineList As String) As DataTable
      '--------------------------------------------------------------------------------
      ' Function to return a DataTable
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lReturn As DataTable = Nothing

      Dim lErrorText As String
      Dim lSQL As String


      ' Remove trailing comma from machine list.
      If aMachineList.EndsWith(",") Then
         aMachineList = aMachineList.TrimEnd(",".ToCharArray)
      End If

      ' Build the SQL SELECT statement.
      lSQL = String.Format("SELECT CASINO_MACH_NO, ACTIVE_FLAG FROM MACH_SETUP WHERE MACH_NO IN ({0})", aMachineList)

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectionString, False, 90)

         ' Execute the SQL SELECT statement.
         lReturn = lSDA.CreateDataTable(lSQL, "TableName")

      Catch ex As Exception
         ' Handle the exception...
         ' Build the error text.
         lErrorText = Me.Name & "::GetMachineStatus error: " & ex.Message
         ' Log, and then show the error...
         FormatLogOutput(lErrorText)
         MessageBox.Show(lErrorText, "Retrieval Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function LogScheduleItemChange(ByRef sPromoChangeReason As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Function to add a row to the APP_EVENT_LOG table.
      ' Returns T/F to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing

      Dim lReturn As Boolean = True
      Dim lErrorText As String = ""

      Dim lAppEventLogDescrString As String

      lAppEventLogDescrString = sPromoChangeReason

      Try
         ' Create a new SQL Data Access instance.
         lSDA = New SqlDataAccess(gConnectionString, False, 30)
         With lSDA
            .AddParameter("@AccountID", SqlDbType.VarChar, "Admin", 10)
            .AddParameter("@WorkStation", SqlDbType.VarChar, "Unknown", 16)
                .AddParameter("@EventSource", SqlDbType.VarChar, "TransPortalControl", 32)
            .AddParameter("@LoginEventID", SqlDbType.Int, 13 + mPrintEntryTicket)
            .AddParameter("@Description", SqlDbType.VarChar, lAppEventLogDescrString, 128)

            lReturn = CBool(.ExecuteProcedureNoResult("[dbo].[InsertAppEventLog]"))

         End With

      Catch ex As Exception
         ' Handle the Exception...
         lReturn = False
         lErrorText = Me.Name & "::LogScheduleItemChange error: " & ex.Message
         MessageBox.Show(lErrorText, "Logging Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         lSDA.Dispose()
         lSDA = Nothing

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   ' Procedures

   Private Sub GetAllMachines()
      '--------------------------------------------------------------------------------
      ' GetAllMachines routine
      ' Sends GetAllMachines message to the TP
      ' TP should respond with machine information which will be displayed in the
      ' ListView grid control.
      '--------------------------------------------------------------------------------

      Try
         If mNetworkClient.SocketConnected Then
            mNetworkClient.Send(BuildHeader() & ",GetAllMachines" & gCrLf)
         End If

      Catch ex As Exception

      End Try

   End Sub

   Private Sub RequestSetup(Optional ByRef IPAddress As String = "")
      '--------------------------------------------------------------------------------
      ' RequestSetup routine
      ' Sends RequestSetup message to the TP for 1 or all machines.
      '--------------------------------------------------------------------------------

      If IPAddress.Length > 0 Then
         mNetworkClient.Send(BuildHeader() & ",RequestSetup," & IPAddress & gCrLf)
      Else
         mNetworkClient.Send(BuildHeader() & ",RequestSetup" & gCrLf)
      End If

      Me.StopTimer()
      Me.GetAllMachines()
      Me.StartTimer()

   End Sub

   Private Sub ResetCounters(Optional ByRef IPAddress As String = "")
      '--------------------------------------------------------------------------------
      ' ResetCounters routine
      ' Sends ResetCounters message to the TP for 1 or all machines.
      '--------------------------------------------------------------------------------

      If IPAddress.Length > 0 Then
         mNetworkClient.Send(BuildHeader() & ",ResetCounters," & IPAddress & gCrLf)
      Else
         mNetworkClient.Send(BuildHeader() & ",ResetCounters" & gCrLf)
      End If

      Call StopTimer()
      Call GetAllMachines()
      Call StartTimer()

   End Sub

   Private Sub RestartTransactionPortal()
      '--------------------------------------------------------------------------------
      ' Routine to restart the Transaction Portal Service.
      ' This routine is called from the ProcessSocketData routine.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSC As ServiceController

      Dim lTimeOut As New TimeSpan(0, 0, 60)

      Dim lStopped As Boolean = False
      Dim lStarted As Boolean = False

      Dim lErrorText As String
      Dim lServiceName As String = ""
      Dim lServerName As String = ""

      Try
         ' Stop polling timer.
         Call StopTimer()

         ' Retrieve the Transaction Portal Service Name.
         lServiceName = My.Settings.TPServiceName
         lServerName = My.Settings.TPServerName

         ' Create a new ServiceController...
         lSC = New ServiceController(lServiceName, lServerName)
         ' Call the Refresh method to get the current service values.
         lSC.Refresh()

         ' Is the service running?
         If lSC.Status = ServiceControllerStatus.Running Then
            ' Yes, can the service be stopped?
            If lSC.CanStop Then
               ' Yes, so stop it.
               lSC.Stop()

               ' Wait for up to 60 seconds for the service tp stop.
               lSC.WaitForStatus(ServiceControllerStatus.Stopped, lTimeOut)

               ' If the service is stopped Reset the Stopped flag.
               If lSC.Status = ServiceControllerStatus.Stopped Then lStopped = True
            Else
               ' The CanStop flag indicates that the service cannot be stopped.
               lErrorText = "Transaction Portal CanStop flag was False."
            End If
         End If

         ' Is the service stopped?
         If lSC.Status = ServiceControllerStatus.Stopped Then
            ' Yes, so restart the service.
            lSC.Start()

            ' Wait for up to 60 seconds for the service to start again.
            lSC.WaitForStatus(ServiceControllerStatus.Running, lTimeOut)

            ' Is the service running now?
            If lSC.Status = ServiceControllerStatus.Running Then
               ' Reset the Started flag
               lStarted = True
            Else
               ' No, so set the error text.
               lErrorText = "The Transaction Portal Service failed to Restart withing 60 seconds."
            End If
         End If

         If lStopped = True AndAlso lStarted = True Then
            ' Reconnect to the service.
            If Not mNetworkClient.SocketConnected Then
               ' Connect to the TP.
               mNetworkClient.Connect(gServer, gPort)

               Call StartTimer()
            End If

            FormatLogOutput("Successfully restarted the Transaction Portal service.")
         End If


      Catch ex As Exception
         ' Handle the error...
         lErrorText = Me.Name & String.Format("::RestartTransactionPortal ({0}) error: ", lServiceName) & ex.Message
         FormatLogOutput(lErrorText)

      End Try

   End Sub

   Private Sub StartupMachine(Optional ByRef IPAddress As String = "")
      '--------------------------------------------------------------------------------
      ' StartupMachine routine
      ' Sends StartupMachine message to the TP for 1 or all machines.
      '--------------------------------------------------------------------------------

      ExectueCommand("StartupMachine")


      Call StopTimer()
      Call GetAllMachines()
      Call StartTimer()

   End Sub

   Private Sub ShutdownMachine(Optional ByRef IPAddress As String = "")
      '--------------------------------------------------------------------------------
      ' ShutdownMachine routine
      ' Sends ShutdownMachine message to the TP for 1 or all machines.
      '--------------------------------------------------------------------------------

        ExectueCommand("ShutdownMachine")

   End Sub

   Private Sub ShowMessage(Optional ByRef IPAddress As String = "")
      '--------------------------------------------------------------------------------
      ' Note: Special processing - This message will have 6 fields to start with.
      '       The IP will be appended as 7th field where necessary. This will be
      '       handled by TransactionPortalControl.vb\ProcessRxBuffer
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSendMessageDialog As New SendMessageText
      Dim lMessage As String = ""

      ' Show a modal dialog and determine if DialogResult = OK.
      If lSendMessageDialog.ShowDialog(Me.MdiParent) = DialogResult.OK Then
         ' Read the contents of the ShowMessageText dialog text box
         lMessage = lSendMessageDialog.txtBox.Text
         If lMessage.Length > 0 Then
            ' Note: in "Z" trans. below add the Message# and MessageText following "ShowMessage"

                If (mSelectedMachines.Count = 0) Then

                    For Each machineItem As ListViewItem In lvwMachineList.Items

                        mSelectedMachines.Add(machineItem.SubItems(1).Text)

                    Next
                End If


                For Each machine As String In mSelectedMachines
                    ' Get the IP of the ListView1 item that was right-clicked.
                    IPAddress = machine

                    If IPAddress.Length > 0 Then
                        mNetworkClient.Send(BuildHeader() & ",ShowMessage," & "801," & lMessage & "," & IPAddress & gCrLf)
                    Else
                        mNetworkClient.Send(BuildHeader() & ",ShowMessage," & "801," & lMessage & gCrLf)
                    End If

                    FormatLogOutput("'" + Command() + "' issued with message " + Environment.NewLine + lMessage + Environment.NewLine + " for IP = " & lMessage)

                    Call StopTimer()
                    Call GetAllMachines()
                    Call StartTimer()
                Next
                mSelectedMachines.Clear()

                If IPAddress.Length > 0 Then
                    mNetworkClient.Send(BuildHeader() & ",ShowMessage," & "801," & lMessage & "," & IPAddress & gCrLf)
                Else
                    mNetworkClient.Send(BuildHeader() & ",ShowMessage," & "801," & lMessage & gCrLf)
                End If
         Else
            MessageBox.Show("Message text is required.", "Send Message Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
         End If
      End If

      lSendMessageDialog.Dispose()

      Call StopTimer()
      Call GetAllMachines()
      Call StartTimer()

   End Sub

   Private Sub RebootMachine(Optional ByRef IPAddress As String = "")
      '--------------------------------------------------------------------------------
      ' RebootMachine routine
      ' Sends RebootMachine message to the TP for 1 or all machines.
      '--------------------------------------------------------------------------------

        ExectueCommand("RebootMachine")

     

   End Sub

   Private Sub ComputeChecksum(Optional ByRef IP As String = "")
      '--------------------------------------------------------------------------------
      ' ComputeChecksum routine
      ' Sends ComputeChecksum message to the TP for 1 or all machines.
      '--------------------------------------------------------------------------------

      If IP.Length > 0 Then
         mNetworkClient.Send(BuildHeader() & ",ComputeChecksum," & IP & gCrLf)
      Else
         mNetworkClient.Send(BuildHeader() & ",ComputeChecksum" & gCrLf)
      End If

      Call StopTimer()
      Call GetAllMachines()
      Call StartTimer()

   End Sub

   Private Sub DeActivateMachine(Optional ByRef IP As String = "")
      '--------------------------------------------------------------------------------
      ' DeActivateMachine routine
      ' Sends DeActivateMachine message to the TP for 1 or all machines.
      '
      ' Note: Used by Dom for Testing only !!!
      '--------------------------------------------------------------------------------
        RebootMachine("DeActivateMachine")


   End Sub

   Private Sub ReadyToPlayMachine(Optional ByRef IP As String = "")
      '--------------------------------------------------------------------------------
      ' ReadyToPlayMachine routine
      ' Sends ReadyToPlayMachine message to the TP for 1 or all machines.
      '
      ' Note: Used by Dom for Testing only!!!
      '--------------------------------------------------------------------------------

        DeActivateMachine("ReadyToPlayMachine")

   End Sub

   Private Sub StartTimer()

      With mTimer
         .Interval = mPollInterval
         .AutoReset = True
         .Start()
      End With

   End Sub

   Private Sub StopTimer()

      mTimer.Stop()

   End Sub

   ' Timer Events
   Private Sub mTimer_Elapsed(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs) Handles mTimer.Elapsed
      '--------------------------------------------------------------------------------
      ' Elapsed event handler for the timer.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lConnected As Boolean

      ' Timer has fired, if connected to the TP call GetAllMachines...
      ' Assume we are not connected.
      lConnected = False

      If mNetworkClient IsNot Nothing Then
         If mNetworkClient.SocketConnected = True Then
            ' Reset the connected flag.
            lConnected = True

            ' Send the actual network request.
            Call GetAllMachines()
         End If
      End If

      ' If we were connected before and are no longer connected, log connection loss and close this window...
      If lConnected = False And Me.Text.Contains(" Connected") Then
         FormatLogOutput("TP connection lost, Machine Manager window closing.")
         Me.Close()
      End If

   End Sub

    Private ReadOnly mSelectedMachines As New List(Of String)


    Private Sub lvwMachineList_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwMachineList.SelectedIndexChanged
        mSelectedMachines.Clear()

        '--------------------------------------------------------------------------------
        ' If the ListView has a selected item, track it.
        '--------------------------------------------------------------------------------

        If lvwMachineList.SelectedItems.Count > 0 Then
            For Each item As ListViewItem In lvwMachineList.SelectedItems
                mSelectedMachines.Add(item.SubItems(1).Text)
            Next


            tbarMain.Buttons(3).Enabled = True
            tbarMain.Buttons(4).Enabled = True

        Else
            mSelectedMachines.Clear()            
            tbarMain.Buttons(3).Enabled = True
            tbarMain.Buttons(4).Enabled = True
        End If

    End Sub

   Private Sub lvwMachineList_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwMachineList.ColumnClick
      '--------------------------------------------------------------------------------
      ' ColumnClick event handler for the Machine list ListView control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If mSortColumn = e.Column And mSort = SortOrder.Ascending Then
         mSort = SortOrder.Descending
      Else
         mSort = SortOrder.Ascending
      End If

      mSortColumn = e.Column
      lvwMachineList.ListViewItemSorter = New ListViewStringSort(e.Column, mSort)

   End Sub

   'Private Sub lvwMachineList_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwMachineList.Click
   '   '--------------------------------------------------------------------------------
   '   ' Click event handler for the Machine list ListView control.
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim lSelectedIndexes As ListView.SelectedIndexCollection


   '   lSelectedIndexes = lvwMachineList.SelectedIndices
   '   If lSelectedIndexes.Count > 0 Then
   '      If lvwMachineList.Items(lSelectedIndexes(0)).SubItems(4).Text = "Offline" Then
   '         tbarMain.Buttons(3).Enabled = True
   '         tbarMain.Buttons(4).Enabled = False
   '         ' Disable the "Shutdown" context menu.
   '         mnuCMShutdown.Enabled = False
   '      Else
   '         tbarMain.Buttons(3).Enabled = False
   '         tbarMain.Buttons(4).Enabled = True
   '         ' Enable the "Shutdown" context menu.
   '         mnuCMShutdown.Enabled = True
   '      End If
   '   End If

   '   lSelectedIndexes = Nothing

   'End Sub

   Private Sub mnuCMStartup_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuCMStartup.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the 'Startup' menu item in ContextMenu1.
      ' Starts up just the selected machine.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String
      Dim lIPAddress As String

        Try
            If (mSelectedMachines.Count = 0) Then

                For Each machineItem As ListViewItem In lvwMachineList.Items

                    mSelectedMachines.Add(machineItem.SubItems(1).Text)

                Next
            End If


            For Each machine As String In mSelectedMachines
                ' Get the IP of the ListView1 item that was right-clicked.
                lIPAddress = machine

                mNetworkClient.Send(BuildHeader() & ",StartupMachine," & lIPAddress & gCrLf)
                FormatLogOutput("'StartupMachine' issued for IP = " & lIPAddress)

                Call StopTimer()
                Call GetAllMachines()
                Call StartTimer()
            Next
            mSelectedMachines.Clear()

        Catch ex As Exception
            ' Handle the exception...
            lErrorText = Me.Name & "::mnuCMStartup_Click error: " & ex.Message
            MessageBox.Show(lErrorText, "Startup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

   End Sub

    Private Sub ExectueCommand(ByVal command As String)
        ' Allocate local vars...
        Dim lErrorText As String
        Dim lIPAddress As String

        Try
            If (mSelectedMachines.Count = 0) Then

                For Each machineItem As ListViewItem In lvwMachineList.Items

                    mSelectedMachines.Add(machineItem.SubItems(1).Text)

                Next
            End If


            For Each machine As String In mSelectedMachines
                ' Get the IP of the ListView1 item that was right-clicked.
                lIPAddress = machine

                mNetworkClient.Send(BuildHeader() & "," + command + "," & lIPAddress & gCrLf)
                FormatLogOutput("'" + command + "' issued for IP = " & lIPAddress)

                Call StopTimer()
                Call GetAllMachines()
                Call StartTimer()
            Next
            mSelectedMachines.Clear()

        Catch ex As Exception
            ' Handle the exception...
            lErrorText = Me.Name & "::ExectueCommand error: " & ex.Message
            MessageBox.Show(lErrorText, command, MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try


    End Sub
    Private Sub mnuCMShutdown_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuCMShutdown.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the 'Shutdown' menu item in ContextMenu1.
        ' Shuts down just the selected machine.
        '--------------------------------------------------------------------------------

        ExectueCommand("ShutdownMachine")


    End Sub

   Private Sub mnuCMRequestSetup_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuCMRequestSetup.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for 'Request Setup' menu item in ContextMenu1.
      ' Sends an 'R' transaction for just the selected machine.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
     ExectueCommand("RequestSetup")

   End Sub

   Private Sub mnuCMResumeMachine_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuCMResumeMachine.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for 'Resume Machine Halted For Ticket Printing' menu item
      ' in 'ContextMenu1'. Sends a 'ResumeMachineHaltedForTicketPrinting' transaction
      ' for just the selected machine.
      '--------------------------------------------------------------------------------
        ' Allocate local vars...

        ExectueCommand("ResumeMachineHaltedForTicketPrinting")

   End Sub

   Private Sub mnuPromoTicketToggle_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuPromoTicketToggle.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for mnuPromoTicketToggle (Options - Turn Promo Ticket On/Off)
      ' Note :   This flips the module var. miPrintEntryTicket, and also the menu text. Then it sends a "Z" trans.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String
      Dim lOnOff As String
      Dim lUserMsg As String

      Try
         If mNetworkClient.SocketConnected Then

            ' Build user confirmation text...
            If mPrintEntryTicket = 1 Then
               lOnOff = "Off"
            Else
               lOnOff = "On"
            End If
            lUserMsg = String.Format("Are you sure that you want to turn Promo Ticket Printing {0}?", lOnOff)

            ' Have user confirm...
            If MessageBox.Show(lUserMsg, "Please Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = Windows.Forms.DialogResult.Yes Then
               If mPrintEntryTicket = 1 Then
                  ' Entry ticket flag is now on, set it to off.
                  mPrintEntryTicket = 0

                  ' Send the "Z" trans. with "EntryTicketOff"
                  mNetworkClient.Send(BuildHeader() & ",EntryTicketOff" & gCrLf)

                  ' Reset menu text so choice is not to turn it on.
                  mnuPromoTicketToggle.Text = "Turn Promo Ticket On"

               ElseIf mPrintEntryTicket = 0 Then
                  ' Entry ticket flag is now off, set it to on.
                  mPrintEntryTicket = 1

                  ' Send the "Z" trans. with "EntryTicketOn"
                  mNetworkClient.Send(BuildHeader() & ",EntryTicketOn" & gCrLf)

                  ' Reset menu text so choice is not to turn it off.
                  mnuPromoTicketToggle.Text = "Turn Promo Ticket Off"
               End If

               ' Update the CASINO.PRINT_PROMO_TICKETS to reflect the current value of the print promo tickets flag.
               Call DbTpcSetPrintPromo()
               LogScheduleItemChange("Promo Entry Tickets Turned " + lOnOff)


            End If

         Else
            ' No connection to the TP so inform user...
            lUserMsg = String.Format("The TPC is not connected to the Transaction Portal.{0}The PrintEntryTicket value is currently set to {1}", gCrLf, mPrintEntryTicket)
            MessageBox.Show(lUserMsg, "Connection Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End If

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::mnuPromoTicketToggle_Click error: " & ex.Message
         MessageBox.Show(lErrorText, "Promo Toggle Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Public Sub DbTpcGetPrintPromo()
      '--------------------------------------------------------------------------------
      ' Purpose: Queries CASINO.PRINT_PROMO_TICKETS and set mPrintEntryTicket to 0 or 1
      ' Called by: MachineManager_Load
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lErrorText As String

      Try
         lSDA = New SqlDataAccess(gConnectionString, False, 60)
         lDT = lSDA.CreateDataTableSP("tpcGetPrintPromo")
         mPrintEntryTicket = CType(lDT.Rows(0).Item(0), Integer)

      Catch ex As Exception
         ' Handle the exception.
         ' Reset mPrintEntryTicket to 0 to indicate error
         mPrintEntryTicket = -1

         ' Build error text.
         lErrorText = Me.Name & "::DbTpcGetPrintPromo error: " & ex.Message

         ' Log and show it...
         FormatLogOutput(lErrorText)
         MessageBox.Show(lErrorText, "DbTpcGetPrintPromo Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup.
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Public Sub DbTpcSetPrintPromo()
      '--------------------------------------------------------------------------------
      ' Update CASINO.PRINT_PROMO_TICKETS with value of mPrintEntryTicket (0 or 1)
      ' Called by MenuTurnPromoTicketOnOff_Click
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lErrorText As String

      Try
         lSDA = New SqlDataAccess(gConnectionString, False, 60)
         lSDA.AddParameter("@PrintPromoValue", SqlDbType.Bit, mPrintEntryTicket)
         lSDA.ExecuteProcedureNoResult("tpcSetPrintPromo")

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::DbTpcSetPrintPromo error: " & ex.ToString
         FormatLogOutput(lErrorText)
         MessageBox.Show(lErrorText, "tpcSetPrintPromo", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Sub ShowTimedMessage(ByVal aMessageText As String, ByVal aCaptionText As String, ByVal aDisplayTime As Integer)
      '--------------------------------------------------------------------------------
      ' Routine to display a messagebox type form that closes itself.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lTimedMsgBox As New TimedMsgBox

      With lTimedMsgBox
         .MessageText = aMessageText
         .TitleText = aCaptionText
         .DisplayTime = aDisplayTime
         .Show()
      End With

   End Sub

End Class

Public Enum SortOrder
   Ascending
   Descending
End Enum

Public Class ListViewStringSort
   Implements IComparer

   Private mSortColumn As Integer
   Private mSortOrder As SortOrder

   Public Sub New(ByVal SortColumn As Integer, ByVal SortOrder As SortOrder)

      mSortColumn = SortColumn
      mSortOrder = SortOrder

   End Sub

   Public Function Compare(ByVal x As Object, ByVal y As Object) As Integer Implements System.Collections.IComparer.Compare
      '--------------------------------------------------------------------------------
      ' Compare function allows comparison of 2 ListItems.
      '--------------------------------------------------------------------------------
      Dim Result As Integer
      Dim ItemX As ListViewItem = CType(x, ListViewItem)
      Dim ItemY As ListViewItem = CType(y, ListViewItem)

      Try
         If x Is Nothing And y Is Nothing Then
            Result = 0
         ElseIf x Is Nothing Then
            Result = 1
         ElseIf y Is Nothing Then
            Result = -1
         Else
            Result = StrComp(ItemX.SubItems(mSortColumn).Text, ItemY.SubItems(mSortColumn).Text, CompareMethod.Text)
         End If

         If mSortOrder = SortOrder.Descending Then
            Result = -Result
         End If

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show(ex.ToString, "ListViewStringSort::Compare Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' Set the function return value.
      Return Result

   End Function

End Class