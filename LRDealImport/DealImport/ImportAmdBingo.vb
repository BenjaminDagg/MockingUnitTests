Imports System.Text

Public Class ImportAmdBingo

   ' Private vars...
   Private mDSImportXMLData As DataSet
   Private mImportFlags As New ImportFlags

   Private mImportMDHistoryID As Integer

   Private mMaxRevShare As Short

   Private mImportDealSQLBase As String
   Private mSourceFolder As String

   Private mGameTypeCodeList() As String

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
      ' Allocate local vars...
      Dim lValueShort As Short
      Dim lErrorText As String = ""


      ' If txtRevSharePercent is not readonly, then user must enter a rev share percent...
      If txtRevSharePercent.ReadOnly = False Then
         ' Attempt to convert user value to a short.
         If Short.TryParse(txtRevSharePercent.Text, lValueShort) = False Then
            ' Conversion failed, set error text.
            lErrorText = "Could not convert Revenue Share Percent to a whole number value."
         ElseIf lValueShort < 5 OrElse lValueShort > 60 Then
            ' User value is out of range, set error text.
            lErrorText = "Invalid Revenue Share Percent, enter a whole number value between 5 and 60."
         End If

         ' Do we have error text?
         If lErrorText.Length = 0 Then
            ' No, so reset the MaxRevShare value to the user entered value.
            mMaxRevShare = lValueShort
         Else
            ' Yes, we have error text, show it then bail out...
            MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
         End If
      End If

      ' Disable appropriate UI items...
      btnCancel.Enabled = False
      btnImport.Enabled = False
      dgvGameTypes.Enabled = False

      ' Attempt to remove data from the DataSet that will not be imported.
      If RemoveNonImportData() Then
         ' Removal was successful, so begin the import process...
         Call ImportAmdData()
      End If

      ' Enable the Cancel button and change the text from Cancel to Close...
      With btnCancel
         .Text = "Close"
         .Enabled = True
      End With

   End Sub

   Private Sub dgvGameTypes_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dgvGameTypes.SelectionChanged
      '--------------------------------------------------------------------------------
      ' SelectionChanged event handler for the DataGridView (Import Game Type list) control.
      '--------------------------------------------------------------------------------

      ' Deselect all rows...
      Call ClearGridRowSelection()

   End Sub

   Private Sub Me_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Activated
      '--------------------------------------------------------------------------------
      ' Activated event handler for this form.
      '--------------------------------------------------------------------------------

      ' Deselect all rows...
      Call ClearGridRowSelection()

   End Sub

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Save window state info for next time this form is opened.
      With My.Settings
         .IAMDBingoLocation = Me.Location
         .IAMDBingoSize = Me.Size
         .IAMDBingoFWS = FormWindowState.Normal
         .Save()
      End With

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Build the base SQL Insert statement for the IMPORT_MD_DETAIL table.
      mImportDealSQLBase = "INSERT INTO IMPORT_MD_DETAIL " & _
         "(IMPORT_MD_HISTORY_ID, TABLE_NAME, DETAIL_TEXT, INSERT_COUNT, UPDATE_COUNT, IGNORED_COUNT, ERROR_COUNT) " & _
         "VALUES ({0},'{1}','{2}',{3},{4},{5},{6})"

      ' Retrieve the max rev share percent from CASINO_FORMS.
      mMaxRevShare = GetMaxRevSharePercent()

      ' Is Max Revenue Share percent zero?
      If mMaxRevShare = 0 Then
         ' Max revenue share percent is zero, allow user to set it by enabling txtRevSharePercent...
         With txtRevSharePercent
            .ReadOnly = False
            .TabStop = True
         End With
      Else
         ' Max revenue share percent is already set, make it readonly and show the value...
         With txtRevSharePercent
            .ReadOnly = True
            .TabStop = False
            .Text = mMaxRevShare.ToString
         End With
      End If

      ' Populate the DataGridView with GameTypes that will be imported.
      Call LoadGrid()

      ' Position and size this form to last saved state.
      With My.Settings
         Me.Location = .IAMDBingoLocation
         Me.Size = .IAMDBingoSize
         Me.WindowState = .IAMDBingoFWS
      End With

   End Sub

#End Region

