<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AppUserView
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
      Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
      Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(AppUserView))
      Me.dgvAppUser = New System.Windows.Forms.DataGridView()
      Me.btnAdd = New System.Windows.Forms.Button()
      Me.btnEdit = New System.Windows.Forms.Button()
      Me.btnClose = New System.Windows.Forms.Button()
      Me.lblGridHeader = New System.Windows.Forms.Label()
      Me.btnRefresh = New System.Windows.Forms.Button()
      CType(Me.dgvAppUser, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'dgvAppUser
      '
      Me.dgvAppUser.AllowUserToAddRows = False
      Me.dgvAppUser.AllowUserToDeleteRows = False
      DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle1.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvAppUser.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
      Me.dgvAppUser.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.dgvAppUser.CausesValidation = False
      DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvAppUser.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
      Me.dgvAppUser.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      Me.dgvAppUser.Location = New System.Drawing.Point(13, 34)
      Me.dgvAppUser.MultiSelect = False
      Me.dgvAppUser.Name = "dgvAppUser"
      Me.dgvAppUser.ReadOnly = True
      Me.dgvAppUser.RowHeadersWidth = 32
      Me.dgvAppUser.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
      Me.dgvAppUser.Size = New System.Drawing.Size(559, 178)
      Me.dgvAppUser.TabIndex = 1
      '
      'btnAdd
      '
      Me.btnAdd.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnAdd.CausesValidation = False
      Me.btnAdd.Location = New System.Drawing.Point(114, 227)
      Me.btnAdd.Name = "btnAdd"
      Me.btnAdd.Size = New System.Drawing.Size(75, 23)
      Me.btnAdd.TabIndex = 1
      Me.btnAdd.Text = "Add"
      Me.btnAdd.UseVisualStyleBackColor = True
      '
      'btnEdit
      '
      Me.btnEdit.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnEdit.CausesValidation = False
      Me.btnEdit.Location = New System.Drawing.Point(208, 227)
      Me.btnEdit.Name = "btnEdit"
      Me.btnEdit.Size = New System.Drawing.Size(75, 23)
      Me.btnEdit.TabIndex = 2
      Me.btnEdit.Text = "Edit"
      Me.btnEdit.UseVisualStyleBackColor = True
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(396, 227)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(75, 23)
      Me.btnClose.TabIndex = 3
      Me.btnClose.Text = "Close"
      Me.btnClose.UseVisualStyleBackColor = True
      '
      'lblGridHeader
      '
      Me.lblGridHeader.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblGridHeader.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblGridHeader.CausesValidation = False
      Me.lblGridHeader.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblGridHeader.ForeColor = System.Drawing.Color.White
      Me.lblGridHeader.Location = New System.Drawing.Point(13, 9)
      Me.lblGridHeader.Name = "lblGridHeader"
      Me.lblGridHeader.Size = New System.Drawing.Size(559, 25)
      Me.lblGridHeader.TabIndex = 4
      Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'btnRefresh
      '
      Me.btnRefresh.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnRefresh.CausesValidation = False
      Me.btnRefresh.Location = New System.Drawing.Point(302, 227)
      Me.btnRefresh.Name = "btnRefresh"
      Me.btnRefresh.Size = New System.Drawing.Size(75, 23)
      Me.btnRefresh.TabIndex = 5
      Me.btnRefresh.Text = "Refresh"
      Me.btnRefresh.UseVisualStyleBackColor = True
      '
      'AppUserView
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(584, 262)
      Me.Controls.Add(Me.btnRefresh)
      Me.Controls.Add(Me.lblGridHeader)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnEdit)
      Me.Controls.Add(Me.btnAdd)
      Me.Controls.Add(Me.dgvAppUser)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MinimumSize = New System.Drawing.Size(400, 200)
      Me.Name = "AppUserView"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Application Users"
      CType(Me.dgvAppUser, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents dgvAppUser As System.Windows.Forms.DataGridView
   Friend WithEvents btnAdd As System.Windows.Forms.Button
   Friend WithEvents btnEdit As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
   Friend WithEvents btnRefresh As System.Windows.Forms.Button
End Class
