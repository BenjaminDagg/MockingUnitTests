<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GameSettingSelect
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
      Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle3 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle4 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(GameSettingSelect))
      Me.lblGridHeader = New System.Windows.Forms.Label
      Me.dgvGameTypes = New System.Windows.Forms.DataGridView
      Me.btnCancel = New System.Windows.Forms.Button
      Me.btnContinue = New System.Windows.Forms.Button
      CType(Me.dgvGameTypes, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'lblGridHeader
      '
      Me.lblGridHeader.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblGridHeader.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblGridHeader.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
      Me.lblGridHeader.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblGridHeader.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
      Me.lblGridHeader.Location = New System.Drawing.Point(7, 22)
      Me.lblGridHeader.Name = "lblGridHeader"
      Me.lblGridHeader.Size = New System.Drawing.Size(839, 23)
      Me.lblGridHeader.TabIndex = 2
      Me.lblGridHeader.Text = "Game Type List"
      Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'dgvGameTypes
      '
      Me.dgvGameTypes.AllowUserToAddRows = False
      Me.dgvGameTypes.AllowUserToDeleteRows = False
      DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle1.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvGameTypes.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
      Me.dgvGameTypes.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvGameTypes.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
      Me.dgvGameTypes.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      DataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window
      DataGridViewCellStyle3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.ControlText
      DataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvGameTypes.DefaultCellStyle = DataGridViewCellStyle3
      Me.dgvGameTypes.Location = New System.Drawing.Point(7, 44)
      Me.dgvGameTypes.MultiSelect = False
      Me.dgvGameTypes.Name = "dgvGameTypes"
      Me.dgvGameTypes.ReadOnly = True
      DataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
      Me.dgvGameTypes.RowHeadersDefaultCellStyle = DataGridViewCellStyle4
      Me.dgvGameTypes.RowHeadersWidth = 32
      Me.dgvGameTypes.RowTemplate.Height = 18
      Me.dgvGameTypes.RowTemplate.ReadOnly = True
      Me.dgvGameTypes.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
      Me.dgvGameTypes.Size = New System.Drawing.Size(839, 318)
      Me.dgvGameTypes.TabIndex = 3
      '
      'btnCancel
      '
      Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Location = New System.Drawing.Point(444, 379)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(60, 23)
      Me.btnCancel.TabIndex = 8
      Me.btnCancel.Text = "&Cancel"
      '
      'btnContinue
      '
      Me.btnContinue.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnContinue.CausesValidation = False
      Me.btnContinue.Location = New System.Drawing.Point(348, 379)
      Me.btnContinue.Name = "btnContinue"
      Me.btnContinue.Size = New System.Drawing.Size(60, 23)
      Me.btnContinue.TabIndex = 7
      Me.btnContinue.Text = "&Continue"
      '
      'GameSettingSelect
      '
      Me.AcceptButton = Me.btnContinue
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.CancelButton = Me.btnCancel
      Me.ClientSize = New System.Drawing.Size(852, 414)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnContinue)
      Me.Controls.Add(Me.dgvGameTypes)
      Me.Controls.Add(Me.lblGridHeader)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "GameSettingSelect"
      Me.Text = "Game Setting - Select a Game Type"
      CType(Me.dgvGameTypes, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
   Friend WithEvents dgvGameTypes As System.Windows.Forms.DataGridView
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnContinue As System.Windows.Forms.Button
End Class
