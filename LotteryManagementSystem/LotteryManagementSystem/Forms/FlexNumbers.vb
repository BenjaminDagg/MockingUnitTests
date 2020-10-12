Public Class FlexNumbers

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event for the Close button.
      '--------------------------------------------------------------------------------

      ' Close this form.      
      Me.Close()

   End Sub

   Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Save button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Is the flex number valid?
      If dgvRevenueType.RowCount AndAlso dgvRevenueType.SelectedRows.Count > 0 AndAlso IsValidFlexNumber() Then
         ' Yes Update the record.
         Call UpdateRevenueType()
      End If

   End Sub

   Private Sub dgvRevenueType_SelectionChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
      '--------------------------------------------------------------------------------
      ' Selection Changed event handler for the data grid view.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lCurrentRowIndex As Integer

      Dim lErrorText As String = ""

      Try

         If dgvRevenueType.CurrentRow IsNot Nothing Then
            lCurrentRowIndex = dgvRevenueType.CurrentRow.Index
            ' Set the RevenueDescription and FlexNumber textbox controls.
            txtRevenueTypeDescription.Text = dgvRevenueType.Item("RevenueTypeDescription", lCurrentRowIndex).Value
            txtFlexNumber.Text = dgvRevenueType.Item("FlexNumber", lCurrentRowIndex).Value
            txtFlexNumber.Modified = False
            btnSave.Enabled = False

         End If

      Catch ex As Exception
         ' Handle error...
         lErrorText = Me.Name & "::dgvRevenueType_SelectionChanged error: " & ex.Message
         MessageBox.Show(lErrorText, "Revenue Type Selection Changed Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try

   End Sub

   Private Sub LoadRevenueTypes()
      '--------------------------------------------------------------------------------
      ' Populate the datagrid control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDgvColumn As DataGridViewColumn
      Dim lDT As DataTable

      Dim lRowCount As UInteger

      Dim lErrorText As String = ""
      Dim lSQL As String

      Try

         ' Build SQL SELECT statement to retrieve Grid data.
         lSQL = "SELECT RevenueTypeID, RevenueTypeDescription, FlexNumber FROM RevenueType ORDER BY RevenueTypeDescription"

         ' Retrieve RevenueType information.
         lDT = CreateDT(lSQL, "RevenueType", lErrorText)

         If lDT IsNot Nothing Then
            ' Store the number of retrieved rows and set the grid caption text...
            lRowCount = lDT.Rows.Count
            lblGridHeader.Text = String.Format("Revenue Type - Display Count: {0}", lRowCount)

            ' Bind retrieved data to the DataGridView control and set DataGridView properties...
            With dgvRevenueType
               .DataSource = lDT
               .ReadOnly = True
            End With
         End If

         For Each lDgvColumn In dgvRevenueType.Columns
            Select Case lDgvColumn.Name
               Case "RevenueTypeID"
                  With lDgvColumn
                     .DisplayIndex = 0
                     .Width = 100
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Type ID"
                     .Visible = False
                  End With

               Case "RevenueTypeDescription"
                  With lDgvColumn
                     .DisplayIndex = 1
                     .Width = 120
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Description"
                  End With

               Case "FlexNumber"
                  With lDgvColumn
                     .DisplayIndex = 2
                     .Width = 100
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Flex Number"
                  End With

            End Select

         Next


      Catch ex As Exception
         ' Handle error...
         lErrorText = Me.Name & "::LoadRevenueType error: " & ex.Message

      Finally
         ' Cleanup...
         lDgvColumn = Nothing

      End Try

      ' If we have error text, log and show it...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Revenue Type Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Load Revenue Types
      Call LoadRevenueTypes()

      AddHandler dgvRevenueType.SelectionChanged, AddressOf Me.dgvRevenueType_SelectionChanged
      AddHandler txtFlexNumber.TextChanged, AddressOf Me.txtFlexNumber_TextChanged

      ' Restore last saved location and size...
      Me.Location = My.Settings.FlexNumberLocation
      Me.Size = My.Settings.FlexNumberSize

   End Sub

   Private Sub Me_FormClosing(sender As System.Object, e As System.Windows.Forms.FormClosingEventArgs) Handles MyBase.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If WindowState = FormWindowState.Normal Then
         ' Save the position and size of this form.
         With My.Settings
            .FlexNumberLocation = Me.Location
            .FlexNumberSize = Me.Size
            .Save()
         End With
      End If

   End Sub

   Private Sub Numeric_Only_KeyPress(ByVal sender As System.Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) _
         Handles txtFlexNumber.KeyPress
      '--------------------------------------------------------------------------------
      ' Routine to handle KeyPress event for textbox controls that require only numeric
      ' entry values.
      '--------------------------------------------------------------------------------

      If Char.IsControl(e.KeyChar) = False And Char.IsDigit(e.KeyChar) = False Then
         e.Handled = True
      End If

   End Sub

   Private Sub txtFlexNumber_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtFlexNumber.TextChanged
      '--------------------------------------------------------------------------------
      ' Event handler for the FlexNumber text change event.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Enables the Save button when a new Flex Number is entered.
      btnSave.Enabled = (txtFlexNumber.Modified AndAlso txtFlexNumber.TextLength > 0 AndAlso dgvRevenueType.RowCount > 0)

   End Sub

   Private Sub UpdateRevenueType()
      '--------------------------------------------------------------------------------
      ' Executes stored procedure that updates the record.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing

      Dim lSpReturnCode As Integer

      Dim lErrorText As String = ""


      Try
         ' Instantiate a new SqlDataAccess object.
         lSDA = New SqlDataAccess(gConnectionString, False)


         With lSDA
            ' Add Parameters for AddAppUser stored proc...
            .AddParameter("@RevenueTypeID",
                          SqlDbType.SmallInt,
                          dgvRevenueType.Item("RevenueTypeID",
                          dgvRevenueType.CurrentRow.Index).Value)
            .AddParameter("@FlexNumber",
                          SqlDbType.SmallInt,
                          Short.Parse(txtFlexNumber.Text))

            ' Execute the stored proc 0 = success, 1 = Flex Number already exists, 2 = No row found to update, n = TSQL Error
            .ExecuteProcedure("UpdateRevenueType")
            lSpReturnCode = .ReturnValue


            Select Case lSpReturnCode

               Case 0
                  ' Successfully update record.
                  MessageBox.Show(String.Format("Successfully updated {0}.",
                                             dgvRevenueType.Item("RevenueTypeDescription",
                                             dgvRevenueType.CurrentRow.Index).Value),
                                             "Revenue Type Update Status",
                                             MessageBoxButtons.OK)
                  ' Refresh dgvRevenueType
                  Call LoadRevenueTypes()

               Case 1
                  ' Flex Number is already assigned.
                  MessageBox.Show("Flex Number is already assigned to another revenue type.",
                              "Revenue Type Update Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                  ' Refresh dgvRevenueType
                  Call LoadRevenueTypes()
                  ' Disable save button.
                  btnSave.Enabled = False

               Case 2
                  ' No record found to update.
                  MessageBox.Show("No record found to update.", "Revenue Type Update Status",
                              MessageBoxButtons.OK, MessageBoxIcon.Error)
                  ' Refresh dgvRevenueType
                  Call LoadRevenueTypes()
                  ' Disable save button.
                  btnSave.Enabled = False

            End Select

         End With


      Catch ex As Exception
         ' Handle error...
         lErrorText = Me.Name & "::UpdateRevenueType: " & ex.Message

      Finally
         ' Close and free the SqlDataAccess object...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' If an error occurred, log and show it...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Update Revenue Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If


   End Sub

   Private Function IsValidFlexNumber() As Boolean
      '--------------------------------------------------------------------------------
      ' Validates the flex number.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lFlexNumber As Short

      Dim lErrorText As String = ""

      ' Is the flex number an integer?
      If Short.TryParse(txtFlexNumber.Text, lFlexNumber) Then
         ' Is the flex number in a valid range?
         If lFlexNumber < 0 OrElse lFlexNumber > 9999 Then
            lErrorText = "Flex Number is out of range. Flex Number must be between 0 and 9999."
         End If
      Else
         lErrorText = "Flex Number is not a valid integer value. "
      End If

      lReturn = (lErrorText.Length = 0)

      If Not lReturn Then
         MessageBox.Show(lErrorText, "Flex Number Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      Return lReturn

   End Function

End Class