Imports System.Collections
Imports System.Text
Imports System.Collections.Generic
Imports LRReportViewer.ReportWebService
Imports System.Net

Module Startup

   ' Public variables...
   Public gDatabaseVersion As Integer

   Public gMinimumDBVersionInt As Integer = 304
   Public gMinimumDBVersionText As String = "3.0.4"

   Public gAppPath As String
   Public gAppUserName As String
   Public gAppVersion As String = My.Application.Info.Version.ToString
   Public gConnectRetail As String
   Public gDefaultCasinoID As String
   Public gCentralServerEnabled As Boolean
   Public gCentralServerDatabaseName As String

   Public gReportServerURL As String
   Public gReportingServiceURL As String
   Public gReportPath As String
   Public gReportName As String
   Public gRetailServer As String
   Public gRetailDatabase As String
   Public gRetailUsername As String
   Public gRetailPassword As String
   Public gReportUsername As String
   Public gReportPassword As String
   Public gReportsFolder As String
   Public gReportDomain As String

   Public gNL As String = Environment.NewLine


   Sub Main(ByVal argv As String())
      '--------------------------------------------------------------------------------
      ' Application entry point.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Build connection strings.
      ' Run the application using MdiParent as the startup form.

      If Not TryCommandLineParmsForLogin() Then
         Environment.Exit(-1)
      End If


      

      

         Application.Run(New MdiParent)


   End Sub

   
   Private Function GetReportSettings() As Boolean
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing
      Dim lErrorText As String

      ' Hit the database
      Try
         lSDA = New SqlDataAccess(gConnectRetail, False)
         With lSDA
            lDT = .CreateDataTable("SELECT VALUE1 ,VALUE2 ,VALUE3 FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'LR_REPORT_VIEWER'")
         End With

         gReportServerURL = String.Format("http://{0}/ReportServer", lDT.Rows.Item(0)("VALUE1"))
         gReportingServiceURL = String.Format("http://{0}/ReportServer/ReportService2005.asmx", lDT.Rows.Item(0)("VALUE1"))
         gReportsFolder = lDT.Rows.Item(0)("VALUE2")

         lSDA = New SqlDataAccess(gConnectRetail, False)
         With lSDA
            lDT = .CreateDataTable("SELECT VALUE1 ,VALUE2 ,VALUE3 FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'LR_REPORT_VIEWER_USER'")
         End With

         gReportUsername = lDT.Rows.Item(0)("VALUE1")
         gReportPassword = lDT.Rows.Item(0)("VALUE2")

         If gReportUsername.Contains("\") OrElse gReportUsername.Contains("/") Then
            Dim splitStr As String() = gReportUsername.Replace("/", "\").Split("\")
            gReportUsername = splitStr(1)
            gReportDomain = splitStr(0)
         End If

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = "Startup::GetReportSettings error: " & ex.Message
         MessageBox.Show(lErrorText, "Login Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         Return False
      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Return True

   End Function
   

   Private Function TryCommandLineParmsForLogin() As Boolean
      'Format: /username:admin /password:Diamond1!
        'Dim inputUserNameArgPfx As String = "/username:"
        'Dim inputPasswordArgPfx As String = "/password:"
      Dim inputReportPathArgPfx As String = "/reportpath:"
      'Dim reportUsernamePrefix As String = "/reportusername:"
      'Dim reportPasswordPrefix As String = "/reportpassword:"
      'Dim reportServerPrefix As String = "/reportserver:"
      Dim retailServerPrefix As String = "/retailserver:"
      Dim retailDatabasePrefix As String = "/retaildatabase:"
      Dim retailUsernamePrefix As String = "/retailusername:"
      Dim retailPasswordPrefix As String = "/retailpassword:"
        'Dim inputUserName As String = ""
        'Dim inputPassword As String = ""
      Dim reportServerName As String = ""
      Dim lResult As Boolean = False
      'Dim lGetReports As Boolean = False
      Dim lAPE As New AppPasswordEncryption
      Dim tempstr As String = lAPE.EncryptPassword("5emperF!")


      For Each arg As String In My.Application.CommandLineArgs

         Dim argItem As String = arg.ToLower()

            'If argItem.StartsWith(inputUserNameArgPfx) Then
            '   inputUserName = arg.Remove(0, inputUserNameArgPfx.Length).Trim("""")

            'ElseIf argItem.StartsWith(inputPasswordArgPfx) Then
            '   inputPassword = arg.Remove(0, inputPasswordArgPfx.Length).Trim("""")

            If argItem.StartsWith(retailServerPrefix) Then
                gRetailServer = arg.Remove(0, retailServerPrefix.Length).Trim("""")

            ElseIf argItem.StartsWith(retailDatabasePrefix) Then
                gRetailDatabase = arg.Remove(0, retailDatabasePrefix.Length).Trim("""")

            ElseIf argItem.StartsWith(retailUsernamePrefix) Then
                gRetailUsername = arg.Remove(0, retailUsernamePrefix.Length).Trim("""")

            ElseIf argItem.StartsWith(retailPasswordPrefix) Then
                gRetailPassword = arg.Remove(0, retailPasswordPrefix.Length).Trim("""")



            ElseIf argItem.StartsWith(inputReportPathArgPfx) Then
                gReportPath = arg.Remove(0, inputReportPathArgPfx.Length).Trim("""")
                Dim splitStr As String() = gReportPath.Trim("\").Trim("/").Replace("/", "\").Split("\")
                gReportName = splitStr(splitStr.Length - 1)
                Dim nameIndex As Integer = gReportPath.LastIndexOf(gReportName)

                If nameIndex > 0 Then
                    gReportPath = gReportPath.Substring(0, nameIndex - 1).Trim("\").Trim("/")
                Else
                    gReportPath = ""
                End If

            End If
        Next

      Dim errorMessage As String = ""


      If (String.IsNullOrWhiteSpace(gRetailServer)) Then
         errorMessage &= "Retail server argument missing or invalid format." & Environment.NewLine
      End If

      If (String.IsNullOrWhiteSpace(gRetailDatabase)) Then
         errorMessage &= "Retail database argument missing or invalid format." & Environment.NewLine
      End If

      If (String.IsNullOrWhiteSpace(gRetailUsername)) Then
         errorMessage &= "Retail username argument missing or invalid format." & Environment.NewLine
      End If

      If (String.IsNullOrWhiteSpace(gRetailPassword)) Then
         errorMessage &= "Retail password argument missing or invalid format." & Environment.NewLine
      End If

        'If (String.IsNullOrWhiteSpace(inputUserName)) Then
        '   errorMessage &= "Username argument missing or invalid format." & Environment.NewLine
        'End If

        'If (String.IsNullOrWhiteSpace(inputPassword)) Then
        '   errorMessage &= "Password argument missing or invalid format." & Environment.NewLine
        'End If

      If (String.IsNullOrWhiteSpace(gReportName)) Then
         errorMessage &= "ReportName argument missing or invalid format." & Environment.NewLine
      End If


      If (String.IsNullOrWhiteSpace(errorMessage) = False) Then
            errorMessage = errorMessage & Environment.NewLine & "Application will now terminate."
         MessageBox.Show(errorMessage, "Startup Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
         Environment.Exit(-1)

      End If

      BuildConnections()

        'If inputUserName.Length > 0 And inputPassword.Length > 0 Then
        'HandleLogin(inputUserName, inputPassword, False)
        GetReportSettings()
        lResult = True
        'End If
        ' Set the function return value.
        Return lResult
   End Function

   


   Private Sub HandleLogin(ByVal Username As String, ByVal Password As String, Optional hashPassword As Boolean = True)
      '--------------------------------------------------------------------------------
      ' Handles login request.
      '--------------------------------------------------------------------------------
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDR As DataRow = Nothing

      Dim lErrorText As String
      Dim lUserMsg As String
      Dim lSQL As String
      Dim lhashedPassword As String = Password

      Dim lActiveAcct As Boolean
      Dim lAMatch As Boolean
      Dim lPMatch As Boolean
      Dim lDgeTech As Boolean

      Dim lResult As Integer

      ' Initialize the minimum Report Viewer version to the
      ' max value of an integer, it will be reset below.
      'mMinRvVersion = Integer.MaxValue
#If DEBUG Then
      lhashedPassword = MD5Hasher.GetMd5Hash(Password)
#End If
      If hashPassword Then
         lhashedPassword = MD5Hasher.GetMd5Hash(Password)
      End If

      Try
         ' Hit the database
         lSDA = New SqlDataAccess(gConnectRetail, False)
         With lSDA
            ' Add Parameters...
            .AddParameter("@AccountID", SqlDbType.VarChar, Username, 10)
            .AddParameter("@Password", SqlDbType.NVarChar, lhashedPassword, 128)

            ' Execute diHandleLogin.
            lDT = .CreateDataTableSP("diHandleLogin")

            '' Assign result to local variable.
            'lResult = .ReturnValue
         End With

         If lDT.Rows.Count > 0 Then
            lDR = lDT.Rows(0)
            ' diHandleLogin returns a minimum Report Viewer version value.

            lAMatch = lDR.Item("AMATCH")
            lPMatch = lDR.Item("PMATCH")
            lActiveAcct = lDR.Item("ACTIVE")
            lDgeTech = lDR.Item("IS_DGE_TECH")

            If (lAMatch AndAlso lPMatch AndAlso lActiveAcct) Then
               lResult = 1
            Else
               lResult = 0
            End If

         End If

         ' Successful login?
         If lResult = 0 Then
            ' Notify of failed login.
            If lDT.Columns.Contains("AMATCH") Then
               ' DB versions 6.0.1 and higher return more info...
               If lAMatch = False Then
                  lUserMsg = "Invalid Account or Password."
               ElseIf lPMatch = False Then
                  lUserMsg = "Invalid Account or Password."
               ElseIf lActiveAcct = False Then
                  lUserMsg = "Invalid Account or Password."
               Else
                  lUserMsg = "Invalid Account or Password."

               End If
            Else
               ' DB versions before 6.0.1 will only succeed or fail.
               lUserMsg = "Invalid Username or Password."
            End If


            MessageBox.Show(lUserMsg, "Login Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

            Environment.Exit(-1)

         End If

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = "Startup::HandleLogin error: " & ex.Message
         MessageBox.Show(lErrorText, "Login Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         Environment.Exit(-1)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Sub BuildConnections()
      '--------------------------------------------------------------------------------
      ' Builds the ConnectionString values using config file entries.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lKeyValueHash As New Hashtable
      Dim lSB As StringBuilder = Nothing
      Dim lAPE As New AppPasswordEncryption

      Dim lDBServer As String = ""
      Dim lDBCatalog As String
      Dim lDBUserID As String = ""
      Dim lDBPassword As String = ""
      Dim lErrorText As String = ""

      ' Build the LotteryRetail database connection string...
      If lErrorText.Length = 0 Then
         Try
            'With My.Settings
            '   lDBServer = .DatabaseServer
            '   lDBCatalog = .LotteryRetailDBCatalog
            '   lDBUserID = .DatabaseUserID
            '   lDBPassword = lAPE.DecryptPassword(.DatabasePassword)
            'End With

            lDBServer = gRetailServer
            lDBCatalog = gRetailDatabase
            lDBUserID = gRetailUsername
            lDBPassword = lAPE.DecryptPassword(gRetailPassword)

            lSB = New StringBuilder(128)
            With lSB
               '.Remove(0, lSB.Length)
               .Append("server=").Append(lDBServer)
               .Append(";database=").Append(lDBCatalog)
               .Append(";User ID=").Append(lDBUserID)
               .Append(";Password=").Append(lDBPassword)
            End With

            gConnectRetail = lSB.ToString

         Catch ex As Exception
            ' Handle the exception...
            lErrorText = "Startup::BuildConnections error building LotteryRetail connection string."
            Environment.Exit(-1)
         End Try
      End If

      ' If an error occurred, log it and then show it...
      If lErrorText.Length > 0 Then
         MessageBox.Show(lErrorText, "BuildConnections Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Friend Function GetAppVersionInt() As Integer
      '--------------------------------------------------------------------------------
      ' Returns the version of this application converted to an integer value.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lIndex As Integer
      Dim lReturn As Integer = 0
      Dim lMultiplier As Short = 1000
      Dim lVersionFields() As String

      ' Store the application version fields in a string array.
      lVersionFields = My.Application.Info.Version.ToString.Split(".".ToCharArray)

      For lIndex = 0 To 3
         lReturn += lMultiplier * Integer.Parse(lVersionFields(lIndex))
         lMultiplier \= 10
      Next

      ' Set the function return value.
      Return lReturn

   End Function

End Module
