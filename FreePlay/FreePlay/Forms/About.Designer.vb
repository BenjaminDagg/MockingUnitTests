<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class About
   Inherits DGE.DgeSmartForm

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
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(About))
      Me.btnOK = New System.Windows.Forms.Button()
      Me.lblDatabase = New System.Windows.Forms.Label()
      Me.lblVersion = New System.Windows.Forms.Label()
      Me.lblProductName = New System.Windows.Forms.Label()
      Me.SuspendLayout()
      '
      'btnOK
      '
      Me.btnOK.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnOK.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnOK.Image = CType(resources.GetObject("btnOK.Image"), System.Drawing.Image)
      Me.btnOK.Location = New System.Drawing.Point(175, 167)
      Me.btnOK.Name = "btnOK"
      Me.btnOK.Size = New System.Drawing.Size(75, 23)
      Me.btnOK.TabIndex = 0
      Me.btnOK.Text = "&OK"
      Me.btnOK.UseVisualStyleBackColor = True
      '
      'lblDatabase
      '
      Me.lblDatabase.BackColor = System.Drawing.SystemColors.ControlLightLight
      Me.lblDatabase.CausesValidation = False
      Me.lblDatabase.Location = New System.Drawing.Point(12, 102)
      Me.lblDatabase.Name = "lblDatabase"
      Me.lblDatabase.Size = New System.Drawing.Size(162, 20)
      Me.lblDatabase.TabIndex = 3
      Me.lblDatabase.Text = "Database"
      '
      'lblVersion
      '
      Me.lblVersion.BackColor = System.Drawing.SystemColors.ControlLightLight
      Me.lblVersion.CausesValidation = False
      Me.lblVersion.Location = New System.Drawing.Point(12, 82)
      Me.lblVersion.Name = "lblVersion"
      Me.lblVersion.Size = New System.Drawing.Size(192, 20)
      Me.lblVersion.TabIndex = 2
      Me.lblVersion.Text = "Version"
      '
      'lblProductName
      '
      Me.lblProductName.BackColor = System.Drawing.SystemColors.ControlLightLight
      Me.lblProductName.CausesValidation = False
      Me.lblProductName.Location = New System.Drawing.Point(12, 62)
      Me.lblProductName.Name = "lblProductName"
      Me.lblProductName.Size = New System.Drawing.Size(250, 20)
      Me.lblProductName.TabIndex = 1
      Me.lblProductName.Text = "ProductName"
      '
      'About
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.BackgroundImage = CType(resources.GetObject("$this.BackgroundImage"), System.Drawing.Image)
      Me.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch
      Me.ClientSize = New System.Drawing.Size(409, 212)
      Me.Controls.Add(Me.btnOK)
      Me.Controls.Add(Me.lblDatabase)
      Me.Controls.Add(Me.lblVersion)
      Me.Controls.Add(Me.lblProductName)
      Me.MaximizeBox = False
      Me.MinimizeBox = False
      Me.Name = "About"
      Me.Padding = New System.Windows.Forms.Padding(9)
      Me.ShowIcon = False
      Me.ShowInTaskbar = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "About"
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents btnOK As System.Windows.Forms.Button
   Friend WithEvents lblDatabase As System.Windows.Forms.Label
   Friend WithEvents lblVersion As System.Windows.Forms.Label
   Friend WithEvents lblProductName As System.Windows.Forms.Label
End Class
