Public Class VoucherLotStatus

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Me.Close()

   End Sub

   Private Sub btnSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSearch.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Search button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Call GetVoucherLotInfo()


   End Sub

   Private Sub txtVoucherLot_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles txtVoucherLot.KeyPress
      '--------------------------------------------------------------------------------
      ' NumericOnly txtVoucherLot KeyPress handler.
      '--------------------------------------------------------------------------------

      If Char.IsControl(e.KeyChar) = False AndAlso Char.IsDigit(e.KeyChar) = False Then
         e.Handled = True
      End If

   End Sub

   Private Sub GetVoucherLotInfo()
      '--------------------------------------------------------------------------------
      ' Subroutine to search for Voucher Lot data.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDR As DataRow

      Dim lMatchCount As Integer

      Dim lLotNbrLong As Long

      Dim lErrorText As String
      Dim lResultBase As String
      Dim lLotNumber As String = txtVoucherLot.Text
      Dim lSQL As String


      ' Clear the current search results.
      txtSearchResults.Clear()

      ' Build the SQL SELECT statement.
      lSQL = "SELECT VoucherLotID, LocationID, DateReceived, Location, DgeID, LocAddress1 " & _
             String.Format("FROM uvwVoucherLotInfo WHERE LotNumber = '{0}'", lLotNumber)

      If Long.TryParse(lLotNumber, lLotNbrLong) Then
         Try
            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectionString, False, 90)

            ' Execute the SQL SELECT statement.
            lDT = lSDA.CreateDataTable(lSQL, "VoucherLot")
            lMatchCount = lDT.Rows.Count

            Select Case lMatchCount
               Case Is < 1
                  txtSearchResults.Text = "No matching Lot Number was found."

               Case Else
                  lResultBase = "Lot Number: {0:00-000000-00000}{1}LocationID: {2}{1}  Location: {3}{1}    DGE ID: {4}{1}   Address: {5}{1}{1}"
                  For Each lDR In lDT.Rows
                     With lDR
                        txtSearchResults.Text &= String.Format(lResultBase, lLotNbrLong, gCrLf, _
                                                               .Item("LocationID"), .Item("Location"), _
                                                               .Item("DgeID"), .Item("LocAddress1"))
                     End With
                  Next
            End Select


         Catch ex As Exception
            ' Handle the exception...
            ' Build the error text.
            lErrorText = Me.Name & "::GetVoucherLotInfo error: " & ex.Message
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
      Else
         ' Could not convert lot number to a Long data type value.
         lErrorText = Me.Name & "::GetVoucherLotInfo error converting Lot Number to a "
      End If

   End Sub

End Class