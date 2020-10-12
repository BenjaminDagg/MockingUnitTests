<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AppUserAddEdit
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(AppUserAddEdit))
        Me.lblAppUserID = New System.Windows.Forms.Label()
        Me.lblUserID = New System.Windows.Forms.Label()
        Me.txtUserID = New System.Windows.Forms.TextBox()
        Me.lblFirstName = New System.Windows.Forms.Label()
        Me.lblPassword = New System.Windows.Forms.Label()
        Me.txtFirstName = New System.Windows.Forms.TextBox()
        Me.txtPassword = New System.Windows.Forms.TextBox()
        Me.lblAppUserIDValue = New System.Windows.Forms.Label()
        Me.lblConfirmPassword = New System.Windows.Forms.Label()
        Me.txtConfirmPassword = New System.Windows.Forms.TextBox()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.cbIsActive = New System.Windows.Forms.CheckBox()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.ErrProvider = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.PnlGroup = New System.Windows.Forms.Panel()
        Me.lblGroupPool = New System.Windows.Forms.Label()
        Me.lblAssignedGroups = New System.Windows.Forms.Label()
        Me.btnRemoveGroup = New System.Windows.Forms.Button()
        Me.btnAddGroup = New System.Windows.Forms.Button()
        Me.lstGroupPool = New System.Windows.Forms.ListBox()
        Me.lstAssignedGroups = New System.Windows.Forms.ListBox()
        Me.btnChangePassword = New System.Windows.Forms.Button()
        Me.btnUnlockAccount = New System.Windows.Forms.Button()
        Me.txtLastName = New System.Windows.Forms.TextBox()
        Me.lblLastName = New System.Windows.Forms.Label()
        CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.PnlGroup.SuspendLayout()
        Me.SuspendLayout()
        '
        'lblAppUserID
        '
        Me.lblAppUserID.CausesValidation = False
        Me.lblAppUserID.Location = New System.Drawing.Point(76, 26)
        Me.lblAppUserID.Name = "lblAppUserID"
        Me.lblAppUserID.Size = New System.Drawing.Size(101, 23)
        Me.lblAppUserID.TabIndex = 0
        Me.lblAppUserID.Text = "Application User ID:"
        Me.lblAppUserID.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblUserID
        '
        Me.lblUserID.CausesValidation = False
        Me.lblUserID.Location = New System.Drawing.Point(129, 59)
        Me.lblUserID.Name = "lblUserID"
        Me.lblUserID.Size = New System.Drawing.Size(48, 13)
        Me.lblUserID.TabIndex = 2
        Me.lblUserID.Text = "User ID:"
        Me.lblUserID.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'txtUserID
        '
        Me.txtUserID.CausesValidation = False
        Me.txtUserID.Location = New System.Drawing.Point(185, 55)
        Me.txtUserID.MaxLength = 16
        Me.txtUserID.Name = "txtUserID"
        Me.txtUserID.Size = New System.Drawing.Size(123, 20)
        Me.txtUserID.TabIndex = 3
        '
        'lblFirstName
        '
        Me.lblFirstName.CausesValidation = False
        Me.lblFirstName.Location = New System.Drawing.Point(76, 87)
        Me.lblFirstName.Name = "lblFirstName"
        Me.lblFirstName.Size = New System.Drawing.Size(101, 13)
        Me.lblFirstName.TabIndex = 4
        Me.lblFirstName.Text = "First Name:"
        Me.lblFirstName.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblPassword
        '
        Me.lblPassword.CausesValidation = False
        Me.lblPassword.Location = New System.Drawing.Point(76, 136)
        Me.lblPassword.Name = "lblPassword"
        Me.lblPassword.Size = New System.Drawing.Size(101, 13)
        Me.lblPassword.TabIndex = 8
        Me.lblPassword.Text = "Password:"
        Me.lblPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'txtFirstName
        '
        Me.txtFirstName.CausesValidation = False
        Me.txtFirstName.Location = New System.Drawing.Point(185, 83)
        Me.txtFirstName.MaxLength = 64
        Me.txtFirstName.Name = "txtFirstName"
        Me.txtFirstName.Size = New System.Drawing.Size(123, 20)
        Me.txtFirstName.TabIndex = 5
        '
        'txtPassword
        '
        Me.txtPassword.CausesValidation = False
        Me.txtPassword.Location = New System.Drawing.Point(185, 132)
        Me.txtPassword.MaxLength = 64
        Me.txtPassword.Name = "txtPassword"
        Me.txtPassword.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
        Me.txtPassword.Size = New System.Drawing.Size(123, 20)
        Me.txtPassword.TabIndex = 9
        '
        'lblAppUserIDValue
        '
        Me.lblAppUserIDValue.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblAppUserIDValue.CausesValidation = False
        Me.lblAppUserIDValue.Location = New System.Drawing.Point(185, 27)
        Me.lblAppUserIDValue.Name = "lblAppUserIDValue"
        Me.lblAppUserIDValue.Size = New System.Drawing.Size(50, 20)
        Me.lblAppUserIDValue.TabIndex = 1
        '
        'lblConfirmPassword
        '
        Me.lblConfirmPassword.CausesValidation = False
        Me.lblConfirmPassword.Location = New System.Drawing.Point(76, 164)
        Me.lblConfirmPassword.Name = "lblConfirmPassword"
        Me.lblConfirmPassword.Size = New System.Drawing.Size(101, 13)
        Me.lblConfirmPassword.TabIndex = 10
        Me.lblConfirmPassword.Text = "Confirm Password:"
        Me.lblConfirmPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'txtConfirmPassword
        '
        Me.txtConfirmPassword.CausesValidation = False
        Me.txtConfirmPassword.Location = New System.Drawing.Point(185, 160)
        Me.txtConfirmPassword.MaxLength = 64
        Me.txtConfirmPassword.Name = "txtConfirmPassword"
        Me.txtConfirmPassword.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
        Me.txtConfirmPassword.Size = New System.Drawing.Size(123, 20)
        Me.txtConfirmPassword.TabIndex = 11
        '
        'btnSave
        '
        Me.btnSave.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnSave.Location = New System.Drawing.Point(108, 384)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(75, 23)
        Me.btnSave.TabIndex = 15
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = True
        '
        'cbIsActive
        '
        Me.cbIsActive.AutoSize = True
        Me.cbIsActive.CausesValidation = False
        Me.cbIsActive.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.cbIsActive.Location = New System.Drawing.Point(252, 29)
        Me.cbIsActive.Name = "cbIsActive"
        Me.cbIsActive.Size = New System.Drawing.Size(56, 17)
        Me.cbIsActive.TabIndex = 17
        Me.cbIsActive.Text = "Active"
        Me.cbIsActive.UseVisualStyleBackColor = True
        '
        'btnClose
        '
        Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnClose.Location = New System.Drawing.Point(202, 384)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(75, 23)
        Me.btnClose.TabIndex = 16
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = True
        '
        'ErrProvider
        '
        Me.ErrProvider.ContainerControl = Me
        '
        'PnlGroup
        '
        Me.PnlGroup.Controls.Add(Me.lblGroupPool)
        Me.PnlGroup.Controls.Add(Me.lblAssignedGroups)
        Me.PnlGroup.Controls.Add(Me.btnRemoveGroup)
        Me.PnlGroup.Controls.Add(Me.btnAddGroup)
        Me.PnlGroup.Controls.Add(Me.lstGroupPool)
        Me.PnlGroup.Controls.Add(Me.lstAssignedGroups)
        Me.PnlGroup.Location = New System.Drawing.Point(37, 236)
        Me.PnlGroup.Name = "PnlGroup"
        Me.PnlGroup.Size = New System.Drawing.Size(311, 136)
        Me.PnlGroup.TabIndex = 14
        '
        'lblGroupPool
        '
        Me.lblGroupPool.AutoSize = True
        Me.lblGroupPool.CausesValidation = False
        Me.lblGroupPool.Location = New System.Drawing.Point(181, 7)
        Me.lblGroupPool.Name = "lblGroupPool"
        Me.lblGroupPool.Size = New System.Drawing.Size(60, 13)
        Me.lblGroupPool.TabIndex = 2
        Me.lblGroupPool.Text = "Group Pool"
        '
        'lblAssignedGroups
        '
        Me.lblAssignedGroups.AutoSize = True
        Me.lblAssignedGroups.CausesValidation = False
        Me.lblAssignedGroups.Location = New System.Drawing.Point(6, 7)
        Me.lblAssignedGroups.Name = "lblAssignedGroups"
        Me.lblAssignedGroups.Size = New System.Drawing.Size(87, 13)
        Me.lblAssignedGroups.TabIndex = 0
        Me.lblAssignedGroups.Text = "Assigned Groups"
        '
        'btnRemoveGroup
        '
        Me.btnRemoveGroup.CausesValidation = False
        Me.btnRemoveGroup.Location = New System.Drawing.Point(143, 72)
        Me.btnRemoveGroup.Name = "btnRemoveGroup"
        Me.btnRemoveGroup.Size = New System.Drawing.Size(26, 23)
        Me.btnRemoveGroup.TabIndex = 5
        Me.btnRemoveGroup.Text = ">"
        Me.btnRemoveGroup.UseVisualStyleBackColor = True
        '
        'btnAddGroup
        '
        Me.btnAddGroup.CausesValidation = False
        Me.btnAddGroup.Location = New System.Drawing.Point(143, 43)
        Me.btnAddGroup.Name = "btnAddGroup"
        Me.btnAddGroup.Size = New System.Drawing.Size(26, 23)
        Me.btnAddGroup.TabIndex = 4
        Me.btnAddGroup.Text = "<"
        Me.btnAddGroup.UseVisualStyleBackColor = True
        '
        'lstGroupPool
        '
        Me.lstGroupPool.CausesValidation = False
        Me.lstGroupPool.FormattingEnabled = True
        Me.lstGroupPool.Location = New System.Drawing.Point(184, 26)
        Me.lstGroupPool.Name = "lstGroupPool"
        Me.lstGroupPool.Size = New System.Drawing.Size(120, 95)
        Me.lstGroupPool.TabIndex = 3
        '
        'lstAssignedGroups
        '
        Me.lstAssignedGroups.CausesValidation = False
        Me.lstAssignedGroups.FormattingEnabled = True
        Me.lstAssignedGroups.Location = New System.Drawing.Point(9, 26)
        Me.lstAssignedGroups.Name = "lstAssignedGroups"
        Me.lstAssignedGroups.Size = New System.Drawing.Size(120, 95)
        Me.lstAssignedGroups.TabIndex = 1
        '
        'btnChangePassword
        '
        Me.btnChangePassword.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnChangePassword.Location = New System.Drawing.Point(202, 202)
        Me.btnChangePassword.Name = "btnChangePassword"
        Me.btnChangePassword.Size = New System.Drawing.Size(75, 23)
        Me.btnChangePassword.TabIndex = 13
        Me.btnChangePassword.Text = "Password "
        Me.btnChangePassword.UseVisualStyleBackColor = True
        '
        'btnUnlockAccount
        '
        Me.btnUnlockAccount.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnUnlockAccount.Location = New System.Drawing.Point(108, 202)
        Me.btnUnlockAccount.Name = "btnUnlockAccount"
        Me.btnUnlockAccount.Size = New System.Drawing.Size(75, 23)
        Me.btnUnlockAccount.TabIndex = 12
        Me.btnUnlockAccount.Text = "Unlock"
        Me.btnUnlockAccount.UseVisualStyleBackColor = True
        '
        'txtLastName
        '
        Me.txtLastName.CausesValidation = False
        Me.txtLastName.Location = New System.Drawing.Point(185, 107)
        Me.txtLastName.MaxLength = 64
        Me.txtLastName.Name = "txtLastName"
        Me.txtLastName.Size = New System.Drawing.Size(123, 20)
        Me.txtLastName.TabIndex = 7
        '
        'lblLastName
        '
        Me.lblLastName.CausesValidation = False
        Me.lblLastName.Location = New System.Drawing.Point(76, 111)
        Me.lblLastName.Name = "lblLastName"
        Me.lblLastName.Size = New System.Drawing.Size(101, 13)
        Me.lblLastName.TabIndex = 6
        Me.lblLastName.Text = "Last Name:"
        Me.lblLastName.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'AppUserAddEdit
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(384, 412)
        Me.Controls.Add(Me.txtLastName)
        Me.Controls.Add(Me.lblLastName)
        Me.Controls.Add(Me.btnUnlockAccount)
        Me.Controls.Add(Me.btnChangePassword)
        Me.Controls.Add(Me.PnlGroup)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.cbIsActive)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.txtConfirmPassword)
        Me.Controls.Add(Me.lblConfirmPassword)
        Me.Controls.Add(Me.lblAppUserIDValue)
        Me.Controls.Add(Me.txtPassword)
        Me.Controls.Add(Me.txtFirstName)
        Me.Controls.Add(Me.lblPassword)
        Me.Controls.Add(Me.lblFirstName)
        Me.Controls.Add(Me.txtUserID)
        Me.Controls.Add(Me.lblUserID)
        Me.Controls.Add(Me.lblAppUserID)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.MaximumSize = New System.Drawing.Size(400, 450)
        Me.MinimizeBox = False
        Me.MinimumSize = New System.Drawing.Size(400, 450)
        Me.Name = "AppUserAddEdit"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).EndInit()
        Me.PnlGroup.ResumeLayout(False)
        Me.PnlGroup.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
   Friend WithEvents lblAppUserID As System.Windows.Forms.Label
   Friend WithEvents lblUserID As System.Windows.Forms.Label
   Friend WithEvents txtUserID As System.Windows.Forms.TextBox
   Friend WithEvents lblFirstName As System.Windows.Forms.Label
   Friend WithEvents lblPassword As System.Windows.Forms.Label
   Friend WithEvents txtFirstName As System.Windows.Forms.TextBox
   Friend WithEvents txtPassword As System.Windows.Forms.TextBox
   Friend WithEvents lblAppUserIDValue As System.Windows.Forms.Label
   Friend WithEvents lblConfirmPassword As System.Windows.Forms.Label
   Friend WithEvents txtConfirmPassword As System.Windows.Forms.TextBox
   Friend WithEvents btnSave As System.Windows.Forms.Button
   Friend WithEvents cbIsActive As System.Windows.Forms.CheckBox
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents ErrProvider As System.Windows.Forms.ErrorProvider
   Friend WithEvents PnlGroup As System.Windows.Forms.Panel
   Friend WithEvents lblGroupPool As System.Windows.Forms.Label
   Friend WithEvents lblAssignedGroups As System.Windows.Forms.Label
   Friend WithEvents btnRemoveGroup As System.Windows.Forms.Button
   Friend WithEvents lstGroupPool As System.Windows.Forms.ListBox
   Friend WithEvents lstAssignedGroups As System.Windows.Forms.ListBox
   Friend WithEvents btnAddGroup As System.Windows.Forms.Button
   Friend WithEvents btnChangePassword As System.Windows.Forms.Button
   Friend WithEvents btnUnlockAccount As System.Windows.Forms.Button
   Friend WithEvents txtLastName As System.Windows.Forms.TextBox
   Friend WithEvents lblLastName As System.Windows.Forms.Label
End Class
