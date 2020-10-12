<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class BingoMasterImport
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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(BingoMasterImport))
      Me.SplitMaster = New System.Windows.Forms.SplitContainer
      Me.dgvImportMasterDeals = New System.Windows.Forms.DataGridView
      Me.lblGridHeader = New System.Windows.Forms.Label
      Me.btnFolderBrowse = New System.Windows.Forms.Button
      Me.txtSourceFolder = New System.Windows.Forms.TextBox
      Me.lblSourceFolder = New System.Windows.Forms.Label
      Me.btnClose = New System.Windows.Forms.Button
      Me.btnImport = New System.Windows.Forms.Button
      Me.grpUpdateFlags = New System.Windows.Forms.GroupBox
      Me.cbWinningTiersUpdate = New System.Windows.Forms.CheckBox
      Me.cbFormsUpdate = New System.Windows.Forms.CheckBox
      Me.cbGameSetupUpdate = New System.Windows.Forms.CheckBox
      Me.cbDenomToGTUpdate = New System.Windows.Forms.CheckBox
      Me.cbLinesBetToGTUpdate = New System.Windows.Forms.CheckBox
      Me.cbCoinsBetToGTUpdate = New System.Windows.Forms.CheckBox
      Me.cbPayscaleTiersUpdate = New System.Windows.Forms.CheckBox
      Me.cbPayscaleUpdate = New System.Windows.Forms.CheckBox
      Me.cbGameTypeUpdate = New System.Windows.Forms.CheckBox
      Me.cbMachineUpdate = New System.Windows.Forms.CheckBox
      Me.cbBankUpdate = New System.Windows.Forms.CheckBox
      Me.grpImportFlags = New System.Windows.Forms.GroupBox
      Me.cbEnforceIS = New System.Windows.Forms.CheckBox
      Me.cbBankMach = New System.Windows.Forms.CheckBox
      Me.cbCasino = New System.Windows.Forms.CheckBox
      Me.dgvRetireMasterDeals = New System.Windows.Forms.DataGridView
      Me.lblGridHeaderMDR = New System.Windows.Forms.Label
      Me.sbrStatus = New System.Windows.Forms.StatusBar
      Me.FolderBrowserDlg = New System.Windows.Forms.FolderBrowserDialog
      Me.lblTargetDBs = New System.Windows.Forms.Label
      Me.SplitMaster.Panel1.SuspendLayout()
      Me.SplitMaster.Panel2.SuspendLayout()
      Me.SplitMaster.SuspendLayout()
      CType(Me.dgvImportMasterDeals, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.grpUpdateFlags.SuspendLayout()
      Me.grpImportFlags.SuspendLayout()
      CType(Me.dgvRetireMasterDeals, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'SplitMaster
      '
      Me.SplitMaster.CausesValidation = False
      Me.SplitMaster.Dock = System.Windows.Forms.DockStyle.Fill
      Me.SplitMaster.Location = New System.Drawing.Point(0, 0)
      Me.SplitMaster.Name = "SplitMaster"
      Me.SplitMaster.Orientation = System.Windows.Forms.Orientation.Horizontal
      '
      'SplitMaster.Panel1
      '
      Me.SplitMaster.Panel1.Controls.Add(Me.lblTargetDBs)
      Me.SplitMaster.Panel1.Controls.Add(Me.dgvImportMasterDeals)
      Me.SplitMaster.Panel1.Controls.Add(Me.lblGridHeader)
      Me.SplitMaster.Panel1.Controls.Add(Me.btnFolderBrowse)
      Me.SplitMaster.Panel1.Controls.Add(Me.txtSourceFolder)
      Me.SplitMaster.Panel1.Controls.Add(Me.lblSourceFolder)
      '
      'SplitMaster.Panel2
      '
      Me.SplitMaster.Panel2.Controls.Add(Me.btnClose)
      Me.SplitMaster.Panel2.Controls.Add(Me.btnImport)
      Me.SplitMaster.Panel2.Controls.Add(Me.grpUpdateFlags)
      Me.SplitMaster.Panel2.Controls.Add(Me.grpImportFlags)
      Me.SplitMaster.Panel2.Controls.Add(Me.dgvRetireMasterDeals)
      Me.SplitMaster.Panel2.Controls.Add(Me.lblGridHeaderMDR)
      Me.SplitMaster.Size = New System.Drawing.Size(688, 570)
      Me.SplitMaster.SplitterDistance = 242
      Me.SplitMaster.TabIndex = 0
      '
      'dgvImportMasterDeals
      '
      Me.dgvImportMasterDeals.AllowUserToAddRows = False
      Me.dgvImportMasterDeals.AllowUserToDeleteRows = False
      Me.dgvImportMasterDeals.AllowUserToOrderColumns = True
      DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle1.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvImportMasterDeals.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
      Me.dgvImportMasterDeals.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvImportMasterDeals.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
      Me.dgvImportMasterDeals.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      Me.dgvImportMasterDeals.Location = New System.Drawing.Point(8, 75)
      Me.dgvImportMasterDeals.Name = "dgvImportMasterDeals"
      Me.dgvImportMasterDeals.ReadOnly = True
      Me.dgvImportMasterDeals.RowHeadersWidth = 32
      Me.dgvImportMasterDeals.RowTemplate.Height = 18
      Me.dgvImportMasterDeals.RowTemplate.ReadOnly = True
      Me.dgvImportMasterDeals.Size = New System.Drawing.Size(673, 164)
      Me.dgvImportMasterDeals.TabIndex = 35
      '
      'lblGridHeader
      '
      Me.lblGridHeader.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblGridHeader.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblGridHeader.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
      Me.lblGridHeader.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblGridHeader.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
      Me.lblGridHeader.Location = New System.Drawing.Point(8, 56)
      Me.lblGridHeader.Name = "lblGridHeader"
      Me.lblGridHeader.Size = New System.Drawing.Size(673, 20)
      Me.lblGridHeader.TabIndex = 34
      Me.lblGridHeader.Text = "Bingo Master Deals to Import"
      Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'btnFolderBrowse
      '
      Me.btnFolderBrowse.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.btnFolderBrowse.CausesValidation = False
      Me.btnFolderBrowse.Location = New System.Drawing.Point(621, 29)
      Me.btnFolderBrowse.Name = "btnFolderBrowse"
      Me.btnFolderBrowse.Size = New System.Drawing.Size(60, 22)
      Me.btnFolderBrowse.TabIndex = 3
      Me.btnFolderBrowse.Text = "&Browse"
      '
      'txtSourceFolder
      '
      Me.txtSourceFolder.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtSourceFolder.CausesValidation = False
      Me.txtSourceFolder.Location = New System.Drawing.Point(97, 7)
      Me.txtSourceFolder.Name = "txtSourceFolder"
      Me.txtSourceFolder.ReadOnly = True
      Me.txtSourceFolder.Size = New System.Drawing.Size(584, 20)
      Me.txtSourceFolder.TabIndex = 2
      '
      'lblSourceFolder
      '
      Me.lblSourceFolder.CausesValidation = False
      Me.lblSourceFolder.Location = New System.Drawing.Point(16, 9)
      Me.lblSourceFolder.Name = "lblSourceFolder"
      Me.lblSourceFolder.Size = New System.Drawing.Size(80, 16)
      Me.lblSourceFolder.TabIndex = 1
      Me.lblSourceFolder.Text = "Source Folder:"
      Me.lblSourceFolder.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(360, 280)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(60, 23)
      Me.btnClose.TabIndex = 40
      Me.btnClose.Text = "&Close"
      '
      'btnImport
      '
      Me.btnImport.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnImport.CausesValidation = False
      Me.btnImport.Enabled = False
      Me.btnImport.Location = New System.Drawing.Point(256, 280)
      Me.btnImport.Name = "btnImport"
      Me.btnImport.Size = New System.Drawing.Size(60, 23)
      Me.btnImport.TabIndex = 39
      Me.btnImport.Text = "&Import"
      '
      'grpUpdateFlags
      '
      Me.grpUpdateFlags.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
      Me.grpUpdateFlags.CausesValidation = False
      Me.grpUpdateFlags.Controls.Add(Me.cbWinningTiersUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbFormsUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbGameSetupUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbDenomToGTUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbLinesBetToGTUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbCoinsBetToGTUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbPayscaleTiersUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbPayscaleUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbGameTypeUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbMachineUpdate)
      Me.grpUpdateFlags.Controls.Add(Me.cbBankUpdate)
      Me.grpUpdateFlags.Location = New System.Drawing.Point(168, 148)
      Me.grpUpdateFlags.Name = "grpUpdateFlags"
      Me.grpUpdateFlags.Size = New System.Drawing.Size(424, 128)
      Me.grpUpdateFlags.TabIndex = 38
      Me.grpUpdateFlags.TabStop = False
      Me.grpUpdateFlags.Text = "Update Flags"
      '
      'cbWinningTiersUpdate
      '
      Me.cbWinningTiersUpdate.AutoCheck = False
      Me.cbWinningTiersUpdate.CausesValidation = False
      Me.cbWinningTiersUpdate.Location = New System.Drawing.Point(292, 72)
      Me.cbWinningTiersUpdate.Name = "cbWinningTiersUpdate"
      Me.cbWinningTiersUpdate.Size = New System.Drawing.Size(120, 17)
      Me.cbWinningTiersUpdate.TabIndex = 10
      Me.cbWinningTiersUpdate.TabStop = False
      Me.cbWinningTiersUpdate.Text = "Winning Tiers"
      '
      'cbFormsUpdate
      '
      Me.cbFormsUpdate.AutoCheck = False
      Me.cbFormsUpdate.CausesValidation = False
      Me.cbFormsUpdate.Location = New System.Drawing.Point(292, 48)
      Me.cbFormsUpdate.Name = "cbFormsUpdate"
      Me.cbFormsUpdate.Size = New System.Drawing.Size(120, 17)
      Me.cbFormsUpdate.TabIndex = 9
      Me.cbFormsUpdate.TabStop = False
      Me.cbFormsUpdate.Text = "Forms"
      '
      'cbGameSetupUpdate
      '
      Me.cbGameSetupUpdate.AutoCheck = False
      Me.cbGameSetupUpdate.CausesValidation = False
      Me.cbGameSetupUpdate.Location = New System.Drawing.Point(292, 24)
      Me.cbGameSetupUpdate.Name = "cbGameSetupUpdate"
      Me.cbGameSetupUpdate.Size = New System.Drawing.Size(120, 17)
      Me.cbGameSetupUpdate.TabIndex = 8
      Me.cbGameSetupUpdate.TabStop = False
      Me.cbGameSetupUpdate.Text = "Game Setups"
      '
      'cbDenomToGTUpdate
      '
      Me.cbDenomToGTUpdate.AutoCheck = False
      Me.cbDenomToGTUpdate.CausesValidation = False
      Me.cbDenomToGTUpdate.Location = New System.Drawing.Point(130, 48)
      Me.cbDenomToGTUpdate.Name = "cbDenomToGTUpdate"
      Me.cbDenomToGTUpdate.Size = New System.Drawing.Size(136, 17)
      Me.cbDenomToGTUpdate.TabIndex = 5
      Me.cbDenomToGTUpdate.TabStop = False
      Me.cbDenomToGTUpdate.Text = "Game Type Denoms"
      '
      'cbLinesBetToGTUpdate
      '
      Me.cbLinesBetToGTUpdate.AutoCheck = False
      Me.cbLinesBetToGTUpdate.CausesValidation = False
      Me.cbLinesBetToGTUpdate.Location = New System.Drawing.Point(130, 96)
      Me.cbLinesBetToGTUpdate.Name = "cbLinesBetToGTUpdate"
      Me.cbLinesBetToGTUpdate.Size = New System.Drawing.Size(134, 17)
      Me.cbLinesBetToGTUpdate.TabIndex = 7
      Me.cbLinesBetToGTUpdate.TabStop = False
      Me.cbLinesBetToGTUpdate.Text = "Game Type Lines Bet"
      '
      'cbCoinsBetToGTUpdate
      '
      Me.cbCoinsBetToGTUpdate.AutoCheck = False
      Me.cbCoinsBetToGTUpdate.CausesValidation = False
      Me.cbCoinsBetToGTUpdate.Location = New System.Drawing.Point(130, 72)
      Me.cbCoinsBetToGTUpdate.Name = "cbCoinsBetToGTUpdate"
      Me.cbCoinsBetToGTUpdate.Size = New System.Drawing.Size(134, 17)
      Me.cbCoinsBetToGTUpdate.TabIndex = 6
      Me.cbCoinsBetToGTUpdate.TabStop = False
      Me.cbCoinsBetToGTUpdate.Text = "Game Type Coins Bet"
      '
      'cbPayscaleTiersUpdate
      '
      Me.cbPayscaleTiersUpdate.AutoCheck = False
      Me.cbPayscaleTiersUpdate.CausesValidation = False
      Me.cbPayscaleTiersUpdate.Location = New System.Drawing.Point(130, 24)
      Me.cbPayscaleTiersUpdate.Name = "cbPayscaleTiersUpdate"
      Me.cbPayscaleTiersUpdate.Size = New System.Drawing.Size(104, 17)
      Me.cbPayscaleTiersUpdate.TabIndex = 4
      Me.cbPayscaleTiersUpdate.TabStop = False
      Me.cbPayscaleTiersUpdate.Text = "Payscale Tiers"
      '
      'cbPayscaleUpdate
      '
      Me.cbPayscaleUpdate.AutoCheck = False
      Me.cbPayscaleUpdate.CausesValidation = False
      Me.cbPayscaleUpdate.Location = New System.Drawing.Point(20, 96)
      Me.cbPayscaleUpdate.Name = "cbPayscaleUpdate"
      Me.cbPayscaleUpdate.Size = New System.Drawing.Size(104, 17)
      Me.cbPayscaleUpdate.TabIndex = 3
      Me.cbPayscaleUpdate.TabStop = False
      Me.cbPayscaleUpdate.Text = "Payscale"
      '
      'cbGameTypeUpdate
      '
      Me.cbGameTypeUpdate.AutoCheck = False
      Me.cbGameTypeUpdate.CausesValidation = False
      Me.cbGameTypeUpdate.Location = New System.Drawing.Point(20, 72)
      Me.cbGameTypeUpdate.Name = "cbGameTypeUpdate"
      Me.cbGameTypeUpdate.Size = New System.Drawing.Size(104, 17)
      Me.cbGameTypeUpdate.TabIndex = 2
      Me.cbGameTypeUpdate.TabStop = False
      Me.cbGameTypeUpdate.Text = "Game Type"
      '
      'cbMachineUpdate
      '
      Me.cbMachineUpdate.AutoCheck = False
      Me.cbMachineUpdate.CausesValidation = False
      Me.cbMachineUpdate.Location = New System.Drawing.Point(20, 48)
      Me.cbMachineUpdate.Name = "cbMachineUpdate"
      Me.cbMachineUpdate.Size = New System.Drawing.Size(104, 17)
      Me.cbMachineUpdate.TabIndex = 1
      Me.cbMachineUpdate.TabStop = False
      Me.cbMachineUpdate.Text = "Machine"
      '
      'cbBankUpdate
      '
      Me.cbBankUpdate.AutoCheck = False
      Me.cbBankUpdate.CausesValidation = False
      Me.cbBankUpdate.Location = New System.Drawing.Point(20, 24)
      Me.cbBankUpdate.Name = "cbBankUpdate"
      Me.cbBankUpdate.Size = New System.Drawing.Size(104, 17)
      Me.cbBankUpdate.TabIndex = 0
      Me.cbBankUpdate.TabStop = False
      Me.cbBankUpdate.Text = "Bank"
      '
      'grpImportFlags
      '
      Me.grpImportFlags.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
      Me.grpImportFlags.CausesValidation = False
      Me.grpImportFlags.Controls.Add(Me.cbEnforceIS)
      Me.grpImportFlags.Controls.Add(Me.cbBankMach)
      Me.grpImportFlags.Controls.Add(Me.cbCasino)
      Me.grpImportFlags.Location = New System.Drawing.Point(8, 148)
      Me.grpImportFlags.Name = "grpImportFlags"
      Me.grpImportFlags.Size = New System.Drawing.Size(152, 102)
      Me.grpImportFlags.TabIndex = 37
      Me.grpImportFlags.TabStop = False
      Me.grpImportFlags.Text = "Import Flags"
      '
      'cbEnforceIS
      '
      Me.cbEnforceIS.AutoCheck = False
      Me.cbEnforceIS.CausesValidation = False
      Me.cbEnforceIS.Location = New System.Drawing.Point(9, 72)
      Me.cbEnforceIS.Name = "cbEnforceIS"
      Me.cbEnforceIS.Size = New System.Drawing.Size(135, 16)
      Me.cbEnforceIS.TabIndex = 2
      Me.cbEnforceIS.TabStop = False
      Me.cbEnforceIS.Text = "Enforce Secure Import"
      '
      'cbBankMach
      '
      Me.cbBankMach.AutoCheck = False
      Me.cbBankMach.CausesValidation = False
      Me.cbBankMach.Location = New System.Drawing.Point(9, 48)
      Me.cbBankMach.Name = "cbBankMach"
      Me.cbBankMach.Size = New System.Drawing.Size(135, 17)
      Me.cbBankMach.TabIndex = 1
      Me.cbBankMach.TabStop = False
      Me.cbBankMach.Text = "Bank / Machine tables"
      '
      'cbCasino
      '
      Me.cbCasino.AutoCheck = False
      Me.cbCasino.CausesValidation = False
      Me.cbCasino.Location = New System.Drawing.Point(9, 24)
      Me.cbCasino.Name = "cbCasino"
      Me.cbCasino.Size = New System.Drawing.Size(135, 17)
      Me.cbCasino.TabIndex = 0
      Me.cbCasino.TabStop = False
      Me.cbCasino.Text = "Casino table"
      '
      'dgvRetireMasterDeals
      '
      Me.dgvRetireMasterDeals.AllowUserToAddRows = False
      Me.dgvRetireMasterDeals.AllowUserToDeleteRows = False
      Me.dgvRetireMasterDeals.AllowUserToOrderColumns = True
      DataGridViewCellStyle3.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle3.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvRetireMasterDeals.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle3
      Me.dgvRetireMasterDeals.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      DataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle4.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvRetireMasterDeals.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle4
      Me.dgvRetireMasterDeals.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      Me.dgvRetireMasterDeals.Location = New System.Drawing.Point(8, 30)
      Me.dgvRetireMasterDeals.Name = "dgvRetireMasterDeals"
      Me.dgvRetireMasterDeals.ReadOnly = True
      Me.dgvRetireMasterDeals.RowHeadersWidth = 32
      Me.dgvRetireMasterDeals.RowTemplate.Height = 18
      Me.dgvRetireMasterDeals.RowTemplate.ReadOnly = True
      Me.dgvRetireMasterDeals.Size = New System.Drawing.Size(673, 112)
      Me.dgvRetireMasterDeals.TabIndex = 36
      '
      'lblGridHeaderMDR
      '
      Me.lblGridHeaderMDR.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblGridHeaderMDR.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblGridHeaderMDR.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
      Me.lblGridHeaderMDR.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblGridHeaderMDR.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
      Me.lblGridHeaderMDR.Location = New System.Drawing.Point(8, 11)
      Me.lblGridHeaderMDR.Name = "lblGridHeaderMDR"
      Me.lblGridHeaderMDR.Size = New System.Drawing.Size(673, 20)
      Me.lblGridHeaderMDR.TabIndex = 35
      Me.lblGridHeaderMDR.Text = "Bingo Master Deals to Retire"
      Me.lblGridHeaderMDR.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'sbrStatus
      '
      Me.sbrStatus.CausesValidation = False
      Me.sbrStatus.Location = New System.Drawing.Point(0, 552)
      Me.sbrStatus.Name = "sbrStatus"
      Me.sbrStatus.Size = New System.Drawing.Size(688, 18)
      Me.sbrStatus.TabIndex = 9
      '
      'FolderBrowserDlg
      '
      Me.FolderBrowserDlg.Description = "Select the Source Folder that contains the files to import."
      '
      'lblTargetDBs
      '
      Me.lblTargetDBs.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblTargetDBs.CausesValidation = False
      Me.lblTargetDBs.Location = New System.Drawing.Point(74, 32)
      Me.lblTargetDBs.Name = "lblTargetDBs"
      Me.lblTargetDBs.Size = New System.Drawing.Size(540, 18)
      Me.lblTargetDBs.TabIndex = 36
      Me.lblTargetDBs.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'BingoMasterImport
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(688, 570)
      Me.Controls.Add(Me.sbrStatus)
      Me.Controls.Add(Me.SplitMaster)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "BingoMasterImport"
      Me.Text = "Import Bingo Master Deals"
      Me.SplitMaster.Panel1.ResumeLayout(False)
      Me.SplitMaster.Panel1.PerformLayout()
      Me.SplitMaster.Panel2.ResumeLayout(False)
      Me.SplitMaster.ResumeLayout(False)
      CType(Me.dgvImportMasterDeals, System.ComponentModel.ISupportInitialize).EndInit()
      Me.grpUpdateFlags.ResumeLayout(False)
      Me.grpImportFlags.ResumeLayout(False)
      CType(Me.dgvRetireMasterDeals, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents SplitMaster As System.Windows.Forms.SplitContainer
   Friend WithEvents lblSourceFolder As System.Windows.Forms.Label
   Friend WithEvents txtSourceFolder As System.Windows.Forms.TextBox
   Friend WithEvents btnFolderBrowse As System.Windows.Forms.Button
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
   Friend WithEvents lblGridHeaderMDR As System.Windows.Forms.Label
   Friend WithEvents dgvImportMasterDeals As System.Windows.Forms.DataGridView
   Friend WithEvents dgvRetireMasterDeals As System.Windows.Forms.DataGridView
   Friend WithEvents grpImportFlags As System.Windows.Forms.GroupBox
   Friend WithEvents cbBankMach As System.Windows.Forms.CheckBox
   Friend WithEvents cbCasino As System.Windows.Forms.CheckBox
   Friend WithEvents grpUpdateFlags As System.Windows.Forms.GroupBox
   Friend WithEvents cbWinningTiersUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbFormsUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbGameSetupUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbDenomToGTUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbLinesBetToGTUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbCoinsBetToGTUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbPayscaleTiersUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbPayscaleUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbGameTypeUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbMachineUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbBankUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents btnImport As System.Windows.Forms.Button
   Friend WithEvents sbrStatus As System.Windows.Forms.StatusBar
   Friend WithEvents FolderBrowserDlg As System.Windows.Forms.FolderBrowserDialog
   Friend WithEvents cbEnforceIS As System.Windows.Forms.CheckBox
   Friend WithEvents lblTargetDBs As System.Windows.Forms.Label
End Class
