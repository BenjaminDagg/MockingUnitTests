<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AddBank
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
      Me.components = New System.ComponentModel.Container
      Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle3 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle4 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(AddBank))
      Me.btnCancel = New System.Windows.Forms.Button
      Me.btnAdd = New System.Windows.Forms.Button
      Me.lblGameTypeCode = New System.Windows.Forms.Label
      Me.txtGameTypeCode = New System.Windows.Forms.TextBox
      Me.lblBankNo = New System.Windows.Forms.Label
      Me.txtBankNo = New System.Windows.Forms.TextBox
      Me.lblBankDescription = New System.Windows.Forms.Label
      Me.txtBankDesc = New System.Windows.Forms.TextBox
      Me.lblProductLine = New System.Windows.Forms.Label
      Me.cboProductLines = New System.Windows.Forms.ComboBox
      Me.lblLockupAmount = New System.Windows.Forms.Label
      Me.txtLockupAmount = New System.Windows.Forms.TextBox
      Me.txtEntryTicketFactor = New System.Windows.Forms.TextBox
      Me.lblEntryTicketFactor = New System.Windows.Forms.Label
      Me.txtEntryTicketAmount = New System.Windows.Forms.TextBox
      Me.lblEntryTicketAmount = New System.Windows.Forms.Label
      Me.lblDBALockupAmount = New System.Windows.Forms.Label
      Me.txtDBALockupAmount = New System.Windows.Forms.TextBox
      Me.ttProvider = New System.Windows.Forms.ToolTip(Me.components)
      Me.dgvBanks = New System.Windows.Forms.DataGridView
      Me.lblGridHeader = New System.Windows.Forms.Label
      CType(Me.dgvBanks, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'btnCancel
      '
      Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.Location = New System.Drawing.Point(313, 301)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(63, 23)
      Me.btnCancel.TabIndex = 17
      Me.btnCancel.Text = "Cancel"
      Me.btnCancel.UseVisualStyleBackColor = True
      '
      'btnAdd
      '
      Me.btnAdd.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnAdd.CausesValidation = False
      Me.btnAdd.Location = New System.Drawing.Point(211, 301)
      Me.btnAdd.Name = "btnAdd"
      Me.btnAdd.Size = New System.Drawing.Size(63, 23)
      Me.btnAdd.TabIndex = 16
      Me.btnAdd.Text = "Add"
      Me.btnAdd.UseVisualStyleBackColor = True
      '
      'lblGameTypeCode
      '
      Me.lblGameTypeCode.CausesValidation = False
      Me.lblGameTypeCode.Location = New System.Drawing.Point(6, 28)
      Me.lblGameTypeCode.Name = "lblGameTypeCode"
      Me.lblGameTypeCode.Size = New System.Drawing.Size(116, 18)
      Me.lblGameTypeCode.TabIndex = 0
      Me.lblGameTypeCode.Text = "Game Type Code:"
      Me.lblGameTypeCode.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtGameTypeCode
      '
      Me.txtGameTypeCode.BackColor = System.Drawing.SystemColors.Window
      Me.txtGameTypeCode.CausesValidation = False
      Me.txtGameTypeCode.Location = New System.Drawing.Point(122, 28)
      Me.txtGameTypeCode.Name = "txtGameTypeCode"
      Me.txtGameTypeCode.ReadOnly = True
      Me.txtGameTypeCode.Size = New System.Drawing.Size(39, 20)
      Me.txtGameTypeCode.TabIndex = 1
      Me.txtGameTypeCode.TabStop = False
      Me.ttProvider.SetToolTip(Me.txtGameTypeCode, "Game Type Code (read only)")
      '
      'lblBankNo
      '
      Me.lblBankNo.CausesValidation = False
      Me.lblBankNo.Location = New System.Drawing.Point(6, 56)
      Me.lblBankNo.Name = "lblBankNo"
      Me.lblBankNo.Size = New System.Drawing.Size(116, 18)
      Me.lblBankNo.TabIndex = 2
      Me.lblBankNo.Text = "Bank Number:"
      Me.lblBankNo.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtBankNo
      '
      Me.txtBankNo.CausesValidation = False
      Me.txtBankNo.Location = New System.Drawing.Point(122, 55)
      Me.txtBankNo.MaxLength = 5
      Me.txtBankNo.Name = "txtBankNo"
      Me.txtBankNo.Size = New System.Drawing.Size(39, 20)
      Me.txtBankNo.TabIndex = 3
      Me.ttProvider.SetToolTip(Me.txtBankNo, "Enter the new Bank Number.")
      '
      'lblBankDescription
      '
      Me.lblBankDescription.CausesValidation = False
      Me.lblBankDescription.Location = New System.Drawing.Point(6, 83)
      Me.lblBankDescription.Name = "lblBankDescription"
      Me.lblBankDescription.Size = New System.Drawing.Size(116, 18)
      Me.lblBankDescription.TabIndex = 4
      Me.lblBankDescription.Text = "Bank Description:"
      Me.lblBankDescription.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtBankDesc
      '
      Me.txtBankDesc.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtBankDesc.CausesValidation = False
      Me.txtBankDesc.Location = New System.Drawing.Point(122, 82)
      Me.txtBankDesc.MaxLength = 128
      Me.txtBankDesc.Name = "txtBankDesc"
      Me.txtBankDesc.Size = New System.Drawing.Size(439, 20)
      Me.txtBankDesc.TabIndex = 5
      Me.ttProvider.SetToolTip(Me.txtBankDesc, "Enter the Bank Description.")
      '
      'lblProductLine
      '
      Me.lblProductLine.CausesValidation = False
      Me.lblProductLine.Location = New System.Drawing.Point(6, 110)
      Me.lblProductLine.Name = "lblProductLine"
      Me.lblProductLine.Size = New System.Drawing.Size(116, 18)
      Me.lblProductLine.TabIndex = 6
      Me.lblProductLine.Text = "Product Line:"
      Me.lblProductLine.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'cboProductLines
      '
      Me.cboProductLines.CausesValidation = False
      Me.cboProductLines.FormattingEnabled = True
      Me.cboProductLines.Location = New System.Drawing.Point(122, 109)
      Me.cboProductLines.Name = "cboProductLines"
      Me.cboProductLines.Size = New System.Drawing.Size(232, 21)
      Me.cboProductLines.TabIndex = 7
      Me.ttProvider.SetToolTip(Me.cboProductLines, "Select the proper Product Line.")
      '
      'lblLockupAmount
      '
      Me.lblLockupAmount.CausesValidation = False
      Me.lblLockupAmount.Location = New System.Drawing.Point(6, 138)
      Me.lblLockupAmount.Name = "lblLockupAmount"
      Me.lblLockupAmount.Size = New System.Drawing.Size(116, 18)
      Me.lblLockupAmount.TabIndex = 8
      Me.lblLockupAmount.Text = "Lockup Amount:"
      Me.lblLockupAmount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtLockupAmount
      '
      Me.txtLockupAmount.CausesValidation = False
      Me.txtLockupAmount.Location = New System.Drawing.Point(122, 137)
      Me.txtLockupAmount.MaxLength = 9
      Me.txtLockupAmount.Name = "txtLockupAmount"
      Me.txtLockupAmount.Size = New System.Drawing.Size(54, 20)
      Me.txtLockupAmount.TabIndex = 9
      Me.ttProvider.SetToolTip(Me.txtLockupAmount, "Enter the Machine Lockup amount in dollars, use only numbers and decimal point.")
      '
      'txtEntryTicketFactor
      '
      Me.txtEntryTicketFactor.CausesValidation = False
      Me.txtEntryTicketFactor.Location = New System.Drawing.Point(122, 164)
      Me.txtEntryTicketFactor.MaxLength = 9
      Me.txtEntryTicketFactor.Name = "txtEntryTicketFactor"
      Me.txtEntryTicketFactor.Size = New System.Drawing.Size(39, 20)
      Me.txtEntryTicketFactor.TabIndex = 11
      Me.ttProvider.SetToolTip(Me.txtEntryTicketFactor, "Enter the Entry Ticket Factor (used to determine the number of plays between crea" & _
              "tion of promotional entry tickets)")
      '
      'lblEntryTicketFactor
      '
      Me.lblEntryTicketFactor.CausesValidation = False
      Me.lblEntryTicketFactor.Location = New System.Drawing.Point(6, 165)
      Me.lblEntryTicketFactor.Name = "lblEntryTicketFactor"
      Me.lblEntryTicketFactor.Size = New System.Drawing.Size(116, 18)
      Me.lblEntryTicketFactor.TabIndex = 10
      Me.lblEntryTicketFactor.Text = "Entry Ticket Factor:"
      Me.lblEntryTicketFactor.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtEntryTicketAmount
      '
      Me.txtEntryTicketAmount.CausesValidation = False
      Me.txtEntryTicketAmount.Location = New System.Drawing.Point(122, 191)
      Me.txtEntryTicketAmount.MaxLength = 9
      Me.txtEntryTicketAmount.Name = "txtEntryTicketAmount"
      Me.txtEntryTicketAmount.Size = New System.Drawing.Size(54, 20)
      Me.txtEntryTicketAmount.TabIndex = 13
      Me.ttProvider.SetToolTip(Me.txtEntryTicketAmount, "If printing promo tickets, print if win amount is this amount or more. 0 to disab" & _
              "le.")
      '
      'lblEntryTicketAmount
      '
      Me.lblEntryTicketAmount.CausesValidation = False
      Me.lblEntryTicketAmount.Location = New System.Drawing.Point(6, 192)
      Me.lblEntryTicketAmount.Name = "lblEntryTicketAmount"
      Me.lblEntryTicketAmount.Size = New System.Drawing.Size(116, 18)
      Me.lblEntryTicketAmount.TabIndex = 12
      Me.lblEntryTicketAmount.Text = "Entry Ticket Amount:"
      Me.lblEntryTicketAmount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblDBALockupAmount
      '
      Me.lblDBALockupAmount.CausesValidation = False
      Me.lblDBALockupAmount.Location = New System.Drawing.Point(6, 219)
      Me.lblDBALockupAmount.Name = "lblDBALockupAmount"
      Me.lblDBALockupAmount.Size = New System.Drawing.Size(116, 18)
      Me.lblDBALockupAmount.TabIndex = 14
      Me.lblDBALockupAmount.Text = "DBA Lockup Amount:"
      Me.lblDBALockupAmount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtDBALockupAmount
      '
      Me.txtDBALockupAmount.CausesValidation = False
      Me.txtDBALockupAmount.Location = New System.Drawing.Point(122, 218)
      Me.txtDBALockupAmount.MaxLength = 9
      Me.txtDBALockupAmount.Name = "txtDBALockupAmount"
      Me.txtDBALockupAmount.Size = New System.Drawing.Size(54, 20)
      Me.txtDBALockupAmount.TabIndex = 15
      Me.ttProvider.SetToolTip(Me.txtDBALockupAmount, "Enter the DBA Lockup amount in dollars, use only numbers and decimal point. DBA w" & _
              "ill not function when machine balance is greater than this amount or enter 0 to " & _
              "turn off.")
      '
      'dgvBanks
      '
      Me.dgvBanks.AllowUserToAddRows = False
      Me.dgvBanks.AllowUserToDeleteRows = False
      DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle1.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvBanks.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
      Me.dgvBanks.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.dgvBanks.CausesValidation = False
      DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvBanks.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
      Me.dgvBanks.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      DataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window
      DataGridViewCellStyle3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.ControlText
      DataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvBanks.DefaultCellStyle = DataGridViewCellStyle3
      Me.dgvBanks.Location = New System.Drawing.Point(223, 160)
      Me.dgvBanks.Name = "dgvBanks"
      Me.dgvBanks.ReadOnly = True
      DataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
      Me.dgvBanks.RowHeadersDefaultCellStyle = DataGridViewCellStyle4
      Me.dgvBanks.RowHeadersWidth = 32
      Me.dgvBanks.RowTemplate.Height = 18
      Me.dgvBanks.RowTemplate.ReadOnly = True
      Me.dgvBanks.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
      Me.dgvBanks.Size = New System.Drawing.Size(338, 115)
      Me.dgvBanks.TabIndex = 18
      '
      'lblGridHeader
      '
      Me.lblGridHeader.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblGridHeader.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblGridHeader.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
      Me.lblGridHeader.CausesValidation = False
      Me.lblGridHeader.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblGridHeader.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
      Me.lblGridHeader.Location = New System.Drawing.Point(223, 138)
      Me.lblGridHeader.Name = "lblGridHeader"
      Me.lblGridHeader.Size = New System.Drawing.Size(338, 23)
      Me.lblGridHeader.TabIndex = 19
      Me.lblGridHeader.Text = "Existing Banks"
      Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'AddBank
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(586, 336)
      Me.Controls.Add(Me.lblGridHeader)
      Me.Controls.Add(Me.dgvBanks)
      Me.Controls.Add(Me.txtDBALockupAmount)
      Me.Controls.Add(Me.lblDBALockupAmount)
      Me.Controls.Add(Me.txtEntryTicketAmount)
      Me.Controls.Add(Me.lblEntryTicketAmount)
      Me.Controls.Add(Me.txtEntryTicketFactor)
      Me.Controls.Add(Me.lblEntryTicketFactor)
      Me.Controls.Add(Me.txtLockupAmount)
      Me.Controls.Add(Me.lblLockupAmount)
      Me.Controls.Add(Me.cboProductLines)
      Me.Controls.Add(Me.lblProductLine)
      Me.Controls.Add(Me.txtBankDesc)
      Me.Controls.Add(Me.lblBankDescription)
      Me.Controls.Add(Me.txtBankNo)
      Me.Controls.Add(Me.lblBankNo)
      Me.Controls.Add(Me.txtGameTypeCode)
      Me.Controls.Add(Me.lblGameTypeCode)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnAdd)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "AddBank"
      Me.Text = "Add New Bank"
      CType(Me.dgvBanks, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnAdd As System.Windows.Forms.Button
   Friend WithEvents lblGameTypeCode As System.Windows.Forms.Label
   Friend WithEvents txtGameTypeCode As System.Windows.Forms.TextBox
   Friend WithEvents lblBankNo As System.Windows.Forms.Label
   Friend WithEvents txtBankNo As System.Windows.Forms.TextBox
   Friend WithEvents lblBankDescription As System.Windows.Forms.Label
   Friend WithEvents txtBankDesc As System.Windows.Forms.TextBox
   Friend WithEvents lblProductLine As System.Windows.Forms.Label
   Friend WithEvents cboProductLines As System.Windows.Forms.ComboBox
   Friend WithEvents lblLockupAmount As System.Windows.Forms.Label
   Friend WithEvents txtLockupAmount As System.Windows.Forms.TextBox
   Friend WithEvents txtEntryTicketFactor As System.Windows.Forms.TextBox
   Friend WithEvents lblEntryTicketFactor As System.Windows.Forms.Label
   Friend WithEvents txtEntryTicketAmount As System.Windows.Forms.TextBox
   Friend WithEvents lblEntryTicketAmount As System.Windows.Forms.Label
   Friend WithEvents lblDBALockupAmount As System.Windows.Forms.Label
   Friend WithEvents txtDBALockupAmount As System.Windows.Forms.TextBox
   Friend WithEvents ttProvider As System.Windows.Forms.ToolTip
   Friend WithEvents dgvBanks As System.Windows.Forms.DataGridView
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
End Class
