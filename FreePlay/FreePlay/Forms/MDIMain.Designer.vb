<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MDIMain
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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MDIMain))
      Me.MenuStrip = New System.Windows.Forms.MenuStrip()
      Me.tsmiFile = New System.Windows.Forms.ToolStripMenuItem()
      Me.tsmiExit = New System.Windows.Forms.ToolStripMenuItem()
      Me.tsmiSetup = New System.Windows.Forms.ToolStripMenuItem()
      Me.tsmiSerialPort = New System.Windows.Forms.ToolStripMenuItem()
      Me.tsmiFreePlay = New System.Windows.Forms.ToolStripMenuItem()
      Me.tsmiCreateFreePlayVouchers = New System.Windows.Forms.ToolStripMenuItem()
      Me.tsmiReports = New System.Windows.Forms.ToolStripMenuItem()
      Me.tsmiHelp = New System.Windows.Forms.ToolStripMenuItem()
      Me.tsmiAbout = New System.Windows.Forms.ToolStripMenuItem()
      Me.MenuStrip.SuspendLayout()
      Me.SuspendLayout()
      '
      'MenuStrip
      '
      Me.MenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiFile, Me.tsmiSetup, Me.tsmiFreePlay, Me.tsmiReports, Me.tsmiHelp})
      Me.MenuStrip.Location = New System.Drawing.Point(0, 0)
      Me.MenuStrip.Name = "MenuStrip"
      Me.MenuStrip.Size = New System.Drawing.Size(699, 24)
      Me.MenuStrip.TabIndex = 0
      Me.MenuStrip.Text = "MenuStrip1"
      '
      'tsmiFile
      '
      Me.tsmiFile.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiExit})
      Me.tsmiFile.Name = "tsmiFile"
      Me.tsmiFile.Size = New System.Drawing.Size(37, 20)
      Me.tsmiFile.Text = "&File"
      '
      'tsmiExit
      '
      Me.tsmiExit.Name = "tsmiExit"
      Me.tsmiExit.Size = New System.Drawing.Size(92, 22)
      Me.tsmiExit.Text = "&Exit"
      '
      'tsmiSetup
      '
      Me.tsmiSetup.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiSerialPort})
      Me.tsmiSetup.Name = "tsmiSetup"
      Me.tsmiSetup.Size = New System.Drawing.Size(49, 20)
      Me.tsmiSetup.Text = "&Setup"
      '
      'tsmiSerialPort
      '
      Me.tsmiSerialPort.Name = "tsmiSerialPort"
      Me.tsmiSerialPort.Size = New System.Drawing.Size(152, 22)
      Me.tsmiSerialPort.Text = "Serial Port"
      '
      'tsmiFreePlay
      '
      Me.tsmiFreePlay.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiCreateFreePlayVouchers})
      Me.tsmiFreePlay.Name = "tsmiFreePlay"
      Me.tsmiFreePlay.Size = New System.Drawing.Size(68, 20)
      Me.tsmiFreePlay.Text = "&Vouchers"
      '
      'tsmiCreateFreePlayVouchers
      '
      Me.tsmiCreateFreePlayVouchers.Name = "tsmiCreateFreePlayVouchers"
      Me.tsmiCreateFreePlayVouchers.Size = New System.Drawing.Size(160, 22)
      Me.tsmiCreateFreePlayVouchers.Text = "&Create Vouchers"
      '
      'tsmiReports
      '
      Me.tsmiReports.Name = "tsmiReports"
      Me.tsmiReports.Size = New System.Drawing.Size(59, 20)
      Me.tsmiReports.Text = "&Reports"
      '
      'tsmiHelp
      '
      Me.tsmiHelp.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiAbout})
      Me.tsmiHelp.Name = "tsmiHelp"
      Me.tsmiHelp.Size = New System.Drawing.Size(44, 20)
      Me.tsmiHelp.Text = "&Help"
      '
      'tsmiAbout
      '
      Me.tsmiAbout.Name = "tsmiAbout"
      Me.tsmiAbout.Size = New System.Drawing.Size(107, 22)
      Me.tsmiAbout.Text = "&About"
      '
      'MDIMain
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(699, 439)
      Me.Controls.Add(Me.MenuStrip)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.IsMdiContainer = True
      Me.MainMenuStrip = Me.MenuStrip
      Me.Name = "MDIMain"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Restricted Credit"
      Me.MenuStrip.ResumeLayout(False)
      Me.MenuStrip.PerformLayout()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents MenuStrip As System.Windows.Forms.MenuStrip
   Friend WithEvents tsmiFile As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiExit As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiFreePlay As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiCreateFreePlayVouchers As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiReports As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiHelp As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiAbout As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiSetup As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiSerialPort As System.Windows.Forms.ToolStripMenuItem

End Class
