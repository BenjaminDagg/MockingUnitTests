<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ChangePassword
   Inherits System.Windows.Forms.Form

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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ChangePassword))
      Me.txtConfirmPassword = New System.Windows.Forms.TextBox()
      Me.lblConfirmPassword = New System.Windows.Forms.Label()
      Me.txtPassword = New System.Windows.Forms.TextBox()
      Me.lblPassword = New System.Windows.Forms.Label()
      Me.btnClose = New System.Windows.Forms.Button()
      Me.btnSave = New System.Windows.Forms.Button()
      Me.txtUserID = New System.Windows.Forms.TextBox()
      Me.lblUserID = New System.Windows.Forms.Label()
      Me.lblAppUserIDValue = New System.Windows.Forms.Label()
      Me.lblAppUserID = New System.Windows.Forms.Label()
      Me.ErrProvider = New System.Windows.Forms.ErrorProvider(Me.components)
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'txtConfirmPassword
      '
      Me.txtConfirmPassword.CausesValidation = False
      Me.txtConfirmPassword.Location = New System.Drawing.Point(164, 112)
      Me.txtConfirmPassword.MaxLength = 64
      Me.txtConfirmPassword.Name = "txtConfirmPassword"
      Me.txtConfirmPassword.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
      Me.txtConfirmPassword.Size = New System.Drawing.Size(133, 20)
      Me.txtConfirmPassword.TabIndex = 5
      '
      'lblConfirmPassword
      '
      Me.lblConfirmPassword.CausesValidation = False
      Me.lblConfirmPassword.Location = New System.Drawing.Point(55, 116)
      Me.lblConfirmPassword.Name = "lblConfirmPassword"
      Me.lblConfirmPassword.Size = New System.Drawing.Size(101, 13)
      Me.lblConfirmPassword.TabIndex = 4
      Me.lblConfirmPassword.Text = "Confirm Password:"
      Me.lblConfirmPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtPassword
      '
      Me.txtPassword.CausesValidation = False
      Me.txtPassword.Location = New System.Drawing.Point(164, 83)
      Me.txtPassword.MaxLength = 64
      Me.txtPassword.Name = "txtPassword"
      Me.txtPassword.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
      Me.txtPassword.Size = New System.Drawing.Size(133, 20)
      Me.txtPassword.TabIndex = 3
      '
      'lblPassword
      '
      Me.lblPassword.CausesValidation = False
      Me.lblPassword.Location = New System.Drawing.Point(55, 87)
      Me.lblPassword.Name = "lblPassword"
      Me.lblPassword.Size = New System.Drawing.Size(101, 13)
      Me.lblPassword.TabIndex = 2
      Me.lblPassword.Text = "Password:"
      Me.lblPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnClose.Location = New System.Drawing.Point(192, 149)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(75, 23)
      Me.btnClose.TabIndex = 7
      Me.btnClose.Text = "Close"
      Me.btnClose.UseVisualStyleBackColor = True
      '
      'btnSave
      '
      Me.btnSave.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnSave.Location = New System.Drawing.Point(98, 149)
      Me.btnSave.Name = "btnSave"
      Me.btnSave.Size = New System.Drawing.Size(75, 23)
      Me.btnSave.TabIndex = 6
      Me.btnSave.Text = "Save"
      Me.btnSave.UseVisualStyleBackColor = True
      '
      'txtUserID
      '
      Me.txtUserID.BackColor = System.Drawing.SystemColors.Window
      Me.txtUserID.CausesValidation = False
      Me.txtUserID.Enabled = False
      Me.txtUserID.Location = New System.Drawing.Point(164, 54)
      Me.txtUserID.MaxLength = 16
      Me.txtUserID.Name = "txtUserID"
      Me.txtUserID.ReadOnly = True
      Me.txtUserID.Size = New System.Drawing.Size(133, 20)
      Me.txtUserID.TabIndex = 1
      Me.txtUserID.TabStop = False
      '
      'lblUserID
      '
      Me.lblUserID.CausesValidation = False
      Me.lblUserID.Location = New System.Drawing.Point(55, 58)
      Me.lblUserID.Name = "lblUserID"
      Me.lblUserID.Size = New System.Drawing.Size(101, 13)
      Me.lblUserID.TabIndex = 0
      Me.lblUserID.Text = "User ID:"
      Me.lblUserID.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblAppUserIDValue
      '
      Me.lblAppUserIDValue.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
      Me.lblAppUserIDValue.CausesValidation = False
      Me.lblAppUserIDValue.Location = New System.Drawing.Point(164, 27)
      Me.lblAppUserIDValue.Name = "lblAppUserIDValue"
      Me.lblAppUserIDValue.Size = New System.Drawing.Size(50, 20)
      Me.lblAppUserIDValue.TabIndex = 9
      '
      'lblAppUserID
      '
      Me.lblAppUserID.CausesValidation = False
      Me.lblAppUserID.Location = New System.Drawing.Point(55, 26)
      Me.lblAppUserID.Name = "lblAppUserID"
      Me.lblAppUserID.Size = New System.Drawing.Size(101, 23)
      Me.lblAppUserID.TabIndex = 8
      Me.lblAppUserID.Text = "Application User ID:"
      Me.lblAppUserID.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'ErrProvider
      '
      Me.ErrProvider.ContainerControl = Me
      '
      'ChangePassword
      '
      Me.AcceptButton = Me.btnSave
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.CancelButton = Me.btnClose
      Me.ClientSize = New System.Drawing.Size(354, 192)
      Me.Controls.Add(Me.lblAppUserIDValue)
      Me.Controls.Add(Me.lblAppUserID)
      Me.Controls.Add(Me.txtUserID)
      Me.Controls.Add(Me.lblUserID)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnSave)
      Me.Controls.Add(Me.txtConfirmPassword)
      Me.Controls.Add(Me.lblConfirmPassword)
      Me.Controls.Add(Me.txtPassword)
      Me.Controls.Add(Me.lblPassword)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MaximizeBox = False
      Me.MaximumSize = New System.Drawing.Size(370, 230)
      Me.MinimizeBox = False
      Me.MinimumSize = New System.Drawing.Size(370, 230)
      Me.Name = "ChangePassword"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Change Password"
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents txtConfirmPassword As System.Windows.Forms.TextBox
   Friend WithEvents lblConfirmPassword As System.Windows.Forms.Label
   Friend WithEvents txtPassword As System.Windows.Forms.TextBox
   Friend WithEvents lblPassword As System.Windows.Forms.Label
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents btnSave As System.Windows.Forms.Button
   Friend WithEvents txtUserID As System.Windows.Forms.TextBox
   Friend WithEvents lblUserID As System.Windows.Forms.Label
   Friend WithEvents lblAppUserIDValue As System.Windows.Forms.Label
   Friend WithEvents lblAppUserID As System.Windows.Forms.Label
   Friend WithEvents ErrProvider As System.Windows.Forms.ErrorProvider
End Class
