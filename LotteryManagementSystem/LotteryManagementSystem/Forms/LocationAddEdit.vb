Public Class LocationAddEdit

   ' [Class member variables]
   Private mOpeningForm As LocationView
   Private mLocationInfo As LocationInfo

   Private mActivatedCount As Integer = 0
   Private mEditMode As Short
   Private Const ModeAdd As Short = 0
   Private Const ModeEdit As Short = 1

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Save button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Is the UI data valid?
      If IsValidData() Then
         ' Yes, attempt to save the data.
         Call SaveData()

      End If

   End Sub

   Private Sub Me_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Activated
      '--------------------------------------------------------------------------------
      ' Activated event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Increment the activation count.
      mActivatedCount += 1

      ' Is this the first form activation?
      If mActivatedCount = 1 Then
         ' Yes, are we in Add mode?
         If mEditMode = ModeAdd Then
            ' Yes, so set the LocationID TextBox control properties...
            With txtLocationID
               .ReadOnly = False
               .BackColor = Color.White
               .TabStop = True
            End With
            With txtDgeID
               .ReadOnly = False
               .BackColor = Color.White
               .TabStop = True
            End With
         Else
            ' Edit Mode...
            With txtLocationID
               .ReadOnly = True
               .BackColor = Color.WhiteSmoke
               .TabStop = False
            End With
            With txtDgeID
               .ReadOnly = True
               .BackColor = Color.WhiteSmoke
               .TabStop = False
            End With
            txtLongName.Focus()
         End If
      End If

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Set the caption based on the edit mode.
      If mEditMode = ModeAdd Then
         Me.Text = "Add New Location"
      Else
         Me.Text = "Modify Location Information"
      End If

   End Sub

   Private Sub Numeric_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) _
      Handles txtLocationID.KeyPress, txtPayoutThreshold.KeyPress, txtPostalCode.KeyPress, _
      txtRetailRevShare.KeyPress, txtSweepAcct.KeyPress, txtRetailNumber.KeyPress
      '--------------------------------------------------------------------------------
      ' NumericOnly KeyPress handler.
      '--------------------------------------------------------------------------------

      If Char.IsControl(e.KeyChar) = False AndAlso Char.IsDigit(e.KeyChar) = False AndAlso Char.IsPunctuation(e.KeyChar) = False Then
         e.Handled = True
      End If

   End Sub

   Private Sub PhoneNumber_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) _
     Handles txtFaxNumber.KeyPress, txtPhoneNumber.KeyPress
      '--------------------------------------------------------------------------------
      ' NumericOnly KeyPress handler.
      '--------------------------------------------------------------------------------

      If Char.IsControl(e.KeyChar) = False AndAlso _
         Char.IsDigit(e.KeyChar) = False AndAlso _
         Char.IsPunctuation(e.KeyChar) = False AndAlso _
         e.KeyChar <> " "c Then

         e.Handled = True

      End If

   End Sub

   Private Sub SaveData()
      '--------------------------------------------------------------------------------
      ' Routine to Add or Update Location information.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing

      Dim lLocationID As Integer
      Dim lRC As Integer

      Dim lPayoutThreshold As Decimal
      Dim lRetailRevShare As Decimal

      Dim lErrorText As String = ""
      Dim lStoredProc As String

      ' Build the stored proc name.
      lStoredProc = String.Format("{0}.LotteryRetail.dbo.lmsUpdateLocation", txtDgeID.Text)

      lLocationID = mLocationInfo.LocationID
      lPayoutThreshold = Decimal.Parse(txtPayoutThreshold.Text)
      lRetailRevShare = Decimal.Parse(txtRetailRevShare.Text)

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectionString, False, 90)

         ' Add approriate parameters, they are the same for Adding or Editing...
         With lSDA
            .AddParameter("@LocationID", SqlDbType.Int, lLocationID)
            .AddParameter("@LongName", SqlDbType.VarChar, txtLongName.Text, 128)
            .AddParameter("@Address1", SqlDbType.VarChar, txtAddress1.Text, 64)
            .AddParameter("@Address2", SqlDbType.VarChar, txtAddress2.Text, 64)
            .AddParameter("@City", SqlDbType.VarChar, txtCity.Text, 64)
            .AddParameter("@State", SqlDbType.VarChar, txtState.Text, 2)
            .AddParameter("@PostalCode", SqlDbType.VarChar, txtPostalCode.Text, 12)
            .AddParameter("@ContactName", SqlDbType.VarChar, txtContactName.Text, 32)
            .AddParameter("@PhoneNumber", SqlDbType.VarChar, txtPhoneNumber.Text, 32)
            .AddParameter("@FaxNumber", SqlDbType.VarChar, txtFaxNumber.Text, 32)
            .AddParameter("@ThresholdAmount", SqlDbType.Money, lPayoutThreshold)
            .AddParameter("@RetailRevShare", SqlDbType.Decimal, lRetailRevShare)
            .AddParameter("@SweepAcct", SqlDbType.VarChar, txtSweepAcct.Text, 32)
            .AddParameter("@RetailerNumber", SqlDbType.Char, txtRetailNumber.Text, 5)

            ' Execute the stored procedure.
            lRC = .ExecuteProcedureNoResult(lStoredProc)
            lRC = .ReturnValue

            ' Handle the error.
            If lRC < 1 Then
               lErrorText = "Stored Procedure failed to update rows."
            End If

            ' If in Add Mode, reset the edit mode from ModeAdd to ModeEdit.
            If mEditMode = ModeAdd Then
               mEditMode = ModeEdit
               Me.Text = "Modify Location information"
            End If

         End With

         ' Attempt to refresh the DataGridView of the LocationView.
         Try
            Call mOpeningForm.LoadLocations()

         Catch ex As Exception
            ' If the locations grid refresh fails, ignore the error..
         End Try

      Catch ex As Exception
         ' Build the error text, then log and show the error...
         lErrorText = Me.Name & "::SaveData error: " & ex.Message

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Do we have error text?
      If lErrorText.Length = 0 Then
         MessageBox.Show(String.Format("Successfully updated Location: {0} - {1}", lLocationID, txtLongName.Text))
         ' Close this form.
         Me.Close()
      Else
         ' Yes, so log and show it.
         Logging.Log(lErrorText)

         ' Show a more friendly message to the user.
         lErrorText = "Update of Location Information failed, please contact the Technology Department." & _
                      gCrLf & "Details of the failure have been saved to the LMS application log file."
         MessageBox.Show(lErrorText, "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Public Sub SetLocationInfo(ByVal aLocationInfo As LocationInfo)
      '--------------------------------------------------------------------------------
      ' Receives a LocationInfo object and uses it for the UI control values.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If aLocationInfo Is Nothing Then
         Throw New ArgumentException("Location Info may not be null.")
      Else
         mLocationInfo = aLocationInfo

         ' Set the Edit Mode based on the LocationID value...
         If mLocationInfo.LocationID = 0 Then
            ' Add Mode.
            mEditMode = ModeAdd
         Else
            ' Edit Mode.
            mEditMode = ModeEdit
         End If

         ' Populate the UI display...
         With mLocationInfo
            txtLocationID.Text = .LocationID.ToString
            txtDgeID.Text = .DgeID
            txtLongName.Text = .LongName
            txtAddress1.Text = .Address1
            txtAddress2.Text = .Address2
            txtCity.Text = .City
            txtState.Text = .State
            txtPostalCode.Text = .PostalCode
            txtContactName.Text = .ContactName
            txtPhoneNumber.Text = .PhoneNumber
            txtFaxNumber.Text = .FaxNumber
            txtPayoutThreshold.Text = .ThresholdAmount.ToString("#,##0.00")
            txtRetailRevShare.Text = .RetailRevShare.ToString("#0.00")
            txtSweepAcct.Text = .SweepAcct
            txtRetailNumber.Text = .RetailerNumber
         End With

      End If

   End Sub

   Private Sub txtAlphaOnly_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles txtState.KeyPress
      '--------------------------------------------------------------------------------
      ' Alpha Only txtState KeyPress handler.
      '--------------------------------------------------------------------------------

      If Char.IsControl(e.KeyChar) = False AndAlso Char.IsLetter(e.KeyChar) = False Then
         e.Handled = True
      End If

   End Sub

   Private Function IsValidData() As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluates UI data and returns T/F to indicate if data is okay to save.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lPayThreshold As Decimal
      Dim lRetailRevShare As Decimal
      Dim lLocationID As Integer

      Dim lErrorDisplay As String = ""
      Dim lErrorText As String
      Dim lValueText As String

      Dim lChar As Char

      ' Evaluate the Location ID...
      lErrorText = ""
      If mEditMode = ModeAdd Then
         If Not Integer.TryParse(txtLocationID.Text, lLocationID) Then
            lReturn = False
            lErrorText = "Unable to convert the Location ID to an integer value."
         End If
      Else
         lLocationID = mLocationInfo.LocationID
      End If

      If lErrorText.Length = 0 Then
         If lLocationID < 1000 OrElse lLocationID > 9999 Then
            lReturn = False
            lErrorText = "Location ID must be in the range of 1000 to 9999."
         End If
      End If
      ErrProvider.SetError(txtLocationID, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' Evaluate DgeID...
      lErrorText = ""
      If txtDgeID.TextLength <> 6 Then
         lReturn = False
         lErrorText = "DGE ID must contain 6 alphanumeric characters."
      Else
         lValueText = txtDgeID.Text
         For lIndex = 0 To 5
            lChar = lValueText.Chars(lIndex)
            If Not Char.IsLetterOrDigit(lChar) Then
               lReturn = False
               lErrorText = "DGE ID must contain 6 alphanumeric characters."
               Exit For
            End If
         Next
      End If
      ErrProvider.SetError(txtDgeID, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' Evaluate LongName...
      lErrorText = ""
      If txtLongName.TextLength < 1 Then
         lReturn = False
         lErrorText = "A Location Description is required."
      End If
      ErrProvider.SetError(txtLongName, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If


      ' Evaluate Address1...
      lErrorText = ""
      If txtAddress1.TextLength < 1 Then
         lReturn = False
         lErrorText = "An entry is required for Address 1."
      End If
      ErrProvider.SetError(txtAddress1, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' Evaluate Address2...
      ' There are no requirements for Address 2.

      ' Evaluate City...
      lErrorText = ""
      If txtCity.TextLength < 1 Then
         lReturn = False
         lErrorText = "A City entry is required."
      End If
      ErrProvider.SetError(txtCity, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' Evaluate State...
      lErrorText = ""
      lValueText = txtState.Text.Trim
      If lValueText.Length <> 2 Then
         lReturn = False
         lErrorText = "A 2 alpha character State entry is required."
      Else
         For lIndex = 0 To 1
            lChar = lValueText.Chars(lIndex)
            If Not Char.IsLetter(lChar) Then
               lReturn = False
               lErrorText = "A 2 alpha character State entry is required."
               Exit For
            End If
         Next
      End If
      ErrProvider.SetError(txtState, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' Evaluate PostalCode...
      lErrorText = ""
      If txtPostalCode.TextLength < 5 Then
         lReturn = False
         lErrorText = "A Valid Postal Code is required."
      End If
      ErrProvider.SetError(txtCity, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' There are currently no requirements for PostalCode, ContactName, PhoneNumber, or FaxNumber.

      ' Evaluate PayoutThreshold...
      lErrorText = ""
      If Decimal.TryParse(txtPayoutThreshold.Text, lPayThreshold) Then
         If lPayThreshold < 0.01 OrElse lPayThreshold > 9999.99 Then
            lReturn = False
            lErrorText = "Invalid Payout Threshold value. Threshold value must be between $0.01 and $9,999.99."
         End If
      Else
         lReturn = False
         lErrorText = "Invalid Payout Threshold value."
      End If
      ErrProvider.SetError(txtPayoutThreshold, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' Evaluate RetailRevShare...
      lErrorText = ""
      If Decimal.TryParse(txtRetailRevShare.Text, lRetailRevShare) Then
         If lRetailRevShare < 5 OrElse lRetailRevShare > 50 Then
            lReturn = False
            lErrorText = "Invalid Retail Revenue Share value, out of range (5.00 to 50.00)."
         End If
      Else
         lReturn = False
         lErrorText = "Invalid Retail Revenue Share value."
      End If
      ErrProvider.SetError(txtRetailRevShare, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' Evaluate SweepAcct...
      lErrorText = ""
      If txtSweepAcct.TextLength > 0 AndAlso txtSweepAcct.TextLength <> 16 Then
         lErrorText = "Sweep Account number must be a total of 16 digits."
         lReturn = False
      End If
      ErrProvider.SetError(txtSweepAcct, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' Evaluate Retailer Number...
      lErrorText = ""
      If txtRetailNumber.TextLength > 0 AndAlso txtRetailNumber.TextLength <> 5 Then
         lErrorText = "Retailer Number must be a total of 5 digits."
         lReturn = False
      End If
      ErrProvider.SetError(txtRetailNumber, lErrorText)
      If lErrorText.Length > 0 Then
         lErrorDisplay &= lErrorText & gCrLf
      End If

      ' If we have error display text, show it...
      If lErrorDisplay.Length > 0 Then
         lErrorDisplay.TrimEnd(gCrLf.ToCharArray)
         MessageBox.Show(lErrorDisplay, "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Public WriteOnly Property OpeningForm() As LocationView
      '--------------------------------------------------------------------------------
      ' Sets the OpeningForm value.
      '--------------------------------------------------------------------------------

      Set(ByVal value As LocationView)
         mOpeningForm = value
      End Set

   End Property

End Class