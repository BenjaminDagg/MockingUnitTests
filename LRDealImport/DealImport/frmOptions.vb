Public Class frmOptions
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
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnOK As System.Windows.Forms.Button
   Friend WithEvents lblEdealDBCatalog As System.Windows.Forms.Label
   Friend WithEvents btnApply As System.Windows.Forms.Button
   Friend WithEvents txtEdealDBCatalog As System.Windows.Forms.TextBox
   Friend WithEvents OptionsTabControl As System.Windows.Forms.TabControl
   Friend WithEvents tabEDealDB As System.Windows.Forms.TabPage
   Friend WithEvents lblPassword As System.Windows.Forms.Label
   Friend WithEvents lblUserID As System.Windows.Forms.Label
   Friend WithEvents txtMillenniumDBCatalog As System.Windows.Forms.TextBox
   Friend WithEvents lblLRDatabase As System.Windows.Forms.Label
   Friend WithEvents txtMillenniumDBServer As System.Windows.Forms.TextBox
   Friend WithEvents lblServer As System.Windows.Forms.Label
   Friend WithEvents txtMillenniumDBPassword As System.Windows.Forms.TextBox
   Friend WithEvents txtMillenniumDBUserID As System.Windows.Forms.TextBox
   Friend WithEvents btnTestEDealConnection As System.Windows.Forms.Button
   Friend WithEvents btnTestMillenniumConnection As System.Windows.Forms.Button
   Friend WithEvents gbEdealConnInfo As System.Windows.Forms.GroupBox
   Friend WithEvents tabMillenniumDB As System.Windows.Forms.TabPage
   Friend WithEvents gbMillenniumConnInfo As System.Windows.Forms.GroupBox
   Friend WithEvents tabSourceLocation As System.Windows.Forms.TabPage
   Friend WithEvents gbSourceLocation As System.Windows.Forms.GroupBox
   Friend WithEvents lblSourceFolder As System.Windows.Forms.Label
   Friend WithEvents lblSourceFileName As System.Windows.Forms.Label
   Friend WithEvents txtSourceFolder As System.Windows.Forms.TextBox
   Friend WithEvents txtSourceFile As System.Windows.Forms.TextBox
   Friend WithEvents lblArchiveFolder As System.Windows.Forms.Label
   Friend WithEvents txtArchiveFolder As System.Windows.Forms.TextBox
   Friend WithEvents cbFreeSpaceCheck As System.Windows.Forms.CheckBox
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmOptions))
      Me.OptionsTabControl = New System.Windows.Forms.TabControl
      Me.tabMillenniumDB = New System.Windows.Forms.TabPage
      Me.gbMillenniumConnInfo = New System.Windows.Forms.GroupBox
      Me.btnTestMillenniumConnection = New System.Windows.Forms.Button
      Me.txtMillenniumDBPassword = New System.Windows.Forms.TextBox
      Me.lblPassword = New System.Windows.Forms.Label
      Me.txtMillenniumDBUserID = New System.Windows.Forms.TextBox
      Me.lblUserID = New System.Windows.Forms.Label
      Me.txtMillenniumDBCatalog = New System.Windows.Forms.TextBox
      Me.lblLRDatabase = New System.Windows.Forms.Label
      Me.txtMillenniumDBServer = New System.Windows.Forms.TextBox
      Me.lblServer = New System.Windows.Forms.Label
      Me.tabEDealDB = New System.Windows.Forms.TabPage
      Me.gbEdealConnInfo = New System.Windows.Forms.GroupBox
      Me.btnTestEDealConnection = New System.Windows.Forms.Button
      Me.txtEdealDBCatalog = New System.Windows.Forms.TextBox
      Me.lblEdealDBCatalog = New System.Windows.Forms.Label
      Me.tabSourceLocation = New System.Windows.Forms.TabPage
      Me.gbSourceLocation = New System.Windows.Forms.GroupBox
      Me.cbFreeSpaceCheck = New System.Windows.Forms.CheckBox
      Me.txtArchiveFolder = New System.Windows.Forms.TextBox
      Me.lblArchiveFolder = New System.Windows.Forms.Label
      Me.txtSourceFile = New System.Windows.Forms.TextBox
      Me.txtSourceFolder = New System.Windows.Forms.TextBox
      Me.lblSourceFileName = New System.Windows.Forms.Label
      Me.lblSourceFolder = New System.Windows.Forms.Label
      Me.btnCancel = New System.Windows.Forms.Button
      Me.btnOK = New System.Windows.Forms.Button
      Me.btnApply = New System.Windows.Forms.Button
      Me.OptionsTabControl.SuspendLayout()
      Me.tabMillenniumDB.SuspendLayout()
      Me.gbMillenniumConnInfo.SuspendLayout()
      Me.tabEDealDB.SuspendLayout()
      Me.gbEdealConnInfo.SuspendLayout()
      Me.tabSourceLocation.SuspendLayout()
      Me.gbSourceLocation.SuspendLayout()
      Me.SuspendLayout()
      '
      'OptionsTabControl
      '
      Me.OptionsTabControl.CausesValidation = False
      Me.OptionsTabControl.Controls.Add(Me.tabMillenniumDB)
      Me.OptionsTabControl.Controls.Add(Me.tabEDealDB)
      Me.OptionsTabControl.Controls.Add(Me.tabSourceLocation)
      Me.OptionsTabControl.Location = New System.Drawing.Point(8, 8)
      Me.OptionsTabControl.Name = "OptionsTabControl"
      Me.OptionsTabControl.SelectedIndex = 0
      Me.OptionsTabControl.Size = New System.Drawing.Size(415, 259)
      Me.OptionsTabControl.TabIndex = 0
      '
      'tabMillenniumDB
      '
      Me.tabMillenniumDB.CausesValidation = False
      Me.tabMillenniumDB.Controls.Add(Me.gbMillenniumConnInfo)
      Me.tabMillenniumDB.Location = New System.Drawing.Point(4, 22)
      Me.tabMillenniumDB.Name = "tabMillenniumDB"
      Me.tabMillenniumDB.Size = New System.Drawing.Size(407, 233)
      Me.tabMillenniumDB.TabIndex = 1
      Me.tabMillenniumDB.Text = "Lottery Retail DB"
      Me.tabMillenniumDB.UseVisualStyleBackColor = True
      '
      'gbMillenniumConnInfo
      '
      Me.gbMillenniumConnInfo.CausesValidation = False
      Me.gbMillenniumConnInfo.Controls.Add(Me.btnTestMillenniumConnection)
      Me.gbMillenniumConnInfo.Controls.Add(Me.txtMillenniumDBPassword)
      Me.gbMillenniumConnInfo.Controls.Add(Me.lblPassword)
      Me.gbMillenniumConnInfo.Controls.Add(Me.txtMillenniumDBUserID)
      Me.gbMillenniumConnInfo.Controls.Add(Me.lblUserID)
      Me.gbMillenniumConnInfo.Controls.Add(Me.txtMillenniumDBCatalog)
      Me.gbMillenniumConnInfo.Controls.Add(Me.lblLRDatabase)
      Me.gbMillenniumConnInfo.Controls.Add(Me.txtMillenniumDBServer)
      Me.gbMillenniumConnInfo.Controls.Add(Me.lblServer)
      Me.gbMillenniumConnInfo.Location = New System.Drawing.Point(24, 16)
      Me.gbMillenniumConnInfo.Name = "gbMillenniumConnInfo"
      Me.gbMillenniumConnInfo.Size = New System.Drawing.Size(344, 160)
      Me.gbMillenniumConnInfo.TabIndex = 1
      Me.gbMillenniumConnInfo.TabStop = False
      Me.gbMillenniumConnInfo.Text = "LotteryRetail Connection String"
      '
      'btnTestMillenniumConnection
      '
      Me.btnTestMillenniumConnection.CausesValidation = False
      Me.btnTestMillenniumConnection.Location = New System.Drawing.Point(124, 128)
      Me.btnTestMillenniumConnection.Name = "btnTestMillenniumConnection"
      Me.btnTestMillenniumConnection.Size = New System.Drawing.Size(109, 23)
      Me.btnTestMillenniumConnection.TabIndex = 8
      Me.btnTestMillenniumConnection.Text = "Test Connection"
      '
      'txtMillenniumDBPassword
      '
      Me.txtMillenniumDBPassword.CausesValidation = False
      Me.txtMillenniumDBPassword.Location = New System.Drawing.Point(88, 96)
      Me.txtMillenniumDBPassword.Name = "txtMillenniumDBPassword"
      Me.txtMillenniumDBPassword.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
      Me.txtMillenniumDBPassword.Size = New System.Drawing.Size(200, 20)
      Me.txtMillenniumDBPassword.TabIndex = 7
      '
      'lblPassword
      '
      Me.lblPassword.CausesValidation = False
      Me.lblPassword.Location = New System.Drawing.Point(14, 98)
      Me.lblPassword.Name = "lblPassword"
      Me.lblPassword.Size = New System.Drawing.Size(72, 16)
      Me.lblPassword.TabIndex = 6
      Me.lblPassword.Text = "Password:"
      Me.lblPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtMillenniumDBUserID
      '
      Me.txtMillenniumDBUserID.CausesValidation = False
      Me.txtMillenniumDBUserID.Location = New System.Drawing.Point(88, 72)
      Me.txtMillenniumDBUserID.Name = "txtMillenniumDBUserID"
      Me.txtMillenniumDBUserID.Size = New System.Drawing.Size(200, 20)
      Me.txtMillenniumDBUserID.TabIndex = 5
      '
      'lblUserID
      '
      Me.lblUserID.CausesValidation = False
      Me.lblUserID.Location = New System.Drawing.Point(14, 74)
      Me.lblUserID.Name = "lblUserID"
      Me.lblUserID.Size = New System.Drawing.Size(72, 16)
      Me.lblUserID.TabIndex = 4
      Me.lblUserID.Text = "User ID:"
      Me.lblUserID.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtMillenniumDBCatalog
      '
      Me.txtMillenniumDBCatalog.CausesValidation = False
      Me.txtMillenniumDBCatalog.Location = New System.Drawing.Point(88, 48)
      Me.txtMillenniumDBCatalog.Name = "txtMillenniumDBCatalog"
      Me.txtMillenniumDBCatalog.Size = New System.Drawing.Size(200, 20)
      Me.txtMillenniumDBCatalog.TabIndex = 3
      '
      'lblLRDatabase
      '
      Me.lblLRDatabase.CausesValidation = False
      Me.lblLRDatabase.Location = New System.Drawing.Point(14, 50)
      Me.lblLRDatabase.Name = "lblLRDatabase"
      Me.lblLRDatabase.Size = New System.Drawing.Size(72, 16)
      Me.lblLRDatabase.TabIndex = 2
      Me.lblLRDatabase.Text = "Database:"
      Me.lblLRDatabase.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtMillenniumDBServer
      '
      Me.txtMillenniumDBServer.CausesValidation = False
      Me.txtMillenniumDBServer.Location = New System.Drawing.Point(88, 24)
      Me.txtMillenniumDBServer.Name = "txtMillenniumDBServer"
      Me.txtMillenniumDBServer.Size = New System.Drawing.Size(200, 20)
      Me.txtMillenniumDBServer.TabIndex = 1
      '
      'lblServer
      '
      Me.lblServer.CausesValidation = False
      Me.lblServer.Location = New System.Drawing.Point(14, 26)
      Me.lblServer.Name = "lblServer"
      Me.lblServer.Size = New System.Drawing.Size(72, 16)
      Me.lblServer.TabIndex = 0
      Me.lblServer.Text = "Server:"
      Me.lblServer.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'tabEDealDB
      '
      Me.tabEDealDB.CausesValidation = False
      Me.tabEDealDB.Controls.Add(Me.gbEdealConnInfo)
      Me.tabEDealDB.Location = New System.Drawing.Point(4, 22)
      Me.tabEDealDB.Name = "tabEDealDB"
      Me.tabEDealDB.Size = New System.Drawing.Size(407, 233)
      Me.tabEDealDB.TabIndex = 0
      Me.tabEDealDB.Text = "eDeal DB"
      Me.tabEDealDB.UseVisualStyleBackColor = True
      '
      'gbEdealConnInfo
      '
      Me.gbEdealConnInfo.CausesValidation = False
      Me.gbEdealConnInfo.Controls.Add(Me.btnTestEDealConnection)
      Me.gbEdealConnInfo.Controls.Add(Me.txtEdealDBCatalog)
      Me.gbEdealConnInfo.Controls.Add(Me.lblEdealDBCatalog)
      Me.gbEdealConnInfo.Location = New System.Drawing.Point(24, 16)
      Me.gbEdealConnInfo.Name = "gbEdealConnInfo"
      Me.gbEdealConnInfo.Size = New System.Drawing.Size(344, 160)
      Me.gbEdealConnInfo.TabIndex = 0
      Me.gbEdealConnInfo.TabStop = False
      Me.gbEdealConnInfo.Text = "eDeal Connection String"
      '
      'btnTestEDealConnection
      '
      Me.btnTestEDealConnection.CausesValidation = False
      Me.btnTestEDealConnection.Location = New System.Drawing.Point(124, 116)
      Me.btnTestEDealConnection.Name = "btnTestEDealConnection"
      Me.btnTestEDealConnection.Size = New System.Drawing.Size(109, 23)
      Me.btnTestEDealConnection.TabIndex = 8
      Me.btnTestEDealConnection.Text = "Test Connection"
      '
      'txtEdealDBCatalog
      '
      Me.txtEdealDBCatalog.CausesValidation = False
      Me.txtEdealDBCatalog.Location = New System.Drawing.Point(88, 59)
      Me.txtEdealDBCatalog.Name = "txtEdealDBCatalog"
      Me.txtEdealDBCatalog.Size = New System.Drawing.Size(200, 20)
      Me.txtEdealDBCatalog.TabIndex = 3
      '
      'lblEdealDBCatalog
      '
      Me.lblEdealDBCatalog.CausesValidation = False
      Me.lblEdealDBCatalog.Location = New System.Drawing.Point(14, 61)
      Me.lblEdealDBCatalog.Name = "lblEdealDBCatalog"
      Me.lblEdealDBCatalog.Size = New System.Drawing.Size(72, 16)
      Me.lblEdealDBCatalog.TabIndex = 2
      Me.lblEdealDBCatalog.Text = "Database:"
      Me.lblEdealDBCatalog.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'tabSourceLocation
      '
      Me.tabSourceLocation.CausesValidation = False
      Me.tabSourceLocation.Controls.Add(Me.gbSourceLocation)
      Me.tabSourceLocation.Location = New System.Drawing.Point(4, 22)
      Me.tabSourceLocation.Name = "tabSourceLocation"
      Me.tabSourceLocation.Size = New System.Drawing.Size(407, 233)
      Me.tabSourceLocation.TabIndex = 2
      Me.tabSourceLocation.Text = "Source Location"
      Me.tabSourceLocation.UseVisualStyleBackColor = True
      '
      'gbSourceLocation
      '
      Me.gbSourceLocation.CausesValidation = False
      Me.gbSourceLocation.Controls.Add(Me.cbFreeSpaceCheck)
      Me.gbSourceLocation.Controls.Add(Me.txtArchiveFolder)
      Me.gbSourceLocation.Controls.Add(Me.lblArchiveFolder)
      Me.gbSourceLocation.Controls.Add(Me.txtSourceFile)
      Me.gbSourceLocation.Controls.Add(Me.txtSourceFolder)
      Me.gbSourceLocation.Controls.Add(Me.lblSourceFileName)
      Me.gbSourceLocation.Controls.Add(Me.lblSourceFolder)
      Me.gbSourceLocation.Location = New System.Drawing.Point(24, 16)
      Me.gbSourceLocation.Name = "gbSourceLocation"
      Me.gbSourceLocation.Size = New System.Drawing.Size(376, 166)
      Me.gbSourceLocation.TabIndex = 0
      Me.gbSourceLocation.TabStop = False
      Me.gbSourceLocation.Text = "Source Information"
      '
      'cbFreeSpaceCheck
      '
      Me.cbFreeSpaceCheck.CausesValidation = False
      Me.cbFreeSpaceCheck.Location = New System.Drawing.Point(126, 116)
      Me.cbFreeSpaceCheck.Name = "cbFreeSpaceCheck"
      Me.cbFreeSpaceCheck.Size = New System.Drawing.Size(176, 16)
      Me.cbFreeSpaceCheck.TabIndex = 9
      Me.cbFreeSpaceCheck.Text = "Perform Freespace Check"
      '
      'txtArchiveFolder
      '
      Me.txtArchiveFolder.CausesValidation = False
      Me.txtArchiveFolder.Location = New System.Drawing.Point(126, 132)
      Me.txtArchiveFolder.MaxLength = 128
      Me.txtArchiveFolder.Name = "txtArchiveFolder"
      Me.txtArchiveFolder.Size = New System.Drawing.Size(231, 20)
      Me.txtArchiveFolder.TabIndex = 8
      Me.txtArchiveFolder.Visible = False
      '
      'lblArchiveFolder
      '
      Me.lblArchiveFolder.CausesValidation = False
      Me.lblArchiveFolder.Location = New System.Drawing.Point(11, 134)
      Me.lblArchiveFolder.Name = "lblArchiveFolder"
      Me.lblArchiveFolder.Size = New System.Drawing.Size(112, 16)
      Me.lblArchiveFolder.TabIndex = 7
      Me.lblArchiveFolder.Text = "Archive Folder:"
      Me.lblArchiveFolder.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      Me.lblArchiveFolder.Visible = False
      '
      'txtSourceFile
      '
      Me.txtSourceFile.CausesValidation = False
      Me.txtSourceFile.Location = New System.Drawing.Point(126, 78)
      Me.txtSourceFile.MaxLength = 128
      Me.txtSourceFile.Name = "txtSourceFile"
      Me.txtSourceFile.Size = New System.Drawing.Size(231, 20)
      Me.txtSourceFile.TabIndex = 4
      '
      'txtSourceFolder
      '
      Me.txtSourceFolder.CausesValidation = False
      Me.txtSourceFolder.Location = New System.Drawing.Point(126, 44)
      Me.txtSourceFolder.MaxLength = 128
      Me.txtSourceFolder.Name = "txtSourceFolder"
      Me.txtSourceFolder.Size = New System.Drawing.Size(231, 20)
      Me.txtSourceFolder.TabIndex = 2
      '
      'lblSourceFileName
      '
      Me.lblSourceFileName.CausesValidation = False
      Me.lblSourceFileName.Location = New System.Drawing.Point(11, 80)
      Me.lblSourceFileName.Name = "lblSourceFileName"
      Me.lblSourceFileName.Size = New System.Drawing.Size(112, 16)
      Me.lblSourceFileName.TabIndex = 3
      Me.lblSourceFileName.Text = "Deal Source File:"
      Me.lblSourceFileName.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblSourceFolder
      '
      Me.lblSourceFolder.CausesValidation = False
      Me.lblSourceFolder.Location = New System.Drawing.Point(11, 46)
      Me.lblSourceFolder.Name = "lblSourceFolder"
      Me.lblSourceFolder.Size = New System.Drawing.Size(112, 16)
      Me.lblSourceFolder.TabIndex = 1
      Me.lblSourceFolder.Text = "Deal Source Folder:"
      Me.lblSourceFolder.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'btnCancel
      '
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Location = New System.Drawing.Point(179, 288)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(75, 23)
      Me.btnCancel.TabIndex = 210
      Me.btnCancel.Text = "&Cancel"
      '
      'btnOK
      '
      Me.btnOK.CausesValidation = False
      Me.btnOK.Location = New System.Drawing.Point(99, 288)
      Me.btnOK.Name = "btnOK"
      Me.btnOK.Size = New System.Drawing.Size(75, 23)
      Me.btnOK.TabIndex = 200
      Me.btnOK.Text = "&OK"
      '
      'btnApply
      '
      Me.btnApply.CausesValidation = False
      Me.btnApply.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnApply.Location = New System.Drawing.Point(259, 288)
      Me.btnApply.Name = "btnApply"
      Me.btnApply.Size = New System.Drawing.Size(75, 23)
      Me.btnApply.TabIndex = 220
      Me.btnApply.Text = "&Apply"
      '
      'frmOptions
      '
      Me.AcceptButton = Me.btnOK
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CancelButton = Me.btnCancel
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(435, 321)
      Me.Controls.Add(Me.btnApply)
      Me.Controls.Add(Me.btnOK)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.OptionsTabControl)
      Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MaximizeBox = False
      Me.MinimizeBox = False
      Me.Name = "frmOptions"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Application Settings"
      Me.OptionsTabControl.ResumeLayout(False)
      Me.tabMillenniumDB.ResumeLayout(False)
      Me.gbMillenniumConnInfo.ResumeLayout(False)
      Me.gbMillenniumConnInfo.PerformLayout()
      Me.tabEDealDB.ResumeLayout(False)
      Me.gbEdealConnInfo.ResumeLayout(False)
      Me.gbEdealConnInfo.PerformLayout()
      Me.tabSourceLocation.ResumeLayout(False)
      Me.gbSourceLocation.ResumeLayout(False)
      Me.gbSourceLocation.PerformLayout()
      Me.ResumeLayout(False)

   End Sub

