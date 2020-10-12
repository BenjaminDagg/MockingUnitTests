Imports System.Text.RegularExpressions
Imports LotteryManagementSystem.My.Resources

Public Class AppUserAddEdit

    ' [Class member variables]
    Private mIsActive As Boolean
    Private mLockedOut As Boolean

    Private mEditMode As Short            ' 0 = Add, 1 = Edit

    Private mAppUserID As Integer

    Private mUserID As String
    Private mFirstName As String
    Private mLastName As String

    Private mOpeningForm As AppUserView

    Private Const ADDMODE = 0
    Private Const EDITMODE = 1

    Private Sub AddUser()
        '--------------------------------------------------------------------------------
        ' Saves the current record.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lAPE As New AppPasswordEncryption

        Dim lSDA As SqlDataAccess = Nothing

        Dim lSpReturnCode As Integer

        Dim lErrorText As String = ""
        Dim lFullName As String = txtFirstName.Text
        Dim lPassword As String = txtPassword.Text
        Dim lHashedPassword As String = ""

        Try
            mUserID = txtUserID.Text

            If txtUserID.TextLength < 3 Or txtUserID.TextLength > 10 Then

                ' Save failed. Inform the user.
                lErrorText = String.Format("UserID {0} must be between 3 and 10 characters.", mUserID)

                ' Log the event in the EventLog table in database.
                LogEvents(lErrorText, gAppLoginID, ErrorTypeId.CreateUserFailed)

         ElseIf Not IsAlphaNumeric(mUserID) = True Then
            lErrorText = String.Format("User ID {0} must not have invalid characters.", mUserID)
            Else


                ' Attempt to hash the password.
                lHashedPassword = lAPE.GetMd5Hash(lPassword)

                ' Successfully hashed the password.
                If String.IsNullOrEmpty(lHashedPassword) = False Then
                    ' Instantiate a new SqlDataAccess object.
                    lSDA = New SqlDataAccess(gConnectionString, False)

                    With lSDA

                        Dim sql As String = SqlQueries.AddUser

                        ' Add Parameters for AddAppUser stored proc...
                        .AddParameter("@UserName", SqlDbType.VarChar, mUserID, 16)
                        .AddParameter("@FirstName", SqlDbType.VarChar, lFullName, 64)
                        .AddParameter("@LastName", SqlDbType.VarChar, lFullName, 64)
                        .AddParameter("@Password", SqlDbType.VarChar, lHashedPassword, 64)

                        ' Execute the stored proc (the return code will be zero if no error)...
                        Dim returnValue As Integer = .ExecuteSQLScalar(sql, True)

                        lSpReturnCode = returnValue

                        ' Attempt to save and retrieve new AppUserID...
                        If lSpReturnCode = 0 Then
                            ' Save failed. Inform the user.
                            lErrorText = String.Format("Failed to add User ID {0}.", mUserID)

                            ' Log the event in the EventLog table in database.
                            LogEvents(lErrorText, gAppLoginID, ErrorTypeId.EditUserFailed)

                        ElseIf lSpReturnCode = -1 Then
                            ' Check if the UserID already exists...
                            lErrorText = String.Format("User ID {0} already exists.", mUserID)

                            ' Set focus and highlight User ID.
                            txtUserID.Focus()
                            txtUserID.SelectAll()

                            ' Log the event in the EventLog table in database.
                            LogEvents(lErrorText, gAppLoginID, ErrorTypeId.CreateUserFailed)

                        Else
                            ' Saved successfully. Set mAppuser with new AppUserID.
                            mAppUserID = lSpReturnCode

                            'Set the lable control with the new AppUserID
                            lblAppUserIDValue.Text = mAppUserID.ToString

                            ' Set AppUserAddEdit form to EditMode
                            mEditMode = EDITMODE
                            Me.Text = "Modify Existing User"

                            ' Set control to read only.
                            txtUserID.ReadOnly = True

                            ' Show panel with groups.
                            PnlGroup.Show()

                            ' Log the event in the EventLog table in database.
                            LogEvents(String.Format("Successfully added User ID {0}", mUserID), gAppLoginID, ErrorTypeId.CreateUserSuccess)
                        End If

                    End With
                End If



            End If




        Catch ex As Exception
            ' Handle the error...
            lErrorText = Me.Name & "::AddUser error: " & ex.Message
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
            ' Show user the error message.
            MessageBox.Show(lErrorText, "Add User Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            ' Show user that new user was added.
            MessageBox.Show("Succesfully Added New User", "Add User Save Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If

    End Sub

   Private Function IsAlphaNumeric(ByVal Str As String) As Boolean

      Dim ContainsAlpha As Boolean
      Dim ContainsNumeric As Boolean
      Dim ContainsValidCharacters As Boolean

      ContainsValidCharacters = True

      'Iterate through each character and determine if its a number,
      'letter, or non number of letter.
      For Each Character As Char In Str
         If Char.IsNumber(Character) Then
            ContainsNumeric = True
         ElseIf Char.IsLetter(Character) Then
            ContainsAlpha = True
         ElseIf Not Char.IsWhiteSpace(Character) Then
            ContainsValidCharacters = False
            Exit For
         End If
      Next

      IsAlphaNumeric = ContainsValidCharacters


   End Function

    Private Sub btnAddGroup_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddGroup.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the AddGroup button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing
        Dim lDRV As DataRowView

        Dim lErrorText As String = ""
        Dim lEventDescription As String = ""
        Dim lGroup As String = ""
        Dim lSQL As String
        Dim lSQLBaseInsert As String = "INSERT INTO AppUserRole (AppUserID, AppRoleId) VALUES ({0},{1})"

        Dim lAppGroupID As Integer

        ' Store text value for the group selected.
        lGroup = lstGroupPool.Text

        Try
            ' Instantiate a new SqlDataAccess object.
            lSDA = New SqlDataAccess(gConnectionString, True)

            For Each lDRV In lstGroupPool.SelectedItems
                ' Get the AppGroupID.
                lAppGroupID = lDRV.Item("AppRoleId")

                ' Build the SQL INSERT statement to Insert a row into the AppUserToGroup table.
                lSQL = String.Format(lSQLBaseInsert, mAppUserID, lAppGroupID)

                ' Perform the AddUserToGroup insert...
                lSDA.ExecuteSQLNoReturn(lSQL)

                ' Build event description and show message.
                lEventDescription = String.Format("{0} was successfully added to the {1} group.", mUserID, lGroup)
                MessageBox.Show(lEventDescription, "User Group Status", MessageBoxButtons.OK, MessageBoxIcon.Information)

                ' Log the event in the EventLog table in database.
                LogEvents(lEventDescription, gAppLoginID, ErrorTypeId.EditUserGroupsSuccess)

            Next
            ' Reload the ListBox controls.
            Call LoadLists(mAppUserID)

        Catch ex As Exception
            ' Handle the exception.
            lErrorText = Me.Name & "::btnAdd_Click error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Add User To Groups", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            ' Cleanup...
            ' Drop the connection.
            If lSDA IsNot Nothing Then lSDA.Dispose()
            ' Release object references...
            lSDA = Nothing
            lDRV = Nothing
        End Try

    End Sub

    Private Sub btnChangePassword_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnChangePassword.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Password button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lCP As New ChangePassword

        ' Show the Change Password form.
        With lCP
            .MdiParent = Me.MdiParent
            .UserID = mUserID
            .AppUserID = mAppUserID
            .ForcedChange = False
            .Show()
        End With

    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        '--------------------------------------------------------------------------------
        ' Click event for the Close button.
        '--------------------------------------------------------------------------------

        Me.Close()

    End Sub

    Private Sub btnRemoveGroup_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRemoveGroup.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the RemoveGroup button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lGroupName As String = ""

        ' Store text value for the group selected.
        lGroupName = lstAssignedGroups.Text

        If lGroupName = "Administration" Then

            If mAppUserID = gAppUserID Then
                MessageBox.Show("Admin rights can only be removed by another Admin user.", "Edit User Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Else
                RemoveUserFromGroup(lGroupName)
            End If

        Else
            RemoveUserFromGroup(lGroupName)

        End If

    End Sub

    Private Sub RemoveUserFromGroup(ByVal aGroupName As String)
        '--------------------------------------------------------------------------------
        ' Click event handler for the RemoveGroup button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDRV As DataRowView

        Dim lAppGroupID As Integer
        Dim lErrorText As String = ""
        Dim lEventDescription As String = ""
        Dim lSQL As String = ""
        Dim lSQLBaseInsert As String

        Try

            Using lSDA As New SqlDataAccess(gConnectionString, True)

                lDRV = lstAssignedGroups.SelectedItem

                ' Get the AppGroupID.
                lAppGroupID = lDRV.Item("AppRoleId")

                ' Build the SQL INSERT statement to Insert a row into the AppUserToGroup table.
                lSQLBaseInsert = "DELETE FROM AppUserRole WHERE (AppUserID = {0}) AND (AppRoleId = {1})"
                lSQL = String.Format(lSQLBaseInsert, mAppUserID, lAppGroupID)

                ' Perform the FormToCasino insert...
                lSDA.ExecuteSQLNoReturn(lSQL)

                ' Build event description and show message.
                lEventDescription = String.Format("{0} was successfully removed from the {1} group.", mUserID, aGroupName)
                MessageBox.Show(lEventDescription, "User Group Status", MessageBoxButtons.OK, MessageBoxIcon.Information)

                ' Log the event in the EventLog table in database.
                LogEvents(lEventDescription, gAppLoginID, ErrorTypeId.EditUserGroupsSuccess)

            End Using

            ' Reload the ListBox controls.
            Call LoadLists(mAppUserID)

        Catch ex As Exception
            ' Handle the exception.
            lErrorText = Me.Name & "::btnRemoveGroup_Click error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Remove User From Group", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

    End Sub

    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Save button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...

        If ValidateUserData() Then
            ' Are we Adding or Editing?
            If mEditMode = ADDMODE Then
                Call AddUser()
            Else
                Call UpdateUser()
            End If

            ' Reload the AppUserView GridControl.
            Try
                Call mOpeningForm.LoadAppUserGrid()

            Catch ex As Exception
                ' Ignore exception...
            End Try
        End If

    End Sub

    Private Sub btnUnlockAccount_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUnlockAccount.Click
        '--------------------------------------------------------------------------------
        ' Click event for the UnlockAccount button.
        '--------------------------------------------------------------------------------
        Dim lSDA As SqlDataAccess = Nothing

        Dim lSpReturnCode As Integer

        Dim lErrorText As String
        Dim lUserID As String = txtUserID.Text

        Try
            ' Instantiate a new SqlDataAccess object.
            lSDA = New SqlDataAccess(gConnectionString, False)

            With lSDA
                ' Add Parameters UnlockAccount store proc...
                .AddParameter("@AppUserID", SqlDbType.Int, mAppUserID)

                ' Execute the stored proc (the return code will be zero if no error)...
                .ExecuteSQLScalar("UPDATE [AppUser] SET      IsLocked       = 0,      FailedPasswordAttemptCount    = 0,      LastFailedPasswordAttemptDate = NULL WHERE AppUserID = @AppUserID", True)
                lSpReturnCode = .ReturnValue

                If lSpReturnCode = 0 Then
                    ' Update successful, inform the user and log in the EventLog table in the database.
                    lErrorText = String.Format("Unlocked User ID {0}.", lUserID)
                    MessageBox.Show(lErrorText, "Unlock Account Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Else
                    ' Update failed, inform the user and log in the EventLog table in the database.
                    lErrorText = String.Format("Failed to Unlock User ID {0}.", lUserID)
                    MessageBox.Show(lErrorText, "Unlock Account Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End If

                ' Log the event in the EventLog table in database.
                LogEvents(lErrorText, gAppLoginID, ErrorTypeId.EditUserSuccess)

                ' Refresh Grid in opening form.
                mOpeningForm.LoadAppUserGrid()

                ' Disable the Unlock button and clear error providers.
                btnUnlockAccount.Enabled = False
                ErrProvider.Clear()

            End With

        Catch ex As Exception
            ' Handle the error...
            lErrorText = Me.Name & "::btnUnlockAccount error: " & ex.Message
            If Not ex.InnerException Is Nothing Then
                lErrorText &= gCrLf & ex.InnerException.Message
            End If
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Unlock Account Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            ' Cleanup...
            If Not lSDA Is Nothing Then
                lSDA.Dispose()
                lSDA = Nothing
            End If

        End Try

    End Sub

    Private Sub cbIsActive_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbIsActive.CheckedChanged
        '--------------------------------------------------------------------------------
        ' Handles the CheckedChanged event for the IsActive Checkbox control.
        '--------------------------------------------------------------------------------

        ' Prevent user from deactivating own account.
        If mAppUserID = gAppUserID Then
            PreventActiveFlagChange()
        End If

        ' If changes are made enable the save button.
        If cbIsActive.Checked <> mIsActive Then
            btnSave.Enabled = True
        End If

    End Sub

    Private Sub PreventActiveFlagChange()
        '--------------------------------------------------------------------------------
        ' Prevents user from deactivating own account.
        '--------------------------------------------------------------------------------

        If cbIsActive.Checked <> mIsActive Then
            MessageBox.Show("Admin users can only be deactivated by another Admin user.", "Edit User Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cbIsActive.Checked = mIsActive
        End If

    End Sub

    Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        '--------------------------------------------------------------------------------
        ' Load event handler for this Form.
        '--------------------------------------------------------------------------------

        ' Set the Form caption.
        If mEditMode = ADDMODE Then
            ' Set the form name.
            Me.Text = "Add New User"

            ' Set checkbox on.
            cbIsActive.Checked = True

            ' Hide controls... 
            PnlGroup.Hide()
            btnUnlockAccount.Hide()
            btnChangePassword.Hide()

        Else
            ' Set the form name.
            Me.Text = "Update Existing User"

            btnSave.Enabled = False

            If mIsActive Then
                ' Set focus on control.
                txtFirstName.Focus()

            Else
                ' User deactived, allow user to activate only.
                txtFirstName.ReadOnly = True
                PnlGroup.Hide()
                Me.btnChangePassword.Hide()
                MessageBox.Show(String.Format("User ID {0} is deactivated. Activate before updating.", _
                                              mUserID), "User Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)

            End If

            ' Set control to read only.
            txtUserID.ReadOnly = True

            ' Hide controls... 
            Me.lblPassword.Hide()
            Me.txtPassword.Hide()
            Me.lblConfirmPassword.Hide()
            Me.txtConfirmPassword.Hide()

        End If

        ' Load the Group ListBox controls.
        Call LoadLists(mAppUserID)

    End Sub

    Private Sub LoadLists(ByVal aAppUserID As Integer)
        '--------------------------------------------------------------------------------
        ' Routine to populate the Group ListBox controls.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing
        Dim lDT As DataTable

        Dim lSQL As String

        ' Build SQL SELECT statement to retrieve assigned groups.
        lSQL = "SELECT ar.AppRoleId, ar.RoleName FROM AppRole ar JOIN AppUserRole ur on ar.AppRoleId = ur.AppRoleId where AppUserID = {0}"
        lSQL = String.Format(lSQL, aAppUserID)

        ' Perform the data retrieval.
        lSDA = New SqlDataAccess(gConnectionString, True)
        lDT = lSDA.CreateDataTable(lSQL, "AssignedGroups")

        ' Populate the control...
        With lstAssignedGroups
            .DataSource = lDT
            .DisplayMember = "RoleName"
            .ValueMember = "AppRoleID"
        End With

        ' Build SQL SELECT statement to retrieve Available Forms.
        lSQL = "SELECT ar.AppRoleId, ar.RoleName FROM dbo.AppRole ar WHERE AppRoleId NOT IN (SELECT AppRoleId FROM dbo.AppUserRole Where AppUserID = {0})"
        lSQL = String.Format(lSQL, aAppUserID)

        ' Perform the data retrieval.
        lDT = lSDA.CreateDataTable(lSQL, "GroupPool")

        ' Populate the control...
        With lstGroupPool
            .DataSource = lDT
            .DisplayMember = "RoleName"
            .ValueMember = "AppRoleID"
        End With

        lDT = Nothing
        lSDA.Dispose()
        lSDA = Nothing

    End Sub

    Private Sub txtFirstName_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtFirstName.TextChanged
        '--------------------------------------------------------------------------------
        ' Handles the TextChanged event for the FullName textbox control.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...

        ' If changes are made enable the save button.
        If txtFirstName.Text <> mFirstName Then
            btnSave.Enabled = True
        End If

    End Sub

    Private Sub txtLastName_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtLastName.TextChanged
        '--------------------------------------------------------------------------------
        ' Handles the TextChanged event for the FullName textbox control.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...

        ' If changes are made enable the save button.
        If txtLastName.Text <> mLastName Then
            btnSave.Enabled = True
        End If

    End Sub


    Private Sub UpdateUser()
        '--------------------------------------------------------------------------------
        ' Saves the current record.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing

        Dim lSpReturnCode As Integer

        Dim lUpdatedFirstName As Boolean = False
        Dim lUpdatedLastName As Boolean = False

        Dim lUpdatedIsActive As Boolean = False

        Dim lErrorText As String = ""
        Dim lFirstName As String = txtFirstName.Text
        Dim lLastName As String = txtLastName.Text

        Dim lLogMessage As String = ""
        Dim lLogText As String = ""
        Dim lUserID As String = txtUserID.Text

        ' Was the full name updated?
        If mFirstName <> lFirstName Then
            lUpdatedFirstName = True
        End If

        If mLastName <> lLastName Then
            lUpdatedLastName = True
        End If

        ' Was the IsActive flag udpate?
        If mIsActive <> cbIsActive.Checked Then
            lUpdatedIsActive = True
        End If

        Try
            ' Instantiate a new SqlDataAccess object.
            lSDA = New SqlDataAccess(gConnectionString, False)

            With lSDA
                ' Add Parameters UpdateUser store proc...
                .AddParameter("@AppUserID", SqlDbType.Int, mAppUserID)
                .AddParameter("@UserName", SqlDbType.VarChar, lUserID, 32)
                .AddParameter("@FirstName", SqlDbType.VarChar, lFirstName, 64)
                .AddParameter("@LastName", SqlDbType.VarChar, lLastName, 64)
                .AddParameter("@IsActive", SqlDbType.Bit, cbIsActive.Checked)

                Dim sql As String = SqlQueries.UpdateUser

                ' Execute the stored proc (the return code will be zero if no error)...

                lSpReturnCode = .ExecuteSQLScalar(sql, True)

                If lSpReturnCode <> 0 Then
                    ' Update failed, inform the user and log in the EventLog table in the database.
                    lErrorText = String.Format("Failed to update User ID {0}.", lUserID)

                    ' Log the event in the EventLog table in database.
                    LogEvents(lErrorText, gAppLoginID, ErrorTypeId.EditUserFailed)
                Else

                    lLogText = String.Format("Successfully updated User ID {0}. ", lUserID)
                    lLogMessage &= lLogText

                    lLogText = ""

                    If lUpdatedFirstName Then
                        lLogText = String.Format("Updated first name from {0} to {1}. ", mFirstName, lFirstName)
                        lLogMessage &= lLogText
                    End If

                    lLogText = ""

                    If lUpdatedLastName Then
                        lLogText = String.Format("Updated last name from {0} to {1}. ", mLastName, lLastName)
                        lLogMessage &= lLogText
                    End If

                    lLogText = ""

                    If lUpdatedIsActive Then
                        If cbIsActive.Checked Then
                            lLogText = "User was activated. "
                        Else
                            lLogText = "User was deactivated. "
                        End If

                        lLogMessage &= lLogText
                    End If

                    ' Log the event in the EventLog table in database.
                    LogEvents(lLogMessage, gAppLoginID, ErrorTypeId.EditUserSuccess)
                End If

            End With

        Catch ex As Exception
            ' Handle the error...
            lErrorText = Me.Name & "::UpdateUser error: " & ex.Message
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
            ' Show user the error message.
            MessageBox.Show(lErrorText, "Update User Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            ' Show user that data was saved.
            MessageBox.Show("Succesfully Updated User", "Update User Save Status", MessageBoxButtons.OK, MessageBoxIcon.Information)

            ' Was the active flage changed?
            If lUpdatedIsActive Then
                ' Yes. Was the user re-actived?
                If cbIsActive.Checked = True Then
                    ' Yes, show controls.
                    txtFirstName.ReadOnly = False
                    PnlGroup.Show()
                    btnChangePassword.Show()
                    btnSave.Enabled = False
                    mIsActive = True
                Else
                    ' No, user was deactivated.
                    Me.Close()
                End If
            Else
                ' No, so close the form.
                Me.Close()
            End If
        End If

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

    Private Function ValidateUserData() As Boolean
        '--------------------------------------------------------------------------------
        ' Validate User Data
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As Boolean = True
        Dim lComparePasswords As Boolean = True

        Dim lErrorMessage As String = ""
        Dim lErrorText As String

        ' Set lErrorText
        lErrorText = ""

        ' Check UserID Textbox
        If txtUserID.TextLength = 0 Then
            lErrorText = "User ID Required."
            lErrorMessage &= lErrorText & gCrLf
        End If

        ' Set the error provider.
        ErrProvider.SetError(txtUserID, lErrorText)

        ' Check FullName Textbox
        lErrorText = ""

        If txtFirstName.TextLength = 0 Then
            lErrorText = "Full Name Required."
            lErrorMessage &= lErrorText & gCrLf
        End If

        ' Set the error provider.
        ErrProvider.SetError(txtFirstName, lErrorText)

        If mEditMode = ADDMODE Then

            ' Check Password Textbox
            lErrorText = ""

            If txtPassword.TextLength = 0 Then
                lComparePasswords = False
                lErrorText = "Password Required."
                lErrorMessage &= lErrorText & gCrLf

                ' Set the error provider.
                ErrProvider.SetError(txtPassword, lErrorText)

                ' Is password policy turned on?
            ElseIf gEnforcePasswordPolicy Then
                ' Yes, so check the strength.
                If CheckPasswordStrength(txtPassword.Text) Then

                    ' Check Confirm Password Textbox
                    lErrorText = ""

                    If txtConfirmPassword.TextLength = 0 Then
                        lComparePasswords = False
                        lErrorText = "Confirm Password Required."
                        lErrorMessage &= lErrorText & gCrLf
                    End If

                    ' Set the error provider.
                    ErrProvider.SetError(txtConfirmPassword, lErrorText)

                    ' Verify passwords match
                    lErrorText = ""

                    If lComparePasswords = True Then
                        If txtPassword.Text <> txtConfirmPassword.Text Then
                            lErrorText = "Passwords do not match."
                            lErrorMessage &= lErrorText & gCrLf
                        End If

                        ' Set the error provider.
                        ErrProvider.SetError(txtPassword, lErrorText)
                        ErrProvider.SetError(txtConfirmPassword, lErrorText)
                    End If
                Else
                    ' Faild to pass password policy.
                    lReturn = False
                    ' Clear the controls and set focus.
                    txtPassword.Clear()
                    txtConfirmPassword.Clear()
                    txtPassword.Focus()
                End If
            End If
        End If

        If lErrorMessage.Length > 0 Then
            lReturn = False
            ' Show user the error message.
            MessageBox.Show(lErrorMessage, "Validate User Data Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

        ' Set the funtion Return value
        Return lReturn

    End Function

    Public WriteOnly Property AppUserID As Integer
        '--------------------------------------------------------------------------------
        ' Sets AppUserID and Edit Mode.
        '--------------------------------------------------------------------------------

        Set(ByVal value As Integer)
            mAppUserID = value
            lblAppUserIDValue.Text = value.ToString

            If value = 0 Then
                mEditMode = ADDMODE
            Else
                mEditMode = EDITMODE
            End If
        End Set

    End Property

    Public WriteOnly Property FirstName As String
        '--------------------------------------------------------------------------------
        ' Sets FullName Value.
        '--------------------------------------------------------------------------------

        Set(ByVal value As String)
            mFirstName = value
            txtFirstName.Text = value
        End Set

    End Property

    Public WriteOnly Property LastName As String
        '--------------------------------------------------------------------------------
        ' Sets FullName Value.
        '--------------------------------------------------------------------------------

        Set(ByVal value As String)
            mLastName = value
            txtLastName.Text = value
        End Set

    End Property

    Public WriteOnly Property IsActive As Boolean
        '--------------------------------------------------------------------------------
        ' Sets IsActive Value
        '--------------------------------------------------------------------------------

        Set(ByVal value As Boolean)
            mIsActive = value
            cbIsActive.Checked = value
        End Set

    End Property

    Public WriteOnly Property LockedOut As Boolean
        '--------------------------------------------------------------------------------
        ' Sets IsActive Value
        '--------------------------------------------------------------------------------

        Set(ByVal value As Boolean)
            mLockedOut = value
            btnUnlockAccount.Enabled = value

            ' If account is locked set the error provider.
            If value = True Then
                Dim lErrorText As String

                lErrorText = "User account is locked"

                ErrProvider.RightToLeft = True
                ErrProvider.SetError(lblUserID, lErrorText)
                ErrProvider.SetError(btnUnlockAccount, lErrorText)

            End If
        End Set

    End Property

    Public WriteOnly Property OpeningForm As AppUserView
        '--------------------------------------------------------------------------------
        ' Sets OpeningForm.
        '--------------------------------------------------------------------------------

        Set(ByVal value As AppUserView)
            mOpeningForm = value
        End Set

    End Property

    Public WriteOnly Property UserID As String
        '--------------------------------------------------------------------------------
        ' Sets LoginID Value.
        '--------------------------------------------------------------------------------

        Set(ByVal value As String)
            mUserID = value
            txtUserID.Text = value
        End Set

    End Property

End Class