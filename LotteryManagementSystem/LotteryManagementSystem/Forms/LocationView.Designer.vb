<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class LocationView
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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(LocationView))
      Me.dgvLocations = New System.Windows.Forms.DataGridView()
      Me.lblGridHeader = New System.Windows.Forms.Label()
      Me.btnRefresh = New System.Windows.Forms.Button()
      Me.btnClose = New System.Windows.Forms.Button()
      Me.btnEdit = New System.Windows.Forms.Button()
      CType(Me.dgvLocations, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'dgvLocations
      '
      Me.dgvLocations.AllowUserToAddRows = False
      Me.dgvLocations.AllowUserToDeleteRows = False
      DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle1.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvLocations.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
      Me.dgvLocations.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.dgvLocations.CausesValidation = False
      DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvLocations.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
      Me.dgvLocations.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      Me.dgvLocations.Location = New System.Drawing.Point(12, 33)
      Me.dgvLocations.MultiSelect = False
      Me.dgvLocations.Name = "dgvLocations"
      Me.dgvLocations.ReadOnly = True
      Me.dgvLocations.RowHeadersWidth = 32
      Me.dgvLocations.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
      Me.dgvLocations.Size = New System.Drawing.Size(660, 173)
      Me.dgvLocations.TabIndex = 2
      '
      'lblGridHeader
      '
      Me.lblGridHeader.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblGridHeader.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblGridHeader.CausesValidation = False
      Me.lblGridHeader.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblGridHeader.ForeColor = System.Drawing.Color.White
      Me.lblGridHeader.Location = New System.Drawing.Point(12, 9)
      Me.lblGridHeader.Name = "lblGridHeader"
      Me.lblGridHeader.Size = New System.Drawing.Size(660, 24)
      Me.lblGridHeader.TabIndex = 5
      Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'btnRefresh
      '
      Me.btnRefresh.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnRefresh.CausesValidation = False
      Me.btnRefresh.Location = New System.Drawing.Point(313, 221)
      Me.btnRefresh.Name = "btnRefresh"
      Me.btnRefresh.Size = New System.Drawing.Size(59, 23)
      Me.btnRefresh.TabIndex = 9
      Me.btnRefresh.Text = "Refresh"
      Me.btnRefresh.UseVisualStyleBackColor = True
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(392, 221)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(59, 23)
      Me.btnClose.TabIndex = 8
      Me.btnClose.Text = "Close"
      Me.btnClose.UseVisualStyleBackColor = True
      '
      'btnEdit
      '
      Me.btnEdit.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnEdit.CausesValidation = False
      Me.btnEdit.Location = New System.Drawing.Point(234, 221)
      Me.btnEdit.Name = "btnEdit"
      Me.btnEdit.Size = New System.Drawing.Size(59, 23)
      Me.btnEdit.TabIndex = 7
      Me.btnEdit.Text = "Edit"
      Me.btnEdit.UseVisualStyleBackColor = True
      '
      'LocationView
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(684, 262)
      Me.Controls.Add(Me.btnRefresh)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnEdit)
      Me.Controls.Add(Me.lblGridHeader)
      Me.Controls.Add(Me.dgvLocations)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MinimumSize = New System.Drawing.Size(400, 200)
      Me.Name = "LocationView"
      Me.Text = "Locations"
      CType(Me.dgvLocations, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents dgvLocations As System.Windows.Forms.DataGridView
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
   Friend WithEvents btnRefresh As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents btnEdit As System.Windows.Forms.Button
End Class
