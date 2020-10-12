<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Authorization
   Inherits DGE.DgeSmartForm

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
      Me.components = New System.ComponentModel.Container()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Authorization))
      Me.lblUserName1 = New System.Windows.Forms.Label()
      Me.txtUserName1 = New System.Windows.Forms.TextBox()
      Me.txtPassword1 = New System.Windows.Forms.TextBox()
      Me.lblPassword1 = New System.Windows.Forms.Label()
      Me.txtPassword2 = New System.Windows.Forms.TextBox()
      Me.lblPassword2 = New System.Windows.Forms.Label()
      Me.txtUserName2 = New System.Windows.Forms.TextBox()
      Me.lblUserName2 = New System.Windows.Forms.Label()
      Me.txtMessage = New System.Windows.Forms.TextBox()
      Me.btnCancel = New System.Windows.Forms.Button()
      Me.btnPrint = New System.Windows.Forms.Button()
      Me.ErrProvider = New System.Windows.Forms.ErrorProvider(Me.components)
      Me.progressStatus = New System.Windows.Forms.ProgressBar()
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'lblUserName1
      '
      Me.lblUserName1.AutoSize = True
      Me.lblUserName1.CausesValidation = False
      Me.lblUserName1.Location = New System.Drawing.Point(42, 25)
      Me.lblUserName1.Name = "lblUserName1"
      Me.lblUserName1.Size = New System.Drawing.Size(58, 13)
      Me.lblUserName1.TabIndex = 0
      Me.lblUserName1.Text = "Username:"
      '
      'txtUserName1
      '
      Me.txtUserName1.CausesValidation = False
      Me.txtUserName1.Location = New System.Drawing.Point(101, 21)
      Me.txtUserName1.MaxLength = 10
      Me.txtUserName1.Name = "txtUserName1"
      Me.txtUserName1.Size = New System.Drawing.Size(100, 20)
      Me.txtUserName1.TabIndex = 1
      '
      'txtPassword1
      '
      Me.txtPassword1.CausesValidation = False
      Me.txtPassword1.Location = New System.Drawing.Point(101, 58)
      Me.txtPassword1.Name = "txtPassword1"
      Me.txtPassword1.Size = New System.Drawing.Size(100, 20)
      Me.txtPassword1.TabIndex = 3
      Me.txtPassword1.UseSystemPasswordChar = True
      '
      'lblPassword1
      '
      Me.lblPassword1.AutoSize = True
      Me.lblPassword1.CausesValidation = False
      Me.lblPassword1.Location = New System.Drawing.Point(44, 62)
      Me.lblPassword1.Name = "lblPassword1"
      Me.lblPassword1.Size = New System.Drawing.Size(56, 13)
      Me.lblPassword1.TabIndex = 2
      Me.lblPassword1.Text = "Password:"
      '
      'txtPassword2
      '
      Me.txtPassword2.CausesValidation = False
      Me.txtPassword2.Location = New System.Drawing.Point(292, 58)
      Me.txtPassword2.Name = "txtPassword2"
      Me.txtPassword2.Size = New System.Drawing.Size(100, 20)
      Me.txtPassword2.TabIndex = 7
      Me.txtPassword2.UseSystemPasswordChar = True
      '
      'lblPassword2
      '
      Me.lblPassword2.AutoSize = True
      Me.lblPassword2.CausesValidation = False
      Me.lblPassword2.Location = New System.Drawing.Point(235, 62)
      Me.lblPassword2.Name = "lblPassword2"
      Me.lblPassword2.Size = New System.Drawing.Size(56, 13)
      Me.lblPassword2.TabIndex = 6
      Me.lblPassword2.Text = "Password:"
      '
      'txtUserName2
      '
      Me.txtUserName2.CausesValidation = False
      Me.txtUserName2.Location = New System.Drawing.Point(292, 21)
      Me.txtUserName2.MaxLength = 10
      Me.txtUserName2.Name = "txtUserName2"
      Me.txtUserName2.Size = New System.Drawing.Size(100, 20)
      Me.txtUserName2.TabIndex = 5
      '
      'lblUserName2
      '
      Me.lblUserName2.AutoSize = True
      Me.lblUserName2.CausesValidation = False
      Me.lblUserName2.Location = New System.Drawing.Point(233, 25)
      Me.lblUserName2.Name = "lblUserName2"
      Me.lblUserName2.Size = New System.Drawing.Size(58, 13)
      Me.lblUserName2.TabIndex = 4
      Me.lblUserName2.Text = "Username:"
      '
      'txtMessage
      '
      Me.txtMessage.Location = New System.Drawing.Point(12, 95)
      Me.txtMessage.Multiline = True
      Me.txtMessage.Name = "txtMessage"
      Me.txtMessage.ReadOnly = True
      Me.txtMessage.Size = New System.Drawing.Size(410, 108)
      Me.txtMessage.TabIndex = 8
      '
      'btnCancel
      '
      Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Image = CType(resources.GetObject("btnCancel.Image"), System.Drawing.Image)
      Me.btnCancel.ImageAlign = System.Drawing.ContentAlignment.TopCenter
      Me.btnCancel.Location = New System.Drawing.Point(231, 240)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(61, 39)
      Me.btnCancel.TabIndex = 11
      Me.btnCancel.Text = "Cancel"
      Me.btnCancel.TextAlign = System.Drawing.ContentAlignment.BottomCenter
      '
      'btnPrint
      '
      Me.btnPrint.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnPrint.CausesValidation = False
      Me.btnPrint.Image = CType(resources.GetObject("btnPrint.Image"), System.Drawing.Image)
      Me.btnPrint.ImageAlign = System.Drawing.ContentAlignment.TopCenter
      Me.btnPrint.Location = New System.Drawing.Point(143, 239)
      Me.btnPrint.Name = "btnPrint"
      Me.btnPrint.Size = New System.Drawing.Size(61, 41)
      Me.btnPrint.TabIndex = 10
      Me.btnPrint.Text = "Print"
      Me.btnPrint.TextAlign = System.Drawing.ContentAlignment.BottomCenter
      '
      'ErrProvider
      '
      Me.ErrProvider.ContainerControl = Me
      '
      'progressStatus
      '
      Me.progressStatus.ForeColor = System.Drawing.SystemColors.MenuHighlight
      Me.progressStatus.Location = New System.Drawing.Point(12, 210)
      Me.progressStatus.Name = "progressStatus"
      Me.progressStatus.Size = New System.Drawing.Size(410, 23)
      Me.progressStatus.TabIndex = 9
      '
      'Authorization
      '
      Me.AcceptButton = Me.btnPrint
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.CancelButton = Me.btnCancel
      Me.ClientSize = New System.Drawing.Size(434, 292)
      Me.Controls.Add(Me.progressStatus)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnPrint)
      Me.Controls.Add(Me.txtMessage)
      Me.Controls.Add(Me.txtPassword2)
      Me.Controls.Add(Me.lblPassword2)
      Me.Controls.Add(Me.txtUserName2)
      Me.Controls.Add(Me.lblUserName2)
      Me.Controls.Add(Me.txtPassword1)
      Me.Controls.Add(Me.lblPassword1)
      Me.Controls.Add(Me.txtUserName1)
      Me.Controls.Add(Me.lblUserName1)
      Me.MaximizeBox = False
      Me.MaximumSize = New System.Drawing.Size(450, 330)
      Me.MinimizeBox = False
      Me.MinimumSize = New System.Drawing.Size(450, 330)
      Me.Name = "Authorization"
      Me.ShowIcon = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Authorization"
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents lblUserName1 As System.Windows.Forms.Label
   Friend WithEvents txtUserName1 As System.Windows.Forms.TextBox
   Friend WithEvents txtPassword1 As System.Windows.Forms.TextBox
   Friend WithEvents lblPassword1 As System.Windows.Forms.Label
   Friend WithEvents txtPassword2 As System.Windows.Forms.TextBox
   Friend WithEvents lblPassword2 As System.Windows.Forms.Label
   Friend WithEvents txtUserName2 As System.Windows.Forms.TextBox
   Friend WithEvents lblUserName2 As System.Windows.Forms.Label
   Friend WithEvents txtMessage As System.Windows.Forms.TextBox
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnPrint As System.Windows.Forms.Button
   Friend WithEvents ErrProvider As System.Windows.Forms.ErrorProvider
   Friend WithEvents progressStatus As System.Windows.Forms.ProgressBar
End Class
