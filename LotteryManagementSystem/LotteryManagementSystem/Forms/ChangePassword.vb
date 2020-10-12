Imports System.Text.RegularExpressions
Imports System.Text
Imports System.Security.Cryptography
Imports LotteryManagementSystem.My.Resources

Public Class ChangePassword

    ' [Class member variables]
    Private mAppUserID As Integer

    Private mForcedChange As Boolean
    Private mPasswordReset As Boolean

    Private mUserID As String

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        '--------------------------------------------------------------------------------
        ' Click event for the Close button.
        '--------------------------------------------------------------------------------

        Me.Close()

    End Sub

    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Save button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lAPE As New AppPasswordEncryption

        Dim lErrorText As String = ""
        Dim lEventDescription = ""
        Dim lHashedPassword As String = ""
        Dim lPassword As String = txtPassword.Text

        ' Compare passwords and attempt to save.
        If ComparePasswords() Then

            ' Is password policy on?
            If gEnforcePasswordPolicy Then

                ' Yes, so check the password strength.
                If CheckPasswordStrength(lPassword) Then

                    ' Attempt to hash the password.
                    lHashedPassword = lAPE.GetMd5Hash(lPassword)

                    ' Successfully hashed the password.
                    If String.IsNullOrEmpty(lHashedPassword) = False Then

                        ' Update the password.
                        If UpdatePassword(lHashedPassword) Then

                            ' Successfully updated password.
                            If mPasswordReset Then
                                lEventDescription = String.Format("Password Reset: User ID {0}.", mUserID)
                            Else
                                lEventDescription = String.Format("Password Modified: User ID {0}.", mUserID)
                            End If

                            ' Log the event.
                            If LogEvents(lEventDescription, gAppLoginID, ErrorTypeId.SuccessfulPasswordChange) Then
                                MessageBox.Show("Successfully updated password.", "Password Update Status", MessageBoxButtons.OK, MessageBoxIcon.Information)

                                ' Close the form.
                                mForcedChange = False
                                Me.Close()

                            End If
                        End If
                    End If
                End If

            Else
                ' Attempt to hash the password.
                lHashedPassword = lAPE.GetMd5Hash(lPassword)

                ' Successfully hashed the password.
                If String.IsNullOrEmpty(lHashedPassword) = False Then

                    ' No, update the password.
                    If UpdatePassword(lPassword) Then

                        ' Successfully updated password.
                        If mPasswordReset Then
                            lEventDescription = String.Format("Password Reset: User ID {0}.", mUserID)
                        Else
                            lEventDescription = String.Format("Password Modified: User ID {0}.", mUserID)
                        End If

                        ' Log the event.
                        If LogEvents(lEventDescription, gAppLoginID, ErrorTypeId.SuccessfulPasswordChange) Then
                            MessageBox.Show("Successfully updated password.", "Password Update Status", MessageBoxButtons.OK, MessageBoxIcon.Information)

                            ' Close the form.
                            mForcedChange = False
                            Me.Close()

                        End If
                    End If
                End If
            End If
        End If

    End Sub

    Private Sub ChangePassword_FormClosing(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles MyBase.FormClosing
        '--------------------------------------------------------------------------------
        ' Handle the FormClosing event.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...

        If CloseForm() = False Then
            e.Cancel = True
        End If

    End Sub

    Private Sub ChangePassword_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        '--------------------------------------------------------------------------------
        ' Handle the Load event.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...

        ' Set the UserText box control.
        txtUserID.Text = mUserID

    End Sub

    Private Function CheckPasswordStrength(ByVal aPassword As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Check password strength.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As Boolean = False

        Dim lErrorText As String = ""
        Dim lUserMsg As String = ""

        Try
            ' Check password against RegEx reqs.
            If Regex.IsMatch(aPassword, gPasswordPolicy) Then
                ' Meets minimum reqs.
                lReturn = True

            Else
                ' Does not meet minimum reqs.
                lUserMsg = gPasswordPolicyMessage.Replace("#;#", Environment.NewLine)
                MessageBox.Show(lUserMsg, "Password Strength Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                txtPassword.Clear()
                txtConfirmPassword.Clear()
                txtPassword.Focus()

            End If

        Catch ex As Exception
            ' Handle the exception. Build the error text.
            lErrorText = Me.Name & "::EnforcePasswordPolicy error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Password Change Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

        ' Set the Function return value.
        Return lReturn

    End Function

    Private Function CloseForm() As Boolean
        '--------------------------------------------------------------------------------
        ' Application will terminate if the password change was forced and not updated.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDialogResult As DialogResult
        Dim lReturn As Boolean = False
        Dim lErrorText As String

        ' Was the password reset forced?
        If mForcedChange Then
            ' Yes, show messagebox and do not allow access until user updates the password.
            lErrorText = "Password has expired and must be updated. Would you like to update password now?"
            lDialogResult = MessageBox.Show(lErrorText, "Password Status", MessageBoxButtons.YesNo, MessageBoxIcon.Warning)

            If lDialogResult = Windows.Forms.DialogResult.No Then
                MessageBox.Show("Application terminating now.", "Password Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Environment.Exit(-1)

            End If
        Else

            ' No, allow user to close the dialog.
            lReturn = True

        End If

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function ComparePasswords() As Boolean
        '--------------------------------------------------------------------------------
        ' Validate User Passwords
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As Boolean = True
        Dim lComparePasswords As Boolean = True

        Dim lErrorMessage As String = ""
        Dim lErrorText As String
        Dim lPassword As String

        ' Set lErrorText
        lErrorText = ""
        lPassword = txtPassword.Text

        ' Check Password Textbox
        If txtPassword.TextLength = 0 Then
            lComparePasswords = False
            lErrorText = "Password Required."
            lErrorMessage &= lErrorText & gCrLf
            ErrProvider.SetError(txtPassword, lErrorText)
        Else
            If lPassword.ToUpper.Contains("PASSWORD") Then
                lComparePasswords = False
                lErrorText = "Password cannot be set to 'Password'."
                lErrorMessage &= lErrorText & gCrLf

                ErrProvider.SetError(txtPassword, lErrorText)
            End If
        End If

        ' Check Confirm Password Textbox
        lErrorText = ""

        If txtConfirmPassword.TextLength = 0 Then
            lComparePasswords = False
            lErrorText = "Confirm Password Required."
            lErrorMessage &= lErrorText & gCrLf
            ErrProvider.SetError(txtConfirmPassword, lErrorText)
        End If

        ' Verify passwords match
        lErrorText = ""

        If lComparePasswords = True Then
            If txtPassword.Text <> txtConfirmPassword.Text Then
                lErrorText = "Passwords do not match."
                lErrorMessage &= lErrorText & gCrLf
            End If

            ErrProvider.SetError(txtPassword, lErrorText)
            ErrProvider.SetError(txtConfirmPassword, lErrorText)
        End If

        If lErrorMessage.Length > 0 Then
            lReturn = False
            ' Show user the error message.
            MessageBox.Show(lErrorMessage, "Compare Passwords Data Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

        ' Set the funtion Return value
        Return lReturn

    End Function

    Private Function UpdatePassword(ByVal aPassword As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Update the user password.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing

        Dim lReturn As Boolean = False

        Dim lSpReturnCode As Integer

        Dim lErrorText As String = ""

        Try

            If gAppUserID <> mAppUserID Then
                mPasswordReset = True
            End If

            ' Instantiate a new SqlDataAccess object.
            lSDA = New SqlDataAccess(gConnectionString, False)

            With lSDA
                ' Add Parameters for the UpdateAppUserPassword stored proc...
                .AddParameter("@AppUserID", SqlDbType.Int, mAppUserID)
                .AddParameter("@Password", SqlDbType.VarChar, aPassword, 64)
                .AddParameter("@PasswordReset", SqlDbType.Bit, mPasswordReset)

                Dim sql As String = SqlQueries.AppUpdatePassword

                ' Execute the stored proc (the return code will be zero if no error)...
                lSpReturnCode = .ExecuteSQLScalar(sql, True)
                

                Select Case lSpReturnCode

                    Case Is = 0
                        ' Yes, so log it in the database
                        lReturn = True

                    Case -1
                        ' Passwords is current password.
                        lErrorText = "Password cannot be the same as your current password."
                        txtPassword.Clear()
                        txtConfirmPassword.Clear()
                        txtPassword.Focus()

                    Case -2
                        ' Passwords was one of the previously used passwords.
                        lErrorText = String.Format("Password cannot be the same as your previous {0} passwords.", gPasswordHistory)
                        txtPassword.Clear()
                        txtConfirmPassword.Clear()
                        txtPassword.Focus()
                End Select

            End With

        Catch ex As Exception
            ' Handle the error...
            lErrorText = Me.Name & "::UpdateAppUserPassword error: " & ex.Message
            If Not ex.InnerException Is Nothing Then
                lErrorText &= gCrLf & ex.InnerException.Message
            End If
            Logging.Log(lErrorText)

        Finally
            ' Cleanup...
            If Not lSDA Is Nothing Then
                lSDA.Dispose()
                lSDA = Nothing
            End If

        End Try

        ' Show success or failure message...
        If lErrorText.Length > 0 Then
            ' Show and log the error message.
            MessageBox.Show(lErrorText, "Update User Password Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Logging.Log(lErrorText)
        End If

        ' Set the funtion Return value
        Return lReturn

    End Function

    Public WriteOnly Property AppUserID As Integer
        '--------------------------------------------------------------------------------
        ' Sets the AppUserID property value.
        '--------------------------------------------------------------------------------

        Set(ByVal value As Integer)
            mAppUserID = value
            lblAppUserIDValue.Text = value.ToString
        End Set

    End Property

    Public WriteOnly Property UserID As String
        '--------------------------------------------------------------------------------
        ' Sets the UserID property value.
        '--------------------------------------------------------------------------------

        Set(ByVal value As String)
            mUserID = value
            txtUserID.Text = value
        End Set

    End Property

    Public WriteOnly Property ForcedChange As Boolean
        '--------------------------------------------------------------------------------
        ' Sets the ForcedChange property value.
        '--------------------------------------------------------------------------------

        Set(ByVal value As Boolean)
            mForcedChange = value
        End Set

    End Property



End Class