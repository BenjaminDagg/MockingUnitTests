Imports System.Text

Public Class ImportAmdC3P

   ' Private vars...
   Private mDSImportXMLData As DataSet
   Private mImportFlags As New ImportFlags

   Private mActivateCount As Integer = 0
   Private mImportMDHistoryID As Integer

   Private mImportDealSQLBase As String
   Private mSourceFolder As String

   Private mGameTypeList() As String

#Region "Event Handlers"

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnImport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImport.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Import button.
      '--------------------------------------------------------------------------------

      ' Disable appropriate UI items...
      btnCancel.Enabled = False
      btnImport.Enabled = False
      dgvGameTypes.Enabled = False

      ' Remove data from the DataSet that will not be imported.
      If RemoveNonImportData() Then
         ' Begin the import process...
         Call ImportAmdC3PData()
      End If

      With btnCancel
         .Enabled = True
         .Text = "Close"
      End With

   End Sub

   Private Sub Me_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Activated
      '--------------------------------------------------------------------------------
      ' Activated event handler for this form.
      '--------------------------------------------------------------------------------

      ' Increment the number of times this form has been activated.
      mActivateCount += 1

      ' First time?
      If mActivateCount = 1 Then
         ' Yes, so deselect all rows...
         If dgvGameTypes.SelectedRows.Count > 0 Then
            For Each lDGVR As DataGridViewRow In dgvGameTypes.SelectedRows
               lDGVR.Selected = False
            Next
         End If
      End If

   End Sub

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------

      ' If the window is maximized, restore to normal.
      If Me.WindowState = FormWindowState.Maximized Then Me.WindowState = FormWindowState.Normal

      ' Save window state info for next time this form is opened.
      With My.Settings
         .IAMDC3PLocation = Me.Location
         .IAMDC3PSize = Me.Size
         .Save()
      End With

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form control.
      '--------------------------------------------------------------------------------

      ' Build the base SQL Insert statement for the IMPORT_MD_DETAIL table.
      mImportDealSQLBase = "INSERT INTO IMPORT_MD_DETAIL " & _
         "(IMPORT_MD_HISTORY_ID, TABLE_NAME, DETAIL_TEXT, INSERT_COUNT, UPDATE_COUNT, IGNORED_COUNT, ERROR_COUNT) " & _
         "VALUES ({0},'{1}','{2}',{3},{4},{5},{6})"

      ' Populate the DataGridView with GameTypes that will be imported.
      Call LoadGrid()

      ' Position and size this form to last saved state.
      With My.Settings
         Me.Location = .IAMDC3PLocation
         Me.Size = .IAMDC3PSize
      End With

   End Sub

#End Region

