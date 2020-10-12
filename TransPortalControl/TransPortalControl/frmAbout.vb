Option Explicit On
Option Strict On

Imports System.IO
Imports System.Reflection
Imports System.Text

Public Class frmAbout
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
   Friend WithEvents btnOk As System.Windows.Forms.Button
   Friend WithEvents lblLine As System.Windows.Forms.Label
   Friend WithEvents Label2 As System.Windows.Forms.Label
   Friend WithEvents lblWarning As System.Windows.Forms.Label
   Friend WithEvents lblCopyright As System.Windows.Forms.Label
   Friend WithEvents lblVersion As System.Windows.Forms.Label
   Friend WithEvents pbDecoration As System.Windows.Forms.PictureBox
   Friend WithEvents lblServer As System.Windows.Forms.Label
   Friend WithEvents lblDBInfo As System.Windows.Forms.Label
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmAbout))
      Me.btnOk = New System.Windows.Forms.Button
      Me.lblWarning = New System.Windows.Forms.Label
      Me.lblLine = New System.Windows.Forms.Label
      Me.Label2 = New System.Windows.Forms.Label
      Me.pbDecoration = New System.Windows.Forms.PictureBox
      Me.lblCopyright = New System.Windows.Forms.Label
      Me.lblVersion = New System.Windows.Forms.Label
      Me.lblServer = New System.Windows.Forms.Label
      Me.lblDBInfo = New System.Windows.Forms.Label
      CType(Me.pbDecoration, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'btnOk
      '
      Me.btnOk.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnOk.CausesValidation = False
      Me.btnOk.Location = New System.Drawing.Point(203, 245)
      Me.btnOk.Name = "btnOk"
      Me.btnOk.Size = New System.Drawing.Size(56, 23)
      Me.btnOk.TabIndex = 0
      Me.btnOk.Text = "&OK"
      '
      'lblWarning
      '
      Me.lblWarning.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblWarning.CausesValidation = False
      Me.lblWarning.Location = New System.Drawing.Point(80, 156)
      Me.lblWarning.Name = "lblWarning"
      Me.lblWarning.Size = New System.Drawing.Size(371, 65)
      Me.lblWarning.TabIndex = 1
      Me.lblWarning.Text = resources.GetString("lblWarning.Text")
      '
      'lblLine
      '
      Me.lblLine.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblLine.BackColor = System.Drawing.SystemColors.AppWorkspace
      Me.lblLine.CausesValidation = False
      Me.lblLine.Location = New System.Drawing.Point(80, 145)
      Me.lblLine.Name = "lblLine"
      Me.lblLine.Size = New System.Drawing.Size(371, 3)
      Me.lblLine.TabIndex = 2
      '
      'Label2
      '
      Me.Label2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.Label2.BackColor = System.Drawing.SystemColors.AppWorkspace
      Me.Label2.CausesValidation = False
      Me.Label2.Location = New System.Drawing.Point(80, 232)
      Me.Label2.Name = "Label2"
      Me.Label2.Size = New System.Drawing.Size(371, 1)
      Me.Label2.TabIndex = 3
      '
      'pbDecoration
      '
      Me.pbDecoration.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
      Me.pbDecoration.BackColor = System.Drawing.Color.RoyalBlue
      Me.pbDecoration.Location = New System.Drawing.Point(8, 8)
      Me.pbDecoration.Name = "pbDecoration"
      Me.pbDecoration.Size = New System.Drawing.Size(64, 256)
      Me.pbDecoration.TabIndex = 4
      Me.pbDecoration.TabStop = False
      '
      'lblCopyright
      '
      Me.lblCopyright.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblCopyright.CausesValidation = False
      Me.lblCopyright.Location = New System.Drawing.Point(79, 24)
      Me.lblCopyright.Name = "lblCopyright"
      Me.lblCopyright.Size = New System.Drawing.Size(372, 14)
      Me.lblCopyright.TabIndex = 5
      Me.lblCopyright.Text = "Copyright (c) 2003 Diamondgame Enterprises"
      Me.lblCopyright.UseMnemonic = False
      '
      'lblVersion
      '
      Me.lblVersion.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblVersion.CausesValidation = False
      Me.lblVersion.Location = New System.Drawing.Point(79, 52)
      Me.lblVersion.Name = "lblVersion"
      Me.lblVersion.Size = New System.Drawing.Size(372, 14)
      Me.lblVersion.TabIndex = 6
      Me.lblVersion.Text = "Version:"
      Me.lblVersion.UseMnemonic = False
      '
      'lblServer
      '
      Me.lblServer.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblServer.CausesValidation = False
      Me.lblServer.Location = New System.Drawing.Point(79, 80)
      Me.lblServer.Name = "lblServer"
      Me.lblServer.Size = New System.Drawing.Size(372, 14)
      Me.lblServer.TabIndex = 9
      Me.lblServer.Text = "Server:"
      Me.lblServer.UseMnemonic = False
      '
      'lblDBInfo
      '
      Me.lblDBInfo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblDBInfo.CausesValidation = False
      Me.lblDBInfo.Location = New System.Drawing.Point(79, 108)
      Me.lblDBInfo.Name = "lblDBInfo"
      Me.lblDBInfo.Size = New System.Drawing.Size(372, 14)
      Me.lblDBInfo.TabIndex = 10
      Me.lblDBInfo.Text = "Database Info"
      Me.lblDBInfo.UseMnemonic = False
      '
      'frmAbout
      '
      Me.AcceptButton = Me.btnOk
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(462, 273)
      Me.Controls.Add(Me.lblDBInfo)
      Me.Controls.Add(Me.lblServer)
      Me.Controls.Add(Me.lblVersion)
      Me.Controls.Add(Me.lblCopyright)
      Me.Controls.Add(Me.pbDecoration)
      Me.Controls.Add(Me.Label2)
      Me.Controls.Add(Me.lblLine)
      Me.Controls.Add(Me.lblWarning)
      Me.Controls.Add(Me.btnOk)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MaximizeBox = False
      Me.MinimizeBox = False
      Me.Name = "frmAbout"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "About Transaction Portal Control"
      CType(Me.pbDecoration, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub btnOk_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOk.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the OK button.
      '--------------------------------------------------------------------------------

      Me.Close()

   End Sub

   Private Sub Form_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      ' Retrieve application information and display in the approprate label controls.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess

      Dim lErrorText As String

      Try
         ' Retrieve version information...
         ' Set the Version label text.
         lblVersion.Text = "Version: " & Application.ProductVersion

         ' Set Server label text.
         lblServer.Text = "Server: " & gServer & ":" & My.Settings.Port.ToString

         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectionString)

         ' BuildConnetion must be called before the server and database names are available.
         lSDA.BuildConnection()

         ' Get connection info.
         lblDBInfo.Text = "DB Connection: " & lSDA.SQLServerName & "." & lSDA.SQLDatabaseName

         ' Free the SqlDataAccess instance.
         lSDA.Dispose()
         lSDA = Nothing

      Catch ex As Exception
         ' Handle the error.
         lErrorText = Me.Name & "::Load event error: " & ex.Message
         MessageBox.Show(lErrorText, "About Form Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

End Class
