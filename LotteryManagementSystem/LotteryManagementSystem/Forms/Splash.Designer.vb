<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Splash
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
      Me.lblAppVersion = New System.Windows.Forms.Label()
      Me.SuspendLayout()
      '
      'lblAppVersion
      '
      Me.lblAppVersion.BackColor = System.Drawing.Color.Transparent
      Me.lblAppVersion.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblAppVersion.ForeColor = System.Drawing.SystemColors.ControlDarkDark
      Me.lblAppVersion.Location = New System.Drawing.Point(213, 55)
      Me.lblAppVersion.Name = "lblAppVersion"
      Me.lblAppVersion.Size = New System.Drawing.Size(158, 24)
      Me.lblAppVersion.TabIndex = 0
      Me.lblAppVersion.Text = "Version"
      '
      'Splash
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.BackgroundImage = Global.LotteryManagementSystem.My.Resources.Resources.DG_SplashScreen
      Me.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch
      Me.ClientSize = New System.Drawing.Size(498, 268)
      Me.ControlBox = False
      Me.Controls.Add(Me.lblAppVersion)
      Me.DoubleBuffered = True
      Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
      Me.MaximizeBox = False
      Me.MinimizeBox = False
      Me.Name = "Splash"
      Me.ShowInTaskbar = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents lblAppVersion As System.Windows.Forms.Label

End Class
