<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class DealRollScan
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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(DealRollScan))
      Me.txtScanText = New System.Windows.Forms.TextBox
      Me.lblScanText = New System.Windows.Forms.Label
      Me.lblGridHeader = New System.Windows.Forms.Label
      Me.dgvDealBoxes = New System.Windows.Forms.DataGridView
      Me.lblScanResult = New System.Windows.Forms.Label
      Me.btnImport = New System.Windows.Forms.Button
      Me.btnCancel = New System.Windows.Forms.Button
      CType(Me.dgvDealBoxes, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'txtScanText
      '
      Me.txtScanText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtScanText.Location = New System.Drawing.Point(115, 54)
      Me.txtScanText.Name = "txtScanText"
      Me.txtScanText.Size = New System.Drawing.Size(344, 20)
      Me.txtScanText.TabIndex = 1
      '
      'lblScanText
      '
      Me.lblScanText.Location = New System.Drawing.Point(30, 58)
      Me.lblScanText.Name = "lblScanText"
      Me.lblScanText.Size = New System.Drawing.Size(84, 13)
      Me.lblScanText.TabIndex = 0
      Me.lblScanText.Text = "Scanned Text:"
      Me.lblScanText.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblGridHeader
      '
      Me.lblGridHeader.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblGridHeader.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblGridHeader.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
      Me.lblGridHeader.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblGridHeader.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
      Me.lblGridHeader.Location = New System.Drawing.Point(115, 91)
      Me.lblGridHeader.Name = "lblGridHeader"
      Me.lblGridHeader.Size = New System.Drawing.Size(344, 23)
      Me.lblGridHeader.TabIndex = 9
      Me.lblGridHeader.Text = "Deal Boxes"
      Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'dgvDealBoxes
      '
      Me.dgvDealBoxes.AllowUserToAddRows = False
      Me.dgvDealBoxes.AllowUserToDeleteRows = False
      DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle1.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvDealBoxes.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
      Me.dgvDealBoxes.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvDealBoxes.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
      Me.dgvDealBoxes.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      DataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window
      DataGridViewCellStyle3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.ControlText
      DataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvDealBoxes.DefaultCellStyle = DataGridViewCellStyle3
      Me.dgvDealBoxes.Location = New System.Drawing.Point(115, 113)
      Me.dgvDealBoxes.Name = "dgvDealBoxes"
      Me.dgvDealBoxes.ReadOnly = True
      DataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
      Me.dgvDealBoxes.RowHeadersDefaultCellStyle = DataGridViewCellStyle4
      Me.dgvDealBoxes.RowHeadersWidth = 32
      Me.dgvDealBoxes.RowTemplate.Height = 18
      Me.dgvDealBoxes.RowTemplate.ReadOnly = True
      Me.dgvDealBoxes.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
      Me.dgvDealBoxes.Size = New System.Drawing.Size(344, 252)
      Me.dgvDealBoxes.TabIndex = 10
      '
      'lblScanResult
      '
      Me.lblScanResult.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblScanResult.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
      Me.lblScanResult.Location = New System.Drawing.Point(112, 386)
      Me.lblScanResult.Name = "lblScanResult"
      Me.lblScanResult.Size = New System.Drawing.Size(347, 50)
      Me.lblScanResult.TabIndex = 11
      '
      'btnImport
      '
      Me.btnImport.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnImport.CausesValidation = False
      Me.btnImport.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnImport.Enabled = False
      Me.btnImport.Location = New System.Drawing.Point(202, 452)
      Me.btnImport.Name = "btnImport"
      Me.btnImport.Size = New System.Drawing.Size(57, 23)
      Me.btnImport.TabIndex = 12
      Me.btnImport.Text = "&Import"
      Me.btnImport.UseVisualStyleBackColor = True
      '
      'btnCancel
      '
      Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Location = New System.Drawing.Point(297, 452)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(57, 23)
      Me.btnCancel.TabIndex = 13
      Me.btnCancel.Text = "&Cancel"
      Me.btnCancel.UseVisualStyleBackColor = True
      '
      'DealRollScan
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.CancelButton = Me.btnCancel
      Me.ClientSize = New System.Drawing.Size(557, 488)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnImport)
      Me.Controls.Add(Me.lblScanResult)
      Me.Controls.Add(Me.dgvDealBoxes)
      Me.Controls.Add(Me.lblGridHeader)
      Me.Controls.Add(Me.txtScanText)
      Me.Controls.Add(Me.lblScanText)
      Me.DataBindings.Add(New System.Windows.Forms.Binding("Location", Global.LRDealImport.My.MySettings.Default, "DRSLocation", True, System.Windows.Forms.DataSourceUpdateMode.OnPropertyChanged))
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Location = Global.LRDealImport.My.MySettings.Default.DRSLocation
      Me.Name = "DealRollScan"
      Me.Text = "Deal Roll Scan"
      CType(Me.dgvDealBoxes, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents txtScanText As System.Windows.Forms.TextBox
   Friend WithEvents lblScanText As System.Windows.Forms.Label
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
   Friend WithEvents dgvDealBoxes As System.Windows.Forms.DataGridView
   Friend WithEvents lblScanResult As System.Windows.Forms.Label
   Friend WithEvents btnImport As System.Windows.Forms.Button
   Friend WithEvents btnCancel As System.Windows.Forms.Button
End Class
