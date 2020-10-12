Imports System.Threading

Public Class frmArchive
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
   Friend WithEvents prgProgress As System.Windows.Forms.ProgressBar
   Friend WithEvents lblStatus As System.Windows.Forms.Label
   Friend WithEvents btnStart As System.Windows.Forms.Button
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents CDWriter As AxCDWriterXPLib.AxCDWriterXP
   Friend WithEvents grpUI As System.Windows.Forms.GroupBox
   Friend WithEvents cbWriteCD As System.Windows.Forms.CheckBox
   Friend WithEvents cbPurgeData As System.Windows.Forms.CheckBox
   Friend WithEvents cbCompressDB As System.Windows.Forms.CheckBox
   Friend WithEvents cbDbBackup As System.Windows.Forms.CheckBox
   Friend WithEvents cbRetrieveAI As System.Windows.Forms.CheckBox
   Friend WithEvents lblWriteCD As System.Windows.Forms.Label
   Friend WithEvents lblRetrieveAI As System.Windows.Forms.Label
   Friend WithEvents lblPurgeData As System.Windows.Forms.Label
   Friend WithEvents lblCompressDB As System.Windows.Forms.Label
   Friend WithEvents lblDbBackup As System.Windows.Forms.Label
   Friend WithEvents lblStepsDesc As System.Windows.Forms.Label
   Friend WithEvents pbPointer As System.Windows.Forms.PictureBox
   Friend WithEvents lblShrinkDatabase As System.Windows.Forms.Label
   Friend WithEvents cbFinalBackup As System.Windows.Forms.CheckBox


   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmArchive))
      Me.lblStatus = New System.Windows.Forms.Label
      Me.prgProgress = New System.Windows.Forms.ProgressBar
      Me.btnStart = New System.Windows.Forms.Button
      Me.btnCancel = New System.Windows.Forms.Button
      Me.CDWriter = New AxCDWriterXPLib.AxCDWriterXP
      Me.grpUI = New System.Windows.Forms.GroupBox
      Me.cbFinalBackup = New System.Windows.Forms.CheckBox
      Me.lblShrinkDatabase = New System.Windows.Forms.Label
      Me.pbPointer = New System.Windows.Forms.PictureBox
      Me.cbWriteCD = New System.Windows.Forms.CheckBox
      Me.cbPurgeData = New System.Windows.Forms.CheckBox
      Me.cbCompressDB = New System.Windows.Forms.CheckBox
      Me.cbDbBackup = New System.Windows.Forms.CheckBox
      Me.cbRetrieveAI = New System.Windows.Forms.CheckBox
      Me.lblWriteCD = New System.Windows.Forms.Label
      Me.lblRetrieveAI = New System.Windows.Forms.Label
      Me.lblPurgeData = New System.Windows.Forms.Label
      Me.lblCompressDB = New System.Windows.Forms.Label
      Me.lblDbBackup = New System.Windows.Forms.Label
      Me.lblStepsDesc = New System.Windows.Forms.Label
      CType(Me.CDWriter, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.grpUI.SuspendLayout()
      CType(Me.pbPointer, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'lblStatus
      '
      Me.lblStatus.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblStatus.CausesValidation = False
      Me.lblStatus.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblStatus.Location = New System.Drawing.Point(5, 232)
      Me.lblStatus.Name = "lblStatus"
      Me.lblStatus.Size = New System.Drawing.Size(592, 28)
      Me.lblStatus.TabIndex = 0
      Me.lblStatus.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      Me.lblStatus.UseMnemonic = False
      '
      'prgProgress
      '
      Me.prgProgress.Dock = System.Windows.Forms.DockStyle.Bottom
      Me.prgProgress.Location = New System.Drawing.Point(0, 272)
      Me.prgProgress.Name = "prgProgress"
      Me.prgProgress.Size = New System.Drawing.Size(602, 18)
      Me.prgProgress.TabIndex = 1
      Me.prgProgress.Visible = False
      '
      'btnStart
      '
      Me.btnStart.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnStart.CausesValidation = False
      Me.btnStart.Location = New System.Drawing.Point(238, 239)
      Me.btnStart.Name = "btnStart"
      Me.btnStart.Size = New System.Drawing.Size(49, 23)
      Me.btnStart.TabIndex = 2
      Me.btnStart.Text = "Start"
      '
      'btnCancel
      '
      Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.Location = New System.Drawing.Point(322, 239)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(49, 23)
      Me.btnCancel.TabIndex = 3
      Me.btnCancel.Text = "Cancel"
      '
      'CDWriter
      '
      Me.CDWriter.CausesValidation = False
      Me.CDWriter.Enabled = True
      Me.CDWriter.Location = New System.Drawing.Point(24, 232)
      Me.CDWriter.Name = "CDWriter"
      Me.CDWriter.OcxState = CType(resources.GetObject("CDWriter.OcxState"), System.Windows.Forms.AxHost.State)
      Me.CDWriter.Size = New System.Drawing.Size(32, 32)
      Me.CDWriter.TabIndex = 4
      Me.CDWriter.TabStop = False
      '
      'grpUI
      '
      Me.grpUI.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.grpUI.Controls.Add(Me.cbFinalBackup)
      Me.grpUI.Controls.Add(Me.lblShrinkDatabase)
      Me.grpUI.Controls.Add(Me.pbPointer)
      Me.grpUI.Controls.Add(Me.cbWriteCD)
      Me.grpUI.Controls.Add(Me.cbPurgeData)
      Me.grpUI.Controls.Add(Me.cbCompressDB)
      Me.grpUI.Controls.Add(Me.cbDbBackup)
      Me.grpUI.Controls.Add(Me.cbRetrieveAI)
      Me.grpUI.Controls.Add(Me.lblWriteCD)
      Me.grpUI.Controls.Add(Me.lblRetrieveAI)
      Me.grpUI.Controls.Add(Me.lblPurgeData)
      Me.grpUI.Controls.Add(Me.lblCompressDB)
      Me.grpUI.Controls.Add(Me.lblDbBackup)
      Me.grpUI.Controls.Add(Me.lblStepsDesc)
      Me.grpUI.Location = New System.Drawing.Point(9, 16)
      Me.grpUI.Name = "grpUI"
      Me.grpUI.Size = New System.Drawing.Size(583, 200)
      Me.grpUI.TabIndex = 17
      Me.grpUI.TabStop = False
      '
      'cbFinalBackup
      '
      Me.cbFinalBackup.AutoCheck = False
      Me.cbFinalBackup.CausesValidation = False
      Me.cbFinalBackup.Checked = True
      Me.cbFinalBackup.CheckState = System.Windows.Forms.CheckState.Checked
      Me.cbFinalBackup.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.cbFinalBackup.ForeColor = System.Drawing.Color.Green
      Me.cbFinalBackup.Location = New System.Drawing.Point(328, 170)
      Me.cbFinalBackup.Name = "cbFinalBackup"
      Me.cbFinalBackup.Size = New System.Drawing.Size(136, 16)
      Me.cbFinalBackup.TabIndex = 30
      Me.cbFinalBackup.Text = "Completed"
      Me.cbFinalBackup.Visible = False
      '
      'lblShrinkDatabase
      '
      Me.lblShrinkDatabase.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblShrinkDatabase.Location = New System.Drawing.Point(96, 170)
      Me.lblShrinkDatabase.Name = "lblShrinkDatabase"
      Me.lblShrinkDatabase.Size = New System.Drawing.Size(216, 16)
      Me.lblShrinkDatabase.TabIndex = 29
      Me.lblShrinkDatabase.Text = "- Final Database Backup"
      '
      'pbPointer
      '
      Me.pbPointer.Image = CType(resources.GetObject("pbPointer.Image"), System.Drawing.Image)
      Me.pbPointer.Location = New System.Drawing.Point(68, 59)
      Me.pbPointer.Name = "pbPointer"
      Me.pbPointer.Size = New System.Drawing.Size(16, 16)
      Me.pbPointer.TabIndex = 28
      Me.pbPointer.TabStop = False
      Me.pbPointer.Visible = False
      '
      'cbWriteCD
      '
      Me.cbWriteCD.AutoCheck = False
      Me.cbWriteCD.CausesValidation = False
      Me.cbWriteCD.Checked = True
      Me.cbWriteCD.CheckState = System.Windows.Forms.CheckState.Checked
      Me.cbWriteCD.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.cbWriteCD.ForeColor = System.Drawing.Color.Green
      Me.cbWriteCD.Location = New System.Drawing.Point(328, 148)
      Me.cbWriteCD.Name = "cbWriteCD"
      Me.cbWriteCD.Size = New System.Drawing.Size(136, 16)
      Me.cbWriteCD.TabIndex = 27
      Me.cbWriteCD.Text = "Completed"
      Me.cbWriteCD.Visible = False
      '
      'cbPurgeData
      '
      Me.cbPurgeData.AutoCheck = False
      Me.cbPurgeData.CausesValidation = False
      Me.cbPurgeData.Checked = True
      Me.cbPurgeData.CheckState = System.Windows.Forms.CheckState.Checked
      Me.cbPurgeData.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.cbPurgeData.ForeColor = System.Drawing.Color.Green
      Me.cbPurgeData.Location = New System.Drawing.Point(328, 126)
      Me.cbPurgeData.Name = "cbPurgeData"
      Me.cbPurgeData.Size = New System.Drawing.Size(136, 16)
      Me.cbPurgeData.TabIndex = 26
      Me.cbPurgeData.Text = "Completed"
      Me.cbPurgeData.Visible = False
      '
      'cbCompressDB
      '
      Me.cbCompressDB.AutoCheck = False
      Me.cbCompressDB.CausesValidation = False
      Me.cbCompressDB.Checked = True
      Me.cbCompressDB.CheckState = System.Windows.Forms.CheckState.Checked
      Me.cbCompressDB.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.cbCompressDB.ForeColor = System.Drawing.Color.Green
      Me.cbCompressDB.Location = New System.Drawing.Point(328, 104)
      Me.cbCompressDB.Name = "cbCompressDB"
      Me.cbCompressDB.Size = New System.Drawing.Size(136, 16)
      Me.cbCompressDB.TabIndex = 25
      Me.cbCompressDB.Text = "Completed"
      Me.cbCompressDB.Visible = False
      '
      'cbDbBackup
      '
      Me.cbDbBackup.AutoCheck = False
      Me.cbDbBackup.CausesValidation = False
      Me.cbDbBackup.Checked = True
      Me.cbDbBackup.CheckState = System.Windows.Forms.CheckState.Checked
      Me.cbDbBackup.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.cbDbBackup.ForeColor = System.Drawing.Color.Green
      Me.cbDbBackup.Location = New System.Drawing.Point(328, 82)
      Me.cbDbBackup.Name = "cbDbBackup"
      Me.cbDbBackup.Size = New System.Drawing.Size(136, 16)
      Me.cbDbBackup.TabIndex = 24
      Me.cbDbBackup.Text = "Completed"
      Me.cbDbBackup.Visible = False
      '
      'cbRetrieveAI
      '
      Me.cbRetrieveAI.AutoCheck = False
      Me.cbRetrieveAI.CausesValidation = False
      Me.cbRetrieveAI.Checked = True
      Me.cbRetrieveAI.CheckState = System.Windows.Forms.CheckState.Checked
      Me.cbRetrieveAI.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.cbRetrieveAI.ForeColor = System.Drawing.Color.Green
      Me.cbRetrieveAI.Location = New System.Drawing.Point(328, 60)
      Me.cbRetrieveAI.Name = "cbRetrieveAI"
      Me.cbRetrieveAI.Size = New System.Drawing.Size(136, 16)
      Me.cbRetrieveAI.TabIndex = 23
      Me.cbRetrieveAI.Text = "Completed"
      Me.cbRetrieveAI.Visible = False
      '
      'lblWriteCD
      '
      Me.lblWriteCD.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblWriteCD.Location = New System.Drawing.Point(96, 148)
      Me.lblWriteCD.Name = "lblWriteCD"
      Me.lblWriteCD.Size = New System.Drawing.Size(216, 16)
      Me.lblWriteCD.TabIndex = 22
      Me.lblWriteCD.Text = "- Save archived data to a CD"
      '
      'lblRetrieveAI
      '
      Me.lblRetrieveAI.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblRetrieveAI.Location = New System.Drawing.Point(96, 60)
      Me.lblRetrieveAI.Name = "lblRetrieveAI"
      Me.lblRetrieveAI.Size = New System.Drawing.Size(216, 16)
      Me.lblRetrieveAI.TabIndex = 21
      Me.lblRetrieveAI.Text = "- Retrieve Archival Information"
      '
      'lblPurgeData
      '
      Me.lblPurgeData.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblPurgeData.Location = New System.Drawing.Point(96, 126)
      Me.lblPurgeData.Name = "lblPurgeData"
      Me.lblPurgeData.Size = New System.Drawing.Size(216, 16)
      Me.lblPurgeData.TabIndex = 20
      Me.lblPurgeData.Text = "- Purge old data"
      '
      'lblCompressDB
      '
      Me.lblCompressDB.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblCompressDB.Location = New System.Drawing.Point(96, 104)
      Me.lblCompressDB.Name = "lblCompressDB"
      Me.lblCompressDB.Size = New System.Drawing.Size(216, 16)
      Me.lblCompressDB.TabIndex = 19
      Me.lblCompressDB.Text = "- Compress the Database Backup"
      '
      'lblDbBackup
      '
      Me.lblDbBackup.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblDbBackup.Location = New System.Drawing.Point(96, 82)
      Me.lblDbBackup.Name = "lblDbBackup"
      Me.lblDbBackup.Size = New System.Drawing.Size(216, 16)
      Me.lblDbBackup.TabIndex = 18
      Me.lblDbBackup.Text = "- Backup the Database"
      '
      'lblStepsDesc
      '
      Me.lblStepsDesc.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblStepsDesc.Font = New System.Drawing.Font("Tahoma", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblStepsDesc.Location = New System.Drawing.Point(24, 24)
      Me.lblStepsDesc.Name = "lblStepsDesc"
      Me.lblStepsDesc.Size = New System.Drawing.Size(552, 16)
      Me.lblStepsDesc.TabIndex = 17
      Me.lblStepsDesc.Text = "The following steps will be performed during the Archive and Purge process:"
      Me.lblStepsDesc.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'frmArchive
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(602, 290)
      Me.Controls.Add(Me.grpUI)
      Me.Controls.Add(Me.CDWriter)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnStart)
      Me.Controls.Add(Me.prgProgress)
      Me.Controls.Add(Me.lblStatus)
      Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "frmArchive"
      Me.Text = "Archive and Purge"
      CType(Me.CDWriter, System.ComponentModel.ISupportInitialize).EndInit()
      Me.grpUI.ResumeLayout(False)
      CType(Me.pbPointer, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region

#Region " Private Form Class Variables "

   Private mArchiveLogFile As String
   Private mFormCaption As String = ""
   Private mStatusText As String = ""
   Private mCDBurnError As String

   Private mFreeBlocks As Integer
   Private mBlocksWritten As Integer
   Private mTotalTrackBlocks As Integer

   Private mBusy As Boolean = False
   Private mEraseComplete As Boolean
   Private mWriteProcessFinished As Boolean = False
   Private mWriteSuccess As Boolean = False

#End Region

#Region " Form Event Handlers "

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStart.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Start button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lRC As Boolean
      Dim lErrorText As String = ""
      Dim lUserMsg As String
      Dim lMBIcon As MessageBoxIcon

      ' Set the busy flag.
      mBusy = True

      ' Ask user to insert cd, allow cancelling...
      lUserMsg = "Please insert a blank CD into the CD Writer on the Server."
      If MessageBox.Show(lUserMsg, "Insert Blank CD", MessageBoxButtons.OKCancel, MessageBoxIcon.Hand) = DialogResult.Cancel Then
         Exit Sub
      End If

      ' Hide the buttons on this form.
      btnStart.Hide()
      btnCancel.Hide()

      ' Show the progress bar.
      prgProgress.Show()

      ' Show an hourglass cursor.
      Me.Cursor = Cursors.WaitCursor

      ' Perform the archive/purge...
      lRC = ArchiveDB(lErrorText)

      ' Show the user archive status message...
      If lRC Then
         lMBIcon = MessageBoxIcon.Information
         lUserMsg = "Archive Process successfully completed." & _
            Environment.NewLine & Environment.NewLine & _
            "Send the CD(s) or archived files to the Diamond Game IT department in the California office."
      Else
         ' Log the error.
         If String.IsNullOrEmpty(lErrorText) Then
            lErrorText = "Archive failed, reason unknown."
         End If

         Logging.Log(lErrorText)
         lMBIcon = MessageBoxIcon.Error
         lUserMsg = lErrorText
      End If

      ' Reset the cursor.
      Me.Cursor = Cursors.Default

      ' Reset the busy flag.
      mBusy = False

      ' Show the archive result status message.
      MessageBox.Show(lUserMsg, "Archive Status", MessageBoxButtons.OK, lMBIcon)

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub frmArchive_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this form.
      '--------------------------------------------------------------------------------

      ' If we are busy, cancel the closure of this form.
      If mBusy Then e.Cancel = True

   End Sub

   Private Sub Form_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Initialize the UI...
      StatusText = ""
      cbRetrieveAI.Hide()
      cbDbBackup.Hide()
      cbCompressDB.Hide()
      cbPurgeData.Hide()
      cbWriteCD.Hide()
      pbPointer.Hide()

      ' Set the archive log filename and truncate the file if too big.
      Call SetArchiveLog()

   End Sub

#End Region

#Region " CDWriter Event Handlers"

   Private Sub CDWriter_EraseComplete(ByVal sender As Object, ByVal e As System.EventArgs) _
   Handles CDWriter.EraseComplete
      '--------------------------------------------------------------------------------
      ' EraseComplete event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      ' Reset the Erase Complete flag.
      mEraseComplete = True

   End Sub

   Private Sub CDWriter_ErasingDisc(ByVal sender As Object, ByVal e As System.EventArgs) Handles CDWriter.ErasingDisc
      '--------------------------------------------------------------------------------
      ' WritingComplete event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      StatusText = "Erasing rewritable CD content..."

   End Sub

   Private Sub CDWriter_CachingTrack(ByVal sender As Object, ByVal e As AxCDWriterXPLib._DCDWriterXPEvents_CachingTrackEvent) Handles CDWriter.CachingTrack
      '--------------------------------------------------------------------------------
      ' CachingTrack event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      StatusText = String.Format("Caching track {0}, {1:#,##0} Blocks to cache...", e.track, e.blocksToCache)

   End Sub

   Private Sub CDWriter_ClosingDisc(ByVal sender As Object, ByVal e As System.EventArgs) Handles CDWriter.ClosingDisc
      '--------------------------------------------------------------------------------
      ' ClosingDisc event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      prgProgress.Value = 98
      StatusText = "Closing Disc..."

   End Sub

   Private Sub CDWriter_ClosingSession(ByVal sender As Object, ByVal e As System.EventArgs) Handles CDWriter.ClosingSession
      '--------------------------------------------------------------------------------
      ' ClosingSession event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      StatusText = "Closing Session..."

   End Sub

   Private Sub CDWriter_ClosingTrack(ByVal sender As Object, ByVal e As AxCDWriterXPLib._DCDWriterXPEvents_ClosingTrackEvent) Handles CDWriter.ClosingTrack
      '--------------------------------------------------------------------------------
      ' ClosingTrack event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      prgProgress.Value = 92
      StatusText = String.Format("Closing Track {0}...", e.track)

   End Sub

   Private Sub CDWriter_CreatingDirectories(ByVal sender As Object, ByVal e As System.EventArgs) Handles CDWriter.CreatingDirectories
      '--------------------------------------------------------------------------------
      ' CreatingDirectories event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      StatusText = "Creating Directories..."

   End Sub

   Private Sub CDWriter_TrackFileError(ByVal sender As Object, ByVal e As AxCDWriterXPLib._DCDWriterXPEvents_TrackFileErrorEvent) Handles CDWriter.TrackFileError
      '--------------------------------------------------------------------------------
      ' TrackFileError event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      mCDBurnError = String.Format("A Track File Error occurred. File Error: {0}, File: {1}.", e.fileError, e.fileName)
      mWriteProcessFinished = True

   End Sub

   Private Sub CDWriter_TrackWriteStart(ByVal sender As Object, ByVal e As AxCDWriterXPLib._DCDWriterXPEvents_TrackWriteStartEvent) Handles CDWriter.TrackWriteStart
      '--------------------------------------------------------------------------------
      ' TrackWriteStart event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      ' Store the total number of blocks to be written on this track.
      mTotalTrackBlocks = e.blocksToWrite

   End Sub

   Private Sub CDWriter_TrackWriteStatus(ByVal sender As Object, ByVal e As AxCDWriterXPLib._DCDWriterXPEvents_TrackWriteStatusEvent) Handles CDWriter.TrackWriteStatus
      '--------------------------------------------------------------------------------
      ' TrackWriteStatus event handler for the CDWriter control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lProgressValue As Integer

      If e.blocksWritten - mBlocksWritten > 500 Then
         ' Store the number of blocks written.
         mBlocksWritten = e.blocksWritten

         ' Calc a progress value.
         lProgressValue = ((mBlocksWritten * 100) / mTotalTrackBlocks) - 10

         ' Show the number of blocks written.
         StatusText = String.Format("Writing Track {0}: {1:#,##0} blocks written...", e.track, mBlocksWritten)

         ' Make sure Progress Value is in a valid range (1 to 90)...
         If lProgressValue > 90 Then
            lProgressValue = 90
         ElseIf lProgressValue < 1 Then
            lProgressValue = 1
         End If

         ' Update the ProgressBar value.
         prgProgress.Value = lProgressValue

      End If

   End Sub

   Private Sub CDWriter_WritingCancelled(ByVal sender As Object, ByVal e As System.EventArgs) Handles CDWriter.WritingCancelled
      '--------------------------------------------------------------------------------
      ' WritingCancelled event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      StatusText = "CD Writing has been cancelled."
      mWriteSuccess = False
      mWriteProcessFinished = True

   End Sub

   Private Sub CDWriter_WritingComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles CDWriter.WritingComplete
      '--------------------------------------------------------------------------------
      ' WritingComplete event handler for the CDWriter control.
      '--------------------------------------------------------------------------------

      StatusText = "CD Writing is complete."
      mWriteSuccess = True
      mWriteProcessFinished = True
      prgProgress.Value = 100

   End Sub

   Private Sub CDWriter_WriteError(ByVal sender As Object, ByVal e As AxCDWriterXPLib._DCDWriterXPEvents_WriteErrorEvent) Handles CDWriter.WriteError
      '--------------------------------------------------------------------------------
      ' WriteError event handler for the CDWriter control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""

      ' Create an error message based upon the error number that occurred...
      Select Case e.writeError
         Case CDWriterXPLib.eWriteError.errDriveError
            lErrorText = "An unknown drive error was encountered."

         Case CDWriterXPLib.eWriteError.errFileError
            lErrorText = "A file error was encountered while writing the disc."

         Case CDWriterXPLib.eWriteError.errInvalidFormat
            lErrorText = "Tracks have been added the disc image with an invalid format...Please try again."

         Case CDWriterXPLib.eWriteError.errNoTracksQueued
            lErrorText = "Tracks have been added the disc image...Please add tracks and try again."

         Case CDWriterXPLib.eWriteError.errReadBufferInitFailed
            lErrorText = "The read buffer could not be initialized...check your memory/disc resources."

         Case CDWriterXPLib.eWriteError.errWriteBufferInitFailed
            lErrorText = "The write buffer could not be initialized...check your memory/disc resources."

         Case Else
            lErrorText = String.Format("Unknown CD Write Error. Error Number {0}.  ", e.writeError) & _
               CDWriter.GetLastError

      End Select

      If mCDBurnError.Length = 0 Then
         mCDBurnError = lErrorText
      Else
         mCDBurnError &= "  " & lErrorText
      End If

      Logging.Log(lErrorText)
      mWriteSuccess = False

   End Sub

#End Region

#Region " Private Functions "

   Private Function ArchiveDB(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Archives Casino database data.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      ' [Data objects]
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow = Nothing
      Dim lDRArchInfo As DataRow = Nothing
      Dim lDS As DataSet = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDTArchiveStats As DataTable = Nothing
      Dim lDTArchInfo As DataTable = Nothing
      Dim lDRSel() As DataRow

      ' [Drawing objects]
      Dim lLocation As System.Drawing.Point

      ' [Encrypt/Decrypt object]
      Dim lAPE As New AppPasswordEncryption

      ' [Drive and File objects]
      Dim lFI As FileInfo
      Dim lBR As BinaryReader
      Dim lDI As IO.DriveInfo

      ' [Booleans]
      Dim lMustRestore As Boolean = False
      Dim lOkToDropBak As Boolean = True
      Dim lReturn As Boolean = True
      Dim lRC As Boolean
      Dim lSpaceCheck As Boolean
      Dim lWriteCD As Boolean = True

      ' [Shorts]
      Dim lIt As Short

      ' [Integers]
      Dim lChunkMax As Integer
      Dim lCount As Integer
      Dim lFileNumber As Integer
      Dim lMinTN As Integer
      Dim lMaxTN As Integer
      Dim lRowCount As Integer
      Dim lSplitSize As Integer
      Dim lValue As Integer

      ' [Longs]
      Dim lDBFileSize As Long
      Dim lFSize As Long
      Dim lRemaining As Long

      ' [Dates]
      Dim lArchiveDT As Date
      Dim lFilterDate As Date

      ' [Strings]
      Dim lBackupFile As String = ""
      Dim lCasinoPrefix As String
      Dim lDataFolder As String = ""
      Dim lDBName As String = ""
      Dim lFileName As String
      Dim lLogMsg As String
      Dim lNewLine As String = Environment.NewLine
      Dim lPWD As String
      Dim lRecoveryMode As String = ""
      Dim lSplitName As String
      Dim lSVR As String
      Dim lSQL As String
      Dim lUID As String
      Dim lValueText As String
      Dim lZipfileName As String

      Dim lFileList() As String


      ' Store the current date and time as the archive datetime.
      lArchiveDT = Date.Now

      Call ArchiveLog("------------------------------------------------------------")
      Call ArchiveLog(String.Format("Archive/Purge process started by {0}.", gAppUserName))

      ' Set the form caption.
      FormCaption = "Archive and Purge in progress..."

      ' Set error text to an empty string.
      aErrorText = ""

      ' Retrieve configuration values we will need for the Process arguments text...
      Try
         With My.Settings
            lSVR = .DatabaseServer
            lDBName = .LotteryRetailDBCatalog
            lUID = .DatabaseUserID
            lPWD = .DatabasePassword
            lPWD = lAPE.DecryptPassword(lPWD)

            ' Set the Freespace check flag...
            lSpaceCheck = .FreeSpaceCheck

            ' Store the archive folder name.
            lDataFolder = .ArchiveFolder

            ' Set the Write CD flag...
            If .WAF.EndsWith("-") Then lWriteCD = False
         End With


      Catch ex As Exception
         ' Handle the error...
         aErrorText = "Error retrieving configuration values: " & ex.Message
         lReturn = False

      End Try

      ' Still okay to continue?
      If lReturn Then
         ' If the folder exists, delete it.
         If Directory.Exists(lDataFolder) Then
            Try
               ' Setting the second argument to True will recursively delete files and subfolders.
               Directory.Delete(lDataFolder, True)

            Catch ex As Exception
               ' Handle the error...
               aErrorText = String.Format("Unable to delete Archive Folder {0}: ", lDataFolder) & ex.Message
               lReturn = False

            End Try
         End If
      End If

      ' Still okay to continue?
      If lReturn Then
         Try
            ' Create the data archive folder.
            Directory.CreateDirectory(lDataFolder)

         Catch ex As Exception
            ' Handle the error...
            aErrorText = String.Format("Unable to create Archive Folder {0}: ", lDataFolder) & ex.Message
            lReturn = False

         End Try
      End If

      ' If we have encountered an error, return now.
      If Not lReturn Then Return lReturn

      ' Create an 'on the fly' DataTable to contain archive stats...
      lDTArchiveStats = New DataTable("ArchiveStats")
      With lDTArchiveStats
         .Columns.Add("CAS_ID", GetType(String))
         .Columns.Add("TABLE_NAME", GetType(String))
         .Columns.Add("ARCHIVE_DATE", GetType(Date))
         .Columns.Add("ID_START", GetType(Integer))
         .Columns.Add("ID_END", GetType(Integer))
         .Columns.Add("ROW_COUNT", GetType(Integer))
      End With

      Try
         ' Instantiate a new database object, keep connection open, set CommandTimout to 3 hours.
         lSDA = New SqlDataAccess(gConnectRetail, True, 10800)

      Catch ex As Exception
         ' Handle the error...
         aErrorText = "Unable to establish database connection. Check connection settings. Error: " & _
            ex.Message
         lReturn = False

      End Try

      ' If no errors so far, retrieve the database diskspace usage.
      If lReturn Then
         ' Build SQL EXEC statement to retrieve db info.
         lSQL = String.Format("EXEC sp_helpdb @dbname='{0}'", lDBName)

         Try
            ' Fill the DataSet.
            lDS = lSDA.ExecuteSQL(lSQL)

            ' Get the database file space...
            lValueText = CType(lDS.Tables(0).Rows(0).Item("db_size"), String).Trim
            Call ArchiveLog(String.Format("{0} File space: {1}.", lDBName, lValueText))
            lValueText = lValueText.Substring(0, lValueText.IndexOfAny(". ".ToCharArray))
            lDBFileSize = (Long.Parse(lValueText) + 1) * 1024 * 1204

            ' Done with DataSet, free it...
            lDS.Dispose()
            lDS = Nothing

            ' Check for sufficient free space...
            lDI = New DriveInfo(lDataFolder)
            Call ArchiveLog(String.Format("Free space in {0}: {1:#,##0.00} MB.", lDataFolder, ((lDI.TotalFreeSpace / 1024) / 1024)))
            If lSpaceCheck = True Then
               If (lDBFileSize * 2) > lDI.TotalFreeSpace Then
                  aErrorText = String.Format("Insufficient free disk space in {0}.", lDataFolder)
                  lReturn = False
               End If
            Else
               Call ArchiveLog("Space Check overridden.")
            End If

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving database information (sp_helpdb): " & ex.Message
            lReturn = False

         End Try
      End If

      ' If we have encountered an error, return now.
      If Not lReturn Then
         If lSDA IsNot Nothing Then lSDA.Dispose()
         Return lReturn
      End If

      ' Initialize the progress viewer form...
      With prgProgress
         .Maximum = 100
         .Value = 2
      End With

      StatusText = "Retrieving Archive information..."
      With pbPointer
         .Show()
         .Refresh()
      End With

      Try
         ' Log start of stored procedure call.
         Call ArchiveLog("Calling Get_Archive_Info.")

         ' Retrieve archive information.
         lDTArchInfo = lSDA.CreateDataTableSP("Get_Archive_Info")
         lDRArchInfo = lDTArchInfo.Rows(0)
         prgProgress.Value = 10

         If IsDBNull(lDRArchInfo.Item("FILTER_DATE")) Then
            lReturn = False
            aErrorText = "Get_Archive_Info found that there is no play data."
            If lSDA IsNot Nothing Then lSDA.Dispose()
            lSDA = Nothing
            Return lReturn
         End If

         lFilterDate = lDRArchInfo.Item("FILTER_DATE")
         lLogMsg = String.Format("Get_Archive_Info returned Filter Date {0}.", lFilterDate)
         Call ArchiveLog(lLogMsg)

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         aErrorText = "Error calling Get_Archive_Info: " & ex.Message
      End Try

      ' Add rows to the ArchiveStats table
      If lReturn Then
         For lIt = 1 To 4
            lDR = lDTArchiveStats.NewRow
            lDR("CAS_ID") = gDefaultCasinoID
            lDR("ARCHIVE_DATE") = lArchiveDT
            Select Case lIt
               Case 1
                  ' CASHIER_TRANS row
                  lDR("TABLE_NAME") = "CASHIER_TRANS"
                  lDR("ID_START") = lDRArchInfo.Item("CASHIER_TRANS_ID_START")
                  lDR("ID_END") = lDRArchInfo.Item("CASHIER_TRANS_ID_END")
                  lDR("ROW_COUNT") = lDRArchInfo.Item("CASHIER_TRANS_ROW_COUNT")
               Case 2
                  ' CASINO_EVENT_LOG row
                  lDR("TABLE_NAME") = "CASINO_EVENT_LOG"
                  lDR("ID_START") = lDRArchInfo.Item("CASINO_EVENT_LOG_ID_START")
                  lDR("ID_END") = lDRArchInfo.Item("CASINO_EVENT_LOG_ID_END")
                  lDR("ROW_COUNT") = lDRArchInfo.Item("CASINO_EVENT_LOG_ROW_COUNT")
               Case 3
                  ' CARD_ACCT row
                  lDR("TABLE_NAME") = "CARD_ACCT"
                  lDR("ID_START") = lDRArchInfo.Item("CARD_ACCT_LOW")
                  lDR("ID_END") = lDRArchInfo.Item("CARD_ACCT_HIGH")
                  lDR("ROW_COUNT") = lDRArchInfo.Item("CARD_ACCT_ROW_COUNT")
               Case 4
                  lDR("TABLE_NAME") = "CASINO_TRANS"
                  lDR("ID_START") = lDRArchInfo.Item("CASINO_TRANS_ID_START")
                  lDR("ID_END") = lDRArchInfo.Item("CASINO_TRANS_ID_END")
                  lDR("ROW_COUNT") = lDRArchInfo.Item("CASINO_TRANS_ROW_COUNT")
            End Select

            ' Add the row.
            lDTArchiveStats.Rows.Add(lDR)
            Call ArchiveLog(String.Format("Get_Archive_Info - Table: {0} Start: {1} End: {2} Rows: {3}", lDR("TABLE_NAME"), lDR("ID_START"), lDR("ID_END"), lDR("ROW_COUNT")))
         Next

         ' Show retrieval as completed.
         With cbRetrieveAI
            .Show()
            .Refresh()
         End With

         Try
            ' Delete any old files in the working folder...
            For Each lFileName In Directory.GetFiles(lDataFolder, "*.*")
               File.Delete(lFileName)
            Next

         Catch ex As Exception
            ' Handle the error...
            lReturn = False
            aErrorText = "Error dropping old archive files: " & ex.Message

         End Try
      End If

      ' -------------------- Backup the database --------------------
      ' Log start of backup.
      If lReturn Then

         ' Build the backup file name...
         lCasinoPrefix = gDefaultCasinoID.TrimEnd(" 0123456789".ToCharArray)
         lBackupFile = String.Format("Casino_{0}_{1:yyyy_MMdd_HHmm}.bak", lCasinoPrefix, lArchiveDT)
         lBackupFile = Path.Combine(lDataFolder, lBackupFile)

         ' Update user status info...
         prgProgress.Value = 20

         ' Move the process pointer image...
         With pbPointer
            lLocation = .Location
            lLocation.Y += 22
            .Location = lLocation
            .Refresh()
         End With

         ' Log start of backup...
         lLogMsg = String.Format("Starting Database backup of {0} to {1}.", lDBName, lBackupFile)
         Call ArchiveLog(lLogMsg)

         ' Show user backup has begun.
         StatusText = String.Format("Backing up to {0}...", lBackupFile)
         Application.DoEvents()

         ' Build the SQL statement to backup the database.
         lSQL = String.Format("BACKUP DATABASE {0} TO DISK = '{1}'", lDBName, lBackupFile)

         Try
            ' Perform the backup.
            lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Database Backup error: " & ex.Message
            lReturn = False
         End Try
      End If

      If lReturn Then
         ' Show database backup as completed.
         With cbDbBackup
            .Show()
            .Refresh()
         End With

         ' Move the process pointer image...
         With pbPointer
            lLocation = .Location
            lLocation.Y += 22
            .Location = lLocation
            .Refresh()
         End With

         Application.DoEvents()

         ' Do we need to split the database backup file?
         lFI = New FileInfo(lBackupFile)
         lFSize = lFI.Length
         Call ArchiveLog(String.Format("Backup file size is {0:#,###}", lFSize))

         lSplitSize = Integer.MaxValue

         ' If lFSize > lSplitSize Then
         If lFSize > lSplitSize Then
            ' Log start of Split/Compress process.
            Call ArchiveLog("Starting Split/Compress process.")

            '  Instantiate  a new Binary Reader to read the backup file.
            lBR = New BinaryReader(New FileStream(lBackupFile, FileMode.Open, FileAccess.Read))

            ' Init bytes remaining to be written and split file number...
            lRemaining = lFSize
            lFileNumber = 0
            prgProgress.Value = 24

            ' Reset split size to a smaller value (1 mb).
            ' We will read/write 1 mb chunks.
            lSplitSize = 1048576

            Do While lRemaining > 0
               Dim lBW As BinaryWriter

               ' Increment the split file number.
               lFileNumber += 1

               ' Build the name of the split backup file.
               lSplitName = lBackupFile.Replace(".bak", String.Format("_{0:00}sf.sbf", lFileNumber))

               ' Create a new Binary Writer.
               lBW = New BinaryWriter(New FileStream(lSplitName, FileMode.Create))

               ' Update user status text.
               StatusText = String.Format("Writing file {0}...", lSplitName)

               ' Create files containing no more than 500 MB...
               For lCount = 1 To 500
                  Dim lData() As Byte

                  ' Read from the bak file into lData.
                  lData = lBR.ReadBytes(lSplitSize)

                  ' Write data we read to the file.
                  lBW.Write(lData)

                  lRemaining -= lSplitSize
                  If lRemaining < 1 Then Exit For
               Next
               Application.DoEvents()

               ' Close the BinaryWriter
               lBW.Close()

               ' Log end of split file writing.
               Call ArchiveLog(String.Format("Finished writing {0}.", lSplitName))

               ' Prepare to zip the split file...
               lFileList = Directory.GetFiles(lDataFolder, Path.GetFileName(lSplitName))
               lZipfileName = Path.ChangeExtension(lSplitName, ".zip")

               ' Update user status text.
               StatusText = String.Format("Compressing file {0}...", lSplitName)

               ' Zip the split file.
               Xceed.Zip.QuickZip.Zip(lZipfileName, True, False, False, lFileList)

               ' Delete the split file since we have it zipped.
               File.Delete(lSplitName)

               ' Log end of zip.
               Call ArchiveLog(String.Format("Finished compressing {0}.", lZipfileName))

               Application.DoEvents()
            Loop

            ' Close and free the binary reader...
            If Not lBR Is Nothing Then
               lBR.Close()
               lBR = Nothing
            End If

            ' Log number of split files...
            lLogMsg = String.Format("Split Backup file into {0} files.", lFileNumber)
            Call ArchiveLog(lLogMsg)
         Else
            ' Did not need to split the backup file, just zip it...
            lFileList = Directory.GetFiles(lDataFolder, Path.GetFileName(lBackupFile))
            lZipfileName = Path.ChangeExtension(lBackupFile, ".zip")

            ' Update user status text.
            StatusText = String.Format("Compressing file {0}...", lBackupFile)

            Application.DoEvents()

            Call ArchiveLog("Starting backup file compression (single file).")

            Try
               ' Zip the split file.
               Xceed.Zip.QuickZip.Zip(lZipfileName, True, False, False, lFileList)

               Call ArchiveLog("Backup file compression finished.")

            Catch ex As Exception
               ' Handle the error...
               aErrorText = "Error attempting to compress database backup: " & ex.Message
               lReturn = False

            End Try

         End If
      End If

      ' Show zipping as completed.
      If lReturn Then
         With cbCompressDB
            .Show()
            .Refresh()
         End With
      Else
         ' Bail out here (before we actually drop data) if an error was encountered.
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
         Return lReturn
      End If

      ' Turn off database logging while purging data...
      If lReturn Then
         lSQL = String.Format("SELECT DATABASEPROPERTYEX('{0}', 'Recovery')", lDBName)
         Try
            lDT = lSDA.CreateDataTable(lSQL)
            lRecoveryMode = lDT.Rows(0).Item(0)

            If lRecoveryMode.ToUpper <> "SIMPLE" Then
               lSQL = String.Format("ALTER DATABASE {0} SET RECOVERY SIMPLE", lDBName)
               lSDA.ExecuteSQLNoReturn(lSQL)

               ' Log reset of recovery mode to SIMPLE.
               Call ArchiveLog("Database Recovery mode set to SIMPLE.")
            End If

         Catch ex As Exception
            ' Ignore this error (it is an error but not one that should kill this operation).

         End Try

      End If

      ' Move the process pointer image...
      If lReturn Then
         With pbPointer
            lLocation = .Location
            lLocation.Y += 22
            .Location = lLocation
            .Refresh()
         End With

         Application.DoEvents()

         ' Begin purging data...
         ' [---------- Purge CASHIER_TRANS data ----------]

         ' Log start of CASHIER_TRANS purge.
         Call ArchiveLog("Purging CASHIER_TRANS data.")

         Try
            lMinTN = lDRArchInfo.Item("CASHIER_TRANS_ID_START")
            lMaxTN = lDRArchInfo.Item("CASHIER_TRANS_ID_END")

            ' Set progress viewer text and value...
            prgProgress.Value = 30
            StatusText = "Dropping old Cashier Transactions..."

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving CASHIER_TRANS start and end values: " & ex.Message
            lReturn = False

         End Try

         If lReturn Then
            If Not (lMinTN = 0 And lMaxTN = 0) Then
               ' Build SQL DELETE statement.
               lSQL = "DELETE FROM {0}..CASHIER_TRANS WHERE CASHIER_TRANS_ID BETWEEN {1} AND {2}"
               lSQL = String.Format(lSQL, lDBName, lMinTN, lMaxTN)

               ' Perform the purge.
               Try
                  lRowCount = lSDA.ExecuteSQLNoReturn(lSQL)
                  lMustRestore = True
                  lLogMsg = String.Format("Purged {0:#,##0} CASHIER_TRANS rows.", lRowCount)
                  Call ArchiveLog(lLogMsg)

               Catch ex As Exception
                  ' Handle the error...
                  aErrorText = "CASHIER_TRANS Purge error: " & ex.Message
                  lReturn = False

               End Try
            Else
               ' No data to drop.
               lRowCount = 0
            End If
         End If

         ' Update the number of rows purged.
         If lReturn Then
            lDRSel = lDTArchiveStats.Select("TABLE_NAME = 'CASHIER_TRANS'")
            If lDRSel.Length > 0 Then
               lDR = lDRSel(0)
               lDR.Item("ROW_COUNT") = lRowCount
            End If
         End If
         Application.DoEvents()
      End If

      ' [---------- Purge CASINO_EVENT_LOG data ----------]
      If lReturn Then
         ' Log start of CASINO_EVENT_LOG purge.
         Call ArchiveLog("Purging CASINO_EVENT_LOG data.")

         ' Get Min and Max values...
         Try
            lMinTN = lDRArchInfo.Item("CASINO_EVENT_LOG_ID_START")
            lMaxTN = lDRArchInfo.Item("CASINO_EVENT_LOG_ID_END")

            ' Set progress viewer text and value...
            prgProgress.Value = 40
            StatusText = "Dropping old Casino Event Log data..."

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving CASINO_EVENT_LOG start and end values: " & ex.Message
            lReturn = False

         End Try

         If lReturn Then
            If Not (lMinTN = 0 And lMaxTN = 0) Then
               ' Build SQL DELETE statement.
               lSQL = "DELETE FROM {0}..CASINO_EVENT_LOG WHERE CASINO_EVENT_LOG_ID BETWEEN {1} AND {2}"
               lSQL = String.Format(lSQL, lDBName, lMinTN, lMaxTN)

               ' Perform the purge.
               Try
                  lRowCount = lSDA.ExecuteSQLNoReturn(lSQL)
                  lMustRestore = True
                  lLogMsg = String.Format("Purged {0:#,##0} CASINO_EVENT_LOG rows.", lRowCount)
                  Call ArchiveLog(lLogMsg)

               Catch ex As Exception
                  ' Handle the error...
                  aErrorText = "CASINO_EVENT_LOG Purge error: " & ex.Message
                  lReturn = False

               End Try
            Else
               ' No data to truncate...
               lRowCount = 0
            End If
         End If

         ' Update the number of rows purged.
         If lReturn Then
            lDRSel = lDTArchiveStats.Select("TABLE_NAME = 'CASINO_EVENT_LOG'")
            If lDRSel.Length > 0 Then
               lDR = lDRSel(0)
               lDR.Item("ROW_COUNT") = lRowCount
            End If
         End If

         Application.DoEvents()
      End If

      ' [---------- Purge CASINO_TRANS data ----------]
      If lReturn Then
         Try
            ' Get Min and Max values...
            lMinTN = lDRArchInfo.Item("CASINO_TRANS_ID_START")
            lMaxTN = lDRArchInfo.Item("CASINO_TRANS_ID_END")

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving CASINO_TRANS start and end values: " & ex.Message
            lReturn = False

         End Try

         If lReturn Then
            If Not (lMinTN = 0 And lMaxTN = 0) Then
               ' Log start of CASINO_TRANS purge...
               lLogMsg = String.Format("Purging CASINO_TRANS data (TRANS_NO between {0} and {1}).", lMinTN, lMaxTN)
               Call ArchiveLog(lLogMsg)

               ' Delete in 1 million row chunks...
               lChunkMax = lMinTN
               lRowCount = 0
               StatusText = String.Format("Dropping Casino Trans rows (IDs in range {0} to {1})...", lMinTN, lMaxTN)

               Do While lChunkMax < lMaxTN And lReturn = True
                  ' Set progress viewer text and value...
                  lValue = prgProgress.Value + 2
                  If lValue > 80 Then lValue = 80
                  prgProgress.Value = lValue

                  lChunkMax += 1000000
                  If lChunkMax > lMaxTN Then lChunkMax = lMaxTN

                  ' Build SQL DELETE statement.
                  lSQL = "DELETE FROM {0}..CASINO_TRANS WHERE TRANS_NO BETWEEN {1} AND {2}"
                  lSQL = String.Format(lSQL, lDBName, lMinTN, lChunkMax)

                  ' Perform the purge.
                  Try
                     lRowCount += lSDA.ExecuteSQLNoReturn(lSQL)
                     lMustRestore = True
                     StatusText = String.Format("Dropped {0:#,##0} Casino Trans rows...", lRowCount)

                  Catch ex As Exception
                     ' Handle the error...
                     aErrorText = "CASINO_TRANS Purge error: " & ex.Message
                     lReturn = False
                  End Try

                  lMinTN = lChunkMax
                  Application.DoEvents()
               Loop
            Else
               ' No data to truncate...
               lRowCount = 0
            End If
         End If

         If lReturn Then
            ' Update the numaber of rows purged.
            lDRSel = lDTArchiveStats.Select("TABLE_NAME = 'CASINO_TRANS'")
            If lDRSel.Length > 0 Then
               lDR = lDRSel(0)
               lDR.Item("ROW_COUNT") = lRowCount
            End If
            lLogMsg = String.Format("Purged {0:#,##0} CASINO_TRANS rows.", lRowCount)
            Call ArchiveLog(lLogMsg)
         End If
      End If

      ' [---------- Purge CARD_ACCT data ----------]
      If lReturn Then
         ' Log start of CARD_ACCT purge.
         Call ArchiveLog("Purging CARD_ACCT data.")
         Try
            ' Get Min and Max values...
            lMinTN = lDRArchInfo.Item("CARD_ACCT_LOW")
            lMaxTN = lDRArchInfo.Item("CARD_ACCT_HIGH")

            ' Set progress viewer text and value...
            prgProgress.Value = 84
            StatusText = "Dropping old Card Account data..."

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving CARD_ACCT start and end values: " & ex.Message
            lReturn = False

         End Try

         If lReturn Then
            ' Build SQL DELETE statement.
            lSQL = "DELETE FROM {0}..CARD_ACCT WHERE (DATEDIFF(Day, MODIFIED_DATE, '{1:yyyy-MM-dd}') > 45) AND (CARD_ACCT_NO LIKE '{2}%')"
            lSQL = String.Format(lSQL, lDBName, lFilterDate, gDefaultCasinoID) & _
               " AND (CARD_ACCT_NO NOT IN (SELECT DISTINCT CARD_ACCT_NO FROM CASINO_TRANS))"

            ' Perform the purge.
            Try
               lRowCount = lSDA.ExecuteSQLNoReturn(lSQL)
               ' Set the must restore flag...
               If Not lMustRestore Then
                  lMustRestore = (lRowCount > 0)
               End If

               ' Log number of card account rows dropped...
               lLogMsg = String.Format("Purged {0:#,##0} CARD_ACCT rows.", lRowCount)
               Call ArchiveLog(lLogMsg)

            Catch ex As Exception
               ' Handle the error...
               aErrorText = "CARD_ACCT Purge error: " & ex.Message
               lReturn = False

            End Try
         End If

         ' Update the number of rows purged.
         If lReturn Then
            lDRSel = lDTArchiveStats.Select("TABLE_NAME = 'CARD_ACCT'")
            If lDRSel.Length > 0 Then
               lDR = lDRSel(0)
               lDR.Item("ROW_COUNT") = lRowCount
            End If
         End If

         Application.DoEvents()
      End If

      ' [---------- End of data purge ----------]

      If lReturn Then
         ' Set the recovery mode to it's original state...
         lSQL = String.Format("SELECT DATABASEPROPERTYEX('{0}', 'Recovery')", lDBName)
         lDT = lSDA.CreateDataTable(lSQL)
         lValueText = lDT.Rows(0).Item(0)
         lRecoveryMode = lRecoveryMode.ToUpper

         ' Do we need to reset the recovery mode?
         If lValueText.ToUpper <> lRecoveryMode Then
            ' Yes, so build the SQL statement and execute it...
            lSQL = String.Format("ALTER DATABASE {0} SET RECOVERY {1}", lDBName, lRecoveryMode)
            Try
               lSDA.ExecuteSQLNoReturn(lSQL)
               ' Log the reset...
               lLogMsg = String.Format("Database Recovery mode reset to {0}.", lRecoveryMode)
            Catch ex As Exception
               lLogMsg = "Failed to restore Database Recovery mode."
            End Try
            Call ArchiveLog(lLogMsg)
         End If

         ' Log end of purge process.
         Call ArchiveLog("Purging successfully finished.")

         ' Write the archive results table to a file.
         lDS = New DataSet("ArchiveStatistics")
         lDS.Tables.Add(lDTArchiveStats)
         lFileName = Path.Combine(lDataFolder, "ArchiveStats.xml")
         lDS.WriteXml(lFileName, XmlWriteMode.WriteSchema)
         Application.DoEvents()

         Try
            ' Write archive result rows to the ARCHIVE_STATS table...
            For Each lDR In lDTArchiveStats.Rows
               ' Build the SQL INSERT statement.
               lSQL = "INSERT INTO ARCHIVE_STATS (TABLE_NAME, ARCHIVE_DATE, ID_START, ID_END, ROW_COUNT) VALUES " & _
                  String.Format("('{0}', '{1}', {2}, {3}, {4})", lDR(1), lDR(2), lDR(3), lDR(4), lDR(5))
               ' Perform the INSERT.
               lSDA.ExecuteSQLNoReturn(lSQL)
               Application.DoEvents()
            Next

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "ARCHIVE_STATS INSERT error: " & ex.Message
            lReturn = False

         End Try
      End If

      ' Do we need to restore the database?
      If lReturn = False And lMustRestore = True Then
         ' Yes, so build the SQL RESTORE DATABASE command...
         ' Note that the lMustRestore boolean has been set to true if any data has been deleted.
         lSQL = String.Format("RESTORE DATABASE {0} FROM DISK = '{1}'", lDBName, lBackupFile)

         ' Set progress viewer text and value...
         StatusText = "Problems were encountered, attempting to restore database..."
         prgProgress.Value = 95

         Call ArchiveLog("Restoring Database started.")

         ' Perform the restoration...
         Try
            lSDA.ExecuteSQLNoReturn(lSQL)
            Call ArchiveLog("Database successfully restored.")

         Catch ex As Exception
            ' Handle the error...
            aErrorText &= "  WARNING: Attempt to restore database failed. Please attempt to manually restore the database using file " & lBackupFile & "."
            lOkToDropBak = False
            Call ArchiveLog(aErrorText)
         End Try
      End If

      ' We are done with the dataset object...
      If Not lDS Is Nothing Then lDS.Dispose()

      ' Delete the original bak file if okay to drop and it exists...
      If lOkToDropBak = True Then
         If File.Exists(lBackupFile) Then
            File.Delete(lBackupFile)
            Call ArchiveLog("Compression complete, backup file deleted.")
         End If
      End If

      ' If successful so far, attempt to burn a CD...
      If lReturn Then
         Dim lErrorText As String = ""
         Dim lCanRetry As Boolean

         ' Show Data Purge has completed.
         With cbPurgeData
            .Show()
            .Refresh()
         End With

         ' Move the process pointer image...
         With pbPointer
            lLocation = .Location
            lLocation.Y += 22
            .Location = lLocation
            .Refresh()
         End With

         ' Is the Write CD flag set?
         If lWriteCD Then
            ' Yes, so begin the CD writing process...
            Do
               lRC = WriteCD(lDataFolder, lErrorText, lCanRetry)
               If lRC = True Then
                  ' Success, no reattempt necessary, exit the Do Loop...
                  Exit Do
               Else
                  ' Log the error.
                  Call ArchiveLog(lErrorText)
                  Logging.Log(lErrorText)

                  ' Problem encountered, can they retry?
                  If lCanRetry Then
                     ' Build user prompt text...
                     lValueText = "It is imperative that the archived files are sent to the Diamond Game IT department in California." & lNewLine & lNewLine & _
                        "Error: " & lErrorText & lNewLine & lNewLine & _
                        "Do you want to try again?"
                     ' Prompt user for retry.
                     If MessageBox.Show(lValueText, _
                                        "Please Confirm", _
                                        MessageBoxButtons.YesNo, _
                                        MessageBoxIcon.Question, _
                                        MessageBoxDefaultButton.Button1) = DialogResult.No Then
                        ' User does not want to retry, exit the write cd loop.
                        Exit Do
                     End If
                  End If
               End If
            Loop

            ' Did the CD Write succeed?
            If lRC Then
               ' Yes, check if we split files and if so, delete the zip files in the Archive Folder.
               lValueText = Path.Combine(lDataFolder, "Disc01")
               If Directory.Exists(lValueText) Then
                  ' Split file folder exists, delete zip files in the data folder.
                  For Each lFileName In Directory.GetFiles(lDataFolder, "*.zip")
                     File.Delete(lFileName)
                  Next
               End If

               ' Set text for archive log file.
               lLogMsg = "Successfully completed CD creation."
            Else
               ' CD Write failed so inform user...
               lLogMsg = "CD creation did NOT complete successfully."

               With cbWriteCD
                  .ForeColor = Color.Red
                  .Text = "Manually Copy Files!!!"
               End With

               ' Set text for archive log file.
               ' User said do not reattempt, inform them that they must manually get the files...
               lValueText = "It is imperative that the archived files are sent to the Diamond Game IT department in California." & _
                  lNewLine & lNewLine & _
                  "You must manually copy the files in Folder " & lDataFolder & _
                  " and send them to the Diamond Game IT department in the California office."
               MessageBox.Show(lValueText, "IMPORTANT NOTICE", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            End If

            ' Log CD write result.
            Call ArchiveLog(lLogMsg)
         Else
            ' CD Writing turned off, log it...
            lLogMsg = "CD creation turned off."
            Call ArchiveLog(lLogMsg)

            ' CD writing was turned off, inform user that they must manually get the files...
            lValueText = "It is imperative that the archived files are sent to the Diamond Game IT department in California." & _
               lNewLine & lNewLine & _
               "You must manually copy the files in Folder " & lDataFolder & _
               " and send them to the Diamond Game IT department in the California office."
            MessageBox.Show(lValueText, "IMPORTANT NOTICE", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
         End If

         ' Show the Write CD checkbox.
         With cbWriteCD
            .Show()
            .Refresh()
         End With
      End If

      ' Are we error free?
      If lReturn Then
         ' Was the backup file deleted?
         If Not File.Exists(lBackupFile) Then
            ' It was deleted, so we will perform another backup now that data is purged, and then free some disk space...
            ' Update user status info...
            prgProgress.Value = 94

            ' Move the process pointer image...
            With pbPointer
               lLocation = .Location
               lLocation.Y += 22
               .Location = lLocation
               .Refresh()
            End With

            StatusText = String.Format("Final Backup to {0}...", lBackupFile)
            Call ArchiveLog("Final Database backup started.")
            Application.DoEvents()

            ' Build the SQL statement to backup the database.
            lSQL = String.Format("BACKUP DATABASE {0} TO DISK = '{1}'", lDBName, lBackupFile)
            lRC = True
            Try
               ' Perform the backup.
               lSDA.ExecuteSQLNoReturn(lSQL)
               lLogMsg = "Final Database backup completed successfully."

            Catch ex As Exception
               ' Handle the error...
               lRC = False
               lLogMsg = "Final Database backup failed: " & ex.Message

            End Try

            ' Log final backup result.
            Call ArchiveLog(lLogMsg)

            ' Tell user we're attempting to shrink the database.
            StatusText = String.Format("Shrinking the {0} database files...", lDBName)

            Call ArchiveLog("Database file truncation started.")
            Application.DoEvents()

            ' Build the SQL statement to shrink the database.
            lSQL = String.Format("DBCC SHRINKDATABASE ({0}, TRUNCATEONLY)", lDBName)

            Try
               ' Perform the truncation.
               lSDA.ExecuteSQLNoReturn(lSQL)
               lLogMsg = "Database file truncation completed successfully."

            Catch ex As Exception
               ' Handle the error...
               lRC = False
               lLogMsg = "Database file truncation failed: " & ex.Message
            End Try

            ' Log DBCC SHRINKDATABASE result.
            Call ArchiveLog(lLogMsg)

            ' Show the final backup checkbox control.
            With cbFinalBackup
               .Show()
               .Refresh()
            End With
         End If
      End If

      ' If no errors, show the report.
      If lReturn Then
         lLogMsg = "Creating Archive Purge Report."
         Call ArchiveLog(lLogMsg)
         StatusText = lLogMsg

         ' Build the SQL SELECT statement to retrieve report data.
         lSQL = String.Format("SELECT * FROM ARCHIVE_STATS WHERE ARCHIVE_DATE = '{0:yyyy-MM-dd HH:mm:ss}'", lArchiveDT)

         ' Retrieve the data.
         lDT = lSDA.CreateDataTable(lSQL)

         ' Show the report...
         Dim frmReportViewer As New ReportViewRSLocal
         With frmReportViewer
            '.MdiParent = Me.MdiParent
            .ArchiveDate = String.Format("{0:MM-dd-yyyy HH:mm:ss}", lArchiveDT)
            .ShowReport(lDT, "ARCHIVE AND PURGE REPORT")
            .Show()
         End With
      End If

      ' We are done with the database object, so free it...
      If lSDA IsNot Nothing Then lSDA.Dispose()

      ' Reset Form Caption text and lblStatus text...
      FormCaption = "Archive and Purge"
      prgProgress.Value = 100
      StatusText = ""
      pbPointer.Hide()

      ' If we have error text, prepend the form and procedure names to it...
      If aErrorText.Length > 0 Then
         aErrorText = Me.Name & "::ArchiveDB: " & aErrorText
      End If

      ' Set the archive function return value.
      Return lReturn

   End Function

   Private Function WriteCD(ByVal aFolderName As String, _
                         ByRef aErrorText As String, _
                         ByRef aCanRetry As Boolean) As Boolean
      '--------------------------------------------------------------------------------
      ' Writes the contents of the specified Folder to a CD.
      ' Returns True or False to indicate success or failure.
      ' Sets aCanRetry flag to indicate if user can make a change and retry the CD Write.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFI As FileInfo

      Dim lIsRewritable As Boolean
      Dim lSingleCD As Boolean = True
      Dim lReturn As Boolean = True

      Dim lCDCount As Short
      Dim lDiscNumber As Short
      Dim lMaxWriteSpeed As Short

      Dim lBlocksRequired As Integer

      Dim lFileSize As Long
      Dim lSizeLimit As Long
      Dim lTotalSize As Long

      Dim lDriveLetter As String
      Dim lFileName As String
      Dim lISODestination As String
      Dim lISOSource As String
      Dim lSubFolder As String
      Dim lUserMsg As String
      Dim lVolumeLabel As String

      ' Initialize error text to an empty string.
      aErrorText = ""
      aCanRetry = True

      ' Does this computer have a CD writer?
      If CDWriter.GetDriveCount < 1 Then
         ' No, so set error text and bail out now...
         aErrorText = "No drive capable of writing a CD was found."
         aCanRetry = False
         Return False
      End If

      ' Retrieve the CD Writing Drive letter.
      lDriveLetter = CDWriter.GetDriveLetter(0)

      ' Attempt to open the drive.
      If Not CDWriter.OpenDrive(0) Then
         ' OpenDrive failed.
         aErrorText = String.Format("Failed to open CD Writer (Drive {0}:\)", lDriveLetter)
         aCanRetry = False
         Return False
      End If

      ' Create the volume label for the CD...
      lVolumeLabel = gDefaultCasinoID & "_AP_" & String.Format("{0:MMddyy}", Date.Now)

      ' Is there a CD in the drive?
      If CDWriter.IsMediaLoaded Then
         ' Yes, is the disc in the drive rewritable?
         lIsRewritable = CDWriter.IsDiscRewritable
      Else
         ' No CD loaded.
         aErrorText = "No media loaded, please insert a blank CD into the CD Writing drive."
         Return False
      End If

      If lIsRewritable Then
         ' CDRW disc, not allowed.
         aErrorText = "For security reasons, CDRW discs are not allowed, please insert a blank CDR disc."

      ElseIf lIsRewritable = False And CDWriter.GetDriveCapability(CDWriterXPLib.eCDRCapabilities.WritesCDR) = False Then
         ' Unable to write CDR.
         aErrorText = "This drive does not support the writing of CDRs."

      ElseIf lIsRewritable = False And CDWriter.GetDiscStatus <> CDWriterXPLib.eDiscStatus.dsEmpty Then
         ' CDR is not empty.
         aErrorText = "The CD is not blank, insert a blank CD."

      End If

      ' Are we okay to burn so far?
      lReturn = (aErrorText.Length = 0)

      If lReturn Then
         ' Get the total of all file sizes to calc number of blocks required...
         lTotalSize = 0
         For Each lFileName In Directory.GetFiles(aFolderName)
            lFI = New FileInfo(lFileName)
            lTotalSize += lFI.Length
         Next

         ' Set the total number of 2k blocks.
         lBlocksRequired = (lTotalSize \ 2048) + Math.Sign(lTotalSize Mod 2048)

         ' Get the number of free blocks.
         mFreeBlocks = CDWriter.GetDiscFreeSpaceBlocks(CDWriterXPLib.eWriteType.wtpData)

         If lBlocksRequired > mFreeBlocks Then
            ' We need to write multiple CD's so prepare new folders and copy appropriate number of files into each...
            lSingleCD = False

            ' Set the max number of btyes we can write to each CD.
            lSizeLimit = (mFreeBlocks * 2048)

            ' Initialize Disc number to 1.
            lDiscNumber = 1

            ' Set the first subfolder name and create it.
            lSubFolder = Path.Combine(aFolderName, String.Format("DISC{0:00}", lDiscNumber))
            If Directory.Exists(lSubFolder) Then Directory.Delete(lSubFolder, True)
            Directory.CreateDirectory(lSubFolder)

            ' Initialize total bytes per CD to zero.
            lTotalSize = 0

            ' Begin copying files to their CD subfolders...
            For Each lFileName In Directory.GetFiles(aFolderName)
               lFI = New FileInfo(lFileName)
               lFileSize = lFI.Length
               lTotalSize += lFileSize
               ' Does the total size exceed the size limit?
               If lTotalSize > lSizeLimit Then
                  ' No more room in the current subfolder, create a new one.
                  lDiscNumber += 1
                  lSubFolder = Path.Combine(aFolderName, String.Format("DISC{0:00}", lDiscNumber))
                  If Directory.Exists(lSubFolder) Then Directory.Delete(lSubFolder, True)
                  Directory.CreateDirectory(lSubFolder)
                  lTotalSize = lFileSize
               End If

               ' Copy, don't move files so this routine may be reentered...
               File.Copy(lFI.FullName, Path.Combine(lSubFolder, lFI.Name))
               ' File.Move(lFI.FullName, Path.Combine(lSubFolder, lFI.Name))
            Next
            lCDCount = lDiscNumber
         Else
            lCDCount = 1
         End If
      End If

      ' If no errors, setup and burn the CD...
      If lReturn Then
         For lDiscNumber = 1 To lCDCount
            With CDWriter
               ' Clear any existing ISO image.
               .ClearISOImage()

               ' Create the ISO image...
               If lSingleCD Then
                  lISOSource = aFolderName & "\*.*"
                  lISODestination = "\Data"
               Else
                  lISOSource = Path.Combine(aFolderName, String.Format("DISC{0:00}\*.*", lDiscNumber))
                  lISODestination = String.Format("\Disc{0:00}", lDiscNumber)
               End If
               .CloneDirectoryToISO(lISODestination, lISOSource)

               ' Set the CDWriter properties...
               .WriteType = CDWriterXPLib.eWriteType.wtpData
               .CloseDisc = True     ' Finalize
               .CloseSession = True
               .Joliet = True        ' Also write Joliet Directory structures in addition to ISO structures
               .UseFileDates = True

               .VolumeApplicationIdentifier = "DGE DealGen"
               .VolumeCopyrightFileIdentifier = "Copyright Diamond Game Enterprises"
               .VolumeDataPreparerIdentifier = "DGE_Tech"
               .VolumeIdentifier = lVolumeLabel
               .VolumePublisherIdentifier = "Diamond Game Enterprises"

               .TestWrite = False

               ' Set the max write speed.
               lMaxWriteSpeed = .GetMaxWriteSpeed
               If lMaxWriteSpeed > 19 Then
                  lMaxWriteSpeed = lMaxWriteSpeed - 4
               ElseIf lMaxWriteSpeed > 7 Then
                  lMaxWriteSpeed = lMaxWriteSpeed - 2
               ElseIf lMaxWriteSpeed > 3 Then
                  lMaxWriteSpeed = lMaxWriteSpeed \ 2
               End If
               Call .SetWriteSpeed(lMaxWriteSpeed)

               ' Use this setting if creating an image from network files or when
               ' creating an image with a substantial amount of small files
               ' Only valid for Data images (ISO/Joliet not Audio discs)
               .CacheDataTrack = False

               ' Use Burn Proof on this write?
               Call .SetBurnProofMode(.IsDriveBurnProofCapable())

               If lReturn Then
                  ' Initialize member variables...
                  mWriteSuccess = False
                  mWriteProcessFinished = False
                  mBlocksWritten = 0
                  mCDBurnError = ""

                  ' Write the disc...
                  If Not .WriteDisc Then
                     lReturn = False
                     mCDBurnError = "Unable to start writing to the CD drive."
                  Else
                     ' Loop until the CD writing is done...
                     Do While mWriteProcessFinished = False
                        Application.DoEvents()
                     Loop
                     ' Set the function return value
                     lReturn = mWriteSuccess
                  End If

                  ' Eject the disc.
                  .Eject()
               End If
            End With

            ' If no errors and burning multiple CD's and not done yet, prompt user for the next CDR.
            If lReturn = True And lSingleCD = False And lDiscNumber < lCDCount Then
               lUserMsg = "Please insert the next blank CDR, close the drive, and click OK."
               MessageBox.Show(lUserMsg, "Insert Disc " & (lDiscNumber + 1).ToString, MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
         Next
      End If

      ' Set the function return value.
      Return lReturn

   End Function

#End Region

#Region " Private Subroutines "

   Private Sub ArchiveLog(ByVal aMessageText As String)
      '--------------------------------------------------------------------------------
      ' Allows logging to a separate archive log file
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lArchiveLogText As String
      Dim lErrorText As String

      Try
         lArchiveLogText = String.Format("{0:yyyy-MM-dd HH:mm:ss} {1}{2}", Now, aMessageText, gNL)
         File.WriteAllText(mArchiveLogFile, lArchiveLogText)

         '' Does the file exist?
         'If File.Exists(mArchiveLogFile) Then
         '   ' Yes, so append text to it.
         '   lWriter = File.AppendText(mArchiveLogFile)
         'Else
         '   ' No, so create it.
         '   lWriter = File.CreateText(mArchiveLogFile)
         'End If

         '' Write the date/time and the message.
         'lWriter.WriteLine(Now & " " & aMessageText)

         '' Close and free the StreamWriter...
         'lWriter.Close()
         'lWriter = Nothing

      Catch ex As Exception
         ' Write the error to the application log.
         lErrorText = Me.Name & "::ArchiveLog error: " & ex.Message
         Logging.Log(lErrorText)

      End Try

   End Sub

   Private Sub SetArchiveLog()
      '--------------------------------------------------------------------------------
      ' Sets the Archive Log file name and resizes the file if it gets too big.
      ' If the file exists and is larger than 256 kb in size, the last 128 kb will be
      ' saved and preceeding data will be truncated.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFI As FileInfo

      Dim lCharPos As Integer
      Dim lFileSize As Integer

      Dim lBuffer As String
      Dim lErrorText As String

      ' Set the archive log filename.
      mArchiveLogFile = Path.Combine(gAppPath, "Archive.log")

      ' If the log file is too large (over 128kb), keep just the last 16kb...
      If File.Exists(mArchiveLogFile) Then
         ' Create a new FileInfo instance.
         lFI = New FileInfo(mArchiveLogFile)

         If Not lFI Is Nothing Then
            ' Get the filesize, use try/catch in case of an overflow or other exception...
            Try
               lFileSize = lFI.Length

               ' Is the file larger than 256kb in size?
               If lFileSize > 262144 Then
                  ' Yes, so read the entire file into a string buffer...
                  lBuffer = File.ReadAllText(mArchiveLogFile)

                  ' Delete the file.
                  lFI.Delete()

                  ' Get the right most 128kb of the string buffer.
                  ' Is there a linefeed character in the last 128k?
                  lCharPos = lBuffer.IndexOf(Chr(10), lFileSize - 131072)
                  If lCharPos > -1 Then
                     ' Yes bump new starting position just past it.
                     lCharPos += 1
                  Else
                     ' No, so set starting position to get last 16k.
                     lCharPos = lFileSize - 131072
                  End If

                  ' Truncate the unwanted portion of the buffer.
                  lBuffer = lBuffer.Substring(lCharPos)

                  ' Write the buffer to the archive log file...
                  File.WriteAllText(mArchiveLogFile, lBuffer)

               End If

            Catch ex As Exception
               ' Handle the error...
               lErrorText = Me.Name & "::SetArchiveLog error: " & ex.Message
               Logging.Log(lErrorText)
               MessageBox.Show(lErrorText, "SetArchiveLog Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

            End Try

            ' Free the file info object reference.
            lFI = Nothing
         End If
      End If

   End Sub

#End Region

#Region " Properties "

   Public Property FormCaption() As String
      '--------------------------------------------------------------------------------
      ' Sets or returns the caption text for this form.
      '--------------------------------------------------------------------------------

      Get
         ' Return the current value of this property
         Return mFormCaption
      End Get

      Set(ByVal Value As String)
         ' Set the current value of this property
         mFormCaption = Value

         ' Use the incoming value as the caption text of this form.
         Me.Text = Value
         Me.Refresh()

      End Set

   End Property

   Private WriteOnly Property StatusText() As String
      '--------------------------------------------------------------------------------
      ' Sets the message text displayed to the user
      '--------------------------------------------------------------------------------

      ' Set and display the current user message text...
      Set(ByVal Value As String)
         mStatusText = Value
         With lblStatus
            .Text = mStatusText
            .Refresh()
         End With
      End Set

   End Property

#End Region

End Class
