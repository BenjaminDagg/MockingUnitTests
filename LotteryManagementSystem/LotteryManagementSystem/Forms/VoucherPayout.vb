Imports System.Drawing.Printing
Imports System.Security.Cryptography
Imports System.IO
Imports System.Text

Public Class VoucherPayout

   ' [Class member variables]
   Private mReceiptData As ReceiptData
   Private mReceiptFont As Font
   Private mVoucherInfo As VoucherInfo

   Private mVoucherExpirationDays As Integer

   Private mReprintReceipt As Boolean

   Private Sub btnClear_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClear.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Clear button.
      '--------------------------------------------------------------------------------

      ' Clear the Voucher TextBox, that will cause clearing
      ' of the other TextBox and Label controls...
      With txtVoucher
         .Clear()
         .Focus()
      End With

   End Sub

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnPayout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPayout.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Payout button.
      '--------------------------------------------------------------------------------
      Dim lPrinterName As String = My.Settings.ReceiptPrinter

      ' Is the receipt printer valid?
      If IsPrinterValid(lPrinterName) Then
         ' Call the routine to payout the voucher and print receipt(s).
         If PayoutVoucher() Then
            ' Update the retail location.
            Call UpdateRetailVoucher()
         End If

      Else
         ' No, Show error message.
         MessageBox.Show(String.Format("The receipt printer {0} is invalid.", lPrinterName), "Printer Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End If

      ' Return focus to the Voucher TextBox control.
      txtVoucher.Focus()

   End Sub

   Private Sub btnReprint_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnReprint.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Payout button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lData As String
      Dim lErrorText As String

      Try
         ' Retrieve data from last printed receipt.
         lData = My.Settings.LastReceipt

         ' Set print receipt mode to reprint.
         mReprintReceipt = True

         ' Is the data good?
         If lData.Length >= 30 AndAlso lData.Contains(";") Then
            ' Yes, so reprint. Create a new instance of ReceiptData
            mReceiptData = New ReceiptData

            ' Set receipt properties using the settings data.
            mReceiptData.SetValuesFromSettingText(lData)

            ' Reset the receipt title to show it is a reprint.
            mReceiptData.ReceiptTitle = "Reprinted Receipt"

            ' Print it.
            Call PrintReceipt(mReceiptData.ReceiptTitle)

         ElseIf String.IsNullOrWhiteSpace(lData) Then
            ' Invalid data, cannot reprint, inform user.
            MessageBox.Show("There is no prior receipt avaliable reprint.", "Reprint Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         Else

            ' Invalid data, cannot reprint, inform user.
            MessageBox.Show("Invalid data for receipt reprint.", "Reprint Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         End If

      Catch ex As Exception
         ' Handle the exception.
         ' Build the error text, then log and show it...
         lErrorText = Me.Name & "::btnReprint_Click error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Reprint Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Return focus to the Voucher TextBox control.
         txtVoucher.Focus()

      End Try

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lPrinterName As String

      ' Get the receipt printer name.
      lPrinterName = My.Settings.ReceiptPrinter

      ' Is the receipt printer installed?
      If Not IsPrinterInstalled(lPrinterName) Then
         ' No, show warning.
         MessageBox.Show(String.Format("The receipt printer {0} is not installed.", lPrinterName), "Printer Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the Receipt Font.
      mReceiptFont = New Font("Tahoma", 8, FontStyle.Regular)

      ' Disable the Payout button.
      btnPayout.Enabled = False


   End Sub

   Private Sub txtVoucher_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles txtVoucher.KeyPress
      '--------------------------------------------------------------------------------
      ' Routine to handle KeyPress event for textbox controls that require only numeric
      ' entry values.
      '--------------------------------------------------------------------------------

      If Char.IsControl(e.KeyChar) = False AndAlso Char.IsDigit(e.KeyChar) = False Then
         e.Handled = True
      End If

   End Sub

   Private Sub txtVoucher_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtVoucher.TextChanged
      '--------------------------------------------------------------------------------
      ' TextChanged event handler for the Voucher TextBox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lValidationID As String = txtVoucher.Text

      Select Case lValidationID.Length
         Case 18
            ' 18 is the expected voucher validation ID length, get voucher info.
            Call GetVoucherInfo(lValidationID)

         Case Is < 18
            ' Make sure UI is cleared.
            Call ClearVoucherUI(True)

         Case Is > 18
            ' TextBox contains too many characters.
            Call ClearVoucherUI(False)
            lblUserInfo.Text = String.Format("Voucher Validation ID is too long.{0}Please clear the Voucher Validation text and re-scan.", gCrLf)

      End Select

   End Sub

   Private Sub TextBox_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) _
     Handles txtLocationName.KeyPress, txtVoucherAmount.KeyPress
      '--------------------------------------------------------------------------------
      ' Diable keypresses for Location and Voucher Amount TextBox controls.
      '--------------------------------------------------------------------------------

      e.Handled = True

   End Sub

   Private Sub ClearVoucherUI(ByVal aClearUserInfo As Boolean)
      '--------------------------------------------------------------------------------
      ' Routine to clear UI.
      '--------------------------------------------------------------------------------

      If btnPayout.Enabled Then btnPayout.Enabled = False
      If txtLocationName.TextLength > 0 Then txtLocationName.Text = ""
      If txtVoucherAmount.TextLength > 0 Then txtVoucherAmount.Text = ""
      If txtValidCheckSum.TextLength > 0 Then txtValidCheckSum.Text = ""
      If txtValidVoucher.TextLength > 0 Then txtValidVoucher.Text = ""
      If txtRedeemed.TextLength > 0 Then txtRedeemed.Text = ""
      pbStatus.Image = Nothing

      ' Are we supposed to clear User Info?
      If aClearUserInfo = True Then
         ' Yes, is there text to clear?
         If lblUserInfo.Text.Length > 0 Then
            ' Yes, so clear it.
            lblUserInfo.Text = ""
         End If
      End If

   End Sub

  

   Private Sub GetVoucherInfo(ByVal aValidationID As String)
      '--------------------------------------------------------------------------------
      ' Routine to retrieve Voucher information.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDT As DataTable = Nothing
      Dim lSDA As SqlDataAccess = Nothing

      Dim lRowCount As Integer

      Dim lErrorText As String
      Dim lSQL As String

      ' Build the SQL SELECT statement.
      lSQL = String.Format("SELECT * FROM uvwVoucherInfo WHERE BARCODE = '{0}'", aValidationID)

      ' Disable the Payout button and clear user info text...
      btnPayout.Enabled = False
      lblUserInfo.Text = ""

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectionString, False, 90)

         ' Execute the SQL SELECT statement.
         lDT = lSDA.CreateDataTable(lSQL, "VoucherInfo")
         lRowCount = lDT.Rows.Count

         Select Case lRowCount
            Case 0
               lblUserInfo.Text = String.Format("Voucher {0} was not found in the database.", FormattedValidationID(aValidationID))
                    pbStatus.Image = My.Resources._Error

            Case 1
               ' Create a new VoucherInfo instance and populate from the first row in the DataTable.
               mVoucherInfo = New VoucherInfo(lDT)

               ' Populate the UI...
               With mVoucherInfo
                  txtVoucherAmount.Text = .VoucherAmount.ToString("c")
                  txtLocationName.Text = .LocationName
                  txtRedeemed.Text = VoucherStatus(.IsRedeemed)
                  txtValidVoucher.Text = VoucherStatus(.IsValid)


                  ' Invoke function IsValidVoucherCheckValue to determine if voucher data is good.
                  .IsValidCheckValue = IsValidVoucherCheckValue()
                  txtValidCheckSum.Text = VoucherStatus(.IsValidCheckValue)

                  ' Is the voucher okay to pay?
                  If .IsRedeemed = True Then
                     ' Alreday redeemed.
                     lblUserInfo.Text = String.Format("Voucher {0} was redeemed on {1} at POS station {2}", .ValidationIDFormatted, .RedeemedDate, .RedeemedLoc)
                     pbStatus.Image = My.Resources._Error

                  ElseIf .IsValid = False Then
                     ' IS_VALID flag in table is False, Voucher creation started but the voucher printed message not received from EGM.
                     lblUserInfo.Text = String.Format("Voucher {0} is not flagged as valid.", .ValidationIDFormatted)
                     pbStatus.Image = My.Resources._Error

                  ElseIf .IsValidCheckValue = False Then
                     ' CheckSum is bad, voucher info probably tampered with.
                     lblUserInfo.Text = String.Format("Voucher {0} has an invalid CheckSum.  The Voucher data may have been tampered with, call a Supervisor.", .ValidationIDFormatted)
                     pbStatus.Image = My.Resources._Error

                  ElseIf .IsTransferred = False Then
                     ' UCV_TRANSFERRED is false
                     lblUserInfo.Text = String.Format("Voucher {0} has not been marked as transferred.", .ValidationIDFormatted)
                     pbStatus.Image = My.Resources._Error

                  ElseIf .IsExpired Then
                     ' Voucher is expired.
                     lblUserInfo.Text = String.Format("Voucher {0} is expired.", .ValidationIDFormatted)
                     pbStatus.Image = My.Resources._Error

                  Else
                     ' Okay to pay.
                     btnPayout.Enabled = True
                     lblUserInfo.Text = String.Format("Voucher {0} is valid and may be paid.", .ValidationIDFormatted)
                     pbStatus.Image = My.Resources.Success

                  End If

               End With

            Case Else
               ' Multiple rows, should never happen...
               lblUserInfo.Text = String.Format("Unexpected error (multiple rows) getting voucher information for Validation ID {0}.", FormattedValidationID(aValidationID))

         End Select

      Catch ex As Exception
         ' Handle the exception...
         ' Build the error text.
         lErrorText = Me.Name & "::GetVoucherInfo error: " & ex.Message
         ' Log, and then show the error...
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Retrieval Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

         If lDT IsNot Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If

      End Try

   End Sub

   Private Sub PrintReceipt(ByVal aReceiptTitle As String)
      '--------------------------------------------------------------------------------
      ' Subroutine to Print a receipt.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim ReceiptPDoc As PrintDocument

      ReceiptPDoc = New PrintDocument


      ReceiptPDoc.DocumentName = "LMS " & aReceiptTitle

      With ReceiptPDoc.PrinterSettings
         .PrinterName = My.Settings.ReceiptPrinter
         .Copies = 1
      End With

      ' Add event handlers...
      AddHandler ReceiptPDoc.PrintPage, AddressOf PrintReceiptPage
      'AddHandler ReceiptPDoc.BeginPrint, AddressOf PrepareReceiptData
      'AddHandler ReceiptPDoc.EndPrint, AddressOf ReceiptPrinted

      ' Print the receipt.
      ReceiptPDoc.Print()

   End Sub

   Private Sub PrintReceiptPage(ByVal sender As Object, ByVal e As PrintPageEventArgs)
      '--------------------------------------------------------------------------------
      ' Subroutine to handle printing of a receipt page.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lLogo As Image = Nothing

      Dim lRectangle As New Rectangle(30, 5, 220, 55)

      Dim lFontHeight As Integer = mReceiptFont.GetHeight(e.Graphics) + 6
      Dim lCurrentX As Integer = 24
      Dim lCurrentY As Integer = 80

      ' Print logo.
      If gPayoutReceiptLogo = "DCLottery" Then
          lLogo = My.Resources.DCLogo_Receipts
      ElseIf String.IsNullOrWhiteSpace(gPayoutReceiptLogo) OrElse gPayoutReceiptLogo = "None" Then
          lLogo = Nothing
      End If

      If lLogo IsNot Nothing Then
          e.Graphics.DrawImage(lLogo, lRectangle)
      End If
      
      ' Add DC Lottery Payment Center.
      If String.IsNullOrWhiteSpace(gPayoutReceiptTitle) = False Then
          e.Graphics.DrawString(gPayoutReceiptTitle, mReceiptFont, Brushes.Black, 80, lCurrentY)
      End If

      
      ' Add Reciept Title.
      Select Case mReceiptData.ReceiptTitle
         Case "Customer Receipt"
            lCurrentY += lFontHeight
            e.Graphics.DrawString(mReceiptData.ReceiptTitle, mReceiptFont, Brushes.Black, 102, lCurrentY)

         Case "Duplicate Customer Receipt"
            lCurrentY += lFontHeight
            e.Graphics.DrawString(mReceiptData.ReceiptTitle, mReceiptFont, Brushes.Black, 78, lCurrentY)

         Case "Lottery Receipt"
            lCurrentY += lFontHeight
            e.Graphics.DrawString(mReceiptData.ReceiptTitle, mReceiptFont, Brushes.Black, 108, lCurrentY)

         Case "Reprinted Receipt"
            lCurrentY += lFontHeight
            e.Graphics.DrawString(mReceiptData.ReceiptTitle, mReceiptFont, Brushes.Black, 102, lCurrentY)

      End Select

      ' Add Current DateTime.
      lCurrentY += lFontHeight
      e.Graphics.DrawString(mReceiptData.ReceiptDateTime, mReceiptFont, Brushes.Black, 85, lCurrentY)

      ' Add UserID
      lCurrentY += (lFontHeight * 2)
      e.Graphics.DrawString("User ID:  " & mReceiptData.UserID, mReceiptFont, Brushes.Black, lCurrentX, lCurrentY)

      ' Add Barcode
      lCurrentY += lFontHeight
      e.Graphics.DrawString("Barcode:  " & mReceiptData.ValidationID, mReceiptFont, Brushes.Black, lCurrentX, lCurrentY)

      ' Add Voucher Amount
      lCurrentY += lFontHeight
      e.Graphics.DrawString("Amount:  " & mReceiptData.Amount, mReceiptFont, Brushes.Black, lCurrentX, lCurrentY)

      ' Add the Reference Number
      lCurrentY += lFontHeight
      e.Graphics.DrawString("Ref Nbr:  " & mReceiptData.ReferenceNumber, mReceiptFont, Brushes.Black, lCurrentX, lCurrentY)

      ' Are we reprinting a receipt?
      If mReprintReceipt Then
         ' Yes, was the last transaction a jackpot voucher and over 600.00?
         If mReceiptData.Amount >= 600.01 AndAlso mReceiptData.VoucherType = 1 Then
            ' Yes, add line for full name.
            lCurrentY += lFontHeight
            e.Graphics.DrawString("Full Name:  _____________________________", mReceiptFont, Brushes.Black, lCurrentX, lCurrentY)

            ' Add line for SSN.
            lCurrentY += lFontHeight
            e.Graphics.DrawString("SSN:  __________________________________", mReceiptFont, Brushes.Black, lCurrentX, lCurrentY)
         End If

      Else

         ' Is the voucher for a jackpot and over 600.00?
         If mVoucherInfo.VoucherAmount >= 600.0 AndAlso mVoucherInfo.VoucherType = 1 Then
            ' Yes, add line for full name.
            lCurrentY += lFontHeight
            e.Graphics.DrawString("Full Name:  _____________________________", mReceiptFont, Brushes.Black, lCurrentX, lCurrentY)

            ' Add line for SSN.
            lCurrentY += lFontHeight
            e.Graphics.DrawString("SSN:  __________________________________", mReceiptFont, Brushes.Black, lCurrentX, lCurrentY)
         End If

      End If

      ' Put a line at the bottom.
      lCurrentY += (3 * lFontHeight)
      e.Graphics.DrawString("-----------------------------------------------------------", mReceiptFont, Brushes.Black, 20, lCurrentY)

      ' No more pages.
      e.HasMorePages = False

   End Sub

   Private Sub SetLocationVoucherUpdated()
      '--------------------------------------------------------------------------------
      ' Routine to update the LotteryCental.VoucherPayout.LocationUpdated column so
      ' we know it was updated (marked as paid) in the Location VOUCHER table.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lErrorText As String = ""
      Dim lSQL As String

      Try
         ' Build the update statement.
         lSQL = String.Format("UPDATE VoucherPayout SET LocationUpdated = 1 WHERE VoucherID = {0} AND LocationID = {1}", mVoucherInfo.VoucherID, mVoucherInfo.LocationID)

         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectionString, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...

         ' Build the error text, then log and show the error...
         lErrorText = Me.Name & "::SetLocationVoucherUpdated error: " & ex.Message

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Sub UpdateRetailVoucher()
      '--------------------------------------------------------------------------------
      ' Routine to mark voucher as having been paid at the retail location.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lErrorID As Integer
      Dim lPayoutAmount As Integer

      Dim lErrorText As String = ""
      Dim lPayoutUser As String
      Dim lProcedureName As String


      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectionString, False, 90)

         ' Set the payout user name
         lPayoutUser = gAppLoginID

         If lPayoutUser.Length > 10 Then
            lPayoutUser = lPayoutUser.Substring(0, 10)
         End If

         ' Convert Payout amount to cents.
         lPayoutAmount = CType(mVoucherInfo.VoucherAmount * 100, Integer)

         ' Build the stored proc name.
         lProcedureName = String.Format("DC{0}.LotteryRetail.dbo.Post_Voucher_Payout", mVoucherInfo.LocationID.ToString)

         With lSDA
            .AddParameter("@VoucherID", SqlDbType.Int, mVoucherInfo.VoucherID)
            .AddParameter("@PayoutUser", SqlDbType.VarChar, lPayoutUser, 10)
            .AddParameter("@AuthUser", SqlDbType.VarChar, "", 10)
            .AddParameter("@PayoutAmount", SqlDbType.Int, lPayoutAmount)
            .AddParameter("@SessionID", SqlDbType.VarChar, "", 40)
            .AddParameter("@WorkStation", SqlDbType.VarChar, gComputerName, 32)
            .AddParameter("@PaymentType", SqlDbType.Char, "A", 1)
            .AddParameter("@LocationID", SqlDbType.Int, mVoucherInfo.LocationID)

            ' Execute the stored procedure.
            lDT = .CreateDataTableSP(lProcedureName)

            ' Did the stored proc execute successfully?
            If lDT IsNot Nothing Then
               If lDT.Rows.Count > 0 Then
                  lDR = lDT.Rows(0)

                  lErrorID = lDR.Item("ErrorID")

                  ' Were there any errors?
                  If lErrorID = 0 Then
                     ' No.
                     lErrorText = ""

                     ' Update the LotteryCental.VoucherPayout.LocationUpdated column.
                     Call SetLocationVoucherUpdated()
                  Else
                     ' Yes, set the error text.
                     lErrorText = lDR.Item("ErrorDescription")
                  End If

               Else
                  ' No row returned.
                  lErrorText = "Retail Voucher Update Failed."
               End If

            Else
               ' Datatable is null.
               lErrorText = String.Format("Failed to execute store procedure: {0}.", lProcedureName)
            End If

         End With

      Catch ex As Exception
         ' Handle the exception...

         ' Build the error text, then log and show the error...
         lErrorText = Me.Name & "::UpdateRetailVoucher error: " & ex.Message

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Do we have error text?
      If lErrorText.Length > 0 Then
         ' Yes, so log it.
         Logging.Log(lErrorText)

         ' and show it.   - Per Bryan Green, ok to let it fail silently 7-27-2011
         ' MessageBox.Show(lErrorText, "Retail Voucher Payout Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If


   End Sub

   Private Function EncryptText(ByVal ClearText As String) As Byte()
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
      lInputBA = lUTF8.GetBytes(ClearText)

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

   Private Function FormattedValidationID(ByVal aValidationID As String) As String
      '--------------------------------------------------------------------------------
      ' Function to return a dash fomatted ValidationID.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lULongValue As ULong
      Dim lReturn As String

      If aValidationID.Contains("-") Then
         Return aValidationID
      ElseIf ULong.TryParse(aValidationID, lULongValue) Then
         lReturn = String.Format("{0:0-000-000-00-00000-000-0}", lULongValue)
      Else
         lReturn = ""
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function GetVoucherCheckValue(ByVal aValidationID As String, ByVal aVoucherAmount As Long, ByVal aRedeemedState As Boolean) As Byte()
      '--------------------------------------------------------------------------------
      ' Creates a CheckValue byte array used to validate a voucher.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lBuffer As String
      Dim lBarcodeData As String
      Dim lCheckSum As Int32 = 0
      Dim lIndex As Int32

      ' Convert arguments to strings and concatenate them...
      lBarcodeData = CType(aValidationID, String)
      lBuffer = lBarcodeData & aVoucherAmount.ToString

      ' Add the RedeemedState (zero or one) to the end of the buffer string...
      If aRedeemedState = False Then
         lBuffer &= "0"
      Else
         lBuffer &= "1"
      End If

      ' Walk the concatenated string and add the value of each digit...
      For lIndex = 0 To lBuffer.Length - 1
         lCheckSum += Int32.Parse(lBuffer.Chars(lIndex))
      Next

      ' Convert the checksum to a string with a minimum length of 3 characters.
      lBuffer = lCheckSum.ToString("000")

      ' Return the function return value.
      Return EncryptText(lBuffer)

   End Function

   Private Function IsPrinterValid(ByVal aPrinterName As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Checks to see if the printer is valid.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = False
      Dim lPD As New PrintDocument

      Try
         lPD.PrinterSettings.PrinterName = aPrinterName

         ' Is the receipt printer valid?
         If lPD.PrinterSettings.IsValid Then
            ' No.
            lReturn = True
         Else
            ' Yes.
            lReturn = False
         End If

      Catch ex As Exception
         lReturn = False
      End Try

      ' Return the function return value.
      Return lReturn

   End Function

   Private Function IsPrinterInstalled(ByVal aPrinterName As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Checks to see if the printer in the config file is installed.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = False
      Dim lPrinter As String

      ' Retrieve a list of installed printers.
      For Each lPrinter In PrinterSettings.InstalledPrinters
         ' Compare printers installed with printer in the config file.
         If String.Compare(aPrinterName, lPrinter, True) = 0 Then
            lReturn = True
         End If
      Next

      ' Return the function return value.
      Return lReturn

   End Function

   Private Function IsValidVoucherCheckValue() As Boolean
      '--------------------------------------------------------------------------------
      ' Function returns True or False to indicate if voucher check value is valid.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lByteVoucher As Byte
      Dim lByteCheck As Byte

      Dim lReturn As Boolean = True
      Dim lVLAmount As Long
      Dim lCheckValue() As Byte

      ' Convert the voucher amount to pennies.
      lVLAmount = Convert.ToInt64(mVoucherInfo.VoucherAmount * 100)

      ' Get a check value.
      lCheckValue = GetVoucherCheckValue(mVoucherInfo.ValidationID, lVLAmount, mVoucherInfo.IsRedeemed)

      ' Compare the check value to the voucher check value.
      For lIndex = 0 To lCheckValue.Length - 1
         lByteCheck = lCheckValue(lIndex)
         lByteVoucher = mVoucherInfo.CheckValue(lIndex)
         If lByteCheck <> lByteVoucher Then
            lReturn = False
            Exit For
         End If
      Next

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function PayoutVoucher() As Boolean
      '--------------------------------------------------------------------------------
      ' Function to mark a Voucher as having been paid.
      ' Executes stored procedure PostVoucherPayout which returns:
      '  0 = Success
      ' -1 = VoucherID/LocationID already exists
      ' -2 = Barcode (Voucher Validation ID) already exists
      '  n = TSQL error code
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      Dim lNewCheckSum() As Byte

      Dim lErrorText As String = ""

      Dim lSpReturnValue As Integer

      Dim lReturn As Boolean = True

      Dim lVLAmount As Long

      Try
         lVLAmount = Convert.ToInt64(mVoucherInfo.VoucherAmount * 100)
         lNewCheckSum = GetVoucherCheckValue(mVoucherInfo.ValidationID, lVLAmount, True)

         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectionString, False, 90)

         With lSDA
            ' Add stored procedure parameters...
            .AddParameter("@VoucherID", SqlDbType.Int, mVoucherInfo.VoucherID)
            .AddParameter("@LocationID", SqlDbType.Int, mVoucherInfo.LocationID)
            .AddParameter("@Barcode", SqlDbType.VarChar, mVoucherInfo.ValidationID, 18)
            .AddParameter("@TransAmount", SqlDbType.Money, mVoucherInfo.VoucherAmount)
            .AddParameter("@PosWorkStation", SqlDbType.VarChar, gComputerName, 32)
            .AddParameter("@AppUserID", SqlDbType.Int, gAppUserID)
            .AddParameter("@NewCheckSum", SqlDbType.VarBinary, lNewCheckSum, lNewCheckSum.Length)


            ' Execute sp PostVoucherPayout.
            lDT = .CreateDataTableSP("PostVoucherPayout")
            If lDT IsNot Nothing Then
               If lDT.Rows.Count = 1 Then
                  mVoucherInfo.ReferenceNbr = lDT.Rows(0).Item("ReferenceNbr")
               End If
            End If

            ' Store the return value.
            lSpReturnValue = .ReturnValue

         End With

         If lSpReturnValue <> 0 Then
            lReturn = False
         End If

         Select Case lSpReturnValue
            Case 0
               ' Success, so print a voucher receipt.

               ' Set reprint receipt to false
               mReprintReceipt = False

               ' Create and populate properties of a new ReceiptData instance...
               mReceiptData = New ReceiptData
               With mReceiptData
                  .ReceiptTitle = "Customer Receipt"
                  .ReceiptDateTime = String.Format("{0:yyyy-MM-dd} {0:T}", Now())
                  .UserID = gAppLoginID
                  .ValidationID = mVoucherInfo.ValidationIDFormatted
                  .Amount = String.Format("{0:c}", mVoucherInfo.VoucherAmount)
                  .ReferenceNumber = mVoucherInfo.ReferenceNbr.ToString
                  .VoucherType = mVoucherInfo.VoucherType
               End With

               ' Print Customer receipt.
               Call PrintReceipt(mReceiptData.ReceiptTitle)

               ' Print Lottery receipt.
                    If gPrintLotteryReceipt Then
                        mReceiptData.ReceiptTitle = "Lottery Receipt"
                        Call PrintReceipt(mReceiptData.ReceiptTitle)
                    End If

               ' Print Duplicate Customer receipt.
                    If gPrintDuplicateCustomerReceipt Then
                        mReceiptData.ReceiptTitle = "Duplicate Customer Receipt"
                        Call PrintReceipt(mReceiptData.ReceiptTitle)
                    End If

               ' Save receipt data in case user wants to reprint the receipt.
               With My.Settings
                  .LastReceipt = mReceiptData.GetSettingString()
                  .Save()
               End With

               ' Reset the UI in preparation for next voucher scan.
               Call ClearVoucherUI(True)
               txtVoucher.Clear()
               lblUserInfo.Text = "Ready to scan voucher."

            Case -1
               ' VoucherID/LocationID already exists
               lErrorText = "Voucher with the same ID and Location has already been paid."

            Case -2
               ' Barcode (Voucher Validation ID) already exists
               lErrorText = "Voucher with the same Validation ID has already been paid."

            Case Else
               ' TSQL Error Code
               lErrorText = String.Format("TSQL Error {0} occurred while executing procedure PostVoucherPayout.", lSpReturnValue)

         End Select

      Catch ex As Exception
         ' Handle the exception.  Build the error text.
         lErrorText = Me.Name & "::PayoutVoucher error: " & ex.Message
         lReturn = False
         ' Log, and then show the error...
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Retrieval Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' If there is error text, show it in the User Info label...
      If lErrorText.Length > 0 Then lblUserInfo.Text = lErrorText

      ' Set Function return value.
      Return lReturn

   End Function

   Private Function VoucherStatus(ByVal aStatus As Boolean) As String
      '--------------------------------------------------------------------------------
      ' Function returns Yes if True, No if False.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As String

      If aStatus = True Then
         lReturn = "Yes"
      Else
         lReturn = "No"
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Public Sub New()

      ' This call is required by the designer.
      InitializeComponent()

      ' Add any initialization after the InitializeComponent() call.

   End Sub

End Class
