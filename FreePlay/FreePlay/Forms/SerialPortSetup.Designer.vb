<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SerialPortSetup
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
      Me.cboCOMPort = New System.Windows.Forms.ComboBox()
      Me.lblCOMPort = New System.Windows.Forms.Label()
      Me.btnSave = New System.Windows.Forms.Button()
      Me.btnClose = New System.Windows.Forms.Button()
      Me.lblBaudRate = New System.Windows.Forms.Label()
      Me.lblDataBits = New System.Windows.Forms.Label()
      Me.lblParity = New System.Windows.Forms.Label()
      Me.lblStopBits = New System.Windows.Forms.Label()
      Me.lblHandshaking = New System.Windows.Forms.Label()
      Me.txtBaudRate = New System.Windows.Forms.TextBox()
      Me.txtDataBits = New System.Windows.Forms.TextBox()
      Me.txtParity = New System.Windows.Forms.TextBox()
      Me.txtStopBits = New System.Windows.Forms.TextBox()
      Me.txtHandshaking = New System.Windows.Forms.TextBox()
      Me.SuspendLayout()
      '
      'cboCOMPort
      '
      Me.cboCOMPort.CausesValidation = False
      Me.cboCOMPort.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
      Me.cboCOMPort.FormattingEnabled = True
      Me.cboCOMPort.Location = New System.Drawing.Point(123, 31)
      Me.cboCOMPort.Name = "cboCOMPort"
      Me.cboCOMPort.Size = New System.Drawing.Size(142, 21)
      Me.cboCOMPort.TabIndex = 1
      '
      'lblCOMPort
      '
      Me.lblCOMPort.AutoSize = True
      Me.lblCOMPort.CausesValidation = False
      Me.lblCOMPort.Location = New System.Drawing.Point(62, 35)
      Me.lblCOMPort.Name = "lblCOMPort"
      Me.lblCOMPort.Size = New System.Drawing.Size(56, 13)
      Me.lblCOMPort.TabIndex = 0
      Me.lblCOMPort.Text = "COM Port:"
      '
      'btnSave
      '
      Me.btnSave.CausesValidation = False
      Me.btnSave.Location = New System.Drawing.Point(74, 270)
      Me.btnSave.Name = "btnSave"
      Me.btnSave.Size = New System.Drawing.Size(75, 23)
      Me.btnSave.TabIndex = 12
      Me.btnSave.Text = "Save"
      Me.btnSave.UseVisualStyleBackColor = True
      '
      'btnClose
      '
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(165, 270)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(75, 23)
      Me.btnClose.TabIndex = 13
      Me.btnClose.Text = "Close"
      Me.btnClose.UseVisualStyleBackColor = True
      '
      'lblBaudRate
      '
      Me.lblBaudRate.AutoSize = True
      Me.lblBaudRate.CausesValidation = False
      Me.lblBaudRate.Location = New System.Drawing.Point(57, 72)
      Me.lblBaudRate.Name = "lblBaudRate"
      Me.lblBaudRate.Size = New System.Drawing.Size(61, 13)
      Me.lblBaudRate.TabIndex = 2
      Me.lblBaudRate.Text = "Baud Rate:"
      '
      'lblDataBits
      '
      Me.lblDataBits.AutoSize = True
      Me.lblDataBits.CausesValidation = False
      Me.lblDataBits.Location = New System.Drawing.Point(65, 108)
      Me.lblDataBits.Name = "lblDataBits"
      Me.lblDataBits.Size = New System.Drawing.Size(53, 13)
      Me.lblDataBits.TabIndex = 4
      Me.lblDataBits.Text = "Data Bits:"
      '
      'lblParity
      '
      Me.lblParity.AutoSize = True
      Me.lblParity.CausesValidation = False
      Me.lblParity.Location = New System.Drawing.Point(82, 144)
      Me.lblParity.Name = "lblParity"
      Me.lblParity.Size = New System.Drawing.Size(36, 13)
      Me.lblParity.TabIndex = 6
      Me.lblParity.Text = "Parity:"
      '
      'lblStopBits
      '
      Me.lblStopBits.AutoSize = True
      Me.lblStopBits.CausesValidation = False
      Me.lblStopBits.Location = New System.Drawing.Point(66, 180)
      Me.lblStopBits.Name = "lblStopBits"
      Me.lblStopBits.Size = New System.Drawing.Size(52, 13)
      Me.lblStopBits.TabIndex = 8
      Me.lblStopBits.Text = "Stop Bits:"
      '
      'lblHandshaking
      '
      Me.lblHandshaking.AutoSize = True
      Me.lblHandshaking.CausesValidation = False
      Me.lblHandshaking.Location = New System.Drawing.Point(45, 216)
      Me.lblHandshaking.Name = "lblHandshaking"
      Me.lblHandshaking.Size = New System.Drawing.Size(73, 13)
      Me.lblHandshaking.TabIndex = 10
      Me.lblHandshaking.Text = "Handshaking:"
      '
      'txtBaudRate
      '
      Me.txtBaudRate.CausesValidation = False
      Me.txtBaudRate.Location = New System.Drawing.Point(124, 68)
      Me.txtBaudRate.Name = "txtBaudRate"
      Me.txtBaudRate.ReadOnly = True
      Me.txtBaudRate.Size = New System.Drawing.Size(141, 20)
      Me.txtBaudRate.TabIndex = 3
      '
      'txtDataBits
      '
      Me.txtDataBits.CausesValidation = False
      Me.txtDataBits.Location = New System.Drawing.Point(124, 104)
      Me.txtDataBits.Name = "txtDataBits"
      Me.txtDataBits.ReadOnly = True
      Me.txtDataBits.Size = New System.Drawing.Size(141, 20)
      Me.txtDataBits.TabIndex = 5
      '
      'txtParity
      '
      Me.txtParity.CausesValidation = False
      Me.txtParity.Location = New System.Drawing.Point(124, 140)
      Me.txtParity.Name = "txtParity"
      Me.txtParity.ReadOnly = True
      Me.txtParity.Size = New System.Drawing.Size(141, 20)
      Me.txtParity.TabIndex = 7
      '
      'txtStopBits
      '
      Me.txtStopBits.CausesValidation = False
      Me.txtStopBits.Location = New System.Drawing.Point(124, 176)
      Me.txtStopBits.Name = "txtStopBits"
      Me.txtStopBits.ReadOnly = True
      Me.txtStopBits.Size = New System.Drawing.Size(141, 20)
      Me.txtStopBits.TabIndex = 9
      '
      'txtHandshaking
      '
      Me.txtHandshaking.CausesValidation = False
      Me.txtHandshaking.Location = New System.Drawing.Point(123, 212)
      Me.txtHandshaking.Name = "txtHandshaking"
      Me.txtHandshaking.ReadOnly = True
      Me.txtHandshaking.Size = New System.Drawing.Size(141, 20)
      Me.txtHandshaking.TabIndex = 11
      '
      'SerialPortSetup
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(314, 312)
      Me.Controls.Add(Me.txtHandshaking)
      Me.Controls.Add(Me.txtStopBits)
      Me.Controls.Add(Me.txtParity)
      Me.Controls.Add(Me.txtDataBits)
      Me.Controls.Add(Me.txtBaudRate)
      Me.Controls.Add(Me.lblHandshaking)
      Me.Controls.Add(Me.lblStopBits)
      Me.Controls.Add(Me.lblParity)
      Me.Controls.Add(Me.lblDataBits)
      Me.Controls.Add(Me.lblBaudRate)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnSave)
      Me.Controls.Add(Me.cboCOMPort)
      Me.Controls.Add(Me.lblCOMPort)
      Me.MaximizeBox = False
      Me.MaximumSize = New System.Drawing.Size(330, 350)
      Me.MinimizeBox = False
      Me.MinimumSize = New System.Drawing.Size(330, 350)
      Me.Name = "SerialPortSetup"
      Me.ShowIcon = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Serial Port"
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents cboCOMPort As System.Windows.Forms.ComboBox
   Friend WithEvents lblCOMPort As System.Windows.Forms.Label
   Friend WithEvents btnSave As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents lblBaudRate As System.Windows.Forms.Label
   Friend WithEvents lblDataBits As System.Windows.Forms.Label
   Friend WithEvents lblParity As System.Windows.Forms.Label
   Friend WithEvents lblStopBits As System.Windows.Forms.Label
   Friend WithEvents lblHandshaking As System.Windows.Forms.Label
   Friend WithEvents txtBaudRate As System.Windows.Forms.TextBox
   Friend WithEvents txtDataBits As System.Windows.Forms.TextBox
   Friend WithEvents txtParity As System.Windows.Forms.TextBox
   Friend WithEvents txtStopBits As System.Windows.Forms.TextBox
   Friend WithEvents txtHandshaking As System.Windows.Forms.TextBox
End Class
