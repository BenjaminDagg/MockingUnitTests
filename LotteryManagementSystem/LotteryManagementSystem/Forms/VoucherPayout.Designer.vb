<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class VoucherPayout
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(VoucherPayout))
        Me.lblVoucher = New System.Windows.Forms.Label()
        Me.btnPayout = New System.Windows.Forms.Button()
        Me.lblVoucherAmount = New System.Windows.Forms.Label()
        Me.txtVoucher = New System.Windows.Forms.TextBox()
        Me.txtVoucherAmount = New System.Windows.Forms.TextBox()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.lblUserInfo = New System.Windows.Forms.Label()
        Me.txtLocationName = New System.Windows.Forms.TextBox()
        Me.lblLocation = New System.Windows.Forms.Label()
        Me.btnReprint = New System.Windows.Forms.Button()
        Me.btnClear = New System.Windows.Forms.Button()
        Me.pbStatus = New System.Windows.Forms.PictureBox()
        Me.txtValidCheckSum = New System.Windows.Forms.TextBox()
        Me.lblValidCheckSum = New System.Windows.Forms.Label()
        Me.txtValidVoucher = New System.Windows.Forms.TextBox()
        Me.lblValidVoucher = New System.Windows.Forms.Label()
        Me.txtRedeemed = New System.Windows.Forms.TextBox()
        Me.lblRedeemed = New System.Windows.Forms.Label()
        CType(Me.pbStatus, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'lblVoucher
        '
        Me.lblVoucher.Location = New System.Drawing.Point(25, 32)
        Me.lblVoucher.Name = "lblVoucher"
        Me.lblVoucher.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblVoucher.Size = New System.Drawing.Size(115, 13)
        Me.lblVoucher.TabIndex = 0
        Me.lblVoucher.Text = "Voucher Valildation ID:"
        Me.lblVoucher.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'btnPayout
        '
        Me.btnPayout.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnPayout.CausesValidation = False
        Me.btnPayout.Location = New System.Drawing.Point(300, 267)
        Me.btnPayout.Name = "btnPayout"
        Me.btnPayout.Size = New System.Drawing.Size(86, 26)
        Me.btnPayout.TabIndex = 10
        Me.btnPayout.Text = "Pay Voucher"
        Me.btnPayout.UseVisualStyleBackColor = True
        '
        'lblVoucherAmount
        '
        Me.lblVoucherAmount.Location = New System.Drawing.Point(51, 67)
        Me.lblVoucherAmount.Name = "lblVoucherAmount"
        Me.lblVoucherAmount.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblVoucherAmount.Size = New System.Drawing.Size(89, 13)
        Me.lblVoucherAmount.TabIndex = 5
        Me.lblVoucherAmount.Text = "Voucher Amount:"
        Me.lblVoucherAmount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'txtVoucher
        '
        Me.txtVoucher.CausesValidation = False
        Me.txtVoucher.Location = New System.Drawing.Point(140, 30)
        Me.txtVoucher.MaxLength = 18
        Me.txtVoucher.Name = "txtVoucher"
        Me.txtVoucher.Size = New System.Drawing.Size(129, 20)
        Me.txtVoucher.TabIndex = 1
        '
        'txtVoucherAmount
        '
        Me.txtVoucherAmount.CausesValidation = False
        Me.txtVoucherAmount.Location = New System.Drawing.Point(140, 63)
        Me.txtVoucherAmount.Name = "txtVoucherAmount"
        Me.txtVoucherAmount.ReadOnly = True
        Me.txtVoucherAmount.Size = New System.Drawing.Size(129, 20)
        Me.txtVoucherAmount.TabIndex = 6
        Me.txtVoucherAmount.TabStop = False
        '
        'btnClose
        '
        Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnClose.CausesValidation = False
        Me.btnClose.Location = New System.Drawing.Point(198, 267)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(86, 26)
        Me.btnClose.TabIndex = 14
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = True
        '
        'lblUserInfo
        '
        Me.lblUserInfo.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblUserInfo.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblUserInfo.CausesValidation = False
        Me.lblUserInfo.Location = New System.Drawing.Point(21, 173)
        Me.lblUserInfo.Name = "lblUserInfo"
        Me.lblUserInfo.Size = New System.Drawing.Size(543, 80)
        Me.lblUserInfo.TabIndex = 13
        '
        'txtLocationName
        '
        Me.txtLocationName.BackColor = System.Drawing.SystemColors.Control
        Me.txtLocationName.CausesValidation = False
        Me.txtLocationName.Location = New System.Drawing.Point(140, 97)
        Me.txtLocationName.Name = "txtLocationName"
        Me.txtLocationName.ReadOnly = True
        Me.txtLocationName.Size = New System.Drawing.Size(267, 20)
        Me.txtLocationName.TabIndex = 4
        Me.txtLocationName.TabStop = False
        '
        'lblLocation
        '
        Me.lblLocation.Location = New System.Drawing.Point(51, 101)
        Me.lblLocation.Name = "lblLocation"
        Me.lblLocation.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblLocation.Size = New System.Drawing.Size(89, 13)
        Me.lblLocation.TabIndex = 3
        Me.lblLocation.Text = "Location:"
        Me.lblLocation.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'btnReprint
        '
        Me.btnReprint.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnReprint.CausesValidation = False
        Me.btnReprint.Location = New System.Drawing.Point(438, 133)
        Me.btnReprint.Name = "btnReprint"
        Me.btnReprint.Size = New System.Drawing.Size(116, 26)
        Me.btnReprint.TabIndex = 15
        Me.btnReprint.Text = "Reprint Last Receipt"
        Me.btnReprint.UseVisualStyleBackColor = True
        '
        'btnClear
        '
        Me.btnClear.CausesValidation = False
        Me.btnClear.Location = New System.Drawing.Point(281, 28)
        Me.btnClear.Name = "btnClear"
        Me.btnClear.Size = New System.Drawing.Size(43, 23)
        Me.btnClear.TabIndex = 2
        Me.btnClear.Text = "Clear"
        Me.btnClear.UseVisualStyleBackColor = True
        '
        'pbStatus
        '
        Me.pbStatus.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pbStatus.Location = New System.Drawing.Point(438, 28)
        Me.pbStatus.Name = "pbStatus"
        Me.pbStatus.Size = New System.Drawing.Size(116, 99)
        Me.pbStatus.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.pbStatus.TabIndex = 16
        Me.pbStatus.TabStop = False
        '
        'txtValidCheckSum
        '
        Me.txtValidCheckSum.CausesValidation = False
        Me.txtValidCheckSum.Location = New System.Drawing.Point(144, 136)
        Me.txtValidCheckSum.MaxLength = 3
        Me.txtValidCheckSum.Name = "txtValidCheckSum"
        Me.txtValidCheckSum.ReadOnly = True
        Me.txtValidCheckSum.Size = New System.Drawing.Size(29, 20)
        Me.txtValidCheckSum.TabIndex = 19
        '
        'lblValidCheckSum
        '
        Me.lblValidCheckSum.Location = New System.Drawing.Point(8, 137)
        Me.lblValidCheckSum.Name = "lblValidCheckSum"
        Me.lblValidCheckSum.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblValidCheckSum.Size = New System.Drawing.Size(137, 18)
        Me.lblValidCheckSum.TabIndex = 18
        Me.lblValidCheckSum.Text = "Valid Voucher CheckSum:"
        Me.lblValidCheckSum.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'txtValidVoucher
        '
        Me.txtValidVoucher.CausesValidation = False
        Me.txtValidVoucher.Location = New System.Drawing.Point(260, 136)
        Me.txtValidVoucher.MaxLength = 3
        Me.txtValidVoucher.Name = "txtValidVoucher"
        Me.txtValidVoucher.ReadOnly = True
        Me.txtValidVoucher.Size = New System.Drawing.Size(29, 20)
        Me.txtValidVoucher.TabIndex = 21
        '
        'lblValidVoucher
        '
        Me.lblValidVoucher.Location = New System.Drawing.Point(179, 137)
        Me.lblValidVoucher.Name = "lblValidVoucher"
        Me.lblValidVoucher.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblValidVoucher.Size = New System.Drawing.Size(81, 18)
        Me.lblValidVoucher.TabIndex = 20
        Me.lblValidVoucher.Text = "Valid Voucher:"
        Me.lblValidVoucher.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'txtRedeemed
        '
        Me.txtRedeemed.CausesValidation = False
        Me.txtRedeemed.Location = New System.Drawing.Point(369, 136)
        Me.txtRedeemed.MaxLength = 3
        Me.txtRedeemed.Name = "txtRedeemed"
        Me.txtRedeemed.ReadOnly = True
        Me.txtRedeemed.Size = New System.Drawing.Size(29, 20)
        Me.txtRedeemed.TabIndex = 23
        '
        'lblRedeemed
        '
        Me.lblRedeemed.Location = New System.Drawing.Point(305, 137)
        Me.lblRedeemed.Name = "lblRedeemed"
        Me.lblRedeemed.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblRedeemed.Size = New System.Drawing.Size(66, 18)
        Me.lblRedeemed.TabIndex = 22
        Me.lblRedeemed.Text = "Redeemed:"
        Me.lblRedeemed.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'VoucherPayout
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(584, 312)
        Me.Controls.Add(Me.txtRedeemed)
        Me.Controls.Add(Me.lblRedeemed)
        Me.Controls.Add(Me.txtValidVoucher)
        Me.Controls.Add(Me.lblValidVoucher)
        Me.Controls.Add(Me.txtValidCheckSum)
        Me.Controls.Add(Me.lblValidCheckSum)
        Me.Controls.Add(Me.pbStatus)
        Me.Controls.Add(Me.btnClear)
        Me.Controls.Add(Me.btnReprint)
        Me.Controls.Add(Me.txtLocationName)
        Me.Controls.Add(Me.lblUserInfo)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.txtVoucherAmount)
        Me.Controls.Add(Me.txtVoucher)
        Me.Controls.Add(Me.lblVoucherAmount)
        Me.Controls.Add(Me.btnPayout)
        Me.Controls.Add(Me.lblVoucher)
        Me.Controls.Add(Me.lblLocation)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MinimumSize = New System.Drawing.Size(575, 350)
        Me.Name = "VoucherPayout"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Voucher Payout"
        CType(Me.pbStatus, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

End Sub
   Friend WithEvents lblVoucher As System.Windows.Forms.Label
   Friend WithEvents btnPayout As System.Windows.Forms.Button
   Friend WithEvents lblVoucherAmount As System.Windows.Forms.Label
   Friend WithEvents txtVoucher As System.Windows.Forms.TextBox
   Friend WithEvents txtVoucherAmount As System.Windows.Forms.TextBox
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents lblUserInfo As System.Windows.Forms.Label
   Friend WithEvents txtLocationName As System.Windows.Forms.TextBox
   Friend WithEvents lblLocation As System.Windows.Forms.Label
   Friend WithEvents btnReprint As System.Windows.Forms.Button
   Friend WithEvents btnClear As System.Windows.Forms.Button
   Friend WithEvents pbStatus As System.Windows.Forms.PictureBox
   Friend WithEvents txtValidCheckSum As System.Windows.Forms.TextBox
   Friend WithEvents lblValidCheckSum As System.Windows.Forms.Label
   Friend WithEvents txtValidVoucher As System.Windows.Forms.TextBox
   Friend WithEvents lblValidVoucher As System.Windows.Forms.Label
   Friend WithEvents txtRedeemed As System.Windows.Forms.TextBox
   Friend WithEvents lblRedeemed As System.Windows.Forms.Label
End Class