#Region "Private Subroutines"

   Private Sub ImportAmdC3PData()
      '--------------------------------------------------------------------------------
      ' Perform EZTab 2.0 and/or SkilTab Import.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAddBank As AddBank
      Dim lBankInfo As BankInfo

      Dim lDlgResult As Windows.Forms.DialogResult

      Dim lReturnCode As Boolean = True
      Dim lServiceWasOn As Boolean = False

      Dim lProgressiveTypeID As Integer

      Dim lErrorText As String = ""
      Dim lGameTypeCode As String
      Dim lServiceName As String = ""
      Dim lUserConfirm As String

      ' Populate import flags
      If SetImportFlags() Then
         ' Create an IMPORT_MD_HISTORY record.
         If CreateImportMDHistoryRow(lErrorText) Then
            ' Successfully created IMPORT_MD_HISTORY row so load Setup data.
            '  The LoadSetupData function attempts to update LotteryRetail database tables.
            lReturnCode = LoadSetupData()

            ' If the load was successful, reset the success flag in the ImportHistoryMD table.
            If lReturnCode Then
               Call SetImportSuccessFlag()

               For Each lDR As DataRow In mDSImportXMLData.Tables("GAME_TYPE").Rows
                  lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
                  lProgressiveTypeID = lDR.Item("PROGRESSIVE_TYPE_ID")

                  lUserConfirm = String.Format("Do you want to add a Bank for Game Type Code {0}?", lGameTypeCode)
                  If MessageBox.Show(lUserConfirm, "Add Bank", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = Windows.Forms.DialogResult.Yes Then
                     lAddBank = New AddBank
                     lBankInfo = New BankInfo

                     ' Setup BankInfo with default values...
                     With lBankInfo
                        .IsActive = True
                        .IsPaper = False
                        .IsProgressive = (lProgressiveTypeID > 0)
                        .ProductID = lDR.Item("PRODUCT_ID")
                        .EntryTicketFactor = 100
                        .GameTypeCode = lGameTypeCode
                        .BankDescription = lDR.Item("LONG_NAME")
                        .DbaLockupAmount = 0
                        .EntryTicketAmount = 0
                        .LockupAmount = 1200.0
                        .ProgressiveAmount = 0
                     End With

                     ' Assign to the BankSetup Property of the AddBank form.
                     lAddBank.BankSetup = lBankInfo

                     Do
                        ' Show the AddBank form as a dialog. Did the user click the Add button?
                        lDlgResult = lAddBank.ShowDialog(Me)

                        If lDlgResult = Windows.Forms.DialogResult.Yes Then
                           ' Yes, so retrieve BankSetup values and send to the AddBank routine...
                           lBankInfo = lAddBank.BankSetup
                           If AddBank(lBankInfo) Then
                              Exit Do
                           Else
                              ' If Bank insert failed, allow user to try again or not...
                              lUserConfirm = "Failed to add a Bank for Game Type Code " & _
                                             lGameTypeCode & ". Do you want to try again?"
                              If MessageBox.Show(lUserConfirm, _
                                                 "Add Bank", _
                                                 MessageBoxButtons.YesNo, _
                                                 MessageBoxIcon.Question) = Windows.Forms.DialogResult.No Then Exit Do
                           End If
                        ElseIf lDlgResult = Windows.Forms.DialogResult.Cancel Then
                           ' User cancelled, exit inner-most Do/Loop.
                           Exit Do
                        End If
                     Loop
                  End If
               Next
            End If

            ' Reset status text.
            sbrStatus.Text = "Finished"

         End If

         Try
            ' Launch the Master Deal Import Report...
            Dim lRVRSL As New ReportViewRSLocal

            ' Retrieve report data.
            Dim lSDA As New SqlDataAccess(gConnectRetail, False, 90)
            Dim lDT As DataTable
            lDT = lSDA.CreateDataTable(String.Format("EXEC rpt_MasterDealImport {0}", mImportMDHistoryID))

            ' Drop the connection to the LotteryRetail database.
            If Not lSDA Is Nothing Then lSDA.Dispose()

            ' Show the report...
            With lRVRSL
               .MdiParent = Me.MdiParent
               .ShowReport(lDT, "Master Deal Import Report")
               .Show()
            End With

         Catch ex As Exception
            ' Handle the error.
            lErrorText = Me.Name & "::btnImport_Click: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Master Deal Import Report Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End Try
      Else
         ' Failed to create IMPORT_MD_HISTORY row, log and show the error.
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      sbrStatus.Text = ""

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
                  .Width = 52
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Code"
               End With

            Case "LONG_NAME"
               With lDgvColumn
                  .DisplayIndex = 1
                  .Width = 320
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderText = "Long Name"
               End With

            Case "TYPE_ID"
               With lDgvColumn
                  .DisplayIndex = 2
                  .Width = 72
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Deal Type"
               End With

            Case "MAX_COINS_BET"
               With lDgvColumn
                  .DisplayIndex = 3
                  .Width = 72
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Max Coins"
               End With

            Case "MAX_LINES_BET"
               With lDgvColumn
                  .DisplayIndex = 4
                  .Width = 74
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Max Lines"
               End With

            Case "PROGRESSIVE_TYPE_ID"
               With lDgvColumn
                  .DisplayIndex = 5
                  .Width = 100
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Progressive ID"
               End With

            Case "PRODUCT_ID"
               With lDgvColumn
                  .DisplayIndex = 6
                  .Width = 76
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Product ID"
               End With

            Case Else
               ' Hide any columns not handled above.
               lDgvColumn.Visible = False

         End Select
      Next

   End Sub

   Private Sub LoadGrid()
      '--------------------------------------------------------------------------------
      ' Removes data from the mDSImportXMLData DataSet that will not be imported,
      ' then populates the Grid control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lDT As DataTable

      Dim lIndex As Integer

      Dim lGameTypeCode As String
      Dim lRemoveGTC As String = ""

      ' Set a reference to the GAME_TYPE DataTable.
      lDT = mDSImportXMLData.Tables("GAME_TYPE")

      ' Remove any GameType rows that are not in the list of GameTypes to import...
      For lIndex = lDT.Rows.Count - 1 To 0 Step -1
         lDR = lDT.Rows(lIndex)
         lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
         If Array.IndexOf(Of String)(mGameTypeList, lGameTypeCode) = -1 Then
            ' Not in the list of game types to import, so delete the row.
            lDR.Delete()
         End If
      Next

      ' Populate the DataGridView control with Game Type data...
      dgvGameTypes.DataSource = lDT
      Call InitGrid()

   End Sub

   Private Sub SetImportSuccessFlag()
      '--------------------------------------------------------------------------------
      ' Reset SUCCESS flag in IMPORT_MD_HISTORY
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing

      Dim lErrorText As String = ""
      Dim lSQL As String

      ' Build update statement.
      lSQL = String.Format("UPDATE IMPORT_MD_HISTORY SET SUCCESSFUL = 1 WHERE IMPORT_MD_HISTORY_ID = {0}", mImportMDHistoryID)

      ' Peform the update.
      Try
         lSDA = New SqlDataAccess(gConnectRetail, False, 60)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the error.
         lErrorText = "SetImportSuccessFlag failed: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup.
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
      End Try

   End Sub

#End Region

#Region "Private Functions"

   Private Function AddBank(ByVal aBankInfo As BankInfo) As Boolean
      '--------------------------------------------------------------------------------
      ' Add a Bank Table row.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lSB As New StringBuilder(512)

      Dim lReturn As Boolean = True

      Dim lDetailText As String
      Dim lErrorText As String
      Dim lSQL As String

      Dim lIsPaper As Char
      Dim lIsProgressive As Char

      ' Convert paper and progressive flags to Char values...
      If aBankInfo.IsPaper Then
         lIsPaper = "1"
      Else
         lIsPaper = "0"
      End If

      ' Convert paper and progressive flags to Char values...
      If aBankInfo.IsProgressive Then
         lIsProgressive = "1"
      Else
         lIsProgressive = "0"
      End If

      lSB.Append("INSERT INTO BANK (BANK_NO, BANK_DESCR, PROG_FLAG, PROG_AMT, ")
      lSB.Append("GAME_TYPE_CODE, PRODUCT_LINE_ID, IS_PAPER, LOCKUP_AMOUNT, ")
      lSB.Append("ENTRY_TICKET_FACTOR, DBA_LOCKUP_AMOUNT) VALUES (")
      lSB.Append(aBankInfo.BankNumber).Append(", '")
      lSB.Append(aBankInfo.BankDescription).Append("', ")
      lSB.Append(lIsProgressive).Append(", ")
      lSB.Append(aBankInfo.ProgressiveAmount).Append(", '")
      lSB.Append(aBankInfo.GameTypeCode).Append("', ")
      lSB.Append(aBankInfo.ProductLineID).Append(", ")
      lSB.Append(lIsPaper).Append(", ")
      lSB.Append(aBankInfo.LockupAmount).Append(", ")
      lSB.Append(aBankInfo.EntryTicketFactor).Append(", ")
      lSB.Append(aBankInfo.DbaLockupAmount).Append(")")


      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 30)

         ' Insert the row...
         lSQL = lSB.ToString
         lSDA.ExecuteSQLNoReturn(lSQL)

         ' Insert a row into the IMPORT_MD_DETAIL table.
         lDetailText = String.Format("Successfully Inserted Bank {0}.", aBankInfo.BankNumber)
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "BANK", lDetailText, 1, 0, 0, 0)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception.
         lReturn = False
         lErrorText = Me.Name & "::AddBank error: " & ex.Message
         MessageBox.Show(lErrorText, "Add Bank Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         Logging.Log(lErrorText)

      Finally
         ' Cleanup.
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function CreateImportMDHistoryRow(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Inserts a row into IMPORT_MD_HISTORY, sets mImportMDHistoryID, returns
      ' True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lErrorText As String = ""
      Dim lReturn As Boolean = True


      ' Initialize error text to an empty string.
      aErrorText = ""

      ' Insert a row into IMPORT_MD_HISTORY.
      Try
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)
         With lSDA
            .AddParameter("@ImportedBy", SqlDbType.VarChar, gAppUserName, 64)
            .AddParameter("@ExportedBy", SqlDbType.VarChar, mImportFlags.ExportedBy, 64)
            .AddParameter("@ExportDate", SqlDbType.DateTime, mImportFlags.ExportDate)
            .AddParameter("@CasinoUpdate", SqlDbType.Bit, mImportFlags.CasinoTable)
            .AddParameter("@BankMachUpdate", SqlDbType.Bit, mImportFlags.BankMachineTables)
            .AddParameter("@Success", SqlDbType.Bit, False)

            ' Execute the procedure.
            .ExecuteProcedureNoResult("diInsertImportMDHistory")

            ' Store the IMPORT_MD_HISTORY_ID value returned from the diInsertImportMDHistory stored procedure.
            ' This value will be used when inserting IMPORT_MD_DETAIL rows.
            mImportMDHistoryID = .ReturnValue
         End With

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         aErrorText = Me.Name & "::CreateImportMDHistoryRow Error: " & ex.Message

      Finally
         ' Close and free the database object...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function LoadSetupData() As Boolean
      '--------------------------------------------------------------------------------
      ' Loads the Setup Data that accompanies Master Deal data.
      ' Returns T/F to indicate success of failure.
      '
      ' Note: This routine does not setup a row in the DEAL_SETUP table, tha's done by
      '       the Deal Server Service which calls stored procedure dsInsertDealSetup.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      ' Update UI...
      With sbrStatus
         .Text = "Loading LotteryRetail database setup data..."
         .Refresh()
      End With
      Application.DoEvents()

      ' Approved masters will not have Casino setup info, so comment this section for now.
      ' Begin with the Casino table.
      'If mImportFlags.CasinoTable Then
      '   ' Export user indicated that the Casino table is to be updated.
      '   lReturn = UpdateCasinoTable()
      'End If

      ' Update the PRODUCT table.
      If lReturn Then lReturn = UpdateProductTable()

      ' Update the PRODUCT_LINE table.
      If lReturn Then lReturn = UpdateProductLineTable()

      ' Update the GAME_CATEGORY table.
      If lReturn Then lReturn = UpdateGameCategoryTable()

      ' Update the PROGRESSIVE_TYPE table.
      If lReturn Then lReturn = UpdateProgressiveTypeTable()

      ' Update the GAME_TYPE table.
      If lReturn Then lReturn = UpdateGameTypeTable()

      ' Update the PROGRESSIVE_POOL table.
      If lReturn Then lReturn = UpdateProgressivePoolTable()

      ' Update the PROG_AWARD_FACTOR table.
      If lReturn Then lReturn = UpdateProgAwardFactorTable()

      ' Update the GAME_SETUP table.
      If lReturn Then lReturn = UpdateGameSetupTable()

      ' Update the DENOM_TO_GAME_TYPE table.
      If lReturn Then lReturn = UpdateDenomTable()

      ' Update the COINS_BET_TO_GAME_TYPE table.
      If lReturn Then lReturn = UpdateCoinsBetTable()

      ' Update the LINES_BET_TO_GAME_TYPE table.
      If lReturn Then lReturn = UpdateLinesBetTable()

      ' Update the PAYSCALE table.
      If lReturn Then lReturn = UpdatePayscaleTable()

      ' Update the PAYSCALE_TIER table.
      If lReturn Then lReturn = UpdatePayscaleTierTable()

      ' Update the PAYSCALE_TIER_KENO table.
      If lReturn Then lReturn = UpdatePayscaleTierKenoTable()

      ' Lab Approved master media does not include Casino specific data,
      ' so Banks and Machines will not be created or updated.

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function RemoveNonImportData() As Boolean
      '--------------------------------------------------------------------------------
      ' Removed data from that will not be imported.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lDT As DataTable

      Dim lReturn As Boolean = True

      Dim lErrorText As String = ""
      Dim lFlareIDList As String = ","
      Dim lGameTypeCode As String
      Dim lMasterDealIDList As String = ","
      Dim lMatchValue As String
      Dim lPayscaleList As String = ","
      Dim lSearchList As String = ""

      Dim lRowCount As Integer
      Dim lRowNumber As Integer

      Try
         ' GAME_SETUP
         sbrStatus.Text = "Setting Game Setup data..."

         lDT = mDSImportXMLData.Tables("GAME_SETUP")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
               If Array.IndexOf(Of String)(mGameTypeList, lGameTypeCode) = -1 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' DENOM_TO_GAME_TYPE
         sbrStatus.Text = "Setting Denom to Game Type data..."

         lDT = mDSImportXMLData.Tables("DENOM_TO_GAME_TYPE")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
               If Array.IndexOf(Of String)(mGameTypeList, lGameTypeCode) = -1 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' COINS_BET_TO_GAME_TYPE
         sbrStatus.Text = "Setting Coins Bet to Game Type data..."

         lDT = mDSImportXMLData.Tables("COINS_BET_TO_GAME_TYPE")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
               If Array.IndexOf(Of String)(mGameTypeList, lGameTypeCode) = -1 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' LINES_BET_TO_GAME_TYPE
         sbrStatus.Text = "Setting Lines Bet to Game Type data..."

         lDT = mDSImportXMLData.Tables("LINES_BET_TO_GAME_TYPE")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
               If Array.IndexOf(Of String)(mGameTypeList, lGameTypeCode) = -1 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' PAYSCALE
         sbrStatus.Text = "Setting Payscale data..."
         lDT = mDSImportXMLData.Tables("PAYSCALE")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
               If Array.IndexOf(Of String)(mGameTypeList, lGameTypeCode) = -1 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               Else
                  ' Keeper, add to list so we can delete proper payscale tier data.
                  lPayscaleList &= String.Format("{0},", lDR.Item("PAYSCALE_NAME"))
               End If
            Next
         End If

         ' PAYSCALE_TIER
         sbrStatus.Text = "Setting Payscale Tier data..."
         lDT = mDSImportXMLData.Tables("PAYSCALE_TIER")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("PAYSCALE_NAME"))
               If lPayscaleList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of payscale names to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' PAYSCALE_TIER_KENO
         sbrStatus.Text = "Setting Payscale Tier data..."
         lDT = mDSImportXMLData.Tables("PAYSCALE_TIER_KENO")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("PAYSCALE_NAME"))
               If lPayscaleList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of payscale names to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' Create a csv list of PROGRESSIVE_TYPE_ID values from the Progressive_Pool table
         lSearchList = ","
         lDT = mDSImportXMLData.Tables("PROGRESSIVE_POOL")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For Each lDR In lDT.Rows
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
               If Array.IndexOf(Of String)(mGameTypeList, lGameTypeCode) > -1 Then
                  ' Keeper, add PROGRESSIVE_TYPE_ID to list.
                  lSearchList &= String.Format("{0},", lDR.Item("PROGRESSIVE_TYPE_ID"))
               End If
            Next
         End If

         ' PROGRESSIVE_TYPE
         sbrStatus.Text = "Setting Progressive Type data..."
         lDT = mDSImportXMLData.Tables("PROGRESSIVE_TYPE")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("PROGRESSIVE_TYPE_ID"))
               ' Progressive of 0 is for non-progressive games.
               If lMatchValue <> ",0," Then
                  If lSearchList.IndexOf(lMatchValue) < 0 Then
                     ' Not in the list of Progressive types to import, so delete the row.
                     lDR.Delete()
                  End If
               End If
            Next
         End If

         ' PROGRESSIVE_POOL
         sbrStatus.Text = "Setting Progressive Pool data..."
         lDT = mDSImportXMLData.Tables("PROGRESSIVE_POOL")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("PROGRESSIVE_TYPE_ID"))
               ' Progressive of 0 is for non-progressive games.
               If lMatchValue <> ",0," Then
                  If lSearchList.IndexOf(lMatchValue) < 0 Then
                     ' Not in the list of Progressive types to import, so delete the row.
                     lDR.Delete()
                  End If
               End If
            Next
         End If

         ' PROG_AWARD_FACTOR
         sbrStatus.Text = "Setting Progressive Award Factor data..."
         lDT = mDSImportXMLData.Tables("PROG_AWARD_FACTOR")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("PROGRESSIVE_TYPE_ID"))
               ' Progressive of 0 is for non-progressive games.
               If lMatchValue <> ",0," Then
                  If lSearchList.IndexOf(lMatchValue) < 0 Then
                     ' Not in the list of Progressive types to import, so delete the row.
                     lDR.Delete()
                  End If
               End If
            Next
         End If

      Catch ex As Exception
         ' Handle the exception. Reset the function return value to False.
         lReturn = False

         ' Build error text, then log and show it...
         lErrorText = Me.Name & "::RemoveNonImportData error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function SetImportFlags() As Boolean
      '--------------------------------------------------------------------------------
      ' Inserts a row into IMPORT_MD_HISTORY, sets mImportMDHistoryID, returns
      ' True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lDT As DataTable
      Dim lErrorText As String = ""
      Dim lReturn As Boolean = True

      Try
         ' Set a reference to the ImportFlags table.
         lDT = mDSImportXMLData.Tables("ImportFlags")

         ' Set a reference to the first row of the ImportFlags table.
         lDR = lDT.Rows(0)

         ' Set Import Flags...
         With mImportFlags
            .ExportDate = lDR.Item("ExportDate")
            .ExportedBy = lDR.Item("ExportedBy")
            .CasinoTable = lDR.Item("CasinoTable")
            .BankMachineTables = False
            .BankUpdate = lDR.Item("Bank")
            .MachineUpdate = lDR.Item("Machine")
            .GameTypeUpdate = True
            .DenomToGameTypeUpdate = True
            .CoinsBetToGameTypeUpdate = True
            .LinesBetToGameTypeUpdate = True
            .GameSetupUpdate = True
            .PayscaleUpdate = True
            .PayscaleTierUpdate = True
            .FormUpdate = False
            .FlareUpdate = False
            .WinningTierUpdate = False
            .DealGenLongVersion = lDR.Item("DealGenLongVersion")

         End With

      Catch ex As Exception
         ' Handle the exception...
         lReturn = False
         lErrorText = Me.Name & "::SetImportFlags error: " & ex.Message

      End Try

      ' If we have error text, log and show it...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateCoinsBetTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CoinsBetToGameType table.
      '
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "COINS_BET_TO_GAME_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the COINS_BET_TO_GAME_TYPE table.
         For Each lDR In mDSImportXMLData.Tables("COINS_BET_TO_GAME_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertCoinsBetToGameType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means already exists and ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Already exists, ignored.
                  lIgnoredCount += 1

               Case Else
                  ' Database error occurred.
                  lReturn = False
                  lErrorText = String.Format("diInsertCoinsBetToGameType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing COINS_BET_TO_GAME_TYPE data."
         lErrorText = Me.Name & "::UpdateCoinsBetTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "COINS_BET_TO_GAME_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateDenomTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the DenomToGameType table.
      ' 
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "DENOM_TO_GAME_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the DENOM_TO_GAME_TYPE table.
         For Each lDR In mDSImportXMLData.Tables("DENOM_TO_GAME_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@Denom", SqlDbType.SmallMoney, lDR.Item("DENOM_VALUE"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertDenomToGameType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means already exists and ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Already exists, ignored.
                  lIgnoredCount += 1

               Case Else
                  ' Database error occurred.
                  lReturn = False
                  lErrorText = String.Format("diInsertDenomToGameType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing DENOM_TO_GAME_TYPE data."
         lErrorText = Me.Name & "::UpdateDenomTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "DENOM_TO_GAME_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateGameCategoryTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the GAME_CATEGORY table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "GAME_CATEGORY Import successful."
      Dim lErrText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PRODUCT table.
         For Each lDR In mDSImportXMLData.Tables("GAME_CATEGORY").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameCategoryID", SqlDbType.Int, lDR.Item("GAME_CATEGORY_ID"))
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@LimitRTransTiers", SqlDbType.Bit, lDR.Item("LIMIT_RTRANS_TIERS"))
               .AddParameter("@SortOrder", SqlDbType.Int, lDR.Item("SORT_ORDER"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertGameCategory")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means successful update, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted. 0 = Successful row insertion
                  lInsertCount += 1
               Case 1
                  ' Updated. 1 = Record exists and update flag = 1 (record updated)
                  lUpdateCount += 1
               Case 2
                  ' Ignored. 2 = Record exists and update flag = 0 (update ignored)
                  lIgnoredCount += 1

               Case Else
                  lReturn = False
                  lErrText = String.Format("diInsertGameCategory failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrText = "Error updating the Product Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing GAME_CATEGORY data."
         lErrText = Me.Name & "::UpdateGameCategoryTable: " & lErrText
         Logging.Log(lErrText)
         MessageBox.Show(lErrText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         lDetailText = "Error importing GAME_CATEGORY data."
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "GAME_CATEGORY", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateGameSetupTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the GameSetup table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "GAME_SETUP Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the GAME_SETUP table.
         For Each lDR In mDSImportXMLData.Tables("GAME_SETUP").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameCode", SqlDbType.VarChar, lDR.Item("GAME_CODE"), 3)
               .AddParameter("@GameDesc", SqlDbType.VarChar, lDR.Item("GAME_DESC"), 64)
               .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("TYPE_ID"), 1)
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@GameTitleID", SqlDbType.Int, lDR.Item("GAME_TITLE_ID"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameSetupUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertGameSetup")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertGameSetup failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing GAME_SETUP data."
         lErrorText = Me.Name & "::UpdateGameSetupTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "GAME_SETUP", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateGameTypeTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the GameType table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "GAME_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the GAME_TYPE table.
         For Each lDR In mDSImportXMLData.Tables("GAME_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("TYPE_ID"), 1)
               .AddParameter("@ProductID", SqlDbType.TinyInt, lDR.Item("PRODUCT_ID"))
               .AddParameter("@ProgressiveTypeID", SqlDbType.TinyInt, lDR.Item("PROGRESSIVE_TYPE_ID"))
               .AddParameter("@MaxCoinsBet", SqlDbType.SmallInt, lDR.Item("MAX_COINS_BET"))
               .AddParameter("@MaxLinesBet", SqlDbType.TinyInt, lDR.Item("MAX_LINES_BET"))
               .AddParameter("@GameCategoryID", SqlDbType.Int, lDR.Item("GAME_CATEGORY_ID"))
               .AddParameter("@BarcodeTypeID", SqlDbType.SmallInt, lDR.Item("BARCODE_TYPE_ID"))
               .AddParameter("@ShowPayCredits", SqlDbType.Bit, lDR.Item("SHOW_PAY_CREDITS"))
               .AddParameter("@MultiBetDeals", SqlDbType.Bit, lDR.Item("MULTI_BET_DEALS"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameTypeUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertGameType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertGameType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing GAME_TYPE data."
         lErrorText = Me.Name & "::UpdateGameTypeTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "GAME_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateLinesBetTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the LinesBetToGameType table.
      ' aRowCount will contain the number of rows deleted prior to this function call.
      '
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "LINES_BET_TO_GAME_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the LINES_BET_TO_GAME_TYPE table.
         For Each lDR In mDSImportXMLData.Tables("LINES_BET_TO_GAME_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LINES_BET"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertLinesBetToGameType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means already exists and ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Already exists, ignored.
                  lIgnoredCount += 1

               Case Else
                  ' Database error occurred.
                  lReturn = False
                  lErrorText = String.Format("diInsertLinesBetToGameType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing LINES_BET_TO_GAME_TYPE data."
         lErrorText = Me.Name & "::UpdateLinesBetTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "LINES_BET_TO_GAME_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdatePayscaleTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Payscale table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PAYSCALE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PAYSCALE table.
         For Each lDR In mDSImportXMLData.Tables("PAYSCALE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PAYSCALE_NAME"), 16)
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.PayscaleUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertPayscale")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertPayscale failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PAYSCALE data."
         lErrorText = Me.Name & "::UpdatePayscaleTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PAYSCALE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdatePayscaleTierKenoTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PayscaleTierKeno table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PAYSCALE_TIER_KENO Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PAYSCALE_TIER_KENO table.
         For Each lDR In mDSImportXMLData.Tables("PAYSCALE_TIER_KENO").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PAYSCALE_NAME"), 16)
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
               .AddParameter("@PickCount", SqlDbType.SmallInt, lDR.Item("PICK_COUNT"))
               .AddParameter("@HitCount", SqlDbType.SmallInt, lDR.Item("HIT_COUNT"))
               .AddParameter("@AwardFactor", SqlDbType.Decimal, lDR.Item("AWARD_FACTOR"))
               .AddParameter("@TierWinType", SqlDbType.TinyInt, lDR.Item("TIER_WIN_TYPE"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.PayscaleTierUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertPayscaleTierKeno")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertPayscaleTierKeno failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PAYSCALE_TIER_KENO data."
         lErrorText = Me.Name & "::UpdatePayscaleTierKenoTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PAYSCALE_TIER_KENO", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdatePayscaleTierTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PayscaleTier table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PAYSCALE_TIER Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lCount As Integer = 0
      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PAYSCALE_TIER table.
         For Each lDR In mDSImportXMLData.Tables("PAYSCALE_TIER").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PAYSCALE_NAME"), 16)
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
               .AddParameter("@CoinsWon", SqlDbType.Int, lDR.Item("COINS_WON"))
               .AddParameter("@Icons", SqlDbType.VarChar, lDR.Item("ICONS"), 32)
               .AddParameter("@IconMask", SqlDbType.VarChar, lDR.Item("ICON_MASK"), 32)
               .AddParameter("@TierWinType", SqlDbType.TinyInt, lDR.Item("TIER_WIN_TYPE"))
               .AddParameter("@UseMultiplier", SqlDbType.Bit, lDR.Item("USE_MULTIPLIER"))
               .AddParameter("@ScatterCount", SqlDbType.TinyInt, lDR.Item("SCATTER_COUNT"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.PayscaleTierUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertPayscaleTier")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertPayscaleTier failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select

            ' Increment loop counter and call DoEvents every 200 iterations so user won't
            ' think the application has crashed...
            lCount += 1
            If lCount Mod 200 = 0 Then
               Application.DoEvents()
            End If

         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PAYSCALE_TIER data."
         lErrorText = Me.Name & "::UpdatePayscaleTierTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PAYSCALE_TIER", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProductLineTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the ProductLine table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PRODUCT_LINE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PRODUCT_LINE table.
         For Each lDR In mDSImportXMLData.Tables("PRODUCT_LINE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@ProductLineID", SqlDbType.SmallInt, lDR.Item("PRODUCT_LINE_ID"))
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@GameClass", SqlDbType.SmallInt, lDR.Item("GAME_CLASS"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertProductLine")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means successful update, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' New row successfully inserted.
                  lInsertCount += 1
               Case 1
                  ' Existing row successfully updated.
                  lUpdateCount += 1
               Case Else
                  ' Database error.
                  lReturn = False
                  lErrorText = String.Format("diInsertProductLine failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PRODUCT_LINE data."
         lErrorText = Me.Name & "::UpdateProductLineTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PRODUCT_LINE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProductTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Product table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PRODUCT Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PRODUCT table.
         For Each lDR In mDSImportXMLData.Tables("PRODUCT").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@ProductID", SqlDbType.TinyInt, lDR.Item("PRODUCT_ID"))
               .AddParameter("@ProductName", SqlDbType.VarChar, lDR.Item("PRODUCT_DESCRIPTION"), 64)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertProduct")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 means successful insertion, 1 means successful update, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted.
                  lInsertCount += 1
               Case 1
                  ' Updated.
                  lUpdateCount += 1
               Case Else
                  lReturn = False
                  lErrorText = String.Format("diInsertProduct failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = "Error updating the Product Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PRODUCT data."
         lErrorText = Me.Name & "::UpdateProductTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PRODUCT", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProgAwardFactorTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PROG_AWARD_FACTOR table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lDetailText As String = "PROG_AWARD_FACTOR Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to the PROG_AWARD_FACTOR table.
         lDT = mDSImportXMLData.Tables("PROG_AWARD_FACTOR")

         ' Process each row in the PROG_AWARD_FACTOR table...
         For Each lDR In lDT.Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@ProgAwardFactorID", SqlDbType.Int, lDR.Item("PROG_AWARD_FACTOR_ID"))
               .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
               .AddParameter("@AwardFactor", SqlDbType.Int, lDR.Item("AWARD_FACTOR"))
               ' We will use the Game Type update flag value.
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameTypeUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertProgAwardFactor")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertProgAwardFactor failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = "Error updating the PROG_AWARD_FACTOR Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PROG_AWARD_FACTOR data."
         lErrorText = Me.Name & "::UpdateProgAwardFactorTable error: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PROG_AWARD_FACTOR", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProgressivePoolTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PROGRESSIVE_POOL table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lDetailText As String = "PROGRESSIVE_POOL Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Set a reference to the PROGRESSIVE_POOL table.
         lDT = mDSImportXMLData.Tables("PROGRESSIVE_POOL")

         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Is there data to process?
         If lDT.Rows.Count > 0 Then
            ' Yes, so set a reference to each row in the PROGRESSIVE_POOL table.
            For Each lDR In lDT.Rows
               With lSDA
                  ' Add the stored procedure parameters...
                  .AddParameter("@ProgressivePoolID", SqlDbType.Int, lDR.Item("PROGRESSIVE_POOL_ID"))
                  .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
                  .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                  .AddParameter("@Denomination", SqlDbType.Int, lDR.Item("DENOMINATION"))
                  .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))
                  .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LINES_BET"))
                  .AddParameter("@Pool1", SqlDbType.Money, lDR.Item("POOL_1"))
                  .AddParameter("@Pool2", SqlDbType.Money, lDR.Item("POOL_2"))
                  .AddParameter("@Pool3", SqlDbType.Money, lDR.Item("POOL_3"))
                  ' We will use the Game Type update flag value.
                  .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameTypeUpdate)

                  ' Execute the procedure.
                  .ExecuteProcedureNoResult("diInsertProgressivePool")

                  ' Capture the value returned from the procedure.
                  lSpReturnCode = lSDA.ReturnValue
               End With

               ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
               Select Case lSpReturnCode
                  Case 0
                     ' Inserted a new record.
                     lInsertCount += 1
                  Case 1
                     ' Existing record Updated.
                     lUpdateCount += 1
                  Case 2
                     ' Existing record Ignored.
                     lIgnoredCount += 1
                  Case Else
                     ' Unexpected return code indicates that a stored procedure error occurred.
                     lErrorCount += 1
                     lReturn = False
                     lErrorText = String.Format("diInsertProgressivePool failed, returned {0}.", lSpReturnCode)
                     Exit For
               End Select
            Next
         End If

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = "Error updating the PROGRESSIVE_POOL Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PROGRESSIVE_POOL data."
         lErrorText = Me.Name & "::UpdateProgressivePoolTable error: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PROGRESSIVE_POOL", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateProgressiveTypeTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the PROGRESSIVE_TYPE table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "PROGRESSIVE_TYPE Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PROGRESSIVE_TYPE table.
         For Each lDR In mDSImportXMLData.Tables("PROGRESSIVE_TYPE").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
               .AddParameter("@PoolCount", SqlDbType.SmallInt, lDR.Item("POOL_COUNT"))
               .AddParameter("@TotalContribution", SqlDbType.Decimal, lDR.Item("TOTAL_CONTRIBUTION"))
               .AddParameter("@SeedCount", SqlDbType.Int, lDR.Item("SEED_COUNT"))
               .AddParameter("@Rate1", SqlDbType.Decimal, lDR.Item("RATE_1"))
               .AddParameter("@Rate2", SqlDbType.Decimal, lDR.Item("RATE_2"))
               .AddParameter("@Rate3", SqlDbType.Decimal, lDR.Item("RATE_3"))
               .AddParameter("@RateCombined", SqlDbType.Decimal, lDR.Item("RATE_COMBINED"))
               ' We will use the Game Type update flag value.
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.GameTypeUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertProgressiveType")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case 1
                  ' Existing record Updated.
                  lUpdateCount += 1
               Case 2
                  ' Existing record Ignored.
                  lIgnoredCount += 1
               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertProgressiveType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = "Error updating the PROGRESSIVE_TYPE Table: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing PROGRESSIVE_TYPE data."
         lErrorText = Me.Name & "::UpdateProgressiveTypeTable error: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PROGRESSIVE_TYPE", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

#End Region

#Region "Form Properties"

   Friend WriteOnly Property GameTypeList() As String()
      '--------------------------------------------------------------------------------
      ' Sets the list of GameTypeCodes as an array of strings to be imported.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String())
         mGameTypeList = value
      End Set

   End Property

   Friend WriteOnly Property ImportXMLData() As DataSet
      '--------------------------------------------------------------------------------
      ' Sets a reference to a DataSet containing data to import.
      '--------------------------------------------------------------------------------

      Set(ByVal value As DataSet)
         mDSImportXMLData = value
      End Set

   End Property

   Friend WriteOnly Property SourceFolder() As String
      '--------------------------------------------------------------------------------
      ' Sets the source folder containing import data.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String)
         mSourceFolder = value
      End Set

   End Property

#End Region

End Class