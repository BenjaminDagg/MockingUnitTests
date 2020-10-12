Public Class GameSetupBingo

   ' [Member variables]
   Private mDTDenomsAvailable As DataTable
   Private mDTDenomsAssigned As DataTable

   Private mDTCoinsBetAvailable As DataTable
   Private mDTCoinsBetAssigned As DataTable

   Private mDTLinesBetAvailable As DataTable
   Private mDTLinesBetAssigned As DataTable

   Private mDTFormsBetAvailable As DataTable
   Private mDTFormsBetAssigned As DataTable

   Private mGameTypeCode As String = ""
   Private mGameTypeDesc As String = ""


   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnCoinsBetAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCoinsBetAdd.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the CoinsBet Add button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDRV As DataRowView
      Dim lDR As DataRow

      Dim lCoinsBetValue As Short

      If lbCoinsBetAvailable.SelectedItem IsNot Nothing Then
         lDRV = lbCoinsBetAvailable.SelectedItem

         lCoinsBetValue = lDRV.Item("COINS_BET")
         lDR = mDTCoinsBetAvailable.Select("COINS_BET = " & lCoinsBetValue.ToString)(0)
         mDTCoinsBetAvailable.Rows.Remove(lDR)

         lDR = mDTCoinsBetAssigned.NewRow
         lDR.Item("COINS_BET") = lCoinsBetValue

         mDTCoinsBetAssigned.Rows.Add(lDR)
      End If

   End Sub

   Private Sub btnCoinsBetDrop_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCoinsBetDrop.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the CoinsBet Drop button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDRV As DataRowView
      Dim lDR As DataRow

      Dim lCoinsBetValue As Short

      If lbCoinsBetAssigned.SelectedItem IsNot Nothing Then
         lDRV = lbCoinsBetAssigned.SelectedItem

         lCoinsBetValue = lDRV.Item("COINS_BET")
         lDR = mDTCoinsBetAssigned.Select("COINS_BET = " & lCoinsBetValue.ToString)(0)
         mDTCoinsBetAssigned.Rows.Remove(lDR)

         lDR = mDTCoinsBetAvailable.NewRow
         lDR.Item("COINS_BET") = lCoinsBetValue

         mDTCoinsBetAvailable.Rows.Add(lDR)
      End If

   End Sub

   Private Sub btnDenomAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDenomAdd.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Add Denom button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDRV As DataRowView
      Dim lDR As DataRow

      Dim lDenomValue As Decimal

      If lbDenomsAvailable.SelectedItem IsNot Nothing Then
         lDRV = lbDenomsAvailable.SelectedItem

         lDenomValue = lDRV.Item("DENOM_VALUE")
         lDR = mDTDenomsAvailable.Select("DENOM_VALUE = " & lDenomValue.ToString)(0)
         mDTDenomsAvailable.Rows.Remove(lDR)

         lDR = mDTDenomsAssigned.NewRow
         lDR.Item("DENOM_VALUE") = lDenomValue

         mDTDenomsAssigned.Rows.Add(lDR)
      End If

   End Sub

   Private Sub btnDenomDrop_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDenomDrop.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Drop Denom button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDRV As DataRowView
      Dim lDR As DataRow

      Dim lDenomValue As Decimal

      If lbDenomsAssigned.SelectedItem IsNot Nothing Then
         lDRV = lbDenomsAssigned.SelectedItem

         lDenomValue = lDRV.Item("DENOM_VALUE")
         lDR = mDTDenomsAssigned.Select("DENOM_VALUE = " & lDenomValue.ToString)(0)
         mDTDenomsAssigned.Rows.Remove(lDR)

         lDR = mDTDenomsAvailable.NewRow
         lDR.Item("DENOM_VALUE") = lDenomValue

         mDTDenomsAvailable.Rows.Add(lDR)

      End If

   End Sub

   Private Sub btnFormAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFormAdd.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Form Add button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lDRA() As DataRow

      Dim lRowIndex As Integer
      Dim lFilter As String
      Dim lFormNumber As String

      If dgvFormsAvailable.SelectedRows.Count > 0 Then
         lRowIndex = dgvFormsAvailable.SelectedRows(0).Index
         lFormNumber = CType(dgvFormsAvailable.Item("FORM_NUMB", lRowIndex).Value, String)
         lFilter = String.Format("FORM_NUMB = '{0}'", lFormNumber)

         lDRA = mDTFormsBetAvailable.Select(lFilter)
         If lDRA.Length > 0 Then
            lDR = lDRA(0)
            mDTFormsBetAssigned.ImportRow(lDR)
            mDTFormsBetAvailable.Rows.Remove(lDR)

         End If
      End If

   End Sub

   Private Sub btnFormRemove_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFormRemove.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Form Remove button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lDRA() As DataRow

      Dim lRowIndex As Integer
      Dim lFilter As String
      Dim lFormNumber As String

      If dgvFormsAssigned.SelectedRows.Count > 0 Then
         lRowIndex = dgvFormsAssigned.SelectedRows(0).Index
         lFormNumber = CType(dgvFormsAssigned.Item("FORM_NUMB", lRowIndex).Value, String)
         lFilter = String.Format("FORM_NUMB = '{0}'", lFormNumber)

         lDRA = mDTFormsBetAssigned.Select(lFilter)
         If lDRA.Length > 0 Then
            lDR = lDRA(0)
            mDTFormsBetAvailable.ImportRow(lDR)
            mDTFormsBetAssigned.Rows.Remove(lDR)

         End If
      End If
   End Sub

   Private Sub btnLinesBetAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLinesBetAdd.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the LinesBet Add button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDRV As DataRowView
      Dim lDR As DataRow

      Dim lLinesBetValue As Short

      If lbLinesBetAvailable.SelectedItem IsNot Nothing Then
         lDRV = lbLinesBetAvailable.SelectedItem

         lLinesBetValue = lDRV.Item("LINES_BET")
         lDR = mDTLinesBetAvailable.Select("LINES_BET = " & lLinesBetValue.ToString)(0)
         mDTLinesBetAvailable.Rows.Remove(lDR)

         lDR = mDTLinesBetAssigned.NewRow
         lDR.Item("LINES_BET") = lLinesBetValue

         mDTLinesBetAssigned.Rows.Add(lDR)
      End If

   End Sub

   Private Sub btnLinesBetDrop_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLinesBetDrop.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the LinesBet Drop button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDRV As DataRowView
      Dim lDR As DataRow

      Dim lLinesBetValue As Short

      If lbLinesBetAssigned.SelectedItem IsNot Nothing Then
         lDRV = lbLinesBetAssigned.SelectedItem

         lLinesBetValue = lDRV.Item("LINES_BET")
         lDR = mDTLinesBetAssigned.Select("LINES_BET = " & lLinesBetValue.ToString)(0)
         mDTLinesBetAssigned.Rows.Remove(lDR)

         lDR = mDTLinesBetAvailable.NewRow
         lDR.Item("LINES_BET") = lLinesBetValue

         mDTLinesBetAvailable.Rows.Add(lDR)
      End If

   End Sub

   Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Save button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""


      ' Is the setup okay?
      If IsValidSetup(lErrorText) Then
         ' Yes, so attempt to save the setup.
         Call SaveGameSetup()
      Else
         ' No, show user what the problem is...

      End If

   End Sub

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Save window state info for next time this form is opened.
      With My.Settings
         .GSBingoLocation = Me.Location
         .GSBingoSize = Me.Size
         .GSBingoFWS = Me.WindowState
         .Save()
      End With

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      txtGameType.Text = String.Format("{0} - {1}", mGameTypeCode, mGameTypeDesc)

      Call PopulateDenomLists()
      Call PopulateCoinsBetLists()
      Call PopulateLinesBetLists()
      Call PopulateForms()


      ' Position and size this form to last saved state.
      Me.Location = My.Settings.GSBingoLocation
      Me.Size = My.Settings.GSBingoSize
      Me.WindowState = My.Settings.GSBingoFWS

   End Sub

   Private Sub PopulateCoinsBetLists()
      '--------------------------------------------------------------------------------
      ' Subroutine to populate the CoinsBet ListBox controls.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""
      Dim lSQL As String

      Try
         ' Build the SQL SELECT statement to retrieve value currently assigned to the GameType.
         lSQL = String.Format("SELECT COINS_BET FROM COINS_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}' ORDER BY COINS_BET", mGameTypeCode)

         ' Retrieve assigned values...
         mDTCoinsBetAssigned = CreateDT(lSQL, lErrorText)

         ' Was the retrieval successful?
         If mDTCoinsBetAssigned IsNot Nothing Then
            ' Yes, so populate the assigned CoinsBet ListBox control...
            With lbCoinsBetAssigned
               .DataSource = mDTCoinsBetAssigned
               .DisplayMember = "COINS_BET"
               .ValueMember = "COINS_BET"
            End With

            ' Now retrieve available CoinsBet values for the game type not already assigned.,..
            lSQL = "SELECT COINS_BET FROM COINS_BET_TO_GAME_TYPE WHERE GAME_TYPE_CODE = " & _
                   String.Format("'{0}' AND COINS_BET NOT IN (SELECT COINS_BET FROM COINS_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}')", mGameTypeCode)

            ' Retrieve assigned values...
            mDTCoinsBetAvailable = CreateDT(lSQL, lErrorText)

            ' Was the retrieval successful?
            If mDTCoinsBetAvailable IsNot Nothing Then
               ' Yes, so populate the available Game CoinsBet ListBox control...
               With lbCoinsBetAvailable
                  .DataSource = mDTCoinsBetAvailable
                  .DisplayMember = "COINS_BET"
                  .ValueMember = "COINS_BET"
               End With
            Else
               ' Retrieval of available CoinsBet values failed.
               lErrorText = Me.Name & "::PopulateCoinsBetLists error (retrieving available Coins Bet): " & lErrorText
            End If

         Else
            ' Retrieval of assigned CoinsBet values failed.
            lErrorText = Me.Name & "::PopulateCoinsBetLists error (retrieving assigned Coins Bet): " & lErrorText
         End If

      Catch ex As Exception
         ' Handle the exception. Build the error text.
         lErrorText = Me.Name & "::PopulateCoinsBetLists error: " & ex.Message

         'Finally
         ' Cleanup...

      End Try

      ' Did we generate error text?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it...
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Populate CoinsBet Lists Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub PopulateDenomLists()
      '--------------------------------------------------------------------------------
      ' Subroutine to populate the Denominations ListBox controls.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...    
      Dim lErrorText As String = ""
      Dim lSQL As String


      Try
         ' Build the SQL SELECT statement to retrieve value currently assigned to the GameType.
         lSQL = String.Format("SELECT DENOM_VALUE FROM DENOMS_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}' ORDER BY DENOM_VALUE", mGameTypeCode)

         ' Retrieve assigned values...
         mDTDenomsAssigned = CreateDT(lSQL, lErrorText)

         ' Was the retrieval successful?
         If mDTDenomsAssigned IsNot Nothing Then
            ' Yes, so populate the Game Denoms ListBox control...
            With lbDenomsAssigned
               .DataSource = mDTDenomsAssigned
               .DisplayMember = "DENOM_VALUE"
               .ValueMember = "DENOM_VALUE"
            End With

            ' Now retrieve available denoms for the game type not already assigned.,..
            lSQL = "SELECT DENOM_VALUE FROM DENOM_TO_GAME_TYPE WHERE GAME_TYPE_CODE = " & _
                   String.Format("'{0}' AND DENOM_VALUE NOT IN (SELECT DENOM_VALUE FROM DENOMS_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}')", mGameTypeCode)

            ' Retrieve assigned values...
            mDTDenomsAvailable = CreateDT(lSQL, lErrorText)

            ' Was the retrieval successful?
            If mDTDenomsAvailable IsNot Nothing Then
               ' Yes, so populate the Game Denoms ListBox control...
               With lbDenomsAvailable
                  .DataSource = mDTDenomsAvailable
                  .DisplayMember = "DENOM_VALUE"
                  .ValueMember = "DENOM_VALUE"
               End With
            Else
               ' Retrieval of available denoms failed.
               lErrorText = Me.Name & "::PopulateDenomLists error (retrieving available denoms): " & lErrorText
            End If

         Else
            ' Retrieval of assigned denoms failed.
            lErrorText = Me.Name & "::PopulateDenomLists error (retrieving assigned denoms): " & lErrorText
         End If

      Catch ex As Exception
         ' Handle the exception. Build the error text.
         lErrorText = Me.Name & "::PopulateDenomLists error: " & ex.Message

         'Finally
         ' Cleanup...

      End Try

      ' Did we generate error text?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it...
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Populate Denom Lists Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub PopulateForms()
      '--------------------------------------------------------------------------------
      ' Subroutine to populate the LinesBet ListBox controls.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""
      Dim lSQL As String

      Try
         ' Build the SQL SELECT statement to retrieve Forms assigned to the GameType.
         lSQL = "SELECT fbl.FORM_NUMB, cf.FORM_DESC, cf.LINES_BET, cf.HOLD_PERCENT, cf.JACKPOT_COUNT, cf.BINGO_MASTER_ID " & _
                "FROM FORMS_BET_LIMIT fbl JOIN CASINO_FORMS cf ON fbl.FORM_NUMB = cf.FORM_NUMB " & _
                String.Format("WHERE fbl.GAME_TYPE_CODE = '{0}' ORDER BY LINES_BET, HOLD_PERCENT", mGameTypeCode)

         ' Retrieve Form data...
         mDTFormsBetAssigned = CreateDT(lSQL, lErrorText)

         ' Was the retrieval successful?
         If mDTFormsBetAssigned IsNot Nothing Then
            ' Yes, so populate the Forms DataGridView control...
            dgvFormsAssigned.DataSource = mDTFormsBetAssigned

            ' Now retrieve form data available for assignment.
            lSQL = "SELECT FORM_NUMB, FORM_DESC, LINES_BET, HOLD_PERCENT, JACKPOT_COUNT, BINGO_MASTER_ID FROM CASINO_FORMS WHERE GAME_TYPE_CODE = " & _
                   String.Format("'{0}' AND FORM_NUMB NOT IN (SELECT FORM_NUMB FROM FORMS_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}')", mGameTypeCode) & _
                   " ORDER BY LINES_BET, HOLD_PERCENT"

            ' Retrieve Form data...
            mDTFormsBetAvailable = CreateDT(lSQL, lErrorText)
            dgvFormsAvailable.DataSource = mDTFormsBetAvailable

            Call InitFormGrids()

         Else
            ' Retrieval of assigned denoms failed.
            lErrorText = Me.Name & "::PopulateForms error (retrieving assigned denoms): " & lErrorText
         End If

      Catch ex As Exception
         lErrorText = Me.Name & "::PopulateForms error: " & ex.Message

      End Try

      ' Did we generate error text?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it...
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Populate Forms Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub InitFormGrids()
      '--------------------------------------------------------------------------------
      ' Initialize the Assigned and Available Form DataGridView controls.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDgvColumn As DataGridViewColumn

      With dgvFormsAssigned
         .BackgroundColor = Color.White
         .ReadOnly = True
         .RowHeadersWidth = 20
         .BackColor = Color.White
         .ForeColor = Color.MidnightBlue
      End With

      With dgvFormsAvailable
         .BackgroundColor = Color.White
         .ReadOnly = True
         .RowHeadersWidth = 20
         .BackColor = Color.White
         .ForeColor = Color.MidnightBlue
      End With

      For Each lDgvColumn In dgvFormsAssigned.Columns
         Select Case lDgvColumn.Name
            Case "FORM_NUMB"
               With lDgvColumn
                  .DisplayIndex = 0
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Form"
               End With

            Case "FORM_DESC"
               With lDgvColumn
                  .DisplayIndex = 1
                  .Width = 240
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderText = "Description"
               End With

            Case "LINES_BET"
               With lDgvColumn
                  .DisplayIndex = 2
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Lines Bet"
               End With

            Case "HOLD_PERCENT"
               With lDgvColumn
                  .DisplayIndex = 3
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Hold"
               End With

            Case "JACKPOT_COUNT"
               With lDgvColumn
                  .DisplayIndex = 4
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Jackpots"
               End With

            Case "BINGO_MASTER_ID"
               With lDgvColumn
                  .DisplayIndex = 5
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Bingo ID"
               End With

            Case Else
               ' Hide any columns not handled above.
               lDgvColumn.Visible = False

         End Select
      Next

      For Each lDgvColumn In dgvFormsAvailable.Columns
         Select Case lDgvColumn.Name
            Case "FORM_NUMB"
               With lDgvColumn
                  .DisplayIndex = 0
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Form"
               End With

            Case "FORM_DESC"
               With lDgvColumn
                  .DisplayIndex = 1
                  .Width = 240
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderText = "Description"
               End With

            Case "LINES_BET"
               With lDgvColumn
                  .DisplayIndex = 2
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Lines Bet"
               End With

            Case "HOLD_PERCENT"
               With lDgvColumn
                  .DisplayIndex = 3
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Hold"
               End With

            Case "JACKPOT_COUNT"
               With lDgvColumn
                  .DisplayIndex = 4
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Jackpots"
               End With

            Case "BINGO_MASTER_ID"
               With lDgvColumn
                  .DisplayIndex = 5
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Bingo ID"
               End With

            Case Else
               ' Hide any columns not handled above.
               lDgvColumn.Visible = False

         End Select
      Next

   End Sub

   Private Sub PopulateLinesBetLists()
      '--------------------------------------------------------------------------------
      ' Subroutine to populate the LinesBet ListBox controls.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""
      Dim lSQL As String

      Try
         ' Build the SQL SELECT statement to retrieve value currently assigned to the GameType.
         lSQL = String.Format("SELECT LINES_BET FROM LINES_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}' ORDER BY LINES_BET", mGameTypeCode)

         ' Retrieve assigned values...
         mDTLinesBetAssigned = CreateDT(lSQL, lErrorText)

         ' Was the retrieval successful?
         If mDTLinesBetAssigned IsNot Nothing Then
            ' Yes, so populate the Game LinesBet ListBox control...
            With lbLinesBetAssigned
               .DataSource = mDTLinesBetAssigned
               .DisplayMember = "LINES_BET"
               .ValueMember = "LINES_BET"
            End With

            ' Now retrieve available LinesBet values for the game type not already assigned.,..
            lSQL = "SELECT LINES_BET FROM LINES_BET_TO_GAME_TYPE WHERE GAME_TYPE_CODE = " & _
                   String.Format("'{0}' AND LINES_BET NOT IN (SELECT LINES_BET FROM LINES_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}')", mGameTypeCode)

            ' Retrieve available values...
            mDTLinesBetAvailable = CreateDT(lSQL, lErrorText)

            ' Was the retrieval successful?
            If mDTLinesBetAvailable IsNot Nothing Then
               ' Yes, so populate the Game LinesBet available ListBox control...
               With lbLinesBetAvailable
                  .DataSource = mDTLinesBetAvailable
                  .DisplayMember = "LINES_BET"
                  .ValueMember = "LINES_BET"
               End With
            Else
               ' Retrieval of available LinesBet values failed.
               lErrorText = Me.Name & "::PopulateLinesBetLists error (retrieving available Lines Bet): " & lErrorText
            End If

         Else
            ' Retrieval of assigned LinesBet values failed.
            lErrorText = Me.Name & "::PopulateLinesBetLists error (retrieving assigned Lines Bet): " & lErrorText
         End If

      Catch ex As Exception
         ' Handle the exception. Build the error text.
         lErrorText = Me.Name & "::PopulateLinesBetLists error: " & ex.Message

         'Finally
         ' Cleanup...

      End Try

      ' Did we generate error text?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it...
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Populate LinesBet Lists Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub SaveGameSetup()
      '--------------------------------------------------------------------------------
      ' Subroutine to Save the game setup.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lRC As Integer

      Dim lErrorText As String
      Dim lSQL As String
      Dim lSQLBase As String

      ' Build the SQL SELECT statement.
      lSQL = "INSERT INTO "
      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 30)

         ' [DENOMS_BET_LIMIT]
         ' Delete any existing DENOMS_BET_LIMIT rows for this GameTypeCode...
         lSQL = String.Format("DELETE FROM DENOMS_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}'", mGameTypeCode)
         lRC = lSDA.ExecuteSQLNoReturn(lSQL)

         ' Now insert user selected rows...
         lSQLBase = "INSERT INTO DENOMS_BET_LIMIT (DENOM_VALUE, GAME_TYPE_CODE) VALUES ({0}, '{1}')"
         For Each lDR In mDTDenomsAssigned.Rows
            lSQL = String.Format(lSQLBase, lDR.Item("DENOM_VALUE"), mGameTypeCode)
            lRC = lSDA.ExecuteSQLNoReturn(lSQL)
         Next

         ' [COINS_BET_LIMIT]
         ' Delete any existing COINS_BET_LIMIT rows for this GameTypeCode...
         lSQL = String.Format("DELETE FROM COINS_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}'", mGameTypeCode)
         lRC = lSDA.ExecuteSQLNoReturn(lSQL)

         ' Now insert user selected rows...
         lSQLBase = "INSERT INTO COINS_BET_LIMIT (COINS_BET, GAME_TYPE_CODE) VALUES ({0}, '{1}')"
         For Each lDR In mDTCoinsBetAssigned.Rows
            lSQL = String.Format(lSQLBase, lDR.Item("COINS_BET"), mGameTypeCode)
            lRC = lSDA.ExecuteSQLNoReturn(lSQL)
         Next

         ' [LINES_BET_LIMIT]
         ' Delete any existing LINES_BET_LIMIT rows for this GameTypeCode...
         lSQL = String.Format("DELETE FROM LINES_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}'", mGameTypeCode)
         lRC = lSDA.ExecuteSQLNoReturn(lSQL)

         ' Now insert user selected rows...
         lSQLBase = "INSERT INTO LINES_BET_LIMIT (LINES_BET, GAME_TYPE_CODE) VALUES ({0}, '{1}')"
         For Each lDR In mDTLinesBetAssigned.Rows
            lSQL = String.Format(lSQLBase, lDR.Item("LINES_BET"), mGameTypeCode)
            lRC = lSDA.ExecuteSQLNoReturn(lSQL)
         Next

         ' [FORMS_BET_LIMIT]
         ' Delete any existing FORMS_BET_LIMIT rows for this GameTypeCode...
         lSQL = String.Format("DELETE FROM FORMS_BET_LIMIT WHERE GAME_TYPE_CODE = '{0}'", mGameTypeCode)
         lRC = lSDA.ExecuteSQLNoReturn(lSQL)

         ' Now insert user selected rows...
         lSQLBase = "INSERT INTO FORMS_BET_LIMIT (FORM_NUMB, GAME_TYPE_CODE) VALUES ('{0}', '{1}')"
         For Each lDR In mDTFormsBetAssigned.Rows
            lSQL = String.Format(lSQLBase, lDR.Item("FORM_NUMB"), mGameTypeCode)
            lRC = lSDA.ExecuteSQLNoReturn(lSQL)
         Next

      Catch ex As Exception
         ' Handle the exception...
         ' Build the error text.
         lErrorText = Me.Name & "::SaveGameSetup error: " & ex.Message
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

   Private Function IsValidSetup(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Function that validates the user setup.
      ' Returns T/F to indicate that the setup is valid or not.
      ' aErrorText will contain an error message if the function returns False.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean

      ' Assume setup is okay.
      lReturn = True
      aErrorText = ""

      ' [Begin evaluation]

      ' Is there at least one Assigned Denomination value?


      ' Is there at least one Assigned CoinsBet value?


      ' Is there at least one Assigned LinesBet value?



      ' Is there at least one Assigned Form value?



      ' Is there one form for each LinesBet?


      ' Is there more than 1 Form with the same Lines Bet option?




      ' Set the function return value.
      Return lReturn

   End Function

   Friend WriteOnly Property GameTypeCode() As String

      Set(ByVal value As String)
         '--------------------------------------------------------------------------------
         ' WriteOnly Property GameTypeCode - Sets the GameTypeCode text.
         '--------------------------------------------------------------------------------

         mGameTypeCode = value

      End Set

   End Property

   Friend WriteOnly Property GameTypeDescription() As String
      Set(ByVal value As String)
         '--------------------------------------------------------------------------------
         ' WriteOnly Property GameTypeDescription - Sets the GameType Description text.
         '--------------------------------------------------------------------------------

         mGameTypeDesc = value

      End Set

   End Property

End Class