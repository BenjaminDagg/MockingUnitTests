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
        Me.msMain = New System.Windows.Forms.MenuStrip()
        Me.tsmiFile = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiExit = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiAdmin = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiAppUserView = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiFlexNumbers = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiLocations = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiVoucherLotSearch = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiPayout = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiPayoutVouchers = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiReports = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiSettings = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiChangePassword = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiPrinters = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiHelp = New System.Windows.Forms.ToolStripMenuItem()
        Me.tsmiAbout = New System.Windows.Forms.ToolStripMenuItem()
        Me.StatusStripMain = New System.Windows.Forms.StatusStrip()
        Me.tssLabel = New System.Windows.Forms.ToolStripStatusLabel()
        Me.msMain.SuspendLayout()
        Me.StatusStripMain.SuspendLayout()
        Me.SuspendLayout()
        '
        'msMain
        '
        Me.msMain.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiFile, Me.tsmiAdmin, Me.tsmiPayout, Me.tsmiReports, Me.tsmiSettings, Me.tsmiHelp})
        Me.msMain.Location = New System.Drawing.Point(0, 0)
        Me.msMain.Name = "msMain"
        Me.msMain.Size = New System.Drawing.Size(1223, 24)
        Me.msMain.TabIndex = 1
        Me.msMain.Text = "MenuStrip"
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
        Me.tsmiExit.Size = New System.Drawing.Size(152, 22)
        Me.tsmiExit.Text = "E&xit"
        '
        'tsmiAdmin
        '
        Me.tsmiAdmin.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiAppUserView, Me.tsmiFlexNumbers, Me.tsmiLocations, Me.tsmiVoucherLotSearch})
        Me.tsmiAdmin.Name = "tsmiAdmin"
        Me.tsmiAdmin.Size = New System.Drawing.Size(98, 20)
        Me.tsmiAdmin.Text = "&Administration"
        '
        'tsmiAppUserView
        '
        Me.tsmiAppUserView.Name = "tsmiAppUserView"
        Me.tsmiAppUserView.Size = New System.Drawing.Size(176, 22)
        Me.tsmiAppUserView.Text = "Application &Users"
        '
        'tsmiFlexNumbers
        '
        Me.tsmiFlexNumbers.Name = "tsmiFlexNumbers"
        Me.tsmiFlexNumbers.Size = New System.Drawing.Size(176, 22)
        Me.tsmiFlexNumbers.Text = "&Flex Numbers"
        '
        'tsmiLocations
        '
        Me.tsmiLocations.Name = "tsmiLocations"
        Me.tsmiLocations.Size = New System.Drawing.Size(176, 22)
        Me.tsmiLocations.Text = "&Locations"
        '
        'tsmiVoucherLotSearch
        '
        Me.tsmiVoucherLotSearch.Name = "tsmiVoucherLotSearch"
        Me.tsmiVoucherLotSearch.Size = New System.Drawing.Size(176, 22)
        Me.tsmiVoucherLotSearch.Text = "&Voucher Lot Search"
        '
        'tsmiPayout
        '
        Me.tsmiPayout.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiPayoutVouchers})
        Me.tsmiPayout.Name = "tsmiPayout"
        Me.tsmiPayout.Size = New System.Drawing.Size(56, 20)
        Me.tsmiPayout.Text = "&Payout"
        '
        'tsmiPayoutVouchers
        '
        Me.tsmiPayoutVouchers.Name = "tsmiPayoutVouchers"
        Me.tsmiPayoutVouchers.Size = New System.Drawing.Size(163, 22)
        Me.tsmiPayoutVouchers.Text = "Payout &Vouchers"
        '
        'tsmiReports
        '
        Me.tsmiReports.Name = "tsmiReports"
        Me.tsmiReports.Size = New System.Drawing.Size(59, 20)
        Me.tsmiReports.Text = "&Reports"
        '
        'tsmiSettings
        '
        Me.tsmiSettings.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiChangePassword, Me.tsmiPrinters})
        Me.tsmiSettings.Name = "tsmiSettings"
        Me.tsmiSettings.Size = New System.Drawing.Size(61, 20)
        Me.tsmiSettings.Text = "&Settings"
        '
        'tsmiChangePassword
        '
        Me.tsmiChangePassword.Name = "tsmiChangePassword"
        Me.tsmiChangePassword.Size = New System.Drawing.Size(168, 22)
        Me.tsmiChangePassword.Text = "&Change Password"
        '
        'tsmiPrinters
        '
        Me.tsmiPrinters.Name = "tsmiPrinters"
        Me.tsmiPrinters.Size = New System.Drawing.Size(168, 22)
        Me.tsmiPrinters.Text = "&Printers"
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
        Me.tsmiAbout.Size = New System.Drawing.Size(152, 22)
        Me.tsmiAbout.Text = "&About"
        '
        'StatusStripMain
        '
        Me.StatusStripMain.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tssLabel})
        Me.StatusStripMain.Location = New System.Drawing.Point(0, 577)
        Me.StatusStripMain.Name = "StatusStripMain"
        Me.StatusStripMain.Size = New System.Drawing.Size(1223, 22)
        Me.StatusStripMain.TabIndex = 3
        '
        'tssLabel
        '
        Me.tssLabel.Name = "tssLabel"
        Me.tssLabel.Size = New System.Drawing.Size(0, 17)
        '
        'MDIMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1223, 599)
        Me.Controls.Add(Me.StatusStripMain)
        Me.Controls.Add(Me.msMain)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.IsMdiContainer = True
        Me.MainMenuStrip = Me.msMain
        Me.Name = "MDIMain"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Lottery Management System"
        Me.msMain.ResumeLayout(False)
        Me.msMain.PerformLayout()
        Me.StatusStripMain.ResumeLayout(False)
        Me.StatusStripMain.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
   Friend WithEvents msMain As System.Windows.Forms.MenuStrip
   Friend WithEvents tsmiFile As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiExit As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiAdmin As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiAppUserView As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiPayout As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiPayoutVouchers As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiReports As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiHelp As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiAbout As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents StatusStripMain As System.Windows.Forms.StatusStrip
   Friend WithEvents tssLabel As System.Windows.Forms.ToolStripStatusLabel
   Friend WithEvents tsmiLocations As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents tsmiVoucherLotSearch As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiFlexNumbers As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiSettings As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiChangePassword As System.Windows.Forms.ToolStripMenuItem
   Friend WithEvents tsmiPrinters As System.Windows.Forms.ToolStripMenuItem
End Class
