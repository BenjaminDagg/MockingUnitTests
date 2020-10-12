Imports LotteryManagementSystem.CentralReportService
Imports System.Net
Imports LotteryManagementSystem.My.Resources
Imports LotteryManagementSystem.SqlReportingWebService2010


Public Class MDIMain

    ' [Class member variables]
    Private mMainMenuStrip As MenuStrip

    Private mActivationCount As Integer

    Private mLoggedIn As Boolean
    Private mAllowPayouts As Boolean
    Private mSSRSConnected As Boolean

    Private mAccessibleMenuItems As New List(Of String)
    Private mReportList As New Dictionary(Of String, ReportItem)

    Private Sub MDIMain_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Activated
        '--------------------------------------------------------------------------------
        ' Activated event handler for this form.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDialogResult As DialogResult

        Dim lLogin As Login

        Dim lAuthResult As Integer

        Dim lErrorText As String = ""
        Dim lPassword As String
        Dim lUserID As String

        ' Increment the number of times this form has been activated.
        mActivationCount += 1

        ' If this is the first time, show the login dialog.
        If mActivationCount = 1 Then
            ' Create a new Login form.
            lLogin = New Login

            mLoggedIn = False

            ' Set login properties and show the form...
            With lLogin
                .txtUserID.Text = My.Settings.LastLoginID
                .UserIDErrorText = ""
                .PasswordErrorText = ""
                lDialogResult = .ShowDialog(Me)
            End With

            Do While lDialogResult = Windows.Forms.DialogResult.OK
                lUserID = lLogin.txtUserID.Text
                lPassword = lLogin.txtPassword.Text

                ' Are the UserID and Password values valid?
                If AuthenticateUser(lUserID, lPassword, lErrorText, lAuthResult) Then
                    ' Yes, so store UserID in gAppUserID and
                    ' save UserID in My.Settings.LastLoginID, then exit the Do loop...
                    If My.Settings.LastLoginID <> lUserID Then
                        My.Settings.LastLoginID = lUserID
                        My.Settings.Save()
                    End If

                    ' Exit the Login loop.
                    Exit Do

                Else
                    ' No, not valid, clear the password TextBox and show login dialog again.
                    lLogin.txtPassword.Text = ""
                    MessageBox.Show(lErrorText, "Login Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    With lLogin
                        .UserIDErrorText = ""
                        .PasswordErrorText = ""

                        Select Case lAuthResult
                            Case -1
                                ' Invalid UserID.
                                .UserIDErrorText = "Invalid User ID."

                            Case -2
                                ' Deactivated UserID.
                                .UserIDErrorText = "Deactivated User ID."

                            Case -3
                                ' Invalid Password.
                                .PasswordErrorText = "Invalid Password."

                            Case -4
                                ' Account Locked.
                                .UserIDErrorText = "Account Locked."

                        End Select

                        lDialogResult = .ShowDialog(Me)
                    End With
                End If
            Loop

            ' If the user clicks cancel button, close form and stop the application.
            If lDialogResult = Windows.Forms.DialogResult.Cancel Then Me.Close()

        End If
    End Sub

    Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        '--------------------------------------------------------------------------------
        ' Load event handler for this Form.
        '--------------------------------------------------------------------------------
        Dim lErrorText As String = ""

        ' Call Application Initialization routine.
        Call MainInit()

        ' Hide Controls and show based on security settings...
        tsmiAdmin.Visible = False
        tsmiReports.Visible = False
        tsmiPayout.Visible = False

        Try
            ' Create a new SqlDataAccess instance.
            Using lSDA As New SqlDataAccess(gConnectionString, False, 20)
                lSDA.BuildConnection()
                gDatabaseName = String.Format("{0}.{1}", lSDA.SQLServerName, lSDA.SQLDatabaseName)
            End Using

        Catch ex As Exception
            ' Handle the exception.
            lErrorText = Me.Name & "::Me_Load error: " & ex.Message
            MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

    End Sub

    Private Sub ReportMenuClick(ByVal sender As System.Object, ByVal e As System.EventArgs)
        '--------------------------------------------------------------------------------
        ' Click event handler for the About Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lFormName As String = "ReportView"

        Dim lReportName As String = DirectCast(sender, ToolStripItem).Text

        Dim lReportView As New ReportView

        Dim lReportItem As ReportItem

        If (mReportList.ContainsKey(lReportName) = False) Then
            Throw New Exception(String.Format("Could not find report {0} in permissions", lReportName))
        End If

        lReportItem = mReportList(lReportName)

		'check if first char is "/"
		Dim lReportPathFirstChar As String = lReportItem.ReportPath.Substring(0, 1)
		If lReportPathFirstChar = "/" Then
			lReportItem.ReportPath = lReportItem.ReportPath.Substring(1)
		End If

        With lReportView
            .MdiParent = Me
            .ReportName = lReportItem.ReportName
            .ReportServer = gReportingServerUrl

            .ReportPath = lReportItem.ReportPath.Replace("/" & lReportName, "")

            ' Log Report Access
            LogEvents(lReportName, gAppLoginID, ErrorTypeId.ReportAccess)

            .Show()
        End With

    End Sub

    Private Sub tsmiAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiAbout.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Payout Voucher Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lFormName As String = "About"

        ' Is the form already open?
        If IsFormOpen(lFormName) Then
            ' Yes, then bring it to the front.
            My.Application.OpenForms.Item(lFormName).BringToFront()
        Else
            ' No, so open it...
            Dim lAbout As New About
            With lAbout
                .MdiParent = Me
                .Show()
            End With

        End If

    End Sub

    Private Sub tsmiAppUserView_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiAppUserView.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Payout Voucher Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lFormName As String = "AppUserView"

        ' Is the form already open?
        If IsFormOpen(lFormName) Then
            ' Yes, then bring it to the front.
            My.Application.OpenForms.Item(lFormName).BringToFront()
        Else
            ' No, so open it...
            Dim lAppUserView As New AppUserView
            With lAppUserView
                .MdiParent = Me
                .Show()
            End With

        End If

    End Sub

    Private Sub tsmiExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiExit.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Exit Tool Strip Menu Item.
        '--------------------------------------------------------------------------------

        Me.Close()

    End Sub

    Private Sub tsmiFlexNumbers_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiFlexNumbers.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Name Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lFormName As String = "FlexNumbers"

        ' Is the form already open?
        If IsFormOpen(lFormName) Then
            ' Yes, then bring it to the front.
            My.Application.OpenForms.Item(lFormName).BringToFront()
        Else
            ' No, so open it...
            Dim lLocationView As New FlexNumbers
            With lLocationView
                .MdiParent = Me
                .Show()
            End With

        End If
    End Sub

    Private Sub tsmiLocations_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiLocations.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Locations Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lFormName As String = "LocationView"

        ' Is the form already open?
        If IsFormOpen(lFormName) Then
            ' Yes, then bring it to the front.
            My.Application.OpenForms.Item(lFormName).BringToFront()
        Else
            ' No, so open it...
            Dim lLocationView As New LocationView
            With lLocationView
                .MdiParent = Me
                .Show()
            End With

        End If

    End Sub

    Private Sub tsmiPayoutVouchers_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiPayoutVouchers.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Payout Voucher Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lFormName As String = "VoucherPayout"

        ' Is the form already open?
        If IsFormOpen(lFormName) Then
            ' Yes, then bring it to the front.
            My.Application.OpenForms.Item(lFormName).BringToFront()
        Else
            ' No, so open it...
            Dim lVP As New VoucherPayout
            With lVP
                .MdiParent = Me
                .Show()
            End With

        End If

    End Sub

    Private Sub tsmiPrinters_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiPrinters.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Printers Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lFormName As String = "PrinterSetup"

        ' Is the form already open?
        If IsFormOpen(lFormName) Then
            ' Yes, then bring it to the front.
            My.Application.OpenForms.Item(lFormName).BringToFront()
        Else
            ' No, so open it...
            Dim lPrinterSetup As New PrinterSetup
            With lPrinterSetup
                .MdiParent = Me
                .Show()
            End With

        End If

    End Sub

    Private Sub tsmiVoucherLotSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiVoucherLotSearch.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Voucher Lot Search Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lVoucherLotStatus As New VoucherLotStatus

        ' Open the Voucher Lot Status form.
        With lVoucherLotStatus
            .MdiParent = Me
            .Show()
        End With

    End Sub

    Private Sub tsmiChangePassword_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiChangePassword.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the ChangePassword Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lForcedChange As Boolean = False

        ' Show the ChangePassword form.
        Call ChangePassword(lForcedChange)

    End Sub

    Private Sub BuildReportTSMI(Optional ByRef menuItem As ToolStripMenuItem = Nothing, Optional ByVal reportPath As String = Nothing)
        '--------------------------------------------------------------------------------
        ' Build Report ToolStripMenu
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSSRS As New ReportingService2010

        Dim iReportFolderMenuItemIndex As Integer = 0

        lSSRS.Credentials = New NetworkCredential(gReportingUserName, gReportingPassword)
        lSSRS.Url = gReportingWebServiceUrl


        Dim lCi As CatalogItem() = Nothing
        Dim lTsi As ToolStripItem = Nothing

        Dim lErrorText As String
        Dim lReportPath As String = ""
        Dim reportName As String
        Dim toolstripMenuItemList As New List(Of ToolStripItem)

        Try
            If (menuItem Is Nothing) Then
                menuItem = tsmiReports


            End If

            If (String.IsNullOrWhiteSpace(reportPath)) Then
                lReportPath = gReportingFolderPath
            Else
                lReportPath = reportPath
            End If

            ' Pass the current user identity to the service
            lSSRS.Credentials = System.Net.CredentialCache.DefaultCredentials



            ' Retrieve all catalog items in the report folder
            lCi = lSSRS.ListChildren(lReportPath, False)

            ' Enumerate all catalog items and add non-hidden reports to the ToolStripMenu
            For Each Report As CatalogItem In lCi

                If Report.TypeName.ToLower() = "report" AndAlso Not Report.Hidden Then

                    reportName = "rpt" + Report.Name.Replace(" ", "").Replace("_", "").ToLower()


                    If mAccessibleMenuItems.Contains(reportName, StringComparer.InvariantCultureIgnoreCase) Then

                        If (mReportList.ContainsKey(Report.Name.ToLower())) = False Then
                            Dim lReportItem As New ReportItem

                            lReportItem.ReportName = Report.Name
                            lReportItem.ReportPath = Report.Path

                            mReportList.Add(Report.Name, lReportItem)

                        End If

                        lTsi = menuItem.DropDownItems.Add(Report.Name)
                        AddHandler lTsi.Click, AddressOf ReportMenuClick

                    End If

                ElseIf Report.TypeName.ToLower() = "folder" Then
                    Dim reportFolderMenuItem As New ToolStripMenuItem()

                    reportFolderMenuItem.Name = Report.Name
                    reportFolderMenuItem.Text = Report.Name

                    ' Recursion for folders
                    BuildReportTSMI(reportFolderMenuItem, Report.Path)

                    If (reportFolderMenuItem.DropDownItems.Count > 0) Then
                        reportFolderMenuItem.Visible = True
                    Else
                        reportFolderMenuItem.Visible = False
                    End If

                    ' Each call of BuildReportSMI keeps track of a index starting at 0, each time a new folder is added that index is incremented
                    ' This allows folders to appear before reports
                    menuItem.DropDownItems.Insert(iReportFolderMenuItemIndex, reportFolderMenuItem)
                    iReportFolderMenuItemIndex += 1
                  
                End If
            Next

            ' Successfully connected to SSRS.
            mSSRSConnected = True

        Catch ex As Exception

            ' Error connecting to SSRS.
            mSSRSConnected = False

            ' Handle the exception.
            lErrorText = Me.Name & "::BuildReportTSMI error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(String.Format("Unable to connect to report server {0}{1}. Reports will be disabled.", gReportingServerUrl, gReportingFolderPath), "Report Server Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

    End Sub

    Private Function PingWebservice() As Boolean
        Dim lReturn As Boolean = False
        ' Dim lWebservice As String = My.Settings.ReportWebService
        Dim lResponse As HttpWebResponse = Nothing
        Dim lErrorText As String = ""
        Dim lRequest As HttpWebRequest

        Try

            lRequest = DirectCast(WebRequest.Create(gReportingWebServiceUrl), HttpWebRequest)


            ' Create a request to the passed URI.   
            lRequest.Credentials = New NetworkCredential(gReportingUserName, gReportingPassword)

            ' Get the response object.   
            lResponse = DirectCast(lRequest.GetResponse(), HttpWebResponse)
            lReturn = True

        Catch ex As Exception
            ' Handle the exception. Build the error text, then log and show it...
            lErrorText = MessageBox.Show(String.Format("Unable to connect to the SSRS Webservice {0}. Reports will be disable.", _
                                         gReportingWebServiceUrl), "Report Server Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Logging.Log(lErrorText)
        End Try

        Return lReturn

    End Function

    Private Sub ChangePassword(ByVal aForcedChange As Boolean)
        '--------------------------------------------------------------------------------
        ' Click event handler for the ChangePassword Tool Strip Menu Item.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lFormName As String = "ChangePassword"

        ' Is the form already open?
        If IsFormOpen(lFormName) Then
            ' Yes, then bring it to the front.
            My.Application.OpenForms.Item(lFormName).BringToFront()

        Else
            ' No, so open it...
            Dim lCP As New ChangePassword

            With lCP
                .AppUserID = gAppUserID
                .UserID = gAppLoginID
                .ForcedChange = aForcedChange
                .ShowDialog()

                If mLoggedIn = False Then
                    ' Successful logon, log event.
                    LogEvents(String.Format("Successful Login: User Name {0}.", gAppLoginID), gAppLoginID, ErrorTypeId.SuccessfulLogin)

                End If

            End With

        End If
    End Sub

    Private Sub SetMenuStrip()
        '--------------------------------------------------------------------------------
        ' Routine to enable the menu items.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDT As DataTable = Nothing
        Dim lDR As DataRow

        Dim lErrorText As String
        Dim lSQL As String

        Dim lAppRoleId As Integer

        ' Build the SQL select statement to return groups that belong to the current user.
        lSQL = String.Format("SELECT AppRoleId FROM AppUserRole WHERE AppUserID = {0} ORDER BY AppRoleId", gAppUserID)
        Dim lHasReportMenuItems As Boolean = False

        Try
            ' Create a new SQL data access instance.
            Using lSDA As New SqlDataAccess(gConnectionString, False)

                ' Retrieve the data.
                lDT = lSDA.CreateDataTable(lSQL)

                ' Enable menu strip items.
                For Each lDR In lDT.Rows
                    lAppRoleId = lDR.Item("AppRoleId")

                    Dim hasReports As Boolean = False
                    hasReports = AccessibleMenuItems(lAppRoleId)

                    If (lHasReportMenuItems = False) Then
                        lHasReportMenuItems = hasReports
                    End If


                Next
            End Using

            If (lHasReportMenuItems) Then
                If PingWebservice() Then

                    BuildReportTSMI()

                    If mSSRSConnected = True Then
                        ' Reporting
                        tsmiReports.Visible = True
                    End If
                End If
            End If


            EnableMenuItems()

        Catch ex As Exception
            ' Handle the exception
            lErrorText = Me.Name & "::SetMenuStrip Error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Set Menu Strip Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

    End Sub

    Private Function AccessibleMenuItems(ByVal aAppGroupID As Integer) As Boolean
        Dim lSQL As String
        Dim lDT As DataTable = Nothing
        Dim lDR As DataRow = Nothing
        Dim lErrorText As String
        Dim lMenuItem As String
        Dim isReportUser As Boolean = False
        Try
            mAccessibleMenuItems.Add("Exit")
            mAccessibleMenuItems.Add("About")
            mAccessibleMenuItems.Add("Change Password")
            mAccessibleMenuItems.Add("Printers")

            lSQL = String.Format("SELECT ap.AppPermissionID, ap.PermissionName FROM dbo.AppRolePermission ar JOIN dbo.AppPermission ap ON ap.AppPermissionID = ar.AppPermissionID WHERE AppRoleId = {0}", aAppGroupID)

            Using lSDA As New SqlDataAccess(gConnectionString, False)

                lDT = lSDA.CreateDataTable(lSQL)

                For Each lDR In lDT.Rows

                    lMenuItem = lDR.Item("PermissionName")


                    Select Case lMenuItem
                        Case "UserAdministration"
                            mAccessibleMenuItems.Add("Application Users")
                            tsmiAdmin.Visible = True
                        Case "CashierTerminal"
                            mAccessibleMenuItems.Add("Payout Vouchers")

                            ' Allow payouts at Central location?
                            If gAllowPayouts = True Then

                                ' Attempt to get the number of voucher expiration days.
                                If Not gVoucherExpirationDays = -1 Then
                                    ' Show payout menu item.
                                    tsmiPayout.Visible = True

                                End If
                            End If

                        Case Else
                            If mAccessibleMenuItems.Contains(lMenuItem) = False Then
                                mAccessibleMenuItems.Add(lMenuItem)
                            End If

                            If (lMenuItem.StartsWith("rpt")) Then
                                isReportUser = True
                            End If
                    End Select



                Next
            End Using

            tsmiFlexNumbers.Visible = gAllowFlexNumbers
            tsmiVoucherLotSearch.Visible = gAllowVoucherLots

        Catch ex As Exception
            lErrorText = Me.Name & "::AddMenuItemToList Error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Set Menu Strip Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

        Return isReportUser
    End Function

    Private Sub EnableMenuItems()
        Dim lToolStripMenuItems As ToolStripMenuItem
        Dim lErrorText As String

        Try
            For Each lToolStripMenuItems In msMain.Items

                If (lToolStripMenuItems.Name <> "tsmiReports") Then
                    For Each ltsmi In lToolStripMenuItems.DropDownItems

                        Dim lItem As String
                        lItem = ltsmi.ToString.Replace("&", "")

                        If mAccessibleMenuItems.Contains(lItem) Then
                            ltsmi.Visible = True
                        Else
                            ltsmi.Visible = False
                        End If
                    Next
                End If
                
            Next

        Catch ex As Exception
            lErrorText = Me.Name & "::EnableMenuItems Error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Set Menu Strip Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

    End Sub

    Private Function AuthenticateUser(ByVal aUsername As String, ByVal aPassword As String, ByRef aErrorText As String, ByRef aResult As Integer) As Boolean
        '--------------------------------------------------------------------------------
        ' Function to authenticate user.
        ' Returns True or False to indicate success or failure.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lAPE As New AppPasswordEncryption
        Dim lDT As DataTable
        Dim lSDA As SqlDataAccess = Nothing
        Dim lDialogResult As DialogResult

        Dim lReturn As Boolean = False

        Dim lErrorText As String = ""
        Dim lHashedPassword As String = ""
        Dim lDaysLeft As Integer

        Dim lForcedChange As Boolean
        Dim lPasswordReset As Boolean

        Try

            ' Attempt to hash the password.
            lHashedPassword = lAPE.GetMd5Hash(aPassword)

            ' Did we successfully hash the password?
            If String.IsNullOrEmpty(lHashedPassword) = False Then

                ' Initialize the application UserID to zero.
                gAppUserID = 0

                ' Create a new SqlDataAccess instance.
                lSDA = New SqlDataAccess(gConnectionString, False, 90)

                With lSDA
                    .AddParameter("@UserName", SqlDbType.VarChar, aUsername, 64)
                    .AddParameter("@Password", SqlDbType.VarChar, lHashedPassword, 64)
                    .AddParameter("@LocationId", SqlDbType.Int, DBNull.Value)

                    Dim sql As String = SqlQueries.AuthenticateUser

                    lDT = .CreateDataTable(sql, "", True)

                End With

                ' Set the SP return values.
                aResult = CType(lDT.Rows(0).Item("AppUserID"), Integer)
                lDaysLeft = CType(lDT.Rows(0).Item("DaysLeft"), Integer)
                lPasswordReset = CType(lDT.Rows(0).Item("PasswordReset"), Boolean)

                ' Set the return value based on the return value in the stored procedure.
                lReturn = (aResult > 0)

                Select Case aResult

                    Case -1
                        ' Invalid UserID.
                        aErrorText = String.Format("Login Failed: User ID {0} is invalid.", aUsername)
                        LogEvents(aErrorText, aUsername, ErrorTypeId.FailedLogin)

                    Case -2
                        ' UserID deactivated.
                        aErrorText = String.Format("Login Failed: User ID {0} is deactivated.", aUsername)
                        LogEvents(aErrorText, aUsername, ErrorTypeId.FailedLogin)

                    Case -3
                        ' Invalid password.
                        aErrorText = String.Format("Login Failed: Invalid password for User ID {0}.", aUsername)
                        LogEvents(aErrorText, aUsername, ErrorTypeId.FailedLogin)

                    Case -4
                        ' UserID account is locked.
                        aErrorText = String.Format("Login Failed: Account is now locked for User ID {0}.", aUsername)
                        LogEvents(aErrorText, aUsername, ErrorTypeId.FailedLogin)

                    Case Is > 0
                        ' Valid login.
                        gAppUserID = aResult
                        gAppLoginID = aUsername

                        ' Was the password reset?
                        If lPasswordReset = False Then

                            ' No, is password expiration on?
                            If gPasswordExpirationDaysOn Then

                                ' Yes...
                                Select Case lDaysLeft

                                    Case Is <= 0
                                        ' User password is expired...
                                        lErrorText = String.Format("Your password has expired and needs to be updated.")
                                        MessageBox.Show(lErrorText, "Password Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)

                                        aErrorText = String.Format("Password Expired: User ID {0}.", aUsername)
                                        LogEvents(aErrorText, aUsername, ErrorTypeId.PasswordExpired)

                                        ' Set the forced change flag to true.
                                        lForcedChange = True

                                        ' Show the change password form.
                                        Call ChangePassword(lForcedChange)

                                    Case 1 To gPasswordExpirationWarning
                                        ' Is password is about to expire warning on?
                                        If gPasswordExpirationWarningOn Then

                                            ' Yes, show the warning.
                                            lErrorText = String.Format("Your password will expire in {0} day(s). Would you like to update your password now?", lDaysLeft)
                                            lDialogResult = MessageBox.Show(lErrorText, "Password Status", MessageBoxButtons.YesNo, MessageBoxIcon.Warning)

                                            If lDialogResult = DialogResult.Yes Then
                                                ' User will attempt to change password.
                                                lForcedChange = False
                                                Call ChangePassword(lForcedChange)

                                            Else
                                                ' User will change password at a later date.
                                                LogEvents(String.Format("Successful Login: User ID {0}.", aUsername), aUsername, ErrorTypeId.SuccessfulLogin)

                                            End If
                                        End If

                                    Case Is > gPasswordExpirationWarning
                                        ' Password has not expired.
                                        LogEvents(String.Format("Successful Login: User ID {0}.", aUsername), aUsername, ErrorTypeId.SuccessfulLogin)

                                End Select
                            Else
                                ' PasswordExpirationOff.
                                LogEvents(String.Format("Successful Login: User ID {0}.", aUsername), aUsername, ErrorTypeId.SuccessfulLogin)

                            End If

                        Else
                            ' User password was reset and needs to be updated...
                            lErrorText = String.Format("Your password was reset and needs to be updated.")
                            MessageBox.Show(lErrorText, "Password Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)

                            ' Set the forced change flag to false.
                            lForcedChange = True

                            ' Show the change password form.
                            Call ChangePassword(lForcedChange)

                        End If

                        ' Set up the menu strip.
                        SetMenuStrip()

                        ' Set value to logged in.
                        mLoggedIn = True

                End Select

            Else
                ' Unable to hash the password.
                aErrorText = "Unable to hash the user password."
                Logging.Log(lErrorText)
                MessageBox.Show(lErrorText, "Authenticate User Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

            End If

        Catch ex As Exception
            ' Handle the exception. Build the error text, then log and show it...
            aErrorText = Me.Name & "::AuthenticateUser error: " & ex.Message
            Logging.Log(aErrorText)

        Finally
            ' Cleanup...
            If lSDA IsNot Nothing Then
                lSDA.Dispose()
                lSDA = Nothing
            End If

        End Try

        ' Set Function return value.
        Return lReturn

    End Function

    Private Function IsFormOpen(ByVal aFormName As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Returns T/F value indicating if named form is open.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lForm As Form
        Dim lReturn As Boolean = False

        ' Search the collection of open forms...
        For Each lForm In My.Application.OpenForms
            If String.Compare(aFormName, lForm.Name, True) = 0 Then
                lReturn = True
            End If
        Next

        ' Set the function return value.
        Return lReturn

    End Function

End Class