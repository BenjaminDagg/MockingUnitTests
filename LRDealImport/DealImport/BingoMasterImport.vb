Public Class BingoMasterImport

   ' [Private - member variables]
   Private mDSCasinoSetupData As DataSet     ' Will contain data from CasinoSetupData.xml in user selected folder.
   Private mDSApprovedMDSetup As DataSet     ' Will contain data from CasinoSetupData.xml on approved CD or DVD ROM.
   Private mDSRetireMD As DataSet

   Private mImportFlags As New ImportFlags

   Private mImportDealSQLBase As String
   Private mSourceBaseFileName As String = "CasinoBingoSetupData.xml"
   Private mSourceFolder As String
   Private mSourceFolderCD As String

   Private mImportMDHistoryID As Integer
   Private mRetireCount As Integer

   Private mBusy As Boolean = False


   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Me.Close()

   End Sub

   Private Sub btnFolderBrowse_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFolderBrowse.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Browse button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""
      Dim lMRUFolder As String = ""
      Dim lSelectedFolder As String
      Dim lSourceFile As String
      Dim lUserMsg As String


      ' If we have a lookup key, see if there is a value in the config file...
      lMRUFolder = My.Settings.LastBMDFolder

      ' Setup Folder Browser dialog control so user can select the source folder.
      With FolderBrowserDlg
         .RootFolder = Environment.SpecialFolder.MyComputer
         If lMRUFolder.Length > 0 Then .SelectedPath = lMRUFolder
         If .ShowDialog() = DialogResult.OK Then
            lSelectedFolder = .SelectedPath
            lSourceFile = Path.Combine(lSelectedFolder, mSourceBaseFileName)
            ' We expect to find the xml file in the selected folder.
            If File.Exists(lSourceFile) Then
               ' Reset the text in the Source Folder TextBox control.
               mSourceFolder = lSelectedFolder
               txtSourceFolder.Text = mSourceFolder

               ' Load the file, the grid, the dataset (mDataSet), and the import flags (mImportFlags)...
               If LoadDataSet(lSourceFile) Then
                  ' Load the retirees grid.
                  Call LoadMasterDealRetireGridBMD()

                  ' Check to see if the file contains masters that have already been loaded.
                  If IsValidBingoTableSet(lErrorText) Then
                     ' Appears to be okay, make sure the import button is enabled.
                     btnImport.Enabled = True
                  Else
                     ' Disable the import button and inform user of the problem...
                     btnImport.Enabled = False
                     MessageBox.Show(lErrorText, "Source Folder Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                  End If
               End If

               ' Save the selected folder in the config file as most recently used...
               If Not lSelectedFolder Is Nothing Then
                  With My.Settings
                     .LastBMDFolder = lSelectedFolder
                     .Save()
                  End With
               End If
            Else
               ' Source file was not found...
               lUserMsg = "Invalid Folder, import file does not exist in the selected folder."
               MessageBox.Show(lUserMsg, "Source Folder Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
         End If
      End With

   End Sub

   Private Sub btnImport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImport.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Import button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturnCode As Boolean = True

      Dim lExistingDealCount As Integer = 0

      Dim lErrorText As String = ""

      ' Store the Casino database version.
      gDatabaseVersion = GetCasinoDBVersion()

      ' Do we have the minimum expected version?
      If gDatabaseVersion >= gMinimumDBVersionInt Then
         ' Yes, so we can continue.
         ' Do we have a valid import stored procedure set in the LotteryRetail database?
         If IsValidImportProcedureSetMD(lErrorText) Then
            ' Yes, so we can continue.

            ' Disable the Import button and refresh so user sees the visual change...
            With btnImport
               .Enabled = False
               .Refresh()
            End With

            ' Create an IMPORT_MD_HISTORY record.
            lReturnCode = CreateImportMDHistoryRow(lErrorText)

            If lReturnCode Then
               ' Do we have Master Deals to retire?
               If mRetireCount > 0 Then
                  ' Yes, so call RetireMasterDeals...
                  sbrStatus.Text = "Retiring Master Deals..."
                  lReturnCode = RetireMasterDealsBMD(lErrorText)
               End If
            End If

            ' Do we have a valid import stored procedure set in the CasinoBingo database?
            lReturnCode = IsValidImportProcedureSetCB(lErrorText)

            If Not lReturnCode Then
               ' CreateImportMDHistoryRow or RetireMasterDeals failed.  Log the error.
               Logging.Log(lErrorText)

               ' Show the error message.
               MessageBox.Show(lErrorText, "Retire Master Deal Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

               ' Exit this routine.
               Exit Sub
            End If

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
               If lReturnCode Then Call SetImportSuccessFlag()

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
         Else
            ' We don't have the expected set of import stored procedures.
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Master Deal Import Report Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End If
      Else
         ' DB Version too low, show the user.
         lErrorText = String.Format("Casino database version {0} or higher is required.", gMinimumDBVersionText)
         MessageBox.Show(lErrorText, "Master Deal Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If mBusy Then
         ' Busy, cancel close.
         e.Cancel = True
      Else
         ' Save window state info for next time this form is opened.
         ConfigFile.SetWindowState(Me)
      End If

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Build the base SQL Insert statement for the IMPORT_MD_DETAIL table.
      mImportDealSQLBase = "INSERT INTO IMPORT_MD_DETAIL " & _
         "(IMPORT_MD_HISTORY_ID, TABLE_NAME, DETAIL_TEXT, INSERT_COUNT, UPDATE_COUNT, IGNORED_COUNT, ERROR_COUNT) " & _
         "VALUES ({0},'{1}','{2}',{3},{4},{5},{6})"

      ' Set the Window caption text...
      Me.Text = "Import Bingo Master Deals for Casino " & gDefaultCasinoID

      ' Display databases that will be updated by the import process...
      With lblTargetDBs
         .Text = String.Format("Import process will update Databases {0}.{1} and {0}.{2}", My.Settings.DatabaseServer, My.Settings.LotteryRetailDBCatalog, My.Settings.CBDBCatalog)
         .Refresh()
      End With

      ' Use last saved window state.
      ConfigFile.GetWindowState(Me)

   End Sub

   Private Sub LoadMasterDealImportGridBMD()
      '--------------------------------------------------------------------------------
      ' Load Master Deal Grid with Bingo Master data.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDgvColumn As DataGridViewColumn

      Dim lErrorText As String = ""


      Try
         ' Bind retrieved data to the Form DataGrid control and set DataGrid properties...
         If Not dgvImportMasterDeals.DataSource Is Nothing Then
            dgvImportMasterDeals.DataSource = Nothing
         End If

         With dgvImportMasterDeals
            .DataSource = mDSCasinoSetupData
            .DataMember = "BINGO_MASTER"
            '.SetDataBinding(mDataSet, "BINGO_MASTER")
            .RowHeadersWidth = 22
         End With

         For Each lDgvColumn In dgvImportMasterDeals.Columns
            Select Case lDgvColumn.Name
               Case "TABLE_NAME"
                  With lDgvColumn
                     .DisplayIndex = 0
                     .Width = 140
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Table Name"
                  End With

               Case "LINES_BET"
                  With lDgvColumn
                     .DisplayIndex = 1
                     .Width = 76
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Lines Bet"
                  End With

               Case "RESULT_COUNT"
                  With lDgvColumn
                     .DisplayIndex = 2
                     .Width = 100
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .DefaultCellStyle.Format = "#,##0"
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Result Count"
                  End With

               Case "HOLD_PERCENT"
                  With lDgvColumn
                     .DisplayIndex = 3
                     .Width = 76
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Hold Pct"
                  End With

               Case Else
                  ' Hide any columns not specifically handled above.
                  lDgvColumn.Visible = False

            End Select
         Next


         'With lColStyle04
         '   .HeaderText = "Version"
         '   .MappingName = "VERSION"
         '   .Alignment = HorizontalAlignment.Center
         '   .Width = 76
         'End With

         'With lColStyle05
         '   .HeaderText = "ID"
         '   .MappingName = "BINGO_MASTER_ID"
         '   .Alignment = HorizontalAlignment.Center
         '   .Width = 40
         'End With


      Catch ex As Exception
         ' Handle error...
         lErrorText = Me.Name & "::LoadMasterDealImportGridBMD error:" & gNL & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Sub LoadMasterDealRetireGridBMD()
      '--------------------------------------------------------------------------------
      ' Load Retire Master Deal Grid (Bingo).
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDTRetireMD As DataTable = mDSCasinoSetupData.Tables("RetireMasterDeal")
      Dim lDR As DataRow

      Dim lChildColumns(0) As DataColumn
      Dim lParentColumns(0) As DataColumn

      Dim lErrorText As String = ""
      Dim lErrorPrefix As String = Me.Name & "::LoadMasterDealRetireGridBMD: "
      Dim lIDList As String = ""

      Try
         ' Set a reference to the RetireMasterDeal DataTable.
         lDTRetireMD = mDSCasinoSetupData.Tables("RetireMasterDeal")

         ' Store row count.
         mRetireCount = lDTRetireMD.Rows.Count

         ' Build a list of Master Deal IDs...
         If mRetireCount = 0 Then
            lIDList = "0"
         Else
            ' Build the list of Master Deal IDs to be retired.
            For Each lDR In lDTRetireMD.Rows
               lIDList &= CType(lDR.Item("BINGO_MASTER_ID"), String) & ","
            Next
            ' Trim the trailing comma character.
            lIDList = lIDList.TrimEnd(",".ToCharArray)
         End If

      Catch ex As Exception
         ' Handle the error...
         lErrorText = lErrorPrefix & "Error building Bingo Master Deal ID retire list: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Load Master Deals to Retire Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' If no errors we can continue.
      If lErrorText.Length = 0 Then
         ' Build SQL SELECT statements to retrieve our data.
         Try
            ' Retrieve data...
            lSDA = New SqlDataAccess(gConnectRetail, False, 90)
            With lSDA
               .AddParameter("@BingoMasterIDList", SqlDbType.VarChar, lIDList, 1024)
               mDSRetireMD = .ExecuteProcedure("GetMasterDealBingoInfo")
            End With

            ' Kill and free the database connection...
            lSDA.Dispose()
            lSDA = Nothing

         Catch ex As Exception
            ' Handle the error...
            lErrorText = lErrorPrefix & "Error retrieving Bingo Master Deal retire data: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Load Master Deals to Retire Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         End Try
      End If

      ' If no errors we can continue.
      If lErrorText.Length = 0 Then
         Try
            With mDSRetireMD
               ' Set the names and disallow add/edit/delete for proper DataGrid display of the returned tables...
               With .Tables(0)
                  .DefaultView.AllowNew = False
                  .DefaultView.AllowDelete = False
                  .DefaultView.AllowEdit = False
                  .TableName = "BINGO_MASTER"
               End With

               With .Tables(1)
                  .DefaultView.AllowNew = False
                  .DefaultView.AllowDelete = False
                  .DefaultView.AllowEdit = False
                  .TableName = "FORM_INFO"
               End With

               With .Tables(2)
                  .DefaultView.AllowNew = False
                  .DefaultView.AllowDelete = False
                  .DefaultView.AllowEdit = False
                  .TableName = "DEAL_INFO"
               End With

            End With

         Catch ex As Exception
            ' Handle the error...
            lErrorText = lErrorPrefix & "Setting DataSet Relationships: " & ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Load Master Deals to Retire Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         End Try
      End If

      ' If no errors we can continue.
      If lErrorText.Length = 0 Then
         'Call AddDGRStylesBMD()
         'dgvRetireMasterDeals.SetDataBinding(mDSRetireMD, "BINGO_MASTER")
         With dgvRetireMasterDeals
            .DataSource = mDSRetireMD
            .DataMember = "BINGO_MASTER"
         End With

         For Each lDgvColumn As DataGridViewColumn In dgvRetireMasterDeals.Columns
            Select Case lDgvColumn.Name
               Case "BINGO_MASTER_ID"
                  With lDgvColumn
                     .DisplayIndex = 0
                     .Width = 74
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "BMD ID"
                  End With

               Case "TABLE_NAME"
                  With lDgvColumn
                     .DisplayIndex = 1
                     .Width = 180
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                     .HeaderText = "Master Deal"
                  End With

               Case "RESULT_COUNT"
                  With lDgvColumn
                     .DisplayIndex = 2
                     .Width = 80
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .DefaultCellStyle.Format = "#,##0"
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Tab Count"
                  End With

               Case "VERSION"
                  With lDgvColumn
                     .DisplayIndex = 3
                     .Width = 74
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Version"
                  End With

               Case "LINES_BET"
                  With lDgvColumn
                     .DisplayIndex = 4
                     .Width = 74
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Lines Bet"
                  End With

               Case "HOLD_PERCENT"
                  With lDgvColumn
                     .DisplayIndex = 5
                     .Width = 74
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Hold Pct"
                  End With

               Case "IS_ACTIVE"
                  With lDgvColumn
                     .DisplayIndex = 6
                     .Width = 80
                     .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                     .HeaderText = "Active"
                  End With

               Case Else
                  ' Hide any columns not specifically handled above.
                  lDgvColumn.Visible = False

            End Select
         Next
      End If

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
      Dim lSourceFolder As String
      Dim lSQL As String

      Dim lCount As Integer
      Dim lReturn As Integer = 1

      ' Init error text to an empty string.
      aErrorText = ""

      ' Build error prefix text.
      lErrPrefix = Me.Name & "::CreateBingoMasterTable: Error: "

      ' Set the Source Folder...
      If mImportFlags.EnforceImportSecurity = True Then
         ' The bingo master files must be imported from the approved CD media.
         lSourceFolder = mSourceFolderCD
      Else
         ' The bingo master files willt be imported from the user selectd folder where the xml file was found.
         lSourceFolder = mSourceFolder
      End If

      ' Build the source file name.
      lSourceFile = Path.Combine(lSourceFolder, String.Format("{0}.bmd", aBaseName))

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
      For Each lDR In mDSCasinoSetupData.Tables("COINS_BET_TO_GAME_TYPE").Rows
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

   Private Function DropDealTableBMD(ByVal aTableName As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Drops CasinoBingo BingoResults table.
      ' Returns T/F to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lReturn As Boolean = True

      Dim lErrorText As String = ""
      Dim lSQL As String

      Try
         ' Build the SQL statement to drop the table.
         lSQL = "DROP TABLE " & aTableName

         ' Instantiate a New SqlDataAccess object connected to the CasinoBingo database.
         lSDA = New SqlDataAccess(gConnectBingo, False, 120)

         ' Attempt to drop the table.
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         lErrorText = Me.Name & "::DropDealTableBMD: Error: " & ex.Message
         Logging.Log(lErrorText)

      Finally
         ' Database object cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

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
      For Each lDR In mDSCasinoSetupData.Tables("DENOM_TO_GAME_TYPE").Rows
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
      For Each lDR In mDSCasinoSetupData.Tables("LINES_BET_TO_GAME_TYPE").Rows
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

   Private Function IsGoodCDROMData(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Routine called when Enforce Import Security is True.
      ' Checks for the correct set of Deals on ROM media.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lDT As DataTable
      Dim lDriveInfo As DriveInfo

      Dim lFileName As String
      Dim lFilterBase As String
      Dim lFilterText As String
      Dim lFolderName As String
      Dim lDriveLetter As String
      Dim lVolumeLabel As String

      Dim lFilesFound As Boolean
      Dim lReturn As Boolean = False
      Dim lRomDriveFound As Boolean = False

      ' Initialize aErrorText and the CD source folder name to an empty string.
      aErrorText = ""
      mSourceFolderCD = ""

      ' Search each drive for a CDRom (or DVD) drive...
      For Each lDriveInfo In DriveInfo.GetDrives
         ' Must check IsReady property before checking accessing any other property of DriveInfo.
         If lDriveInfo.IsReady Then
            ' Drive is ready, is it a CDRom drive?
            If lDriveInfo.DriveType = DriveType.CDRom Then
               ' Yes, so retrieve and store the drive letter and volume letter...
               lDriveLetter = lDriveInfo.RootDirectory.FullName
               lVolumeLabel = lDriveInfo.VolumeLabel

               ' Set drive found flag.
               lRomDriveFound = True

               ' Volume label must be "DGE_AMD".
               If lVolumeLabel.StartsWith("DGE_AMD") Then
                  ' Search CDROM for SetupData* folder.
                  For Each lFolder As DirectoryInfo In lDriveInfo.RootDirectory.GetDirectories("SetupDataBingo*", SearchOption.TopDirectoryOnly)
                     ' Check for the expected set of files.
                     ' Must have CasinoSetupData.xml, MsgDigest.dat, and all of the DMD files that are in the MASTER_DEAL table...
                     lFolderName = lFolder.FullName
                     lFileName = Path.Combine(lFolderName, "CasinoBingoSetupData.xml")

                     ' Assume for the moment that all files will be found.
                     lFilesFound = True

                     ' Does the CasinoSetupData.xml file exist?
                     If File.Exists(lFileName) Then
                        ' Yes, so load the approved master deal xml file.
                        mDSApprovedMDSetup = New DataSet
                        mDSApprovedMDSetup.ReadXml(lFileName, XmlReadMode.ReadSchema)

                        ' Yes, does the MsgDigest.dat file exist?
                        lFileName = Path.Combine(lFolderName, "MsgDigest.dat")
                        If File.Exists(lFileName) Then
                           ' Yes, do all of the required DMD files exist?
                           If mDSCasinoSetupData IsNot Nothing Then
                              For Each lDR In mDSCasinoSetupData.Tables("BINGO_MASTER").Rows
                                 ' Build the fully qualified distribution master file name.
                                 lFileName = Path.Combine(lFolderName, lDR.Item("BASE_NAME")) & ".bmd"

                                 ' Does the file exist?
                                 If File.Exists(lFileName) = False Then
                                    ' No, set error text and found flag...
                                    aErrorText = lFileName & " file not found."
                                    lFilesFound = False
                                    Exit For
                                 End If
                              Next

                              ' Did we find all of the expected files?
                              If lFilesFound = True Then
                                 ' Yes, so set the CD source folder name and return true.
                                 mSourceFolderCD = lFolderName

                                 ' Check that all of the Master Deals in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                 ' Set a reference to the BINGO_MASTER table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("BINGO_MASTER")

                                 ' Check each BINGO_MASTER row from the import set against the BINGO_MASTER rows on the ROM drive...
                                 lFilterBase = "BINGO_MASTER_ID={0} AND GAME_TYPE_CODE='{1}' AND TABLE_NAME='{2}' AND BASE_NAME='{3}' AND " & _
                                               "LINES_BET={4} AND RESULT_COUNT={5} AND HOLD_PERCENT={6} AND VERSION={7} AND IS_ACTIVE={8}"

                                 For Each lDR In mDSCasinoSetupData.Tables("BINGO_MASTER").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("BINGO_MASTER_ID"), .Item("GAME_TYPE_CODE"), .Item("TABLE_NAME"), .Item("BASE_NAME"), _
                                                     .Item("LINES_BET"), .Item("RESULT_COUNT"), .Item("HOLD_PERCENT"), .Item("VERSION"), .Item("IS_ACTIVE"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "BINGO_MASTER row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the GAME_TYPE rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                 ' Set a reference to the GAME_TYPE table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("GAME_TYPE")

                                 ' Check each Game Type row from the import set against the Game Type rows on the ROM drive.
                                 lFilterBase = "GAME_TYPE_CODE = '{0}' AND REEL_COUNT={1} AND TYPE_ID='{2}' AND MAX_COINS_BET={3} AND MAX_LINES_BET={4} AND IS_ACTIVE={5}"
                                 For Each lDR In mDSCasinoSetupData.Tables("GAME_TYPE").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("GAME_TYPE_CODE"), .Item("REEL_COUNT"), .Item("TYPE_ID"), _
                                                     .Item("MAX_COINS_BET"), .Item("MAX_LINES_BET"), .Item("IS_ACTIVE"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "GAME_TYPE row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the Payscales in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                 ' Set a reference to the PAYSCALE table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("PAYSCALE")

                                 ' Check each Payscale from the import set against the Payscales on the ROM drive.
                                 For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE").Rows
                                    With lDR
                                       lFilterText = String.Format("PAYSCALE_NAME='{0}' AND GAME_TYPE_CODE='{1}' AND IS_ACTIVE={2}", _
                                                     .Item("PAYSCALE_NAME"), .Item("GAME_TYPE_CODE"), .Item("IS_ACTIVE"))
                                    End With
                                    If lDT.Select(lFilterText).Length = 0 Then
                                       aErrorText = "PAYSCALE row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                       Return False
                                    End If
                                 Next

                                 ' Check that all of the Payscale Tiers in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                 ' Set a reference to the PAYSCALE_TIER table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("PAYSCALE_TIER")

                                 ' Check each PayscaleTier from the import set against the PayscaleTiers on the ROM drive.
                                 lFilterBase = "PAYSCALE_NAME='{0}' AND TIER_LEVEL={1} AND COINS_WON={2} AND TIER_WIN_TYPE={3} AND USE_MULTIPLIER={4}"
                                 For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE_TIER").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("PAYSCALE_NAME"), .Item("TIER_LEVEL"), _
                                                     .Item("COINS_WON"), .Item("TIER_WIN_TYPE"), .Item("USE_MULTIPLIER"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "PAYSCALE_TIER row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Are there any keno payscale tier rows?
                                 If mDSCasinoSetupData.Tables("PAYSCALE_TIER_KENO").Rows.Count > 0 Then
                                    ' Yes, so check that all of the PAYSCALE_TIER_KENO rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                    ' Set a reference to the PAYSCALE_TIER_KENO table from the ROM drive.
                                    lDT = mDSApprovedMDSetup.Tables("PAYSCALE_TIER_KENO")

                                    ' Check each PAYSCALE_TIER_KENO row from the import set against the PAYSCALE_TIER_KENO rows on the ROM drive.
                                    lFilterBase = "PAYSCALE_NAME='{0}' AND TIER_LEVEL={1} AND PICK_COUNT={2} AND HIT_COUNT={3} AND AWARD_FACTOR={4} AND TIER_WIN_TYPE={5}"
                                    For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE_TIER_KENO").Rows
                                       With lDR
                                          lFilterText = String.Format(lFilterBase, .Item("PAYSCALE_NAME"), .Item("TIER_LEVEL"), .Item("PICK_COUNT"), _
                                                                      .Item("HIT_COUNT"), .Item("AWARD_FACTOR"), .Item("TIER_WIN_TYPE"))
                                          If lDT.Select(lFilterText).Length = 0 Then
                                             aErrorText = "PAYSCALE_TIER_KENO row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                             Return False
                                          End If
                                       End With
                                    Next
                                 End If

                                 ' Check that all of the Game Codes in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                 ' Set a reference to the Game Setup table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("GAME_SETUP")

                                 ' Check each game code from the import set against the game codes on the ROM drive.
                                 lFilterBase = "GAME_CODE = '{0}' AND GAME_TYPE_CODE='{1}' AND TYPE_ID='{2}' AND GAME_TITLE_ID={3}"
                                 For Each lDR In mDSCasinoSetupData.Tables("GAME_SETUP").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("GAME_CODE"), .Item("GAME_TYPE_CODE"), .Item("TYPE_ID"), .Item("GAME_TITLE_ID"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "GAME_SETUP row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the Forms in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                 ' Set a reference to the forms table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("CASINO_FORMS")

                                 ' Check each form number from the import set against the form numbers on the ROM drive.
                                 lFilterBase = "FORM_NUMB = '{0}' AND DEAL_TYPE='{1}' AND TABS_PER_DEAL={2} AND WINS_PER_DEAL={3} AND " & _
                                               "DENOMINATION={4} AND COINS_BET={5} AND LINES_BET={6} AND GAME_TYPE_CODE='{7}' AND " & _
                                               "BINGO_MASTER_ID={8} AND HOLD_PERCENT={9} AND IS_PAPER={10} AND IS_ACTIVE={11}"
                                 For Each lDR In mDSCasinoSetupData.Tables("CASINO_FORMS").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("FORM_NUMB"), .Item("DEAL_TYPE"), .Item("TABS_PER_DEAL"), _
                                                                   .Item("WINS_PER_DEAL"), .Item("DENOMINATION"), .Item("COINS_BET"), _
                                                                   .Item("LINES_BET"), .Item("GAME_TYPE_CODE"), .Item("BINGO_MASTER_ID"), _
                                                                   .Item("HOLD_PERCENT"), .Item("IS_PAPER"), .Item("IS_ACTIVE"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "CASINO_FORMS row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the WINNING_TIERS in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                 ' Set a reference to the WINNING_TIERS table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("WINNING_TIERS")

                                 ' Check Winning Tiers from the import set against the Winning Tiers on the ROM drive.
                                 lFilterBase = "FORM_NUMB='{0}' AND TIER_LEVEL={1} AND NUMB_OF_WINNERS={2} AND WINNING_AMOUNT={3} AND COINS_WON={4}"
                                 For Each lDR In mDSCasinoSetupData.Tables("WINNING_TIERS").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("FORM_NUMB"), .Item("TIER_LEVEL"), _
                                                     .Item("NUMB_OF_WINNERS"), .Item("WINNING_AMOUNT"), .Item("COINS_WON"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "WINNING_TIERS row was not found or has different values in the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the FLARE rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                 ' Set a reference to the FLARE table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("FLARE")
                                 ' Check that each FLARE row in the import set exists in the FLARE rows of the ROM drive.
                                 lFilterBase = "FLARE_ID={0} AND GAME_TYPE_CODE='{1}' AND BET_COMBO_COUNT={2} AND TIER_COUNT={3}"
                                 For Each lDR In mDSCasinoSetupData.Tables("FLARE").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("FLARE_ID"), .Item("GAME_TYPE_CODE"), .Item("BET_COMBO_COUNT"), .Item("TIER_COUNT"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "FLARE row was not found or has different values in the approved data set. Criteria" & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the FLARE_HEADER rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                 ' Set a reference to the forms table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("FLARE_HEADER")
                                 ' Check each FLARE_HEADER from the import set against the FLARE_HEADERs on the ROM drive.
                                 lFilterBase = "FLARE_HEADER_ID={0} AND FLARE_ID={1} AND COLUMN_NUMBER={2} AND LINES_BET={3} AND CREDITS_BET='{4}'"
                                 For Each lDR In mDSCasinoSetupData.Tables("FLARE_HEADER").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("FLARE_HEADER_ID"), .Item("FLARE_ID"), .Item("COLUMN_NUMBER"), .Item("LINES_BET"), .Item("CREDITS_BET"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "FLARE_HEADER row was not found or has different values in the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the FLARE_TIER rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD
                                 ' Set a reference to the FLARE_TIER table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("FLARE_TIER")
                                 ' Check each FLARE_TIER row from the import set against the FLARE_TIER rows on the ROM drive.
                                 lFilterBase = "FLARE_TIER_ID={0} AND FLARE_ID={1} AND TIER_LEVEL={2} AND SYMBOLS='{3}' AND BASE_CREDITS={4} AND WIN_COUNT_LIST='{5}'"
                                 For Each lDR In mDSCasinoSetupData.Tables("FLARE_TIER").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("FLARE_TIER_ID"), .Item("FLARE_ID"), .Item("TIER_LEVEL"), _
                                                     .Item("SYMBOLS"), .Item("BASE_CREDITS"), .Item("WIN_COUNT_LIST"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "FLARE_TIER row was not found or has different values in the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the CB_GameType rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                 ' Set a reference to the CB_GameType table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("CB_GameType")

                                 ' Check each Game Type row from the import set against the Game Type rows on the ROM drive.
                                 lFilterBase = "GameTypeID = {0} AND GameTypeCode='{1}' AND ReelCount={2} AND MaxCoinsBet={3} AND MaxLinesBet={4} AND IsActive={5}"
                                 For Each lDR In mDSCasinoSetupData.Tables("CB_GameType").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("GameTypeID"), .Item("GameTypeCode"), .Item("ReelCount"), _
                                                                   .Item("MaxCoinsBet"), .Item("MaxLinesBet"), .Item("IsActive"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "CB_GameType row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the CB_Payscale rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                 ' Set a reference to the CB_Payscale table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("CB_Payscale")

                                 ' Check each CB_Payscale row from the import set against the CB_Payscale rows on the ROM drive.
                                 lFilterBase = "PayscaleID = {0} AND PayscaleName='{1}' AND GameTypeID={2} AND IsActive={3}"
                                 For Each lDR In mDSCasinoSetupData.Tables("CB_Payscale").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("PayscaleID"), .Item("PayscaleName"), _
                                                     .Item("GameTypeID"), .Item("IsActive"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "CB_Payscale row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the CB_BingoMaster rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                 ' Set a reference to the CB_BingoMaster table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("CB_BingoMaster")

                                 ' Check each CB_BingoMaster row from the import set against the CB_BingoMaster rows on the ROM drive.
                                 lFilterBase = "BingoMasterID = {0} AND GameTypeID={1} AND LinesBet={2} AND ResultTableName='{3}' AND " & _
                                               "BingoMatchMethodID={4} AND PatternList='{5}' AND ResultCount={6} AND Version={7} AND IsActive={8}"
                                 For Each lDR In mDSCasinoSetupData.Tables("CB_BingoMaster").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("BingoMasterID"), .Item("GameTypeID"), .Item("LinesBet"), _
                                                                    .Item("ResultTableName"), .Item("BingoMatchMethodID"), .Item("PatternList"), _
                                                                    .Item("ResultCount"), .Item("Version"), .Item("IsActive"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "CB_BingoMaster row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the CB_PayscaleTier rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                 ' Set a reference to the CB_PayscaleTier table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("CB_PayscaleTier")

                                 ' Check each CB_PayscaleTier row from the import set against the CB_PayscaleTier rows on the ROM drive.
                                 lFilterBase = "PayscaleTierID = {0} AND PayscaleID = {1} AND TierLevel={2} AND CoinsWon={3} AND TierWinTypeID={4}"
                                 For Each lDR In mDSCasinoSetupData.Tables("CB_PayscaleTier").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("PayscaleTierID"), .Item("PayscaleID"), _
                                                                   .Item("TierLevel"), .Item("CoinsWon"), .Item("TierWinTypeID"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "CB_PayscaleTier was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the CB_BallDrawCount rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                 ' Set a reference to the CB_BallDrawCount table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("CB_BallDrawCount")

                                 ' Check each CB_BallDrawCount row from the import set against the CB_BallDrawCount rows on the ROM drive.
                                 lFilterBase = "GameTypeID = {0} AND LinesBet = {1} AND DrawCount={2}"
                                 For Each lDR In mDSCasinoSetupData.Tables("CB_BallDrawCount").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("GameTypeID"), .Item("LinesBet"), .Item("DrawCount"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "CB_BallDrawCount row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the CB_PatternResult rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                 ' Set a reference to the CB_PatternResult table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("CB_PatternResult")

                                 ' Check each CB_BallDrawCount row from the import set against the CB_BallDrawCount rows on the ROM drive.
                                 lFilterBase = "BingoMasterID = {0} AND PatternID = {1} AND PayscaleTierID={2} AND ExceptionCheck={3}"
                                 For Each lDR In mDSCasinoSetupData.Tables("CB_PatternResult").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("BingoMasterID"), .Item("PatternID"), .Item("PayscaleTierID"), .Item("ExceptionCheck"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "CB_PatternResult row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the CB_ResultPointer rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                 ' Set a reference to the CB_ResultPointer table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("CB_ResultPointer")

                                 ' Check each CB_ResultPointer row from the import set against the CB_ResultPointer rows on the ROM drive.
                                 lFilterBase = "BingoMasterID = {0} AND TierLevel = {1} AND PositionFirst={2} AND PositionLast={3} AND ResultCount={4}"
                                 For Each lDR In mDSCasinoSetupData.Tables("CB_ResultPointer").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("BingoMasterID"), .Item("TierLevel"), .Item("PositionFirst"), .Item("PositionLast"), .Item("ResultCount"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "CB_ResultPointer row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' Check that all of the CB_AlternateResult rows in mDSCasinoSetupData exist in mDSCasinoSetupDataAMD.
                                 ' Set a reference to the CB_AlternateResult table from the ROM drive.
                                 lDT = mDSApprovedMDSetup.Tables("CB_AlternateResult")

                                 ' Check each CB_AlternateResult row from the import set against the CB_AlternateResult rows on the ROM drive.
                                 lFilterBase = "BingoMasterID = {0} AND CoinsBet = {1} AND PayscaleTierID={2} AND AlternateID={3}"
                                 For Each lDR In mDSCasinoSetupData.Tables("CB_AlternateResult").Rows
                                    With lDR
                                       lFilterText = String.Format(lFilterBase, .Item("BingoMasterID"), .Item("CoinsBet"), .Item("PayscaleTierID"), .Item("AlternateID"))
                                       If lDT.Select(lFilterText).Length = 0 Then
                                          aErrorText = "CB_AlternateResult row was not found or has different values than the approved data set. Criteria: " & lFilterText
                                          Return False
                                       End If
                                    End With
                                 Next

                                 ' No errors, return true.
                                 Return True
                              End If
                           Else
                              ' mDSCasinoSetupData Is a null reference.
                              aErrorText = "SetupData is not loaded."
                           End If
                        Else
                           ' File.Exists(MsgDigest.dat) = false.
                           aErrorText = "MsgDigest.dat file not found."
                           lFilesFound = False
                        End If
                     Else
                        ' File.Exists(CasinoBingoSetupData.xml) = false.
                        aErrorText = "CasinoBingoSetupData.xml file not found."
                        lFilesFound = False
                     End If

                     If aErrorText.Length > 0 Then
                        Return False
                     End If
                  Next
               Else
                  ' Incorrect volume label.
                  aErrorText = "Invalid CD or DVD Disc."
               End If
            End If
         End If
      Next

      ' If no CD/DVD Rom drive was found, set error text appropriately.
      If lRomDriveFound = False Then
         aErrorText = "Did not find a CD or DVD Rom drive."
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function IsValidBingoTableSet(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Checks that Bingo Masters are not already loaded.
      ' Returns T/F to indicate success of failure.
      ' Populates aErrorText string on failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lReturn As Boolean = True

      Dim lCount As Integer
      Dim lDealNumber As Integer

      Dim lDBName As String
      Dim lIDList As String = ""
      Dim lSQL As String
      Dim lTableList As String = ""

      ' Init error text to an empty string.
      aErrorText = ""

      Try
         ' Store the name of the CasinoBingo database.
         lDBName = My.Settings.CBDBCatalog

         ' Set a reference to the BINGO_MASTER datatable.
         lDT = mDSCasinoSetupData.Tables("BINGO_MASTER")

         ' Do we have data rows in the table?
         If lDT.Rows.Count > 0 Then
            ' Yes, so build a list of id's and table names...
            For Each lDR In lDT.Rows
               lIDList &= lDR.Item("BINGO_MASTER_ID") & ","
               lTableList &= "'" & lDR.Item("TABLE_NAME") & "',"
            Next

            ' Trim trailing commas...
            lIDList = lIDList.TrimEnd(",".ToCharArray)
            lTableList = lTableList.TrimEnd(",".ToCharArray)

            ' Begin by looking for existing BingoResults tables...
            lSQL = String.Format("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME IN ({0})", lTableList)

            ' Open a connectionn to the CasinoBingo database.
            lSDA = New SqlDataAccess(gConnectBingo, True)

            ' Retrieve table names...
            lDT = lSDA.CreateDataTable(lSQL)
            lCount = lDT.Rows.Count

            If lCount > 0 Then
               ' Reset return value to False.
               lReturn = False

               ' Build a list of Bingo Result tables that are in the file and also
               ' already exist in the CasinoBingo database...
               lTableList = ""
               For Each lDR In lDT.Rows
                  lTableList &= lDR.Item("TABLE_NAME") & ", "
               Next
               lTableList = lTableList.TrimEnd(", ".ToCharArray)

               ' Now build the error text.
               aErrorText = "The following Bingo Results table(s) in the import file already exist in the " & _
                            String.Format("{0} database:{1}{1}{2}", lDBName, gNL, lTableList)
            End If

            ' If no errors yet, make sure no BingoMaster rows already exist.
            If lReturn Then
               lSQL = String.Format("SELECT COUNT(*) FROM BingoMaster WHERE BingoMasterID IN ({0})", lIDList)
               lDT = lSDA.CreateDataTable(lSQL)
               lCount = lDT.Rows(0).Item(0)
               If lCount > 0 Then
                  lReturn = False
                  aErrorText = lDBName & ".BingoMaster table contains rows that exist in the import file."
               End If
            End If
         Else
            ' No BINGO_MASTER rows were found.
            lReturn = False
            aErrorText = "No BINGO_MASTER rows were exported."
         End If

      Catch ex As Exception
         ' Handle the exception.
         lReturn = False
         aErrorText = Me.Name & "::IsValidMasterSetBingo error (CB Check): " & ex.Message

      Finally
         ' Cleanup, free the database object...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Now, if no errors yet, check the LotteryRetail database...
      If lReturn = True Then
         Try
            ' Store the name of the CasinoBingo database.
            lDBName = My.Settings.LotteryRetailDBCatalog

            ' Build SQL SELECT to retrieve any matching Casino.BINGO_MASTER table rows.
            lSQL = String.Format("SELECT BINGO_MASTER_ID, TABLE_NAME FROM BINGO_MASTER WHERE BINGO_MASTER_ID IN ({0})", lIDList)

            ' Open a connection to the LotteryRetail database.
            lSDA = New SqlDataAccess(gConnectRetail, True)

            ' Retrieve the data.
            lDT = lSDA.CreateDataTable(lSQL)

            ' Store the number of rows retrieved.
            lCount = lDT.Rows.Count

            ' Do we already have BingoMasterIDs with the same values?
            If lCount > 0 Then
               ' Yes, so reset the return value to False.
               lReturn = False

               ' Build a list of Bingo Result tables that are in the file and also
               ' already exist in the CasinoBingo database...
               lTableList = ""
               For Each lDR In lDT.Rows
                  lTableList &= lDR.Item("TABLE_NAME") & ", "
               Next
               ' Trim trailing delimiters.
               lTableList = lTableList.TrimEnd(", ".ToCharArray)

               ' Now build the error text.
               aErrorText = "The following Bingo Results table(s) in the import file already exist in the " & _
                            String.Format("{0} database:{1}{1}{2}", lDBName, gNL, lTableList)
            Else
               ' Bingo Masters are okay, now make sure there are no conflicting LotteryRetail database DEAL_SETUP rows...
               ' Build SQL SELECT to retrieve any matching Casino.DEAL_SETUP table rows.
               lSQL = String.Format("SELECT DEAL_NO FROM DEAL_SETUP WHERE DEAL_NO IN ({0})", lIDList)

               ' Retrieve the data.
               lDT = lSDA.CreateDataTable(lSQL)

               ' Store the number of rows retrieved.
               lCount = lDT.Rows.Count

               ' Do we have conflicting Deal numbers?
               If lCount > 0 Then
                  ' Yes, so reset the return value to False.
                  lReturn = False

                  ' Build a list of Deal numbers that already exist in the Casino database...
                  lTableList = ""
                  For Each lDR In lDT.Rows
                     lDealNumber = lDR.Item("DEAL_NO")
                     lTableList &= lDealNumber.ToString & ", "
                  Next
                  ' Trim trailing delimiters.
                  lTableList = lTableList.TrimEnd(", ".ToCharArray)

                  ' Now build the error text.
                  aErrorText = "The following Deal Numbers already exist in the " & _
                               String.Format("{0} database:{1}{1}{2}", lDBName, gNL, lTableList)
               End If

            End If

         Catch ex As Exception
            ' Handle the exception.
            lReturn = False
            aErrorText = Me.Name & "::IsValidMasterSetBingo error (M Check): " & ex.Message

         Finally
            'Cleanup, free the database object...
            If Not lSDA Is Nothing Then
               lSDA.Dispose()
               lSDA = Nothing
            End If

         End Try

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

   Private Function LoadDataSet(ByVal aSourceFile As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Loads the specified file into mDataSet.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lDealGenLongVersion As Long
      Dim lMinDealGenVersion As Long = My.Settings.MinDealGenVersion

      Dim lEnforceImportSecurity As Boolean

      Dim lCasinoID As String = ""
      Dim lErrorPrefix As String = Me.Name & "::LoadDataSet error: "
      Dim lErrorText As String = ""
      Dim lStatusText As String = ""

      ' Disable the import button.
      btnImport.Enabled = False

      ' Load the new file...
      Try
         mDSCasinoSetupData = New DataSet
         mDSCasinoSetupData.ReadXml(aSourceFile, XmlReadMode.ReadSchema)

      Catch ex As Exception
         ' Handle the exception...
         lReturn = False
         mDSCasinoSetupData = Nothing
         mDSRetireMD = Nothing
         lErrorText = "Failed to read source file: " & ex.Message
         lStatusText = "Load Error Reading Source"

      End Try

      ' If no errors, we can continue...
      If lReturn = True Then
         Try
            ' Load the Grid with Bingo Master Deal data.
            Call LoadMasterDealImportGridBMD()

         Catch ex As Exception
            ' Handle the exception...
            lReturn = False
            lErrorText = "Failed to load Master Deal Grid: " & ex.Message
            lStatusText = "Load Error"
         End Try
      End If

      ' If no errors, we can continue...
      If lReturn = True Then
         Try
            ' Set a reference to the ImportFlags table.
            lDT = mDSCasinoSetupData.Tables("ImportFlags")

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
               .WinningTierUpdate = lDR.Item("WinningTier")
               If lDR.Table.Columns.Contains("DealGenLongVersion") Then
                  lDealGenLongVersion = lDR.Item("DealGenLongVersion")
               Else
                  lDealGenLongVersion = 0
               End If
               .DealGenLongVersion = lDealGenLongVersion

               ' Set checked property of the CheckBox controls...
               cbCasino.Checked = .CasinoTable
               cbBankMach.Checked = .BankMachineTables
               cbBankUpdate.Checked = .BankUpdate
               cbMachineUpdate.Checked = .MachineUpdate
               cbEnforceIS.Checked = lEnforceImportSecurity
               cbGameTypeUpdate.Checked = .GameTypeUpdate
               cbDenomToGTUpdate.Checked = .DenomToGameTypeUpdate
               cbCoinsBetToGTUpdate.Checked = .CoinsBetToGameTypeUpdate
               cbLinesBetToGTUpdate.Checked = .LinesBetToGameTypeUpdate
               cbGameSetupUpdate.Checked = .GameSetupUpdate
               cbPayscaleUpdate.Checked = .PayscaleUpdate
               cbPayscaleTiersUpdate.Checked = .PayscaleTierUpdate
               cbFormsUpdate.Checked = .FormUpdate
               cbWinningTiersUpdate.Checked = .WinningTierUpdate
            End With

         Catch ex As Exception
            ' Handle the exception...
            lReturn = False
            lErrorText = "Failed to set Import Flags and Form Controls: " & ex.Message
            lStatusText = "Load Error"

         End Try

      End If

      If lReturn = True Then
         ' Set a reference to the first row of the CASINO table.
         lDR = mDSCasinoSetupData.Tables("CASINO").Rows(0)
         lCasinoID = lDR.Item("CAS_ID")

         If String.Compare(lCasinoID, gDefaultCasinoID, True) <> 0 Then
            ' Is the dataset for the proper casino?
            ' No, set return value, error and status text...
            lReturn = False
            lErrorText = String.Format("Dataset is for {0} and this Casino is {1}.", lCasinoID, gDefaultCasinoID)
            lStatusText = lErrorText
         End If
      End If

      ' Still good to go?
      If lReturn = True Then
         ' Yes, now make sure that the Deal Generation system version is okay...
         If lDealGenLongVersion < lMinDealGenVersion Then
            ' No, set return value, error and status text...
            lReturn = False
            lErrorText = String.Format("Export set was created with DealGen version {0}, must be {1} or higher.", _
                         lDealGenLongVersion, lMinDealGenVersion)
            lStatusText = lErrorText
         End If
      End If

      ' Still good to go?
      If lReturn = True Then
         ' GLI001 is reserved for Approved Master disks and may not be loaded.
         If String.Compare(lCasinoID, "GLI001", True) = 0 Then
            lReturn = False
            lErrorText = "CasinoID GLI001 is reserved for approved master data and may not be loaded."
            lStatusText = lErrorText
         End If
      End If

      ' If no errors yet and Enforce Import Security is True, make sure we have a CD or DVD with master deals.
      If lReturn = True AndAlso lEnforceImportSecurity = True Then
         lReturn = IsGoodCDROMData(lErrorText)
      End If

      ' If we have error text, log and show it...
      If lErrorText.Length > 0 Then
         lErrorText = lErrorPrefix & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set enabled property of the import button.
      btnImport.Enabled = lReturn

      If lReturn Then
         ' Yes, so enable the Import button and set the status text...
         sbrStatus.Text = String.Format("Ready to Import new Bingo Master(s) from {0}.", aSourceFile)
      Else
         sbrStatus.Text = lStatusText
      End If

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
         lDTMD = mDSCasinoSetupData.Tables(lMasterTable)

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

      ' Begin with the Casino table...
      If mImportFlags.CasinoTable Then
         ' Export user indicated that the Casino table is to be updated.
         lReturn = UpdateCasinoTable()
      End If

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

      ' If Bank and Machine tables are flagged, update them...
      If lReturn = True AndAlso mImportFlags.BankMachineTables = True Then
         ' Update the Bank table.
         lReturn = UpdateBankTable()

         ' Update the Machine table.
         If lReturn Then lReturn = UpdateMachineTable()
      End If

      ' Update the Deal Setup table...
      If lReturn Then lReturn = UpdateDealSetupTable()

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function RetireMasterDealsBMD(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Retires specified Bingo Master Deals.
      ' Also deactivates associated Form and Deal rows.
      ' Returns True or False to indicate success or failure.
      ' Populates aErrorText if errors are encountered.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lDetailHist As New HistoryDetail

      Dim lExportedBy As String
      Dim lFormNbr As String
      Dim lBingoMasterTable As String
      Dim lSQL As String
      Dim lSQLBaseCF As String
      Dim lSQLBaseDS As String
      Dim lSQLBaseBM As String
      Dim lSQLBaseCBBM As String   ' CasinoBingo.BingoMaster table base update statement text.

      Dim lBingoMasterID As Integer
      Dim lCount As Integer
      Dim lDealNbr As Integer

      Dim lReturn As Boolean = True

      ' Initialize error text to an empty string.
      aErrorText = ""

      ' Specify that parent id and detail table name that will be updated.
      With lDetailHist
         .DetailParentID = mImportMDHistoryID
         .UpdateTable = "IMPORT_MD_DETAIL"
      End With

      ' Store name of user that created the export set.
      lExportedBy = mImportFlags.ExportedBy

      ' Build SQL base strings...
      lSQLBaseDS = "UPDATE DEAL_SETUP SET IS_OPEN = 0, CLOSE_DATE = GetDate(), CLOSED_BY = '" & _
                 lExportedBy & "' WHERE DEAL_NO = {0} AND IS_OPEN = 1"
      lSQLBaseCF = "UPDATE CASINO_FORMS SET IS_ACTIVE = 0 WHERE FORM_NUMB = '{0}' AND IS_ACTIVE = 1"
      lSQLBaseBM = "UPDATE BINGO_MASTER SET IS_ACTIVE = 0 WHERE BINGO_MASTER_ID = {0} AND IS_ACTIVE = 1"
      lSQLBaseCBBM = "UPDATE BingoMaster SET IsActive = 0 WHERE BingoMasterID = {0} AND IsActive = 1"

      ' Set a reference to the DEAL_INFO DataTable.
      lDT = mDSRetireMD.Tables("DEAL_INFO")

      ' Begin by deactivating DEAL_SETUP rows.
      Try
         ' Instantiate a New SqlDataAccess object connected to the LotteryRetail database.
         lSDA = New SqlDataAccess(gConnectRetail, True, 120)

         ' Walk the Deal Info table and close deals associated with master deals being retired.
         For Each lDR In lDT.Rows
            lDealNbr = CType(lDR.Item("DEAL_NO"), Integer)

            With lDetailHist
               .TableName = "DEAL_SETUP"
               .DetailText = String.Format("Close Deal {0}.", lDealNbr)
               ' Reset counters...
               .ResetCounters()
            End With

            ' Build the DEAL_SETUP SQL UPDATE statement.
            lSQL = String.Format(lSQLBaseDS, lDealNbr)

            ' Perform the update.
            lCount = lSDA.ExecuteSQLNoReturn(lSQL)

            ' Set counts based upon the return value...
            If lCount > 0 Then
               lDetailHist.IncrementUpdated()
            Else
               lDetailHist.IncrementIgnored()
            End If

            ' Insert a row into the Import MD Detail table...
            lSQL = lDetailHist.SQLInsertText
            lSDA.ExecuteSQLNoReturn(lSQL)
         Next

         ' Set a reference to the FORM_INFO DataTable.
         lDT = mDSRetireMD.Tables("FORM_INFO")
         lDetailHist.TableName = "CASINO_FORMS"

         ' Walk the Form Info table and deactivate the forms associated with master deals being retired.
         For Each lDR In lDT.Rows
            ' Store form number.
            lFormNbr = lDR.Item("FORM_NUMB")

            lSQL = String.Format(lSQLBaseCF, lFormNbr)
            lCount = lSDA.ExecuteSQLNoReturn(lSQL)

            With lDetailHist
               .DetailText = String.Format("Deactivate Form {0}.", lFormNbr)
               ' Reset counters...
               .ResetCounters()
            End With

            ' Set counts based upon the return value...
            If lCount > 0 Then
               lDetailHist.IncrementUpdated()
            Else
               lDetailHist.IncrementIgnored()
            End If

            ' Insert a row into the Import MD Detail table...
            lSQL = lDetailHist.SQLInsertText
            lSDA.ExecuteSQLNoReturn(lSQL)
         Next

         ' Set a reference to the BINGO_MASTER DataTable.
         lDetailHist.TableName = "BINGO_MASTER"
         lDT = mDSRetireMD.Tables("BINGO_MASTER")
         For Each lDR In lDT.Rows
            lBingoMasterID = lDR.Item("BINGO_MASTER_ID")
            lBingoMasterTable = lDR.Item("TABLE_NAME")

            With lDetailHist
               .DetailText = String.Format("Deactivate Bingo Master Deal {0} ({1}).", lBingoMasterID, lBingoMasterTable)
               ' Reset counters...
               .ResetCounters()
            End With

            ' Build the SQL statement to deaactivate the Bingo Master record.
            lSQL = String.Format(lSQLBaseBM, lBingoMasterID)

            ' Execute the statement.
            lCount = lSDA.ExecuteSQLNoReturn(lSQL)

            ' Set counts based upon the return value...
            If lCount > 0 Then
               lDetailHist.IncrementUpdated()
            Else
               lDetailHist.IncrementIgnored()
            End If

            ' Insert a row into the Import MD Detail table...
            lSQL = lDetailHist.SQLInsertText
            lSDA.ExecuteSQLNoReturn(lSQL)

         Next

         For Each lDR In lDT.Rows
            lBingoMasterTable = lDR.Item("TABLE_NAME")
            With lDetailHist
               .TableName = lBingoMasterTable
               .ResetCounters()

               ' Drop the CasinoBingo BingoResults Master Deal table.
               If DropDealTableBMD(lBingoMasterTable) Then
                  .IncrementUpdated()
               Else
                  .IncrementErrors()
               End If

               ' Insert a row into the Import MD Detail table...
               lSQL = .SQLInsertText
            End With

            ' Attempt to drop the CasinoBingo BingoResults table.
            lSDA.ExecuteSQLNoReturn(lSQL)
         Next

         ' Now we need to deactivate the BingoMaster record in the CasinoBingo database...
         lSDA.Dispose()
         lSDA = New SqlDataAccess(gConnectBingo, True, 90)

         ' Walk the Deal Info table and close deals associated with master deals being retired.
         lDT = mDSRetireMD.Tables("BINGO_MASTER")
         For Each lDR In lDT.Rows
            ' Store the Bingo Master ID.
            lBingoMasterID = lDR.Item("BINGO_MASTER_ID")

            ' Build the SQL statement to deaactivate the CasinoBingo.BingoMaster table record.
            lSQL = String.Format(lSQLBaseCBBM, lBingoMasterID)

            ' Execute the statement.
            lCount = lSDA.ExecuteSQLNoReturn(lSQL)
         Next

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         aErrorText = Me.Name & String.Format("::RetireMasterDealsBMD:Table {0}: Error : ", lDetailHist.TableName) & ex.Message

      Finally
         ' Cleanup...
         ' Close and free the database object...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

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
         For Each lDR In mDSCasinoSetupData.Tables("CB_AlternateResult").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("CB_BallDrawCount").Rows
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

   Private Function UpdateBankTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Bank table.
      ' Called only if mImportFlags.BankMachineTables = True.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lReturn As Boolean = True

      Dim lDetailText As String = "BANK Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lUpdateCount As Integer = 0
      Dim lSpReturnCode As Integer

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the BANK table.
         For Each lDR In mDSCasinoSetupData.Tables("BANK").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@BankNo", SqlDbType.Int, lDR.Item("BANK_NO"))
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@ProgFlag", SqlDbType.Bit, lDR.Item("PROG_FLAG"))
               .AddParameter("@IsPaper", SqlDbType.Bit, lDR.Item("IS_PAPER"))
               .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))
               .AddParameter("@BankDesc", SqlDbType.VarChar, lDR.Item("BANK_DESCR"), 128)
               .AddParameter("@ProductLineID", SqlDbType.SmallInt, lDR.Item("PRODUCT_LINE_ID"))
               .AddParameter("@LockupAmount", SqlDbType.SmallMoney, lDR("LOCKUP_AMOUNT"))
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.BankUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertBank")

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
                  lErrorText = String.Format("diInsertBank failed, returned {0}.", lSpReturnCode)
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
         lErrorText = Me.Name & "::UpdateBankTable: " & lErrorText
         lDetailText = "Error importing BANK data."
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "BANK", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
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
         For Each lDR In mDSCasinoSetupData.Tables("CB_BingoMaster").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("CASINO_FORMS").Rows
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
               .AddParameter("@DGERevPercent", SqlDbType.TinyInt, lDR.Item("DGE_REV_PERCENT"))
               .AddParameter("@JPAmount", SqlDbType.Money, lDR.Item("JP_AMOUNT"))
               ' Exports created before the JACKPOT_COUNT column was added to Forms table will not have the JACKPOT_COUNT column in the exported resultset.
               ' If the column is not present, the stored procedure will default a value of 0 into the JACKPOT_COUNT column.
               If mDSCasinoSetupData.Tables("CASINO_FORMS").Columns.Contains("JACKPOT_COUNT") Then .AddParameter("@JackpotCount", SqlDbType.Int, lDR("JACKPOT_COUNT"))
               .AddParameter("@Denomination", SqlDbType.SmallMoney, lDR.Item("DENOMINATION"))
               .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))
               .AddParameter("@LinesBet", SqlDbType.SmallInt, lDR.Item("LINES_BET"))
               .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
               .AddParameter("@PayscaleMultiplier", SqlDbType.TinyInt, lDR.Item("PAYSCALE_MULTIPLIER"))
               .AddParameter("@BingoMasterID", SqlDbType.Int, lDR.Item("BINGO_MASTER_ID"))
               .AddParameter("@HoldPercent", SqlDbType.Decimal, lHoldPercent)
               .AddParameter("@IsPaper", SqlDbType.Bit, lDR.Item("IS_PAPER"))
               ' Note: @IsMicroTab parameter not added. It defaults to 0 which is always correct for Bingo forms.
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
         ' Handle the error...
         lErrorText = ex.Message

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

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "CASINO_FORMS", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      ' DB Cleanup...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function UpdateCasinoTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Casino table.
      ' Only called if mImportFlags.CasinoTable = True.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "CASINO Import successful."
      Dim lErrorText As String = ""
      Dim lSQL As String

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Dim lReturn As Boolean = True

      Try
         ' Set a reference to the first row in the Casino table.
         lDR = mDSCasinoSetupData.Tables("CASINO").Rows(0)

         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         With lSDA
            ' Add the stored procedure parameters...
            .AddParameter("@CasinoID", SqlDbType.Char, lDR.Item("CAS_ID"), 6)
            .AddParameter("@CasinoName", SqlDbType.VarChar, lDR.Item("CAS_NAME"), 48)
            .AddParameter("@LockupAmt", SqlDbType.SmallMoney, lDR.Item("LOCKUP_AMT"))
            .AddParameter("@FromTime", SqlDbType.DateTime, lDR.Item("FROM_TIME"))
            .AddParameter("@ToTime", SqlDbType.DateTime, lDR.Item("TO_TIME"))
            .AddParameter("@ClaimTimeout", SqlDbType.TinyInt, lDR.Item("CLAIM_TIMEOUT"))
            .AddParameter("@DaubTimeout", SqlDbType.SmallInt, lDR.Item("DAUB_TIMEOUT"))
            .AddParameter("@BingoFreeSquare", SqlDbType.Bit, lDR.Item("BINGO_FREE_SQUARE"))
            .AddParameter("@CardType", SqlDbType.TinyInt, lDR.Item("CARD_TYPE"))
            .AddParameter("@PlayerCard", SqlDbType.Bit, lDR.Item("PLAYER_CARD"))
            .AddParameter("@ReceiptPrinter", SqlDbType.Bit, lDR.Item("RECEIPT_PRINTER"))
            .AddParameter("@DisplayProgressive", SqlDbType.Bit, lDR.Item("DISPLAY_PROGRESSIVE"))
            .AddParameter("@TpiID", SqlDbType.Int, lDR.Item("TPI_ID"))
            .AddParameter("@ReprintTicket", SqlDbType.Bit, lDR.Item("REPRINT_TICKET"))
            .AddParameter("@SummarizePlay", SqlDbType.Bit, lDR.Item("SUMMARIZE_PLAY"))
         End With

      Catch ex As Exception
         ' Handle the error...
         lErrorText = "Error Adding Parameters: " & ex.Message

      End Try

      If lErrorText.Length = 0 Then
         Try
            ' Execute diInsertCasino.
            lSDA.ExecuteProcedureNoResult("diInsertCasino")

            ' Capture the value returned from the procedure.
            lSpReturnCode = lSDA.ReturnValue

            ' 0 means successful insertion, 1 means successful update, anything else means an error occurred.
            If lSpReturnCode < 0 OrElse lSpReturnCode > 1 Then
               lReturn = False
               lErrorText = String.Format("diInsertCasino failed, returned {0}.", lSpReturnCode)
            End If

         Catch ex As Exception
            ' Handle the error...
            lErrorText = "Error executing diInsertCasino: " & ex.Message

         End Try
      End If

      ' Did an error occur?
      If lErrorText.Length > 0 Then
         ' Yes, so reset the return value, set, log, and show the error...
         lReturn = False
         lDetailText = "Error importing CASINO data."
         lErrorText = Me.Name & "::UpdateCasinoTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table...
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "CASINO", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)

      Try
         lSDA.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the error...
         lErrorText = Me.Name & "::UpdateCasinoTable error while attempting to update the IMPORT_MD_DETAIL table: " & ex.Message
         lReturn = False
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
         For Each lDR In mDSCasinoSetupData.Tables("COINS_BET_TO_GAME_TYPE").Rows
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

      If mDSCasinoSetupData.Tables.Contains("DEAL_SETUP") Then
         Try
            ' Create a new SqlDataAccess instance.
            lSDA = New SqlDataAccess(gConnectRetail, True, 60)


            For Each lDT As DataTable In mDSCasinoSetupData.Tables
               Debug.WriteLine("TableName: " & lDT.TableName)
            Next

            ' Set a reference to each row in the GAME_SETUP table.
            For Each lDR In mDSCasinoSetupData.Tables("DEAL_SETUP").Rows
               lDealNbr = lDR.Item("DEAL_NO")
               With lSDA
                  ' Add the stored procedure parameters...
                  .AddParameter("@DealNo", SqlDbType.Int, lDealNbr)
                  .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("TYPE_ID"), 1)
                  .AddParameter("@DealDescr", SqlDbType.VarChar, lDR.Item("DEAL_DESCR"), 64)
                  .AddParameter("@NumbRolls", SqlDbType.Int, lDR.Item("NUMB_ROLLS"))
                  .AddParameter("@TabsPerRoll", SqlDbType.Int, lDR.Item("TABS_PER_ROLL"))
                  '.AddParameter("@ProgInd", SqlDbType.Bit, lDR.Item("PROG_IND"))
                  '.AddParameter("@ProgPct", SqlDbType.Decimal, lDR.Item("PROG_PCT"))
                  .AddParameter("@TabAmt", SqlDbType.SmallMoney, lDR.Item("TAB_AMT"))
                  .AddParameter("@CostPerTab", SqlDbType.SmallMoney, lDR.Item("COST_PER_TAB"))
                  '.AddParameter("@ProgVal", SqlDbType.Money, lDR.Item("PROG_VAL"))
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
         For Each lDR In mDSCasinoSetupData.Tables("DENOM_TO_GAME_TYPE").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("GAME_CATEGORY").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("GAME_SETUP").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("GAME_TYPE").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("CB_GameType").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("LINES_BET_TO_GAME_TYPE").Rows
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

   Private Function UpdateMachineTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Updates the Machine table.
      ' Called only if mImportFlags.BankMachineTables = True.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDetailText As String = "MACH_SETUP Import successful."
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

         ' Set a reference to each row in the MACH_SETUP table.
         For Each lDR In mDSCasinoSetupData.Tables("MACH_SETUP").Rows
            With lSDA
               ' Add the stored procedure parameters...
               .AddParameter("@MachNo", SqlDbType.Char, lDR.Item("MACH_NO"), 5)
               .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("TYPE_ID"), 1)
               .AddParameter("@ModelDesc", SqlDbType.VarChar, lDR.Item("MODEL_DESC"), 64)
               .AddParameter("@BankNo", SqlDbType.Int, lDR.Item("BANK_NO"))
               .AddParameter("@GameCode", SqlDbType.VarChar, lDR.Item("GAME_CODE"), 3)
               .AddParameter("@RemovedFlag", SqlDbType.Bit, lDR.Item("REMOVED_FLAG"))
               .AddParameter("@IPAddress", SqlDbType.VarChar, lDR.Item("IP_ADDRESS"), 24)
               .AddParameter("@UpdateFlag", SqlDbType.Bit, mImportFlags.MachineUpdate)

               ' Execute the procedure.
               .ExecuteProcedureNoResult("diInsertMachSetup")

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
                  lErrorText = String.Format("diInsertMachSetup failed, returned {0}.", lSpReturnCode)
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
         lDetailText = "Error importing MACH_SETUP data."
         lErrorText = Me.Name & "::UpdateMachineTable: " & lErrorText
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Insert a row into the IMPORT_MD_DETAIL table.
      lSQL = String.Format(mImportDealSQLBase, mImportMDHistoryID, "MACH_SETUP", lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
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
         For Each lDR In mDSCasinoSetupData.Tables("CB_PatternResult").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("CB_Payscale").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE").Rows
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

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectBingo, True, 60)

         ' Set a reference to each row in the CB_BingoMaster table.
         For Each lDR In mDSCasinoSetupData.Tables("CB_PayscaleTier").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE_TIER_KENO").Rows
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

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the PAYSCALE_TIER table.
         For Each lDR In mDSCasinoSetupData.Tables("PAYSCALE_TIER").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("PRODUCT_LINE").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("PRODUCT").Rows
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
         lDT = mDSCasinoSetupData.Tables("PROG_AWARD_FACTOR")

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
         lDT = mDSCasinoSetupData.Tables("PROGRESSIVE_POOL")

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
         For Each lDR In mDSCasinoSetupData.Tables("PROGRESSIVE_TYPE").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("CB_ResultPointer").Rows
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
         For Each lDR In mDSCasinoSetupData.Tables("CB_TierWinType").Rows
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

      Dim lReturn As Boolean = True

      Dim lErrorCount As Integer = 0
      Dim lIgnoredCount As Integer = 0
      Dim lInsertCount As Integer = 0
      Dim lSpReturnCode As Integer
      Dim lUpdateCount As Integer = 0

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, True, 60)

         ' Set a reference to each row in the WINNING_TIERS table.
         For Each lDR In mDSCasinoSetupData.Tables("WINNING_TIERS").Rows
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

      ' Set the function return value.
      Return lReturn

   End Function

End Class