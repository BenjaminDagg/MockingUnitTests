Public Class LocationView

   ' [Class member variables]
   ' Track current row index.
   Private mLastRow As Integer = -1

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnEdit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEdit.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Edit button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lLocationAddEdit As LocationAddEdit
      Dim lLocationInfo As New LocationInfo()


      ' Are there rows in the Grid?
      If dgvLocations.RowCount > 0 Then
         ' Yes, store the current row index
         mLastRow = dgvLocations.CurrentRow.Index

         With lLocationInfo
            .LocationID = dgvLocations.Item("LocationID", mLastRow).Value
            .DgeID = dgvLocations.Item("DGEID", mLastRow).Value
            .LongName = dgvLocations.Item("LongName", mLastRow).Value
            .Address1 = dgvLocations.Item("Address1", mLastRow).Value
            .Address2 = dgvLocations.Item("Address2", mLastRow).Value
            .City = dgvLocations.Item("City", mLastRow).Value
            .State = dgvLocations.Item("State", mLastRow).Value
            .PostalCode = dgvLocations.Item("PostalCode", mLastRow).Value
            .ContactName = dgvLocations.Item("ContactName", mLastRow).Value
            .PhoneNumber = dgvLocations.Item("PhoneNumber", mLastRow).Value
            .FaxNumber = dgvLocations.Item("FaxNumber", mLastRow).Value
            .ThresholdAmount = dgvLocations.Item("PayoutThreshold", mLastRow).Value
            .RetailRevShare = dgvLocations.Item("RetailRevShare", mLastRow).Value
            .SweepAcct = dgvLocations.Item("SweepAcct", mLastRow).Value
            .RetailerNumber = dgvLocations.Item("RetailerNumber", mLastRow).Value
         End With

         lLocationAddEdit = New LocationAddEdit
         With lLocationAddEdit
            .MdiParent = Me.MdiParent
            .OpeningForm = Me
            .SetLocationInfo(lLocationInfo)
            .Show()
         End With

      End If

   End Sub

   Private Sub btnRefresh_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Refresh button.
      '--------------------------------------------------------------------------------

      ' Refresh by reloading the the Location DataGridView control.
      Call LoadLocations()

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Populate the Datagrid with Game data.
      Call LoadLocations()

      ' Restore last saved location and size...
      Me.Location = My.Settings.LocationViewLocation
      Me.Size = My.Settings.LocationViewSize

   End Sub

   Private Sub Me_FormClosing(sender As System.Object, e As System.Windows.Forms.FormClosingEventArgs) Handles MyBase.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If WindowState = FormWindowState.Normal Then
         ' Save the position and size of this form.
         With My.Settings
            .LocationViewLocation = Me.Location
            .LocationViewSize = Me.Size
            .Save()
         End With
      End If

   End Sub

   Friend Sub LoadLocations()
      '--------------------------------------------------------------------------------
      ' Populate the datagrid control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDgvColumn As DataGridViewColumn
      Dim lDT As DataTable

      Dim lRowCount As UInteger

      Dim lErrorText As String = ""
      Dim lSQL As String
      Dim lTableName As String = "CASINO"

      ' Build SQL SELECT statement to retrieve Grid data.
      lSQL = "SELECT LOCATION_ID AS LocationID, CAS_ID AS DGEID, ISNULL(CAS_NAME, '') AS LongName, " &
             "PAYOUT_THRESHOLD AS PayoutThreshold, ISNULL(ADDRESS1, '') AS Address1, ISNULL(ADDRESS2, '') AS Address2, " &
             "CITY AS City, STATE AS State, ISNULL(ZIP, '') AS PostalCode, ISNULL(CONTACT_NAME, '') AS ContactName, " &
             "ISNULL(PHONE, '') AS PhoneNumber, ISNULL(FAX, '') AS FaxNumber, RETAIL_REV_SHARE AS RetailRevShare, " &
             "SWEEP_ACCT AS SweepAcct, RETAILER_NUMBER AS RetailerNumber FROM CASINO ORDER BY CAS_ID"

      Try
         ' Retrieve Game information.
         lDT = CreateDT(lSQL, lTableName, lErrorText)

         ' Store the number of retrieved rows and set the grid caption text...
         lRowCount = lDT.Rows.Count
         lblGridHeader.Text = String.Format("Locations - Display Count: {0}", lRowCount)

         ' Set the enabled property of the Edit and Deactivate buttons based upon existance of rows...
         btnEdit.Enabled = (lRowCount > 0)

         ' Bind retrieved data to the DataGridView control and set DataGridView properties...
         With dgvLocations
            .DataSource = lDT
            .ReadOnly = True
            .RowHeadersWidth = 20
         End With

         For Each lDgvColumn In dgvLocations.Columns
            Select Case lDgvColumn.Name
               Case "LocationID"
                  With lDgvColumn
                     .DisplayIndex = 0
                     .Width = 84
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Location ID"
                  End With

               Case "DGEID"
                  With lDgvColumn
                     .DisplayIndex = 1
                     .Width = 60
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "DGE ID"
                  End With

               Case "LongName"
                  With lDgvColumn
                     .DisplayIndex = 2
                     .Width = 250
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderText = "Location"
                  End With

               Case "PayoutThreshold"
                  With lDgvColumn
                     .DisplayIndex = 3
                     .Width = 98
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                     .DefaultCellStyle.Format = "#,##0.00"
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleRight
                     .HeaderText = "Payout Threshold"
                  End With

               Case "Address1"
                  With lDgvColumn
                     .DisplayIndex = 4
                     .Width = 200
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderText = "Address 1"
                  End With

               Case "Address2"
                  With lDgvColumn
                     .DisplayIndex = 5
                     .Width = 120
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderText = "Address 2"
                  End With

               Case "City"
                  With lDgvColumn
                     .DisplayIndex = 6
                     .Width = 102
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderText = "City"
                  End With

               Case "State"
                  With lDgvColumn
                     .DisplayIndex = 7
                     .Width = 52
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "State/Province"
                  End With

               Case "PostalCode"
                  With lDgvColumn
                     .DisplayIndex = 8
                     .Width = 80
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Postal Code"
                  End With

               Case "ContactName"
                  With lDgvColumn
                     .DisplayIndex = 9
                     .Width = 80
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderText = "Contact Name"
                  End With

               Case "PhoneNumber"
                  With lDgvColumn
                     .DisplayIndex = 10
                     .Width = 60
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderText = "Phone Nbr"
                  End With

               Case "FaxNumber"
                  With lDgvColumn
                     .DisplayIndex = 11
                     .Width = 60
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderText = "Fax Nbr"
                  End With

               Case "RetailRevShare"
                  With lDgvColumn
                     .DisplayIndex = 12
                     .Width = 98
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                     .DefaultCellStyle.Format = "#0.00"
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleRight
                     .HeaderText = "Revenue Share"
                  End With

               Case "SweepAcct"
                  With lDgvColumn
                     .DisplayIndex = 13
                     .Width = 98
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Sweep Account"
                  End With

               Case "RetailerNumber"
                  With lDgvColumn
                     .DisplayIndex = 14
                     .Width = 98
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .DefaultCellStyle.Format = "00000"
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Retailer Number"
                  End With

            End Select
         Next

         ' Attempt to reposition...
         If lRowCount > 0 AndAlso mLastRow > -1 Then
            If mLastRow > lRowCount - 1 Then mLastRow = lRowCount - 1
            dgvLocations.Rows(mLastRow).Selected = True
         End If

      Catch ex As Exception
         ' Handle error...
         lErrorText = Me.Name & "::LoadLocationsGrid error: " & ex.Message

      Finally
         ' Cleanup...
         lDgvColumn = Nothing

      End Try

      ' If we have error text, log and show it...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Locations Grid Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

End Class