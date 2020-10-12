Imports System.IO
Imports LotteryManagementSystem.My.Resources
Imports System.Diagnostics.Eventing.Reader

Module ModMain

#Region " Public Application (Global) variables "

    ' [Application Public (global) variables]
    Public gAccountLockoutDuration As Integer
    Public gAppUserID As Integer
    Public gPasswordExpirationWarning As Integer
    Public gPasswordHistory As Integer
    Public gPrintLotteryReceipt As Boolean
    Public gPrintDuplicateCustomerReceipt As Boolean

    Public gVoucherExpirationDays As Integer

    Public gSymmetricEncryptionService As SymmetricEncryptService
    Public gReportingDomainName As String
    Public gReportingFolderPath As String
    Public gReportingPassword As String
    Public gReportingServerName As String
    Public gReportingServerUrl As String
    Public gReportingUserName As String
    Public gReportingWebServiceUrl As String


    Public gAppPath As String
    Public gAppLoginID As String
    Public gComputerName As String
    Public gConnectionString As String
    Public gCrLf As String
    Public gDatabaseName As String
    Public gPasswordPolicy As String
    Public gPasswordPolicyMessage As String
    Public gPayoutReceiptLogo As String
    Public gPayoutReceiptTitle As String

    Public gAccountLockoutOn As Boolean
    Public gAllowPayouts As Boolean
    Public gAllowFlexNumbers As Boolean
    Public gAllowVoucherLots As Boolean
    Public gEnforcePasswordPolicy As Boolean
    Public gPasswordExpirationDaysOn As Boolean
    Public gPasswordExpirationWarningOn As Boolean
    Public gPasswordHistoryOn As Boolean

#End Region

