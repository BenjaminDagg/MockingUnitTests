Public Class Login

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------

      Me.DialogResult = Windows.Forms.DialogResult.Cancel
      Me.Close()

   End Sub

   Private Sub btnLogin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLogin.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Login button.
      '--------------------------------------------------------------------------------
      Dim lErrorText As String

      ' Clear error provider.
      ErrProvider.Clear()

      If txtUserID.TextLength = 0 Then
         ' No User ID was entered.
         lErrorText = "User ID cannot be blank. Enter a valid user ID and try again."
         MessageBox.Show(lErrorText, "Login Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
         ErrProvider.SetError(txtUserID, lErrorText)
         txtUserID.Focus()

      ElseIf txtPassword.TextLength = 0 Then
         ' No Password was entered.
         lErrorText = "Password cannot be blank. Enter a valid password and try again."
         MessageBox.Show(lErrorText, "Login Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
         ErrProvider.SetError(txtPassword, lErrorText)
         txtPassword.Focus()

      Else
         ' Aunthenticate user...
         Me.DialogResult = Windows.Forms.DialogResult.OK
         Me.Close()

      End If
      
   End Sub

   Private Sub Me_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Activated
      '--------------------------------------------------------------------------------
      ' Activated event handler for this Form.
      '--------------------------------------------------------------------------------

      ' Set focus to the Password TextBox control.
        If txtUserID.TextLength > 0 Then
            txtPassword.Focus()
        Else
            txtUserID.Focus()
        End If


   End Sub

   Private Sub txtUserID_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtUserID.Enter
      '--------------------------------------------------------------------------------
      ' Enter event handler for the UserID TextBox control.
      '--------------------------------------------------------------------------------

      ' Select all of the text in the User ID TextBox control.
      txtUserID.SelectAll()

   End Sub

   Public WriteOnly Property UserIDErrorText As String
      '--------------------------------------------------------------------------------
      ' Set the ErrProvider error text for the UserID TextBox control.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String)
         ErrProvider.SetError(txtUserID, value)
      End Set

   End Property

   Public WriteOnly Property PasswordErrorText As String
      '--------------------------------------------------------------------------------
      ' Set the ErrProvider error text for the Password TextBox control.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String)
         ErrProvider.SetError(txtPassword, value)
      End Set

   End Property

End Class