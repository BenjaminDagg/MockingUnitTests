<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class About
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
      Me.OKButton = New System.Windows.Forms.Button()
      Me.lblProductName = New System.Windows.Forms.Label()
      Me.lblVersion = New System.Windows.Forms.Label()
      Me.lblDatabase = New System.Windows.Forms.Label()
      Me.lblLoginID = New System.Windows.Forms.Label()
      Me.SuspendLayout()
      '
      'OKButton
      '
      Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.OKButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.OKButton.Location = New System.Drawing.Point(175, 188)
      Me.OKButton.Name = "OKButton"
      Me.OKButton.Size = New System.Drawing.Size(75, 23)
      Me.OKButton.TabIndex = 0
      Me.OKButton.Text = "&OK"
      '
      'lblProductName
      '
      Me.lblProductName.BackColor = System.Drawing.SystemColors.ControlLightLight
      Me.lblProductName.CausesValidation = False
      Me.lblProductName.Location = New System.Drawing.Point(12, 83)
      Me.lblProductName.Name = "lblProductName"
      Me.lblProductName.Size = New System.Drawing.Size(250, 20)
      Me.lblProductName.TabIndex = 1
      Me.lblProductName.Text = "ProductName"
      '
      'lblVersion
      '
      Me.lblVersion.BackColor = System.Drawing.SystemColors.ControlLightLight
      Me.lblVersion.CausesValidation = False
      Me.lblVersion.Location = New System.Drawing.Point(12, 103)
      Me.lblVersion.Name = "lblVersion"
      Me.lblVersion.Size = New System.Drawing.Size(192, 20)
      Me.lblVersion.TabIndex = 2
      Me.lblVersion.Text = "Version"
      '
      'lblDatabase
      '
      Me.lblDatabase.BackColor = System.Drawing.SystemColors.ControlLightLight
      Me.lblDatabase.CausesValidation = False
      Me.lblDatabase.Location = New System.Drawing.Point(12, 123)
      Me.lblDatabase.Name = "lblDatabase"
      Me.lblDatabase.Size = New System.Drawing.Size(192, 20)
      Me.lblDatabase.TabIndex = 3
      Me.lblDatabase.Text = "Database"
      '
      'lblLoginID
      '
      Me.lblLoginID.BackColor = System.Drawing.Color.Transparent
      Me.lblLoginID.CausesValidation = False
      Me.lblLoginID.Location = New System.Drawing.Point(12, 143)
      Me.lblLoginID.Name = "lblLoginID"
      Me.lblLoginID.Size = New System.Drawing.Size(192, 20)
      Me.lblLoginID.TabIndex = 4
      Me.lblLoginID.Text = "LoginID"
      '
      'About
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.BackColor = System.Drawing.Color.White
      Me.BackgroundImage = Global.LotteryManagementSystem.My.Resources.Resources.DG_logos_Horiz_400px
      Me.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None
      Me.CancelButton = Me.OKButton
      Me.ClientSize = New System.Drawing.Size(419, 223)
      Me.Controls.Add(Me.lblLoginID)
      Me.Controls.Add(Me.lblDatabase)
      Me.Controls.Add(Me.lblVersion)
      Me.Controls.Add(Me.lblProductName)
      Me.Controls.Add(Me.OKButton)
      Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
      Me.MaximizeBox = False
      Me.MaximumSize = New System.Drawing.Size(425, 251)
      Me.MinimizeBox = False
      Me.MinimumSize = New System.Drawing.Size(425, 251)
      Me.Name = "About"
      Me.Padding = New System.Windows.Forms.Padding(9)
      Me.ShowIcon = False
      Me.ShowInTaskbar = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "About"
      Me.ResumeLayout(False)

   End Sub
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents lblProductName As System.Windows.Forms.Label
   Friend WithEvents lblVersion As System.Windows.Forms.Label
   Friend WithEvents lblDatabase As System.Windows.Forms.Label
   Friend WithEvents lblLoginID As System.Windows.Forms.Label

End Class