#Region " Application Initialization "

    Sub MainInit()
        '--------------------------------------------------------------------------------
        ' Entry point into this application.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lErrorText As String = ""

        ' Store crlf in a global variable.
        gCrLf = Environment.NewLine

        ' Store the Startup Path of this application.
        gAppPath = Application.StartupPath

        ' Store the computer name.
        gComputerName = My.Computer.Name

        ' Set defaults for menu items
        gAllowFlexNumbers = True
        gAllowVoucherLots = True

        ' Setup application log filename.
        Logging.LogFileName = Path.Combine(gAppPath, "LotteryManagementSystem.log")


        Dim generalEncryptionKey As Byte() = New Byte() {1, 107, 51, 183, 60, 238, 9, 75, 130, 184, 109, 83, 56, 186, 23, 89, 45, 160, 2, 122, 66, 192, 23, 126, 119, 15, 171, 72, 238, 147, 101, 122}
        Dim generalEncryptionIv As Byte() = New Byte() {60, 79, 144, 22, 37, 128, 1, 127, 64, 141, 93, 212, 99, 115, 142, 199}

        gSymmetricEncryptionService = New SymmetricEncryptService(generalEncryptionKey, generalEncryptionIv, SymmetricEncryptionAlgorithm.Rijndael)


        ' Assign connection string to a global var...
        gConnectionString = BuildConnection()

        Try
            ' Test the SQL Connection.
            If TestSQLConnection() Then

                ' Attempt to get application settings.
                If GetAppSettings(lErrorText) Then

                    ' Does the application exe pass authentication?
                    If AuthenticateApp() Then
                        ' Yes, Record the application version information.
                        Call RecordAppVersion()

                    Else
                        lErrorText = "The Lottery Mangemenet System application has failed security authentication and will terminate." & _
                                                 gCrLf & gCrLf & "Application Version: " & My.Application.Info.Version.ToString
                        MessageBox.Show(lErrorText, "Startup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Application.Exit()
                    End If

                Else
                    MessageBox.Show(lErrorText, "Startup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Logging.Log(lErrorText)
                    Environment.Exit(-1)

                End If
            End If
        Catch ex As Exception
            ' Handle the exception.
            MessageBox.Show(ex.Message, "Lottery Management System", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

    End Sub

#End Region

#Region " Friend Application SubRoutines "

    Friend Sub ShowDataGridViewColumnWidths(ByVal aDataGridView As DataGridView)
        '--------------------------------------------------------------------------------
        ' Show column widths in the specified DataGridView control.
        ' To be used primarily for column width setup during application design.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lColumn As DataGridViewColumn
        Dim lUserMsg As String = ""

        For Each lColumn In aDataGridView.Columns
            lUserMsg &= lColumn.Name & " = " & lColumn.Width.ToString & gCrLf
        Next

        ' Add the size of the row header column.
        lUserMsg &= gCrLf & "Row Headers width = " & aDataGridView.RowHeadersWidth.ToString & gCrLf

        ' Add the Size of the control itself.
        lUserMsg &= gCrLf & "Control Size: " & aDataGridView.Size.ToString

        ' Free object references...
        lColumn = Nothing

        ' Show the message.
        MessageBox.Show(lUserMsg, aDataGridView.Name, MessageBoxButtons.OK, MessageBoxIcon.Information)

    End Sub

#End Region

#Region " Friend Application Functions "

    Friend Function CreateDT(ByVal aSQL As String, ByVal aTableName As String, ByRef aErrorText As String) As DataTable
        '--------------------------------------------------------------------------------
        ' Generic function to return a db resultset in a DataTable object.
        ' This routine takes a TableName parameter.
        ' If an error occurs, populates aErrorText and returns nothing.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing
        Dim lReturn As DataTable

        Try
            ' Instantiate a SqlDataAccess object.
            lSDA = New SqlDataAccess(gConnectionString, False, 120)

            ' Perform the retrieval.
            lReturn = lSDA.CreateDataTable(aSQL, aTableName)

        Catch ex As Exception
            ' Handle the error.
            aErrorText = "CreateDT error: " & ex.Message
            lReturn = Nothing
            Logging.Log(aErrorText)

        Finally
            ' Cleanup...
            If lSDA IsNot Nothing Then
                lSDA.Dispose()
                lSDA = Nothing
            End If
        End Try

        ' Set the function return value.
        Return lReturn

    End Function

    Friend Function LogEvents(ByVal aEventDescription As String, ByVal aUserID As String, ByVal aEventCode As ErrorTypeId) As Boolean
        '--------------------------------------------------------------------------------
        ' Inserts row into the EventLog table.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing

        Dim lReturn As Boolean = False

        Dim lSpReturnCode As Integer

        Dim lErrorText As String = ""
        Dim lEventSource As String = ""


        Try
            ' Instantiate a new SqlDataAccess object.
            lSDA = New SqlDataAccess(gConnectionString, False)

            lEventSource = String.Format("{0}_{1}", My.Computer.Name, My.Application.Info.AssemblyName)


            With lSDA
                ' Add Parameters for the UpdateAppUserPassword stored proc...
                .AddParameter("@EventTypeId", SqlDbType.Int, aEventCode)
                .AddParameter("@EventDescription", SqlDbType.VarChar, aEventDescription, 1024)
                .AddParameter("@Details", SqlDbType.VarChar, DBNull.Value, 1024)

                .AddParameter("@EventSource", SqlDbType.VarChar, lEventSource, 64)

                .AddParameter("@UserName", SqlDbType.VarChar, aUserID, 32)

                Dim sql As String = SqlQueries.InsertEventLog

                ' Execute the stored proc (the return code will be zero if no error)...
                .ExecuteSQLNoReturn(sql, True)
                lSpReturnCode = .ReturnValue

                ' Was the update successful?
                If lSpReturnCode = 0 Then
                    ' Yes, so log it in the database
                    lReturn = True
                Else
                    ' Yes, inform the user.
                    lErrorText = "Failed to insert row into the EventLog table."
                End If

            End With

        Catch ex As Exception
            ' Handle the error...
            lErrorText = "ModMain::LogEvent error: " & ex.Message
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
            MessageBox.Show(lErrorText, "Log Event Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Logging.Log(lErrorText)
        End If

        ' Set the funtion Return value
        Return lReturn

    End Function

#End Region

#Region " Private SubRoutines"

    Private Sub RecordAppVersion()
        '--------------------------------------------------------------------------------
        ' Call stored procedure to record the version of this application.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing
        Dim lDT As DataTable

        Dim lTableCount As Integer

        Dim lErrorText As String
        Dim lSQL As String


        Try
            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectionString, True, 120)

            ' Determine if the APP_INFO table exists in the database...
            lSQL = "SELECT COUNT(*) FROM sys.tables WHERE [name] = 'AppEnvironment'"
            lDT = lSDA.CreateDataTable(lSQL)
            lTableCount = lDT.Rows(0).Item(0)

            If lTableCount > 0 Then
                ' The table is there so execute stored procedure InsertAppInfo to insert application info into it.
                With lSDA
                    ' Add InsertAppInfo stored procedure parameters...
                    .AddParameter("@ApplicationName", SqlDbType.VarChar, My.Application.Info.AssemblyName, 64)
                    .AddParameter("@ApplicationVersion", SqlDbType.VarChar, My.Application.Info.Version.ToString, 16)
                    .AddParameter("@ApplicationType", SqlDbType.VarChar, "Desktop")
                    .AddParameter("@ApplicationPath", SqlDbType.VarChar, gAppPath)
                    .AddParameter("@ApplicationAssemblyPath", SqlDbType.VarChar, gAppPath)
                    .AddParameter("@ProcessUserIdentity", SqlDbType.VarChar, "")
                    .AddParameter("@DeviceName", SqlDbType.VarChar, Environment.MachineName, 64)
                    .AddParameter("@DeviceOs", SqlDbType.VarChar, Environment.OSVersion.VersionString, 64)
                    .AddParameter("@IsOperatingSystem64Bit", SqlDbType.Bit, Environment.Is64BitOperatingSystem, 64)

                    .AddParameter("@ProcessorCount", SqlDbType.SmallInt, Environment.ProcessorCount)
                    .AddParameter("@TotalPhyiscalMemory", SqlDbType.BigInt, My.Computer.Info.TotalPhysicalMemory)
                    .AddParameter("@TotalVirtualMemory", SqlDbType.BigInt, My.Computer.Info.TotalVirtualMemory)
                    .AddParameter("@AvaliablePhysicalMemory", SqlDbType.BigInt, My.Computer.Info.AvailablePhysicalMemory)
                    .AddParameter("@AvaliableVirtualMemory", SqlDbType.BigInt, My.Computer.Info.AvailableVirtualMemory)

                    Dim sql As String = SqlQueries.AddApplicationEnvironment

                    ' Execute InsertAppInfo stored procedure...
                    .ExecuteSQLNoReturn(sql, True)
                End With
            End If

        Catch ex As Exception
            ' Handle the exception, build the error text and write it to the EventLog...
            lErrorText = "Startup::RecordAppVersion error: " & ex.Message
            Logging.Log(lErrorText)

        Finally
            ' Cleanup...
            If lSDA IsNot Nothing Then
                lSDA.Dispose()
                lSDA = Nothing
            End If

        End Try

    End Sub

#End Region

#Region " Private Functions"

    Private Function AuthenticateApp() As Boolean
        '--------------------------------------------------------------------------------
        ' Evaluate hash of app exe
        ' Return T/F
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSHA1 As DGE.SHA1Cryptography
        Dim lHashDigest() As Byte
        Dim lStaticDigest() As Byte

        Dim lAuthRequired As Boolean = True
        Dim lReturn As Boolean = False

        Dim lErrorText As String = ""
        Dim lHashText As String
        Dim lMsgDigest As String
        Dim lSourceFiles(2) As String
        Dim lTestText As String


        lAuthRequired = (Debugger.IsAttached = False)

        ' Is application authorization required?
        If lAuthRequired Then

            ' Store the fully qualified filename of the message digest file that will be used for comparison.
            lMsgDigest = Path.Combine(gAppPath, "lmsMsgDigest.dat")

            ' Yes, so populate the source file array with fully qualified filenames to check...
            lSourceFiles = My.Settings.AppAuthList.Split(",".ToCharArray)

            ' Build fully qualified filenames.
            For lIndex As Integer = 0 To lSourceFiles.GetUpperBound(0)
                lSourceFiles(lIndex) = Path.Combine(gAppPath, lSourceFiles(lIndex))
                ' Confirm that each file exists.
                If Not File.Exists(lSourceFiles(lIndex)) Then
                    lErrorText = String.Format("File {0} not found", lSourceFiles(lIndex))
                    Exit For
                End If
            Next

            ' Set the fully qualified filename of the message digest file.
            If lErrorText.Length = 0 Then
                If File.Exists(lMsgDigest) = False Then
                    lErrorText = String.Format("File {0} not found", lMsgDigest)
                End If
            End If

            ' Any errors encountered yet?
            If lErrorText.Length = 0 Then
                ' No errors, so create a new hash and compare to digest...
                Try
                    ' Instantiate a new SHA1 instance.
                    lSHA1 = New DGE.SHA1Cryptography

                    ' Create the hashed array and convert to a string for comparison...
                    lHashDigest = lSHA1.CreateFileHash(lSourceFiles)
                    lHashText = System.Text.UTF8Encoding.UTF8.GetString(lHashDigest)

                    ' Load static digest array and convert to a string for comparison...
                    lStaticDigest = File.ReadAllBytes(lMsgDigest)
                    lTestText = System.Text.UTF8Encoding.UTF8.GetString(lStaticDigest)

                    ' Perform string compare, setting return value.
                    lReturn = (String.Compare(lHashText, lTestText, False) = 0)

                Catch ex As Exception
                    ' Handle the error...
                    lErrorText = "modMain::AuthenticateApp error: " & ex.Message
                    lReturn = False

                End Try
            End If

            ' If there is error text, show it...
            If String.IsNullOrEmpty(lErrorText) = False Then
                MessageBox.Show(lErrorText, "Application Authentication Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
        Else
            ' Authentication is not required, return true.
            lReturn = True
        End If

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function BuildConnection() As String
        '--------------------------------------------------------------------------------
        ' Builds the ConnectionString values using config file entries.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lAPE As New AppPasswordEncryption

        Dim lDBPassword As String
        Dim lErrorText As String = ""
        Dim lReturn As String = ""

        ' Build the database connection string...
        Try
            lDBPassword = lAPE.DecryptPassword(My.Settings.DBKey)
            lReturn = String.Format(My.Settings.DBConnect, lDBPassword)

        Catch ex As Exception
            ' Handle the exception...
            lErrorText = "ModMain::BuildConnection error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Build Connection Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            ' Clean up.
            lAPE = Nothing

        End Try

        ' Set the Function Return value.
        Return lReturn

    End Function

    Private Function GetAppSettings(ByRef aErrorText As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Gets and sets application settings.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDT As DataTable

        Dim lRowCount As Integer

        Dim lSQL As String
        Dim lTableName As String = "AppSettings"

        Dim lReturn As Boolean = False

        ' Build SQL SELECT statement to retrieve AppSettings.
        lSQL = "SELECT * FROM AppConfig WHERE ConfigKey in ('AccountLockoutDuration','AllowFlexNumbers','AllowPayouts','PasswordPolicyRegularExpression','PasswordExpirationDays','PasswordExpirationWarningDays','PreviousPasswordLimit','PayoutReceiptLogo','PayoutReceiptTitle','VoucherExpirationDays','ReportingDomainName','ReportingFolderPath','ReportingPassword','ReportingServerName','ReportingServerUrl','ReportingUserName','ReportingWebServiceUrl', 'PrintLotteryReceipt', 'PrintDuplicateCustomerReceipt')"

      

        Try
            ' Execute SQL.
            lDT = CreateDT(lSQL, lTableName, aErrorText)

            If lDT IsNot Nothing Then

                ' Store the number of retrieved rows.
                lRowCount = lDT.Rows.Count

            End If

            ' Did we get all of the application settings?

            gAllowFlexNumbers = False
            gAllowVoucherLots = False
            gPasswordPolicyMessage = "The Password does not meet the minimum requirements: #;# (1) Must be at least 8 characters in length. #;# (2) Contain at least one upper and lower case. #;# (3) Contain at least one digit and one symbol."


            If lRowCount = 18 Then

                ' Yes.
                For Each lRow As DataRow In lDT.Rows
                    Select Case lRow("ConfigKey")

                        Case "AllowPayouts"
                            ' Allow voucher redemptions.
                            gAllowPayouts = CType(lRow.Item("ConfigValue"), Boolean)

                        Case "AccountLockoutDuration"
                            ' Get and set the user account lockout after X number of failed login attempts.
                            gAccountLockoutDuration = CType(lRow.Item("ConfigValue"), Integer)

                            If (gAccountLockoutDuration > 0) Then
                                gAccountLockoutOn = True
                            Else
                                gAccountLockoutOn = False
                            End If


                        Case "PasswordExpirationDays"
                            ' Get and set the number of days a password will be valid for.

                            Dim passwordExpirationDays As Integer = CType(lRow.Item("ConfigValue"), Integer)
                            If (passwordExpirationDays > 0) Then
                                gPasswordExpirationDaysOn = True
                            End If



                        Case "PasswordExpirationWarningDays"
                            gPasswordExpirationWarning = CType(lRow.Item("ConfigValue"), Integer)

                            If (gPasswordExpirationWarning > 0) Then
                                gPasswordExpirationWarningOn = True
                            End If



                        Case "VoucherExpirationDays"
                            ' Get and set the voucher expiration days.
                            gVoucherExpirationDays = CType(lRow.Item("ConfigValue"), Integer)

                        Case "PasswordPolicyRegularExpression"

                            ' Get and set Enforce Password policy.
                            gPasswordPolicy = CType(lRow.Item("ConfigValue"), String)

                            If (String.IsNullOrWhiteSpace(gPasswordPolicy)) Then
                                gEnforcePasswordPolicy = False
                            Else
                                gEnforcePasswordPolicy = True
                            End If

                        Case "PrintLotteryReceipt"
                            gPrintLotteryReceipt = CType(lRow.Item("ConfigValue"), Boolean)

                        Case "PrintDuplicateCustomerReceipt"
                            gPrintDuplicateCustomerReceipt = CType(lRow.Item("ConfigValue"), Boolean)

                        Case "PreviousPasswordLimit"
                            ' Get and set the number of last passwords used a user will not be allowed to use.
                            gPasswordHistory = CType(lRow.Item("ConfigValue"), Integer)

                        Case "PayoutReceiptLogo"
                            gPayoutReceiptLogo = CType(lRow.Item("ConfigValue"), String)

                        Case "PayoutReceiptTitle"
                            gPayoutReceiptTitle = CType(lRow.Item("ConfigValue"), String)


                        Case "ReportingDomainName"
                            gReportingDomainName = CType(lRow.Item("ConfigValue"), String)

                        Case "ReportingFolderPath"
                            gReportingFolderPath = CType(lRow.Item("ConfigValue"), String)

                        Case "ReportingServerName"
                            gReportingServerName = CType(lRow.Item("ConfigValue"), String)

                        Case "ReportingServerUrl"
                            gReportingServerUrl = CType(lRow.Item("ConfigValue"), String)

                        Case "ReportingWebServiceUrl"
                            gReportingWebServiceUrl = CType(lRow.Item("ConfigValue"), String)

                        Case "ReportingUserName"
                            gReportingUserName = CType(lRow.Item("ConfigValue"), String)

                        Case "ReportingPassword"
                            Dim reportingPassword As String = CType(lRow.Item("ConfigValue"), String)
                            gReportingPassword = gSymmetricEncryptionService.Decrypt(reportingPassword)

                    End Select

                Next

                gReportingServerUrl = String.Format(gReportingServerUrl, gReportingServerName)
                gReportingWebServiceUrl = String.Format(gReportingWebServiceUrl, gReportingServerName)

                ' Successfully retrieved settings. 
                lReturn = True

            Else
                ' Failed to get AppSettings.
                aErrorText = "Application settings missing. Application will now terminate. "

            End If

        Catch ex As Exception
            ' Handle error...
            aErrorText = "ModMain::GetAppSettings error: " & ex.Message
        End Try

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function TestSQLConnection() As Boolean
        '--------------------------------------------------------------------------------
        ' Test SQL Connection.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing
        Dim lDT As DataTable

        Dim lErrorText As String
        Dim lSQL As String

        Dim lReturn As Boolean

        Try
            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectionString, True, 120)

            ' Test the SQL connection.
            lSQL = "SELECT @@Version"
            lDT = lSDA.CreateDataTable(lSQL)

            lReturn = True

        Catch ex As Exception
            ' Handle the exception, build the error text and write it to the EventLog...
            lErrorText = "Unable to connect to SQL Server. Check the connection settings and try again."
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "SQL Connection Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Environment.Exit(-1)
        Finally
            ' Cleanup...
            If lSDA IsNot Nothing Then
                lSDA.Dispose()
                lSDA = Nothing
            End If

        End Try

        ' Set the Function Return value.
        Return lReturn

    End Function

#End Region

End Module