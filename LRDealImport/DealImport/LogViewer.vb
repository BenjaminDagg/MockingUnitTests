Public Class LogViewer
   Inherits System.Windows.Forms.Form

   Private WithEvents mFSW As FileSystemWatcher
   Private mLogFile As String
   Private mLogFolder As String

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
   Friend WithEvents txtLog As System.Windows.Forms.TextBox
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents btnClearLog As System.Windows.Forms.Button

   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(LogViewer))
      Me.btnClose = New System.Windows.Forms.Button
      Me.txtLog = New System.Windows.Forms.TextBox
      Me.btnClearLog = New System.Windows.Forms.Button
      Me.SuspendLayout()
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(328, 335)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(65, 23)
      Me.btnClose.TabIndex = 1
      Me.btnClose.Text = "Close"
      '
      'txtLog
      '
      Me.txtLog.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtLog.CausesValidation = False
      Me.txtLog.Font = New System.Drawing.Font("Courier New", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.txtLog.Location = New System.Drawing.Point(8, 8)
      Me.txtLog.MaxLength = 0
      Me.txtLog.Multiline = True
      Me.txtLog.Name = "txtLog"
      Me.txtLog.ReadOnly = True
      Me.txtLog.ScrollBars = System.Windows.Forms.ScrollBars.Both
      Me.txtLog.Size = New System.Drawing.Size(609, 319)
      Me.txtLog.TabIndex = 2
      Me.txtLog.Text = ""
      '
      'btnClearLog
      '
      Me.btnClearLog.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClearLog.CausesValidation = False
      Me.btnClearLog.Location = New System.Drawing.Point(232, 335)
      Me.btnClearLog.Name = "btnClearLog"
      Me.btnClearLog.Size = New System.Drawing.Size(65, 23)
      Me.btnClearLog.TabIndex = 3
      Me.btnClearLog.Text = "Clear Log"
      '
      'LogViewer
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(625, 364)
      Me.Controls.Add(Me.btnClearLog)
      Me.Controls.Add(Me.txtLog)
      Me.Controls.Add(Me.btnClose)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "LogViewer"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Log Viewer"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub btnClearLog_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnClearLog.Click
      '--------------------------------------------------------------------------------
      ' Click event for the Clear Log button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lUserMsg As String

      lUserMsg = "Are you sure that you want to clear the contents of the Log File?"
      If MessageBox.Show(lUserMsg, "Please Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
         File.Delete(mLogFile)
         txtLog.Clear()
      End If

   End Sub

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event for the Close button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Sub FillViewer()
      '--------------------------------------------------------------------------------
      ' Routine to read log file contents into the txtLog textbox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSR As StreamReader

      ' Clear current content of the log viewer TextBox control.
      txtLog.Clear()

      If File.Exists(mLogFile) Then
         lSR = File.OpenText(mLogFile)
         With lSR
            txtLog.Text = .ReadToEnd()
            .Close()
         End With
         lSR = Nothing
      End If

      With txtLog
         .Focus()
         .Select(.TextLength, 0)
         .ScrollToCaret()
      End With

   End Sub

   Private Sub Form_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Tell the file system watcher to stop sending events.
      mFSW.EnableRaisingEvents = False
      mFSW.Dispose()
      mFSW = Nothing

      ' Save window state info for next time this form is opened.
      ConfigFile.SetWindowState(Me)

   End Sub

   Private Sub Form_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFilter As String

      ' Get the log file name.
      mLogFile = Logging.LogFileName
      mLogFolder = Path.GetDirectoryName(mLogFile)
      lFilter = Path.GetFileName(mLogFile)


      Me.Text = "Log Viewer - " & mLogFile

      ' Initialize the File System Watcher...
      mFSW = New FileSystemWatcher(mLogFolder, lFilter)
      With mFSW
         .IncludeSubdirectories = False
         .EnableRaisingEvents = True
      End With

      Me.Show()
      FillViewer()

      ' Use last saved window state.
      ConfigFile.GetWindowState(Me)

   End Sub

   Private Sub mFileSystemWatcher_Changed(ByVal sender As Object, ByVal e As System.IO.FileSystemEventArgs) Handles mFSW.Changed
      '--------------------------------------------------------------------------------
      ' Changed event for the File System Watcher.
      '--------------------------------------------------------------------------------

      ' Call the FillViewer routine.
      Call FillViewer()

   End Sub

End Class
