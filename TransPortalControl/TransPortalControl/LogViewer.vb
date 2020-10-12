Option Explicit On 
Option Strict On

Imports System.IO

Public Class LogViewer
   Inherits System.Windows.Forms.Form

   Private mStreamReader As StreamReader

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
   Friend WithEvents btnRefresh As System.Windows.Forms.Button

   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(LogViewer))
      Me.txtLog = New System.Windows.Forms.TextBox
      Me.btnRefresh = New System.Windows.Forms.Button
      Me.btnClose = New System.Windows.Forms.Button
      Me.SuspendLayout()
      '
      'txtLog
      '
      Me.txtLog.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtLog.Location = New System.Drawing.Point(8, 12)
      Me.txtLog.MaxLength = 0
      Me.txtLog.Multiline = True
      Me.txtLog.Name = "txtLog"
      Me.txtLog.ReadOnly = True
      Me.txtLog.ScrollBars = System.Windows.Forms.ScrollBars.Both
      Me.txtLog.Size = New System.Drawing.Size(789, 428)
      Me.txtLog.TabIndex = 0
      '
      'btnRefresh
      '
      Me.btnRefresh.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnRefresh.Location = New System.Drawing.Point(310, 444)
      Me.btnRefresh.Name = "btnRefresh"
      Me.btnRefresh.Size = New System.Drawing.Size(75, 23)
      Me.btnRefresh.TabIndex = 1
      Me.btnRefresh.Text = "Refresh"
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.Location = New System.Drawing.Point(419, 444)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(75, 23)
      Me.btnClose.TabIndex = 2
      Me.btnClose.Text = "Close"
      '
      'LogViewer
      '
      Me.AcceptButton = Me.btnRefresh
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(805, 473)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnRefresh)
      Me.Controls.Add(Me.txtLog)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "LogViewer"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Log Viewer"
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub

#End Region

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnRefresh_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Refresh button.
      '--------------------------------------------------------------------------------

      ' Display log text...
      Me.FillViewer()

   End Sub

   Private Sub mnuCloseLogViewer_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close Log Viewer menu item.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub Me_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String

      Try
         Me.Show()
         Me.Text = "Log Viewer - " & gLogFile
         Call FillViewer()

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::LogViewer_Load error: " & ex.ToString
         MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Sub FillViewer()
      '--------------------------------------------------------------------------------
      ' FillViewer Subroutine.
      ' Loads TP log file into txtLog TextBox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lChunkSize As Long = 131072

      txtLog.Clear()

      Try
         ' Does the log file exist?
         If File.Exists(gLogFile) Then
            ' Yes, so create a new StreamReader to read the log file.
            mStreamReader = New StreamReader(gLogFile)

            ' If the file is greater than Chunk Size, move the stream position to where there is just
            ' Chunk Size amount of data left and read the next line so that partial lines won't be diplayed.
            If mStreamReader.BaseStream.Length > lChunkSize Then
               mStreamReader.BaseStream.Position = mStreamReader.BaseStream.Length - lChunkSize
               mStreamReader.ReadLine()
            End If

            With txtLog
               .Focus()
               .AppendText(mStreamReader.ReadToEnd)
               .Select(txtLog.TextLength, 0)
               .ScrollToCaret()
            End With

            mStreamReader.Close()
            ' Else
            ' Log file not found.
            ' MessageBox.Show("Log file " & gLogFile & " was not found.", "Read Log File Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
         End If

      Catch ex As Exception
         ' Handle the exception...
         MessageBox.Show("A problem was encountered while attempting to load the log file." & gCrLf & _
                        "Please check the path of the log file in the setting window.", _
                        "Error Encountered", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try

   End Sub

End Class
