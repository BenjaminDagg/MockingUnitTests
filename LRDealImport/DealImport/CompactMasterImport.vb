Imports System.Text
Imports System.ServiceProcess

Public Class CompactMasterImport
   Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

   Public Sub New()
      MyBase.New()

      'This call is required by the Windows Form Designer.
      InitializeComponent()

      'Add any initialization after the InitializeComponent() call

   End Sub

   'Form overrides dispose to clean up the component list.
   Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
      If disposing Then
         If Not (components Is Nothing) Then
            components.Dispose()
         End If
      End If
      MyBase.Dispose(disposing)
   End Sub

   'Required by the Windows Form Designer
   Private components As System.ComponentModel.IContainer

   'NOTE: The following procedure is required by the Windows Form Designer
   'It can be modified using the Windows Form Designer.  
   'Do not modify it using the code editor.
   Friend WithEvents sbrStatus As System.Windows.Forms.StatusBar
   Friend WithEvents FolderBrowserDlg As System.Windows.Forms.FolderBrowserDialog
   Friend WithEvents SplitMaster As System.Windows.Forms.SplitContainer
   Friend WithEvents lblSourceFolder As System.Windows.Forms.Label
   Friend WithEvents btnFolderBrowse As System.Windows.Forms.Button
   Friend WithEvents txtSourceFolder As System.Windows.Forms.TextBox
   Friend WithEvents DGRetireMasterDeals As System.Windows.Forms.DataGrid
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents btnImport As System.Windows.Forms.Button
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
   Friend WithEvents grpImportFlags As System.Windows.Forms.GroupBox
   Friend WithEvents cbBankMach As System.Windows.Forms.CheckBox
   Friend WithEvents cbCasino As System.Windows.Forms.CheckBox
   Friend WithEvents cbFlareUpdate As System.Windows.Forms.CheckBox
   Friend WithEvents cbEnforceIS As System.Windows.Forms.CheckBox
   Friend WithEvents lblTargetDBs As System.Windows.Forms.Label
   Friend WithEvents DGImportMasterDeals As System.Windows.Forms.DataGrid
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(CompactMasterImport))
      Me.sbrStatus = New System.Windows.Forms.StatusBar
      Me.FolderBrowserDlg = New System.Windows.Forms.FolderBrowserDialog
      Me.SplitMaster = New System.Windows.Forms.SplitContainer
      Me.lblTargetDBs = New System.Windows.Forms.Label
      Me.DGImportMasterDeals = New System.Windows.Forms.DataGrid
      Me.lblSourceFolder = New System.Windows.Forms.Label
      Me.btnFolderBrowse = New System.Windows.Forms.Button
      Me.txtSourceFolder = New System.Windows.Forms.TextBox
      Me.btnClose = New System.Windows.Forms.Button
      Me.btnImport = New System.Windows.Forms.Button
      Me.grpUpdateFlags = New System.Windows.Forms.GroupBox
      Me.cbFlareUpdate = New System.Windows.Forms.CheckBox
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
      Me.DGRetireMasterDeals = New System.Windows.Forms.DataGrid
      Me.SplitMaster.Panel1.SuspendLayout()
      Me.SplitMaster.Panel2.SuspendLayout()
      Me.SplitMaster.SuspendLayout()
      CType(Me.DGImportMasterDeals, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.grpUpdateFlags.SuspendLayout()
      Me.grpImportFlags.SuspendLayout()
      CType(Me.DGRetireMasterDeals, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'sbrStatus
      '
      Me.sbrStatus.CausesValidation = False
      Me.sbrStatus.Location = New System.Drawing.Point(0, 552)
      Me.sbrStatus.Name = "sbrStatus"
      Me.sbrStatus.Size = New System.Drawing.Size(753, 18)
      Me.sbrStatus.TabIndex = 8
      '
      'FolderBrowserDlg
      '
      Me.FolderBrowserDlg.Description = "Select the Source Folder that contains the files to import."
      '
      'SplitMaster
      '
      Me.SplitMaster.Dock = System.Windows.Forms.DockStyle.Fill
      Me.SplitMaster.Location = New System.Drawing.Point(0, 0)
      Me.SplitMaster.Name = "SplitMaster"
      Me.SplitMaster.Orientation = System.Windows.Forms.Orientation.Horizontal
      '
      'SplitMaster.Panel1
      '
      Me.SplitMaster.Panel1.CausesValidation = False
      Me.SplitMaster.Panel1.Controls.Add(Me.lblTargetDBs)
      Me.SplitMaster.Panel1.Controls.Add(Me.DGImportMasterDeals)
      Me.SplitMaster.Panel1.Controls.Add(Me.lblSourceFolder)
      Me.SplitMaster.Panel1.Controls.Add(Me.btnFolderBrowse)
      Me.SplitMaster.Panel1.Controls.Add(Me.txtSourceFolder)
      Me.SplitMaster.Panel1MinSize = 100
      '
      'SplitMaster.Panel2
      '
      Me.SplitMaster.Panel2.CausesValidation = False
      Me.SplitMaster.Panel2.Controls.Add(Me.btnClose)
      Me.SplitMaster.Panel2.Controls.Add(Me.btnImport)
      Me.SplitMaster.Panel2.Controls.Add(Me.grpUpdateFlags)
      Me.SplitMaster.Panel2.Controls.Add(Me.grpImportFlags)
      Me.SplitMaster.Panel2.Controls.Add(Me.DGRetireMasterDeals)
      Me.SplitMaster.Panel2MinSize = 100
      Me.SplitMaster.Size = New System.Drawing.Size(753, 552)
      Me.SplitMaster.SplitterDistance = 218
      Me.SplitMaster.TabIndex = 10
      '
      'lblTargetDBs
      '
      Me.lblTargetDBs.CausesValidation = False
      Me.lblTargetDBs.Location = New System.Drawing.Point(97, 35)
      Me.lblTargetDBs.Name = "lblTargetDBs"
      Me.lblTargetDBs.Size = New System.Drawing.Size(559, 18)
      Me.lblTargetDBs.TabIndex = 8
      Me.lblTargetDBs.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'DGImportMasterDeals
      '
      Me.DGImportMasterDeals.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.DGImportMasterDeals.CaptionFont = New System.Drawing.Font("Tahoma", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.DGImportMasterDeals.CaptionText = "Master Deals - Import"
      Me.DGImportMasterDeals.CausesValidation = False
      Me.DGImportMasterDeals.DataMember = ""
      Me.DGImportMasterDeals.HeaderForeColor = System.Drawing.SystemColors.ControlText
      Me.DGImportMasterDeals.Location = New System.Drawing.Point(8, 61)
      Me.DGImportMasterDeals.Name = "DGImportMasterDeals"
      Me.DGImportMasterDeals.ReadOnly = True
      Me.DGImportMasterDeals.Size = New System.Drawing.Size(733, 154)
      Me.DGImportMasterDeals.TabIndex = 6
      '
      'lblSourceFolder
      '
      Me.lblSourceFolder.CausesValidation = False
      Me.lblSourceFolder.Location = New System.Drawing.Point(16, 9)
      Me.lblSourceFolder.Name = "lblSourceFolder"
      Me.lblSourceFolder.Size = New System.Drawing.Size(80, 16)
      Me.lblSourceFolder.TabIndex = 3
      Me.lblSourceFolder.Text = "Source Folder:"
      Me.lblSourceFolder.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'btnFolderBrowse
      '
      Me.btnFolderBrowse.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.btnFolderBrowse.CausesValidation = False
      Me.btnFolderBrowse.Location = New System.Drawing.Point(681, 33)
      Me.btnFolderBrowse.Name = "btnFolderBrowse"
      Me.btnFolderBrowse.Size = New System.Drawing.Size(60, 22)
      Me.btnFolderBrowse.TabIndex = 5
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
      Me.txtSourceFolder.Size = New System.Drawing.Size(644, 20)
      Me.txtSourceFolder.TabIndex = 4
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(407, 290)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(60, 23)
      Me.btnClose.TabIndex = 14
      Me.btnClose.Text = "&Close"
      '
      'btnImport
      '
      Me.btnImport.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnImport.CausesValidation = False
      Me.btnImport.Enabled = False
      Me.btnImport.Location = New System.Drawing.Point(303, 290)
      Me.btnImport.Name = "btnImport"
      Me.btnImport.Size = New System.Drawing.Size(60, 23)
      Me.btnImport.TabIndex = 13
      Me.btnImport.Text = "&Import"
      '
      'grpUpdateFlags
      '
      Me.grpUpdateFlags.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
      Me.grpUpdateFlags.CausesValidation = False
      Me.grpUpdateFlags.Controls.Add(Me.cbFlareUpdate)
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
      Me.grpUpdateFlags.Location = New System.Drawing.Point(179, 154)
      Me.grpUpdateFlags.Name = "grpUpdateFlags"
      Me.grpUpdateFlags.Size = New System.Drawing.Size(424, 128)
      Me.grpUpdateFlags.TabIndex = 12
      Me.grpUpdateFlags.TabStop = False
      Me.grpUpdateFlags.Text = "Update Flags"
      '
      'cbFlareUpdate
      '
      Me.cbFlareUpdate.AutoCheck = False
      Me.cbFlareUpdate.CausesValidation = False
      Me.cbFlareUpdate.Location = New System.Drawing.Point(312, 96)
      Me.cbFlareUpdate.Name = "cbFlareUpdate"
      Me.cbFlareUpdate.Size = New System.Drawing.Size(100, 17)
      Me.cbFlareUpdate.TabIndex = 11
      Me.cbFlareUpdate.TabStop = False
      Me.cbFlareUpdate.Text = "Flares"
      '
      'cbWinningTiersUpdate
      '
      Me.cbWinningTiersUpdate.AutoCheck = False
      Me.cbWinningTiersUpdate.CausesValidation = False
      Me.cbWinningTiersUpdate.Location = New System.Drawing.Point(312, 72)
      Me.cbWinningTiersUpdate.Name = "cbWinningTiersUpdate"
      Me.cbWinningTiersUpdate.Size = New System.Drawing.Size(100, 17)
      Me.cbWinningTiersUpdate.TabIndex = 10
      Me.cbWinningTiersUpdate.TabStop = False
      Me.cbWinningTiersUpdate.Text = "Winning Tiers"
      '
      'cbFormsUpdate
      '
      Me.cbFormsUpdate.AutoCheck = False
      Me.cbFormsUpdate.CausesValidation = False
      Me.cbFormsUpdate.Location = New System.Drawing.Point(312, 48)
      Me.cbFormsUpdate.Name = "cbFormsUpdate"
      Me.cbFormsUpdate.Size = New System.Drawing.Size(100, 17)
      Me.cbFormsUpdate.TabIndex = 9
      Me.cbFormsUpdate.TabStop = False
      Me.cbFormsUpdate.Text = "Forms"
      '
      'cbGameSetupUpdate
      '
      Me.cbGameSetupUpdate.AutoCheck = False
      Me.cbGameSetupUpdate.CausesValidation = False
      Me.cbGameSetupUpdate.Location = New System.Drawing.Point(312, 24)
      Me.cbGameSetupUpdate.Name = "cbGameSetupUpdate"
      Me.cbGameSetupUpdate.Size = New System.Drawing.Size(100, 17)
      Me.cbGameSetupUpdate.TabIndex = 8
      Me.cbGameSetupUpdate.TabStop = False
      Me.cbGameSetupUpdate.Text = "Game Setups"
      '
      'cbDenomToGTUpdate
      '
      Me.cbDenomToGTUpdate.AutoCheck = False
      Me.cbDenomToGTUpdate.CausesValidation = False
      Me.cbDenomToGTUpdate.Location = New System.Drawing.Point(147, 48)
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
      Me.cbLinesBetToGTUpdate.Location = New System.Drawing.Point(147, 96)
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
      Me.cbCoinsBetToGTUpdate.Location = New System.Drawing.Point(147, 72)
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
      Me.cbPayscaleTiersUpdate.Location = New System.Drawing.Point(147, 24)
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
      Me.grpImportFlags.Location = New System.Drawing.Point(11, 154)
      Me.grpImportFlags.Name = "grpImportFlags"
      Me.grpImportFlags.Size = New System.Drawing.Size(152, 102)
      Me.grpImportFlags.TabIndex = 11
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
      Me.cbBankMach.Size = New System.Drawing.Size(135, 16)
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
      Me.cbCasino.Size = New System.Drawing.Size(135, 16)
      Me.cbCasino.TabIndex = 0
      Me.cbCasino.TabStop = False
      Me.cbCasino.Text = "Casino table"
      '
      'DGRetireMasterDeals
      '
      Me.DGRetireMasterDeals.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.DGRetireMasterDeals.CaptionFont = New System.Drawing.Font("Tahoma", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.DGRetireMasterDeals.CaptionText = "Master Deals - Retire"
      Me.DGRetireMasterDeals.CausesValidation = False
      Me.DGRetireMasterDeals.DataMember = ""
      Me.DGRetireMasterDeals.HeaderForeColor = System.Drawing.SystemColors.ControlText
      Me.DGRetireMasterDeals.Location = New System.Drawing.Point(8, 3)
      Me.DGRetireMasterDeals.Name = "DGRetireMasterDeals"
      Me.DGRetireMasterDeals.ReadOnly = True
      Me.DGRetireMasterDeals.Size = New System.Drawing.Size(733, 145)
      Me.DGRetireMasterDeals.TabIndex = 10
      '
      'CompactMasterImport
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(753, 570)
      Me.Controls.Add(Me.SplitMaster)
      Me.Controls.Add(Me.sbrStatus)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "CompactMasterImport"
      Me.Text = "Import EZTab 2.0 and SkilTab Master Deals"
      Me.SplitMaster.Panel1.ResumeLayout(False)
      Me.SplitMaster.Panel1.PerformLayout()
      Me.SplitMaster.Panel2.ResumeLayout(False)
      Me.SplitMaster.ResumeLayout(False)
      CType(Me.DGImportMasterDeals, System.ComponentModel.ISupportInitialize).EndInit()
      Me.grpUpdateFlags.ResumeLayout(False)
      Me.grpImportFlags.ResumeLayout(False)
      CType(Me.DGRetireMasterDeals, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private mDSCasinoSetupData As DataSet     ' Will contain data from CasinoSetupData.xml in user selected folder.
   Private mDSApprovedMDSetup As DataSet     ' Will contain data from CasinoSetupData.xml on approved CD or DVD ROM.
   Private mDSRetireMD As DataSet

   Private mImportFlags As New ImportFlags

   Private mImportDealSQLBase As String
   Private mSourceBaseFileName As String = "CasinoSetupData.xml"
   Private mSourceFolder As String
   Private mSourceFolderCD As String

   Private mImportMDHistoryID As Integer
   Private mRetireCount As Integer

   Private mBusy As Boolean = False

   Private Sub btnFolderBrowse_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
      Handles btnFolderBrowse.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Browse button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""
      Dim lMRUFolder As String = ""
      Dim lSelectedFolder As String
      Dim lSourceFile As String
      Dim lUserMsg As String

      ' Set the last source folder lookup key based upon the import type...
      ' Importing Compact Masters (Distribution Master Deal files).

      ' If we have a lookup key, see if there is a value in the config file...
      lMRUFolder = My.Settings.LastDMDFolder

      ' Setup Folder Browser dialog control so user can select the source folder.
      With FolderBrowserDlg
         .RootFolder = Environment.SpecialFolder.MyComputer
         If lMRUFolder.Length > 0 Then .SelectedPath = lMRUFolder
         If .ShowDialog() = DialogResult.OK Then
            ' Store the selected Folder name.
            lSelectedFolder = .SelectedPath

            ' Build the fully qualified xml source file name.
            lSourceFile = Path.Combine(lSelectedFolder, mSourceBaseFileName)

            ' We expect to find the xml file in the selected folder.
            If File.Exists(lSourceFile) Then
               ' Reset the text in the Source Folder TextBox control.
               mSourceFolder = lSelectedFolder
               txtSourceFolder.Text = mSourceFolder

               ' Load the file, the grid, the dataset (mDSCasinoSetupData), and the import flags (mImportFlags)...
               If LoadDataSet(lSourceFile) Then
                  ' Load the retirees grid.
                  Call LoadMasterDealRetireGridDMD()
               End If

               ' Save the selected folder in the config file as most recently used...
               If Not lSelectedFolder Is Nothing Then
                  With My.Settings
                     .LastDMDFolder = lSelectedFolder
                     .Save()
                  End With
               End If
            Else
               ' Source file was not found...
               lUserMsg = "Invalid Folder, import file does not exist in the selected folder."
               MessageBox.Show(lUserMsg, "Source Folder Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
         End If
      End With

   End Sub

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
      Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Me.Close()

   End Sub

   Private Sub btnImport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
      Handles btnImport.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Import button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturnCode As Boolean = True
      Dim lServiceWasOn As Boolean = False

      Dim lExistingDealCount As Integer = 0

      Dim lErrorText As String = ""
      Dim lServiceName As String = ""

      ' Disable the Import and Close buttons...
      With btnImport
         .Enabled = False
         .Refresh()
      End With

      With btnClose
         .Enabled = False
         .Refresh()
      End With

      ' Store the Casino database version.
      gDatabaseVersion = GetCasinoDBVersion()

      ' Do we have the minimum expected version?
      If gDatabaseVersion >= gMinimumDBVersionInt Then
         ' Yes, so we can continue.
         ' Do we have a valid import stored procedure set in the LotteryRetail database?
         If IsValidImportProcedureSetMD(lErrorText) Then
            ' Yes, so we can continue.
            ' Get the Deal Server Service name so we can stop it if it is running.
            lServiceName = My.Settings.DealServerServiceName
            If String.IsNullOrEmpty(lServiceName) Then lServiceName = "DGE Deal Server"

            ' Turn off the DealServer Service if it is running.
            sbrStatus.Text = String.Format("Stopping Service {0}...", lServiceName)
            lServiceWasOn = StopService(lServiceName)

            ' Disable the Import button.
            btnImport.Enabled = False

            ' Create an IMPORT_MD_HISTORY record.
            lReturnCode = CreateImportMDHistoryRow(lErrorText)

            If lReturnCode Then
               ' Do we have Master Deals to retire?
               If mRetireCount > 0 Then
                  ' Yes, so call RetireMasterDeals...
                  sbrStatus.Text = "Retiring Master Deals..."
                  lReturnCode = RetireMasterDealsDMD(lErrorText)
               End If
            End If

            If Not lReturnCode Then
               ' CreateImportMDHistoryRow or RetireMasterDeals failed.  Log the error.
               Logging.Log(lErrorText)

               ' Restart the DGE Deal Service if it was stopped.
               If lServiceWasOn Then
                  sbrStatus.Text = String.Format("Restarting Service {0}...", lServiceName)
                  lReturnCode = StartService(lServiceName)
               End If

               ' Show the error message.
               MessageBox.Show(lErrorText, "Retire Master Deal Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

               ' Enable the Close button.
               btnClose.Enabled = True

               ' Exit this routine.
               Exit Sub
            End If

            ' Load Master Deal Tables.
            ' The LoadMasterDeals function attempts to create and populate a DMD Master Deal table.
            lReturnCode = LoadMasterDeals()
            If lReturnCode Then
               ' Load Setup data.
               '  The LoadSetupData function attempts to update LotteryRetail database tables.
               lReturnCode = LoadSetupData()

               ' If the load was successful, reset the success flag in the ImportHistoryMD table.
               If lReturnCode Then
                  Call SetImportSuccessFlag()
               Else
                  ' Load of Setup data failed, attempt to drop any DMD tables created.
                  Call DropMasterDealTables()
               End If

               ' Restart the DGE Deal Service if it was stopped.
               If lServiceWasOn Then
                  sbrStatus.Text = String.Format("Restarting Service {0}...", lServiceName)
                  lReturnCode = StartService(lServiceName)
               End If

               ' Reset status text.
               sbrStatus.Text = "Finished"

               Try
                  ' Launch the Master Deal Import Report...
                  Dim lRVRSL As New ReportViewRSLocal

                  ' Retrieve report data.
                  Dim lSDA As New SqlDataAccess(gConnectRetail, False, 90)
                  Dim lDT As DataTable
                  lDT = lSDA.CreateDataTable(String.Format("EXEC rpt_MasterDealImport {0}", mImportMDHistoryID))

                  ' Drop the connection to the LotteryRetail database.
                  If Not lSDA Is Nothing Then lSDA.Dispose()

                  ' Show the report...
                  With lRVRSL
                     .MdiParent = Me.MdiParent
                     .ShowReport(lDT, "Master Deal Import Report")
                     .Show()
                  End With

               Catch ex As Exception
                  ' Handle the error.
                  lErrorText = Me.Name & "::btnImport_Click: " & ex.Message
                  Logging.Log(lErrorText)
                  MessageBox.Show(lErrorText, "Master Deal Import Report Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
               End Try

            Else
               ' LoadMasterDeals function returned False.
               sbrStatus.Text = "Finished with errors, check the log file."
            End If
         Else
            ' We don't have the expected set of import stored procedures.
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Master Deal Import Report Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End If

      Else
         ' DB Version too low, show the user.
         lErrorText = String.Format("Casino database version {0} or higher is required.", gMinimumDBVersionText)
         MessageBox.Show(lErrorText, "Master Deal Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Enable the Import and Close buttons...
      btnClose.Enabled = True
      btnImport.Enabled = True

   End Sub

   Private Sub Me_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If mBusy Then
         ' Busy, cancel close.
         e.Cancel = True
      Else
         Try
            ' Save window state info for next time this form is opened.
            ConfigFile.SetWindowState(Me)
         Catch ex As Exception
            ' Ignore this exception.
         End Try
      End If

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Build the base SQL Insert statement for the IMPORT_MD_DETAIL table.
      mImportDealSQLBase = "INSERT INTO IMPORT_MD_DETAIL " & _
         "(IMPORT_MD_HISTORY_ID, TABLE_NAME, DETAIL_TEXT, INSERT_COUNT, UPDATE_COUNT, IGNORED_COUNT, ERROR_COUNT) " & _
         "VALUES ({0},'{1}','{2}',{3},{4},{5},{6})"

      ' Set the Window caption text...
      Me.Text = "Import EZTab 2.0 and SkilTab Master Deals for Casino " & gDefaultCasinoID

      ' Display databases that will be updated by the import process...
      With lblTargetDBs
         .Text = String.Format("Import process will update Databases {0}.{1} and {0}.{2}", My.Settings.DatabaseServer, My.Settings.LotteryRetailDBCatalog, My.Settings.eTabDBCatalog)
         .Refresh()
      End With

      ' Use last saved window state.
      Try
         ConfigFile.GetWindowState(Me)
      Catch ex As Exception
         ' Ignore exception.
      End Try

   End Sub

   Private Sub AddDGRStylesDMD()
      '--------------------------------------------------------------------------------
      ' Adds Table Styles to the Master Deals for Retirement DataGrid control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lTableStyle As DataGridTableStyle

      Dim lColStyleBool00 As DataGridBoolColumn

      Dim lColStyle00 As DataGridTextBoxColumn
      Dim lColStyle01 As DataGridTextBoxColumn
      Dim lColStyle02 As DataGridTextBoxColumn
      Dim lColStyle03 As DataGridTextBoxColumn
      Dim lColStyle04 As DataGridTextBoxColumn
      Dim lColStyle05 As DataGridTextBoxColumn
      Dim lColStyle06 As DataGridTextBoxColumn

      ' [Master Deals]
      If Not DGRetireMasterDeals.TableStyles.Contains("MASTER_DEAL") Then
         lTableStyle = New DataGridTableStyle
         With lTableStyle
            .AllowSorting = False
            .AlternatingBackColor = Color.Gainsboro
            .BackColor = Color.White
            .ForeColor = Color.MidnightBlue
            .GridLineStyle = DataGridLineStyle.Solid
            .GridLineColor = Color.RoyalBlue
            .HeaderBackColor = Color.SteelBlue
            .HeaderFont = New Font("Tahoma", 8.0!, FontStyle.Bold)
            .HeaderForeColor = Color.White
            .RowHeaderWidth = 16
            .SelectionBackColor = Color.SteelBlue
            .SelectionForeColor = Color.White
            .MappingName = "MASTER_DEAL"
         End With

         ' Setup the column style objects for each column...
         lColStyle00 = New DataGridTextBoxColumn
         With lColStyle00
            .HeaderText = "MD ID"
            .MappingName = "MASTER_DEAL_ID"
            .Alignment = HorizontalAlignment.Center
            .Width = 74
         End With

         lColStyle01 = New DataGridTextBoxColumn
         With lColStyle01
            .HeaderText = "Master Deal"
            .MappingName = "TABLE_NAME"
            .Alignment = HorizontalAlignment.Left
            .Width = 180
         End With

         lColStyle02 = New DataGridTextBoxColumn
         With lColStyle02
            .HeaderText = "Tab Count"
            .MappingName = "RESULT_COUNT"
            .Alignment = HorizontalAlignment.Center
            .Format = "#,##0"
            .Width = 80
         End With

         lColStyle03 = New DataGridTextBoxColumn
         With lColStyle03
            .HeaderText = "Coins Bet"
            .MappingName = "COINS_BET"
            .Alignment = HorizontalAlignment.Center
            .Width = 74
         End With

         lColStyle04 = New DataGridTextBoxColumn
         With lColStyle04
            .HeaderText = "Lines Bet"
            .MappingName = "LINES_BET"
            .Alignment = HorizontalAlignment.Center
            .Width = 74
         End With

         lColStyle05 = New DataGridTextBoxColumn
         With lColStyle05
            .HeaderText = "Hold Pct"
            .MappingName = "HOLD_PERCENT"
            .Alignment = HorizontalAlignment.Center
            .Width = 74
         End With

         lColStyleBool00 = New DataGridBoolColumn
         With lColStyleBool00
            .HeaderText = "Active"
            .MappingName = "IS_ACTIVE"
            .Alignment = HorizontalAlignment.Center
            .Width = 80
         End With

         ' Add the column style objects to the table style object.
         lTableStyle.GridColumnStyles.AddRange(New DataGridColumnStyle() _
            {lColStyle00, lColStyle01, lColStyle02, lColStyle03, _
             lColStyle04, lColStyle05, lColStyleBool00})

         ' Add the Table Style object to the data grid control.
         DGRetireMasterDeals.TableStyles.Add(lTableStyle)
      End If

      ' [Forms]
      If Not DGRetireMasterDeals.TableStyles.Contains("FORM_INFO") Then
         lTableStyle = New DataGridTableStyle

         With lTableStyle
            .AllowSorting = False
            .AlternatingBackColor = Color.Gainsboro
            .BackColor = Color.White
            .ForeColor = Color.MidnightBlue
            .GridLineStyle = DataGridLineStyle.Solid
            .GridLineColor = Color.RoyalBlue
            .HeaderBackColor = Color.SteelBlue
            .HeaderFont = New Font("Tahoma", 8.0!, FontStyle.Bold)
            .HeaderForeColor = Color.White
            .RowHeaderWidth = 16
            .SelectionBackColor = Color.SteelBlue
            .SelectionForeColor = Color.White
            .MappingName = "FORM_INFO"
         End With

         ' Setup the column style objects for each column...
         lColStyle00 = New DataGridTextBoxColumn
         With lColStyle00
            .HeaderText = "Form"
            .MappingName = "FORM_NUMB"
            .Alignment = HorizontalAlignment.Center
            .Width = 100
         End With

         lColStyle01 = New DataGridTextBoxColumn
         With lColStyle01
            .HeaderText = "Description"
            .MappingName = "FORM_DESC"
            .Alignment = HorizontalAlignment.Left
            .Width = 100
         End With

         lColStyle02 = New DataGridTextBoxColumn
         With lColStyle02
            .HeaderText = "GT Code"
            .MappingName = "GAME_TYPE_CODE"
            .Alignment = HorizontalAlignment.Center
            .Width = 80
         End With

         lColStyle03 = New DataGridTextBoxColumn
         With lColStyle03
            .HeaderText = "Tab Count"
            .MappingName = "TABS_PER_DEAL"
            .Alignment = HorizontalAlignment.Center
            .Format = "#,##0"
            .Width = 80
         End With

         lColStyle04 = New DataGridTextBoxColumn
         With lColStyle04
            .HeaderText = "Denom"
            .MappingName = "DENOMINATION"
            .Alignment = HorizontalAlignment.Center
            .Format = "c"
            .Width = 72
         End With

         lColStyle05 = New DataGridTextBoxColumn
         With lColStyle05
            .HeaderText = "Coins Bet"
            .MappingName = "COINS_BET"
            .Alignment = HorizontalAlignment.Center
            .Width = 74
         End With

         lColStyle06 = New DataGridTextBoxColumn
         With lColStyle06
            .HeaderText = "Lines Bet"
            .MappingName = "LINES_BET"
            .Alignment = HorizontalAlignment.Center
            .Width = 74
         End With

         lColStyleBool00 = New DataGridBoolColumn
         With lColStyleBool00
            .HeaderText = "Active"
            .MappingName = "IS_ACTIVE"
            .Alignment = HorizontalAlignment.Center
            .Width = 80
         End With

         ' Add the column style objects to the table style object.
         lTableStyle.GridColumnStyles.AddRange(New DataGridColumnStyle() _
            {lColStyle00, lColStyle01, lColStyle02, lColStyle03, _
             lColStyle04, lColStyle05, lColStyle06, lColStyleBool00})

         ' Add the Table Style object to the data grid control.
         DGRetireMasterDeals.TableStyles.Add(lTableStyle)
      End If

      ' [Deals]
      If Not DGRetireMasterDeals.TableStyles.Contains("DEAL_INFO") Then
         lTableStyle = New DataGridTableStyle

         With lTableStyle
            .AllowSorting = False
            .AlternatingBackColor = Color.Gainsboro
            .BackColor = Color.White
            .ForeColor = Color.MidnightBlue
            .GridLineStyle = DataGridLineStyle.Solid
            .GridLineColor = Color.RoyalBlue
            .HeaderBackColor = Color.SteelBlue
            .HeaderFont = New Font("Tahoma", 8.0!, FontStyle.Bold)
            .HeaderForeColor = Color.White
            .RowHeaderWidth = 16
            .SelectionBackColor = Color.SteelBlue
            .SelectionForeColor = Color.White
            .MappingName = "DEAL_INFO"
         End With

         ' Setup the column style objects for each column...
         lColStyle00 = New DataGridTextBoxColumn
         With lColStyle00
            .HeaderText = "Deal Nbr"
            .MappingName = "DEAL_NO"
            .Alignment = HorizontalAlignment.Center
            .Width = 80
         End With

         lColStyle01 = New DataGridTextBoxColumn
         With lColStyle01
            .HeaderText = "Description"
            .MappingName = "DEAL_DESCR"
            .Alignment = HorizontalAlignment.Left
            .Width = 80
         End With

         lColStyle02 = New DataGridTextBoxColumn
         With lColStyle02
            .HeaderText = "Denom"
            .MappingName = "DENOMINATION"
            .Alignment = HorizontalAlignment.Center
            .Format = "c"
            .Width = 80
         End With

         lColStyle03 = New DataGridTextBoxColumn
         With lColStyle03
            .HeaderText = "Coins Bet"
            .MappingName = "COINS_BET"
            .Alignment = HorizontalAlignment.Center
            .Width = 74
         End With

         lColStyle04 = New DataGridTextBoxColumn
         With lColStyle04
            .HeaderText = "Lines Bet"
            .MappingName = "LINES_BET"
            .Alignment = HorizontalAlignment.Center
            .Width = 74
         End With

         lColStyleBool00 = New DataGridBoolColumn
         With lColStyleBool00
            .HeaderText = "Open"
            .MappingName = "IS_OPEN"
            .Alignment = HorizontalAlignment.Center
            .Width = 80
         End With

         lColStyle05 = New DataGridTextBoxColumn
         With lColStyle05
            .HeaderText = "ETS ID"
            .MappingName = "ETAB_SEQUENCE_ID"
            .Alignment = HorizontalAlignment.Center
            .Width = 76
         End With

         ' Add the column style objects to the table style object.
         lTableStyle.GridColumnStyles.AddRange(New DataGridColumnStyle() _
            {lColStyle00, lColStyle01, lColStyle02, lColStyle03, _
             lColStyle04, lColStyleBool00, lColStyle05})

         ' Add the Table Style object to the data grid control.
         DGRetireMasterDeals.TableStyles.Add(lTableStyle)
      End If

   End Sub

   Private Function IsGoodCDROMData(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Routine called when Enforce Import Security is True.
      ' Checks for the correct set of Deals on ROM media.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lDT As DataTable
      Dim lDriveInfo As DriveInfo

      Dim lFileName As String
      Dim lFilterBase As String
      Dim lFilterText As String
      Dim lFolderName As String
      Dim lDriveLetter As String
      Dim lVolumeLabel As String

      Dim lFilesFound As Boolean
      Dim lReturn As Boolean = False
      Dim lRomDriveFound As Boolean = False

      ' Initialize aErrorText and the CD source folder name to an empty string.
      aErrorText = ""
      mSourceFolderCD = ""

      Try

         ' Search each drive for a CDRom (or DVD) drive...
         For Each lDriveInfo In DriveInfo.GetDrives
            ' Must check IsReady property before checking accessing any other property of DriveInfo.
            If lDriveInfo.IsReady Then
               ' Drive is ready, is it a CDRom drive?
               If lDriveInfo.DriveType = DriveType.CDRom Then
                  ' Yes, so retrieve and store the drive letter and volume letter...
                  lDriveLetter = lDriveInfo.RootDirectory.FullName
                  lVolumeLabel = lDriveInfo.VolumeLabel

                  ' Set drive found flag.
                  lRomDriveFound = True

                  ' Volume label must be "DGE_AMD".
                  If lVolumeLabel.StartsWith("DGE_AMD") Then
                     ' Search CDROM for SetupData* folder.
                     For Each lFolder As DirectoryInfo In lDriveInfo.RootDirectory.GetDirectories("SetupData*", SearchOption.TopDirectoryOnly)
                        ' Check for the expected set of files.
                        ' Must have CasinoSetupData.xml, MsgDigest.dat, and all of the DMD files that are in the MASTER_DEAL table...
                        lFolderName = lFolder.FullName
                        lFileName = Path.Combine(lFolderName, "CasinoSetupData.xml")

                        ' Assume for the moment that all files will be found.
                        lFilesFound = True

                        ' Does the CasinoSetupData.xml file exist?
                        If File.Exists(lFileName) Then
                           ' Yes, so load the approved master deal xml file.
                           mDSApprovedMDSetup = New DataSet
                           mDSApprovedMDSetup.ReadXml(lFileName, XmlReadMode.ReadSchema)

                           ' Yes, does the MsgDigest.dat file exist?
                           lFileName = Path.Combine(lFolderName, "MsgDigest.dat")
                           If File.Exists(lFileName) Then
                              ' Yes, do all of the required DMD files exist?
                              If mDSCasinoSetupData IsNot Nothing Then
                                 For Each lDR In mDSCasinoSetupData.Tables("MASTER_DEAL").Rows
                                    ' Build the fully qualified distribution master file name.
                                    lFileName = Path.Combine(lFolderName, lDR.Item("TABLE_NAME")) & ".dmd"

                                    ' Does the file exist?
                                    If File.Exists(lFileName) = False Then
                                       ' No, set error text and found flag...
                                       aErrorText = lFileName & " file not found."
                                       lFilesFound = False
                                       Exit For
                                    End If
                                 Next

                                 ' Did we find all of the expected files?
                                 If lFilesFound = True Then
                                    ' Yes, so set the CD source folder name and return true.
                                    mSourceFolderCD = lFolderName

                                    ' Check that all of the Master Deals in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                    ' Set a reference to the MASTER_DEAL table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("MASTER_DEAL")

                                    ' Check each Master Deal row from the import set against the Master Deal rows on the ROM drive.
                                    lFilterBase = "MASTER_DEAL_ID={0} AND TABLE_NAME='{1}' AND COINS_BET={2} AND LINES_BET={3} AND RESULT_COUNT={4} AND HOLD_PERCENT={5} AND IS_ACTIVE={6}"
                                    For Each lDR In mDSCasinoSetupData.Tables("MASTER_DEAL").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, .Item("MASTER_DEAL_ID"), .Item("TABLE_NAME"), .Item("COINS_BET"), _
                                                        .Item("LINES_BET"), .Item("RESULT_COUNT"), .Item("HOLD_PERCENT"), .Item("IS_ACTIVE"))
                                          If lDT.Select(lFilterText).Length = 0 Then
                                             aErrorText = "MASTER_DEAL row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                             Return False
                                          End If
                                       End With
                                    Next

                                    ' Check that all of the GAME_TYPE rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                    ' Set a reference to the GAME_TYPE table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("GAME_TYPE")

                                    ' Check each Game Type row from the import set against the Game Type rows on the ROM drive.
                                    lFilterBase = "GAME_TYPE_CODE = '{0}' AND TYPE_ID='{1}' AND MAX_COINS_BET={2} AND MAX_LINES_BET={3} AND IS_ACTIVE={4}"
                                    For Each lDR In mDSCasinoSetupData.Tables("GAME_TYPE").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, .Item("GAME_TYPE_CODE"), .Item("TYPE_ID"), _
                                                        .Item("MAX_COINS_BET"), .Item("MAX_LINES_BET"), .Item("IS_ACTIVE"))
                                          If lDT.Select(lFilterText).Length = 0 Then
                                             aErrorText = "GAME_TYPE row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                             Return False
                                          End If
                                       End With
                                    Next

                                    ' Check that all of the Payscales in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                    ' Set a reference to the PAYSCALE table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("PAYSCALE")

                                    ' Check each Payscale from the import set against the Payscales on the ROM drive.
                                    For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE").Rows
                                       With lDR
                                          lFilterText = String.Format("PAYSCALE_NAME='{0}' AND GAME_TYPE_CODE='{1}' AND IS_ACTIVE={2}", _
                                                        .Item("PAYSCALE_NAME"), .Item("GAME_TYPE_CODE"), .Item("IS_ACTIVE"))
                                       End With
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "PAYSCALE row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    Next

                                    ' Check that all of the Payscale Tiers in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                    ' Set a reference to the PAYSCALE_TIER table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("PAYSCALE_TIER")

                                    ' Check each PayscaleTier from the import set against the PayscaleTiers on the ROM drive.
                                    lFilterBase = "PAYSCALE_NAME='{0}' AND TIER_LEVEL={1} AND COINS_WON={2} AND TIER_WIN_TYPE={3} AND USE_MULTIPLIER={4}"
                                    For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE_TIER").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, .Item("PAYSCALE_NAME"), .Item("TIER_LEVEL"), _
                                                        .Item("COINS_WON"), .Item("TIER_WIN_TYPE"), .Item("USE_MULTIPLIER"))
                                       End With
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "PAYSCALE_TIER row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    Next

                                    ' Are there any Keno payscale tier rows?
                                    If mDSCasinoSetupData.Tables("PAYSCALE_TIER_KENO").Rows.Count > 0 Then
                                       ' Yes, so check that all of the PAYSCALE_TIER_KENO rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                       ' Set a reference to the PAYSCALE_TIER_KENO table from the ROM drive.
                                       lDT = mDSApprovedMDSetup.Tables("PAYSCALE_TIER_KENO")

                                       ' Check each PAYSCALE_TIER_KENO row from the import set against the PAYSCALE_TIER_KENO rows on the ROM drive.
                                       lFilterBase = "PAYSCALE_NAME='{0}' AND TIER_LEVEL={1} AND PICK_COUNT={2} AND HIT_COUNT={3} AND AWARD_FACTOR={4} AND TIER_WIN_TYPE={5}"
                                       For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE_TIER_KENO").Rows
                                          With lDR
                                             lFilterText = String.Format(lFilterBase, .Item("PAYSCALE_NAME"), .Item("TIER_LEVEL"), .Item("PICK_COUNT"), _
                                                                         .Item("HIT_COUNT"), .Item("AWARD_FACTOR"), .Item("TIER_WIN_TYPE"))
                                          End With
                                          If lDT.Select(lFilterText).Length = 0 Then
                                             aErrorText = "PAYSCALE_TIER_KENO row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                             Return False
                                          End If
                                       Next
                                    End If

                                    ' Check that all of the Game Codes in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                    ' Set a reference to the Game Setup table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("GAME_SETUP")

                                    ' Check each GAME_SETUP row from the import set against the GAME_SETUP rows on the ROM drive.
                                    lFilterBase = "GAME_CODE = '{0}' AND GAME_TYPE_CODE='{1}' AND TYPE_ID='{2}' AND GAME_TITLE_ID={3}"
                                    For Each lDR In mDSCasinoSetupData.Tables("GAME_SETUP").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, .Item("GAME_CODE"), .Item("GAME_TYPE_CODE"), .Item("TYPE_ID"), .Item("GAME_TITLE_ID"))
                                       End With
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "GAME_SETUP row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    Next

                                    ' Check that all of the Forms in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                    ' Set a reference to the forms table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("CASINO_FORMS")

                                    ' Check each CASINO_FORMS row from the import set against the CASINO_FORMS rows on the ROM drive.
                                    lFilterBase = "FORM_NUMB = '{0}' AND DEAL_TYPE='{1}' AND TABS_PER_DEAL={2} AND WINS_PER_DEAL={3} AND " & _
                                                  "DENOMINATION={4} AND COINS_BET={5} AND LINES_BET={6} AND GAME_TYPE_CODE='{7}' AND " & _
                                                  "MASTER_DEAL_ID={8} AND HOLD_PERCENT={9} AND IS_PAPER={10} AND IS_ACTIVE={11}"

                                    For Each lDR In mDSCasinoSetupData.Tables("CASINO_FORMS").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, .Item("FORM_NUMB"), .Item("DEAL_TYPE"), .Item("TABS_PER_DEAL"), _
                                                                      .Item("WINS_PER_DEAL"), .Item("DENOMINATION"), .Item("COINS_BET"), _
                                                                      .Item("LINES_BET"), .Item("GAME_TYPE_CODE"), .Item("MASTER_DEAL_ID"), _
                                                                      .Item("HOLD_PERCENT"), .Item("IS_PAPER"), .Item("IS_ACTIVE"))
                                          If lDT.Select(lFilterText).Length = 0 Then
                                             aErrorText = "CASINO_FORMS row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                             Return False
                                          End If
                                       End With
                                    Next

                                    ' Check that all of the WINNING_TIERS in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                    ' Set a reference to the WINNING_TIERS table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("WINNING_TIERS")

                                    ' Check Winning Tiers from the import set against the Winning Tiers on the ROM drive.
                                    lFilterBase = "FORM_NUMB='{0}' AND TIER_LEVEL={1} AND NUMB_OF_WINNERS={2} AND WINNING_AMOUNT={3} AND COINS_WON={4}"
                                    For Each lDR In mDSCasinoSetupData.Tables("WINNING_TIERS").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, .Item("FORM_NUMB"), .Item("TIER_LEVEL"), _
                                                        .Item("NUMB_OF_WINNERS"), .Item("WINNING_AMOUNT"), .Item("COINS_WON"))
                                       End With
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "WINNING_TIERS row was not found or has different values in the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    Next

                                    ' Check that all of the FLARE rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                    ' Set a reference to the FLARE table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("FLARE")
                                    ' Check that each FLARE row in the import set exists in the FLARE rows of the ROM drive.
                                    lFilterBase = "FLARE_ID={0} AND GAME_TYPE_CODE='{1}' AND BET_COMBO_COUNT={2} AND TIER_COUNT={3}"
                                    For Each lDR In mDSCasinoSetupData.Tables("FLARE").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, lDR.Item("FLARE_ID"), .Item("GAME_TYPE_CODE"), .Item("BET_COMBO_COUNT"), .Item("TIER_COUNT"))
                                          If lDT.Select(lFilterText).Length = 0 Then
                                             aErrorText = "FLARE row was not found or has different values in the approved data set. Criteria" & lFilterText
                                             Return False
                                          End If
                                       End With
                                    Next

                                    ' Check that all of the FLARE_HEADER rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                    ' Set a reference to the forms table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("FLARE_HEADER")
                                    ' Check each FLARE_HEADER from the import set against the FLARE_HEADERs on the ROM drive.
                                    lFilterBase = "FLARE_HEADER_ID={0} AND FLARE_ID={1} AND COLUMN_NUMBER={2} AND LINES_BET={3} AND CREDITS_BET='{4}'"
                                    For Each lDR In mDSCasinoSetupData.Tables("FLARE_HEADER").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, .Item("FLARE_HEADER_ID"), .Item("FLARE_ID"), .Item("COLUMN_NUMBER"), .Item("LINES_BET"), .Item("CREDITS_BET"))
                                          If lDT.Select(lFilterText).Length = 0 Then
                                             aErrorText = "FLARE_HEADER row was not found or has different values in the approved data set. Criteria: " & lFilterText
                                             Return False
                                          End If
                                       End With
                                    Next

                                    ' Check that all of the FLARE_TIER rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                    ' Set a reference to the FLARE_TIER table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("FLARE_TIER")
                                    ' Check each FLARE_TIER row from the import set against the FLARE_TIER rows on the ROM drive.
                                    lFilterBase = "FLARE_TIER_ID={0} AND FLARE_ID={1} AND TIER_LEVEL={2} AND SYMBOLS='{3}' AND BASE_CREDITS={4} AND WIN_COUNT_LIST='{5}'"
                                    For Each lDR In mDSCasinoSetupData.Tables("FLARE_TIER").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, .Item("FLARE_TIER_ID"), .Item("FLARE_ID"), .Item("TIER_LEVEL"), _
                                                        .Item("SYMBOLS"), .Item("BASE_CREDITS"), .Item("WIN_COUNT_LIST"))
                                          If lDT.Select(lFilterText).Length = 0 Then
                                             aErrorText = "FLARE_TIER row was not found or has different values in the approved data set. Criteria: " & lFilterText
                                             Return False
                                          End If
                                       End With
                                    Next

                                    ' No errors, return true.
                                    Return True
                                 End If
                              Else
                                 ' mDSCasinoSetupData Is a null reference.
                                 aErrorText = "SetupData is not loaded."
                              End If
                           Else
                              ' File.Exists(MsgDigest.dat) = false.
                              aErrorText = "MsgDigest.dat file not found."
                              lFilesFound = False
                           End If
                        Else
                           ' File.Exists(CasinoSetupData.xml) = false.
                           aErrorText = "CasinoSetupData.xml file not found."
                           lFilesFound = False
                        End If

                        If aErrorText.Length > 0 Then
                           Return False
                        End If
                     Next
                  Else
                     ' Incorrect volume label.
                     aErrorText = "Invalid CD or DVD Disc."
                  End If
               End If
            End If
         Next

         ' If no CD/DVD Rom drive was found, set error text appropriately.
         If lRomDriveFound = False Then
            aErrorText = "Did not find a CD or DVD Rom drive."
         End If

      Catch ex As Exception
         ' Handle the exception...
         aErrorText = Me.Name & "IsGoodCDROMData error: " & ex.Message
         lReturn = False

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function LoadDataSet(ByVal aSourceFile As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Loads the specified file into mDSCasinoSetupData.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lDealGenLongVersion As Long
      Dim lMinDealGenVersion As Long = My.Settings.MinDealGenVersion

      Dim lEnforceImportSecurity As Boolean

      Dim lCasinoID As String = ""
      Dim lErrorPrefix As String = Me.Name & "::LoadDataSet error: "
      Dim lErrorText As String = ""
      Dim lStatusText As String = ""

      ' Disable the import button.
      btnImport.Enabled = False

      ' Load the new file...
      Try
         mDSCasinoSetupData = New DataSet
         mDSCasinoSetupData.ReadXml(aSourceFile, XmlReadMode.ReadSchema)

      Catch ex As Exception
         ' Handle the exception...
         lReturn = False
         mDSCasinoSetupData = Nothing
         mDSRetireMD = Nothing
         lErrorText = "Failed to read source file: " & ex.Message
         lStatusText = "Load Error Reading Source"

      End Try

      ' If no errors, we can continue...
      If lReturn = True Then
         Try
            ' Load the Grid.
            ' Compact Master Deals.
            Call LoadMasterDealImportGridDMD()

         Catch ex As Exception
            ' Handle the exception...
            lReturn = False
            lErrorText = "Failed to load Master Deal Grid: " & ex.Message
            lStatusText = "Load Error"
         End Try
      End If

      ' If no errors, we can continue...
      If lReturn = True Then
         Try
            ' Set a reference to the ImportFlags table.
            lDT = mDSCasinoSetupData.Tables("ImportFlags")

            ' Set a reference to the first row of the ImportFlags table.
            lDR = lDT.Rows(0)

            ' Set Import Flags...
            With mImportFlags
               .ExportDate = lDR.Item("ExportDate")
               .ExportedBy = lDR.Item("ExportedBy")

               .CasinoTable = lDR.Item("CasinoTable")
               .BankMachineTables = lDR.Item("BankMachTables")
               If .BankMachineTables = True Then
                  ' If we are to update the Bank and Machine tables, use the Bank and Machine update settings.
                  .BankUpdate = lDR.Item("Bank")
                  .MachineUpdate = lDR.Item("Machine")
               Else
                  ' We are not to update the Bank and Machine tables...
                  .BankUpdate = False
                  .MachineUpdate = False
               End If

               ' Set the Enforce Import Security flag...
               If lDT.Columns.Contains("EnforceImportSecurity") Then
                  ' Column exists, use the column value.
                  lEnforceImportSecurity = lDR.Item("EnforceImportSecurity")
               Else
                  ' Column does not exist, set to False.
                  lEnforceImportSecurity = False
               End If
               .EnforceImportSecurity = lEnforceImportSecurity

               .GameTypeUpdate = lDR.Item("GameType")
               .DenomToGameTypeUpdate = lDR.Item("DenomToGameType")
               .CoinsBetToGameTypeUpdate = lDR.Item("CoinsBetToGameType")
               .LinesBetToGameTypeUpdate = lDR.Item("LinesBetToGameType")
               .GameSetupUpdate = lDR.Item("GameSetup")
               .PayscaleUpdate = lDR.Item("Payscale")
               .PayscaleTierUpdate = lDR.Item("PayscaleTier")
               .FormUpdate = lDR.Item("Form")
               .FlareUpdate = lDR.Item("Flare")
               .WinningTierUpdate = lDR.Item("WinningTier")
               If lDR.Table.Columns.Contains("DealGenLongVersion") Then
                  lDealGenLongVersion = lDR.Item("DealGenLongVersion")
               Else
                  lDealGenLongVersion = 0
               End If
               .DealGenLongVersion = lDealGenLongVersion

               ' Set checked property of the CheckBox controls...
               cbCasino.Checked = .CasinoTable
               cbBankMach.Checked = .BankMachineTables

               cbBankUpdate.Checked = .BankUpdate
               cbMachineUpdate.Checked = .MachineUpdate
               cbEnforceIS.Checked = lEnforceImportSecurity
               cbGameTypeUpdate.Checked = .GameTypeUpdate
               cbDenomToGTUpdate.Checked = .DenomToGameTypeUpdate
               cbCoinsBetToGTUpdate.Checked = .CoinsBetToGameTypeUpdate
               cbLinesBetToGTUpdate.Checked = .LinesBetToGameTypeUpdate
               cbGameSetupUpdate.Checked = .GameSetupUpdate
               cbPayscaleUpdate.Checked = .PayscaleUpdate
               cbPayscaleTiersUpdate.Checked = .PayscaleTierUpdate
               cbFormsUpdate.Checked = .FormUpdate
               cbFlareUpdate.Checked = .FlareUpdate
               cbWinningTiersUpdate.Checked = .WinningTierUpdate

            End With

         Catch ex As Exception
            ' Handle the exception...
            lReturn = False
            lErrorText = "Failed to set Import Flags and Form Controls: " & ex.Message
            lStatusText = "Load Error"

         End Try

      End If

      ' If no errors yet, make sure the dataset is for the correct Casino.
      If lReturn = True Then
         ' Retrive CasinoID from the DataSet.
         lCasinoID = mDSCasinoSetupData.Tables("CASINO").Rows(0).Item("CAS_ID")

         ' Is the dataset for the proper casino?
         If String.Compare(lCasinoID, gDefaultCasinoID, True) <> 0 Then
            ' No, set return value, error and status text...
            lReturn = False
            lErrorText = String.Format("Dataset is for {0} and this Casino is {1}.", lCasinoID, gDefaultCasinoID)
            lStatusText = lErrorText
         End If
      End If

      ' Still good to go?
      If lReturn = True Then
         ' Yes, now make sure that the Deal Generation system version is okay...
         If lDealGenLongVersion < lMinDealGenVersion Then
            ' No, set return value, error and status text...
            lReturn = False
            lErrorText = String.Format("Export set was created with DealGen version {0}, must be {1} or higher.", _
                                       lDealGenLongVersion, lMinDealGenVersion)
            lStatusText = lErrorText
         End If
      End If

      ' Still good to go?
      If lReturn = True Then
         ' GLI001 is reserved for Approved Master disks and may not be loaded.
         If String.Compare(lCasinoID, "GLI001", True) = 0 Then
            lReturn = False
            lErrorText = "CasinoID GLI001 is reserved for approved master data and may not be loaded."
            lStatusText = lErrorText
         End If
      End If

      ' If no errors yet and Enforce Import Security is True, make sure we have a CD or DVD with master deals.
      If lReturn = True AndAlso lEnforceImportSecurity = True Then
         lReturn = IsGoodCDROMData(lErrorText)
      End If

      ' If we have error text, log and show it...
      If lErrorText.Length > 0 Then
         lErrorText = lErrorPrefix & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set enabled property of the import button.
      btnImport.Enabled = lReturn

      If lReturn Then
         ' Yes, so enable the Import button and set the status text...
         lStatusText = String.Format("Ready to Import new Master Deals from {0}.", aSourceFile)
      End If

      ' Show load status.
      sbrStatus.Text = lStatusText

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub LoadMasterDealImportGridDMD()
      '--------------------------------------------------------------------------------
      ' Load Master Deal Grid with Compact Master data.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String

      Dim lTableStyle As New DataGridTableStyle

      Dim lColStyle00 As New DataGridTextBoxColumn
      Dim lColStyle01 As New DataGridTextBoxColumn
      Dim lColStyle02 As New DataGridTextBoxColumn
      Dim lColStyle03 As New DataGridTextBoxColumn
      Dim lColStyle04 As New DataGridTextBoxColumn
      Dim lColStyle05 As New DataGridTextBoxColumn

      Try
         ' Bind retrieved data to the Form DataGrid control and set DataGrid properties...
         If Not DGImportMasterDeals.DataSource Is Nothing Then
            DGImportMasterDeals.DataSource = Nothing
         End If

         If DGImportMasterDeals.TableStyles.Contains("MASTER_DEAL") Then
            lTableStyle = DGImportMasterDeals.TableStyles("MASTER_DEAL")
            DGImportMasterDeals.TableStyles.Remove(lTableStyle)
            lTableStyle = New DataGridTableStyle
         End If

         With DGImportMasterDeals
            .SetDataBinding(mDSCasinoSetupData, "MASTER_DEAL")
            .CaptionVisible = True
            .RowHeaderWidth = 16
         End With

         ' Add table style if not already there...
         With lTableStyle
            .AllowSorting = True
            .AlternatingBackColor = Color.Gainsboro
            .BackColor = Color.White
            .ForeColor = Color.MidnightBlue
            .GridLineStyle = DataGridLineStyle.Solid
            .GridLineColor = Color.RoyalBlue
            .HeaderBackColor = Color.SteelBlue
            .HeaderFont = New Font("Tahoma", 8.0!, FontStyle.Bold)
            .HeaderForeColor = Color.White
            .SelectionBackColor = Color.SteelBlue
            .SelectionForeColor = Color.White
            .RowHeaderWidth = 16

            ' Do not forget to set the MappingName property. 
            ' Without this, the DataGridTableStyle properties
            ' and any associated DataGridColumnStyle objects
            ' will have no effect.
            .MappingName = "MASTER_DEAL"
         End With

         ' Setup the column style objects for each column...
         With lColStyle00
            .HeaderText = "Table Name"
            .MappingName = "TABLE_NAME"
            .Alignment = HorizontalAlignment.Center
            .Width = 140
         End With

         With lColStyle01
            .HeaderText = "Coins Bet"
            .MappingName = "COINS_BET"
            .Alignment = HorizontalAlignment.Center
            .Width = 76
         End With

         With lColStyle02
            .HeaderText = "Lines Bet"
            .MappingName = "LINES_BET"
            .Alignment = HorizontalAlignment.Center
            .Width = 76
         End With

         With lColStyle03
            .HeaderText = "Result Count"
            .MappingName = "RESULT_COUNT"
            .Alignment = HorizontalAlignment.Center
            .Format = "#,##0"
            .Width = 100
         End With

         With lColStyle04
            .HeaderText = "Hold Pct"
            .MappingName = "HOLD_PERCENT"
            .Alignment = HorizontalAlignment.Center
            .Width = 76
         End With

         With lColStyle05
            .HeaderText = "ID"
            .MappingName = "MASTER_DEAL_ID"
            .Alignment = HorizontalAlignment.Center
            .Width = 40
         End With

         ' Add the column style objects to the table style object.
         lTableStyle.GridColumnStyles.AddRange(New DataGridColumnStyle() _
            {lColStyle00, lColStyle01, lColStyle02, _
             lColStyle03, lColStyle04, lColStyle05})

         ' Add the Table Style object to the data grid control.
         DGImportMasterDeals.TableStyles.Add(lTableStyle)

      Catch ex As Exception
         ' Handle error...
         lErrorText = Me.Name & "::LoadMasterDealImportGridDMD error:" & gNL & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Sub LoadMasterDealRetireGridDMD()
      '--------------------------------------------------------------------------------
      ' Load Retire Master Deal Grid (Compact).
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDTRetireMD As DataTable
      Dim lDR As DataRow

      Dim lChildColumns(0) As DataColumn
      Dim lParentColumns(0) As DataColumn

      Dim lErrorText As String = ""
      Dim lErrorPrefix As String = Me.Name & "::LoadMasterDealRetireGridDMD: "
      Dim lIDList As String = ""

      Try
         ' Set a reference to the RetireMasterDeal DataTable.
         lDTRetireMD = mDSCasinoSetupData.Tables("RetireMasterDeal")

         ' Store row count.
         mRetireCount = lDTRetireMD.Rows.Count

         ' Build a list of Master Deal IDs...
         If mRetireCount = 0 Then
            lIDList = "0"
         Else
            ' Build the list of Master Deal IDs to be retired.
            For Each lDR In lDTRetireMD.Rows
               lIDList &= CType(lDR.Item("MASTER_DEAL_ID"), String) & ","
            Next
            ' Trim the trailing comma character.
            lIDList = lIDList.TrimEnd(",".ToCharArray)
         End If

      Catch ex As Exception
         ' Handle the error...
         lErrorText = lErrorPrefix & "Error building Master Deal ID retire list: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Load Master Deals to Retire Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' If no errors we can continue.
      If lErrorText.Length = 0 Then
         ' Build SQL SELECT statements to retrieve our data.
         Try
            ' Retrieve data...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)
            With lSDA
               .AddParameter("@MasterDealIDList", SqlDbType.VarChar, lIDList, 512)
               mDSRetireMD = .ExecuteProcedure("GetMasterDealInfo")
            End With

         Catch ex As Exception
            ' Handle the error...
            lErrorText = lErrorPrefix & "Error retrieving Master Deal retire data: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Load Master Deals to Retire Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         End Try
      End If

      ' If no errors we can continue.
      If lErrorText.Length = 0 Then
         Try
            With mDSRetireMD
               ' Set the names and disallow add/edit/delete for proper DataGrid display of the returned tables...
               With .Tables(0)
                  .DefaultView.AllowNew = False
                  .DefaultView.AllowDelete = False
                  .DefaultView.AllowEdit = False
                  .TableName = "MASTER_DEAL"
               End With

               With .Tables(1)
                  .DefaultView.AllowNew = False
                  .DefaultView.AllowDelete = False
                  .DefaultView.AllowEdit = False
                  .TableName = "FORM_INFO"
               End With

               With .Tables(2)
                  .DefaultView.AllowNew = False
                  .DefaultView.AllowDelete = False
                  .DefaultView.AllowEdit = False
                  .TableName = "DEAL_INFO"
               End With
            End With

         Catch ex As Exception
            ' Handle the error...
            lErrorText = lErrorPrefix & "Setting DataSet Table Properties: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Load Master Deals to Retire Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)

         End Try
      End If

      ' If no errors we can continue.
      If lErrorText.Length = 0 Then
         Call AddDGRStylesDMD()
         DGRetireMasterDeals.SetDataBinding(mDSRetireMD, "MASTER_DEAL")
      End If

   End Sub

   Private Sub SetImportSuccessFlag()
      '--------------------------------------------------------------------------------
      ' Reset SUCCESS flag in IMPORT_MD_HISTORY
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing

      Dim lErrorText As String = ""
      Dim lSQL As String

      ' Build update statement.
      lSQL = String.Format("UPDATE IMPORT_MD_HISTORY SET SUCCESSFUL = 1 WHERE IMPORT_MD_HISTORY_ID = {0}", mImportMDHistoryID)

      ' Peform the update.
      Try
         lSDA = New SqlDataAccess(gConnectRetail, False, 60)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the error.
         lErrorText = "SetImportSuccessFlag failed: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup.
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
      End Try

   End Sub

   Private Function CreateImportMDHistoryRow(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Inserts a row into IMPORT_MD_HISTORY, sets mImportMDHistoryID, returns
      ' True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lErrorText As String = ""
      Dim lReturn As Boolean = True


      ' Initialize error text to an empty string.
      aErrorText = ""

      ' Insert a row into IMPORT_MD_HISTORY.
      Try
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)
         With lSDA
            .AddParameter("@ImportedBy", SqlDbType.VarChar, gAppUserName, 64)
            .AddParameter("@ExportedBy", SqlDbType.VarChar, mImportFlags.ExportedBy, 64)
            .AddParameter("@ExportDate", SqlDbType.DateTime, mImportFlags.ExportDate)
            .AddParameter("@CasinoUpdate", SqlDbType.Bit, mImportFlags.CasinoTable)
            .AddParameter("@BankMachUpdate", SqlDbType.Bit, mImportFlags.BankMachineTables)
            .AddParameter("@Success", SqlDbType.Bit, False)

            ' Execute the procedure.
            .ExecuteProcedureNoResult("diInsertImportMDHistory")

            ' Store the IMPORT_MD_HISTORY_ID value returned from the diInsertImportMDHistory stored procedure.
            mImportMDHistoryID = .ReturnValue
         End With

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         aErrorText = Me.Name & "::CreateImportMDHistoryRow Error: " & ex.Message

      Finally
         ' Close and free the database object...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function CreateMasterDealTable(ByVal aTableName As String, ByRef aErrorText As String) As Integer
      '--------------------------------------------------------------------------------
      ' Creates and populates eTab Master Deal table.
      ' Returns: 1 if successful
      '          0 if a database error occurs
      '         -1 if the file does not exist
      '         -2 if the MasterDeal table already exists in the eTab database.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable

      Dim lErrPrefix As String
      Dim lSourceFile As String
      Dim lSourceFolder As String
      Dim lSQL As String

      Dim lCount As Integer
      Dim lReturn As Integer = 1

      ' Init error text to an empty string.
      aErrorText = ""

      ' Build error prefix text.
      lErrPrefix = Me.Name & "::CreateMasterDealTable: Error: "

      ' Set the Source Folder...
      If mImportFlags.EnforceImportSecurity = True Then
         lSourceFolder = mSourceFolderCD
      Else
         lSourceFolder = mSourceFolder
      End If

      ' Build the source file name.
      lSourceFile = Path.Combine(lSourceFolder, String.Format("{0}.dmd", aTableName))

      ' Does the source file exist?
      If File.Exists(lSourceFile) Then
         ' Yes, now see if the table already exists in the eTab database...
         lSQL = "SELECT COUNT(*) AS TableCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '{0}'"
         lSQL = String.Format(lSQL, aTableName)

         Try
            ' Create a new SqlDataAccess instance, keeping the connection open and 
            ' using a Command Timeout of 10 minutes (for the Bulk Insert).
            lSDA = New SqlDataAccess(gConnectETab, True, 600)
            ' Attempt to retrieve the count.
            lDT = lSDA.CreateDataTable(lSQL)
            lCount = lDT.Rows(0).Item(0)

            ' If the table already exists, set the function return value to -2.
            If lCount > 0 Then lReturn = -2

         Catch ex As Exception
            ' Handle the error.
            aErrorText = lErrPrefix & ex.Message
            lReturn = 0
         End Try

         ' If no problems yet, attempt to create the table.
         If lReturn = 1 Then
            lSQL = "CREATE TABLE {0} ([TicketNumber] [int] NOT NULL , [eBarcode] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL) ON [PRIMARY];" & _
                   "ALTER TABLE {0} WITH NOCHECK ADD CONSTRAINT [PK_{0}] PRIMARY KEY CLUSTERED ([TicketNumber]) ON [PRIMARY]"
            lSQL = String.Format(lSQL, aTableName)

            Try
               ' Attempt to create the table.
               lSDA.ExecuteSQLNoReturn(lSQL)

            Catch ex As Exception
               ' Handle the error.
               aErrorText = lErrPrefix & "Failed to create table: " & ex.Message
               lReturn = 0

            End Try

         End If

         ' If no problems yet, attempt to BULK INSERT into the table.
         If lReturn = 1 Then
            lSQL = String.Format("BULK INSERT {0} FROM '{1}' WITH (FIELDTERMINATOR = ',')", aTableName, lSourceFile)

            Try
               ' Attempt to perform the Bulk Insert.
               lSDA.ExecuteSQLNoReturn(lSQL)

            Catch ex As Exception
               ' Handle the error.
               aErrorText = lErrPrefix & "Bulk Insert failed: " & ex.Message
               lReturn = 0

            End Try

            ' If we created the table but cannot populate it, then drop the table.
            If lReturn = 0 Then
               lSQL = "DROP TABLE " & aTableName
               Try
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Catch ex As Exception
                  ' Handle the error.
                  aErrorText &= " Failed to DROP the table."

               End Try
            End If
         End If

         ' Close and free the database object.
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
      Else
         ' Source file not found.
         aErrorText = lSourceFile & " not found."
         lReturn = -1
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DropCoinsBetToGameType() As Integer
      '--------------------------------------------------------------------------------
      ' Drops COINS_BET_TO_GAME_TYPE records so they can be replaced.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Integer = 0

      Dim lGameTypeCodeList As String = ""
      Dim lLastGTC As String = ""
      Dim lThisGTC As String = ""
      Dim lSQL As String

      ' Walk each row in COINS_BET_TO_GAME_TYPE table and build a list of GameTypeCodes.
      For Each lDR In mDSCasinoSetupData.Tables("COINS_BET_TO_GAME_TYPE").Rows
         lThisGTC = lDR.Item("GAME_TYPE_CODE")
         If lThisGTC <> lLastGTC Then
            lGameTypeCodeList &= "'" & lThisGTC & "',"
            lLastGTC = lThisGTC
         End If
      Next

      If lGameTypeCodeList.Length > 0 Then
         ' Trim the trailing comma.
         lGameTypeCodeList = lGameTypeCodeList.TrimEnd(",".ToCharArray)

         ' Build the delete statement.
         lSQL = "DELETE FROM COINS_BET_TO_GAME_TYPE WHERE GAME_TYPE_CODE IN ({0})"
         lSQL = String.Format(lSQL, lGameTypeCodeList)

         Try
            ' Attempt to delete the rows...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)
            lReturn = lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error
            lReturn = -1
            Logging.Log("DropCoinsBetToGameTypes failed: " & ex.Message)

         Finally
            ' DB Cleanup.
            If Not lSDA Is Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If
         End Try

      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub DropMasterDealTables()
      '--------------------------------------------------------------------------------
      ' Drops any DMD tables that were added.
      '--------------------------------------------------------------------------------
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDTMD As DataTable
      Dim lDR As DataRow

      Dim lErrorText As String
      Dim lSQL As String
      Dim lTableName As String

      lTableName = "MASTER_DEAL"
      If mDSCasinoSetupData.Tables.Contains(lTableName) Then
         Try
            ' Set a reference to the master deal table.
            lDTMD = mDSCasinoSetupData.Tables(lTableName)

            ' Instantiate a new SqlDataAccess object.
            lSDA = New SqlDataAccess(gConnectETab, True, 90)

            ' Walk the rows in the table...
            For Each lDR In lDTMD.Rows
               ' Get the table name.
               lTableName = lDR.Item("TABLE_NAME")
               lSQL = String.Format("IF EXISTS(SELECT * FROM sys.tables WHERE [name] = '{0}') DROP TABLE {0}", lTableName)
               Try
                  ' Attempt to drop the table.
                  lSDA.ExecuteProcedureNoResult(lSQL)
               Catch ex As Exception
                  ' Ignore the exception, table might not exist...
               End Try
            Next

         Catch ex As Exception
            ' Handle the exception...
            lErrorText = Me.Name & "::DropMasterDealTables error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Drop Master Deal Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         Finally
            ' Cleanup...
            If lSDA IsNot Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If
         End Try
      End If

   End Sub

   Private Function DropDealTableDMD(ByVal aDealNbr As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Drops eTab database Deal table.
      ' Returns T/F to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lReturn As Boolean = True

      Dim lErrorText As String = ""
      Dim lSQL As String

      ' Build the SQL statement to drop the table.
      lSQL = String.Format("DROP TABLE Deal{0}", aDealNbr)

      Try
         ' Instantiate a New SqlDataAccess object.
         lSDA = New SqlDataAccess(gConnectETab, False, 120)

         ' Attempt to drop the table.
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = Me.Name & "::DropDealTableDMD: Error: " & ex.Message
         Logging.Log(lErrorText)

      Finally
         ' Database object cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DropDenomToGameType() As Integer
      '--------------------------------------------------------------------------------
      ' Drops DENOM_TO_GAME_TYPE records so they can be replaced.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Integer = 0

      Dim lGameTypeCodeList As String = ""
      Dim lLastGTC As String = ""
      Dim lThisGTC As String = ""
      Dim lSQL As String

      ' Walk each row in DENOM_TO_GAME_TYPE table and build a list of GameTypeCodes.
      For Each lDR In mDSCasinoSetupData.Tables("DENOM_TO_GAME_TYPE").Rows
         lThisGTC = lDR.Item("GAME_TYPE_CODE")
         If lThisGTC <> lLastGTC Then
            lGameTypeCodeList &= "'" & lThisGTC & "',"
            lLastGTC = lThisGTC
         End If
      Next

      If lGameTypeCodeList.Length > 0 Then
         ' Trim the trailing comma.
         lGameTypeCodeList = lGameTypeCodeList.TrimEnd(",".ToCharArray)

         ' Build the delete statement.
         lSQL = "DELETE FROM DENOM_TO_GAME_TYPE WHERE GAME_TYPE_CODE IN ({0})"
         lSQL = String.Format(lSQL, lGameTypeCodeList)

         Try
            ' Attempt to delete the rows...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)
            ' Store number of deleted rows as the return value.
            lReturn = lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error
            lReturn = -1
            Logging.Log("DropDenomToGameTypes failed: " & ex.Message)

         Finally
            ' DB Cleanup.
            If Not lSDA Is Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If
         End Try

      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DropFlareHeaders() As Integer
      '--------------------------------------------------------------------------------
      ' Drops FLARE_HEADER records so they can be replaced.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Integer = 0

      Dim lFlareIDList As String = ""
      Dim lLastFID As String = ""
      Dim lThisFID As String = ""
      Dim lSQL As String

      ' Walk each row in the FLARE_HEADER DataTable and build a list of Flare IDs.
      For Each lDR In mDSCasinoSetupData.Tables("FLARE_HEADER").Rows
         lThisFID = lDR.Item("FLARE_ID")
         If lThisFID <> lLastFID Then
            lFlareIDList &= "'" & lThisFID & "',"
            lLastFID = lThisFID
         End If
      Next

      If lFlareIDList.Length > 0 Then
         ' Trim the trailing comma.
         lFlareIDList = lFlareIDList.TrimEnd(",".ToCharArray)

         ' Build the delete statement.
         lSQL = String.Format("DELETE FROM FLARE_HEADER WHERE FLARE_ID IN ({0})", lFlareIDList)

         Try
            ' Attempt to delete the rows...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)
            lReturn = lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error
            lReturn = -1
            Logging.Log("DropFlareHeaders error: " & ex.Message)

         Finally
            ' DB Cleanup.
            If Not lSDA Is Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If
         End Try

      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DropFlareTiers() As Integer
      '--------------------------------------------------------------------------------
      ' Drops FLARE_TIER records so they can be replaced.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Integer = 0

      Dim lFlareIDList As String = ""
      Dim lLastFID As String = ""
      Dim lThisFID As String = ""
      Dim lSQL As String

      ' Walk each row in the FLARE_HEADER DataTable and build a list of Flare IDs.
      For Each lDR In mDSCasinoSetupData.Tables("FLARE_TIER").Rows
         lThisFID = lDR.Item("FLARE_ID")
         If lThisFID <> lLastFID Then
            lFlareIDList &= "'" & lThisFID & "',"
            lLastFID = lThisFID
         End If
      Next

      If lFlareIDList.Length > 0 Then
         ' Trim the trailing comma.
         lFlareIDList = lFlareIDList.TrimEnd(",".ToCharArray)

         ' Build the delete statement.
         lSQL = String.Format("DELETE FROM FLARE_TIER WHERE FLARE_ID IN ({0})", lFlareIDList)

         Try
            ' Attempt to delete the rows...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)
            lReturn = lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error
            lReturn = -1
            Logging.Log("DropFlareTiers error: " & ex.Message)

         Finally
            ' DB Cleanup.
            If Not lSDA Is Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If
         End Try
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DropLinesBetToGameType() As Integer
      '--------------------------------------------------------------------------------
      ' Drops LINES_BET_TO_GAME_TYPE records so they can be replaced.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Integer = 0

      Dim lGameTypeCodeList As String = ""
      Dim lLastGTC As String = ""
      Dim lThisGTC As String = ""
      Dim lSQL As String

      ' Walk each row in LINES_BET_TO_GAME_TYPE table and build a list of GameTypeCodes.
      For Each lDR In mDSCasinoSetupData.Tables("LINES_BET_TO_GAME_TYPE").Rows
         lThisGTC = lDR.Item("GAME_TYPE_CODE")
         If lThisGTC <> lLastGTC Then
            lGameTypeCodeList &= "'" & lThisGTC & "',"
            lLastGTC = lThisGTC
         End If
      Next

      If lGameTypeCodeList.Length > 0 Then
         ' Trim the trailing comma.
         lGameTypeCodeList = lGameTypeCodeList.TrimEnd(",".ToCharArray)

         ' Build the delete statement.
         lSQL = "DELETE FROM LINES_BET_TO_GAME_TYPE WHERE GAME_TYPE_CODE IN ({0})"
         lSQL = String.Format(lSQL, lGameTypeCodeList)

         Try
            ' Attempt to delete the rows...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)
            lReturn = lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error
            lReturn = -1
            Logging.Log("DropLinesBetToGameTypes failed: " & ex.Message)

         Finally
            ' DB Cleanup.
            If Not lSDA Is Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If
         End Try

      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function InsertCasinoMasterDealRow(ByVal aMasterDealDataRow As DataRow) As Boolean
      '--------------------------------------------------------------------------------
      ' Inserts a row into the Casino.MASTER_DEAL table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lReturn As Boolean = True
      Dim lOpCode As Integer = 1
      Dim lErrorText As String = ""
      Dim lErrorPrefix As String = Me.Name & "::InsertCasinoMasterDealRow error: "

      Try
         ' Create a new SqlDataAccess object instance.
         lSDA = New SqlDataAccess(gConnectRetail, False, 45)

         ' Add stored procedure parameters...
         With lSDA
            .AddParameter("@MasterDealID", SqlDbType.Int, aMasterDealDataRow.Item("MASTER_DEAL_ID"))
            .AddParameter("@TableName", SqlDbType.VarChar, aMasterDealDataRow.Item("TABLE_NAME"), 32)
            .AddParameter("@CoinsBet", SqlDbType.SmallInt, aMasterDealDataRow.Item("COINS_BET"))
            .AddParameter("@LinesBet", SqlDbType.TinyInt, aMasterDealDataRow.Item("LINES_BET"))
            .AddParameter("@ResultCount", SqlDbType.Int, aMasterDealDataRow.Item("RESULT_COUNT"))
            .AddParameter("@HoldPercent", SqlDbType.TinyInt, aMasterDealDataRow.Item("HOLD_PERCENT"))
            .AddParameter("@IsActive", SqlDbType.Bit, aMasterDealDataRow.Item("IS_ACTIVE"))

            lOpCode += 1

            ' Attempt to execute the stored procedure.
            .ExecuteProcedureNoResult("diInsertMasterDeal")
         End With

      Catch ex As Exception When lOpCode = 1
         lErrorText = lErrorPrefix & "adding sp parameters: " & ex.Message

      Catch ex As Exception When lOpCode = 2
         lErrorText = lErrorPrefix & "executing diInsertMasterDeal: " & ex.Message

      Catch ex As Exception
         ' Handle the error.
         lErrorText = lErrorPrefix & ex.Message

      Finally
         ' Free the database object...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Any errors?
      If lErrorText.Length > 0 Then
         ' An error occurred, reset the return value, log it, and show it...
         lReturn = False
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Insert Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function LoadMasterDeals() As Boolean
      '--------------------------------------------------------------------------------
      ' Loads Master Deals.
      ' Returns T/F to indicate success of failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDTMD As DataTable
      Dim lDR As DataRow

      Dim lBaseName As String = ""
      Dim lDetailText As String = ""
      Dim lErrorText As String = ""
      Dim lMasterTable As String
      Dim lSQL As String
      Dim lTableName As String
      Dim lUserMsg As String = ""

      Dim lReturn As Boolean = True
      Dim lSuccess As Boolean

      Dim lReturnCode As Integer

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lUpdateCount As Integer = 0

      Try
         ' Open a connectionn to the LotteryRetail database so we can insert IMPORT_MD_DETAIL rows.
         lSDA = New SqlDataAccess(gConnectRetail, True, 240)
         lMasterTable = "MASTER_DEAL"

         ' Yes, so we can continue. Set a reference to the MASTER_DEAL table in mDSCasinoSetupData.
         lDTMD = mDSCasinoSetupData.Tables(lMasterTable)

         ' Walk the rows in the table...
         For Each lDR In lDTMD.Rows
            ' Get the table name.
            lTableName = lDR.Item("TABLE_NAME")

            ' Update the UI...
            lUserMsg = String.Format("Creating Master Deal table {0}...", lTableName)

            With sbrStatus
               .Text = lUserMsg
               .Refresh()
            End With

            ' Let Windows breath.
            Application.DoEvents()

            lReturnCode = CreateMasterDealTable(lTableName, lErrorText)
            ' Return codes:
            '              1 = success'
            '              0 = db error
            '             -1 = file does not exist
            '             -2 = MasterDeal table already exists

            ' Log any error text returned from CreateMasterDealTable.
            If lErrorText.Length > 0 Then Logging.Log(lErrorText)

            Select Case lReturnCode
               Case -2
                  ' MasterDeal table already exists.
                  lDetailText = String.Format("Table {0} already exists.", lTableName)
                  lErrorText = lDetailText
                  lErrorCount = 1
                  lReturn = False

               Case -1
                  ' Source file not found.
                  lDetailText = String.Format("Source file for {0} does not exist.", lTableName)
                  lErrorText = lDetailText
                  lErrorCount = 1
                  lReturn = False

               Case 0
                  ' Database error occurred.
                  lDetailText = String.Format("Database error occured while attempting to create and populate table {0}.", lTableName)
                  lErrorText = lDetailText
                  lErrorCount = 1
                  lReturn = False

               Case 1
                  ' Successfully created eTab.MasterDeal table.
                  ' Insert a row into either the Casino.MASTER_DEAL table.
                  lSuccess = InsertCasinoMasterDealRow(lDR)
                  If lSuccess Then
                     ' Successful
                     lInsertCount = 1
                     lDetailText = String.Format("Successfully created and loaded table {0}.", lTableName)
                  Else
                     ' LotteryRetail Master table (compact or bingo) insert failed.
                     lErrorCount = 1
                     lReturn = False
                     lErrorText = "Failed to insert MASTER_DEAL record."
                     lDetailText = String.Format("Failed to insert {0} {1} record.", lTableName, lMasterTable)
                  End If
            End Select

            ' Insert a row into the Import MD Detail table...
            lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Exit from the loop if problems encountered...
            If Not lReturn Then Exit For
         Next

      Catch ex As Exception
         ' Handle the exception...
         lReturn = False
         lErrorText = Me.Name & "::LoadMasterDeals error: " & ex.Message
      End Try

      ' Database object cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' If there was an error, log it and show the user...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function LoadSetupData() As Boolean
      '--------------------------------------------------------------------------------
      ' Loads the Setup Data that accompanies Master Deal data.
      ' Returns T/F to indicate success of failure.
      '
      ' Note: This routine does not setup a row in the DEAL_SETUP table, that's done by
      '       the Deal Server Service which calls stored procedure dsInsertDealSetup.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True
      Dim lRowCount As Integer

      ' Update UI...
      With sbrStatus
         .Text = "Loading LotteryRetail database setup data..."
         .Refresh()
      End With
      Application.DoEvents()

      ' Begin with the Casino table...
      If mImportFlags.CasinoTable Then
         ' Export user indicated that the Casino table is to be updated.
         lReturn = UpdateCasinoTable()
      End If

      ' Update the PRODUCT table.
      If lReturn Then lReturn = UpdateProductTable()

      ' Update the PRODUCT_LINE table.
      If lReturn Then lReturn = UpdateProductLineTable()

      ' Update the GAME_CATEGORY table.
      If lReturn Then lReturn = UpdateGameCategoryTable()

      ' Update the PROGRESSIVE_TYPE table.
      If lReturn Then lReturn = UpdateProgressiveTypeTable()

      ' Update the GAME_TYPE table.
      If lReturn Then lReturn = UpdateGameTypeTable()

      ' Update the PROGRESSIVE_POOL table.
      If lReturn Then lReturn = UpdateProgressivePoolTable()

      ' Update the PROG_AWARD_FACTOR table.
      If lReturn Then lReturn = UpdateProgAwardFactorTable()

      ' Update the GAME_SETUP table.
      If lReturn Then lReturn = UpdateGameSetupTable()

      ' Update the DENOM_TO_GAME_TYPE table.
      If lReturn Then
         ' If DenomToGameTypeUpdate flag is set, we will drop the existing rows first.
         lRowCount = 0
         If mImportFlags.DenomToGameTypeUpdate Then
            lRowCount = DropDenomToGameType()
         End If

         ' Update the DENOM_TO_GAME_TYPE table.
         If lRowCount > -1 Then
            lReturn = UpdateDenomTable(lRowCount)
         Else
            lReturn = False
         End If
      End If

      ' Update the COINS_BET_TO_GAME_TYPE table.
      If lReturn Then
         ' If CoinsBetToGameTypeUpdate flag is set, we will drop the existing rows first.
         lRowCount = 0
         If mImportFlags.CoinsBetToGameTypeUpdate Then
            lRowCount = DropCoinsBetToGameType()
         End If

         ' Update the COINS_BET_TO_GAME_TYPE table.
         If lRowCount > -1 Then
            lReturn = UpdateCoinsBetTable(lRowCount)
         Else
            lReturn = False
         End If
      End If

      ' Update the LINES_BET_TO_GAME_TYPE table.
      If lReturn Then
         ' If LinesBetToGameTypeUpdate flag is set, we will drop the existing rows first.
         lRowCount = 0
         If mImportFlags.LinesBetToGameTypeUpdate Then
            lRowCount = DropLinesBetToGameType()
         End If

         ' Update the LINES_BET_TO_GAME_TYPE table.
         If lRowCount > -1 Then
            lReturn = UpdateLinesBetTable(lRowCount)
         Else
            lReturn = False
         End If
      End If

      ' Update the PAYSCALE table.
      If lReturn Then lReturn = UpdatePayscaleTable()

      ' Update the PAYSCALE_TIER table.
      If lReturn Then lReturn = UpdatePayscaleTierTable()

      ' Update the PAYSCALE_TIER_KENO table.
      If lReturn Then lReturn = UpdatePayscaleTierKenoTable()

      ' Update the CASINO_FORMS table.
      If lReturn Then lReturn = UpdateCasinoFormsTable()

      ' Update the WINNING_TIERS table.
      If lReturn Then lReturn = UpdateWinningTiersTable()

      ' Update the FLARE table.
      If lReturn Then lReturn = UpdateFlareTable()

      ' Update the FLARE_HEADER table.
      If lReturn Then
         If mImportFlags.FlareUpdate Then
            lRowCount = 0
            lRowCount = DropFlareHeaders()
         End If

         ' Update the FLARE_HEADER table.
         If lRowCount > -1 Then
            lReturn = UpdateFlareHeaderTable(lRowCount)
         Else
            lReturn = False
         End If
      End If

      ' Update the FLARE_TIER table.
      If lReturn Then
         If mImportFlags.FlareUpdate Then
            lRowCount = 0
            lRowCount = DropFlareTiers()
         End If

         ' Update the FLARE_TIER table.
         If lRowCount > -1 Then
            lReturn = UpdateFlareTierTable(lRowCount)
         Else
            lReturn = False
         End If
      End If

      ' If Bank and Machine tables are flagged, update them...
      If lReturn = True AndAlso mImportFlags.BankMachineTables = True Then
         ' Update the Bank table.
         lReturn = UpdateBankTable()

         ' Update the Machine table.
         If lReturn Then lReturn = UpdateMachineTable()
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function RetireMasterDealsDMD(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Retires specified Compact Master Deals.
      ' Also deactivates associated Forms, Deals, and eTabSequence rows
      ' Returns True or False to indicate success or failure.
      ' Populates aErrorText if errors are encountered.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lDetailHist As New HistoryDetail

      Dim lExportedBy As String
      Dim lFormNbr As String
      Dim lMasterTable As String
      Dim lSQL As String
      Dim lSQLBaseCF As String
      Dim lSQLBaseES As String
      Dim lSQLBaseDS As String
      Dim lSQLBaseMD As String

      Dim lCount As Integer
      Dim lDealNbr As Integer
      Dim lETabSequenceID As Integer
      Dim lMasterID As Integer

      Dim lReturn As Boolean = True

      ' Initialize error text to an empty string.
      aErrorText = ""

      ' Specify that parent id and detail table name that will be updated.
      With lDetailHist
         .DetailParentID = mImportMDHistoryID
         .UpdateTable = "IMPORT_MD_DETAIL"
      End With

      ' Store name of user that created the export set.
      lExportedBy = mImportFlags.ExportedBy

      ' Build SQL base strings...
      lSQLBaseDS = "UPDATE DEAL_SETUP SET IS_OPEN = 0, CLOSE_DATE = GetDate(), CLOSED_BY = '" & _
                 lExportedBy & "' WHERE DEAL_NO = {0} AND IS_OPEN = 1"
      lSQLBaseES = "DELETE FROM ETAB_SEQUENCE WHERE ETAB_SEQUENCE_ID = {0}"
      lSQLBaseCF = "UPDATE CASINO_FORMS SET IS_ACTIVE = 0 WHERE FORM_NUMB = '{0}' AND IS_ACTIVE = 1"
      lSQLBaseMD = "UPDATE MASTER_DEAL SET IS_ACTIVE = 0 WHERE MASTER_DEAL_ID = {0} AND IS_ACTIVE = 1"

      ' Set a reference to the DEAL_INFO DataTable.
      lDT = mDSRetireMD.Tables("DEAL_INFO")

      ' Begin by deactivating DEAL_SETUP rows.
      Try
         ' Instantiate a New SqlDataAccess object connected to the LotteryRetail database.
         lSDA = New SqlDataAccess(gConnectRetail, True, 120)

         ' Walk the Deal Info table and close deals associated with master deals being retired.
         ' We will also remove ETAB_SEQUENCE rows.
         For Each lDR In lDT.Rows
            lDealNbr = CType(lDR.Item("DEAL_NO"), Integer)
            lETabSequenceID = CType(lDR.Item("ETAB_SEQUENCE_ID"), Integer)

            With lDetailHist
               .TableName = "DEAL_SETUP"
               .DetailText = String.Format("Close Deal {0}.", lDealNbr)
               ' Reset counters...
               .ResetCounters()
            End With

            ' Build the DEAL_SETUP SQL UPDATE statement.
            lSQL = String.Format(lSQLBaseDS, lDealNbr)

            ' Perform the update.
            lCount = lSDA.ExecuteSQLNoReturn(lSQL)

            ' Set counts based upon the return value...
            If lCount > 0 Then
               lDetailHist.IncrementUpdated()
            Else
               lDetailHist.IncrementIgnored()
            End If

            ' Insert a row into the Import MD Detail table...
            lSQL = lDetailHist.SQLInsertText
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Remove ETAB_SEQUENCE table row for the Deal...
            With lDetailHist
               .TableName = "ETAB_SEQUENCE"
               .DetailText = String.Format("Drop ETAB_SEQUENCE ID {0} Deal {1}.", lETabSequenceID, lDealNbr)
               ' Reset counters...
               .ResetCounters()
            End With
            lSQL = String.Format(lSQLBaseES, lETabSequenceID)
            lCount = lSDA.ExecuteSQLNoReturn(lSQL)

            ' Set counts based upon the return value...
            If lCount > 0 Then
               lDetailHist.IncrementUpdated()
            Else
               lDetailHist.IncrementIgnored()
            End If

            ' Insert a row into the Import MD Detail table...
            lSQL = lDetailHist.SQLInsertText
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Update any ETAB_SEQUENCE rows that point to the deleted row to point to nothing.
            lSQL = String.Format("UPDATE ETAB_SEQUENCE SET NEXT_DEAL = 0 WHERE NEXT_DEAL = {0}", lETabSequenceID)
            lCount = lSDA.ExecuteSQLNoReturn(lSQL)

            ' Prepare values for insert into Import MD Detail table...
            With lDetailHist
               .TableName = "eTab.Deal" & lDealNbr.ToString
               .DetailText = String.Format("Drop eTab.Deal{0}.", lDealNbr)
               ' Reset counters...
               lDetailHist.ResetCounters()
            End With

            ' Drop the eTab database Deal table.
            If DropDealTableDMD(lDealNbr) Then
               lDetailHist.IncrementUpdated()
            Else
               lDetailHist.IncrementErrors()
            End If

            ' Insert a row into the Import MD Detail table...
            lSQL = lDetailHist.SQLInsertText
            lSDA.ExecuteSQLNoReturn(lSQL)
         Next

         ' Set a reference to the FORM_INFO DataTable.
         lDT = mDSRetireMD.Tables("FORM_INFO")

         ' Walk the Form Info table and deactivate the forms associated with master deals being retired.
         lDetailHist.TableName = "CASINO_FORMS"
         For Each lDR In lDT.Rows
            ' Store form number.
            lFormNbr = lDR.Item("FORM_NUMB")

            lSQL = String.Format(lSQLBaseCF, lFormNbr)
            lCount = lSDA.ExecuteSQLNoReturn(lSQL)

            With lDetailHist
               .DetailText = String.Format("Deactivate Form {0}.", lFormNbr)
               ' Reset counters...
               .ResetCounters()
            End With

            ' Set counts based upon the return value...
            If lCount > 0 Then
               lDetailHist.IncrementUpdated()
            Else
               lDetailHist.IncrementIgnored()
            End If

            ' Insert a row into the Import MD Detail table...
            lSQL = lDetailHist.SQLInsertText
            lSDA.ExecuteSQLNoReturn(lSQL)
         Next

         ' Set a reference to the MASTER_DEAL DataTable.
         lDetailHist.TableName = "MASTER_DEAL"
         lDT = mDSRetireMD.Tables("MASTER_DEAL")
         For Each lDR In lDT.Rows
            lMasterID = lDR.Item("MASTER_DEAL_ID")
            lMasterTable = lDR.Item("TABLE_NAME")

            With lDetailHist
               .DetailText = String.Format("Deactivate Master Deal {0} ({1}).", lMasterID, lMasterTable)
               ' Reset counters...
               .ResetCounters()
            End With

            lSQL = String.Format(lSQLBaseMD, lMasterID)
            lCount = lSDA.ExecuteSQLNoReturn(lSQL)

            ' Set counts based upon the return value...
            If lCount > 0 Then
               lDetailHist.IncrementUpdated()
            Else
               lDetailHist.IncrementIgnored()
            End If

            ' Insert a row into the Import MD Detail table...
            lSQL = lDetailHist.SQLInsertText
            lSDA.ExecuteSQLNoReturn(lSQL)
         Next

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         aErrorText = Me.Name & String.Format("::RetireMasterDealsDMD:Table {0}: Error : ", lDetailHist.TableName) & ex.Message

      End Try

      ' Close and free the database object...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function StartService(ByVal aServiceName As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Attempts to start the specified service.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSC As New ServiceController
      Dim lErrorText As String
      Dim lReturn As Boolean = True

      Try
         With lSC
            ' Assign the ServiceName property value.
            .ServiceName = aServiceName
            ' Refresh to get the current service values.
            .Refresh()

            ' Is the service running?
            If lSC.Status <> ServiceControllerStatus.Running Then
               ' No, so attempt to start it.
               lSC.Start()
            End If
         End With

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = Me.Name & String.Format("::StartService ({0})", aServiceName) & ex.Message
         Logging.Log(lErrorText)
      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function StopService(ByVal aServiceName As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Attempts to stop the specified service.
      ' Returns True if the service was found, was running, and was successfully stopped.
      ' Returns False in any other case.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSC As New ServiceController
      Dim lErrorText As String
      Dim lReturn As Boolean = False

      Try
         With lSC
            ' Assign the ServiceName property value.
            .ServiceName = aServiceName
            ' Refresh to get the current service values.
            .Refresh()

            ' Is the service running?
            If lSC.Status = ServiceControllerStatus.Running Then
               If lSC.CanStop Then
                  lSC.Stop()
                  lReturn = True
               End If
            End If
         End With

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = Me.Name & String.Format("::StopService ({0})", aServiceName) & ex.Message
         Logging.Log(lErrorText)
      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateBankTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Bank table.
      ' Called only if mImportFlags.BankMachineTables = True.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Boolean = True

      Dim lDetailText As String = "BANK Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lUpdateCount As Integer = 0
      Dim lSpReturnCode As Integer

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the BANK table.
         For Each lDR In mDSCasinoSetupData.Tables("BANK").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@BankNo", SqlDbType.Int, lDR.Item("BANK_NO"))
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@ProgFlag", SqlDbType.Bit, lDR.Item("PROG_FLAG"))
               .AddParameter("@IsPaper", SqlDbType.Bit, lDR.Item("IS_PAPER"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))
               .AddParameter("@BankDesc", SqlDbType.VarChar, lDR.Item("BANK_DESCR"), 128)
               .AddParameter("@ProductLineID", SqlDbType.SmallInt, lDR.Item("PRODUCT_LINE_ID"))
               .AddParameter("@LockupAmount", SqlDbType.SmallMoney, lDR("LOCKUP_AMOUNT"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.BankUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertBank")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertBank failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lErrorText = Me.Name & "::UpdateBankTable: " & lErrorText
         lDetailText = "Error importing BANK data."
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "BANK", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateCasinoFormsTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoForms table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CASINO_FORMS Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lHoldPercent As Decimal

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the CASINO_FORMS table.
         For Each lDR In mDSCasinoSetupData.Tables("CASINO_FORMS").Rows
            ' Round any hold percentages that have a fractional component.
            lHoldPercent = Math.Round(lDR.Item("HOLD_PERCENT"), 0)

            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@FormNbr", SqlDbType.VarChar, lDR.Item("FORM_NUMB"), 16)
               .AddParameter("@DealType", SqlDbType.Char, lDR.Item("DEAL_TYPE"), 1)
               .AddParameter("@CostPerTab", SqlDbType.SmallMoney, lDR.Item("COST_PER_TAB"))
               .AddParameter("@NbrRolls", SqlDbType.Int, lDR.Item("NUMB_ROLLS"))
               .AddParameter("@TabsPerRoll", SqlDbType.Int, lDR.Item("TABS_PER_ROLL"))
               .AddParameter("@TabsPerDeal", SqlDbType.Int, lDR.Item("TABS_PER_DEAL"))
               .AddParameter("@WinsPerDeal", SqlDbType.Int, lDR.Item("WINS_PER_DEAL"))
               .AddParameter("@TotalAmtIn", SqlDbType.Money, lDR.Item("TOTAL_AMT_IN"))
               .AddParameter("@TotalAmtOut", SqlDbType.Money, lDR.Item("TOTAL_AMT_OUT"))
               .AddParameter("@FormDesc", SqlDbType.VarChar, lDR.Item("FORM_DESC"), 30)
               .AddParameter("@TabAmt", SqlDbType.SmallMoney, lDR.Item("TAB_AMT"))
               .AddParameter("@IsRevShare", SqlDbType.Bit, lDR.Item("IS_REV_SHARE"))
               .AddParameter("@DGERevPercent", SqlDbType.TinyInt, lDR.Item("DGE_REV_PERCENT"))
               .AddParameter("@JPAmount", SqlDbType.Money, lDR.Item("JP_AMOUNT"))
               ' Exports created before the JACKPOT_COUNT column was added to Forms table will not have the JACKPOT_COUNT column in the exported resultset.
               ' If the column is not present, the stored procedure will default a value of 0 into the JACKPOT_COUNT column.
               If mDSCasinoSetupData.Tables("CASINO_FORMS").Columns.Contains("JACKPOT_COUNT") Then .AddParameter("@JackpotCount", SqlDbType.Int, lDR("JACKPOT_COUNT"))
               ' @ProdInd and @ProdPct were dropped in version 6.0.8
               .AddParameter("@Denomination", SqlDbType.SmallMoney, lDR.Item("DENOMINATION"))
               .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))
               .AddParameter("@LinesBet", SqlDbType.SmallInt, lDR.Item("LINES_BET"))
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@PayscaleMultiplier", SqlDbType.TinyInt, lDR.Item("PAYSCALE_MULTIPLIER"))
               .AddParameter("@MasterDealID", SqlDbType.Int, lDR.Item("MASTER_DEAL_ID"))
               .AddParameter("@HoldPercent", SqlDbType.Decimal, lHoldPercent)
               .AddParameter("@IsPaper", SqlDbType.Bit, lDR.Item("IS_PAPER"))
               ' Exports created before micro tab support was added will not have the IS_MICRO_TAB column.
               ' If the column is not present, the stored procedure will default a value of 0 into the IS_MICRO_TAB column.
               If mDSCasinoSetupData.Tables("CASINO_FORMS").Columns.Contains("IS_MICRO_TAB") Then .AddParameter("@IsMicroTab", SqlDbType.Bit, lDR("IS_MICRO_TAB"))

               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.FormUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertCasinoForms")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertCasinoForms failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lErrorText = Me.Name & "::UpdateCasinoFormsTable: " & lErrorText
         lDetailText = "Error importing CASINO_FORMS data."
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "CASINO_FORMS", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateCasinoTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Casino table.
      ' Only called if mImportFlags.CasinoTable = True.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CASINO Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Set a reference to the first row in the Casino table.
         lDR = mDSCasinoSetupData.Tables("CASINO").Rows(0)

         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         With lSDA
            ' Add the stored procedure parameters...
            .AddParameter("@CasinoID", SqlDbType.Char, lDR.Item("CAS_ID"), 6)
            .AddParameter("@CasinoName", SqlDbType.VarChar, lDR.Item("CAS_NAME"), 48)
            .AddParameter("@LockupAmt", SqlDbType.SmallMoney, lDR.Item("LOCKUP_AMT"))
            .AddParameter("@FromTime", SqlDbType.DateTime, lDR.Item("FROM_TIME"))
            .AddParameter("@ToTime", SqlDbType.DateTime, lDR.Item("TO_TIME"))
            .AddParameter("@ClaimTimeout", SqlDbType.SmallInt, lDR.Item("CLAIM_TIMEOUT"))
            .AddParameter("@DaubTimeout", SqlDbType.SmallInt, lDR.Item("DAUB_TIMEOUT"))
            .AddParameter("@BingoFreeSquare", SqlDbType.Bit, lDR.Item("BINGO_FREE_SQUARE"))
            .AddParameter("@CardType", SqlDbType.TinyInt, lDR.Item("CARD_TYPE"))
            .AddParameter("@PlayerCard", SqlDbType.Bit, lDR.Item("PLAYER_CARD"))
            .AddParameter("@ReceiptPrinter", SqlDbType.Bit, lDR.Item("RECEIPT_PRINTER"))
            .AddParameter("@DisplayProgressive", SqlDbType.Bit, lDR.Item("DISPLAY_PROGRESSIVE"))
            .AddParameter("@TpiID", SqlDbType.Int, lDR.Item("TPI_ID"))
            .AddParameter("@ReprintTicket", SqlDbType.Bit, lDR.Item("REPRINT_TICKET"))
            .AddParameter("@SummarizePlay", SqlDbType.Bit, lDR.Item("SUMMARIZE_PLAY"))
         End With

      Catch ex As Exception
         ' Handle the error...
         lErrorText = "Error Adding Parameters: " & ex.Message

      End Try

      If lErrorText.Length = 0 Then
         Try
            ' Execute diInsertCasino.
            lSDA.ExecuteProcedureNoResult("diInsertCasino")

            ' Capture the value returned from the procedure.
            lSpReturnCode = lSDA.ReturnValue

            ' 0 means successful insertion, 1 means successful update, anything else means an error occurred.
            If lSpReturnCode < 0 OrElse lSpReturnCode > 1 Then
               lReturn = False
               lErrorText = String.Format("diInsertCasino failed, returned {0}.", lSpReturnCode)
            End If

         Catch ex As Exception
            ' Handle the error...
            lErrorText = "Error executing diInsertCasino: " & ex.Message

         End Try
      End If

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so reset the return value, set, log, and show the error...
         lReturn = False
         lDetailText = "Error importing CASINO data."
         lErrorText = Me.Name & "::UpdateCasinoTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table...
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "CASINO", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)

      Try
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the error...
         lErrorText = Me.Name & "::UpdateCasinoTable error while attempting to update the IMPORT_MD_DETAIL table: " & ex.Message
         lReturn = False
      End Try

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateCoinsBetTable(ByVal aRowCount As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CoinsBetToGameType table.
      ' aRowCount will contain the number of rows deleted prior to this function call.
      '
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "COINS_BET_TO_GAME_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the COINS_BET_TO_GAME_TYPE table.
         For Each lDR In mDSCasinoSetupData.Tables("COINS_BET_TO_GAME_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertCoinsBetToGameType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means already exists and ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Already exists, ignored.
                  lIgnoredCount += 1

               Case Else
                  ' Database error occurred.
                  lReturn = False
                  lErrorText = String.Format("diInsertCoinsBetToGameType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing COINS_BET_TO_GAME_TYPE data."
         lErrorText = Me.Name & "::UpdateCoinsBetTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      Else
         ' If updating, show number of rows replaced in detail text.
         If mImportFlags.CoinsBetToGameTypeUpdate Then lDetailText &= String.Format(" Replaced {0} rows.", aRowCount)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "COINS_BET_TO_GAME_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateDenomTable(ByVal aRowCount As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the DenomToGameType table.
      ' aRowCount will contain the number of rows deleted prior to this function call.
      ' 
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "DENOM_TO_GAME_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the DENOM_TO_GAME_TYPE table.
         For Each lDR In mDSCasinoSetupData.Tables("DENOM_TO_GAME_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@Denom", SqlDbType.SmallMoney, lDR.Item("DENOM_VALUE"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertDenomToGameType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means already exists and ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Already exists, ignored.
                  lIgnoredCount += 1

               Case Else
                  ' Database error occurred.
                  lReturn = False
                  lErrorText = String.Format("diInsertDenomToGameType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing DENOM_TO_GAME_TYPE data."
         lErrorText = Me.Name & "::UpdateDenomTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      Else
         ' If updating, show number of rows replaced in detail text.
         If mImportFlags.DenomToGameTypeUpdate Then lDetailText &= String.Format(" Replaced {0} rows.", aRowCount)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "DENOM_TO_GAME_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateFlareTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the FLARE table.
      ' 
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "FLARE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the FLARE table.
         For Each lDR In mDSCasinoSetupData.Tables("FLARE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@FlareID", SqlDbType.Int, lDR.Item("FLARE_ID"))
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"))
               .AddParameter("@BetComboCount", SqlDbType.SmallInt, lDR.Item("BET_COMBO_COUNT"))
               .AddParameter("@TierCount", SqlDbType.SmallInt, lDR.Item("TIER_COUNT"))
               .AddParameter("@DenomList", SqlDbType.VarChar, lDR.Item("DENOM_LIST"), 256)
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.FlareUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertFlare")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means already exists and ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Already exists, ignored.
                  lIgnoredCount += 1

               Case Else
                  ' Database error occurred.
                  lReturn = False
                  lErrorText = String.Format("diInsertFlare failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing Flare data."
         lErrorText = Me.Name & "::UpdateFlareTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "FLARE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateFlareHeaderTable(ByVal aRowCount As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the FLARE_HEADER table.
      ' aRowCount will contain the number of rows deleted prior to this function call.
      ' 
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "FLARE_HEADER Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the FLARE_HEADER table.
         For Each lDR In mDSCasinoSetupData.Tables("FLARE_HEADER").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@FlareHeaderID", SqlDbType.Int, lDR.Item("FLARE_HEADER_ID"))
               .AddParameter("@FlareID", SqlDbType.Int, lDR.Item("FLARE_ID"))
               .AddParameter("@ColumnNumber", SqlDbType.SmallInt, lDR.Item("COLUMN_NUMBER"))
               .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LINES_BET"))
               .AddParameter("@CreditsBet", SqlDbType.VarChar, lDR.Item("CREDITS_BET"), 64)
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.FlareUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertFlareHeader")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means already exists and ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Already exists, ignored.
                  lIgnoredCount += 1

               Case Else
                  ' Database error occurred.
                  lReturn = False
                  lErrorText = String.Format("diInsertFlareHeader failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing FlareHeader data."
         lErrorText = Me.Name & "::UpdateFlareHeaderTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      Else
         ' If updating, show number of rows replaced in detail text.
         If mImportFlags.FlareUpdate Then lDetailText &= String.Format(" Replaced {0} rows.", aRowCount)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "FLARE_HEADER", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateFlareTierTable(ByVal aRowCount As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the FLARE_TIER table.
      ' aRowCount will contain the number of rows deleted prior to this function call.
      ' 
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "FLARE_TIER Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the FLARE_TIER table.
         For Each lDR In mDSCasinoSetupData.Tables("FLARE_TIER").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@FlareTierID", SqlDbType.Int, lDR.Item("FLARE_TIER_ID"))
               .AddParameter("@FlareID", SqlDbType.Int, lDR.Item("FLARE_ID"))
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
               .AddParameter("@Symbols", SqlDbType.VarChar, lDR.Item("SYMBOLS"), 32)
               .AddParameter("@DisplayText", SqlDbType.VarChar, lDR.Item("DISPLAY_TEXT"), 64)
               .AddParameter("@BaseCredits", SqlDbType.Int, lDR.Item("BASE_CREDITS"))
               .AddParameter("@FlareTierName", SqlDbType.VarChar, lDR.Item("FLARE_TIER_NAME"), 32)
               .AddParameter("@WinCountList", SqlDbType.VarChar, lDR.Item("WIN_COUNT_LIST"), 256)
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.FlareUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertFlareTier")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means already exists and ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Already exists, ignored.
                  lIgnoredCount += 1

               Case Else
                  ' Database error occurred.
                  lReturn = False
                  lErrorText = String.Format("diInsertFlareHeader failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing FlareHeader data."
         lErrorText = Me.Name & "::UpdateFlareHeaderTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      Else
         ' If updating, show number of rows replaced in detail text.
         If mImportFlags.FlareUpdate Then lDetailText &= String.Format(" Replaced {0} rows.", aRowCount)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "FLARE_HEADER", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateGameCategoryTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the GAME_CATEGORY table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "GAME_CATEGORY Import successful."
      Dim lErrText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PRODUCT table.
         For Each lDR In mDSCasinoSetupData.Tables("GAME_CATEGORY").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameCategoryID", SqlDbType.Int, lDR.Item("GAME_CATEGORY_ID"))
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@LimitRTransTiers", SqlDbType.Bit, lDR.Item("LIMIT_RTRANS_TIERS"))
               .AddParameter("@SortOrder", SqlDbType.Int, lDR.Item("SORT_ORDER"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertGameCategory")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means successful update, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted. 0 = Successful row insertion
                  lInsertCount += 1
               Case 1
                  ' Updated. 1 = Record exists and update flag = 1 (record updated)
                  lUpdateCount += 1
               Case 2
                  ' Ignored. 2 = Record exists and update flag = 0 (update ignored)
                  lIgnoredCount += 1

               Case Else
                  lReturn = False
                  lErrText = String.Format("diInsertGameCategory failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrText = "Error updating the Product Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing GAME_CATEGORY data."
         lErrText = Me.Name & "::UpdateGameCategoryTable: " & lErrText
         Logging.Log(lErrText)
         MessageBox.Show(lErrText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         lDetailText = "Error importing GAME_CATEGORY data."
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "GAME_CATEGORY", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateGameSetupTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the GameSetup table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "GAME_SETUP Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the GAME_SETUP table.
         For Each lDR In mDSCasinoSetupData.Tables("GAME_SETUP").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameCode", SqlDbType.VarChar, lDR.Item("GAME_CODE"), 3)
               .AddParameter("@GameDesc", SqlDbType.VarChar, lDR.Item("GAME_DESC"), 64)
               .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("TYPE_ID"), 1)
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@GameTitleID", SqlDbType.Int, lDR.Item("GAME_TITLE_ID"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameSetupUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertGameSetup")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertGameSetup failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing GAME_SETUP data."
         lErrorText = Me.Name & "::UpdateGameSetupTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "GAME_SETUP", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateGameTypeTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the GameType table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "GAME_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the GAME_TYPE table.
         For Each lDR In mDSCasinoSetupData.Tables("GAME_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("TYPE_ID"), 1)
               .AddParameter("@ProductID", SqlDbType.TinyInt, lDR.Item("PRODUCT_ID"))
               .AddParameter("@ProgressiveTypeID", SqlDbType.TinyInt, lDR.Item("PROGRESSIVE_TYPE_ID"))
               .AddParameter("@MaxCoinsBet", SqlDbType.SmallInt, lDR.Item("MAX_COINS_BET"))
               .AddParameter("@MaxLinesBet", SqlDbType.TinyInt, lDR.Item("MAX_LINES_BET"))
               .AddParameter("@GameCategoryID", SqlDbType.Int, lDR.Item("GAME_CATEGORY_ID"))
               .AddParameter("@BarcodeTypeID", SqlDbType.SmallInt, lDR.Item("BARCODE_TYPE_ID"))
               .AddParameter("@ShowPayCredits", SqlDbType.Bit, lDR.Item("SHOW_PAY_CREDITS"))
               .AddParameter("@MultiBetDeals", SqlDbType.Bit, lDR.Item("MULTI_BET_DEALS"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameTypeUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertGameType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertGameType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing GAME_TYPE data."
         lErrorText = Me.Name & "::UpdateGameTypeTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "GAME_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateLinesBetTable(ByVal aRowCount As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the LinesBetToGameType table.
      ' aRowCount will contain the number of rows deleted prior to this function call.
      '
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "LINES_BET_TO_GAME_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the LINES_BET_TO_GAME_TYPE table.
         For Each lDR In mDSCasinoSetupData.Tables("LINES_BET_TO_GAME_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LINES_BET"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertLinesBetToGameType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means already exists and ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Already exists, ignored.
                  lIgnoredCount += 1

               Case Else
                  ' Database error occurred.
                  lReturn = False
                  lErrorText = String.Format("diInsertLinesBetToGameType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing LINES_BET_TO_GAME_TYPE data."
         lErrorText = Me.Name & "::UpdateLinesBetTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      Else
         ' If updating, show number of rows replaced in detail text.
         If mImportFlags.LinesBetToGameTypeUpdate Then lDetailText &= String.Format(" Replaced {0} rows.", aRowCount)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "LINES_BET_TO_GAME_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateMachineTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Machine table.
      ' Called only if mImportFlags.BankMachineTables = True.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "MACH_SETUP Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the MACH_SETUP table.
         For Each lDR In mDSCasinoSetupData.Tables("MACH_SETUP").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@MachNo", SqlDbType.Char, lDR.Item("MACH_NO"), 5)
               .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("TYPE_ID"), 1)
               .AddParameter("@ModelDesc", SqlDbType.VarChar, lDR.Item("MODEL_DESC"), 64)
               .AddParameter("@BankNo", SqlDbType.Int, lDR.Item("BANK_NO"))
               .AddParameter("@GameCode", SqlDbType.VarChar, lDR.Item("GAME_CODE"), 3)
               .AddParameter("@RemovedFlag", SqlDbType.Bit, lDR.Item("REMOVED_FLAG"))
               .AddParameter("@IPAddress", SqlDbType.VarChar, lDR.Item("IP_ADDRESS"), 24)
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.MachineUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertMachSetup")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertMachSetup failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing MACH_SETUP data."
         lErrorText = Me.Name & "::UpdateMachineTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "MACH_SETUP", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdatePayscaleTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Payscale table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PAYSCALE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PAYSCALE table.
         For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PAYSCALE_NAME"), 16)
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.PayscaleUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertPayscale")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertPayscale failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PAYSCALE data."
         lErrorText = Me.Name & "::UpdatePayscaleTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PAYSCALE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdatePayscaleTierKenoTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PayscaleTierKeno table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PAYSCALE_TIER_KENO Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PAYSCALE_TIER_KENO table.
         For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE_TIER_KENO").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PAYSCALE_NAME"), 16)
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
               .AddParameter("@PickCount", SqlDbType.SmallInt, lDR.Item("PICK_COUNT"))
               .AddParameter("@HitCount", SqlDbType.SmallInt, lDR.Item("HIT_COUNT"))
               .AddParameter("@AwardFactor", SqlDbType.Decimal, lDR.Item("AWARD_FACTOR"))
               .AddParameter("@TierWinType", SqlDbType.TinyInt, lDR.Item("TIER_WIN_TYPE"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.PayscaleTierUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertPayscaleTierKeno")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertPayscaleTierKeno failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PAYSCALE_TIER_KENO data."
         lErrorText = Me.Name & "::UpdatePayscaleTierKenoTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PAYSCALE_TIER_KENO", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdatePayscaleTierTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PayscaleTier table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PAYSCALE_TIER Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PAYSCALE_TIER table.
         For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE_TIER").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PAYSCALE_NAME"), 16)
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
               .AddParameter("@CoinsWon", SqlDbType.Int, lDR.Item("COINS_WON"))
               .AddParameter("@Icons", SqlDbType.VarChar, lDR.Item("ICONS"), 32)
               .AddParameter("@IconMask", SqlDbType.VarChar, lDR.Item("ICON_MASK"), 32)
               .AddParameter("@TierWinType", SqlDbType.TinyInt, lDR.Item("TIER_WIN_TYPE"))
               .AddParameter("@UseMultiplier", SqlDbType.Bit, lDR.Item("USE_MULTIPLIER"))
               .AddParameter("@ScatterCount", SqlDbType.TinyInt, lDR.Item("SCATTER_COUNT"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.PayscaleTierUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertPayscaleTier")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertPayscaleTier failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PAYSCALE_TIER data."
         lErrorText = Me.Name & "::UpdatePayscaleTierTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PAYSCALE_TIER", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProductLineTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the ProductLine table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PRODUCT_LINE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PRODUCT_LINE table.
         For Each lDR In mDSCasinoSetupData.Tables("PRODUCT_LINE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@ProductLineID", SqlDbType.SmallInt, lDR.Item("PRODUCT_LINE_ID"))
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@GameClass", SqlDbType.SmallInt, lDR.Item("GAME_CLASS"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertProductLine")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means successful update, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' New row successfully inserted.
                  lInsertCount += 1
               Case 1
                  ' Existing row successfully updated.
                  lUpdateCount += 1
               Case Else
                  ' Database error.
                  lReturn = False
                  lErrorText = String.Format("diInsertProductLine failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PRODUCT_LINE data."
         lErrorText = Me.Name & "::UpdateProductLineTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PRODUCT_LINE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProductTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Product table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PRODUCT Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PRODUCT table.
         For Each lDR In mDSCasinoSetupData.Tables("PRODUCT").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@ProductID", SqlDbType.TinyInt, lDR.Item("PRODUCT_ID"))
               .AddParameter("@ProductName", SqlDbType.VarChar, lDR.Item("PRODUCT_DESCRIPTION"), 64)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertProduct")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means successful update, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Updated.
                  lUpdateCount += 1
               Case Else
                  lReturn = False
                  lErrorText = String.Format("diInsertProduct failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = "Error updating the Product Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PRODUCT data."
         lErrorText = Me.Name & "::UpdateProductTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PRODUCT", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProgAwardFactorTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PROG_AWARD_FACTOR table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lDetailText As String = "PROG_AWARD_FACTOR Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to the PROG_AWARD_FACTOR table.
         lDT = mDSCasinoSetupData.Tables("PROG_AWARD_FACTOR")

         ' Process each row in the PROG_AWARD_FACTOR table...
         For Each lDR In lDT.Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@ProgAwardFactorID", SqlDbType.Int, lDR.Item("PROG_AWARD_FACTOR_ID"))
               .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
               .AddParameter("@AwardFactor", SqlDbType.Int, lDR.Item("AWARD_FACTOR"))
               ' We will use the Game Type update flag value.
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameTypeUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertProgAwardFactor")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertProgAwardFactor failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = "Error updating the PROG_AWARD_FACTOR Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PROG_AWARD_FACTOR data."
         lErrorText = Me.Name & "::UpdateProgAwardFactorTable error: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PROG_AWARD_FACTOR", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProgressivePoolTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PROGRESSIVE_POOL table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lDetailText As String = "PROGRESSIVE_POOL Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Set a reference to the PROGRESSIVE_POOL table.
         lDT = mDSCasinoSetupData.Tables("PROGRESSIVE_POOL")

         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Is there data to process?
         If lDT.Rows.Count > 0 Then
            ' Yes, so set a reference to each row in the PROGRESSIVE_POOL table.
            For Each lDR In lDT.Rows
               With lSDA
                  ' Add the stored procedure parameters...
                  .AddParameter("@ProgressivePoolID", SqlDbType.Int, lDR.Item("PROGRESSIVE_POOL_ID"))
                  .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
                  .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                  .AddParameter("@Denomination", SqlDbType.Int, lDR.Item("DENOMINATION"))
                  .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))
                  .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LINES_BET"))
                  .AddParameter("@Pool1", SqlDbType.Money, lDR.Item("POOL_1"))
                  .AddParameter("@Pool2", SqlDbType.Money, lDR.Item("POOL_2"))
                  .AddParameter("@Pool3", SqlDbType.Money, lDR.Item("POOL_3"))
                  ' We will use the Game Type update flag value.
                  .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameTypeUpdate)

                  ' Execute the procedure.
                  .ExecuteProcedureNoResult("diInsertProgressivePool")

                  ' Capture the value returned from the procedure.
                  lSpReturnCode = lSDA.ReturnValue
               End With

               ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
               Select Case lSpReturnCode
                  Case 0
                     ' Inserted a new record.
                     lInsertCount += 1
                  Case 1
                     ' Existing record Updated.
                     lUpdateCount += 1
                  Case 2
                     ' Existing record Ignored.
                     lIgnoredCount += 1
                  Case Else
                     ' Unexpected return code indicates that a stored procedure error occurred.
                     lErrorCount += 1
                     lReturn = False
                     lErrorText = String.Format("diInsertProgressivePool failed, returned {0}.", lSpReturnCode)
                     Exit For
               End Select
            Next
         End If

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = "Error updating the PROGRESSIVE_POOL Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PROGRESSIVE_POOL data."
         lErrorText = Me.Name & "::UpdateProgressivePoolTable error: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PROGRESSIVE_POOL", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProgressiveTypeTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PROGRESSIVE_TYPE table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PROGRESSIVE_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PROGRESSIVE_TYPE table.
         For Each lDR In mDSCasinoSetupData.Tables("PROGRESSIVE_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@PoolCount", SqlDbType.SmallInt, lDR.Item("POOL_COUNT"))
               .AddParameter("@TotalContribution", SqlDbType.Decimal, lDR.Item("TOTAL_CONTRIBUTION"))
               .AddParameter("@SeedCount", SqlDbType.Int, lDR.Item("SEED_COUNT"))
               .AddParameter("@Rate1", SqlDbType.Decimal, lDR.Item("RATE_1"))
               .AddParameter("@Rate2", SqlDbType.Decimal, lDR.Item("RATE_2"))
               .AddParameter("@Rate3", SqlDbType.Decimal, lDR.Item("RATE_3"))
               .AddParameter("@RateCombined", SqlDbType.Decimal, lDR.Item("RATE_COMBINED"))
               ' We will use the Game Type update flag value.
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameTypeUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertProgressiveType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertProgressiveType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = "Error updating the PROGRESSIVE_TYPE Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PROGRESSIVE_TYPE data."
         lErrorText = Me.Name & "::UpdateProgressiveTypeTable error: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PROGRESSIVE_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateWinningTiersTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the WinningTiers table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "WINNING_TIERS Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the WINNING_TIERS table.
         For Each lDR In mDSCasinoSetupData.Tables("WINNING_TIERS").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@NbrOfWinners", SqlDbType.Int, lDR.Item("NUMB_OF_WINNERS"))
               .AddParameter("@WinningAmount", SqlDbType.Money, lDR.Item("WINNING_AMOUNT"))
               .AddParameter("@FormNumber", SqlDbType.VarChar, lDR.Item("FORM_NUMB"), 10)
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
               .AddParameter("@CoinsWon", SqlDbType.Int, lDR.Item("COINS_WON"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.WinningTierUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertWinningTiers")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertWinningTiers failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = "Error Adding Parameters: " & ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing WINNING_TIERS data."
         lErrorText = Me.Name & "::UpdateWinningTiersTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "WINNING_TIERS", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateTierWinTypeBingo() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.TierWinType table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.TierWinType Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_BingoMaster table.
         For Each lDR In mDSCasinoSetupData.Tables("CB_TierWinType").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@TierWinTypeID", SqlDbType.Int, lDR.Item("TierWinTypeID"))
               .AddParameter("@Description", SqlDbType.VarChar, lDR.Item("Description"), 32)
               .AddParameter("@SortOrder", SqlDbType.SmallInt, lDR.Item("SortOrder"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IsActive"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, True)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertTierWinType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertTierWinType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message
         lDetailText = "CasinoBingo.TierWinType Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "TierWinType", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.TierWinType data."
         lErrorText = Me.Name & "::UpdateBingoTierWinType: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

#If DEBUG Then

   Private Sub lblSourceFolder_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lblSourceFolder.DoubleClick
      Dim lRC As Boolean
      Dim lErrorText As String = ""

      lRC = IsGoodCDROMData(lErrorText)
      If lRC Then
         MessageBox.Show("IsGoodCDROMData return True.", "IsGoodCDROMData Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
      Else
         MessageBox.Show(lErrorText, "IsGoodCDROMData Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

#End If

End Class
