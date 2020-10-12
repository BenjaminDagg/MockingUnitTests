<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class VoucherLotStatus
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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(VoucherLotStatus))
      Me.btnSearch = New System.Windows.Forms.Button()
      Me.btnClose = New System.Windows.Forms.Button()
      Me.txtVoucherLot = New System.Windows.Forms.TextBox()
      Me.lblVoucherLot = New System.Windows.Forms.Label()
      Me.txtSearchResults = New System.Windows.Forms.TextBox()
      Me.SuspendLayout()
      '
      'btnSearch
      '
      Me.btnSearch.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnSearch.CausesValidation = False
      Me.btnSearch.Location = New System.Drawing.Point(119, 225)
      Me.btnSearch.Name = "btnSearch"
      Me.btnSearch.Size = New System.Drawing.Size(55, 23)
      Me.btnSearch.TabIndex = 3
      Me.btnSearch.Text = "Search"
      Me.btnSearch.UseVisualStyleBackColor = True
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(211, 225)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(55, 23)
      Me.btnClose.TabIndex = 4
      Me.btnClose.Text = "Close"
      Me.btnClose.UseVisualStyleBackColor = True
      '
      'txtVoucherLot
      '
      Me.txtVoucherLot.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtVoucherLot.CausesValidation = False
      Me.txtVoucherLot.Location = New System.Drawing.Point(273, 26)
      Me.txtVoucherLot.MaxLength = 14
      Me.txtVoucherLot.Name = "txtVoucherLot"
      Me.txtVoucherLot.Size = New System.Drawing.Size(91, 20)
      Me.txtVoucherLot.TabIndex = 1
      '
      'lblVoucherLot
      '
      Me.lblVoucherLot.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblVoucherLot.CausesValidation = False
      Me.lblVoucherLot.Location = New System.Drawing.Point(135, 24)
      Me.lblVoucherLot.Name = "lblVoucherLot"
      Me.lblVoucherLot.Size = New System.Drawing.Size(137, 23)
      Me.lblVoucherLot.TabIndex = 0
      Me.lblVoucherLot.Text = "Enter Voucher Lot Number:"
      Me.lblVoucherLot.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtSearchResults
      '
      Me.txtSearchResults.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtSearchResults.CausesValidation = False
      Me.txtSearchResults.Font = New System.Drawing.Font("Courier New", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.txtSearchResults.Location = New System.Drawing.Point(25, 62)
      Me.txtSearchResults.Multiline = True
      Me.txtSearchResults.Name = "txtSearchResults"
      Me.txtSearchResults.Size = New System.Drawing.Size(338, 149)
      Me.txtSearchResults.TabIndex = 2
      '
      'VoucherLotStatus
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(384, 262)
      Me.Controls.Add(Me.txtSearchResults)
      Me.Controls.Add(Me.lblVoucherLot)
      Me.Controls.Add(Me.txtVoucherLot)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnSearch)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MinimumSize = New System.Drawing.Size(300, 200)
      Me.Name = "VoucherLotStatus"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Voucher Lot Search"
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents btnSearch As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents txtVoucherLot As System.Windows.Forms.TextBox
   Friend WithEvents lblVoucherLot As System.Windows.Forms.Label
   Friend WithEvents txtSearchResults As System.Windows.Forms.TextBox
End Class
