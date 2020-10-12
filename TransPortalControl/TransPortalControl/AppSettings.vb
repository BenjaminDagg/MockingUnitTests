Imports System.IO

Public Class AppSettings
   Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

   Public Sub New(Optional ByVal TabPage As Integer = 0)
      MyBase.New()

      'This call is required by the Windows Form Designer.
      InitializeComponent()

      'Add any initialization after the InitializeComponent() call
      ' If TabPage < TCSettings.TabCount Then TCSettings.SelectedIndex = TabPage
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
   Friend WithEvents TCSettings As System.Windows.Forms.TabControl
   Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
   Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
   Friend WithEvents btnPathUpdate As System.Windows.Forms.Button
   Friend WithEvents grpLogFileLocation As System.Windows.Forms.GroupBox
   Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
   Friend WithEvents btnPollingIntervalUpdate As System.Windows.Forms.Button
   Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
   Friend WithEvents btnServerPortUpdate As System.Windows.Forms.Button
   Friend WithEvents Label1 As System.Windows.Forms.Label
   Friend WithEvents Label2 As System.Windows.Forms.Label
   Friend WithEvents Label3 As System.Windows.Forms.Label
   Friend WithEvents Label4 As System.Windows.Forms.Label
   Friend WithEvents Label5 As System.Windows.Forms.Label
   Friend WithEvents txtLogFile As System.Windows.Forms.TextBox
   Friend WithEvents txtPollingSeconds As System.Windows.Forms.TextBox
   Friend WithEvents txtPort As System.Windows.Forms.TextBox
   Friend WithEvents txtServer As System.Windows.Forms.TextBox
   Friend WithEvents Label6 As System.Windows.Forms.Label
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(AppSettings))
        Me.TCSettings = New System.Windows.Forms.TabControl()
        Me.TabPage1 = New System.Windows.Forms.TabPage()
        Me.grpLogFileLocation = New System.Windows.Forms.GroupBox()
        Me.txtLogFile = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.btnPathUpdate = New System.Windows.Forms.Button()
        Me.TabPage2 = New System.Windows.Forms.TabPage()
        Me.GroupBox3 = New System.Windows.Forms.GroupBox()
        Me.txtPort = New System.Windows.Forms.TextBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.txtServer = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.btnServerPortUpdate = New System.Windows.Forms.Button()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.txtPollingSeconds = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.btnPollingIntervalUpdate = New System.Windows.Forms.Button()
        Me.TCSettings.SuspendLayout
        Me.TabPage1.SuspendLayout
        Me.grpLogFileLocation.SuspendLayout
        Me.TabPage2.SuspendLayout
        Me.GroupBox3.SuspendLayout
        Me.GroupBox2.SuspendLayout
        Me.SuspendLayout
        '
        'TCSettings
        '
        Me.TCSettings.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom)  _
            Or System.Windows.Forms.AnchorStyles.Left)  _
            Or System.Windows.Forms.AnchorStyles.Right),System.Windows.Forms.AnchorStyles)
        Me.TCSettings.Controls.Add(Me.TabPage1)
        Me.TCSettings.Controls.Add(Me.TabPage2)
        Me.TCSettings.Location = New System.Drawing.Point(10, 18)
        Me.TCSettings.Name = "TCSettings"
        Me.TCSettings.SelectedIndex = 0
        Me.TCSettings.Size = New System.Drawing.Size(495, 266)
        Me.TCSettings.TabIndex = 0
        '
        'TabPage1
        '
        Me.TabPage1.CausesValidation = false
        Me.TabPage1.Controls.Add(Me.grpLogFileLocation)
        Me.TabPage1.Location = New System.Drawing.Point(4, 29)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Size = New System.Drawing.Size(487, 233)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.Text = "Log File"
        Me.TabPage1.UseVisualStyleBackColor = true
        '
        'grpLogFileLocation
        '
        Me.grpLogFileLocation.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left)  _
            Or System.Windows.Forms.AnchorStyles.Right),System.Windows.Forms.AnchorStyles)
        Me.grpLogFileLocation.Controls.Add(Me.txtLogFile)
        Me.grpLogFileLocation.Controls.Add(Me.Label6)
        Me.grpLogFileLocation.Controls.Add(Me.btnPathUpdate)
        Me.grpLogFileLocation.Location = New System.Drawing.Point(13, 23)
        Me.grpLogFileLocation.Name = "grpLogFileLocation"
        Me.grpLogFileLocation.Size = New System.Drawing.Size(454, 164)
        Me.grpLogFileLocation.TabIndex = 3
        Me.grpLogFileLocation.TabStop = false
        Me.grpLogFileLocation.Text = "Log File Path"
        '
        'txtLogFile
        '
        Me.txtLogFile.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left)  _
            Or System.Windows.Forms.AnchorStyles.Right),System.Windows.Forms.AnchorStyles)
        Me.txtLogFile.Location = New System.Drawing.Point(13, 70)
        Me.txtLogFile.Name = "txtLogFile"
        Me.txtLogFile.Size = New System.Drawing.Size(432, 26)
        Me.txtLogFile.TabIndex = 1
        '
        'Label6
        '
        Me.Label6.Location = New System.Drawing.Point(13, 35)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(217, 34)
        Me.Label6.TabIndex = 3
        Me.Label6.Text = "Local path to log file:"
        '
        'btnPathUpdate
        '
        Me.btnPathUpdate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right),System.Windows.Forms.AnchorStyles)
        Me.btnPathUpdate.Location = New System.Drawing.Point(325, 117)
        Me.btnPathUpdate.Name = "btnPathUpdate"
        Me.btnPathUpdate.Size = New System.Drawing.Size(120, 34)
        Me.btnPathUpdate.TabIndex = 2
        Me.btnPathUpdate.Text = "Update"
        '
        'TabPage2
        '
        Me.TabPage2.CausesValidation = false
        Me.TabPage2.Controls.Add(Me.GroupBox3)
        Me.TabPage2.Controls.Add(Me.GroupBox2)
        Me.TabPage2.Location = New System.Drawing.Point(4, 29)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Size = New System.Drawing.Size(796, 389)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.Text = "Server Settings"
        Me.TabPage2.UseVisualStyleBackColor = true
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.txtPort)
        Me.GroupBox3.Controls.Add(Me.Label4)
        Me.GroupBox3.Controls.Add(Me.txtServer)
        Me.GroupBox3.Controls.Add(Me.Label3)
        Me.GroupBox3.Controls.Add(Me.Label2)
        Me.GroupBox3.Controls.Add(Me.btnServerPortUpdate)
        Me.GroupBox3.Location = New System.Drawing.Point(13, 199)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(414, 163)
        Me.GroupBox3.TabIndex = 9
        Me.GroupBox3.TabStop = false
        Me.GroupBox3.Text = "Connect To"
        '
        'txtPort
        '
        Me.txtPort.Location = New System.Drawing.Point(320, 70)
        Me.txtPort.Name = "txtPort"
        Me.txtPort.Size = New System.Drawing.Size(64, 26)
        Me.txtPort.TabIndex = 7
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(269, 75)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(77, 19)
        Me.Label4.TabIndex = 11
        Me.Label4.Text = "Port:"
        '
        'txtServer
        '
        Me.txtServer.Location = New System.Drawing.Point(90, 70)
        Me.txtServer.Name = "txtServer"
        Me.txtServer.Size = New System.Drawing.Size(153, 26)
        Me.txtServer.TabIndex = 5
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(13, 75)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(77, 19)
        Me.Label3.TabIndex = 10
        Me.Label3.Text = "Server:"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(13, 35)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(384, 23)
        Me.Label2.TabIndex = 9
        Me.Label2.Text = "Connect to this server:"
        '
        'btnServerPortUpdate
        '
        Me.btnServerPortUpdate.Location = New System.Drawing.Point(307, 117)
        Me.btnServerPortUpdate.Name = "btnServerPortUpdate"
        Me.btnServerPortUpdate.Size = New System.Drawing.Size(90, 34)
        Me.btnServerPortUpdate.TabIndex = 8
        Me.btnServerPortUpdate.Text = "Update"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.Label5)
        Me.GroupBox2.Controls.Add(Me.txtPollingSeconds)
        Me.GroupBox2.Controls.Add(Me.Label1)
        Me.GroupBox2.Controls.Add(Me.btnPollingIntervalUpdate)
        Me.GroupBox2.Location = New System.Drawing.Point(13, 23)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(414, 164)
        Me.GroupBox2.TabIndex = 8
        Me.GroupBox2.TabStop = false
        Me.GroupBox2.Text = "Polling Interval"
        '
        'Label5
        '
        Me.Label5.Location = New System.Drawing.Point(13, 76)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(89, 19)
        Me.Label5.TabIndex = 11
        Me.Label5.Text = "Seconds:"
        '
        'txtPollingSeconds
        '
        Me.txtPollingSeconds.AcceptsReturn = true
        Me.txtPollingSeconds.Location = New System.Drawing.Point(102, 70)
        Me.txtPollingSeconds.Name = "txtPollingSeconds"
        Me.txtPollingSeconds.Size = New System.Drawing.Size(77, 26)
        Me.txtPollingSeconds.TabIndex = 3
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(13, 35)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(384, 23)
        Me.Label1.TabIndex = 5
        Me.Label1.Text = "Number of seconds between update requests."
        '
        'btnPollingIntervalUpdate
        '
        Me.btnPollingIntervalUpdate.Location = New System.Drawing.Point(307, 117)
        Me.btnPollingIntervalUpdate.Name = "btnPollingIntervalUpdate"
        Me.btnPollingIntervalUpdate.Size = New System.Drawing.Size(90, 34)
        Me.btnPollingIntervalUpdate.TabIndex = 4
        Me.btnPollingIntervalUpdate.Text = "Update"
        '
        'AppSettings
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(8, 19)
        Me.CausesValidation = false
        Me.ClientSize = New System.Drawing.Size(515, 338)
        Me.Controls.Add(Me.TCSettings)
        Me.Icon = CType(resources.GetObject("$this.Icon"),System.Drawing.Icon)
        Me.Name = "AppSettings"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Settings"
        Me.TCSettings.ResumeLayout(false)
        Me.TabPage1.ResumeLayout(false)
        Me.grpLogFileLocation.ResumeLayout(false)
        Me.grpLogFileLocation.PerformLayout
        Me.TabPage2.ResumeLayout(false)
        Me.GroupBox3.ResumeLayout(false)
        Me.GroupBox3.PerformLayout
        Me.GroupBox2.ResumeLayout(false)
        Me.GroupBox2.PerformLayout
        Me.ResumeLayout(false)

