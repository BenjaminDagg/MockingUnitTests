Imports System.ServiceProcess
Imports System.IO
Imports System.Text

Public Class TPConfig
   Inherits System.Windows.Forms.Form

   Private mServiceController As New System.ServiceProcess.ServiceController
   Friend WithEvents btnBrowse As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents FolderBrowserDlg As System.Windows.Forms.FolderBrowserDialog
   Friend WithEvents gbTPStatus As System.Windows.Forms.GroupBox
   Friend WithEvents lblTPStatus As System.Windows.Forms.Label
   Private mTransPortalServiceName As String = "Transaction Portal"

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
   Friend WithEvents btnStopTPService As System.Windows.Forms.Button
   Friend WithEvents btnStartTPService As System.Windows.Forms.Button
   Friend WithEvents grpConfigPath As System.Windows.Forms.GroupBox
   Friend WithEvents txtPath As System.Windows.Forms.TextBox
   Friend WithEvents lblPath As System.Windows.Forms.Label
   Friend WithEvents lblFileName As System.Windows.Forms.Label
   Friend WithEvents grpConfiguration As System.Windows.Forms.GroupBox
   Friend WithEvents txtConfigFile As System.Windows.Forms.TextBox
   Friend WithEvents btnSaveTPConfig As System.Windows.Forms.Button
   Friend WithEvents btnLoadConfiguration As System.Windows.Forms.Button
   Friend WithEvents txtFileName As System.Windows.Forms.TextBox
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(TPConfig))
      Me.btnStopTPService = New System.Windows.Forms.Button
      Me.btnStartTPService = New System.Windows.Forms.Button
      Me.grpConfigPath = New System.Windows.Forms.GroupBox
      Me.btnBrowse = New System.Windows.Forms.Button
      Me.lblFileName = New System.Windows.Forms.Label
      Me.lblPath = New System.Windows.Forms.Label
      Me.txtFileName = New System.Windows.Forms.TextBox
      Me.txtPath = New System.Windows.Forms.TextBox
      Me.grpConfiguration = New System.Windows.Forms.GroupBox
      Me.btnClose = New System.Windows.Forms.Button
      Me.btnSaveTPConfig = New System.Windows.Forms.Button
      Me.btnLoadConfiguration = New System.Windows.Forms.Button
      Me.txtConfigFile = New System.Windows.Forms.TextBox
      Me.FolderBrowserDlg = New System.Windows.Forms.FolderBrowserDialog
      Me.gbTPStatus = New System.Windows.Forms.GroupBox
      Me.lblTPStatus = New System.Windows.Forms.Label
      Me.grpConfigPath.SuspendLayout()
      Me.grpConfiguration.SuspendLayout()
      Me.gbTPStatus.SuspendLayout()
      Me.SuspendLayout()
      '
      'btnStopTPService
      '
      Me.btnStopTPService.Enabled = False
      Me.btnStopTPService.Location = New System.Drawing.Point(249, 12)
      Me.btnStopTPService.Name = "btnStopTPService"
      Me.btnStopTPService.Size = New System.Drawing.Size(104, 24)
      Me.btnStopTPService.TabIndex = 0
      Me.btnStopTPService.Text = "&Stop TP Service"
      '
      'btnStartTPService
      '
      Me.btnStartTPService.Enabled = False
      Me.btnStartTPService.Location = New System.Drawing.Point(249, 43)
      Me.btnStartTPService.Name = "btnStartTPService"
      Me.btnStartTPService.Size = New System.Drawing.Size(104, 24)
      Me.btnStartTPService.TabIndex = 1
      Me.btnStartTPService.Text = "Start &TP Service"
      '
      'grpConfigPath
      '
      Me.grpConfigPath.Controls.Add(Me.btnBrowse)
      Me.grpConfigPath.Controls.Add(Me.lblFileName)
      Me.grpConfigPath.Controls.Add(Me.lblPath)
      Me.grpConfigPath.Controls.Add(Me.txtFileName)
      Me.grpConfigPath.Controls.Add(Me.txtPath)
      Me.grpConfigPath.ForeColor = System.Drawing.Color.DarkBlue
      Me.grpConfigPath.Location = New System.Drawing.Point(8, 79)
      Me.grpConfigPath.Name = "grpConfigPath"
      Me.grpConfigPath.Size = New System.Drawing.Size(560, 75)
      Me.grpConfigPath.TabIndex = 19
      Me.grpConfigPath.TabStop = False
      Me.grpConfigPath.Text = "Configuration Location"
      '
      'btnBrowse
      '
      Me.btnBrowse.Location = New System.Drawing.Point(322, 17)
      Me.btnBrowse.Name = "btnBrowse"
      Me.btnBrowse.Size = New System.Drawing.Size(54, 23)
      Me.btnBrowse.TabIndex = 23
      Me.btnBrowse.Text = "Browse"
      Me.btnBrowse.UseVisualStyleBackColor = True
      '
      'lblFileName
      '
      Me.lblFileName.Location = New System.Drawing.Point(382, 24)
      Me.lblFileName.Name = "lblFileName"
      Me.lblFileName.Size = New System.Drawing.Size(96, 16)
      Me.lblFileName.TabIndex = 22
      Me.lblFileName.Text = "File"
      '
      'lblPath
      '
      Me.lblPath.Location = New System.Drawing.Point(10, 24)
      Me.lblPath.Name = "lblPath"
      Me.lblPath.Size = New System.Drawing.Size(216, 16)
      Me.lblPath.TabIndex = 21
      Me.lblPath.Text = "Path"
      '
      'txtFileName
      '
      Me.txtFileName.Location = New System.Drawing.Point(382, 44)
      Me.txtFileName.Name = "txtFileName"
      Me.txtFileName.Size = New System.Drawing.Size(168, 20)
      Me.txtFileName.TabIndex = 20
      Me.txtFileName.Text = "TransactionPortal.exe.config"
      '
      'txtPath
      '
      Me.txtPath.Location = New System.Drawing.Point(8, 44)
      Me.txtPath.Name = "txtPath"
      Me.txtPath.Size = New System.Drawing.Size(368, 20)
      Me.txtPath.TabIndex = 19
      Me.txtPath.Text = "C:\Program Files\Diamond Game Enterprises\Transaction Portal"
      '
      'grpConfiguration
      '
      Me.grpConfiguration.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.grpConfiguration.Controls.Add(Me.btnClose)
      Me.grpConfiguration.Controls.Add(Me.btnSaveTPConfig)
      Me.grpConfiguration.Controls.Add(Me.btnLoadConfiguration)
      Me.grpConfiguration.Controls.Add(Me.txtConfigFile)
      Me.grpConfiguration.ForeColor = System.Drawing.Color.DarkBlue
      Me.grpConfiguration.Location = New System.Drawing.Point(7, 164)
      Me.grpConfiguration.Name = "grpConfiguration"
      Me.grpConfiguration.Size = New System.Drawing.Size(676, 283)
      Me.grpConfiguration.TabIndex = 20
      Me.grpConfiguration.TabStop = False
      Me.grpConfiguration.Text = "Configuration"
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.Enabled = False
      Me.btnClose.Location = New System.Drawing.Point(380, 250)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(54, 24)
      Me.btnClose.TabIndex = 20
      Me.btnClose.Text = "&Close"
      '
      'btnSaveTPConfig
      '
      Me.btnSaveTPConfig.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnSaveTPConfig.Enabled = False
      Me.btnSaveTPConfig.Location = New System.Drawing.Point(311, 250)
      Me.btnSaveTPConfig.Name = "btnSaveTPConfig"
      Me.btnSaveTPConfig.Size = New System.Drawing.Size(54, 24)
      Me.btnSaveTPConfig.TabIndex = 19
      Me.btnSaveTPConfig.Text = "S&ave"
      '
      'btnLoadConfiguration
      '
      Me.btnLoadConfiguration.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnLoadConfiguration.Location = New System.Drawing.Point(242, 250)
      Me.btnLoadConfiguration.Name = "btnLoadConfiguration"
      Me.btnLoadConfiguration.Size = New System.Drawing.Size(54, 24)
      Me.btnLoadConfiguration.TabIndex = 18
      Me.btnLoadConfiguration.Text = "&Load"
      '
      'txtConfigFile
      '
      Me.txtConfigFile.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtConfigFile.Font = New System.Drawing.Font("Courier New", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.txtConfigFile.Location = New System.Drawing.Point(8, 19)
      Me.txtConfigFile.Multiline = True
      Me.txtConfigFile.Name = "txtConfigFile"
      Me.txtConfigFile.ScrollBars = System.Windows.Forms.ScrollBars.Both
      Me.txtConfigFile.Size = New System.Drawing.Size(658, 224)
      Me.txtConfigFile.TabIndex = 17
      Me.txtConfigFile.WordWrap = False
      '
      'FolderBrowserDlg
      '
      Me.FolderBrowserDlg.RootFolder = System.Environment.SpecialFolder.ProgramFiles
      Me.FolderBrowserDlg.SelectedPath = "C:\Program Files\Diamond Game Enterprises\Transaction Portal"
      '
      'gbTPStatus
      '
      Me.gbTPStatus.Controls.Add(Me.lblTPStatus)
      Me.gbTPStatus.ForeColor = System.Drawing.Color.DarkBlue
      Me.gbTPStatus.Location = New System.Drawing.Point(8, 12)
      Me.gbTPStatus.Name = "gbTPStatus"
      Me.gbTPStatus.Size = New System.Drawing.Size(226, 47)
      Me.gbTPStatus.TabIndex = 21
      Me.gbTPStatus.TabStop = False
      Me.gbTPStatus.Text = "Transaction Portal Status"
      '
      'lblTPStatus
      '
      Me.lblTPStatus.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblTPStatus.Location = New System.Drawing.Point(11, 17)
      Me.lblTPStatus.Name = "lblTPStatus"
      Me.lblTPStatus.Size = New System.Drawing.Size(203, 23)
      Me.lblTPStatus.TabIndex = 22
      Me.lblTPStatus.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'TPConfig
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(690, 453)
      Me.Controls.Add(Me.gbTPStatus)
      Me.Controls.Add(Me.grpConfiguration)
      Me.Controls.Add(Me.grpConfigPath)
      Me.Controls.Add(Me.btnStartTPService)
      Me.Controls.Add(Me.btnStopTPService)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "TPConfig"
      Me.ShowInTaskbar = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Setup TP Configuration"
      Me.grpConfigPath.ResumeLayout(False)
      Me.grpConfigPath.PerformLayout()
      Me.grpConfiguration.ResumeLayout(False)
      Me.grpConfiguration.PerformLayout()
      Me.gbTPStatus.ResumeLayout(False)
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Cleanup...
      If mServiceController IsNot Nothing Then
         mServiceController.Close()
         mServiceController.Dispose()
      End If

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lServiceFound As Boolean = False

      Try

         For Each lSC As ServiceController In ServiceProcess.ServiceController.GetServices(My.Settings.TPServerName)
            If lSC.ServiceName = mTransPortalServiceName Then
               lServiceFound = True
               Exit For
            End If
         Next

         If lServiceFound Then
            mServiceController = New System.ServiceProcess.ServiceController(mTransPortalServiceName, My.Settings.TPServerName)
            mServiceController.Refresh()

            If mServiceController.Status = ServiceProcess.ServiceControllerStatus.Running Then
               btnStopTPService.Enabled = True
               btnStartTPService.Enabled = False
            Else
               btnStopTPService.Enabled = False
               btnStartTPService.Enabled = True
            End If

            mServiceController.Refresh()
            lblTPStatus.Text = mServiceController.Status.ToString

         Else
            MessageBox.Show("TransPortal service not found - start and stop buttons will be disabled.", "TP Configuration Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            lblTPStatus.Text = "Unknown"
         End If

      Catch ex As Exception
         ' Handle the exception: Disable Stop and Start buttons...
         btnStopTPService.Enabled = False
         btnStartTPService.Enabled = False

      End Try

   End Sub

   Friend Sub StopService()
      '-------------------------------------------------------------------------------
      ' StopService routine - attempts to stop the transportal service.
      '--------------------------------------------------------------------------------

      Try
         mServiceController.ServiceName = mTransPortalServiceName
         mServiceController.Refresh()

         If mServiceController.Status = ServiceProcess.ServiceControllerStatus.Running Then
            If mServiceController.CanStop = True Then
               mServiceController.Stop()
               btnStopTPService.Enabled = False
               btnStartTPService.Enabled = True
            End If
         Else
            btnStopTPService.Enabled = True
            btnStartTPService.Enabled = False
            MessageBox.Show("Service is already stopped.", "Stop TP Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
         End If

         mServiceController.Refresh()

      Catch ex As Exception
         ' Handle the exception...
         MessageBox.Show(Me.Name & "::StopService error: " & ex.Message, "Stop TP Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Friend Sub StartService()
      '--------------------------------------------------------------------------------
      ' StartService routine - attempts to start the transportal service.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lStopwatch As Stopwatch

      Try
         mServiceController.ServiceName = mTransPortalServiceName
         mServiceController.Refresh()

         If mServiceController.Status = ServiceProcess.ServiceControllerStatus.Running Then
            btnStopTPService.Enabled = True
            btnStartTPService.Enabled = False
            MessageBox.Show("Service is already running.", "Start TP Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
         Else
            Me.Cursor = Cursors.AppStarting

            mServiceController.Start()
            btnStopTPService.Enabled = True
            btnStartTPService.Enabled = False
            lStopwatch = Stopwatch.StartNew

            mServiceController.Refresh()
            Do While mServiceController.Status = ServiceControllerStatus.StartPending
               If lStopwatch.ElapsedMilliseconds > 30000 Then Exit Do
               mServiceController.Refresh()
            Loop
         End If

         Me.Cursor = Cursors.Default

      Catch ex As Exception
         ' Handle the exception...
         MessageBox.Show(Me.Name & "::StartService error: " & ex.Message, "Start TP Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Sub btnStopTPService_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
      Handles btnStartTPService.Click, btnStopTPService.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Start and Stop Transportal Service buttons.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lStatusText As String

      If sender Is btnStartTPService Then
         Call StartService()
      Else
         Call StopService()
      End If

      lStatusText = mServiceController.Status.ToString
      MessageBox.Show("TP Service Status: " & lStatusText, "Service Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
      lblTPStatus.Text = lStatusText

   End Sub

   Private Function ReadConfigFile() As Boolean
      '--------------------------------------------------------------------------------
      ' ReadConfigFile - loads the TP config file into txtConfigFile TextBox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lErrorText As String
      Dim lFileName As String

      ' Clear current textbox content.
      txtConfigFile.Clear()

      Try
         ' Build the configfile filename.
         lFileName = Path.Combine(txtPath.Text, txtFileName.Text)

         ' Read file content into the TextBox control.
         txtConfigFile.Text = File.ReadAllText(lFileName)

      Catch ex As Exception
         ' Handle the exception...
         lReturn = False
         lErrorText = Me.Name & "::ReadConfigFile error: " & ex.Message
         MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' Set the function return value.
      Return (lReturn)

   End Function

   Private Function WriteConfigFile() As Boolean
      '--------------------------------------------------------------------------------
      ' WriteConfigFile
      ' Saves txtConfigFile TextBox control content to the TP config file.
      ' Returns T/F to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lErrorText As String
      Dim lFileName As String

      Try
         ' Build the TP Configfile filename.
         lFileName = Path.Combine(txtPath.Text, txtFileName.Text)

         ' Write TextBox control content to the file.
         File.WriteAllText(lFileName, txtConfigFile.Text)

      Catch ex As Exception
         ' Handle the exception.
         lReturn = False
         lErrorText = Me.Name & "::ReadConfigFile error: " & ex.Message
         MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub btnLoadConfiguration_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLoadConfiguration.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Load Configuration button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Attempt to read the config file.
      If ReadConfigFile() Then
         btnLoadConfiguration.Enabled = False
         btnSaveTPConfig.Enabled = True
         ' MessageBox.Show("File Configuration loaded.", "TP Config", MessageBoxButtons.OK, MessageBoxIcon.Information)
      End If

   End Sub

   Private Sub btnSaveTPConfig_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSaveTPConfig.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Load Configuration button.
      '--------------------------------------------------------------------------------

      ' Attempt to save TextBox content back to the config file.
      If WriteConfigFile() Then
         ' Success, enable load button, disable save button, show success...
         btnLoadConfiguration.Enabled = True
         btnSaveTPConfig.Enabled = False
         MessageBox.Show("File Configuration saved.", "TP Config", MessageBoxButtons.OK, MessageBoxIcon.Information)
      End If

   End Sub

   Private Sub btnBrowse_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBrowse.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Browse button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If FolderBrowserDlg.ShowDialog() = DialogResult.OK Then
         txtPath.Text = FolderBrowserDlg.SelectedPath
      End If

   End Sub

End Class