#Region "Private Subroutines"

   Private Sub ClearGridRowSelection()
      '--------------------------------------------------------------------------------
      ' Deselects all grid rows.
      '--------------------------------------------------------------------------------

      ' Deselect all rows...
      If dgvGameTypes.SelectedRows.Count > 0 Then
         For Each lDGVR As DataGridViewRow In dgvGameTypes.SelectedRows
            lDGVR.Selected = False
         Next
      End If

   End Sub

   Private Sub ImportAmdData()
      '--------------------------------------------------------------------------------
      ' Perform EZTab Bingo Import.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAddBank As AddBank
      Dim lBankInfo As BankInfo

      Dim lReturnCode As Boolean = True

      Dim lProgressiveTypeID As Integer

      Dim lErrorText As String = ""
      Dim lGameTypeCode As String
      Dim lUserConfirm As String

      ' Populate import flags
      If SetImportFlags() Then
         ' Create an IMPORT_MD_HISTORY record.
         lReturnCode = CreateImportMDHistoryRow(lErrorText)

         If lReturnCode Then
            ' Load Master Deal Tables.
            ' The LoadMasterDeals function attempts to create and populate a Bingo Master table.
            lReturnCode = LoadMasterDeals()

            If lReturnCode Then
               ' Load Setup data.
               '  The LoadSetupData function attempts to update LotteryRetail database tables.
               lReturnCode = LoadSetupData()
               If lReturnCode Then
                  ' Now we need to update the CasinoBingo tables.
                  lReturnCode = LoadBingoSetupData()
               End If

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
                           If lAddBank.ShowDialog(Me) = Windows.Forms.DialogResult.Yes Then
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
                           Else
                              ' User clicked the Cancel button, exit the inner loop.
                              Exit Do
                           End If
                        Loop
                     End If
                  Next
               End If

               ' Reset status text.
               sbrStatus.Text = "Finished"

               Try
                  ' Launch the Master Deal Import Report...
                  Dim frmReportViewer As New ReportViewRSLocal

                  ' Retrieve report data.
                  Dim lSDA As New SqlDataAccess(gConnectRetail, False, 90)
                  Dim lDT As DataTable
                  lDT = lSDA.CreateDataTable(String.Format("EXEC rpt_MasterDealImport {0}", mImportMDHistoryID))

                  ' Drop the connection to the LotteryRetail database.
                  If lSDA IsNot Nothing Then
                     lSDA.Dispose()
                     lSDA = Nothing
                  End If

                  ' Show the report...
                  With frmReportViewer
                     .MdiParent = Me.MdiParent
                     .ShowReport(lDT, "Master Deal Import Report")
                     .Show()
                  End With

               Catch ex As Exception
                  ' Handle the error.
                  lErrorText = Me.Name & "::btnImport_Click: " & ex.Message
                  Logging.Log(lErrorText)
                  MessageBox.Show(lErrorText, "Bingo Master Import Report Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

               End Try

            Else
               ' LoadMasterDeals function returned False.
               sbrStatus.Text = "Finished with errors, check the log file."
            End If
         End If

      End If

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


      ' Write out table row counts before deleting GameType rows...
      'Debug.WriteLine("--------------- Before Dropping GameType Rows ---------------")
      'For lIndex = 0 To mDSImportXMLData.Tables.Count - 1
      '   lDT = mDSImportXMLData.Tables(lIndex)
      '   Debug.WriteLine(String.Format("Table {0} contains {1} rows.", lDT.TableName, lDT.Rows.Count))
      'Next

      ' Set a reference to the GAME_TYPE DataTable.
      lDT = mDSImportXMLData.Tables("GAME_TYPE")

      ' Remove any GameType rows that are not in the list of GameTypes to import...
      For lIndex = lDT.Rows.Count - 1 To 0 Step -1
         lDR = lDT.Rows(lIndex)
         lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
         If Array.IndexOf(Of String)(mGameTypeCodeList, lGameTypeCode) = -1 Then
            ' Not in the list of game types to import, so delete the row.
            lDR.Delete()
         End If
      Next

      ' Populate the DataGridView control with Game Type data...
      dgvGameTypes.DataSource = mDSImportXMLData.Tables("GAME_TYPE")

      ' Write out table row counts after deleting GameType rows...
      'Debug.WriteLine("--------------- After Dropping GameType Rows ---------------")
      'For lIndex = 0 To mDSImportXMLData.Tables.Count - 1
      '   lDT = mDSImportXMLData.Tables(lIndex)
      '   Debug.WriteLine(String.Format("Table {0} contains {1} rows.", lDT.TableName, lDT.Rows.Count))
      'Next

      ' Call InitGrid to setup the grid display.
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

   Private Function CreateBingoMasterTable(ByVal aBaseName As String, ByVal aTableName As String, ByRef aErrorText As String) As Integer
      '--------------------------------------------------------------------------------
      ' Creates and populates a CasinoBingo database Bingo Results table.
      ' Returns: 1 if successful
      '          0 if a database error occurs
      '         -1 if the file does not exist
      '         -2 if the MasterDeal table already exists in the eTab database.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable

      Dim lErrPrefix As String
      Dim lSourceFile As String
      Dim lSQL As String

      Dim lCount As Integer
      Dim lReturn As Integer = 1

      ' Init error text to an empty string.
      aErrorText = ""

      ' Build error prefix text.
      lErrPrefix = Me.Name & "::CreateBingoMasterTable: Error: "

      ' Build the source file name.
      lSourceFile = Path.Combine(mSourceFolder, String.Format("{0}.bmd", aBaseName))

      ' Does the source file exist?
      If File.Exists(lSourceFile) Then
         ' Yes, now see if the table already exists in the eTab database...
         lSQL = "SELECT COUNT(*) AS TableCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '{0}'"
         lSQL = String.Format(lSQL, aTableName)

         Try
            ' Create a new SqlDataAccess instance, keeping connection open and command timeout
            ' of 5 minutes (for Bulk Insert)
            lSDA = New SqlDataAccess(gConnectBingo, True, 600)

            ' Attempt to retrieve the count.
            lDT = lSDA.CreateDataTable(lSQL)
            lCount = lDT.Rows(0).Item(0)

            ' If the table already exists, set the function return value to -2.
            If lCount > 0 Then lReturn = -2

         Catch ex As Exception
            ' Handle the error.
            aErrorText = lErrPrefix & ex.Message
            lReturn = 0
         End Try

         ' If no problems yet, attempt to create the table.
         If lReturn = 1 Then
            lSQL = "CREATE TABLE {0} ([Sequence] [int] NOT NULL, " & _
                   "[TierLevel] [smallint] NOT NULL, " & _
                   "[eBarcode] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL) ON [PRIMARY];" & _
                   "ALTER TABLE {0} WITH NOCHECK ADD CONSTRAINT [PK_{0}] " & _
                   "PRIMARY KEY CLUSTERED ([Sequence]) ON [PRIMARY]"
            lSQL = String.Format(lSQL, aTableName)

            Try
               ' Attempt to create the table.
               lSDA.ExecuteSQLNoReturn(lSQL)

            Catch ex As Exception
               ' Handle the error.
               aErrorText = lErrPrefix & "Failed to create table: " & ex.Message
               lReturn = 0

            End Try

         End If

         ' If no problems yet, attempt to BULK INSERT into the table.
         If lReturn = 1 Then
            lSQL = String.Format("BULK INSERT {0} FROM '{1}' WITH (FIELDTERMINATOR = ',')", aTableName, lSourceFile)

            Try
               ' Attempt to perform the Bulk Insert.
               lSDA.ExecuteSQLNoReturn(lSQL)

            Catch ex As Exception
               ' Handle the error.
               aErrorText = lErrPrefix & "Bulk Insert failed: " & ex.Message
               lReturn = 0

            End Try

            ' If we created the table but cannot populate it, then drop the table.
            If lReturn = 0 Then
               lSQL = "DROP TABLE " & aTableName
               Try
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Catch ex As Exception
                  ' Handle the error.
                  aErrorText &= " Failed to DROP the table."
               End Try
            End If
         End If

         ' Close and free the database object.
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
      Else
         ' Source file not found.
         aErrorText = lSourceFile & " not found."
         lReturn = -1
      End If

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

   Private Function DropCoinsBetToGameType() As Integer
      '--------------------------------------------------------------------------------
      ' Drops COINS_BET_TO_GAME_TYPE records so they can be replaced.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Integer = 0

      Dim lGameTypeCodeList As String = ""
      Dim lLastGTC As String = ""
      Dim lThisGTC As String = ""
      Dim lSQL As String

      ' Walk each row in COINS_BET_TO_GAME_TYPE table and build a list of GameTypeCodes.
      For Each lDR In mDSImportXMLData.Tables("COINS_BET_TO_GAME_TYPE").Rows
         lThisGTC = lDR.Item("GAME_TYPE_CODE")
         If lThisGTC <> lLastGTC Then
            lGameTypeCodeList &= "'" & lThisGTC & "',"
            lLastGTC = lThisGTC
         End If
      Next

      If lGameTypeCodeList.Length > 0 Then
         ' Trim the trailing comma.
         lGameTypeCodeList = lGameTypeCodeList.TrimEnd(",".ToCharArray)

         ' Build the delete statement.
         lSQL = "DELETE FROM COINS_BET_TO_GAME_TYPE WHERE GAME_TYPE_CODE IN ({0})"
         lSQL = String.Format(lSQL, lGameTypeCodeList)

         Try
            ' Attempt to delete the rows...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)
            lReturn = lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error
            lReturn = -1
            Logging.Log("DropCoinsBetToGameTypes failed: " & ex.Message)

         Finally
            ' DB Cleanup.
            If Not lSDA Is Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If
         End Try

      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DropDenomToGameType() As Integer
      '--------------------------------------------------------------------------------
      ' Drops DENOM_TO_GAME_TYPE records so they can be replaced.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Integer = 0

      Dim lGameTypeCodeList As String = ""
      Dim lLastGTC As String = ""
      Dim lThisGTC As String = ""
      Dim lSQL As String

      ' Walk each row in DENOM_TO_GAME_TYPE table and build a list of GameTypeCodes.
      For Each lDR In mDSImportXMLData.Tables("DENOM_TO_GAME_TYPE").Rows
         lThisGTC = lDR.Item("GAME_TYPE_CODE")
         If lThisGTC <> lLastGTC Then
            lGameTypeCodeList &= "'" & lThisGTC & "',"
            lLastGTC = lThisGTC
         End If
      Next

      If lGameTypeCodeList.Length > 0 Then
         ' Trim the trailing comma.
         lGameTypeCodeList = lGameTypeCodeList.TrimEnd(",".ToCharArray)

         ' Build the delete statement.
         lSQL = "DELETE FROM DENOM_TO_GAME_TYPE WHERE GAME_TYPE_CODE IN ({0})"
         lSQL = String.Format(lSQL, lGameTypeCodeList)

         Try
            ' Attempt to delete the rows...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)

            ' Store number of deleted rows as the return value.
            lReturn = lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error
            lReturn = -1
            Logging.Log("DropDenomToGameTypes failed: " & ex.Message)

         Finally
            ' DB Cleanup.
            If Not lSDA Is Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If
         End Try

      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DropLinesBetToGameType() As Integer
      '--------------------------------------------------------------------------------
      ' Drops LINES_BET_TO_GAME_TYPE records so they can be replaced.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Integer = 0

      Dim lGameTypeCodeList As String = ""
      Dim lLastGTC As String = ""
      Dim lThisGTC As String = ""
      Dim lSQL As String

      ' Walk each row in LINES_BET_TO_GAME_TYPE table and build a list of GameTypeCodes.
      For Each lDR In mDSImportXMLData.Tables("LINES_BET_TO_GAME_TYPE").Rows
         lThisGTC = lDR.Item("GAME_TYPE_CODE")
         If lThisGTC <> lLastGTC Then
            lGameTypeCodeList &= "'" & lThisGTC & "',"
            lLastGTC = lThisGTC
         End If
      Next

      If lGameTypeCodeList.Length > 0 Then
         ' Trim the trailing comma.
         lGameTypeCodeList = lGameTypeCodeList.TrimEnd(",".ToCharArray)

         ' Build the delete statement.
         lSQL = "DELETE FROM LINES_BET_TO_GAME_TYPE WHERE GAME_TYPE_CODE IN ({0})"
         lSQL = String.Format(lSQL, lGameTypeCodeList)

         Try
            ' Attempt to delete the rows...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)
            lReturn = lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error
            lReturn = -1
            Logging.Log("DropLinesBetToGameTypes failed: " & ex.Message)

         Finally
            ' DB Cleanup.
            If Not lSDA Is Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If
         End Try

      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function InsertCasinoBingoMasterRow(ByVal aBingoMasterDataRow As DataRow) As Boolean
      '--------------------------------------------------------------------------------
      ' Inserts a row into the Casino.MASTER_DEAL table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing

      Dim lReturn As Boolean = True

      Dim lOpCode As Integer = 1
      Dim lSpReturnValue As Integer

      Dim lErrorText As String = ""
      Dim lErrorPrefix As String = Me.Name & "::InsertCasinoBingoMasterRow error"

      Try
         ' Create a new SqlDataAccess object instance.
         lSDA = New SqlDataAccess(gConnectRetail, False, 45)

         ' Add stored procedure parameters...
         With lSDA
            .AddParameter("@BingoMasterID", SqlDbType.Int, aBingoMasterDataRow.Item("BINGO_MASTER_ID"))
            .AddParameter("@LongName", SqlDbType.VarChar, aBingoMasterDataRow.Item("LONG_NAME"), 64)
            .AddParameter("@GameTypeCode", SqlDbType.VarChar, aBingoMasterDataRow.Item("GAME_TYPE_CODE"), 2)
            .AddParameter("@BaseName", SqlDbType.VarChar, aBingoMasterDataRow.Item("BASE_NAME"), 32)
            .AddParameter("@TableName", SqlDbType.VarChar, aBingoMasterDataRow.Item("TABLE_NAME"), 32)
            .AddParameter("@LinesBet", SqlDbType.TinyInt, aBingoMasterDataRow.Item("LINES_BET"))
            .AddParameter("@ResultCount", SqlDbType.Int, aBingoMasterDataRow.Item("RESULT_COUNT"))
            .AddParameter("@HoldPercent", SqlDbType.TinyInt, aBingoMasterDataRow.Item("HOLD_PERCENT"))
            .AddParameter("@Version", SqlDbType.SmallInt, aBingoMasterDataRow.Item("VERSION"))
            .AddParameter("@IsActive", SqlDbType.Bit, aBingoMasterDataRow.Item("IS_ACTIVE"))

            lOpCode += 1

            ' Attempt to execute the stored procedure.
            .ExecuteProcedureNoResult("diInsertBingoMaster")

            ' Store the value returned from the stored procedure.
            lSpReturnValue = .ReturnValue
         End With

         ' If no error and return value from the stored procedure is not 0 then build new error text...
         If lSpReturnValue <> 0 And lErrorText.Length = 0 Then
            If lSpReturnValue = -1 Then
               lErrorText = lErrorPrefix & "MasterDeal Row already exists."
            Else
               lErrorText = lErrorPrefix & "SQL error code " & lSpReturnValue & " returned from diInsertBingoMaster"
            End If
            lReturn = False
         End If

      Catch ex As Exception When lOpCode = 1
         lErrorText = lErrorPrefix & " adding sp parameters: " & ex.Message

      Catch ex As Exception When lOpCode = 2
         lErrorText = lErrorPrefix & " executing diInsertBingoMaster: " & ex.Message

      Catch ex As Exception
         ' Handle the error.
         lErrorText = lErrorPrefix & ": " & ex.Message

      Finally
         ' Free the database object...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Any errors?
      If lErrorText.Length > 0 Then
         ' An error occurred, reset the return value, log it, and show it...
         lReturn = False
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Insert Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function LoadBingoSetupData() As Boolean
      '--------------------------------------------------------------------------------
      ' Loads the CasinoBingo Setup Data that accompanies Master Deal data.
      ' Returns T/F to indicate success of failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      ' Update UI...
      With sbrStatus
         .Text = "Loading CasinoBingo setup data..."
         .Refresh()
      End With

      Application.DoEvents()

      ' Update the CasinoBingo.BingoMaster table.
      lReturn = UpdateBingoMaster()

      ' Update the CasinoBingo.GameType table.
      If lReturn Then lReturn = UpdateGameTypeBingo()

      ' Update the CasinoBingo.Payscale table.
      If lReturn Then lReturn = UpdatePayscaleBingo()

      ' Update the CasinoBingo.TierWinType table.
      If lReturn Then lReturn = UpdateTierWinTypeBingo()

      ' Update the CasinoBingo.PayscaleTier table.
      If lReturn Then lReturn = UpdatePayscaleTierBingo()

      ' Update the CasinoBingo.BallDrawCount table.
      If lReturn Then lReturn = UpdateBallDrawCountBingo()

      ' Update the CasinoBingo.PatternResult table.
      If lReturn Then lReturn = UpdatePatternResultBingo()

      ' Update the CasinoBingo.ResultPointer table.
      If lReturn Then lReturn = UpdateResultPointerBingo()

      ' Update the CasinoBingo.AlternateResult table.
      If lReturn Then lReturn = UpdateAlternateResultBingo()

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function LoadMasterDeals() As Boolean
      '--------------------------------------------------------------------------------
      ' Loads Master Deals.
      ' Returns T/F to indicate success of failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDTMD As DataTable
      Dim lDR As DataRow

      Dim lBaseName As String = ""
      Dim lDetailText As String = ""
      Dim lErrorText As String = ""
      Dim lMasterTable As String
      Dim lSQL As String
      Dim lTableName As String
      Dim lUserMsg As String = ""

      Dim lReturn As Boolean = True
      Dim lSuccess As Boolean

      Dim lReturnCode As Integer

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lUpdateCount As Integer = 0

      Try
         ' Open a connectionn to the LotteryRetail database so we can insert IMPORT_MD_DETAIL rows.
         lSDA = New SqlDataAccess(gConnectRetail, True, 900)
         lMasterTable = "BINGO_MASTER"

         ' Yes, so we can continue. Set a reference to the MASTER_DEAL table in mDataSet.
         lDTMD = mDSImportXMLData.Tables(lMasterTable)

         ' Walk the rows in the table...
         For Each lDR In lDTMD.Rows
            ' Get the table name.
            lTableName = lDR.Item("TABLE_NAME")
            lBaseName = lDR.Item("BASE_NAME")

            ' Update the UI...
            lUserMsg = String.Format("Creating Bingo Results table {0}...", lTableName)
            With sbrStatus
               .Text = lUserMsg
               .Refresh()
            End With

            ' Let Windows breath.
            Application.DoEvents()

            ' Create and populate the eTab.MasterDeal table.
            lReturnCode = CreateBingoMasterTable(lBaseName, lTableName, lErrorText)

            ' If error text was populated, log it.
            If Not String.IsNullOrEmpty(lErrorText) Then Logging.Log(lErrorText)

            ' Return codes:
            '              1 = success'
            '              0 = db error
            '             -1 = file does not exist
            '             -2 = MasterDeal table already exists

            Select Case lReturnCode
               Case -2
                  ' MasterDeal table already exists.
                  lDetailText = String.Format("Table {0} already exists.", lTableName)
                  lErrorText = lDetailText
                  lErrorCount = 1
                  lReturn = False

               Case -1
                  ' Source file not found.
                  lDetailText = String.Format("Source file for {0} does not exist.", lTableName)
                  lErrorText = lDetailText
                  lErrorCount = 1
                  lReturn = False

               Case 0
                  ' Database error occurred.
                  lDetailText = String.Format("Database error occured while attempting to create and populate table {0}.", lTableName)
                  lErrorText = lDetailText
                  lErrorCount = 1
                  lReturn = False

               Case 1
                  ' Successfully created eTab.MasterDeal table.
                  ' Insert a row into the Casino.BINGO_MASTER table.                  
                  lSuccess = InsertCasinoBingoMasterRow(lDR)

                  If lSuccess Then
                     ' Successful
                     lInsertCount = 1
                     lDetailText = String.Format("Successfully created and loaded table {0}.", lTableName)
                  Else
                     ' LotteryRetail Master table (compact or bingo) insert failed.
                     lErrorCount = 1
                     lReturn = False
                     lErrorText = "Failed to insert MASTER_DEAL record."
                     lDetailText = String.Format("Failed to insert {0} {1} record.", lTableName, lMasterTable)
                  End If
            End Select

            ' Insert a row into the Import MD Detail table...
            lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Exit from the loop if problems encountered...
            If Not lReturn Then Exit For
         Next

      Catch ex As Exception
         ' Handle the exception...
         lReturn = False
         lErrorText = Me.Name & "::LoadMasterDeals error: " & ex.Message
      End Try

      ' Database object cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' If there was an error, log it and show the user...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function LoadSetupData() As Boolean
      '--------------------------------------------------------------------------------
      ' Loads the Setup Data that accompanies Master Deal data.
      ' Returns T/F to indicate success of failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True
      Dim lRowCount As Integer

      ' Update UI...
      With sbrStatus
         .Text = "Loading LotteryRetail database setup data..."
         .Refresh()
      End With
      Application.DoEvents()

      ' Approved Masters will not be Casino specific so comment next block for now...
      ' Begin with the Casino table...
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
      If lReturn Then
         ' If DenomToGameTypeUpdate flag is set, we will drop the existing rows first.
         lRowCount = 0
         If mImportFlags.DenomToGameTypeUpdate Then
            lRowCount = DropDenomToGameType()
         End If

         ' Update the DENOM_TO_GAME_TYPE table.
         If lRowCount > -1 Then
            lReturn = UpdateDenomTable(lRowCount)
         Else
            lReturn = False
         End If
      End If

      ' Update the COINS_BET_TO_GAME_TYPE table.
      If lReturn Then
         ' If CoinsBetToGameTypeUpdate flag is set, we will drop the existing rows first.
         lRowCount = 0
         If mImportFlags.CoinsBetToGameTypeUpdate Then
            lRowCount = DropCoinsBetToGameType()
         End If

         ' Update the COINS_BET_TO_GAME_TYPE table.
         If lRowCount > -1 Then
            lReturn = UpdateCoinsBetTable(lRowCount)
         Else
            lReturn = False
         End If
      End If

      ' Update the LINES_BET_TO_GAME_TYPE table.
      If lReturn Then
         ' If LinesBetToGameTypeUpdate flag is set, we will drop the existing rows first.
         lRowCount = 0
         If mImportFlags.LinesBetToGameTypeUpdate Then
            lRowCount = DropLinesBetToGameType()
         End If

         ' Update the LINES_BET_TO_GAME_TYPE table.
         If lRowCount > -1 Then
            lReturn = UpdateLinesBetTable(lRowCount)
         Else
            lReturn = False
         End If
      End If

      ' Update the PAYSCALE table.
      If lReturn Then lReturn = UpdatePayscaleTable()

      ' Update the PAYSCALE_TIER table.
      If lReturn Then lReturn = UpdatePayscaleTierTable()

      ' Update the PAYSCALE_TIER_KENO table.
      If lReturn Then lReturn = UpdatePayscaleTierKenoTable()

      ' Update the CASINO_FORMS table.
      If lReturn Then lReturn = UpdateCasinoFormsTable()

      ' Update the WINNING_TIERS table.
      If lReturn Then lReturn = UpdateWinningTiersTable()

      ' Approved Masters will not be Casino specific so comment next block for now...

      ' If Bank and Machine tables are flagged, update them...
      'If lReturn = True AndAlso mImportFlags.BankMachineTables = True Then
      '   ' Update the Bank table.
      '   lReturn = UpdateBankTable()

      '   ' Update the Machine table.
      '   If lReturn Then lReturn = UpdateMachineTable()
      'End If

      ' Update the Deal Setup table...
      If lReturn Then lReturn = UpdateDealSetupTable()

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function RemoveNonImportData() As Boolean
      '--------------------------------------------------------------------------------
      ' Removed data from that will not be imported.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lDT As DataTable = Nothing

      Dim lReturn As Boolean = True

      Dim lBingoMasterIDList As String = ","
      Dim lErrorText As String = ""
      Dim lFlareIDList As String = ","
      Dim lFormNumber As String
      Dim lGameTypeCode As String
      Dim lGameTypeIDList As String
      Dim lMatchValue As String
      Dim lPayscaleList As String = ","
      Dim lSearchList As String = ""

      Dim lRowCount As Integer
      Dim lRowNumber As Integer
      Dim lTableNumber As Integer

      Try

         ' Remove non-import data from tables:
         '    GAME_SETUP, DENOM_TO_GAME_TYPE, COINS_BET_TO_GAME_TYPE, LINES_BET_TO_GAME_TYPE

         For lTableNumber = 1 To 4
            Select Case lTableNumber
               Case 1
                  ' GAME_SETUP
                  sbrStatus.Text = "Setting Game Setup data..."
                  lDT = mDSImportXMLData.Tables("GAME_SETUP")

               Case 2
                  ' DENOM_TO_GAME_TYPE
                  sbrStatus.Text = "Setting Denom to Game Type data..."
                  lDT = mDSImportXMLData.Tables("DENOM_TO_GAME_TYPE")

               Case 3
                  ' COINS_BET_TO_GAME_TYPE
                  sbrStatus.Text = "Setting Coins Bet to Game Type data..."
                  lDT = mDSImportXMLData.Tables("COINS_BET_TO_GAME_TYPE")

               Case 4
                  ' LINES_BET_TO_GAME_TYPE
                  sbrStatus.Text = "Setting Lines Bet to Game Type data..."
                  lDT = mDSImportXMLData.Tables("LINES_BET_TO_GAME_TYPE")

            End Select

            ' Store the number of table rows.
            lRowCount = lDT.Rows.Count

            ' Are there rows to process?
            If lRowCount > 0 Then
               ' Yes, then visit each row to see if it matches the GameTypeCode(s) that are to be imported...
               For lRowNumber = lRowCount - 1 To 0 Step -1
                  lDR = lDT.Rows(lRowNumber)
                  lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
                  If Array.IndexOf(Of String)(mGameTypeCodeList, lGameTypeCode) = -1 Then
                     ' Not in the list of game type codes to import, so delete the row.
                     lDR.Delete()
                  End If
               Next
            End If

         Next

         ' CASINO_FORMS
         sbrStatus.Text = "Setting Forms data..."

         lDT = mDSImportXMLData.Tables("CASINO_FORMS")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            lSearchList = ","
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
               If Array.IndexOf(Of String)(mGameTypeCodeList, lGameTypeCode) = -1 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               Else
                  lBingoMasterIDList &= String.Format("{0},", lDR.Item("BINGO_MASTER_ID"))
                  lSearchList &= String.Format("{0},", lDR.Item("FORM_NUMB"))
               End If
            Next
         End If

         ' WINNING_TIERS
         sbrStatus.Text = "Setting Winning Tiers data..."

         lDT = mDSImportXMLData.Tables("WINNING_TIERS")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lFormNumber = String.Format(",{0},", lDR.Item("FORM_NUMB"))
               If lSearchList.IndexOf(lFormNumber) < 0 Then
                  lDR.Delete()
               End If
            Next
         End If

         ' DEAL_SETUP
         sbrStatus.Text = "Setting Deal Setup data..."

         lDT = mDSImportXMLData.Tables("DEAL_SETUP")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lFormNumber = String.Format(",{0},", lDR.Item("FORM_NUMB"))
               If lSearchList.IndexOf(lFormNumber) < 0 Then
                  lDR.Delete()
               End If
            Next
         End If

         ' BINGO_MASTER
         sbrStatus.Text = "Setting Master Deal data..."

         lDT = mDSImportXMLData.Tables("BINGO_MASTER")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("BINGO_MASTER_ID"))
               If lBingoMasterIDList.IndexOf(lMatchValue) < 0 Then
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
               If Array.IndexOf(Of String)(mGameTypeCodeList, lGameTypeCode) = -1 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               Else
                  ' Keeper, add to Payscale name list so we can delete proper payscale tier data.
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

         ' FLARE
         sbrStatus.Text = "Setting Flare data..."

         lDT = mDSImportXMLData.Tables("FLARE")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
               If Array.IndexOf(Of String)(mGameTypeCodeList, lGameTypeCode) = -1 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               Else
                  ' Keeper, add to list so we can delete proper payscale tier data.
                  lFlareIDList &= String.Format("{0},", lDR.Item("FLARE_ID"))
               End If
            Next
         End If

         ' FLARE_HEADER
         sbrStatus.Text = "Setting Flare Header data..."

         lDT = mDSImportXMLData.Tables("FLARE_HEADER")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("FLARE_ID"))
               If lFlareIDList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' FLARE_TIER
         sbrStatus.Text = "Setting Flare Header data..."

         lDT = mDSImportXMLData.Tables("FLARE_TIER")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("FLARE_ID"))
               If lFlareIDList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of game types to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' Create a csv list of PROGRESSIVE_TYPE_ID values from the Progressive_Pool table
         lDT = mDSImportXMLData.Tables("PROGRESSIVE_POOL")
         lRowCount = lDT.Rows.Count
         lSearchList = ","
         If lRowCount > 0 Then
            For Each lDR In lDT.Rows
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
               If Array.IndexOf(Of String)(mGameTypeCodeList, lGameTypeCode) > -1 Then
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

         ' CB_GameType
         sbrStatus.Text = "Setting Bingo database GameType data..."

         lDT = mDSImportXMLData.Tables("CB_GameType")
         lRowCount = lDT.Rows.Count
         lGameTypeIDList = ","
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lGameTypeCode = lDR.Item("GameTypeCode")
               If Array.IndexOf(Of String)(mGameTypeCodeList, lGameTypeCode) > -1 Then
                  ' It is a keeper, add the GameTypeID to the search list
                  lGameTypeIDList &= String.Format("{0},", lDR.Item("GameTypeID"))
               Else
                  ' Not in the list of GameTypes to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' CB_Payscale
         sbrStatus.Text = "Setting Bingo database Payscale data..."

         lDT = mDSImportXMLData.Tables("CB_Payscale")
         lRowCount = lDT.Rows.Count
         lPayscaleList = ","
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("GameTypeID"))
               If lGameTypeIDList.IndexOf(lMatchValue) > -1 Then
                  ' It's a keeper, Add the PayscaleID to the PayscaleList
                  lPayscaleList &= String.Format("{0},", lDR.Item("PayscaleID"))
               Else
                  ' Not in the list of GameTypes to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' CB_PayscaleTier
         sbrStatus.Text = "Setting Bingo database PayscaleTier data..."

         lDT = mDSImportXMLData.Tables("CB_PayscaleTier")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("PayscaleID"))
               If lPayscaleList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of Payscales to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' CB_BingoMaster
         sbrStatus.Text = "Setting Bingo database Bingo Master data..."

         lDT = mDSImportXMLData.Tables("CB_BingoMaster")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("GameTypeID"))
               If lGameTypeIDList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of GameTypes to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' CB_BallDrawCount
         sbrStatus.Text = "Setting Bingo database Ball Draw Count data..."

         lDT = mDSImportXMLData.Tables("CB_BallDrawCount")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("GameTypeID"))
               If lGameTypeIDList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of GameTypes to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' CB_PatternResult
         sbrStatus.Text = "Setting Bingo database Pattern Result data..."

         lDT = mDSImportXMLData.Tables("CB_PatternResult")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("BingoMasterID"))
               If lBingoMasterIDList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of Bingo Master IDs to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' CB_ResultPointer
         sbrStatus.Text = "Setting Bingo database Result Pointer data..."

         lDT = mDSImportXMLData.Tables("CB_ResultPointer")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("BingoMasterID"))
               If lBingoMasterIDList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of Bingo Master IDs to import, so delete the row.
                  lDR.Delete()
               End If
            Next
         End If

         ' CB_AlternateResult
         sbrStatus.Text = "Setting Bingo database Alternate Result data..."

         lDT = mDSImportXMLData.Tables("CB_AlternateResult")
         lRowCount = lDT.Rows.Count
         If lRowCount > 0 Then
            For lRowNumber = lRowCount - 1 To 0 Step -1
               lDR = lDT.Rows(lRowNumber)
               lMatchValue = String.Format(",{0},", lDR.Item("BingoMasterID"))
               If lBingoMasterIDList.IndexOf(lMatchValue) < 0 Then
                  ' Not in the list of Bingo Master IDs to import, so delete the row.
                  lDR.Delete()
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

      Dim lEnforceImportSecurity As Boolean
      Dim lReturn As Boolean = True

      Dim lDealGenLongVersion As Long

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
            .BankMachineTables = lDR.Item("BankMachTables")
            If .BankMachineTables = True Then
               ' If we are to update the Bank and Machine tables, use the Bank and Machine update settings.
               .BankUpdate = lDR.Item("Bank")
               .MachineUpdate = lDR.Item("Machine")
            Else
               ' We are not to update the Bank and Machine tables...
               .BankUpdate = False
               .MachineUpdate = False
            End If

            ' Set the Enforce Import Security flag...
            If lDT.Columns.Contains("EnforceImportSecurity") Then
               ' Column exists, use the column value.
               lEnforceImportSecurity = lDR.Item("EnforceImportSecurity")
            Else
               ' Column does not exist, set to False.
               lEnforceImportSecurity = False
            End If
            .EnforceImportSecurity = lEnforceImportSecurity

            .GameTypeUpdate = lDR.Item("GameType")
            .DenomToGameTypeUpdate = lDR.Item("DenomToGameType")
            .CoinsBetToGameTypeUpdate = lDR.Item("CoinsBetToGameType")
            .LinesBetToGameTypeUpdate = lDR.Item("LinesBetToGameType")
            .GameSetupUpdate = lDR.Item("GameSetup")
            .PayscaleUpdate = lDR.Item("Payscale")
            .PayscaleTierUpdate = lDR.Item("PayscaleTier")
            .FormUpdate = lDR.Item("Form")
            .FlareUpdate = lDR.Item("Flare")
            .WinningTierUpdate = lDR.Item("WinningTier")
            If lDR.Table.Columns.Contains("DealGenLongVersion") Then
               lDealGenLongVersion = lDR.Item("DealGenLongVersion")
            Else
               lDealGenLongVersion = 0
            End If
            .DealGenLongVersion = lDealGenLongVersion

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

   Private Function UpdateAlternateResultBingo() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.AlternateResult table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.AlternateResult Import successful."
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
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_BingoMaster table.
         For Each lDR In mDSImportXMLData.Tables("CB_AlternateResult").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@BingoMasterID", SqlDbType.Int, lDR.Item("BingoMasterID"))
               .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("CoinsBet"))
               .AddParameter("@PayscaleTierID", SqlDbType.Int, lDR.Item("PayscaleTierID"))
               .AddParameter("@AlternateID", SqlDbType.Int, lDR.Item("AlternateID"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, True)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertAlternateResult")

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
                  lErrorText = String.Format("diInsertAlternateResult failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = ex.Message
         lDetailText = "CasinoBingo.AlternateResult Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the LotteryRetail IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "AlternateResult", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.AlternateResult data."
         lErrorText = Me.Name & "::UpdateAlternateResultBingo: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateBallDrawCountBingo() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.BallDrawCount table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.BallDrawCount Import successful."
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
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_BingoMaster table.
         For Each lDR In mDSImportXMLData.Tables("CB_BallDrawCount").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeID", SqlDbType.Int, lDR.Item("GameTypeID"))
               .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LinesBet"))
               .AddParameter("@DrawCount", SqlDbType.SmallInt, lDR.Item("DrawCount"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, True)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertBallDrawCount")

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
                  lErrorText = String.Format("diInsertBallDrawCount failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message
         lDetailText = "CasinoBingo.BallDrawCount Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "BallDrawCount", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.BallDrawCount data."
         lErrorText = Me.Name & "::UpdateBallDrawCountBingo: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateBingoMaster() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.BingoMaster table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.BingoMaster Import successful."
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
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_BingoMaster table.
         For Each lDR In mDSImportXMLData.Tables("CB_BingoMaster").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@BingoMasterID", SqlDbType.Int, lDR.Item("BingoMasterID"))
               .AddParameter("@GameTypeID", SqlDbType.Int, lDR.Item("GameTypeID"))
               .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LinesBet"))
               .AddParameter("@ResultsTableName", SqlDbType.VarChar, lDR.Item("ResultTableName"), 32)
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LongName"), 64)
               .AddParameter("@BingoMatchMethodID", SqlDbType.TinyInt, lDR.Item("BingoMatchMethodID"))
               .AddParameter("@PatternList", SqlDbType.VarChar, lDR.Item("PatternList"), 8000)
               .AddParameter("@ResultCount", SqlDbType.Int, lDR.Item("ResultCount"))
               .AddParameter("@Version", SqlDbType.SmallInt, lDR.Item("Version"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IsActive"))

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertBingoMaster")

               ' Capture the value returned from the procedure.
               lSpReturnCode = lSDA.ReturnValue
            End With

            ' 0 = successful insertion, -1 = row exists (error), anything else means an error occurred.
            Select Case lSpReturnCode
               Case 0
                  ' Inserted a new record.
                  lInsertCount += 1
               Case -1
                  ' Row already exists
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertBingoMaster error, row already exists ({0}).", lDR.Item("LongName"))
                  Exit For

               Case Else
                  ' Unexpected return code indicates that a stored procedure error occurred.
                  lErrorCount += 1
                  lReturn = False
                  lErrorText = String.Format("diInsertBingoMaster failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message
         lDetailText = "CasinoBingo.BingoMaster Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "BingoMaster", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.GameType data."
         lErrorText = Me.Name & "::UpdateBingoMaster: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateCasinoFormsTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoForms table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CASINO_FORMS Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lHoldPercent As Decimal

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the CASINO_FORMS table.
         For Each lDR In mDSImportXMLData.Tables("CASINO_FORMS").Rows
            ' Round any hold percentages that have a fractional component.
            lHoldPercent = Math.Round(lDR.Item("HOLD_PERCENT"), 0)

            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@FormNbr", SqlDbType.VarChar, lDR.Item("FORM_NUMB"), 16)
               .AddParameter("@DealType", SqlDbType.Char, lDR.Item("DEAL_TYPE"), 1)
               .AddParameter("@CostPerTab", SqlDbType.SmallMoney, lDR.Item("COST_PER_TAB"))
               .AddParameter("@NbrRolls", SqlDbType.Int, lDR.Item("NUMB_ROLLS"))
               .AddParameter("@TabsPerRoll", SqlDbType.Int, lDR.Item("TABS_PER_ROLL"))
               .AddParameter("@TabsPerDeal", SqlDbType.Int, lDR.Item("TABS_PER_DEAL"))
               .AddParameter("@WinsPerDeal", SqlDbType.Int, lDR.Item("WINS_PER_DEAL"))
               .AddParameter("@TotalAmtIn", SqlDbType.Money, lDR.Item("TOTAL_AMT_IN"))
               .AddParameter("@TotalAmtOut", SqlDbType.Money, lDR.Item("TOTAL_AMT_OUT"))
               .AddParameter("@FormDesc", SqlDbType.VarChar, lDR.Item("FORM_DESC"), 30)
               .AddParameter("@TabAmt", SqlDbType.SmallMoney, lDR.Item("TAB_AMT"))
               .AddParameter("@IsRevShare", SqlDbType.Bit, lDR.Item("IS_REV_SHARE"))
               .AddParameter("@DGERevPercent", SqlDbType.TinyInt, mMaxRevShare)
               .AddParameter("@JPAmount", SqlDbType.Money, lDR.Item("JP_AMOUNT"))
               ' Exports created before the JACKPOT_COUNT column was added to Forms table will not have the JACKPOT_COUNT column in the exported resultset.
               ' If the column is not present, the stored procedure will default a value of 0 into the JACKPOT_COUNT column.
               If mDSImportXMLData.Tables("CASINO_FORMS").Columns.Contains("JACKPOT_COUNT") Then .AddParameter("@JackpotCount", SqlDbType.Int, lDR("JACKPOT_COUNT"))
               .AddParameter("@Denomination", SqlDbType.SmallMoney, lDR.Item("DENOMINATION"))
               .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))
               .AddParameter("@LinesBet", SqlDbType.SmallInt, lDR.Item("LINES_BET"))
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@PayscaleMultiplier", SqlDbType.TinyInt, lDR.Item("PAYSCALE_MULTIPLIER"))
               .AddParameter("@BingoMasterID", SqlDbType.Int, lDR.Item("BINGO_MASTER_ID"))
               .AddParameter("@HoldPercent", SqlDbType.Decimal, lHoldPercent)
               .AddParameter("@IsPaper", SqlDbType.Bit, lDR.Item("IS_PAPER"))
               ' Note: @TabTypeID parameter not added. It defaults to -1 which is always correct for Bingo forms.
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.FormUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertCasinoForms")

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
                  lErrorText = String.Format("diInsertCasinoForms failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::UpdateCasinoFormsTable error: " & ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lErrorText = Me.Name & "::UpdateCasinoFormsTable: " & lErrorText
         lDetailText = "Error importing CASINO_FORMS data."
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "CASINO_FORMS", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::UpdateCasinoFormsTable error updating IMPORT_ME_DETAIL: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      Try
         ' Update CASINO_FORMS.DGE_REV_PERCENT for any rows where IS_REV_SHARE = 1 and DGE_REV_PERCENT = 0
         lSQL = String.Format("UPDATE CASINO_FORMS SET DGE_REV_PERCENT = {0} WHERE IS_REV_SHARE = 1 AND DGE_REV_PERCENT = 0", mMaxRevShare)
         lUpdateCount = lSDA.ExecuteSQLNoReturn(lSQL)

         ' If any rows were updated, log it...
         If lUpdateCount > 0 Then
            lDetailText = String.Format("UpdateCasinoFormsTable routine updated column DGE_REV_PERCENT to {0} percent in {0} row(s).", mMaxRevShare, lUpdateCount)
            Logging.Log(lDetailText)
         End If

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::UpdateCasinoFormsTable error updating IMPORT_ME_DETAIL: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateCoinsBetTable(ByVal aRowCount As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CoinsBetToGameType table.
      ' aRowCount will contain the number of rows deleted prior to this function call.
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
      Else
         ' If updating, show number of rows replaced in detail text.
         If mImportFlags.CoinsBetToGameTypeUpdate Then lDetailText &= String.Format(" Replaced {0} rows.", aRowCount)
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

   Private Function UpdateDealSetupTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the LotteryRetail DEAL_SETUP table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "DEAL_SETUP Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lCurrentDT As DateTime = DateTime.Now

      Dim lReturn As Boolean = True

      Dim lDealNbr As Integer
      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      If mDSImportXMLData.Tables.Contains("DEAL_SETUP") Then
         Try
            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectRetail, True, 60)

            ' Set a reference to each row in the GAME_SETUP table.
            For Each lDR In mDSImportXMLData.Tables("DEAL_SETUP").Rows
               lDealNbr = lDR.Item("DEAL_NO")
               With lSDA
                  ' Add the stored procedure parameters...
                  .AddParameter("@DealNo", SqlDbType.Int, lDealNbr)
                  .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("TYPE_ID"), 1)
                  .AddParameter("@DealDescr", SqlDbType.VarChar, lDR.Item("DEAL_DESCR"), 64)
                  .AddParameter("@NumbRolls", SqlDbType.Int, lDR.Item("NUMB_ROLLS"))
                  .AddParameter("@TabsPerRoll", SqlDbType.Int, lDR.Item("TABS_PER_ROLL"))
                  .AddParameter("@TabAmt", SqlDbType.SmallMoney, lDR.Item("TAB_AMT"))
                  .AddParameter("@CostPerTab", SqlDbType.SmallMoney, lDR.Item("COST_PER_TAB"))
                  .AddParameter("@CreatedBy", SqlDbType.VarChar, lDR.Item("CREATED_BY"), 32)
                  .AddParameter("@JPAmount", SqlDbType.Money, lDR.Item("JP_AMOUNT"))
                  .AddParameter("@FormNumb", SqlDbType.VarChar, lDR.Item("FORM_NUMB"), 10)
                  .AddParameter("@Denomination", SqlDbType.SmallMoney, lDR.Item("DENOMINATION"))
                  .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))
                  .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LINES_BET"))
                  .AddParameter("@GameCode", SqlDbType.VarChar, lDR.Item("GAME_CODE"), 3)

                  ' Execute the procedure.
                  .ExecuteProcedureNoResult("diInsertDealSetup")

                  ' Capture the value returned from the procedure.
                  lSpReturnCode = lSDA.ReturnValue
               End With

               ' 0 = successful insertion, 1 = successful update, 2 = ignored, anything else means an error occurred.
               Select Case lSpReturnCode
                  Case 0
                     ' Inserted a new record.
                     lInsertCount += 1

                  Case 1
                     ' Deal record already exists, this is an error condition.
                     lErrorCount += 1
                     lReturn = False
                     lErrorText = String.Format("UpdateDealSetup failed, Deal {0} already exists in DEAL_SETUP.", lDealNbr)
                     Exit For

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
      Else
         ' No DEAL_SETUP DataTable was found in the mDataSet DataSet...
         lErrorText = "DEAL_SETUP table was not found in the import DataSet."
         lErrorCount += 1
         lReturn = False
      End If

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing DEAL_SETUP data."
         lErrorText = Me.Name & "::UpdateDealSetupTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      Try
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "DEAL_SETUP", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message

      End Try

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateDenomTable(ByVal aRowCount As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the DenomToGameType table.
      ' aRowCount will contain the number of rows deleted prior to this function call.
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
      Else
         ' If updating, show number of rows replaced in detail text.
         If mImportFlags.DenomToGameTypeUpdate Then lDetailText &= String.Format(" Replaced {0} rows.", aRowCount)
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
                  lErrorText = String.Format("diInsertGameCategory failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = "Error updating table GAME_CATEGORY: " & ex.Message
         lErrorCount += 1

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing GAME_CATEGORY data."
         lErrorText = Me.Name & "::UpdateGameCategoryTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
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

   Private Function UpdateGameTypeBingo() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.GameType table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.GameType Import successful."
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
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_GameType table.
         For Each lDR In mDSImportXMLData.Tables("CB_GameType").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@GameTypeID", SqlDbType.Int, lDR.Item("GameTypeID"))
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GameTypeCode"), 2)
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LongName"), 64)
               .AddParameter("@ReelCount", SqlDbType.TinyInt, lDR.Item("ReelCount"))
               .AddParameter("@MaxCoinsBet", SqlDbType.SmallInt, lDR.Item("MaxCoinsBet"))
               .AddParameter("@MaxLinesBet", SqlDbType.TinyInt, lDR.Item("MaxLinesBet"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IsActive"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, True)

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
         lDetailText = "CasinoBingo.GameType Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "GameType", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.GameType data."
         lErrorText = Me.Name & "::UpdateGameTypeBingo: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
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

   Private Function UpdateLinesBetTable(ByVal aRowCount As Integer) As Boolean
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
      Else
         ' If updating, show number of rows replaced in detail text.
         If mImportFlags.LinesBetToGameTypeUpdate Then lDetailText &= String.Format(" Replaced {0} rows.", aRowCount)
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

   Private Function UpdatePatternResultBingo() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.PatternResult table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.PatternResult Import successful."
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
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_PatternResult table.
         For Each lDR In mDSImportXMLData.Tables("CB_PatternResult").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@BingoMasterID", SqlDbType.Int, lDR.Item("BingoMasterID"))
               .AddParameter("@PatternID", SqlDbType.Int, lDR.Item("PatternID"))
               .AddParameter("@PayscaleTierID", SqlDbType.Int, lDR.Item("PayscaleTierID"))
               .AddParameter("@ExceptionCheck", SqlDbType.Bit, lDR.Item("ExceptionCheck"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, True)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertPatternResult")

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
                  lErrorText = String.Format("diInsertPatternResult failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = ex.Message
         lDetailText = "CasinoBingo.PatternResult Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PatternResult", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.PatternResult data."
         lErrorText = Me.Name & "::UpdatePatternResultBingo: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdatePayscaleBingo() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.Payscale table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.Payscale Import successful."
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
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_Payscale table.
         For Each lDR In mDSImportXMLData.Tables("CB_Payscale").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@PayscaleID", SqlDbType.Int, lDR.Item("PayscaleID"))
               .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PayscaleName"), 16)
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LongName"), 64)
               .AddParameter("@GameTypeID", SqlDbType.Int, lDR.Item("GameTypeID"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IsActive"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, True)

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
         lDetailText = "CasinoBingo.Payscale Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "Payscale", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.GameType data."
         lErrorText = Me.Name & "::UpdatePayscaleBingo: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
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

   Private Function UpdatePayscaleTierBingo() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.PayscaleTier table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.PayscaleTier Import successful."
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
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_BingoMaster table.
         For Each lDR In mDSImportXMLData.Tables("CB_PayscaleTier").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@PayscaleTierID", SqlDbType.Int, lDR.Item("PayscaleTierID"))
               .AddParameter("@PayscaleID", SqlDbType.Int, lDR.Item("PayscaleID"))
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TierLevel"))
               .AddParameter("@ShortName", SqlDbType.VarChar, lDR.Item("ShortName"), 8)
               .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LongName"), 64)
               .AddParameter("@CoinsWon", SqlDbType.Int, lDR.Item("CoinsWon"))
               .AddParameter("@TierWinTypeID", SqlDbType.Int, lDR.Item("TierWinTypeID"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, True)

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
         lDetailText = "CasinoBingo.PayscaleTier Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "PayscaleTier", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.PayscaleTier data."
         lErrorText = Me.Name & "::UpdatePayscaleTierBingo: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
         lDetailText = "Error importing PRODUCT data."
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
         lDetailText = "Error importing PROG_AWARD_FACTOR data."
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
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to the PROGRESSIVE_POOL table.
         lDT = mDSImportXMLData.Tables("PROGRESSIVE_POOL")

         ' Set a reference to each row in the PROGRESSIVE_TYPE table.
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
         lDetailText = "Error importing PROGRESSIVE_POOL data."
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
         lDetailText = "Error importing PROGRESSIVE_TYPE data."
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

   Private Function UpdateResultPointerBingo() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.ResultPointer table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.ResultPointer Import successful."
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
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_BingoMaster table.
         For Each lDR In mDSImportXMLData.Tables("CB_ResultPointer").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@BingoMasterID", SqlDbType.Int, lDR.Item("BingoMasterID"))
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TierLevel"))
               .AddParameter("@IDFirst", SqlDbType.Int, lDR.Item("PositionFirst"))
               .AddParameter("@IDLast", SqlDbType.Int, lDR.Item("PositionLast"))
               .AddParameter("@ResultCount", SqlDbType.Int, lDR.Item("ResultCount"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, True)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertResultPointer")

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
                  lErrorText = String.Format("diInsertResultPointer failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message
         lDetailText = "CasinoBingo.ResultPointer Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "ResultPointer", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.ResultPointer data."
         lErrorText = Me.Name & "::UpdateResultPointerBingo: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateTierWinTypeBingo() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the CasinoBingo.TierWinType table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CasinoBingo.TierWinType Import successful."
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
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_BingoMaster table.
         For Each lDR In mDSImportXMLData.Tables("CB_TierWinType").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@TierWinTypeID", SqlDbType.Int, lDR.Item("TierWinTypeID"))
               .AddParameter("@Description", SqlDbType.VarChar, lDR.Item("Description"), 32)
               .AddParameter("@SortOrder", SqlDbType.SmallInt, lDR.Item("SortOrder"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IsActive"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, True)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertTierWinType")

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
                  lErrorText = String.Format("diInsertTierWinType failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = ex.Message
         lDetailText = "CasinoBingo.TierWinType Import failed: " & lErrorText
         lErrorCount += 1

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      Try
         ' Insert a row into the IMPORT_MD_DETAIL table.
         lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "TierWinType", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the exception...
         If lErrorText.Length = 0 Then
            lErrorText = "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         Else
            lErrorText &= gNL & "Failed to update IMPORT_MD_DETAIL table: " & ex.Message
         End If

      Finally
         ' DB Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing CasinoBingo.TierWinType data."
         lErrorText = Me.Name & "::UpdateBingoTierWinType: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateWinningTiersTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the WinningTiers table.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "WINNING_TIERS Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String
      Dim lStatusText As String = sbrStatus.Text

      Dim lReturn As Boolean = True

      Dim lCount As Integer = 0
      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lRowCountTotal As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Store total number of WinningTiers rows.
         lRowCountTotal = mDSImportXMLData.Tables("WINNING_TIERS").Rows.Count

         ' Set a reference to each row in the WINNING_TIERS table.
         For Each lDR In mDSImportXMLData.Tables("WINNING_TIERS").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@NbrOfWinners", SqlDbType.Int, lDR.Item("NUMB_OF_WINNERS"))
               .AddParameter("@WinningAmount", SqlDbType.Money, lDR.Item("WINNING_AMOUNT"))
               .AddParameter("@FormNumber", SqlDbType.VarChar, lDR.Item("FORM_NUMB"), 10)
               .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
               .AddParameter("@CoinsWon", SqlDbType.Int, lDR.Item("COINS_WON"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.WinningTierUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertWinningTiers")

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
                  lErrorText = String.Format("diInsertWinningTiers failed, returned {0}.", lSpReturnCode)
                  Exit For
            End Select

            ' Increment loop counter and call DoEvents every 200 iterations so user won't
            ' think the application has crashed...
            lCount += 1
            If lCount Mod 200 = 0 Then
               ' Update UI...
               With sbrStatus
                  .Text = String.Format("Updating Casino.Winning Tiers row {0} of {1}...", lCount, lRowCountTotal)
                  .Refresh()
               End With
               Application.DoEvents()
            End If
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = "Error Adding Parameters: " & ex.Message

      End Try

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show it.
         lReturn = False
         lDetailText = "Error importing WINNING_TIERS data."
         lErrorText = Me.Name & "::UpdateWinningTiersTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "WINNING_TIERS", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Reset the status text.
      sbrStatus.Text = lStatusText

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
         mGameTypeCodeList = value
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