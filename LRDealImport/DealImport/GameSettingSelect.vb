Public Class GameSettingSelect

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Me.Close()

   End Sub

   Private Sub btnContinue_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinue.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Continue button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lProductID As Integer
      Dim lRowIndex As Integer

      Dim lErrorText As String
      Dim lGameTypeCode As String


      ' Are there selected rows?
      If dgvGameTypes.SelectedRows.Count > 0 Then
         lRowIndex = dgvGameTypes.SelectedRows(0).Index
         lGameTypeCode = CType(dgvGameTypes.Item("GAME_TYPE_CODE", lRowIndex).Value, String)

         lProductID = CType(dgvGameTypes.Item("PRODUCT_ID", lRowIndex).Value, Integer)

         Select Case lProductID
            Case 3
               Dim lGSBingo As New GameSetupBingo
               With lGSBingo
                  .GameTypeCode = lGameTypeCode
                  .GameTypeDescription = CType(dgvGameTypes.Item("LONG_NAME", lRowIndex).Value, String)
                  .MdiParent = Me.MdiParent
                  .Show()
               End With

         End Select

         'MessageBox.Show(lGameTypeCode & " - " & lProductID.ToString, "Game Type Selection Status", MessageBoxButtons.OK, MessageBoxIcon.Information)


      Else
         ' No selected rows, inform the user.
         lErrorText = "No Game Type has been selected."
         MessageBox.Show(lErrorText, "Game Setting Selection Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If


   End Sub

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Save window state info for next time this form is opened.
      With My.Settings
         .GSSelectLocation = Me.Location
         .GSSelectSize = Me.Size
         .GSSelectFWS = Me.WindowState
         .Save()
      End With

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Call LoadGameTypes()

      ' Position and size this form to last saved state.
      Me.Location = My.Settings.GSSelectLocation
      Me.Size = My.Settings.GSSelectSize
      Me.WindowState = My.Settings.GSSelectFWS


   End Sub

   Private Sub InitGrid()
      '--------------------------------------------------------------------------------
      ' Initialize the Grid.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDgvColumn As DataGridViewColumn

      With dgvGameTypes
         .BackgroundColor = Color.White
         .ReadOnly = True
         .RowHeadersWidth = 20
         .BackColor = Color.White
         .ForeColor = Color.MidnightBlue
      End With

      For Each lDgvColumn In dgvGameTypes.Columns
         Select Case lDgvColumn.Name
            Case "GAME_TYPE_CODE"
               With lDgvColumn
                  .DisplayIndex = 0
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Game Type"
               End With

            Case "LONG_NAME"
               With lDgvColumn
                  .DisplayIndex = 1
                  .Width = 320
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderText = "Description"
               End With

            Case "PRODUCT_TYPE"
               With lDgvColumn
                  .DisplayIndex = 2
                  .Width = 200
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderText = "Type of Game"
               End With

            Case Else
               ' Hide any columns not handled above.
               lDgvColumn.Visible = False

         End Select
      Next

   End Sub

   Private Sub LoadGameTypes()
      '--------------------------------------------------------------------------------
      ' Load the Game Type selection DataGridView control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable

      Dim lErrorText As String
      Dim lSQL As String


      ' Build the SQL SELECT statement to retrieve active Game Types in active Banks.
      lSQL = "SELECT DISTINCT gt.GAME_TYPE_CODE, gt.LONG_NAME, " & _
             "p.PRODUCT_DESCRIPTION + ' - ' + dt.DEAL_TYPE_NAME AS PRODUCT_TYPE, " & _
             "gt.PRODUCT_ID " & _
             "FROM GAME_TYPE gt JOIN BANK b ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
             "JOIN DEAL_TYPE dt ON gt.TYPE_ID = dt.TYPE_ID " & _
             "JOIN dbo.PRODUCT p ON gt.PRODUCT_ID = p.PRODUCT_ID " & _
             "WHERE gt.IS_ACTIVE = 1 AND b.IS_ACTIVE = 1 ORDER BY gt.GAME_TYPE_CODE"
      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, False, 90)

         ' Execute the SQL SELECT statement.
         lDT = lSDA.CreateDataTable(lSQL, "GameTypes")

         With dgvGameTypes
            .DataSource = lDT

         End With

         Call InitGrid()

      Catch ex As Exception
         ' Handle the exception...
         ' Build the error text.
         lErrorText = Me.Name & "::ProcName error: " & ex.Message
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

   End Sub

  
End Class