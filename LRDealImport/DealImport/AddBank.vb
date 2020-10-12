Public Class AddBank

#Region "Private Variables"

   Private mBankInfo As BankInfo

#End Region

#Region "Event Handlers"

   Private Sub btnAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAdd.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""

      Dim lBankNumber As Integer
      Dim lEntryTicketFactor As Integer

      Dim lDbaLockupAmount As Decimal
      Dim lEntryTicketAmount As Decimal
      Dim lLockupAmount As Decimal

      ' Do we have a description?
      If txtBankDesc.TextLength > 0 Then
         If cboProductLines.SelectedIndex > -1 Then
            If Integer.TryParse(txtBankNo.Text, lBankNumber) Then
               If Integer.TryParse(txtEntryTicketFactor.Text, lEntryTicketFactor) Then
                  If Decimal.TryParse(txtLockupAmount.Text, lLockupAmount) Then
                     If Decimal.TryParse(txtEntryTicketAmount.Text, lEntryTicketAmount) Then
                        If Decimal.TryParse(txtDBALockupAmount.Text, lDbaLockupAmount) Then
                           With mBankInfo
                              .BankDescription = txtBankDesc.Text
                              .BankNumber = lBankNumber
                              .ProductLineID = cboProductLines.SelectedValue
                              .LockupAmount = lLockupAmount
                              .EntryTicketFactor = lEntryTicketFactor
                              .EntryTicketAmount = lEntryTicketAmount
                              .DbaLockupAmount = lDbaLockupAmount
                           End With

                           ' Set the DialogResult property of this form to Yes and close the form...
                           Me.DialogResult = Windows.Forms.DialogResult.Yes
                           Me.Close()
                        Else
                           lErrorText = "Could not convert DBA Lockup Amount to a decimal value."
                        End If
                     Else
                        lErrorText = "Could not convert Entry Ticket Amount to a decimal value."
                     End If
                  Else
                     lErrorText = "Could not convert Lockup Amount to a decimal value."
                  End If
               Else
                  lErrorText = "Could not convert Entry Ticket Factor to an integer value."
               End If
            Else
               ' Bad Bank number
               lErrorText = "Could not convert Bank Number to an integer value."
            End If
         Else
            lErrorText = "Please select a Product Line."
         End If
      Else
         ' No bank description.
         lErrorText = "A Bank Description is required."
      End If

      ' Do we have error text to display?
      If lErrorText.Length > 0 Then
         ' Yes, so show it...
         MessageBox.Show(lErrorText, "Add Bank Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------

      ' Set the DialogResult property of this form to Cancel and close the form...
      Me.DialogResult = Windows.Forms.DialogResult.Cancel
      Me.Close()

   End Sub

   Private Sub Me_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Activated
      '--------------------------------------------------------------------------------
      ' Activated event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDT As DataTable

      ' Set the selected index of the ProductLines ComboBox control to -1
      ' (deselects any values) if there is more than 1 row.
      lDT = cboProductLines.DataSource
      If lDT.Rows.Count > 1 Then
         cboProductLines.SelectedIndex = -1
      End If

   End Sub

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Save window state info for next time this form is opened.
      With My.Settings
         .AddBankLocation = Me.Location
         .AddBankSize = Me.Size
         .Save()
      End With

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Populate the ProductLines ComboBox control.
      Call LoadProductLines()

      ' Populate the Existing Banks DataGridView control.
      Call LoadBanks()

      ' Position and size this form to last saved state.
      With My.Settings
         Me.Location = .AddBankLocation
         Me.Size = .AddBankSize
         Me.WindowState = FormWindowState.Normal
      End With
   End Sub

#End Region

#Region "Private Subroutines"

   Private Sub InitGrid()
      '--------------------------------------------------------------------------------
      ' Initialize the Grid.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDgvColumn As DataGridViewColumn

      With dgvBanks
         .BackgroundColor = Color.White
         .ReadOnly = True
         .RowHeadersWidth = 20
         .BackColor = Color.White
         .ForeColor = Color.MidnightBlue
      End With

      For Each lDgvColumn In dgvBanks.Columns
         Select Case lDgvColumn.Name
            Case "BANK_NO"
               With lDgvColumn
                  .DisplayIndex = 0
                  .Width = 72
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Bank Nbr"
               End With

            Case "BANK_DESCR"
               With lDgvColumn
                  .DisplayIndex = 1
                  .Width = 200
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderText = "Description"
               End With

            Case "GAME_TYPE_CODE"
               With lDgvColumn
                  .DisplayIndex = 2
                  .Width = 42
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "GTC"
               End With

            Case Else
               ' Hide any columns not handled above.
               lDgvColumn.Visible = False

         End Select
      Next

   End Sub

   Private Sub LoadBanks()
      '--------------------------------------------------------------------------------
      ' Routine to populate the Existing Banks DataGridView control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lErrorText As String
      Dim lSQL As String


      lSQL = "SELECT BANK_NO, BANK_DESCR, GAME_TYPE_CODE FROM BANK ORDER BY GAME_TYPE_CODE"

      Try
         ' Instantiate a new SqlDataAccess object.
         lSDA = New SqlDataAccess(gConnectRetail, False, 60)

         ' Retrieve data into DataTable.
         lDT = lSDA.CreateDataTable(lSQL, "Banks")

         dgvBanks.DataSource = lDT

         Call InitGrid()


      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::LoadBanks error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Load Banks Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Sub LoadProductLines()
      '--------------------------------------------------------------------------------
      ' Routine to populate the ProductLines ComboBox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      'Dim lDT As DataTable

      Dim lProductID As Short = mBankInfo.ProductID

      Dim lErrorText As String
      Dim lSQL As String

      ' Build SQL SELECT statement for data to retrieve...
      lSQL = "SELECT PRODUCT_LINE_ID, LONG_NAME FROM PRODUCT_LINE WHERE IS_ACTIVE = 1 "
      Select Case lProductID
         Case 2
            ' Triple Play - EZTab 2.0
            lSQL &= "AND GAME_CLASS = 3 AND LONG_NAME NOT LIKE '%Bingo%' "

         Case 3
            ' Diamond Bingo
            lSQL &= "AND LONG_NAME LIKE '%Bingo%' "

         Case 5
            ' SkilTab - EZTab 2.0
            lSQL &= "AND LONG_NAME LIKE '%SkilTab%' "

         Case 6
            ' Diamond Progressive Class 3
            lSQL &= "AND PRODUCT_LINE_ID > 10 AND GAME_CLASS = 3 AND LONG_NAME NOT LIKE '%Bingo%' AND LONG_NAME NOT LIKE '%SkilTab%' "

      End Select

      ' Add the ORDER BY clause.
      lSQL &= " ORDER BY PRODUCT_LINE_ID"

      Try
         ' Instantiate a new SqlDataAccess object.
         lSDA = New SqlDataAccess(gConnectRetail, False, 60)

         ' Retrieve data into DataTable.
         'lDT = lSDA.CreateDataTable(lSQL, "ProductLine")

         With cboProductLines
            .DisplayMember = "LONG_NAME"
            .ValueMember = "PRODUCT_LINE_ID"
            .DataSource = lSDA.CreateDataTable(lSQL, "ProductLine")
         End With

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::LoadProductLines error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Load Product Lines Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

#End Region

#Region "Form Properties"

   Friend Property BankSetup() As BankInfo
      '------------------------------------------------------------
      ' Get or Set the BankInfo object containing Bank setup data.
      '------------------------------------------------------------

      Get
         Return mBankInfo
      End Get

      Set(ByVal value As BankInfo)
         Dim lChar As Char

         Dim lDefaultBankNumber As String = ""
         Dim lGameTypeCode As String

         Dim lAsciiValue As Short

         Dim lIndex As Integer
         Dim lBankNbrInt As Integer

         ' Store reference to the incoming BankInfo object.
         mBankInfo = value

         ' Set the Default the Bank description.
         txtBankDesc.Text = mBankInfo.BankDescription

         ' Set the default machine Lockup Amount.
         txtLockupAmount.Text = mBankInfo.LockupAmount.ToString

         ' Set the default EntryTicketFactor.
         txtEntryTicketFactor.Text = mBankInfo.EntryTicketFactor.ToString

         ' Set the default EntryTicketAmount.
         txtEntryTicketAmount.Text = mBankInfo.EntryTicketAmount.ToString

         ' Set the default DBA Lockup Amount.
         txtDBALockupAmount.Text = mBankInfo.DbaLockupAmount.ToString

         ' Store the GameTypeCode in a local var and use for Text property of the GameTypeCode TextBox control...
         lGameTypeCode = mBankInfo.GameTypeCode
         txtGameTypeCode.Text = lGameTypeCode

         ' Modify the Form caption.
         Me.Text = "Add New Bank for Game Type Code " & lGameTypeCode

         ' Try to create a default Bank Number.
         If Integer.TryParse(lGameTypeCode, lBankNbrInt) Then
            ' GameTypeCode is a number, use it.
            txtBankNo.Text = lBankNbrInt.ToString
         Else
            ' Could not convert GameTypeCode to a number, examine each
            ' character in the GTC and build a default bank number.
            Try
               For lIndex = 0 To lGameTypeCode.Length - 1
                  lChar = lGameTypeCode.Chars(lIndex)
                  If Char.IsLetter(lChar) Then
                     ' It is a letter, so convert A to 10, B to 11, etc...
                     lAsciiValue = Convert.ToInt16(lChar) - 55
                     lDefaultBankNumber &= lAsciiValue.ToString
                  Else
                     ' It is a number...
                     If lIndex = 0 Then
                        ' It is a number in the first position, just use it.
                        lDefaultBankNumber &= lChar
                     Else
                        ' It is a number after the first position, prepend a zero if necessary.
                        lDefaultBankNumber &= String.Format("{0:00}", Short.Parse(lChar))
                     End If
                  End If
               Next

               txtBankNo.Text = lDefaultBankNumber

            Catch ex As Exception
               ' Ignore the exeption...
            End Try
         End If
      End Set

   End Property

#End Region

End Class