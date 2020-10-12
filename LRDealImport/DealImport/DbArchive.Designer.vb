<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class DbArchive
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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(DbArchive))
      Me.grpUI = New System.Windows.Forms.GroupBox
      Me.cbFinalBackup = New System.Windows.Forms.CheckBox
      Me.lblShrinkDatabase = New System.Windows.Forms.Label
      Me.pbPointer = New System.Windows.Forms.PictureBox
      Me.cbPurgeData = New System.Windows.Forms.CheckBox
      Me.cbDbBackup = New System.Windows.Forms.CheckBox
      Me.cbRetrieveAI = New System.Windows.Forms.CheckBox
      Me.lblRetrieveAI = New System.Windows.Forms.Label
      Me.lblPurgeData = New System.Windows.Forms.Label
      Me.lblDbBackup = New System.Windows.Forms.Label
      Me.lblStepsDesc = New System.Windows.Forms.Label
      Me.btnCancel = New System.Windows.Forms.Button
      Me.btnStart = New System.Windows.Forms.Button
      Me.prgProgress = New System.Windows.Forms.ProgressBar
      Me.lblStatus = New System.Windows.Forms.Label
      Me.grpUI.SuspendLayout()
      CType(Me.pbPointer, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'grpUI
      '
      Me.grpUI.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.grpUI.Controls.Add(Me.cbFinalBackup)
      Me.grpUI.Controls.Add(Me.lblShrinkDatabase)
      Me.grpUI.Controls.Add(Me.pbPointer)
      Me.grpUI.Controls.Add(Me.cbPurgeData)
      Me.grpUI.Controls.Add(Me.cbDbBackup)
      Me.grpUI.Controls.Add(Me.cbRetrieveAI)
      Me.grpUI.Controls.Add(Me.lblRetrieveAI)
      Me.grpUI.Controls.Add(Me.lblPurgeData)
      Me.grpUI.Controls.Add(Me.lblDbBackup)
      Me.grpUI.Controls.Add(Me.lblStepsDesc)
      Me.grpUI.Location = New System.Drawing.Point(9, 16)
      Me.grpUI.Name = "grpUI"
      Me.grpUI.Size = New System.Drawing.Size(583, 200)
      Me.grpUI.TabIndex = 18
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
      Me.cbFinalBackup.Location = New System.Drawing.Point(328, 126)
      Me.cbFinalBackup.Name = "cbFinalBackup"
      Me.cbFinalBackup.Size = New System.Drawing.Size(136, 16)
      Me.cbFinalBackup.TabIndex = 30
      Me.cbFinalBackup.Text = "Completed"
      Me.cbFinalBackup.Visible = False
      '
      'lblShrinkDatabase
      '
      Me.lblShrinkDatabase.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblShrinkDatabase.Location = New System.Drawing.Point(96, 126)
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
      'cbPurgeData
      '
      Me.cbPurgeData.AutoCheck = False
      Me.cbPurgeData.CausesValidation = False
      Me.cbPurgeData.Checked = True
      Me.cbPurgeData.CheckState = System.Windows.Forms.CheckState.Checked
      Me.cbPurgeData.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.cbPurgeData.ForeColor = System.Drawing.Color.Green
      Me.cbPurgeData.Location = New System.Drawing.Point(328, 104)
      Me.cbPurgeData.Name = "cbPurgeData"
      Me.cbPurgeData.Size = New System.Drawing.Size(136, 16)
      Me.cbPurgeData.TabIndex = 26
      Me.cbPurgeData.Text = "Completed"
      Me.cbPurgeData.Visible = False
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
      Me.lblPurgeData.Location = New System.Drawing.Point(96, 104)
      Me.lblPurgeData.Name = "lblPurgeData"
      Me.lblPurgeData.Size = New System.Drawing.Size(216, 16)
      Me.lblPurgeData.TabIndex = 20
      Me.lblPurgeData.Text = "- Purge old data"
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
      'btnCancel
      '
      Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.Location = New System.Drawing.Point(322, 239)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(49, 23)
      Me.btnCancel.TabIndex = 22
      Me.btnCancel.Text = "Cancel"
      '
      'btnStart
      '
      Me.btnStart.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnStart.CausesValidation = False
      Me.btnStart.Location = New System.Drawing.Point(238, 239)
      Me.btnStart.Name = "btnStart"
      Me.btnStart.Size = New System.Drawing.Size(49, 23)
      Me.btnStart.TabIndex = 21
      Me.btnStart.Text = "Start"
      '
      'prgProgress
      '
      Me.prgProgress.Dock = System.Windows.Forms.DockStyle.Bottom
      Me.prgProgress.Location = New System.Drawing.Point(0, 262)
      Me.prgProgress.Name = "prgProgress"
      Me.prgProgress.Size = New System.Drawing.Size(600, 18)
      Me.prgProgress.TabIndex = 20
      Me.prgProgress.Visible = False
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
      Me.lblStatus.TabIndex = 19
      Me.lblStatus.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      Me.lblStatus.UseMnemonic = False
      '
      'DbArchive
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(600, 280)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnStart)
      Me.Controls.Add(Me.prgProgress)
      Me.Controls.Add(Me.lblStatus)
      Me.Controls.Add(Me.grpUI)
      Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "DbArchive"
      Me.ShowInTaskbar = False
      Me.Text = "Archive and Purge"
      Me.grpUI.ResumeLayout(False)
      CType(Me.pbPointer, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents grpUI As System.Windows.Forms.GroupBox
   Friend WithEvents cbFinalBackup As System.Windows.Forms.CheckBox
   Friend WithEvents lblShrinkDatabase As System.Windows.Forms.Label
   Friend WithEvents pbPointer As System.Windows.Forms.PictureBox
   Friend WithEvents cbPurgeData As System.Windows.Forms.CheckBox
   Friend WithEvents cbDbBackup As System.Windows.Forms.CheckBox
   Friend WithEvents cbRetrieveAI As System.Windows.Forms.CheckBox
   Friend WithEvents lblRetrieveAI As System.Windows.Forms.Label
   Friend WithEvents lblPurgeData As System.Windows.Forms.Label
   Friend WithEvents lblDbBackup As System.Windows.Forms.Label
   Friend WithEvents lblStepsDesc As System.Windows.Forms.Label
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnStart As System.Windows.Forms.Button
   Friend WithEvents prgProgress As System.Windows.Forms.ProgressBar
   Friend WithEvents lblStatus As System.Windows.Forms.Label
End Class
