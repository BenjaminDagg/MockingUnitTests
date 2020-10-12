<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FlexNumbers
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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(FlexNumbers))
      Me.btnSave = New System.Windows.Forms.Button()
      Me.btnClose = New System.Windows.Forms.Button()
      Me.lblRevenueDescription = New System.Windows.Forms.Label()
      Me.lblFlexNumber = New System.Windows.Forms.Label()
      Me.txtFlexNumber = New System.Windows.Forms.TextBox()
      Me.dgvRevenueType = New System.Windows.Forms.DataGridView()
      Me.txtRevenueTypeDescription = New System.Windows.Forms.TextBox()
      Me.lblGridHeader = New System.Windows.Forms.Label()
      CType(Me.dgvRevenueType, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'btnSave
      '
      Me.btnSave.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnSave.CausesValidation = False
      Me.btnSave.Enabled = False
      Me.btnSave.Location = New System.Drawing.Point(121, 327)
      Me.btnSave.Name = "btnSave"
      Me.btnSave.Size = New System.Drawing.Size(75, 23)
      Me.btnSave.TabIndex = 8
      Me.btnSave.Text = "Save"
      Me.btnSave.UseVisualStyleBackColor = True
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(218, 327)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(75, 23)
      Me.btnClose.TabIndex = 9
      Me.btnClose.Text = "Close"
      Me.btnClose.UseVisualStyleBackColor = True
      '
      'lblRevenueDescription
      '
      Me.lblRevenueDescription.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.lblRevenueDescription.AutoSize = True
      Me.lblRevenueDescription.Location = New System.Drawing.Point(57, 251)
      Me.lblRevenueDescription.Name = "lblRevenueDescription"
      Me.lblRevenueDescription.Size = New System.Drawing.Size(137, 13)
      Me.lblRevenueDescription.TabIndex = 4
      Me.lblRevenueDescription.Text = "Revenue Type Description:"
      '
      'lblFlexNumber
      '
      Me.lblFlexNumber.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.lblFlexNumber.AutoSize = True
      Me.lblFlexNumber.Location = New System.Drawing.Point(125, 282)
      Me.lblFlexNumber.Name = "lblFlexNumber"
      Me.lblFlexNumber.Size = New System.Drawing.Size(69, 13)
      Me.lblFlexNumber.TabIndex = 6
      Me.lblFlexNumber.Text = "Flex Number:"
      '
      'txtFlexNumber
      '
      Me.txtFlexNumber.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.txtFlexNumber.CausesValidation = False
      Me.txtFlexNumber.Location = New System.Drawing.Point(200, 278)
      Me.txtFlexNumber.MaxLength = 4
      Me.txtFlexNumber.Name = "txtFlexNumber"
      Me.txtFlexNumber.Size = New System.Drawing.Size(157, 20)
      Me.txtFlexNumber.TabIndex = 7
      '
      'dgvRevenueType
      '
      Me.dgvRevenueType.AllowUserToAddRows = False
      Me.dgvRevenueType.AllowUserToDeleteRows = False
      DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle1.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvRevenueType.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
      Me.dgvRevenueType.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.dgvRevenueType.CausesValidation = False
      Me.dgvRevenueType.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      Me.dgvRevenueType.Location = New System.Drawing.Point(13, 37)
      Me.dgvRevenueType.MultiSelect = False
      Me.dgvRevenueType.Name = "dgvRevenueType"
      Me.dgvRevenueType.ReadOnly = True
      Me.dgvRevenueType.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
      Me.dgvRevenueType.Size = New System.Drawing.Size(389, 184)
      Me.dgvRevenueType.TabIndex = 1
      '
      'txtRevenueTypeDescription
      '
      Me.txtRevenueTypeDescription.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.txtRevenueTypeDescription.CausesValidation = False
      Me.txtRevenueTypeDescription.Location = New System.Drawing.Point(200, 247)
      Me.txtRevenueTypeDescription.MaxLength = 4
      Me.txtRevenueTypeDescription.Name = "txtRevenueTypeDescription"
      Me.txtRevenueTypeDescription.ReadOnly = True
      Me.txtRevenueTypeDescription.Size = New System.Drawing.Size(157, 20)
      Me.txtRevenueTypeDescription.TabIndex = 5
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
      Me.lblGridHeader.Size = New System.Drawing.Size(389, 28)
      Me.lblGridHeader.TabIndex = 0
      Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'FlexNumbers
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(414, 362)
      Me.Controls.Add(Me.lblGridHeader)
      Me.Controls.Add(Me.txtRevenueTypeDescription)
      Me.Controls.Add(Me.dgvRevenueType)
      Me.Controls.Add(Me.txtFlexNumber)
      Me.Controls.Add(Me.lblFlexNumber)
      Me.Controls.Add(Me.lblRevenueDescription)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnSave)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MinimumSize = New System.Drawing.Size(348, 272)
      Me.Name = "FlexNumbers"
      Me.Text = "Flex Numbers"
      CType(Me.dgvRevenueType, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents btnSave As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents lblRevenueDescription As System.Windows.Forms.Label
   Friend WithEvents lblFlexNumber As System.Windows.Forms.Label
   Friend WithEvents txtFlexNumber As System.Windows.Forms.TextBox
   Friend WithEvents dgvRevenueType As System.Windows.Forms.DataGridView
   Friend WithEvents txtRevenueTypeDescription As System.Windows.Forms.TextBox
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
End Class
