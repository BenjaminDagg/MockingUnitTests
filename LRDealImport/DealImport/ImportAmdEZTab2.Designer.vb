<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ImportAmdEZTab2
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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ImportAmdEZTab2))
      Me.lblGridHeader = New System.Windows.Forms.Label
      Me.dgvGameTypes = New System.Windows.Forms.DataGridView
      Me.btnImport = New System.Windows.Forms.Button
      Me.btnCancel = New System.Windows.Forms.Button
      Me.sbrStatus = New System.Windows.Forms.StatusBar
      Me.txtRevSharePercent = New System.Windows.Forms.TextBox
      Me.lblRevSharePercent = New System.Windows.Forms.Label
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
      Me.lblGridHeader.Location = New System.Drawing.Point(7, 10)
      Me.lblGridHeader.Name = "lblGridHeader"
      Me.lblGridHeader.Size = New System.Drawing.Size(679, 23)
      Me.lblGridHeader.TabIndex = 0
      Me.lblGridHeader.Text = "Game Type Import Set"
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
      Me.dgvGameTypes.CausesValidation = False
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
      Me.dgvGameTypes.Location = New System.Drawing.Point(7, 32)
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
      Me.dgvGameTypes.Size = New System.Drawing.Size(679, 225)
      Me.dgvGameTypes.TabIndex = 1
      '
      'btnImport
      '
      Me.btnImport.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnImport.CausesValidation = False
      Me.btnImport.Location = New System.Drawing.Point(264, 272)
      Me.btnImport.Name = "btnImport"
      Me.btnImport.Size = New System.Drawing.Size(63, 23)
      Me.btnImport.TabIndex = 4
      Me.btnImport.Text = "Import"
      Me.btnImport.UseVisualStyleBackColor = True
      '
      'btnCancel
      '
      Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.Location = New System.Drawing.Point(366, 272)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(63, 23)
      Me.btnCancel.TabIndex = 5
      Me.btnCancel.Text = "Cancel"
      Me.btnCancel.UseVisualStyleBackColor = True
      '
      'sbrStatus
      '
      Me.sbrStatus.CausesValidation = False
      Me.sbrStatus.Location = New System.Drawing.Point(0, 308)
      Me.sbrStatus.Name = "sbrStatus"
      Me.sbrStatus.Size = New System.Drawing.Size(692, 18)
      Me.sbrStatus.TabIndex = 6
      '
      'txtRevSharePercent
      '
      Me.txtRevSharePercent.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
      Me.txtRevSharePercent.Location = New System.Drawing.Point(138, 273)
      Me.txtRevSharePercent.Name = "txtRevSharePercent"
      Me.txtRevSharePercent.ReadOnly = True
      Me.txtRevSharePercent.Size = New System.Drawing.Size(37, 20)
      Me.txtRevSharePercent.TabIndex = 3
      '
      'lblRevSharePercent
      '
      Me.lblRevSharePercent.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
      Me.lblRevSharePercent.Location = New System.Drawing.Point(4, 274)
      Me.lblRevSharePercent.Name = "lblRevSharePercent"
      Me.lblRevSharePercent.Size = New System.Drawing.Size(132, 19)
      Me.lblRevSharePercent.TabIndex = 2
      Me.lblRevSharePercent.Text = "Revenue Share Percent:"
      Me.lblRevSharePercent.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'ImportAmdEZTab2
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(692, 326)
      Me.Controls.Add(Me.txtRevSharePercent)
      Me.Controls.Add(Me.lblRevSharePercent)
      Me.Controls.Add(Me.sbrStatus)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnImport)
      Me.Controls.Add(Me.dgvGameTypes)
      Me.Controls.Add(Me.lblGridHeader)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "ImportAmdEZTab2"
      Me.Text = "Import Approved EZTab 2.0 and SkilTab Deals"
      CType(Me.dgvGameTypes, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
   Friend WithEvents dgvGameTypes As System.Windows.Forms.DataGridView
   Friend WithEvents btnImport As System.Windows.Forms.Button
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents sbrStatus As System.Windows.Forms.StatusBar
   Friend WithEvents txtRevSharePercent As System.Windows.Forms.TextBox
   Friend WithEvents lblRevSharePercent As System.Windows.Forms.Label
End Class