#End Region

   ' Declare Private variables with Class scope.
   Private mFreeSpaceCheck As Boolean

   Private mDataSourceFile As String
   Private mDataSourceFolder As String

   Private mDatabaseServer As String
   Private mDatabaseUserID As String
   Private mDatabasePassword As String

   Private mEdealDBCatalog As String
   Private mMillenniumDBCatalog As String

   Private Sub Form_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this Form.
      '--------------------------------------------------------------------------------

      ' Save window state info for next time this form is opened.
      ConfigFile.SetWindowState(Me)

   End Sub

   Private Sub Form_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAPE As New AppPasswordEncryption
      Dim lValueText As String

      Try
         ' Populate the Approved Master Deals Disk Drives ComboBox control.
         ' Call LoadAMDDrives()

         With My.Settings
            mFreeSpaceCheck = .FreeSpaceCheck

            ' LotteryRetail connection info...
            mDatabaseServer = .DatabaseServer
            mMillenniumDBCatalog = .LotteryRetailDBCatalog
            mDatabaseUserID = .DatabaseUserID
            lValueText = .DatabasePassword
            If lValueText.Length > 0 Then
               mDatabasePassword = lAPE.DecryptPassword(lValueText)
            Else
               mDatabasePassword = ""
            End If

            ' eDeal connection info...
            mEdealDBCatalog = .EdealDBCatalog
            mDatabaseUserID = .DatabaseUserID
            lValueText = .DatabasePassword
            If lValueText.Length > 0 Then
               mDatabasePassword = lAPE.DecryptPassword(lValueText)
            Else
               mDatabasePassword = ""
            End If

            ' File and Folder settings...
            mDataSourceFile = .DataSourceFile
            mDataSourceFolder = .DataFolder

         End With

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show(ex.Message, "Form Load Error", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      Try
         ' Set Freespace Check CheckBox control.
         cbFreeSpaceCheck.Checked = mFreeSpaceCheck

         ' Populate text boxes
         txtMillenniumDBServer.Text = mDatabaseServer
         txtMillenniumDBCatalog.Text = mMillenniumDBCatalog
         txtMillenniumDBUserID.Text = mDatabaseUserID
         txtMillenniumDBPassword.Text = mDatabasePassword
         txtEdealDBCatalog.Text = mEdealDBCatalog
         txtSourceFile.Text = mDataSourceFile
         txtSourceFolder.Text = mDataSourceFolder

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show(ex.Message, "Form Load Error", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel Button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAPE As New AppPasswordEncryption
      Dim lSaveSettings As Boolean = False
      Dim lRebuildConnections As Boolean = False

      Try
         ' Has Data Source information changed?
         If txtSourceFile.Text <> mDataSourceFile Then
            My.Settings.DataSourceFile = mDataSourceFile
            lSaveSettings = True
         End If

         If txtSourceFolder.Text <> mDataSourceFolder Then
            My.Settings.DataSourceFile = mDataSourceFolder
            lSaveSettings = True
         End If

         If cbFreeSpaceCheck.Checked <> mFreeSpaceCheck Then
            My.Settings.FreeSpaceCheck = mFreeSpaceCheck
            lSaveSettings = True
         End If

         ' Has eDeal db information changed?
         If txtEdealDBCatalog.Text <> mEdealDBCatalog Then
            My.Settings.EdealDBCatalog = mEdealDBCatalog
            lSaveSettings = True
            lRebuildConnections = True
         End If

         ' Has LotteryRetail db information changed?
         If txtMillenniumDBServer.Text <> mDatabaseServer Then
            My.Settings.DatabaseServer = mDatabaseServer
            lSaveSettings = True
            lRebuildConnections = True
         End If

         If txtMillenniumDBCatalog.Text <> mMillenniumDBCatalog Then
            My.Settings.LotteryRetailDBCatalog = mMillenniumDBCatalog
            lSaveSettings = True
            lRebuildConnections = True
         End If

         If txtMillenniumDBUserID.Text <> mDatabaseUserID Then
            My.Settings.DatabaseUserID = mDatabaseUserID
            lSaveSettings = True
            lRebuildConnections = True
         End If

         If txtMillenniumDBPassword.Text <> mDatabasePassword Then
            My.Settings.DatabasePassword = lAPE.EncryptPassword(mDatabasePassword)
            lSaveSettings = True
            lRebuildConnections = True
         End If

         ' Save settings if necessary.
         If lSaveSettings Then My.Settings.Save()

         ' Rebuild connection strings if necessary.
         If lRebuildConnections Then Call BuildConnections()

         ' Close this form.
         Me.Close()

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show(Me.Name & " btnCancel_Click Error: " & ex.Message, "Cancel Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the OK button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrText As String = ""

      If SaveSetupChanges(lErrText) Then
         Me.Close()
      Else
         MessageBox.Show(lErrText, "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub btnApply_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApply.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Apply button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""

      If Not SaveSetupChanges(lErrorText) Then
         MessageBox.Show(lErrorText, "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub btnTestConnection_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
      Handles btnTestMillenniumConnection.Click, btnTestEDealConnection.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Test database connection buttons.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As New SqlDataAccess
      Dim lDS As New DataSet

      Dim lConnect As String = ""
      Dim lMBStatusText As String = ""

      Dim lDataModified As Boolean

      If sender Is btnTestMillenniumConnection Then
         lDataModified = DataChangedMillennium()
         lConnect = gConnectRetail
         lMBStatusText = "LotteryRetail Database Connection Status"
      ElseIf sender Is btnTestEDealConnection Then
         lDataModified = DataChangedEDeal()
         lConnect = gConnectEDeal
         lMBStatusText = "eDeal Database Connection Status"
      End If

      If lDataModified Then
         ' Have user apply changes to force rebuild of connection string.
         MessageBox.Show("You must apply your changes before testing the connection.", _
                         lMBStatusText, MessageBoxButtons.OK, MessageBoxIcon.Stop)
      Else
         ' Database setup has not changed, attempt to connect and retrieve version information...
         Me.Cursor = Cursors.WaitCursor
         Try
            With lSDA
               .ConnectionString = lConnect
               lDS = .ExecuteSQL("Select @@Version")
            End With

            ' Show success.
            MessageBox.Show("Connection Successful.", lMBStatusText, MessageBoxButtons.OK, MessageBoxIcon.Information)

         Catch ex As Exception
            ' An error occurred, show connection failure.
            MessageBox.Show("Connection Failed.", lMBStatusText, MessageBoxButtons.OK, MessageBoxIcon.Error)

         End Try

         Me.Cursor = Cursors.Default

         ' Free the database object...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
      End If

   End Sub

   Private Function IsValidSourceFile(ByVal aFileName As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Tests the incoming file name and returns true or false to indicate validity.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean

      ' Assume name is okay.
      lReturn = True

      ' Test file name content...
      If aFileName Is Nothing Then
         lReturn = False
      ElseIf aFileName.Length <> 21 Then
         lReturn = False
      ElseIf Not aFileName.EndsWith("_ExportData.xml") Then
         lReturn = False
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function IsValidSourceFolder(ByVal aFolderName As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Tests the incoming folder name and returns true or false to indicate validity.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean
      Dim lStartChar As String

      ' Assume name is okay.
      lReturn = True

      ' Test folder name content...
      If aFolderName Is Nothing Then
         lReturn = False
      ElseIf aFolderName.Length <> 8 Then
         lReturn = False
      ElseIf Not aFolderName.EndsWith(":\Data\") Then
         lReturn = False
      Else
         lStartChar = aFolderName.Substring(0, 1)
         If "ABCDEFGHIJKLMNOPQRSTUVWXYZ".IndexOf(lStartChar) < 1 Then
            lReturn = False
         End If
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function SaveSetupChanges(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Routine to save changes.
      ' Returns T/F to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAPE As New AppPasswordEncryption

      ' Initialize error text to an empty string.
      aErrorText = ""

      Try
         ' Have any file or folder values changed?
         If txtSourceFile.Modified = True Or _
            txtSourceFolder.Modified = True Or _
            cbFreeSpaceCheck.Checked <> mFreeSpaceCheck Then
            ' Yes, so check for a valid folder name.
            If Not IsValidSourceFolder(txtSourceFolder.Text) Then
               aErrorText = "The Source Folder must begin with a valid Drive Letter followed by :\Data\ (ie E:\Data\)."
            ElseIf Not IsValidSourceFile(txtSourceFile.Text) Then
               aErrorText = "The Source File must begin with the Location Identifier (ie OLG001) followed by _ExportData.xml (ie OLG001_ExportData.xml)."
            Else
               ' Yes, so save the new values...
               With My.Settings
                  .DataSourceFile = txtSourceFile.Text
                  .DataFolder = txtSourceFolder.Text
                  ' .ArchiveFolder = txtArchiveFolder.Text
                  .FreeSpaceCheck = cbFreeSpaceCheck.Checked
                  .Save()
               End With

               ' Reset modified status of TextBox controls.
               txtSourceFile.Modified = False
               txtSourceFolder.Modified = False
            End If
         End If

         ' Has LotteryRetail db information changed?
         If DataChangedMillennium() Then
            ' Yes, so save the new values...
            With My.Settings
               .DatabaseServer = txtMillenniumDBServer.Text
               .LotteryRetailDBCatalog = txtMillenniumDBCatalog.Text
               .DatabaseUserID = txtMillenniumDBUserID.Text
               .DatabasePassword = lAPE.EncryptPassword(txtMillenniumDBPassword.Text)
               .Save()
            End With

            ' Rebuild connection strings.
            Call BuildConnections()

            ' Reset modified status of TextBox controls.
            txtMillenniumDBServer.Modified = False
            txtMillenniumDBCatalog.Modified = False
            txtMillenniumDBUserID.Modified = False
            txtMillenniumDBPassword.Modified = False
         End If

         ' Has eDeal db information changed?
         If DataChangedEDeal() Then
            ' Yes, so save the new values...
            With My.Settings
               .EdealDBCatalog = txtEdealDBCatalog.Text
               .Save()
            End With

            ' Reset modified status of TextBox controls.
            txtEdealDBCatalog.Modified = False

            ' Rebuild connection strings.
            Call BuildConnections()
         End If

      Catch ex As Exception
         ' Handle the error, store error message.
         aErrorText = "SaveSetupChanges Error: " & ex.Message

      End Try

      ' Set the function return value.
      Return (aErrorText.Length = 0)

   End Function

   Private Function DataChangedEDeal() As Boolean
      '--------------------------------------------------------------------------------
      ' Returns True or False to indicate if any of the data in the
      ' eDeal TextBox controls has been modified.
      '--------------------------------------------------------------------------------

      Return txtEdealDBCatalog.Modified 

   End Function

   Private Function DataChangedMillennium() As Boolean
      '--------------------------------------------------------------------------------
      ' Returns True or False to indicate if any of the data in the
      ' eTab TextBox controls has been modified.
      '--------------------------------------------------------------------------------

      Return txtMillenniumDBServer.Modified OrElse _
             txtMillenniumDBCatalog.Modified OrElse _
             txtMillenniumDBUserID.Modified OrElse _
             txtMillenniumDBPassword.Modified

   End Function

End Class