End Sub

   Protected Overrides Sub Finalize()
      MyBase.Finalize()
   End Sub

#End Region

   Private Sub btnPathUpdate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPathUpdate.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the PathUpdate button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lLogFilename = txtLogFile.Text

      Try
         ' Do we have text?
         If Not String.IsNullOrEmpty(lLogFilename) Then

                If File.Exists(lLogFilename) Then
                    ' Yes, so save it...
                    My.Settings.LogFile = txtLogFile.Text
                    My.Settings.Save()
                    MessageBox.Show("Log File has been Updated successfully.", "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Information)

                Else
                    MessageBox.Show("Invalid Log File Name. File path entered is invalid or does not exist.", "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

                End If
                
         Else
                MessageBox.Show("Invalid Log File name. Cannot be empty.", "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End If

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show(Me.Name & "::btnPathUpdate_Click error: " & ex.Message, "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Sub btnPollingIntervalUpdate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPollingIntervalUpdate.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the PathUpdate button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lPollInteval As Integer

      Try
         ' Can we convert text to Int?
         If Integer.TryParse(txtPollingSeconds.Text, lPollInteval) Then
            ' Is it within a reasonable range?
            If IsInRange(lPollInteval, 5, 120) Then
               ' Yes, so save it...
               My.Settings.PollingInterval = lPollInteval
               My.Settings.Save()
               MessageBox.Show("Polling Interval has been successfully saved.", "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Else
               ' Out of range
               MessageBox.Show("Polling Interval value out of range (5 to 120 seconds).", "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
         Else
            ' Could not convert to an int.
            MessageBox.Show("Invalid Polling interval.", "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End If

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show(Me.Name & "::btnPollingIntervalUpdate_Click error: " & ex.Message, "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Sub btnServerPortUpdate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnServerPortUpdate.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Server and Port update button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""
      Dim lServer As String

      Dim lPort As Integer

      Try
         lServer = txtServer.Text
         If lServer.Length > 0 Then
            If Integer.TryParse(txtPort.Text, lPort) Then
               If IsInRange(lPort, 4500, 5000) Then
                  My.Settings.Server = lServer
                  My.Settings.Port = lPort
                  My.Settings.Save()
                  gServer = lServer
                  gPort = lPort
                  MessageBox.Show("Server and Port settings have been successfully saved.", "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
               Else
                  lErrorText = "The Port setting value is out of range (4500 to 5000)."
               End If
            Else
               lErrorText = "Invalid Port value."
            End If
         Else
            lErrorText = "A Server value is required."
         End If

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::btnServerPortUpdate_Click error: " & ex.Message

      End Try

      ' Do we have error text?
      If lErrorText.Length > 0 Then
         ' Yes, so log (if tracing is on) and show it.
         FormatLogOutput(lErrorText)
         MessageBox.Show(lErrorText, "Update Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Hide buttons...
      ' btnPollingIntervalUpdate.Hide()
      ' btnServerPortUpdate.Hide()

      ' Initialize TextBox control Text values...
      With My.Settings
         txtServer.Text = .Server
         txtLogFile.Text = .LogFile
         txtPort.Text = .Port
         txtPollingSeconds.Text = .PollingInterval
      End With

   End Sub

  

End Class
