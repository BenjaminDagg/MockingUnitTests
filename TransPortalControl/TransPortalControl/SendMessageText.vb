Public Class SendMessageText
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
   Friend WithEvents txtBox As System.Windows.Forms.TextBox
   Friend WithEvents okBtn As System.Windows.Forms.Button
   Friend WithEvents cancelBtn As System.Windows.Forms.Button
   Friend WithEvents lblUserInfo As System.Windows.Forms.Label
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.txtBox = New System.Windows.Forms.TextBox
      Me.lblUserInfo = New System.Windows.Forms.Label
      Me.okBtn = New System.Windows.Forms.Button
      Me.cancelBtn = New System.Windows.Forms.Button
      Me.SuspendLayout()
      '
      'txtBox
      '
      Me.txtBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtBox.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.txtBox.Location = New System.Drawing.Point(8, 56)
      Me.txtBox.MaxLength = 100
      Me.txtBox.Name = "txtBox"
      Me.txtBox.Size = New System.Drawing.Size(392, 20)
      Me.txtBox.TabIndex = 0
      '
      'lblUserInfo
      '
      Me.lblUserInfo.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblUserInfo.Location = New System.Drawing.Point(16, 8)
      Me.lblUserInfo.Name = "lblUserInfo"
      Me.lblUserInfo.Size = New System.Drawing.Size(312, 32)
      Me.lblUserInfo.TabIndex = 1
      Me.lblUserInfo.Text = "Enter a message to display on the machine (100 chars. max). Use %N for a new line" & _
          "."
      '
      'okBtn
      '
      Me.okBtn.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.okBtn.DialogResult = System.Windows.Forms.DialogResult.OK
      Me.okBtn.Location = New System.Drawing.Point(119, 104)
      Me.okBtn.Name = "okBtn"
      Me.okBtn.Size = New System.Drawing.Size(75, 23)
      Me.okBtn.TabIndex = 2
      Me.okBtn.Text = "OK"
      '
      'cancelBtn
      '
      Me.cancelBtn.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.cancelBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.cancelBtn.Location = New System.Drawing.Point(223, 104)
      Me.cancelBtn.Name = "cancelBtn"
      Me.cancelBtn.Size = New System.Drawing.Size(75, 23)
      Me.cancelBtn.TabIndex = 3
      Me.cancelBtn.Text = "Cancel"
      '
      'SendMessageText
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(416, 141)
      Me.ControlBox = False
      Me.Controls.Add(Me.cancelBtn)
      Me.Controls.Add(Me.okBtn)
      Me.Controls.Add(Me.lblUserInfo)
      Me.Controls.Add(Me.txtBox)
      Me.MaximizeBox = False
      Me.MinimizeBox = False
      Me.Name = "SendMessageText"
      Me.ShowInTaskbar = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Send Machine Message"
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub

#End Region

   Private Sub txtBox_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles txtBox.KeyPress
      '--------------------------------------------------------------------------------
      ' KeyPress event handler for the message TextBox control.
      '--------------------------------------------------------------------------------

      ' Did user enter a comma character?
      If e.KeyChar = ","c Then
         ' Yes, so suppress it.
         e.Handled = True
      End If

   End Sub

End Class
