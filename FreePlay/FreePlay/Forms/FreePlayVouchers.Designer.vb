<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FreePlayVouchers
   Inherits DGE.DgeSmartForm

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
      Me.lblVoucherAmount = New System.Windows.Forms.Label()
      Me.lblQuantity = New System.Windows.Forms.Label()
      Me.lblExpirationDays = New System.Windows.Forms.Label()
      Me.btnCancel = New System.Windows.Forms.Button()
      Me.btnContinue = New System.Windows.Forms.Button()
      Me.txtExpirationDays = New System.Windows.Forms.TextBox()
      Me.txtQuantity = New System.Windows.Forms.TextBox()
      Me.txtVoucherAmount = New System.Windows.Forms.TextBox()
      Me.ErrProvider1 = New System.Windows.Forms.ErrorProvider(Me.components)
      Me.ErrProvider2 = New System.Windows.Forms.ErrorProvider(Me.components)
      Me.ErrProvider3 = New System.Windows.Forms.ErrorProvider(Me.components)
      CType(Me.ErrProvider1, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.ErrProvider2, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.ErrProvider3, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'lblVoucherAmount
      '
      Me.lblVoucherAmount.AutoSize = True
      Me.lblVoucherAmount.CausesValidation = False
      Me.lblVoucherAmount.Location = New System.Drawing.Point(63, 26)
      Me.lblVoucherAmount.Name = "lblVoucherAmount"
      Me.lblVoucherAmount.Size = New System.Drawing.Size(89, 13)
      Me.lblVoucherAmount.TabIndex = 0
      Me.lblVoucherAmount.Text = "Voucher Amount:"
      '
      'lblQuantity
      '
      Me.lblQuantity.AutoSize = True
      Me.lblQuantity.CausesValidation = False
      Me.lblQuantity.Location = New System.Drawing.Point(103, 61)
      Me.lblQuantity.Name = "lblQuantity"
      Me.lblQuantity.Size = New System.Drawing.Size(49, 13)
      Me.lblQuantity.TabIndex = 2
      Me.lblQuantity.Text = "Quantity:"
      '
      'lblExpirationDays
      '
      Me.lblExpirationDays.AutoSize = True
      Me.lblExpirationDays.CausesValidation = False
      Me.lblExpirationDays.Location = New System.Drawing.Point(69, 96)
      Me.lblExpirationDays.Name = "lblExpirationDays"
      Me.lblExpirationDays.Size = New System.Drawing.Size(83, 13)
      Me.lblExpirationDays.TabIndex = 4
      Me.lblExpirationDays.Text = "Expiration Days:"
      '
      'btnCancel
      '
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Location = New System.Drawing.Point(166, 147)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(75, 23)
      Me.btnCancel.TabIndex = 7
      Me.btnCancel.Text = "Cancel"
      Me.btnCancel.UseVisualStyleBackColor = True
      '
      'btnContinue
      '
      Me.btnContinue.CausesValidation = False
      Me.btnContinue.Location = New System.Drawing.Point(74, 147)
      Me.btnContinue.Name = "btnContinue"
      Me.btnContinue.Size = New System.Drawing.Size(75, 23)
      Me.btnContinue.TabIndex = 6
      Me.btnContinue.Text = "Continue"
      Me.btnContinue.UseVisualStyleBackColor = True
      '
      'txtExpirationDays
      '
      Me.txtExpirationDays.CausesValidation = False
      Me.txtExpirationDays.Location = New System.Drawing.Point(158, 92)
      Me.txtExpirationDays.MaxLength = 3
      Me.txtExpirationDays.Name = "txtExpirationDays"
      Me.txtExpirationDays.Size = New System.Drawing.Size(45, 20)
      Me.txtExpirationDays.TabIndex = 5
      '
      'txtQuantity
      '
      Me.txtQuantity.CausesValidation = False
      Me.txtQuantity.Location = New System.Drawing.Point(158, 57)
      Me.txtQuantity.MaxLength = 3
      Me.txtQuantity.Name = "txtQuantity"
      Me.txtQuantity.Size = New System.Drawing.Size(45, 20)
      Me.txtQuantity.TabIndex = 3
      '
      'txtVoucherAmount
      '
      Me.txtVoucherAmount.CausesValidation = False
      Me.txtVoucherAmount.Location = New System.Drawing.Point(158, 22)
      Me.txtVoucherAmount.MaxLength = 5
      Me.txtVoucherAmount.Name = "txtVoucherAmount"
      Me.txtVoucherAmount.Size = New System.Drawing.Size(78, 20)
      Me.txtVoucherAmount.TabIndex = 1
      '
      'ErrProvider1
      '
      Me.ErrProvider1.ContainerControl = Me
      '
      'ErrProvider2
      '
      Me.ErrProvider2.ContainerControl = Me
      '
      'ErrProvider3
      '
      Me.ErrProvider3.ContainerControl = Me
      '
      'FreePlayVouchers
      '
      Me.AcceptButton = Me.btnContinue
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.CancelButton = Me.btnCancel
      Me.ClientSize = New System.Drawing.Size(314, 182)
      Me.Controls.Add(Me.txtVoucherAmount)
      Me.Controls.Add(Me.txtExpirationDays)
      Me.Controls.Add(Me.txtQuantity)
      Me.Controls.Add(Me.btnContinue)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.lblExpirationDays)
      Me.Controls.Add(Me.lblQuantity)
      Me.Controls.Add(Me.lblVoucherAmount)
      Me.MaximizeBox = False
      Me.MaximumSize = New System.Drawing.Size(330, 220)
      Me.MinimizeBox = False
      Me.MinimumSize = New System.Drawing.Size(330, 220)
      Me.Name = "FreePlayVouchers"
      Me.ShowIcon = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Voucher Creation"
      CType(Me.ErrProvider1, System.ComponentModel.ISupportInitialize).EndInit()
      CType(Me.ErrProvider2, System.ComponentModel.ISupportInitialize).EndInit()
      CType(Me.ErrProvider3, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents lblVoucherAmount As System.Windows.Forms.Label
   Friend WithEvents lblQuantity As System.Windows.Forms.Label
   Friend WithEvents lblExpirationDays As System.Windows.Forms.Label
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnContinue As System.Windows.Forms.Button
   Friend WithEvents txtExpirationDays As System.Windows.Forms.TextBox
   Friend WithEvents txtQuantity As System.Windows.Forms.TextBox
   Friend WithEvents txtVoucherAmount As System.Windows.Forms.TextBox
   Friend WithEvents ErrProvider1 As System.Windows.Forms.ErrorProvider
   Friend WithEvents ErrProvider2 As System.Windows.Forms.ErrorProvider
   Friend WithEvents ErrProvider3 As System.Windows.Forms.ErrorProvider
End Class
