Public Class FreePlayVouchers

   Private mErrorIcon As Icon
   Private mWarningIcon As Icon

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Me.Close()

   End Sub

   Private Sub btnContinue_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinue.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Print button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAuthorization As Authorization

      Dim lErrorText As String = ""

      Try

         ' Is the data valid?
         If IsValidDataVoucherAmount(lErrorText) AndAlso IsValidDataExpirationDays(lErrorText) AndAlso IsValidDataQuantity(lErrorText) Then
            ' Yes, continue and open the Authorization window.
            lAuthorization = New Authorization
            With lAuthorization
               .MdiParent = Me.MdiParent
               .VoucherAmount = CType(txtVoucherAmount.Text, Decimal)
               .Quantity = txtQuantity.Text
               .ExpirationDays = CType(txtExpirationDays.Text, Integer)
               .Show()
            End With

            ' Close the form.
            Me.Close()

         Else
            ' No, show error message.
            MessageBox.Show(lErrorText, "Validate Data Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End If

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::btnContinue_Click error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, My.Settings.ApplicationTitle + " Voucher Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try


   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Initialize the DGESmartForm class
      Call InitializeBase()
      mErrorIcon = ErrProvider1.Icon.Clone()

      Dim warningIcon As New Bitmap(16, 18)
      Dim warningGraphics As Graphics = Graphics.FromImage(warningIcon)
      warningGraphics.DrawImage(SystemIcons.Warning.ToBitmap(), 0, 1, warningIcon.Width + 1, warningIcon.Height + 1)
      mWarningIcon = Icon.FromHandle(warningIcon.GetHicon())

      Me.Text = My.Settings.ApplicationTitle
      ' Set the default expiration days to 30.
      txtExpirationDays.Text = gDefaultExpirationDays
      txtVoucherAmount.Text = Format(CDbl(gDefaultCents) / 100.0, "###,###,##0.00")

   End Sub

   Private Sub Numeric_Only_KeyPress(ByVal sender As System.Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles txtQuantity.KeyPress, txtExpirationDays.KeyPress
      '--------------------------------------------------------------------------------
      ' Routine to handle KeyPress event for textbox controls that require only numeric
      ' entry values.
      '--------------------------------------------------------------------------------

      If Char.IsControl(e.KeyChar) = False And Char.IsDigit(e.KeyChar) = False Then
         e.Handled = True
      End If

   End Sub

   Private Sub txtVoucherAmount_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles txtVoucherAmount.KeyPress
      '--------------------------------------------------------------------------------
      ' Routine to handle KeyPress event for VoucherAmount textbox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lChars As String = "0123456789."

      ' Allow numbers and period only.
      If lChars.IndexOf(e.KeyChar) = -1 Then
         e.Handled = True
      End If

      ' Allow BackSpace.
      If e.KeyChar = Chr(8) Then
         e.Handled = False
      End If


   End Sub


   Private Sub txtVoucherAmount_Leave(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtVoucherAmount.Leave
      '--------------------------------------------------------------------------------
      ' Routine to format VoucherAmount textbox
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String

      Try
         ' Does the textbox contral have data?
         If txtVoucherAmount.TextLength > 0 Then
            ' Yes, so format it.
            txtVoucherAmount.Text = Format(Double.Parse(txtVoucherAmount.Text), "###,###,##0.00")
         End If

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::txtVoucherAmount_Leave error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, My.Settings.ApplicationTitle + " Voucher Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try


   End Sub




   Private Function IsValidDataVoucherAmount(ByRef aErrorText As String, Optional writeToLog As Boolean = True) As Boolean
      '--------------------------------------------------------------------------------
      ' Validates the ExpirationDays number.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lExpirationDays As Short
      Dim lQuantity As Short
      Dim lVoucherAmount As Double

      Dim lErrorText As String

      Dim errProviderIcon As Icon = mErrorIcon

      ' Is the Voucher Amount a double?
      lErrorText = ""
      If Double.TryParse(txtVoucherAmount.Text, lVoucherAmount) Then
         ' Is the Voucher Amount in a valid range?
         If gSupervisorMaxCents > 0 AndAlso lVoucherAmount * 100 > gSupervisorMaxCents Then
            lErrorText = "Voucher Amount will require elevated permissions."
            errProviderIcon = mWarningIcon
         End If

         If lVoucherAmount < 0.01 OrElse lVoucherAmount * 100 > gElevatedMaxCents Then
            errProviderIcon = mErrorIcon
            lErrorText = String.Format("Voucher Amount must be between $0.01 and ${0:0.00}.", (CDbl(gElevatedMaxCents) / 100.0))
            aErrorText &= lErrorText
            lReturn = False
         End If
      Else
         lErrorText = "Voucher Amount is not a valid value."
         aErrorText &= lErrorText
         lReturn = False
      End If

      ' Set the error provider.
      If String.IsNullOrEmpty(lErrorText) Then
         ErrProvider1.Clear()
      End If

      ErrProvider1.Icon = errProviderIcon
      ErrProvider1.SetError(txtVoucherAmount, lErrorText)

      If writeToLog AndAlso Not lReturn Then
         Logging.Log(aErrorText)
      End If

      ' Set Function return value.
      Return lReturn

   End Function

   Private Function IsValidDataExpirationDays(ByRef aErrorText As String, Optional writeToLog As Boolean = True) As Boolean
      '--------------------------------------------------------------------------------
      ' Validates the ExpirationDays number.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lExpirationDays As Short
      Dim lQuantity As Short
      Dim lVoucherAmount As Double

      Dim lErrorText As String

      Dim errProviderIcon As Icon = mErrorIcon

      ' Is the ExpirationDays number an integer?
      lErrorText = ""
      If Short.TryParse(txtExpirationDays.Text, lExpirationDays) Then
         ' Is the ExpirationDays number in a valid range?
         If gSupervisorMaxExpirationDays > 0 AndAlso lExpirationDays > gSupervisorMaxExpirationDays Then
            lErrorText = "Expiration Days will require elevated permissions."
            errProviderIcon = mWarningIcon
         End If

         If lExpirationDays < 1 OrElse lExpirationDays > gElevatedMaxExpirationDays Then
            errProviderIcon = mErrorIcon
            lErrorText = String.Format("Expiration Days must be between 1 and {0}.", gElevatedMaxExpirationDays)
            If aErrorText.Length > 0 Then aErrorText &= gCrLf
            aErrorText &= lErrorText
            lReturn = False
         End If
      Else
         lErrorText = "Expiration Days are not a valid integer value."
         If aErrorText.Length > 0 Then aErrorText &= gCrLf
         aErrorText &= lErrorText
         lReturn = False
      End If

      ' Set the error provider.
      If String.IsNullOrEmpty(lErrorText) Then
         ErrProvider2.Clear()
      End If

      ErrProvider2.Icon = errProviderIcon
      ErrProvider2.SetError(txtExpirationDays, lErrorText)

      If writeToLog AndAlso Not lReturn Then
         Logging.Log(aErrorText)
      End If

      ' Set Function return value.
      Return lReturn

   End Function

   Private Function IsValidDataQuantity(ByRef aErrorText As String, Optional writeToLog As Boolean = True) As Boolean
      '--------------------------------------------------------------------------------
      ' Validates the ExpirationDays number.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lExpirationDays As Short
      Dim lQuantity As Short
      Dim lVoucherAmount As Double

      Dim lErrorText As String

      ' Is the Quantity number an integer?
      lErrorText = ""
      If Short.TryParse(txtQuantity.Text, lQuantity) Then
         ' Is the Quantity number in a valid range?
         If lQuantity < 1 OrElse lQuantity > 500 Then
            lErrorText = "Quantity must be between 1 and 500."
            If aErrorText.Length > 0 Then aErrorText &= gCrLf
            aErrorText &= lErrorText
            lReturn = False
         End If
      Else
         lErrorText = "Quantity is not a valid integer value."
         If aErrorText.Length > 0 Then aErrorText &= gCrLf
         aErrorText &= lErrorText
         lReturn = False
      End If

      ' Set the error provider.
      ErrProvider3.SetError(txtQuantity, lErrorText)

      If writeToLog AndAlso Not lReturn Then
         Logging.Log(aErrorText)
      End If

      ' Set Function return value.
      Return lReturn

   End Function

   Private Sub txtVoucherAmount_TextChanged(sender As System.Object, e As System.EventArgs) Handles txtVoucherAmount.TextChanged
      IsValidDataVoucherAmount("", False)
   End Sub

   Private Sub txtExpirationDays_TextChanged(sender As System.Object, e As System.EventArgs) Handles txtExpirationDays.TextChanged
      IsValidDataExpirationDays("", False)
   End Sub

   Private Sub txtQuantity_TextChanged(sender As System.Object, e As System.EventArgs) Handles txtQuantity.TextChanged
      IsValidDataQuantity("", False)
   End Sub
End Class