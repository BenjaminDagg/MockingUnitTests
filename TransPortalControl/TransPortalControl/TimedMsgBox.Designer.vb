<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class TimedMsgBox
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
      Me.components = New System.ComponentModel.Container
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(TimedMsgBox))
      Me.lblMessageText = New System.Windows.Forms.Label
      Me.btnOK = New System.Windows.Forms.Button
      Me.tmrDisplayTime = New System.Windows.Forms.Timer(Me.components)
      Me.SuspendLayout()
      '
      'lblMessageText
      '
      Me.lblMessageText.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblMessageText.Location = New System.Drawing.Point(12, 9)
      Me.lblMessageText.Name = "lblMessageText"
      Me.lblMessageText.Size = New System.Drawing.Size(562, 110)
      Me.lblMessageText.TabIndex = 0
      Me.lblMessageText.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'btnOK
      '
      Me.btnOK.Location = New System.Drawing.Point(262, 132)
      Me.btnOK.Name = "btnOK"
      Me.btnOK.Size = New System.Drawing.Size(63, 23)
      Me.btnOK.TabIndex = 1
      Me.btnOK.Text = "OK"
      Me.btnOK.UseVisualStyleBackColor = True
      '
      'tmrDisplayTime
      '
      '
      'TimedMsgBox
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(586, 167)
      Me.Controls.Add(Me.btnOK)
      Me.Controls.Add(Me.lblMessageText)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MaximizeBox = False
      Me.MinimizeBox = False
      Me.Name = "TimedMsgBox"
      Me.ShowInTaskbar = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents lblMessageText As System.Windows.Forms.Label
   Friend WithEvents btnOK As System.Windows.Forms.Button
   Friend WithEvents tmrDisplayTime As System.Windows.Forms.Timer
End Class
