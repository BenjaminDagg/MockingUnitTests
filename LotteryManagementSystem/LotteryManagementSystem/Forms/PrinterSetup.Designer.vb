<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PrinterSetup
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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(PrinterSetup))
      Me.btnSave = New System.Windows.Forms.Button()
      Me.btnClose = New System.Windows.Forms.Button()
      Me.lblReportPrinter = New System.Windows.Forms.Label()
      Me.lblReceiptPrinter = New System.Windows.Forms.Label()
      Me.cbReportPrinter = New System.Windows.Forms.ComboBox()
      Me.cbReceiptPrinter = New System.Windows.Forms.ComboBox()
      Me.SuspendLayout()
      '
      'btnSave
      '
      Me.btnSave.CausesValidation = False
      Me.btnSave.Location = New System.Drawing.Point(105, 124)
      Me.btnSave.Name = "btnSave"
      Me.btnSave.Size = New System.Drawing.Size(75, 23)
      Me.btnSave.TabIndex = 4
      Me.btnSave.Text = "Save"
      Me.btnSave.UseVisualStyleBackColor = True
      '
      'btnClose
      '
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(200, 124)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(75, 23)
      Me.btnClose.TabIndex = 5
      Me.btnClose.Text = "Close"
      Me.btnClose.UseVisualStyleBackColor = True
      '
      'lblReportPrinter
      '
      Me.lblReportPrinter.AutoSize = True
      Me.lblReportPrinter.CausesValidation = False
      Me.lblReportPrinter.Location = New System.Drawing.Point(50, 36)
      Me.lblReportPrinter.Name = "lblReportPrinter"
      Me.lblReportPrinter.Size = New System.Drawing.Size(75, 13)
      Me.lblReportPrinter.TabIndex = 0
      Me.lblReportPrinter.Text = "Report Printer:"
      '
      'lblReceiptPrinter
      '
      Me.lblReceiptPrinter.AutoSize = True
      Me.lblReceiptPrinter.CausesValidation = False
      Me.lblReceiptPrinter.Location = New System.Drawing.Point(45, 80)
      Me.lblReceiptPrinter.Name = "lblReceiptPrinter"
      Me.lblReceiptPrinter.Size = New System.Drawing.Size(80, 13)
      Me.lblReceiptPrinter.TabIndex = 2
      Me.lblReceiptPrinter.Text = "Receipt Printer:"
      '
      'cbReportPrinter
      '
      Me.cbReportPrinter.CausesValidation = False
      Me.cbReportPrinter.FormattingEnabled = True
      Me.cbReportPrinter.Location = New System.Drawing.Point(131, 32)
      Me.cbReportPrinter.Name = "cbReportPrinter"
      Me.cbReportPrinter.Size = New System.Drawing.Size(208, 21)
      Me.cbReportPrinter.TabIndex = 1
      '
      'cbReceiptPrinter
      '
      Me.cbReceiptPrinter.CausesValidation = False
      Me.cbReceiptPrinter.FormattingEnabled = True
      Me.cbReceiptPrinter.Location = New System.Drawing.Point(131, 76)
      Me.cbReceiptPrinter.Name = "cbReceiptPrinter"
      Me.cbReceiptPrinter.Size = New System.Drawing.Size(208, 21)
      Me.cbReceiptPrinter.TabIndex = 3
      '
      'PrinterSetup
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(384, 162)
      Me.Controls.Add(Me.cbReceiptPrinter)
      Me.Controls.Add(Me.cbReportPrinter)
      Me.Controls.Add(Me.lblReceiptPrinter)
      Me.Controls.Add(Me.lblReportPrinter)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnSave)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MaximizeBox = False
      Me.MaximumSize = New System.Drawing.Size(400, 200)
      Me.MinimizeBox = False
      Me.MinimumSize = New System.Drawing.Size(400, 200)
      Me.Name = "PrinterSetup"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Printer Setup"
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents btnSave As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents lblReportPrinter As System.Windows.Forms.Label
   Friend WithEvents lblReceiptPrinter As System.Windows.Forms.Label
   Friend WithEvents cbReportPrinter As System.Windows.Forms.ComboBox
   Friend WithEvents cbReceiptPrinter As System.Windows.Forms.ComboBox
End Class
