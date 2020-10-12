Imports System.IO
Imports System.IO.Ports
Imports System.Text
Imports System.Security.Cryptography
Imports System.Globalization

Public Class Authorization

    Private mRng As Random

    Private mCOMport As SerialPort

    Private mCancelSession As Boolean
    Private mPrintingSession As Boolean

    Private mVoucherAmount As Decimal
    Private mVoucherTitle As String

    Private mExpirationDays As Integer
    Private mQuantity As Integer
    Private mSessionID As Integer

    Private mCityStateZip As String
    Private mLocationName As String
    Private mPrinterStatus As String
    Private mLanguage As String
    Private mPrintValue1 As String
    Private mPrintValue2 As String
    Private mPrintValue3 As String
    Private mPrintValue4 As String
    Private mPrintValue5 As String
    Private mPrintValue6 As String
    Private mPrintValue7 As String
    Private mPrintValue8 As String
    Private mPrintValue9 As String


    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        '--------------------------------------------------------------------------------
        ' Click event for the Cancel button.
        '--------------------------------------------------------------------------------

        ' Is the application running a print session? 
        If mPrintingSession = False Then
            ' No, ok to close.
            Me.Close()
        Else
            ' Yes, set member variable to true and wait to finish the current voucher before closing the window.
            mCancelSession = True
        End If

    End Sub

    Private Function ValidateUserGroups(lUserGroup1 As String, lUserGroup2 As String, ByRef aErrorText As String) As Boolean
        lUserGroup1 = lUserGroup1.ToLower()
        lUserGroup2 = lUserGroup2.ToLower()
        Dim lReturn As Boolean = gElevatedGroups.Contains(lUserGroup1) AndAlso gElevatedGroups.Contains(lUserGroup2)
        If Not lReturn AndAlso (mExpirationDays > gSupervisorMaxExpirationDays OrElse mVoucherAmount * 100 > gSupervisorMaxCents) Then
            lReturn = (gSupervisorGroups.Contains(lUserGroup1) OrElse gSupervisorGroups.Contains(lUserGroup2)) AndAlso (gElevatedGroups.Contains(lUserGroup1) OrElse gElevatedGroups.Contains(lUserGroup2))
            If Not lReturn Then
                aErrorText = "Users do not have the required group permissions to print the entered voucher values. Please see information text for the correct user groups." 'String.Format("Users must have the correct group permissions to print the entered voucher values. The following user types are needed to print the entered values: {0}0 or 1: {1}{0}1 to 2: {2}", Environment.NewLine, String.Join(", ", gSupervisorGroups), String.Join(", ", gElevatedGroups))
                ErrProvider.SetError(txtUserName1, aErrorText)
                ErrProvider.SetError(txtUserName2, aErrorText)
            End If
        ElseIf Not lReturn Then
            lReturn = (gSupervisorGroups.Contains(lUserGroup1) OrElse gElevatedGroups.Contains(lUserGroup1)) AndAlso (gSupervisorGroups.Contains(lUserGroup2) OrElse gElevatedGroups.Contains(lUserGroup2))
            If Not lReturn Then
                aErrorText = "Users do not have the required group permissions to print the entered voucher values. Please see information text for the correct user groups."
                ErrProvider.SetError(txtUserName1, aErrorText)
                ErrProvider.SetError(txtUserName2, aErrorText)
            End If
        End If
        Return lReturn
    End Function

    Private Sub btnPrint_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPrint.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Print button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lPrinterStatus As PrinterStatus

        Dim lErrorText As String = ""
        Dim lSuccessText As String = ""
        Dim lValidationID As String = ""
        Dim lUserGroup1 As String = ""
        Dim lUserGroup2 As String = ""


        ' Do the textbox controls have data?
        If FormHasData(lErrorText) Then

            ' Are the AccountIDs different?
            If DifferentUsers() Then
                lUserGroup1 = AuthenticateUser(txtUserName1, txtPassword1, lErrorText)
                ' Authenticate the first AccountID and Password.
                If Not String.IsNullOrEmpty(lErrorText) Then
                    ErrProvider.SetError(txtUserName1, lErrorText)
                    ErrProvider.SetError(txtPassword1, lErrorText)
                End If
                If lUserGroup1 <> "NONE" Then
                    lUserGroup2 = AuthenticateUser(txtUserName2, txtPassword2, lErrorText)
                    ' Authenticate the second AccountID and Password.
                    If Not String.IsNullOrEmpty(lErrorText) Then
                        ErrProvider.SetError(txtUserName2, lErrorText)
                        ErrProvider.SetError(txtPassword2, lErrorText)
                    End If
                    If lUserGroup2 <> "NONE" AndAlso ValidateUserGroups(lUserGroup1, lUserGroup2, lErrorText) Then

                        ' Get printer status.
                        lPrinterStatus = GetPrinterStatus()
                        If lPrinterStatus.Busy = False AndAlso lPrinterStatus.PrinterError = False Then
                            ' Good to go...

                            ' Insert a Promo Voucher Session into the PromoVoucherSession table.
                            If InsertPromoVoucherSession(lErrorText) Then

                                ' Insert a Voucher into the Voucher table.
                                If InsertVoucher(lErrorText) Then

                                    ' Show success message box.
                                    If mQuantity = 1 Then
                                        lSuccessText = String.Format("Successfully printed {0} voucher.", mQuantity)
                                    Else
                                        lSuccessText = String.Format("Successfully printed {0} vouchers.", mQuantity)
                                    End If
                                    Logging.Log(lSuccessText)
                                    MessageBox.Show(lSuccessText, "Printing Status", MessageBoxButtons.OK)

                                    ' Close the window.
                                    Me.Close()
                                    ' Close the COMPort
                                    CloseCOMPort()

                                Else
                                    ' Close the window.
                                    Me.Close()
                                    ' Close the COMPort
                                    CloseCOMPort()

                                End If
                            End If

                        Else
                            ' Printer Error...
                            lErrorText = String.Format("Printer error, check printer and try again. Error:{0}", mPrinterStatus)

                            ' Enable the print button and allow user check printer and try again.
                            btnPrint.Enabled = True

                        End If
                    End If
                End If
            End If
        End If

        ' Are there any errors?
        If lErrorText.Length > 0 Then
            ' Yes, show them.
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Authorization Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

    End Sub

    Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        '--------------------------------------------------------------------------------
        ' Load event handler for this Form.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lErrorText As String = ""

        SetLanguage()

        ' Set private member variables.
        mCancelSession = False
        mPrintingSession = False

        ' Initialize the DGESmartForm class
        InitializeBase()

        ' Set Location member variables.
        GetLocationInfo()

        ' Seed the Random # generator for Barcodes.
        mRng = New Random(Convert.ToInt32(Date.Now.Ticks And Integer.MaxValue))

        ' Hide the progress bar.
        progressStatus.Visible = False

        ' Build the txtMessage textbox message.

        If (mExpirationDays > gSupervisorMaxExpirationDays OrElse mVoucherAmount * 100 > gSupervisorMaxCents) Then
            txtMessage.Text = String.Format("The user groups listed below are necessary for printing the entered voucher values. {0}Zero or one of the following: {1}{0}One or two of the following: {2}", Environment.NewLine, String.Join(", ", gSupervisorGroups), String.Join(", ", gElevatedGroups))
        Else
            txtMessage.Text = String.Format("The user groups listed below are necessary for printing the entered voucher values. {0}Zero to two of the following: {1}{0}Zero to two of the following: {2}", Environment.NewLine, String.Join(", ", gSupervisorGroups), String.Join(", ", gElevatedGroups))
        End If

        txtMessage.Text = String.Format(txtMessage.Text & _
                          "{0}{0}{4} Voucher Summary{0}Voucher Amount: {1}{0}Quantity: {2} {0}Expirations Days:{3}", gCrLf, mVoucherAmount, mQuantity, mExpirationDays, My.Settings.ApplicationTitle)

    End Sub

    Private Sub SetLanguage()
        Dim lSQL As String
        Dim lDT As DataTable
        Dim lLanguageCode As String

        mLanguage = "English"

        lSQL = "SELECT ISNULL(VALUE2, 'EN') AS LanguageCode FROM dbo.CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'COUNTRY_CODE'"

        Using lSDA As New SqlDataAccess(gConnectionString)
            lDT = lSDA.CreateDataTable(lSQL)
        End Using

        If lDT.Rows.Count > 0 Then
            lLanguageCode = lDT.Rows(0).Item(0)
            If lLanguageCode.Length > 0 Then
                If lLanguageCode = "FR" Then
                    mLanguage = "French"
                End If
            End If
        End If

    End Sub

    Private Sub CloseCOMPort()
        '--------------------------------------------------------------------------------
        ' Close the COMport.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...

        If mCOMport.IsOpen = True Then
            ' Close Serial Port connection.
            mCOMport.Close()
        End If

    End Sub

    Private Sub GetLocationInfo()
        '--------------------------------------------------------------------------------
        ' Call stored procedure to record the version of this application.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing
        Dim lDT As DataTable
        Dim lDR As DataRow

        Dim lErrorText As String
        Dim lSQL As String

        Try

            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectionString, False, 90)

            ' Determine if the APP_INFO table exists in the database...
            lSQL = "SELECT CAS_NAME, ISNULL(CITY, '') + ' / ' + ISNULL(STATE, '') + ' / ' + ISNULL(ZIP, '')" & _
                   "AS CITYSTATEZIP FROM CASINO WHERE SETASDEFAULT = 1"
            lDT = lSDA.CreateDataTable(lSQL)

            If lDT.Rows.Count > 0 Then
                lDR = lDT.Rows(0)

                mLocationName = lDR.Item("CAS_NAME")
                mCityStateZip = lDR.Item("CITYSTATEZIP")
            End If

        Catch ex As Exception
            ' Handle the exception, build the error text and write it to the EventLog...
            lErrorText = Me.Name & "::GetLocationInfo error: " & ex.Message
            Logging.Log(lErrorText)

            ' Cleanup...
            If lSDA IsNot Nothing Then
                lSDA.Dispose()
                lSDA = Nothing
            End If
        End Try

    End Sub

    Private Sub SetPrintValues()
        Dim lDateAndTime As DateTime
        Dim lCurrencyFormat As String

        lDateAndTime = DateTime.Now

        Select Case mLanguage
            Case "French"

                Dim lCultureInfo As New CultureInfo("fr-CA")
                lCurrencyFormat = mVoucherAmount.ToString("c", lCultureInfo)

                mPrintValue1 = "COUPON PROMO"
                ' mPrintValue2 = "Émission"
                mPrintValue2 = "Emission"
                mPrintValue3 = "Billet "
                'mPrintValue4 = String.Format("Nul après {0} jours", mExpirationDays)
                mPrintValue4 = String.Format("Nul apres {0} jours", mExpirationDays)
                mPrintValue5 = String.Format("{0}", lCurrencyFormat)
                mPrintValue6 = "Appareil: Type B"
                mPrintValue7 = String.Format("{0:dd/MM/yyyy}", lDateAndTime)
                mPrintValue8 = String.Format("{0:HH:mm:ss}", lDateAndTime)
                'mPrintValue9 = "Non monnayable-Modalités au verso"
                mPrintValue9 = "Non monnayable-Modalites au verso"

            Case "English"
                mPrintValue1 = My.Settings.VoucherTitle
                mPrintValue2 = "Validation"
                mPrintValue3 = "Ticket # "
                mPrintValue4 = String.Format("Void after {0} days", mExpirationDays)
                mPrintValue5 = String.Format("{0:c}", mVoucherAmount)
                mPrintValue6 = gComputerName
                mPrintValue7 = String.Format("{0:MM/dd/yyyy}", lDateAndTime)
                mPrintValue8 = String.Format("{0:HH:mm:ss}", lDateAndTime)
                mPrintValue9 = "No Cash Value"
        End Select

    End Sub

    Private Sub PrintVoucher(ByVal aValidationID As String, ByVal aVoucherID As Integer)
        '--------------------------------------------------------------------------------
        ' Print the voucher.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lCommandString As String
        Dim lErrorText As String
        Dim lStatus As String = ""

        Dim lValidationID As String

        Try

            SetPrintValues()

            ' Format ValidationID
            lValidationID = String.Format("{0:0-000-000-00-00000-000-0}", ULong.Parse(aValidationID))

            ' Build command string to send printer.
            lCommandString = "^P|9|1|{0}|{13}|{1}|{2}|{9}|{10}|{0}|{3}|{12}|{11}{4}|| |{5}|{6}|{7}|{8}|^"
            lCommandString = String.Format(lCommandString, lValidationID, mLocationName, mCityStateZip, mPrintValue7, aVoucherID, mPrintValue5, _
                                           mPrintValue4, mPrintValue6, aValidationID, mPrintValue1, mPrintValue2, mPrintValue3, mPrintValue8, mPrintValue9)

            ' Send printer print command.
            WriteToCOMPort(lCommandString)

        Catch ex As Exception
            ' Handle the exception.  Build the error text.
            lErrorText = Me.Name & "::PrintVoucher error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Print Voucher Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

    End Sub

    Private Function AuthenticateUser(ByVal aUsername As TextBox, ByVal aPassword As TextBox, ByRef aErrorText As String) As String
        '--------------------------------------------------------------------------------
        ' Function to authenticate user.
        ' Returns True or False to indicate success or failure.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDT As DataTable
        Dim lErrorText As String = ""
        Dim lLevelCode As String
        Dim lIsValid As Boolean
        'Dim lLoginAttemptsLeft As Integer
        Dim lAccountLocked As Boolean

        Dim lReturn As String = "NONE"
        Dim lInvalidUsers(3) As String


        lInvalidUsers = {"ADMIN", "ADMINISTRATOR", "SUPER", "SUPERVISOR"}

        ' Is the first AccountID a generic admin or supervisor account?
        If Array.IndexOf(lInvalidUsers, aUsername.Text.ToUpper) = -1 Then

            Try

                Using lSDA As New SqlDataAccess(gConnectionString, False, 90)
                    lSDA.AddParameter("@AccountID", SqlDbType.VarChar, aUsername.Text, 10)
                    lSDA.AddParameter("@Password", SqlDbType.VarChar, MD5Hasher.GetMd5Hash(aPassword.Text), 128)
                    lDT = lSDA.CreateDataTableSP("LRAS_AuthenticateUser")
                End Using

                ' Is the account locked?
                lAccountLocked = lDT.Rows(0).Item(2)
                If lAccountLocked Then
                    lErrorText = "The Account ID is locked. Please see your Administrator."
                    ErrProvider.SetError(aUsername, aErrorText)
                    aUsername.Focus()
                    Throw New Exception(lErrorText)
                End If

                ' Is the user valid?
                lIsValid = lDT.Rows(0).Item(1)
                If lIsValid = False Then
                    lErrorText = "Invalid Account ID or Password."
                    ErrProvider.SetError(aUsername, aErrorText)
                    aUsername.Focus()
                    Throw New Exception(lErrorText)
                End If

                '' Is the user password valid?
                'lIsValid = lDT.Rows(0).Item(0)
                'lLoginAttemptsLeft = lDT.Rows(0).Item(4) - lDT.Rows(0).Item(3)
                'If lIsValid = False Then
                '   lErrorText = String.Format("Invalid Password. You have {0} attempt(s) left to correctly enter your password or your account will be locked out.", lLoginAttemptsLeft)
                '   ErrProvider.SetError(aPassword, aErrorText)
                '   aUsername.Focus()
                '   Throw New Exception(lErrorText)
                'End If

                ' Is the user active?
                lIsValid = lDT.Rows(0).Item(5)
                If lIsValid = False Then
                    lErrorText = "Deactivated Account ID."
                    ErrProvider.SetError(aUsername, aErrorText)
                    aUsername.Focus()
                    Throw New Exception(lErrorText)
                End If

                ' Does the user have Admin or Supervisor permissions?
                lLevelCode = lDT.Rows(0).Item(8)
		lReturn = lLevelCode

                

            Catch ex As Exception
                ' Handle the exception. Build the error text, then log and show it...
                aErrorText = ex.Message
                Logging.Log(aErrorText)
            End Try

        Else
            ' AccountID cannot be a generic admin or supervisor account.
            aErrorText = "Generic administrative user accounts may not be used for authorization."
            ErrProvider.SetError(aUsername, aErrorText)
            aUsername.Focus()
        End If

        ' Set Function return value.
        Return lReturn

    End Function

    Private Function CharToInt(ByVal aChar As Char) As Integer
        '--------------------------------------------------------------------------------
        ' Convert a char to its ASCII integer value.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...

        Return Convert.ToInt32(aChar)

    End Function

    Private Function CreateValidationID() As String
        '--------------------------------------------------------------------------------
        ' Uses the current MilliSecond as seed to generated a random # between 1-2000.
        ' It then add/subtracts this to the current year. Then converts that date into Ticks.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lCurrentDateTime As DateTime
        Dim lNewDateTime As DateTime

        Dim lIndex As Short
        Dim lRandomValue As Integer
        Dim lTicks As Long

        Dim lErrorText As String = ""
        Dim lReturn As String = ""


        Try

            ' Try 10 times to get a voucher without duplicates.
            For lIndex = 1 To 100
                lCurrentDateTime = DateTime.Now

                ' Generate a random value in the range 1-2000.
                lRandomValue = mRng.Next(1, 2001)

                If (lRandomValue > 1000) Then
                    ' Add all years over a 1000 to the current year to obtain the NewTime.
                    lNewDateTime = lCurrentDateTime.AddYears(lRandomValue - 1000)
                Else
                    ' Subtract this from the current year to obtain the NewTime.
                    lNewDateTime = lCurrentDateTime.AddYears(-lRandomValue)
                End If

                ' Convert the NewTime to TICKS
                lTicks = lNewDateTime.Ticks + 999

                ' Now check to see if this barcode ALREADY exists in the database.
                If Not ValidationIDExist(lTicks.ToString) Then
                    ' Unique barcode found, set the return value.
                    lReturn = lTicks.ToString

                    ' Exit the search for duplicates loop.
                    Exit For
                Else
                    ' Set New barcode to empty string to indicate failure.
                    lReturn = ""
                End If
                ' Since we are here, a Duplicate Barcode was found.
                ' Create a new sequence of random values by creating a new instance of Random with a new seed value.
                mRng = New Random(Convert.ToInt32(Date.Now.Ticks And Integer.MaxValue))
            Next

        Catch ex As Exception
            ' Handle the exception. Build the error text, then log and show it...
            lErrorText = Me.Name & "::CreateValidationID error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Print Voucher Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

            ' Set New barcode to empty string to indicate failure.
            lReturn = ""
        End Try

        ' Return the new Barcode as string
        Return lReturn

    End Function

    Private Function CreateVoucherCheckValue(ByVal aValidationID As String, ByVal aVoucherAmount As Long) As Byte()
        '--------------------------------------------------------------------------------
        ' Creates a CheckValue byte array used to validate a voucher.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lCheckSum As Int32 = 0
        Dim lIndex As Int32

        Dim lBuffer As String
        Dim lBarcodeData As String

        ' Convert arguments to strings and concatenate them...
        lBarcodeData = CType(aValidationID, String)
        lBuffer = lBarcodeData & aVoucherAmount.ToString & "0"

        ' Walk the concatenated string and add the value of each digit...
        For lIndex = 0 To lBuffer.Length - 1
            lCheckSum += Int32.Parse(lBuffer.Chars(lIndex))
        Next

        ' Convert the checksum to a string with a minimum length of 3 characters.
        lBuffer = lCheckSum.ToString("000")

        ' Return the function return value.
        Return EncryptText(lBuffer)

    End Function

    Private Function DifferentUsers() As Boolean
        '--------------------------------------------------------------------------------
        ' Function to check that users are not the same.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As Boolean = True

        Dim lErrorText As String = ""

        Try
            ' Compare the users to make sure they are not the same...
            If String.Compare(txtUserName1.Text.ToLower, txtUserName2.Text.ToLower) = 0 Then
                lErrorText = "Authorization users must me different."
                MessageBox.Show(lErrorText, "Authenticate User Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

                ' Set the error provider.
                ErrProvider.SetError(txtUserName1, lErrorText)
                ErrProvider.SetError(txtUserName2, lErrorText)

                ' Set the return value.
                lReturn = False

            End If

        Catch ex As Exception
            ' Handle the exception. Build the error text, then log and show it...
            lErrorText = Me.Name & "::DifferentUsers error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Print Voucher Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function EncryptText(ByVal aClearText As String) As Byte()
        '--------------------------------------------------------------------------------
        ' EncryptCheckValue function
        ' Takes a ClearText string and returns an encrypted Byte array.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSize As Long
        Dim lIntSize As Integer

        Dim lKey() As Byte = {10, 20, 30, 40, 50, 100, 90, 80, 70, 60, 111, 222, 31, 44, 57, 105, 9, 8, 7, 216, 11, 12, 138, 14}
        Dim lIV() As Byte = {25, 32, 14, 88, 66, 13, 44, 99}

        Dim lTripleDesCSP As New TripleDESCryptoServiceProvider
        Dim lMS As New MemoryStream
        Dim lUTF8 As New UTF8Encoding

        Dim lInputBA() As Byte
        Dim lCT As ICryptoTransform
        Dim lCS As CryptoStream

        ' Populate the input byte array.
        lInputBA = lUTF8.GetBytes(aClearText)

        ' Call CreateEncryptor method of the TripleDESCryptoServiceProvider to create a new ICryptoTransform instance.
        lCT = lTripleDesCSP.CreateEncryptor(lKey, lIV)

        ' Create a new CryptoStream instance.
        lCS = New CryptoStream(lMS, lCT, CryptoStreamMode.Write)

        ' Fill the input buffer.
        lCS.Write(lInputBA, 0, lInputBA.Length)
        lCS.FlushFinalBlock()
        lMS.Position = 0

        ' Get the size of the memory stream and decrement it...
        lSize = lMS.Length
        lIntSize = CType(lSize, Integer)

        Dim lReturn(lIntSize - 1) As Byte

        ' Load the return array.
        lMS.Read(lReturn, 0, lIntSize)
        lCS.Close()

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function FormHasData(ByRef aErrorText As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Function to check to check fields for data.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As Boolean = True

        Dim lErrorText As String = ""

        ' Check the txtUsername1 textbox control for text.
        If txtUserName1.TextLength = 0 Then
            lErrorText = "Must enter a Username."
            aErrorText &= lErrorText
            ' Set the return value.
            lReturn = False
        End If

        ' Set the error provider.
        ErrProvider.SetError(txtUserName1, lErrorText)
        lErrorText = ""

        ' Check the txtPassword1 textbox control for text.
        If txtPassword1.TextLength = 0 Then
            lErrorText = "Must enter a password."
            If aErrorText.Length > 0 Then aErrorText &= gCrLf
            aErrorText &= lErrorText
            ' Set the return value.
            lReturn = False
        End If

        ' Set the error provider.
        ErrProvider.SetError(txtPassword1, lErrorText)
        lErrorText = ""

        ' Check the txtUserName2 textbox control for text.
        If txtUserName2.TextLength = 0 Then
            lErrorText = "Must enter a Username."
            If aErrorText.Length > 0 Then aErrorText &= gCrLf
            aErrorText &= lErrorText
            ' Set the return value.
            lReturn = False
        End If

        ' Set the error provider.
        ErrProvider.SetError(txtUserName2, lErrorText)
        lErrorText = ""

        ' Check the txtPassword2 textbox control for text.
        If txtPassword2.TextLength = 0 Then
            lErrorText = "Must enter a password."
            If aErrorText.Length > 0 Then aErrorText &= gCrLf
            aErrorText &= lErrorText
            ' Set the return value.
            lReturn = False
        End If

        ' Set the error provider.
        ErrProvider.SetError(txtPassword2, lErrorText)

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function GetPrinterErrorText(ByVal aPrinterStatus As PrinterStatus) As String
        '--------------------------------------------------------------------------------
        '  Return printer error text based on printer status.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As String = ""

        ' Printer paper is jammed
        If aPrinterStatus.Jammed = True Then
            lReturn = "Paper jammed."
        End If

        ' Printer is offline.
        If aPrinterStatus.Offline = True Then
            If lReturn.Length > 0 Then lReturn &= " - "
            lReturn &= "Printer offline."
        End If

        ' Printer is out of paper.
        If aPrinterStatus.OutOfPaper = True Then
            If lReturn.Length > 0 Then lReturn &= " - "
            lReturn &= "Printer out of paper."
        End If

        ' Generic printer error.
        If aPrinterStatus.PrinterError = True Then
            If lReturn.Length > 0 Then lReturn &= " - "
            lReturn &= String.Format("Printer Error code: {0}", mPrinterStatus)
        End If

        ' Generic printer error.
        If aPrinterStatus.TopOfForm = False Then
            If lReturn.Length > 0 Then lReturn &= " - "
            lReturn &= "Check paper."
        End If

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function GetPrinterStatus() As PrinterStatus
        '--------------------------------------------------------------------------------
        ' Checks printer status and returns a PrinterStatus object with
        ' properties populated.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As New PrinterStatus

        Dim lField1 As Integer
        Dim lField2 As Integer
        Dim lField3 As Integer
        Dim lField4 As Integer
        Dim lField5 As Integer

        Dim lCommandString As String
        Dim lErrorText As String = ""
        Dim lExceptionError As String = ""
        Dim lFields() As String
        Dim lHexValue As String = "05"

        Try
            ' Build the command string to get the printer status.
            lCommandString = Char.ConvertFromUtf32(Convert.ToInt32(lHexValue, 16))

            ' Send printer status command.
            If WriteToCOMPort(lCommandString) Then

                Application.DoEvents()

                Threading.Thread.Sleep(100)

                ' Store printer status.
                mPrinterStatus = mCOMport.ReadExisting

                ' Did we receive a status?
                If mPrinterStatus.Length > 0 Then
                    ' Yes, split the returned printer status string into an array of field values.
                    lFields = mPrinterStatus.Split("|".ToCharArray)

                    ' Convert field values to ascii integer values...
                    lField1 = CharToInt(lFields(3))
                    lField2 = CharToInt(lFields(4))
                    lField3 = CharToInt(lFields(5))
                    lField4 = CharToInt(lFields(6))
                    lField5 = CharToInt(lFields(7))

                    ' Set the PrinterStatus properties...
                    With lReturn
                        .Busy = lField1 And 32
                        .OutOfPaper = lField1 And 4
                        .Offline = lField3 And 2
                        .Jammed = lField4 And 2
                        .TopOfForm = lField5 And 16
                        .PrintSuccess = lField5 And 32
                        .PrinterError = (lField1 And 27) Or (lField2 And 63) Or (lField3 And 53) Or (lField4 And 4) Or (lField5 And 4)
                    End With

                Else
                    ' No, unable to communicate with printer.
                    lReturn.Offline = True

                End If

            End If

        Catch ex As Exception
            ' Handle the exception.  Build the error text.
            lExceptionError = Me.Name & "::GetPrinterStatus error: " & ex.Message
            lErrorText = "Unable to communicate to printer. Check the connection and try again."
            Logging.Log(String.Format("{0} : {1}", lErrorText, lExceptionError))
            MessageBox.Show(lErrorText, " Serial Port Setup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function InsertPromoVoucherSession(ByRef aErrorText As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Function to Insert row into the PROMO_VOUCHER_SESSION table.
        ' Returns T or False to indicate success or failure.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing

        Dim lReturn As Boolean = False

        Dim lResult As Integer

        Dim lErrorText As String = ""
        Dim lUserName1 As String = txtUserName1.Text
        Dim lUserName2 As String = txtUserName2.Text

        Try

            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectionString, False, 90)

            With lSDA
                .AddParameter("@AuthAccountID1", SqlDbType.VarChar, lUserName1, 10)
                .AddParameter("@AuthAccountID2", SqlDbType.VarChar, lUserName2, 10)
                .AddParameter("@VoucherAmount", SqlDbType.Decimal, mVoucherAmount)
                .AddParameter("@VoucherCount", SqlDbType.VarChar, mQuantity)
                .AddParameter("@ExpirationDays", SqlDbType.VarChar, mExpirationDays)
                .AddParameter("@Workstation", SqlDbType.VarChar, gComputerName, 64)
                .ExecuteProcedureNoResult("fpInsertPromoVoucherSession")
                lResult = .ReturnValue
            End With

            ' Did the insert fail?
            If lResult > 0 Then
                ' No, set the return value.
                lReturn = True
                mSessionID = lResult
                Logging.Log(String.Format("Begin print session, PromoSessionID:{0}. Authorizing Users:{1}, {2}", mSessionID, lUserName1, lUserName2))
            Else
                'Yes, set the error text.
                aErrorText = "Failed to insert row."
            End If

        Catch ex As Exception
            ' Handle the exception. Build the error text, then log and show it...
            lErrorText = Me.Name & "::InsertPromoVoucherSession error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Print Voucher Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

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

    Private Function InsertVoucher(ByRef aErrorText As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Function to insert and call print voucher method.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDT As DataTable = Nothing

        Dim lPrinterStatus As PrinterStatus

        Dim lStopWatch As Stopwatch

        Dim lCheckSum() As Byte

        Dim lActualPrinted As Integer
        Dim lCount As Integer
        Dim lIndex As Integer
        Dim lSpErrorID As Integer
        Dim lVoucherID As Integer

        Dim lVLAmount As Integer

        Dim lDbFailure As Boolean = False
        Dim lReturn As Boolean = False

        Dim lCreatedLoc As String = gComputerName
        Dim lWarningText As String = ""
        Dim lValidationID As String = ""

        Try
            ' Initialize error text to an empty string.
            aErrorText = ""

            ' Is the CreatedLoc name > than 16 characters?
            If lCreatedLoc.Length > 16 Then
                ' Yes, trim it to 16 characters.
                lCreatedLoc = lCreatedLoc.Substring(0, 16)
            End If

            ' Set textbox controls to ReadOnly.
            txtUserName1.ReadOnly = True
            txtPassword1.ReadOnly = True

            txtUserName2.ReadOnly = True
            txtPassword2.ReadOnly = True

            ' Disable the print button.
            btnPrint.Enabled = False

            With progressStatus
                ' Show the progress bar.
                .Visible = True
                'Set the max and step values
                .Maximum = mQuantity
                .Step = 1
            End With

            ' Outer For Loop to print vouchers...
            For lIndex = 1 To mQuantity
                lCount = 0
                lValidationID = ""
                lCheckSum = Nothing

                ' Set PrintingSession to True.
                mPrintingSession = True

                ' Did the user cancel the session?
                If mCancelSession = True Then
                    ' Yes, set error text and exirt For Loop.
                    aErrorText = "User cancelled session."
                    ' Exit For Loop.
                    Exit For
                End If

                ' Get printer status before printing.
                lPrinterStatus = GetPrinterStatus()

                If lPrinterStatus.Offline Then
                    ' Log error.
                    aErrorText = "Printer offline. Check printer connections and try again."

                    ' Exit For loop.
                    Exit For
                End If

                ' Check for printer out of paper...
                Do
                    ' Get printer status before printing.
                    lPrinterStatus = GetPrinterStatus()

                    If IsPrinterOutOfPaper(lPrinterStatus) Then
                        ' Log error.
                        aErrorText = "Failed to complete the printing session user aborted, printer out of paper."

                        ' Exit For loop.
                        Exit For
                    End If
                Loop While lPrinterStatus.OutOfPaper = True And aErrorText.Length = 0

                ' Check for printer jam...
                Do
                    ' Get printer status before printing.
                    lPrinterStatus = GetPrinterStatus()

                    If IsPrinterJammed(lPrinterStatus) Then
                        ' Log error.
                        aErrorText = "Failed to complete the printing session user aborted, printer jammed."

                        ' Exit loop.
                        Exit For
                    End If
                Loop While lPrinterStatus.Jammed = True And aErrorText.Length = 0

                ' Check for printer error...
                Do
                    ' Get printer status before printing.
                    lPrinterStatus = GetPrinterStatus()

                    If PrinterError(lPrinterStatus) Then
                        ' Log error.
                        aErrorText = String.Format("Failed to complete the printing session due to printer error: {0}.", mPrinterStatus)

                        ' Exit loop.
                        Exit For
                    End If
                Loop While lPrinterStatus.PrinterError = True And aErrorText.Length = 0

                ' Get a new Validation ID and insert a row into the VOUCHER table...
                Do While lValidationID.Length = 0 AndAlso lCount < 100
                    lCount += 1
                    lValidationID = CreateValidationID()

                    ' Create checksum...
                    lVLAmount = Convert.ToInt32(mVoucherAmount * 100)
                    lCheckSum = CreateVoucherCheckValue(lValidationID, lVLAmount)

                    Using lSDA = New SqlDataAccess(gConnectionString)

                        With lSDA
                            ' Add stored procedure parameters...
                            .AddParameter("@ValidationID", SqlDbType.VarChar, lValidationID, 18)
                            .AddParameter("@VoucherAmount", SqlDbType.Int, lVLAmount)
                            .AddParameter("@CreatedLoc", SqlDbType.VarChar, lCreatedLoc, 16)
                            .AddParameter("@VoucherType", SqlDbType.Int, 4)
                            .AddParameter("@CheckSum", SqlDbType.VarBinary, lCheckSum, lCheckSum.Length)
                            .AddParameter("@SessionPlayAmt", SqlDbType.Int, 0)
                            .AddParameter("@PromoVoucherSessionID", SqlDbType.Int, mSessionID)

                            ' Execute sp fpInsertVoucher
                            lDT = .CreateDataTableSP("fpInsertVoucher")
                        End With

                        If lDT IsNot Nothing Then
                            If lDT.Rows.Count > 0 Then
                                lSpErrorID = lDT.Rows(0).Item("ErrorID")
                                lVoucherID = lDT.Rows(0).Item("VoucherID")
                            Else
                                lSpErrorID = -1
                                lVoucherID = 0
                            End If
                        Else
                            lSpErrorID = -2
                            lVoucherID = 0
                        End If

                    End Using

                    ' Was the Voucher successfully inserted?
                    Select Case lSpErrorID
                        Case 0
                            ' Get printer status before printing.
                            lPrinterStatus = GetPrinterStatus()

                            ' Check for busy or printer error.
                            If lPrinterStatus.Busy = False AndAlso lPrinterStatus.PrinterError = False Then

                                ' No errors and not busy, so print the voucher.
                                PrintVoucher(lValidationID, lVoucherID)

                                lStopWatch = New Stopwatch
                                lStopWatch.Start()

                                ' Update progress bar after each insert.
                                progressStatus.PerformStep()

                                Do
                                    ' Allow user to click Cancel.
                                    Application.DoEvents()

                                    ' Check printer for Success status.
                                    lPrinterStatus = GetPrinterStatus()

                                    ' If inside the loop for over 30 seconds exit.
                                    If lStopWatch.Elapsed > TimeSpan.FromSeconds(30) Then
                                        aErrorText = "Printer status timeout."
                                        Exit Do
                                    End If
                                Loop While lPrinterStatus.Busy = True

                                lStopWatch.Stop()

                                If lPrinterStatus.PrintSuccess Then
                                    ' Update actual vouchers printed count.
                                    lActualPrinted = lActualPrinted + 1

                                    ' Update Voucher, Set IsActive True.
                                    If SetVoucherIsValid(lValidationID) = False Then
                                        ' Exit loop.
                                        Exit For
                                    End If

                                Else
                                    ' Get error text.
                                    aErrorText = GetPrinterErrorText(lPrinterStatus)
                                    ' Exit the loop.
                                    Exit For

                                End If
                            Else
                                ' Get error text.
                                aErrorText = GetPrinterErrorText(lPrinterStatus)
                                ' Exit the loop.
                                Exit For
                            End If

                        Case 701
                            ' ValidationID already exists.
                            aErrorText = "Voucher with the same ValidationID already exists."
                            lValidationID = ""

                        Case -2, -1
                            ' Either the connection is bad or the stored procedure did not return a row...
                            aErrorText = String.Format("TSQL Error {0} occurred while executing procedure InsertVoucher.", lSpErrorID)
                            Exit For

                        Case Else
                            ' TSQL Error Code
                            aErrorText = String.Format("TSQL Error {0} occurred while executing procedure InsertVoucher.", lSpErrorID)
                            Logging.Log(aErrorText)
                            lDbFailure = True
                            Exit Do

                    End Select
                Loop

                If lDbFailure Then
                    ' Log TSQL Error.
                    Logging.Log(aErrorText)
                    Exit For
                End If
            Next

            ' Update the printed Voucher count.
            If Not UpdatePrintedVoucherCount(lActualPrinted) Then
                aErrorText = "Print session was complete but failed to update the promo voucher session table with printed count."
                Logging.Log(aErrorText)
            End If

            ' Were all of the vouchers successfully printed?
            If lActualPrinted = mQuantity Then
                ' Yes
                lReturn = True
            Else
                ' No, set Warning text and show messagebox with actual printed count.
                ' Printed one voucher...
                If lActualPrinted = 1 Then
                    lWarningText = String.Format("Print session successfully printed {0} voucher.", lActualPrinted)

                    ' Printed more than one voucher.
                ElseIf lActualPrinted > 1 Then
                    lWarningText = String.Format("Print session successfully printed {0} vouchers.", lActualPrinted)

                End If

                ' Only show warning if vouchers were printed.
                If lWarningText.Length > 0 Then
                    Logging.Log(lWarningText)
                    MessageBox.Show(lWarningText, "Authorization Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                End If

            End If

        Catch ex As Exception
            ' Handle the exception.  Build the error text.
            aErrorText = Me.Name & "::InsertVoucher error: " & ex.Message & String.Format(" Actual vouchers printed {0}.", lActualPrinted)
            Logging.Log(aErrorText)
            MessageBox.Show(aErrorText, "Authorization Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

        ' Set Function return value.
        Return lReturn

    End Function

    Private Function IsPrinterJammed(ByVal aPrinterStatus As PrinterStatus) As Boolean
        '--------------------------------------------------------------------------------
        '  Checks printer for paper jam.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As Boolean = False

        Dim lUserMessage As String = ""

        ' Does the printer have paper?
        If aPrinterStatus.Jammed = True Then
            ' Have user load paper or bail out...
            lUserMessage = "Printer paper is jammed. Clear the jam and click 'Yes' to continue or click No to stop now."
            If MessageBox.Show(lUserMessage, "Printer Status", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = Windows.Forms.DialogResult.No Then
                lReturn = True
            End If
        End If

        'Set Function return value.
        Return lReturn

    End Function

    Private Function IsPrinterOutOfPaper(ByVal aPrinterStatus As PrinterStatus) As Boolean
        '--------------------------------------------------------------------------------
        '  Checks printer for paper.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As Boolean = False

        Dim lUserMessage As String = ""

        ' Does the printer have paper?
        If aPrinterStatus.OutOfPaper = True Then
            ' Have user load paper or bail out...
            lUserMessage = "Printer out of paper. Load more and click 'Yes' to continue or click 'No' to stop now."
            If MessageBox.Show(lUserMessage, "Printer Status", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = Windows.Forms.DialogResult.No Then
                lReturn = True
            End If
        End If

        'Set Function return value.
        Return lReturn

    End Function

    Private Function PrinterError(ByVal aPrinterStatus As PrinterStatus) As Boolean
        '--------------------------------------------------------------------------------
        '  Checks printer for error.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As Boolean = False

        Dim lErrorText As String = ""

        ' Does the printer have paper?
        If aPrinterStatus.PrinterError = True Then
            ' Have user load paper or bail out...
            lErrorText = "Failed to print due to printer error."
            Logging.Log(String.Format("{0}: {1}", lErrorText, mPrinterStatus))
            lReturn = True
        End If

        'Set Function return value.
        Return lReturn

    End Function

    Private Function SetVoucherIsValid(ByVal aValidation As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Function that updates vouchers as valid in the database.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDT As DataTable = Nothing
        Dim lSDA As SqlDataAccess = Nothing

        Dim lReturn As Boolean = False

        Dim lCount As Integer = 0

        Dim lErrorText As String = ""
        Dim lSQL As String

        Try

            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectionString, False, 90)

            ' Update the vouhcer, set IS_VALID = True in the database...
            lSQL = String.Format("UPDATE VOUCHER SET IS_VALID = 1 WHERE BARCODE = '{0}'", aValidation)

            lCount = lSDA.ExecuteSQLNoReturn(lSQL)

            ' Store the number of rows that were updated. 
            If lCount > 0 Then
                lReturn = True
            Else
                lErrorText = "Failed to set voucher as IS_VALID."
                Logging.Log(lErrorText)
            End If

        Catch ex As Exception
            ' Handle the exception. Build the error text.
            lErrorText = Me.Name & "::SetVoucherIsValid error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Authorization Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

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

    Private Function UpdatePrintedVoucherCount(ByVal aPrintedVoucherCount As Integer) As Boolean
        '--------------------------------------------------------------------------------
        ' Function to authenticate user.
        ' Returns True or False to indicate success or failure.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing

        Dim lReturn As Boolean = False

        Dim lSpReturnValue As Integer

        Dim lErrorText As String = ""


        Try
            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectionString, False, 90)

            With lSDA
                .AddParameter("@VouchersPrinted", SqlDbType.Int, aPrintedVoucherCount)
                .AddParameter("@PromoVoucherSessionID", SqlDbType.Int, mSessionID)
                .ExecuteProcedureNoResult("fpUpdatePromoVoucherSession")
                lSpReturnValue = .ReturnValue
            End With

            Select Case lSpReturnValue
                Case 0
                    ' Successfully updated the row.
                    lReturn = True
                Case -1
                    ' Row not found.
                    lErrorText = "Unable to update row. Row not found."
                Case Else
                    ' TSQL Error Code
                    lErrorText = String.Format("TSQL Error {0} occurred while executing procedure fpUpdatePromoVoucherSession.", lSpReturnValue)
                    Logging.Log(lErrorText)
            End Select

        Catch ex As Exception
            ' Handle the exception. Build the error text, then log and show it...
            lErrorText = Me.Name & "::UpdatePrintedVoucherCount error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Print Voucher Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

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

    Private Function ValidationIDExist(ByVal aValidationID As String) As Boolean
        '--------------------------------------------------------------------------------
        '   Purpose: Returns a TRUE or FALSE based upon if the new barcode already exists in the VOUCHER table.
        ' Called by: GetNewBarcode, DbTpInsertBarcode
        '     Calls: tpBarcodeAlreadyExists
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDT As DataTable = Nothing
        Dim lSDA As SqlDataAccess = Nothing

        Dim lReturn As Boolean = True

        Dim lCount As Integer = 0

        Dim lErrorText As String = ""


        Try
            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectionString, False, 90)

            With lSDA
                .AddParameter("@Barcode", aValidationID)
                lDT = .CreateDataTableSP("tpBarcodeAlreadyExists")

            End With

            ' Get the count of ValidationIDs in the 
            lCount = CType(lDT.Rows(0).Item(0), Integer)

            ' Set the return value.
            lReturn = (lCount > 0)

        Catch ex As Exception
            ' Handle the exception. Build the error text, then log and show it...
            lErrorText = Me.Name & "::ValidationIDExist error: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Print Voucher Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

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

    Private Function WriteToCOMPort(ByVal aCommandString As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Function that sends command string to the printer.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lReturn As Boolean = True

        Dim lErrorText As String = ""
        Dim lExceptionError As String = ""
        Dim lHandShake As String = My.Settings.COMHandShake
        Dim lParity As String = My.Settings.COMParity


        Try
            If mCOMport Is Nothing Then
                mCOMport = New SerialPort
            End If

            ' Is the COMPort open?
            If mCOMport.IsOpen = False Then
                ' No, So open it...
                With mCOMport
                    .PortName = My.Settings.COMPort
                    .BaudRate = My.Settings.COMBaudRate

                    Select Case lParity
                        Case "None"
                            .Parity = Parity.None

                        Case "Even"
                            .Parity = Parity.Even

                        Case "Odd"
                            .Parity = Parity.Odd
                    End Select

                    .StopBits = My.Settings.COMStopBits
                    .DataBits = My.Settings.COMDataBits

                    Select Case lHandShake
                        Case "XonXoff"
                            .Handshake = Handshake.XOnXOff

                        Case "None"
                            .Handshake = Handshake.None

                        Case "Hardware"
                            .Handshake = Handshake.RequestToSend
                    End Select

                End With

                ' Open Serial Port connection.
                mCOMport.Open()
            End If

            ' Send printer print command.
            mCOMport.Write(aCommandString)

        Catch ex As Exception

            lReturn = False

            ' Handle the exception.  Build the error text.
            lExceptionError = Me.Name & "::WriteToCOMPort error: " & ex.Message
            lErrorText = String.Format("Unable to open {0}. Check the connection settings and try again.", mCOMport.PortName)
            Logging.Log(String.Format("{0} : {1}", lErrorText, lExceptionError))
            MessageBox.Show(lErrorText, " Serial Port Setup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

        ' Set the fucntion return value.
        Return lReturn

    End Function

    Friend Property ExpirationDays() As Integer
        '--------------------------------------------------------------------------------
        ' Gets/sets the ExpirationsDays.
        '--------------------------------------------------------------------------------

        Get
            ExpirationDays = mExpirationDays
        End Get

        Set(ByVal Value As Integer)
            mExpirationDays = Value
        End Set

    End Property

    Friend Property Quantity() As Integer
        '--------------------------------------------------------------------------------
        ' Gets/sets the Quantity.
        '--------------------------------------------------------------------------------

        Get
            Quantity = mQuantity
        End Get

        Set(ByVal Value As Integer)
            mQuantity = Value
        End Set

    End Property

    Friend Property VoucherAmount() As Decimal
        '--------------------------------------------------------------------------------
        ' Gets/sets the Voucher Amount.
        '--------------------------------------------------------------------------------

        Get
            VoucherAmount = mVoucherAmount
        End Get

        Set(ByVal Value As Decimal)
            mVoucherAmount = Value
        End Set

    End Property

End Class