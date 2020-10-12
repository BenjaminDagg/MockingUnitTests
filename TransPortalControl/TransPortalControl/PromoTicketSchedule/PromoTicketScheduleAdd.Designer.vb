<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PromoTicketScheduleAdd
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
      Me.components = New System.ComponentModel.Container()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(PromoTicketScheduleAdd))
      Me.btnCancel = New System.Windows.Forms.Button()
      Me.btnSave = New System.Windows.Forms.Button()
      Me.lblStartTime = New System.Windows.Forms.Label()
      Me.dtpStartingTime = New System.Windows.Forms.DateTimePicker()
      Me.lblEndTime = New System.Windows.Forms.Label()
      Me.dtpEndingTime = New System.Windows.Forms.DateTimePicker()
      Me.ErrProvider = New System.Windows.Forms.ErrorProvider(Me.components)
      Me.lblScheduleComments = New System.Windows.Forms.Label()
      Me.txtComments = New System.Windows.Forms.TextBox()
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'btnCancel
      '
      Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Location = New System.Drawing.Point(303, 168)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(75, 23)
      Me.btnCancel.TabIndex = 7
      Me.btnCancel.Text = "Cancel"
      Me.btnCancel.UseVisualStyleBackColor = True
      '
      'btnSave
      '
      Me.btnSave.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnSave.CausesValidation = False
      Me.btnSave.Location = New System.Drawing.Point(190, 168)
      Me.btnSave.Name = "btnSave"
      Me.btnSave.Size = New System.Drawing.Size(75, 23)
      Me.btnSave.TabIndex = 6
      Me.btnSave.Text = "Save"
      Me.btnSave.UseVisualStyleBackColor = True
      '
      'lblStartTime
      '
      Me.lblStartTime.CausesValidation = False
      Me.lblStartTime.Location = New System.Drawing.Point(155, 64)
      Me.lblStartTime.Name = "lblStartTime"
      Me.lblStartTime.Size = New System.Drawing.Size(124, 23)
      Me.lblStartTime.TabIndex = 2
      Me.lblStartTime.Text = "Starting Date and Time:"
      Me.lblStartTime.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      Me.lblStartTime.UseMnemonic = False
      '
      'dtpStartingTime
      '
      Me.dtpStartingTime.CausesValidation = False
      Me.dtpStartingTime.CustomFormat = "MM/dd/yyyy HH:mm:ss"
      Me.dtpStartingTime.Format = System.Windows.Forms.DateTimePickerFormat.Custom
      Me.dtpStartingTime.Location = New System.Drawing.Point(279, 65)
      Me.dtpStartingTime.Name = "dtpStartingTime"
      Me.dtpStartingTime.Size = New System.Drawing.Size(134, 20)
      Me.dtpStartingTime.TabIndex = 3
      Me.dtpStartingTime.Value = New Date(2008, 1, 1, 14, 8, 0, 0)
      '
      'lblEndTime
      '
      Me.lblEndTime.CausesValidation = False
      Me.lblEndTime.Location = New System.Drawing.Point(155, 99)
      Me.lblEndTime.Name = "lblEndTime"
      Me.lblEndTime.Size = New System.Drawing.Size(124, 23)
      Me.lblEndTime.TabIndex = 4
      Me.lblEndTime.Text = "Ending Date and Time:"
      Me.lblEndTime.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      Me.lblEndTime.UseMnemonic = False
      '
      'dtpEndingTime
      '
      Me.dtpEndingTime.CausesValidation = False
      Me.dtpEndingTime.CustomFormat = "MM/dd/yyyy HH:mm:ss"
      Me.dtpEndingTime.Format = System.Windows.Forms.DateTimePickerFormat.Custom
      Me.dtpEndingTime.Location = New System.Drawing.Point(279, 100)
      Me.dtpEndingTime.Name = "dtpEndingTime"
      Me.dtpEndingTime.Size = New System.Drawing.Size(134, 20)
      Me.dtpEndingTime.TabIndex = 5
      Me.dtpEndingTime.Value = New Date(2008, 1, 1, 14, 8, 0, 0)
      '
      'ErrProvider
      '
      Me.ErrProvider.ContainerControl = Me
      '
      'lblScheduleComments
      '
      Me.lblScheduleComments.CausesValidation = False
      Me.lblScheduleComments.Location = New System.Drawing.Point(64, 27)
      Me.lblScheduleComments.Name = "lblScheduleComments"
      Me.lblScheduleComments.Size = New System.Drawing.Size(69, 23)
      Me.lblScheduleComments.TabIndex = 0
      Me.lblScheduleComments.Text = "Description:"
      Me.lblScheduleComments.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      Me.lblScheduleComments.UseMnemonic = False
      '
      'txtComments
      '
      Me.txtComments.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtComments.Location = New System.Drawing.Point(133, 29)
      Me.txtComments.MaxLength = 128
      Me.txtComments.Name = "txtComments"
      Me.txtComments.Size = New System.Drawing.Size(371, 20)
      Me.txtComments.TabIndex = 1
      '
      'PromoTicketScheduleAdd
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(569, 203)
      Me.Controls.Add(Me.txtComments)
      Me.Controls.Add(Me.lblScheduleComments)
      Me.Controls.Add(Me.dtpEndingTime)
      Me.Controls.Add(Me.lblEndTime)
      Me.Controls.Add(Me.dtpStartingTime)
      Me.Controls.Add(Me.lblStartTime)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnSave)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "PromoTicketScheduleAdd"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Add New Promo Entry Ticket Schedule"
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnSave As System.Windows.Forms.Button
   Friend WithEvents lblStartTime As System.Windows.Forms.Label
   Friend WithEvents dtpStartingTime As System.Windows.Forms.DateTimePicker
   Friend WithEvents lblEndTime As System.Windows.Forms.Label
   Friend WithEvents dtpEndingTime As System.Windows.Forms.DateTimePicker
   Friend WithEvents ErrProvider As System.Windows.Forms.ErrorProvider
   Friend WithEvents txtComments As System.Windows.Forms.TextBox
   Friend WithEvents lblScheduleComments As System.Windows.Forms.Label
End Class
