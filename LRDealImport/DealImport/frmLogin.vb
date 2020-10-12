Public Class frmLogin
   Inherits System.Windows.Forms.Form

   'Events
   Public Event Login(ByVal Username As String, ByVal Password As String)

   ' Private vars.
   Private msUID As String = ""
   Private msPWD As String = ""

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
   Friend WithEvents cmdLogin As System.Windows.Forms.Button
   Friend WithEvents lblUsername As System.Windows.Forms.Label
   Friend WithEvents lblPassword As System.Windows.Forms.Label
   Friend WithEvents txtUsername As System.Windows.Forms.TextBox
   Friend WithEvents txtPassword As System.Windows.Forms.TextBox
   Friend WithEvents ErrProvider As System.Windows.Forms.ErrorProvider
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.components = New System.ComponentModel.Container
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmLogin))
      Me.cmdLogin = New System.Windows.Forms.Button
      Me.lblUsername = New System.Windows.Forms.Label
      Me.lblPassword = New System.Windows.Forms.Label
      Me.txtUsername = New System.Windows.Forms.TextBox
      Me.txtPassword = New System.Windows.Forms.TextBox
      Me.ErrProvider = New System.Windows.Forms.ErrorProvider(Me.components)
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'cmdLogin
      '
      Me.cmdLogin.CausesValidation = False
      Me.cmdLogin.Location = New System.Drawing.Point(92, 96)
      Me.cmdLogin.Name = "cmdLogin"
      Me.cmdLogin.Size = New System.Drawing.Size(48, 23)
      Me.cmdLogin.TabIndex = 2
      Me.cmdLogin.Text = "Login"
      '
      'lblUsername
      '
      Me.lblUsername.CausesValidation = False
      Me.lblUsername.Location = New System.Drawing.Point(31, 26)
      Me.lblUsername.Name = "lblUsername"
      Me.lblUsername.Size = New System.Drawing.Size(64, 20)
      Me.lblUsername.TabIndex = 4
      Me.lblUsername.Text = "User ID:"
      Me.lblUsername.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblPassword
      '
      Me.lblPassword.CausesValidation = False
      Me.lblPassword.Location = New System.Drawing.Point(31, 54)
      Me.lblPassword.Name = "lblPassword"
      Me.lblPassword.Size = New System.Drawing.Size(64, 20)
      Me.lblPassword.TabIndex = 5
      Me.lblPassword.Text = "Password:"
      Me.lblPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtUsername
      '
      Me.txtUsername.CausesValidation = False
      Me.txtUsername.Location = New System.Drawing.Point(97, 26)
      Me.txtUsername.MaxLength = 10
      Me.txtUsername.Name = "txtUsername"
      Me.txtUsername.Size = New System.Drawing.Size(100, 20)
      Me.txtUsername.TabIndex = 0
      '
      'txtPassword
      '
      Me.txtPassword.CausesValidation = False
      Me.txtPassword.Location = New System.Drawing.Point(97, 54)
      Me.txtPassword.Name = "txtPassword"
      Me.txtPassword.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
      Me.txtPassword.Size = New System.Drawing.Size(100, 20)
      Me.txtPassword.TabIndex = 1
      '
      'ErrProvider
      '
      Me.ErrProvider.ContainerControl = Me
      '
      'frmLogin
      '
      Me.AcceptButton = Me.cmdLogin
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(224, 122)
      Me.Controls.Add(Me.txtPassword)
      Me.Controls.Add(Me.txtUsername)
      Me.Controls.Add(Me.lblPassword)
      Me.Controls.Add(Me.lblUsername)
      Me.Controls.Add(Me.cmdLogin)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MaximizeBox = False
      Me.MaximumSize = New System.Drawing.Size(240, 160)
      Me.MinimizeBox = False
      Me.MinimumSize = New System.Drawing.Size(200, 120)
      Me.Name = "frmLogin"
      Me.ShowInTaskbar = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
      Me.Text = "Login"
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub

#End Region

   Private Sub LoginForm_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event for this form.
      '--------------------------------------------------------------------------------

      ' Center the login form within the owning MDI form..
      With Me.MdiParent.ClientSize
         Me.Left = (.Width - Me.Width) \ 2
         Me.Top = (.Height - Me.Height) \ 2
      End With

      ' If UID and PWD have been preloaded, assign them to the textbox controls.
      If Len(msUID) Then txtUsername.Text = msUID
      If Len(msPWD) Then txtPassword.Text = msPWD

   End Sub

   Private Sub cmdLogin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdLogin.Click
      '--------------------------------------------------------------------------------
      ' Click event for the Login Button control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lsErrText As String = ""
      Dim lsUserMsg As String = ""

      ' Check that user has entered required data...
      If txtUsername.Text.Length = 0 Then
         ' User name is missing...
         lsErrText = "A User ID entry is required."
         lsUserMsg = lsErrText
         ErrProvider.SetError(txtUsername, lsErrText)
      Else
         ' User name has text.
         ErrProvider.SetError(txtUsername, "")
      End If

      If txtPassword.Text.Length = 0 Then
         ' Password is missing...
         lsErrText = "A Password entry is required."
         If lsUserMsg.Length > 0 Then
            lsUserMsg = lsUserMsg & ControlChars.CrLf & lsErrText
         Else
            lsUserMsg = lsErrText
         End If
         ErrProvider.SetError(txtPassword, lsErrText)
      Else
         ' Password has text.
         ErrProvider.SetError(txtPassword, "")
      End If

      ' Was there an entry error?
      If Len(lsErrText) > 0 Then
         ' Yes, so tell the user.
         MessageBox.Show(lsErrText, "Login Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      Else
         ' No, so raise the login event and close this form.
         RaiseEvent Login(txtUsername.Text, txtPassword.Text)
         Me.Close()
      End If

   End Sub

   Public Property UserID() As String
      '--------------------------------------------------------------------------------
      ' UserID property.
      '--------------------------------------------------------------------------------

      Get
         UserID = msUID
      End Get
      Set(ByVal Value As String)
         msUID = Value
      End Set

   End Property

   Public Property Password() As String
      '--------------------------------------------------------------------------------
      ' Password Property
      '--------------------------------------------------------------------------------

      Get
         Password = msPWD
      End Get
      Set(ByVal Value As String)
         msPWD = Value
      End Set

   End Property

   Private Sub txtUsername_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtUsername.Enter
      '--------------------------------------------------------------------------------
      ' Enter event for txtUsername textbox control.
      ' Select all text in the control.
      '--------------------------------------------------------------------------------

      ' Select all text in control on entry.
      txtUsername.SelectAll()

   End Sub


   Private Sub txtPassword_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtPassword.Enter
      '--------------------------------------------------------------------------------
      ' Enter event for txtPassword textbox control.
      ' Select all text in the control.
      '--------------------------------------------------------------------------------

      ' Select all text in control on entry.
      txtPassword.SelectAll()

   End Sub

   Private Sub LoginForm_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles MyBase.Paint
      '--------------------------------------------------------------------------------
      ' Paint event for this form.
      '--------------------------------------------------------------------------------
      Static lbHandled As Boolean

      ' On first paint event, set focus to the password textbox if username is populated.
      If Not lbHandled Then
         If Len(txtUsername.Text) > 0 Then txtPassword.Focus()
         lbHandled = True
      End If

   End Sub

End Class
